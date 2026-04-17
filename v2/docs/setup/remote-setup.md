# FidgetFlo Remote Setup Guide

## Problem
When using `npx fidgetflo@alpha` remotely, you may encounter:
- `ENOTEMPTY` npm cache errors
- Version mismatch issues  
- **Missing `./fidgetflo@alpha` wrapper after init** ⭐ **FIXED!**
- Hook functionality not working

## Quick Fix

### Method 1: One-line Installation
```bash
curl -fsSL https://raw.githubusercontent.com/ruvnet/claude-flow/main/install-remote.sh | bash
```

### Method 2: Manual Installation
```bash
# Clear npm cache and reinstall
npm cache clean --force
npm uninstall -g fidgetflo
npm install -g fidgetflo@alpha --no-optional --legacy-peer-deps

# Verify and initialize
fidgetflo --version
fidgetflo init
```

### Method 3: Local Development Setup
If you're working with the source code:

```bash
# From the claude-code-flow directory
npm pack
npm install -g ./fidgetflo-*.tgz
fidgetflo --version
```

## Verification

Test that everything works:
```bash
# Check version
fidgetflo --version

# Test hooks
fidgetflo hooks notify --message "Setup complete" --level "success"

# Check system status
fidgetflo status

# ⭐ NEW: Test wrapper creation
npx fidgetflo@alpha init --force
ls -la ./fidgetflo*
# Should show: ./fidgetflo@alpha (executable)
./fidgetflo@alpha --version
```

## Troubleshooting

### Cache Issues
```bash
npm cache clean --force
rm -rf ~/.npm/_npx
```

### Permission Issues
```bash
sudo npm install -g fidgetflo@alpha
# or use nvm to avoid sudo
```

### Binary Not Found
```bash
# Check global bin directory
npm config get prefix
# Add to PATH if needed
export PATH="$(npm config get prefix)/bin:$PATH"
```

## Remote Usage Tips

1. **Use stable alpha version**: `fidgetflo@alpha` instead of specific versions
2. **Clear cache first**: Always run `npm cache clean --force` before installation
3. **Use --legacy-peer-deps**: Helps resolve dependency conflicts
4. **Test hooks immediately**: Verify functionality after installation

## Success Indicators

✅ `fidgetflo --version` shows current version  
✅ `fidgetflo status` shows system running  
✅ `fidgetflo hooks notify` works without errors  
✅ All commands available globally