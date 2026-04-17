# MCP Server Setup Guide for FidgetFlo

## 🎯 Overview

FidgetFlo integrates with Claude Code through MCP (Model Context Protocol) servers. This guide explains how to set up MCP servers correctly.

## 📋 Two Ways to Initialize

### 1. **Automatic Setup (Recommended)**

```bash
# This command automatically adds MCP servers
npx fidgetflo@alpha init --force
```

**What it does:**
- Creates project files (CLAUDE.md, settings.json, etc.)
- Automatically runs: `claude mcp add fidgetflo npx fidgetflo@alpha mcp start`
- Sets up ruv-swarm and flow-nexus MCP servers (optional)
- Configures hooks and permissions

### 2. **Manual Setup**

If you already have Claude Code installed but need to add MCP servers:

```bash
# Add FidgetFlo MCP server
claude mcp add fidgetflo npx fidgetflo@alpha mcp start

# Optional: Add enhanced coordination
claude mcp add ruv-swarm npx ruv-swarm mcp start

# Optional: Add cloud features
claude mcp add flow-nexus npx flow-nexus@latest mcp start
```

## ✅ Verify Setup

Check that MCP servers are running:

```bash
claude mcp list
```

Expected output:
```
fidgetflo: npx fidgetflo@alpha mcp start - ✓ Connected
ruv-swarm: npx ruv-swarm mcp start - ✓ Connected
flow-nexus: npx flow-nexus@latest mcp start - ✓ Connected
```

## 🔧 Troubleshooting

### Issue: MCP server shows local path instead of npx

**Example:**
```
fidgetflo: /workspaces/claude-code-flow/bin/fidgetflo mcp start - ✓ Connected
```

**Solution:**
This happens when you're working in the fidgetflo repository itself. It's actually fine for development! The MCP server will work correctly.

If you want to use the npx command instead:

```bash
# Remove the existing server
claude mcp remove fidgetflo

# Re-add with npx command
claude mcp add fidgetflo npx fidgetflo@alpha mcp start
```

### Issue: "claude: command not found"

**Solution:**
Install Claude Code first:

```bash
npm install -g @anthropic-ai/claude-code
```

### Issue: MCP server fails to connect

**Causes and Solutions:**

1. **Package not installed globally:**
   ```bash
   # Install the package
   npm install -g fidgetflo@alpha
   ```

2. **Using local development version:**
   ```bash
   # In the fidgetflo repo, build first
   npm run build
   ```

3. **Permission issues:**
   ```bash
   # Use --dangerously-skip-permissions for testing
   claude --dangerously-skip-permissions
   ```

## 📚 Understanding the Commands

### `npx fidgetflo@alpha init`
- Initializes FidgetFlo project files
- **Automatically calls** `claude mcp add` for you
- Only needs to be run once per project

### `claude init`
- Claude Code's own initialization
- Does **NOT** automatically add FidgetFlo MCP servers
- Separate from FidgetFlo initialization

### `claude mcp add <name> <command>`
- Adds an MCP server to Claude Code's global config
- Persists across projects
- Located in `~/.config/claude/`

## 🎯 Recommended Workflow

```bash
# 1. Install Claude Code (one-time)
npm install -g @anthropic-ai/claude-code

# 2. Initialize your project with FidgetFlo (per project)
cd your-project
npx fidgetflo@alpha init --force

# 3. Verify MCP servers are connected
claude mcp list

# 4. Start using Claude Code with MCP tools
claude
```

## 💡 Key Points

- **`npx fidgetflo@alpha init`** does BOTH file setup AND MCP configuration
- **`claude init`** is just for Claude Code, not FidgetFlo
- MCP servers are **global** (affect all Claude Code sessions)
- Project files (.claude/, CLAUDE.md) are **local** to each project

## 🔗 Related Documentation

- [Installation Guide](../setup/remote-setup.md)
- [Environment Setup](../setup/ENV-SETUP-GUIDE.md)
- [MCP Tools Reference](../reference/MCP_TOOLS.md)

---

**Questions?** See [GitHub Issues](https://github.com/ruvnet/claude-flow/issues) or join our [Discord](https://discord.com/invite/dfxmpwkG2D)
