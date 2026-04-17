# Claude Token Tracking Guide

## Overview

FidgetFlo now includes **REAL** token tracking capabilities that capture actual Claude API usage, not simulated data. This guide shows how to enable and use token tracking with the Claude Code CLI.

## Quick Start

### Step 1: Enable Telemetry

First, enable telemetry for token tracking:

```bash
./fidgetflo analysis setup-telemetry
```

This will:
- Set `CLAUDE_CODE_ENABLE_TELEMETRY=1` environment variable
- Create `.env` file with telemetry settings
- Initialize token tracking directory (`.fidgetflo/metrics/`)

### Step 2: Run Claude with Token Tracking

Use the `--claude` flag with telemetry enabled:

```bash
# Option 1: Set environment variable inline
CLAUDE_CODE_ENABLE_TELEMETRY=1 ./fidgetflo swarm "your task" --claude

# Option 2: Export environment variable
export CLAUDE_CODE_ENABLE_TELEMETRY=1
./fidgetflo swarm "your task" --claude

# Option 3: Use wrapper directly
./fidgetflo analysis claude-monitor  # Start monitoring in one terminal
./fidgetflo swarm "your task" --claude  # Run Claude in another terminal
```

### Step 3: View Token Usage

After running Claude commands:

```bash
# View comprehensive token usage report
./fidgetflo analysis token-usage --breakdown --cost-analysis

# Get current session cost
./fidgetflo analysis claude-cost

# Monitor session in real-time
./fidgetflo analysis claude-monitor [session-id]
```

## Architecture

### How It Works

1. **Claude Telemetry Integration**: The system integrates with Claude's native OpenTelemetry support
2. **Process Wrapping**: When telemetry is enabled, Claude commands are wrapped to capture output
3. **Token Extraction**: Token usage is extracted from:
   - Claude CLI output patterns
   - Session JSONL files (if accessible)
   - `/cost` command output
4. **Persistent Storage**: Token data is stored in `.fidgetflo/metrics/token-usage.json`

### Key Components

- **`claude-telemetry.js`**: Core telemetry wrapper module
- **`token-tracker.js`**: Token tracking and cost calculation
- **`analysis.js`**: Analysis commands and reporting

## Features

### Real-Time Monitoring

Monitor Claude sessions as they run:

```bash
# Monitor with default 5-second interval
./fidgetflo analysis claude-monitor

# Monitor with custom interval (3 seconds)
./fidgetflo analysis claude-monitor current --interval 3000
```

### Cost Analysis

Track costs based on Claude 3 pricing:

| Model  | Input (per 1M tokens) | Output (per 1M tokens) |
|--------|----------------------|------------------------|
| Opus   | $15.00              | $75.00                 |
| Sonnet | $3.00               | $15.00                 |
| Haiku  | $0.25               | $1.25                  |

### Token Breakdown

View token usage by:
- Agent type
- Command
- Session
- Time period

```bash
# Detailed breakdown
./fidgetflo analysis token-usage --breakdown

# Agent-specific analysis
./fidgetflo analysis token-usage --agent coordinator --cost-analysis
```

## Advanced Usage

### Programmatic Token Tracking

You can also use the telemetry wrapper programmatically:

```javascript
import { runClaudeWithTelemetry } from './claude-telemetry.js';

const result = await runClaudeWithTelemetry(
  ['chat', 'Hello, Claude!'],
  {
    sessionId: 'my-session-123',
    agentType: 'custom-agent'
  }
);
```

### Session Monitoring

Monitor specific sessions:

```javascript
import { monitorClaudeSession } from './claude-telemetry.js';

const stopMonitor = await monitorClaudeSession('session-id', 5000);

// Stop monitoring when done
stopMonitor();
```

## Troubleshooting

### No Token Data Showing

1. Verify telemetry is enabled:
   ```bash
   echo $CLAUDE_CODE_ENABLE_TELEMETRY  # Should output: 1
   ```

