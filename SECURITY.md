# Security Policy

## Supported Versions

| Version | Supported |
|---------|-----------|
| 0.1.x   | Yes       |

FidgetFlo is a rebrand + skill-layer fork of [ruvnet/ruflo](https://github.com/ruvnet/ruflo) (see [CREDITS.md](./CREDITS.md) + [ATTRIBUTION.md](./ATTRIBUTION.md)). Most of the engine code this project ships is ruv's. Please read the triage routing below before filing.

## Reporting a Vulnerability

**Do not open a public GitHub issue for security vulnerabilities.**

- For a bug in **the FidgetFlo rebrand layer, the `/f*` skill family, or the tier-system wrappers** — email **nate@lorecraft.io**.
- For a bug in **the underlying Ruflo engine** (MCP server, swarm engine, hive-mind, memory, hooks, neural components, CLI core) — file upstream at [ruvnet/ruflo security advisories](https://github.com/ruvnet/ruflo/security/advisories) or email **security@ruv.io**. That is where the fix belongs.
- If you are not sure which layer the bug lives in — email **nate@lorecraft.io**. I will triage and route upstream as needed.

Include in your report:

- A clear description of the vulnerability
- Steps to reproduce
- Affected version(s) and components (rebrand layer vs. Ruflo engine)
- Impact assessment (severity, exploitation potential)
- Any suggested fixes or mitigations, if available

## Response Timeline

- **48 hours** — Initial acknowledgment
- **7 days** — Preliminary assessment and severity classification
- **30 days** — Target for a fix or mitigation

## Safe Harbor

Security research conducted in good faith is authorized. No legal action will be pursued against researchers who:

- Make a good-faith effort to avoid privacy violations, data destruction, and service disruption
- Report vulnerabilities promptly and provide sufficient detail for reproduction
- Do not publicly disclose the vulnerability before a fix is available
- Do not exploit the vulnerability beyond what is necessary to demonstrate the issue

## Credit

Researchers will be publicly credited (with their permission) in release notes when a reported vulnerability is fixed.

## Security Practices

The underlying Ruflo engine employs the following security measures at system boundaries (all ruv's work, preserved unchanged):

- **Input validation** using Zod schemas for all public API inputs
- **Parameterized SQL queries** to prevent injection attacks
- **Path traversal prevention** via the `PathValidator` module
- **Command injection protection** via the `SafeExecutor` module

## Questions

- FidgetFlo rebrand layer: **nate@lorecraft.io**
- Ruflo engine: **security@ruv.io**
