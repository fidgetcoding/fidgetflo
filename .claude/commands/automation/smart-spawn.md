# smart-spawn

Intelligently spawn agents based on workload analysis.

## Usage
```bash
npx fidgetflo automation smart-spawn [options]
```

## Options
- `--analyze` - Analyze before spawning
- `--threshold <n>` - Spawn threshold
- `--topology <type>` - Preferred topology

## Examples
```bash
# Smart spawn with analysis
npx fidgetflo automation smart-spawn --analyze

# Set spawn threshold
npx fidgetflo automation smart-spawn --threshold 5

# Force topology
npx fidgetflo automation smart-spawn --topology hierarchical
```