2. Check token usage file exists:
   ```bash
   cat .fidgetflo/metrics/token-usage.json
   ```

3. Ensure Claude is installed:
   ```bash
   which claude  # Should show Claude path
   ```

### Token Tracking Not Working

1. Clear existing metrics:
   ```bash
   rm -rf .fidgetflo/metrics/token-usage.json
   ```

2. Re-enable telemetry:
   ```bash
   ./fidgetflo analysis setup-telemetry
   ```

3. Run with explicit telemetry:
   ```bash
   CLAUDE_CODE_ENABLE_TELEMETRY=1 ./fidgetflo swarm "test" --claude
   ```

## Integration with CI/CD

For automated environments:

```yaml
# GitHub Actions example
env:
  CLAUDE_CODE_ENABLE_TELEMETRY: '1'
  
steps:
  - name: Setup telemetry
    run: ./fidgetflo analysis setup-telemetry
    
  - name: Run Claude task
    run: ./fidgetflo swarm "${{ inputs.task }}" --claude
    
  - name: Report costs
    run: ./fidgetflo analysis claude-cost
```

## Privacy & Security

- **No sensitive data**: Only token counts and costs are tracked
- **Local storage**: All data is stored locally in `.fidgetflo/metrics/`
- **Opt-in**: Telemetry must be explicitly enabled
- **No external transmission**: Data is never sent to external servers

## Best Practices

1. **Enable telemetry once**: Set it in your `.env` file for persistence
2. **Monitor long tasks**: Use `claude-monitor` for tasks > 5 minutes
3. **Regular cost checks**: Run `claude-cost` after expensive operations
4. **Batch operations**: Group Claude calls to optimize token usage
5. **Use appropriate models**: Choose Haiku for simple tasks, Opus for complex

## API Reference

### Commands

| Command | Description |
|---------|-------------|
| `analysis setup-telemetry` | Configure token tracking |
| `analysis token-usage` | View token usage report |
| `analysis claude-monitor` | Monitor session in real-time |
| `analysis claude-cost` | Get current session cost |

### Environment Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `CLAUDE_CODE_ENABLE_TELEMETRY` | Enable token tracking | `0` |
| `OTEL_METRICS_EXPORTER` | OpenTelemetry exporter | `console` |
| `OTEL_LOGS_EXPORTER` | Log exporter type | `console` |

### Files

| File | Purpose |
|------|---------|
| `.fidgetflo/metrics/token-usage.json` | Token usage data |
| `.fidgetflo/metrics/sessions/*.json` | Session metrics |
| `.env` | Environment configuration |

## Examples

### Complete Workflow

```bash
# 1. Setup
./fidgetflo analysis setup-telemetry

# 2. Run task with tracking
export CLAUDE_CODE_ENABLE_TELEMETRY=1
./fidgetflo swarm "Create a REST API with authentication" --claude

# 3. Check usage
./fidgetflo analysis token-usage --breakdown --cost-analysis

# 4. Monitor next session
./fidgetflo analysis claude-monitor &  # Run in background
./fidgetflo swarm "Add tests to the API" --claude

# 5. Final cost report
./fidgetflo analysis claude-cost
```

### Optimization Example

```bash
# Analyze token usage patterns
./fidgetflo analysis token-usage --breakdown

# Identify high-consumption agents
./fidgetflo analysis token-usage --agent coordinator

# Get optimization suggestions
./fidgetflo analysis bottleneck-detect --scope agent
```

## Support

For issues or questions:
- GitHub Issues: https://github.com/ruvnet/claude-flow/issues
- Documentation: https://github.com/ruvnet/claude-flow/docs

## Conclusion

Real token tracking in FidgetFlo provides transparency into API usage and costs. By following this guide, you can:
- Track actual Claude API token consumption
- Monitor costs in real-time
- Optimize token usage patterns
- Make informed decisions about model selection

Remember: This tracks **REAL** usage, not simulated data!