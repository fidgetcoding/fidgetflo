# swarm-spawn

Spawn agents in the swarm.

## Usage
```bash
npx fidgetflo swarm spawn [options]
```

## Options
- `--type <type>` - Agent type
- `--count <n>` - Number to spawn
- `--capabilities <list>` - Agent capabilities

## Examples
```bash
npx fidgetflo swarm spawn --type coder --count 3
npx fidgetflo swarm spawn --type researcher --capabilities "web-search,analysis"
```
