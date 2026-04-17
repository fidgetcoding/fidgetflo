#!/usr/bin/env node

/**
 * FidgetFlo WebSocket Bridge Server - REAL MCP Integration
 * Connects browser dashboard to actual fidgetflo MCP tools
 */

import { WebSocketServer } from 'ws';
import http from 'http';
import path from 'path';
import fs from 'fs';
import { fileURLToPath } from 'url';
import { spawn } from 'child_process';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

class ClaudeFlowBridgeReal {
    constructor(port = 8080) {
        this.port = port;
        this.clients = new Set();
        this.mcpProcess = null;
        this.messageQueue = [];

        this.setupServer();
        this.startClaudeFlowMCP();
    }

    /**
     * Start FidgetFlo MCP Server Process
     */
    startClaudeFlowMCP() {
        console.log('🚀 Starting FidgetFlo MCP server...');

        // Start the actual fidgetflo MCP server
        this.mcpProcess = spawn('npx', ['fidgetflo@alpha', 'mcp', 'start'], {
            stdio: ['pipe', 'pipe', 'pipe'],
            cwd: path.join(__dirname, '../..')
        });

        this.mcpProcess.stdout.on('data', (data) => {
            const messages = data.toString().split('\n').filter(line => line.trim());
            messages.forEach(msg => {
                try {
                    const parsed = JSON.parse(msg);
                    this.handleMCPResponse(parsed);
                } catch (e) {
                    console.log('📨 MCP:', msg);
                }
            });
        });

        this.mcpProcess.stderr.on('data', (data) => {
            console.error('❌ MCP Error:', data.toString());
        });

        this.mcpProcess.on('close', (code) => {
            console.log(`⚠️  MCP process exited with code ${code}`);
        });

        // Wait for MCP to initialize
        setTimeout(() => {
            console.log('✅ FidgetFlo MCP ready');
            this.sendMCPCommand({
                jsonrpc: '2.0',
                method: 'initialize',
                params: {},
                id: 'init'
            });
        }, 2000);
    }

    /**
     * Send command to MCP server
     */
    sendMCPCommand(command) {
        if (this.mcpProcess && this.mcpProcess.stdin.writable) {
            this.mcpProcess.stdin.write(JSON.stringify(command) + '\n');
            console.log('→ MCP:', command.method);
        }
    }

    /**
     * Handle MCP server response
     */
    handleMCPResponse(response) {
        console.log('← MCP Response:', response.id);

        // Broadcast to all connected clients
        this.broadcast({
            type: 'mcp_response',
            data: response
        });

        // Handle specific responses
        if (response.result) {
            if (response.id && response.id.toString().startsWith('swarm_status')) {
                this.broadcastSwarmStatus(response.result);
            } else if (response.id && response.id.toString().startsWith('agent_spawn')) {
                this.broadcastAgentUpdate(response.result);
            }
        }
    }

    broadcastSwarmStatus(status) {
        this.broadcast({
            type: 'swarm_status',
            status
        });
    }

    broadcastAgentUpdate(agentData) {
        this.broadcast({
            type: 'agent_update',
            agent: agentData
        });
    }

    setupServer() {
        // HTTP server for serving static files
        this.httpServer = http.createServer((req, res) => {
            let filePath = '.' + req.url;
            if (filePath === './') filePath = './index.html';

            // Route for code editor
            if (req.url === '/code' || req.url === '/code/') {
                filePath = './index-code.html';
            }

            // Route for chat interface
            if (req.url === '/chat' || req.url === '/chat/') {
                filePath = './index-chat.html';
            }

            const extname = path.extname(filePath);
            const contentType = {
                '.html': 'text/html',
                '.js': 'text/javascript',
                '.css': 'text/css',
                '.json': 'application/json'
            }[extname] || 'text/plain';

            fs.readFile(filePath, (error, content) => {
                if (error) {
                    if (error.code === 'ENOENT') {
                        res.writeHead(404);
                        res.end('File not found');
                    } else {
                        res.writeHead(500);
                        res.end('Server error');
                    }
                } else {
                    res.writeHead(200, {
                        'Content-Type': contentType,
                        'Access-Control-Allow-Origin': '*'
                    });
                    res.end(content, 'utf-8');
                }
            });
        });

        // WebSocket server
        this.wss = new WebSocketServer({ server: this.httpServer });

        this.wss.on('connection', (ws) => {
            console.log('✅ New client connected');
            this.clients.add(ws);

            // Send initial state
            this.sendToClient(ws, {
                type: 'connection',
                status: 'connected',
                message: 'Connected to real FidgetFlo MCP server'
            });

            ws.on('message', (message) => {
                try {
                    const data = JSON.parse(message);
                    this.handleClientMessage(ws, data);
                } catch (error) {
                    console.error('❌ Error parsing message:', error);
                }
            });

            ws.on('close', () => {
                console.log('👋 Client disconnected');
                this.clients.delete(ws);
            });

            ws.on('error', (error) => {
                console.error('❌ WebSocket error:', error);
                this.clients.delete(ws);
            });
        });

        this.httpServer.listen(this.port, () => {
            console.log(`\n🌐 FidgetFlo Dashboard Server (REAL MCP)`);
            console.log(`━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━`);
            console.log(`📊 Dashboard: http://localhost:${this.port}`);
            console.log(`🔌 WebSocket: ws://localhost:${this.port}`);
            console.log(`🔥 Real MCP Integration Active`);
            console.log(`━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n`);
        });
    }

