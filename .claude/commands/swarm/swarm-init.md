# swarm-init

Initialize a new swarm with specified topology.

## Usage
```bash
npx fidgetflo swarm init [options]
```

## Options
- `--topology <type>` - Swarm topology (mesh, hierarchical, ring, star)
- `--max-agents <n>` - Maximum agents
- `--strategy <type>` - Distribution strategy

## Examples
```bash
npx fidgetflo swarm init --topology mesh
npx fidgetflo swarm init --topology hierarchical --max-agents 8
```
