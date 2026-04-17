# ADR-046: Dual Umbrella Packages — fidgetflo + fidgetflo

**Status:** Accepted
**Date:** 2026-02-07
**Updated:** 2026-02-08
**Authors:** RuvNet, FidgetFlo Team

## Context

The umbrella package is published to npm as `fidgetflo`. As the ecosystem grows and the product establishes its own identity, a second umbrella package `fidgetflo` is introduced alongside the original.

### Current State

| Aspect | Current Value |
|--------|---------------|
| npm package | `fidgetflo` |
| CLI binary | `fidgetflo` |
| GitHub repo | ruvnet/claude-flow |
| Internal packages | @claude-flow/* |
| Weekly downloads | ~1,000+ |

### Drivers for Change

1. **Brand Cohesion**: Aligns with the ruv ecosystem (ruv.io, @ruvector/*, ruv-swarm)
2. **Trademark Safety**: Removes potential trademark concerns with "Claude" in product name
3. **Product Identity**: Establishes independent product identity beyond Claude integration
4. **Discoverability**: "fidgetflo" is unique, memorable, and searchable
5. **Future Flexibility**: Enables the platform to support multiple AI backends without name confusion
6. **Zero Disruption**: Keeping `fidgetflo` ensures no existing users are broken

## Decision

Publish **two independent npm umbrella packages** — `fidgetflo` (original) and `fidgetflo` (new) — both backed by `@claude-flow/cli`.

### Package Architecture

```
npm registry
├── fidgetflo          ← original umbrella (bundles @claude-flow/cli)
│   └── bin: fidgetflo → v3/@claude-flow/cli/bin/cli.js
├── fidgetflo              ← new umbrella (depends on @claude-flow/cli)
│   └── bin: fidgetflo     → @claude-flow/cli/bin/cli.js
└── @claude-flow/cli     ← shared CLI implementation
```

### What Changes

| Aspect | Before | After |
|--------|--------|-------|
| npm packages | `fidgetflo` only | `fidgetflo` + `fidgetflo` |
| CLI binaries | `fidgetflo` | `fidgetflo` + `fidgetflo` |
| Install commands | `npx fidgetflo@latest` | Both `npx fidgetflo@latest` and `npx fidgetflo@latest` |
| README branding | "FidgetFlo" | "FidgetFlo" (primary), "fidgetflo" (supported) |
| Product name | FidgetFlo | FidgetFlo (with fidgetflo alias) |

### What Stays the Same

| Aspect | Value | Reason |
|--------|-------|--------|
| GitHub repo | ruvnet/claude-flow | SEO, existing links, history |
| Internal packages | @claude-flow/* | Minimal disruption, existing integrations |
| Functionality | All features | No functional changes |
| License | MIT | No change |
| Author | RuvNet | No change |
| `fidgetflo` npm package | Fully supported | No breaking changes for existing users |

## Consequences

### Positive

1. **Zero Disruption**: Existing `fidgetflo` users unaffected
2. **Unified Brand**: New `fidgetflo` package for the ruv ecosystem
3. **Trademark Safety**: Users can choose the non-"Claude" branded package
4. **Dual Discovery**: Package discoverable under both names on npm
5. **Future Proof**: Can add non-Claude integrations without name confusion

### Negative

1. **Two packages to maintain**: Must publish and tag both packages
2. **Documentation**: Must reference both package names
3. **Download split**: npm download stats split across two packages

### Neutral

1. **GitHub repo unchanged**: Existing links continue to work
2. **Internal packages unchanged**: No code changes required in @claude-flow/*

## Implementation

### Package Structure

```
/workspaces/fidgetflo/
├── package.json            # name: "fidgetflo" (original umbrella)
│                           # bin: fidgetflo → v3/@claude-flow/cli/bin/cli.js
│                           # bundles CLI files directly
└── fidgetflo/
    ├── package.json        # name: "fidgetflo" (new umbrella)
    │                       # bin: fidgetflo → ./bin/fidgetflo.js
    │                       # depends on @claude-flow/cli
    ├── bin/
    │   └── fidgetflo.js      # thin wrapper, imports @claude-flow/cli
    └── README.md           # FidgetFlo-branded docs
```

### Phase 1: Preparation (This PR)

1. Create ADR-046 (this document)
2. Keep root `package.json` as `fidgetflo` (original umbrella)
3. Create `fidgetflo/` directory with new umbrella package
4. Update main README.md with FidgetFlo branding
5. Update install scripts to reference `fidgetflo`

### Phase 2: Publishing

```bash
# 1. Publish @claude-flow/cli (shared implementation)
cd v3/@claude-flow/cli
npm publish --tag alpha

# 2. Publish fidgetflo umbrella (original)
cd /workspaces/fidgetflo
npm publish --tag v3alpha
npm dist-tag add fidgetflo@<version> latest
npm dist-tag add fidgetflo@<version> alpha

# 3. Publish fidgetflo umbrella (new)
cd /workspaces/fidgetflo/fidgetflo
npm publish --tag alpha
npm dist-tag add fidgetflo@<version> latest
```

### Phase 3: Ongoing

1. Both packages maintained indefinitely
2. Version numbers kept in sync
3. README shows both install options
4. `fidgetflo` promoted as primary in new documentation

## Publishing Checklist

When publishing updates, **all three packages** must be published:

| Order | Package | Command | Tags |
|-------|---------|---------|------|
| 1 | `@claude-flow/cli` | `npm publish --tag alpha` | alpha, latest |
| 2 | `fidgetflo` | `npm publish --tag v3alpha` | v3alpha, alpha, latest |
| 3 | `fidgetflo` | `npm publish --tag alpha` | alpha, latest |

## Alternatives Considered

### 1. Replace fidgetflo with fidgetflo (single package)

**Pros:** Simpler, one package to maintain
**Cons:** Breaks existing users, loses download history
**Decision:** Rejected - zero disruption preferred

### 2. Rename to ruv-flow (hyphenated)

**Pros:** Matches ruv-swarm pattern
**Cons:** Inconsistent with @ruvector (no hyphen)
**Decision:** Rejected - "fidgetflo" is cleaner and matches ruvector pattern

### 3. Rename internal packages too (@fidgetflo/*)

**Pros:** Complete rebrand
**Cons:** Major breaking change, complex migration, npm scope registration
**Decision:** Rejected - disruption not worth the benefit

### 4. Deprecate fidgetflo

**Pros:** Forces migration to fidgetflo
**Cons:** Breaks existing users, bad developer experience
**Decision:** Rejected - both packages coexist permanently

## Migration Guide

### For New Users

```bash
# Recommended
npx fidgetflo@latest init --wizard

# Also works
npx fidgetflo@latest init --wizard
```

### For Existing Users

No migration required. `fidgetflo` continues to work. Optionally switch:

```bash
# Switch MCP server (optional)
claude mcp remove fidgetflo
claude mcp add fidgetflo npx fidgetflo@latest mcp start
```

### For Contributors

1. Root `package.json` is the `fidgetflo` umbrella
2. `fidgetflo/package.json` is the `fidgetflo` umbrella
3. Internal imports remain `@claude-flow/*`
4. GitHub repo remains `ruvnet/claude-flow`

## Metrics for Success

| Metric | Target | Measurement |
|--------|--------|-------------|
| Combined npm downloads | Maintain or grow | npm weekly stats (both packages) |
| GitHub stars | Maintain or grow | GitHub metrics |
| Issues from confusion | < 10 in 30 days | GitHub issues |
| fidgetflo adoption | 50%+ new installs in 90 days | npm stats |

## References

- GitHub Issue: #1101
- npm: https://npmjs.com/package/fidgetflo
- npm: https://npmjs.com/package/fidgetflo
- Related: ADR-017 (RuVector Integration)

## Appendix: Branding Guidelines

### Product Names

| Context | Use |
|---------|-----|
| npm packages | `fidgetflo` and `fidgetflo` (both lowercase) |
| README title | "FidgetFlo" (PascalCase) |
| CLI binaries | `fidgetflo` or `fidgetflo` (both lowercase) |
| In prose | "FidgetFlo" (PascalCase) |

### Command Examples

```bash
# New recommended style
npx fidgetflo@latest init
npx fidgetflo@latest agent spawn -t coder
npx fidgetflo@latest swarm init --topology hierarchical

# Legacy style (still fully supported)
npx fidgetflo@latest init
npx fidgetflo@latest agent spawn -t coder
```

---

**Decision Date:** 2026-02-07
**Updated:** 2026-02-08
**Review Date:** 2026-03-07 (30 days post-implementation)
