# memory-search

Search through stored memory.

## Usage
```bash
npx fidgetflo memory search [options]
```

## Options
- `--query <text>` - Search query
- `--pattern <regex>` - Pattern matching
- `--limit <n>` - Result limit

## Examples
```bash
# Search memory
npx fidgetflo memory search --query "authentication"

# Pattern search
npx fidgetflo memory search --pattern "api-.*"

# Limited results
npx fidgetflo memory search --query "config" --limit 10
```
