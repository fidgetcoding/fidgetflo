# FidgetFlo

Enterprise AI agent orchestration platform. Deploy 60+ specialized agents in coordinated swarms with self-learning, fault-tolerant consensus, vector memory, and MCP integration.

**FidgetFlo** is the new name for [fidgetflo](https://www.npmjs.com/package/fidgetflo). Both packages are fully supported.

## Install

```bash
# Quick start
npx fidgetflo@latest init --wizard

# Global install
npm install -g fidgetflo

# Add as MCP server
claude mcp add fidgetflo -- npx -y fidgetflo@latest mcp start
```

## Usage

```bash
fidgetflo init --wizard          # Initialize project
fidgetflo agent spawn -t coder   # Spawn an agent
fidgetflo swarm init             # Start a swarm
fidgetflo memory search -q "..."  # Search vector memory
fidgetflo doctor                 # System diagnostics
```

## Relationship to fidgetflo

| Package | npm | CLI Command |
|---------|-----|-------------|
| `fidgetflo` | [npmjs.com/package/fidgetflo](https://www.npmjs.com/package/fidgetflo) | `fidgetflo` |
| `fidgetflo` | [npmjs.com/package/fidgetflo](https://www.npmjs.com/package/fidgetflo) | `fidgetflo` |

Both packages use `@claude-flow/cli` under the hood. Choose whichever you prefer.

## Documentation

Full documentation: [github.com/ruvnet/claude-flow](https://github.com/ruvnet/claude-flow)

## License

MIT
