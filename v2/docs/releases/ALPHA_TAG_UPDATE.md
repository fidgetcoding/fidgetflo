# Alpha Tag Update - fidgetflo@alpha

**Date**: 2025-10-22
**Action**: Updated npm dist-tag `alpha` to point to v2.7.1

## Current Dist-Tags

```json
{
  "alpha-v2": "2.0.0-alpha.2",
  "alpha": "2.7.1",
  "latest": "2.7.1"
}
```

## Changes Made

### Before
```
alpha: 2.7.0-alpha.14
latest: 2.7.1
```

### After
```
alpha: 2.7.1
latest: 2.7.1
```

## Installation Commands

Users can now install using any of these methods:

### Install Latest Stable (Recommended)
```bash
npm install -g fidgetflo
# or
npm install -g fidgetflo@latest
# Installs: v2.7.1
```

### Install Alpha (Same as Latest for v2.7.1)
```bash
npm install -g fidgetflo@alpha
# Installs: v2.7.1
```

### Install Specific Version
```bash
npm install -g fidgetflo@2.7.1
# Installs: v2.7.1
```

### Install Legacy Alpha
```bash
npm install -g fidgetflo@2.7.0-alpha.14
# Installs: v2.7.0-alpha.14 (previous alpha)
```

## Verification

### Check Installed Version
```bash
npm view fidgetflo@alpha version
# Output: 2.7.1
```

### Check All Dist-Tags
```bash
npm dist-tag ls fidgetflo
# Output:
# alpha-v2: 2.0.0-alpha.2
# alpha: 2.7.1
# latest: 2.7.1
```

### Verify Installation
```bash
npm install -g fidgetflo@alpha
fidgetflo --version
# Should show: v2.7.1
```

## Why This Update?

The `@alpha` tag is commonly used in the codebase and documentation:
- Used in examples: `npx fidgetflo@alpha`
- Used in MCP setup: `claude mcp add fidgetflo npx fidgetflo@alpha mcp start`
- Used by developers testing latest features

Since v2.7.1 is a stable release with critical bug fixes, we've updated the `@alpha` tag to point to this version so users get the latest stable code when using `@alpha`.

## Breaking Changes

**None** - This is purely a tag update:
- Existing installations are NOT affected
- Users must explicitly reinstall to get v2.7.1
- Old versions remain available (e.g., `fidgetflo@2.7.0-alpha.14`)

## Includes Critical Fixes

v2.7.1 includes these critical bug fixes:
- ✅ Pattern persistence (neural_train now saves data)
- ✅ Pattern search (neural_patterns handler implemented)
- ✅ Pattern statistics (complete tracking system)

## Recommended Action for Users

If you're using `fidgetflo@alpha`, update to get the critical fixes:

```bash
# Uninstall old version
npm uninstall -g fidgetflo

# Install latest alpha (v2.7.1)
npm install -g fidgetflo@alpha

# Verify
fidgetflo --version
# Should show: v2.7.1
```

## Registry Information

- **Package**: fidgetflo
- **Registry**: https://www.npmjs.com/package/fidgetflo
- **Latest Version**: 2.7.1
- **Alpha Tag**: 2.7.1 (updated 2025-10-22)
- **Visibility**: Public

## Tag Update Command

```bash
npm dist-tag add fidgetflo@2.7.1 alpha
# Output: +alpha: fidgetflo@2.7.1
```

## Verification Timestamp

```
Date: Wed Oct 22 2025
Registry Check: https://registry.npmjs.org/fidgetflo
Status: ✅ Confirmed - alpha tag points to 2.7.1
```

---

**Updated By**: npm dist-tag command
**Verified**: 2025-10-22
**Status**: ✅ Complete
