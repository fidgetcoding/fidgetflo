# Credits & Attribution

FidgetFlo is a rebrand and extension of [Ruflo](https://github.com/ruvnet/ruflo) by [@ruvnet](https://github.com/ruvnet). This document exists to make that lineage unmissable. If you are reading this, please understand: **the engine that makes FidgetFlo work is not my engineering. It is ruv's.**

---

## Original Work — Ruflo by ruvnet

- **Project:** Ruflo
- **Author:** ruvnet
- **Repository:** https://github.com/ruvnet/ruflo
- **Author profile:** https://github.com/ruvnet
- **Website:** https://ruv.io
- **License:** MIT

### What ruv built

The entire substrate that FidgetFlo runs on was designed, engineered, and shipped by ruvnet. This includes, but is not limited to:

- The **MCP server** and its tool surface (agents, swarms, memory, hooks, tasks, sessions, hive-mind, neural, performance, GitHub, workflow, and everything else exposed over the Model Context Protocol).
- **Swarm orchestration** — hierarchical, mesh, and adaptive topologies; agent lifecycle; specialization; claim/handoff; coordination primitives.
- **Hive-mind consensus** — Byzantine fault-tolerant coordination, raft-based leader authority, broadcast and shared-memory primitives.
- The **memory subsystem** — AgentDB integration, HNSW indexing (150x–12,500x search speedups), hierarchical recall, pattern store/search, quantization.
- **RAG / embeddings** integration — neural embeddings, hyperbolic embeddings, semantic routing.
- **Claude Code and Codex integration** — the MCP transport layer, hook system, stream-chain pipelines, trajectory tracking.
- **ReasoningBank** adaptive learning, **EWC++** consolidation, **SONA** self-optimizing neural architecture, **Flash Attention** performance work.
- The **CLI** (`npx ruflo`), the daemon, the doctor, the init flows, the 60+ agent types, the 3-tier model routing.
- The self-learning hooks system, the 12 workers, the automation, the observability.

If it does real work, ruv wrote it.

---

## License

Ruflo is licensed under the MIT License. It is the MIT license — specifically the permission to "use, copy, modify, merge, publish, distribute, sublicense" — that makes FidgetFlo legally possible at all. Without ruv choosing a permissive license, this rebrand would not exist.

FidgetFlo is distributed under the same MIT license, with a second copyright line appended for the rebrand and skill additions. See [`LICENSE`](./LICENSE).

The combined copyright notice:

```
Copyright (c) 2024-2026 ruvnet (original Ruflo work — https://github.com/ruvnet/ruflo)
Copyright (c) 2026 Nate Davidovich / Lorecraft LLC (FidgetFlo rebrand + skill additions)
```

ruv's copyright is preserved exactly as it appears in the upstream Ruflo `LICENSE` file. Nate's copyright only covers the rebrand and the skill-layer additions listed below.

---

## FidgetFlo Modifications — by Nate Davidovich / Lorecraft LLC

FidgetFlo was created by cloning `ruvnet/ruflo` and pushing to a new remote at `github.com/lorecraft-io/fidgetflo`. The git history is re-initialized from the `v3.5.80` tag; ruv's authorship is preserved via the LICENSE file and this CREDITS document, not via `git log`.

On top of that cloned snapshot, the following additions have been made under Nate's authorship:

- **The f\* skill family** — a 10-command skill pack that wraps the underlying Ruflo engine with opinionated workflows.
- **Extended-thinking tier system** — `rswarm` / `rmini` tier variants adapted into the f\* prefix, exposing light / deep / ultrathink thinking budgets.
- **Rebrand only** — naming, packaging, and documentation updates that re-present Ruflo as FidgetFlo.
- **Ongoing modifications** — any future changes committed after the initial clone.

Initial import: ruvnet/ruflo@v3.5.80, 2026-04-16.

**The underlying MCP server, swarm engine, hive-mind, memory system, hooks, and neural components are not modified in the initial release.** They are ruv's code, shipped as-is.

---

## Unmodified From Ruflo

At the time of the initial clone, the following are unchanged from upstream `ruvnet/ruflo@v3.5.80`:

- The entire `src/` tree that implements the MCP server and engine.
- Agent definitions, topologies, and coordination logic.
- Memory, hooks, neural, and performance subsystems.
- The CLI command surface (`ruflo …` is renamed to `fidgetflo …` at the binary level; the behavior is ruv's).
- Tests, CI, and build infrastructure authored by ruv.

If any of that changes in later releases, it will be called out in `CHANGELOG.md` and the commit log.

---

## How to Tell the Difference

This matters for bug triage, for credit, and for not embarrassing anyone.

- **If you find a bug in the MCP server, swarm engine, hive-mind, memory, hooks, neural components, or CLI core** → that is almost certainly ruv's code. Please check the upstream [`ruvnet/ruflo` issue tracker](https://github.com/ruvnet/ruflo/issues) first. If it reproduces on vanilla Ruflo, file it upstream — that is where the fix belongs. I will happily relay or co-file.
- **If you find a bug in the f\* skill family, the tier system wrappers, or anything under the rebrand's `skills/` directory** → that is Nate's addition. File it on the [FidgetFlo issue tracker](https://github.com/lorecraft-io/fidgetflo/issues).
- **If you are not sure** → file it on FidgetFlo. I will triage and route upstream when appropriate.

Rule of thumb: the engine is ruv's. The skin and the skill shortcuts are mine.

---

## Thank You

To ruvnet: thank you. Thank you for the engineering, thank you for choosing MIT, thank you for publishing the work in the open. Ruflo is a serious piece of software — the kind of thing a lot of people would have kept private or locked behind a paid tier. The fact that it is free, open, and permissively licensed is why FidgetFlo can exist, why I can build on top of it, and why anyone else can too. That is a generous act and I do not want it to go unacknowledged.

If you ever want any of this renamed, removed, or reframed, say the word.

---

## Contact

- **FidgetFlo issues (rebrand + f\* skills):** https://github.com/lorecraft-io/fidgetflo/issues
- **FidgetFlo maintainer:** Nate Davidovich — nate@lorecraft.io — Lorecraft LLC
- **Ruflo issues (upstream engine):** https://github.com/ruvnet/ruflo/issues
- **Ruflo author:** ruvnet — https://github.com/ruvnet — https://ruv.io
