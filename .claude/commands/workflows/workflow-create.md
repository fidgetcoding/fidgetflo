# workflow-create

Create reusable workflow templates.

## Usage
```bash
npx fidgetflo workflow create [options]
```

## Options
- `--name <name>` - Workflow name
- `--from-history` - Create from history
- `--interactive` - Interactive creation

## Examples
```bash
# Create workflow
npx fidgetflo workflow create --name "deploy-api"

# From history
npx fidgetflo workflow create --name "test-suite" --from-history

# Interactive mode
npx fidgetflo workflow create --interactive
```
