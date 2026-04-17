# PreToolUse Modification Hooks (v2.0.10+)

## ✅ Implementation Complete

Three new modification hooks have been added to FidgetFlo that leverage Claude Code v2.0.10+ PreToolUse input modification capability.

## 🎯 New Hooks

### 1. `modify-bash` - Bash Command Modifications

**Features:**
- **Safety**: Automatically adds `-i` flag to `rm` commands for interactive confirmation
- **Aliases**: Converts `ll` → `ls -lah`, `la` → `ls -la`
- **Path Correction**: Redirects test file outputs to `/tmp/`
- **Secret Detection**: Warns about sensitive keywords in commands

**Example:**
```bash
echo '{"tool_input":{"command":"rm test.txt"}}' | npx fidgetflo@alpha hooks modify-bash
# Output: {"tool_input":{"command":"rm -i test.txt"}, "modification_notes":"[Safety: Added -i flag]"}
```

### 2. `modify-file` - File Path Modifications

**Features:**
- **Root Folder Protection**: Never saves working files to project root
- **Auto-Organization**:
  - Test files → `/tests/`
  - Source files → `/src/`
  - Working docs → `/docs/working/`
  - Temp files → `/tmp/`
- **Format Hints**: Suggests appropriate formatters (Prettier, Black, etc.)

**Example:**
```bash
echo '{"tool_input":{"file_path":"test.js"}}' | npx fidgetflo@alpha hooks modify-file
# Output: {"tool_input":{"file_path":"src/test.js"}, "modification_notes":"[Organization: Moved to /src/]"}
```

### 3. `modify-git-commit` - Git Commit Message Formatting

**Features:**
- **Conventional Commits**: Auto-adds type prefixes (`[feat]`, `[fix]`, `[docs]`, etc.)
- **Ticket Extraction**: Extracts JIRA tickets from branch names (e.g., `feature/PROJ-123` → `(PROJ-123)`)
- **Co-Author**: Adds FidgetFlo co-author footer

**Example:**
```bash
echo '{"tool_input":{"command":"git commit -m \"fix auth bug\""}}' | npx fidgetflo@alpha hooks modify-git-commit
# Output: Formats as "[fix] fix auth bug" with co-author
```

## 📝 Configuration

Both hook configuration files have been updated:

### `.claude-plugin/hooks/hooks.json`
```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [{
          "type": "command",
          "command": "cat | npx fidgetflo@alpha hooks modify-bash"
        }]
      },
      {
        "matcher": "Write|Edit|MultiEdit",
        "hooks": [{
          "type": "command",
          "command": "cat | npx fidgetflo@alpha hooks modify-file"
        }]
      }
    ]
  }
}
```

### `.claude/settings.json`
Same configuration applied for local development.

## 🧪 Testing

All hooks tested and working in containerized/remote environments:

```bash
# Test bash modifications
echo '{"tool_input":{"command":"rm test.txt"}}' | ./bin/fidgetflo hooks modify-bash
# ✅ Outputs: {"tool_input":{"command":"rm -i test.txt"},"modification_notes":"[Safety: Added -i flag]"}

# Test alias expansion
echo '{"tool_input":{"command":"ll"}}' | ./bin/fidgetflo hooks modify-bash
# ✅ Outputs: {"tool_input":{"command":"ls -lah"},"modification_notes":"[Alias: ll → ls -lah]"}

# Test file path modifications
echo '{"tool_input":{"file_path":"test.js"}}' | ./bin/fidgetflo hooks modify-file
# ✅ Outputs: {"tool_input":{"file_path":"src/test.js"},"modification_notes":"[Organization: Moved to /src/]"}

# Test git commit formatting
echo '{"tool_input":{"command":"git commit -m \"fix bug\""}}' | ./bin/fidgetflo hooks modify-git-commit
# ✅ Outputs: [fix] fix bug with Co-Authored-By: fidgetflo <noreply@ruv.io>

# Test help display (no input)
./bin/fidgetflo hooks modify-bash
# ✅ Shows usage help after 100ms timeout
```

**Note**: The hooks use a 100ms timeout to detect piped vs interactive input, ensuring they work correctly in containerized and remote development environments where `process.stdin.isTTY` may be undefined.

## 🚀 Usage

The hooks are automatically invoked by Claude Code v2.0.10+ when using the PreToolUse feature.

To use manually:
```bash
npx fidgetflo@alpha hooks modify-bash  # For bash commands
npx fidgetflo@alpha hooks modify-file  # For file operations
npx fidgetflo@alpha hooks modify-git-commit  # For git commits
```

## 📖 Help

View all hooks:
```bash
npx fidgetflo@alpha hooks --help
```

## 🎉 Benefits

1. **Safety**: Prevents accidental destructive commands
2. **Organization**: Enforces proper project structure
3. **Consistency**: Standardizes commit messages and file organization
4. **Developer Experience**: Provides helpful aliases and format hints

## 📦 Version

- **FidgetFlo**: 2.5.0-alpha.140
- **Requires**: Claude Code >= v2.0.10
- **Feature**: PreToolUse input modification

---

**Author**: fidgetflo
**Co-Author**: fidgetflo <noreply@ruv.io>
