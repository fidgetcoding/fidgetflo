# memory-persist

Persist memory across sessions.

## Usage
```bash
npx fidgetflo memory persist [options]
```

## Options
- `--export <file>` - Export to file
- `--import <file>` - Import from file
- `--compress` - Compress memory data

## Examples
```bash
# Export memory
npx fidgetflo memory persist --export memory-backup.json

# Import memory
npx fidgetflo memory persist --import memory-backup.json

# Compressed export
npx fidgetflo memory persist --export memory.gz --compress
```
