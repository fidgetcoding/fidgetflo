# workflow-execute

Execute saved workflows.

## Usage
```bash
npx fidgetflo workflow execute [options]
```

## Options
- `--name <name>` - Workflow name
- `--params <json>` - Workflow parameters
- `--dry-run` - Preview execution

## Examples
```bash
# Execute workflow
npx fidgetflo workflow execute --name "deploy-api"

# With parameters
npx fidgetflo workflow execute --name "test-suite" --params '{"env": "staging"}'

# Dry run
npx fidgetflo workflow execute --name "deploy-api" --dry-run
```
