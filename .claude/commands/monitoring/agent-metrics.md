# agent-metrics

View agent performance metrics.

## Usage
```bash
npx fidgetflo agent metrics [options]
```

## Options
- `--agent-id <id>` - Specific agent
- `--period <time>` - Time period
- `--format <type>` - Output format

## Examples
```bash
# All agents metrics
npx fidgetflo agent metrics

# Specific agent
npx fidgetflo agent metrics --agent-id agent-001

# Last hour
npx fidgetflo agent metrics --period 1h
```
