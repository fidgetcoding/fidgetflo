---
name: fidgetflo-help
description: Show FidgetFlo commands and usage
---

# FidgetFlo Commands

## 🌊 FidgetFlo: Agent Orchestration Platform

FidgetFlo is the ultimate multi-terminal orchestration platform that revolutionizes how you work with Claude Code.

## Core Commands

### 🚀 System Management
- `./fidgetflo start` - Start orchestration system
- `./fidgetflo start --ui` - Start with interactive process management UI
- `./fidgetflo status` - Check system status
- `./fidgetflo monitor` - Real-time monitoring
- `./fidgetflo stop` - Stop orchestration

### 🤖 Agent Management
- `./fidgetflo agent spawn <type>` - Create new agent
- `./fidgetflo agent list` - List active agents
- `./fidgetflo agent info <id>` - Agent details
- `./fidgetflo agent terminate <id>` - Stop agent

### 📋 Task Management
- `./fidgetflo task create <type> "description"` - Create task
- `./fidgetflo task list` - List all tasks
- `./fidgetflo task status <id>` - Task status
- `./fidgetflo task cancel <id>` - Cancel task
- `./fidgetflo task workflow <file>` - Execute workflow

### 🧠 Memory Operations
- `./fidgetflo memory store "key" "value"` - Store data
- `./fidgetflo memory query "search"` - Search memory
- `./fidgetflo memory stats` - Memory statistics
- `./fidgetflo memory export <file>` - Export memory
- `./fidgetflo memory import <file>` - Import memory

### ⚡ SPARC Development
- `./fidgetflo sparc "task"` - Run SPARC orchestrator
- `./fidgetflo sparc modes` - List all 17+ SPARC modes
- `./fidgetflo sparc run <mode> "task"` - Run specific mode
- `./fidgetflo sparc tdd "feature"` - TDD workflow
- `./fidgetflo sparc info <mode>` - Mode details

### 🐝 Swarm Coordination
- `./fidgetflo swarm "task" --strategy <type>` - Start swarm
- `./fidgetflo swarm "task" --background` - Long-running swarm
- `./fidgetflo swarm "task" --monitor` - With monitoring
- `./fidgetflo swarm "task" --ui` - Interactive UI
- `./fidgetflo swarm "task" --distributed` - Distributed coordination

### 🌍 MCP Integration
- `./fidgetflo mcp status` - MCP server status
- `./fidgetflo mcp tools` - List available tools
- `./fidgetflo mcp config` - Show configuration
- `./fidgetflo mcp logs` - View MCP logs

### 🤖 Claude Integration
- `./fidgetflo claude spawn "task"` - Spawn Claude with enhanced guidance
- `./fidgetflo claude batch <file>` - Execute workflow configuration

## 🌟 Quick Examples

### Initialize with SPARC:
```bash
npx -y fidgetflo@latest init --sparc
```

### Start a development swarm:
```bash
./fidgetflo swarm "Build REST API" --strategy development --monitor --review
```

### Run TDD workflow:
```bash
./fidgetflo sparc tdd "user authentication"
```

### Store project context:
```bash
./fidgetflo memory store "project_requirements" "e-commerce platform specs" --namespace project
```

### Spawn specialized agents:
```bash
./fidgetflo agent spawn researcher --name "Senior Researcher" --priority 8
./fidgetflo agent spawn developer --name "Lead Developer" --priority 9
```

## 🎯 Best Practices
- Use `./fidgetflo` instead of `npx fidgetflo` after initialization
- Store important context in memory for cross-session persistence
- Use swarm mode for complex tasks requiring multiple agents
- Enable monitoring for real-time progress tracking
- Use background mode for tasks > 30 minutes

## 📚 Resources
- Documentation: https://github.com/fidgetcoding/fidgetflo/tree/main/v3/docs
- Examples: https://github.com/fidgetcoding/fidgetflo/tree/main/v2/examples
- Issues: https://github.com/fidgetcoding/fidgetflo/issues