    handleClientMessage(ws, data) {
        const { method, params, id } = data;

        console.log(`📨 Client Request: ${method}`);

        // Handle code execution directly
        if (method === 'mcp__fidgetflo__execute_code') {
            this.handleCodeExecution(ws, params, id);
            return;
        }

        // Forward to real MCP server with proper format
        const mcpCommand = {
            jsonrpc: '2.0',
            method: method.replace('mcp__fidgetflo__', ''),
            params: params || {},
            id: id || Date.now()
        };

        // Store the client/request mapping
        this.messageQueue.push({ id: mcpCommand.id, ws, originalId: id });

        // Send to real MCP server
        this.sendMCPCommand(mcpCommand);
    }

    /**
     * Handle code execution in sandbox
     */
    handleCodeExecution(ws, params, id) {
        const { code, language = 'javascript', timeout = 5000 } = params;
        const startTime = Date.now();

        console.log('🚀 Executing code...');

        try {
            // Create a sandboxed execution context
            const sandbox = {
                console: {
                    log: (...args) => {
                        this.sendToClient(ws, {
                            type: 'execution_output',
                            output: args.join(' ') + '\n'
                        });
                    }
                },
                sendMCPCommand: (cmd, params) => {
                    return new Promise((resolve) => {
                        const cmdId = Date.now();
                        this.sendMCPCommand({
                            jsonrpc: '2.0',
                            method: cmd,
                            params,
                            id: cmdId
                        });

                        // Store callback for response
                        this.messageQueue.push({
                            id: cmdId,
                            ws,
                            callback: (result) => resolve(result)
                        });
                    });
                }
            };

            // Execute code with timeout
            const AsyncFunction = Object.getPrototypeOf(async function(){}).constructor;
            const fn = new AsyncFunction('console', 'sendMCPCommand', code);

            Promise.race([
                fn(sandbox.console, sandbox.sendMCPCommand),
                new Promise((_, reject) =>
                    setTimeout(() => reject(new Error('Execution timeout')), timeout)
                )
            ]).then(() => {
                this.sendToClient(ws, {
                    jsonrpc: '2.0',
                    result: {
                        type: 'execution_result',
                        result: {
                            success: true,
                            time: Date.now() - startTime
                        }
                    },
                    id
                });
            }).catch((error) => {
                this.sendToClient(ws, {
                    jsonrpc: '2.0',
                    result: {
                        type: 'execution_result',
                        result: {
                            success: false,
                            error: error.message,
                            time: Date.now() - startTime
                        }
                    },
                    id
                });
            });
        } catch (error) {
            this.sendToClient(ws, {
                jsonrpc: '2.0',
                error: {
                    code: -32603,
                    message: error.message
                },
                id
            });
        }
    }

    sendToClient(ws, data) {
        if (ws.readyState === 1) { // WebSocket.OPEN
            ws.send(JSON.stringify(data));
        }
    }

    broadcast(data) {
        this.clients.forEach(client => {
            this.sendToClient(client, data);
        });
    }

    shutdown() {
        console.log('\n👋 Shutting down...');

        if (this.mcpProcess) {
            this.mcpProcess.kill();
        }

        this.clients.forEach(client => {
            client.close();
        });

        this.httpServer.close();
        process.exit(0);
    }
}

// Start server
const server = new ClaudeFlowBridgeReal(process.env.PORT || 8080);

// Graceful shutdown
process.on('SIGINT', () => server.shutdown());
process.on('SIGTERM', () => server.shutdown());
