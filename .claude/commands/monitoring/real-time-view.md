# real-time-view

Real-time view of swarm activity.

## Usage
```bash
npx fidgetflo monitoring real-time-view [options]
```

## Options
- `--filter <type>` - Filter view
- `--highlight <pattern>` - Highlight pattern
- `--tail <n>` - Show last N events

## Examples
```bash
# Start real-time view
npx fidgetflo monitoring real-time-view

# Filter errors
npx fidgetflo monitoring real-time-view --filter errors

# Highlight pattern
npx fidgetflo monitoring real-time-view --highlight "API"
```
