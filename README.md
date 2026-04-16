# FidgetFlo

**FidgetFlo** is a FIDGETCODING-branded personal fork of **[Ruflo by @ruvnet](https://github.com/ruvnet/ruflo)**, with a custom slash-command skill layer and an opinionated effort-tier thinking system layered on top.

> Everything under the hood — the MCP servers, the 15-agent swarm engine, the raft-consensus hive-mind, AgentDB memory with HNSW search, the 60+ agent types — is **ruv's work**, preserved intact under its original MIT license. FidgetFlo adds a rebranded wrapper, a 10-command `/f*` skill family, and some defaults I prefer. That's it.

If you want the real thing, use Ruflo: **https://github.com/ruvnet/ruflo**. If you like my opinionated defaults, use this.

---

## Built on Ruflo

All of the actual engineering that makes this useful is Ruflo. Specifically:

- **MCP server** (`mcp__ruflo__*`, 200+ tools) — agent lifecycle, swarm coordination, memory, hooks, neural patterns, AgentDB, performance benchmarks, GitHub automation, WASM agents.
- **Swarm engine** — hierarchical, mesh, adaptive coordinators. 15-agent full swarm, 5-agent mini swarm, specialized strategy, raft consensus.
- **Hive-mind** — queen-led autonomous execution with Byzantine fault-tolerant consensus (`/fhive` here, `/rhive` upstream).
- **Memory subsystem** — AgentDB with HNSW indexing (150x–12,500x search improvement), ReasoningBank adaptive learning, session persistence, hybrid store.
- **Hooks system** — 17 hook types, 12 workers, pre/post/session lifecycle, intelligence learning, trajectory tracking.
- **Neural + WASM layer** — Flash Attention (2.49x–7.47x speedup), EWC++ consolidation, SONA adaptation, Agent Booster WASM for <1ms transforms.
- **Model routing** — 3-tier ADR-026 router (WASM → Haiku → Sonnet/Opus) with complexity scoring.
- **Doctor / daemon / init** — the operational surface.

All of that is **ruvnet/ruflo**. Thank you to ruv for keeping it MIT so forks like this are legal and honest.

**Upstream:** https://github.com/ruvnet/ruflo
**Author:** https://ruv.io

See [`CREDITS.md`](./CREDITS.md) and [`ATTRIBUTION.md`](./ATTRIBUTION.md) for the full attribution story.

---

## What's different from Ruflo

Nathan's layer on top of ruv's engine:

1. **The `/f*` skill family** — 10 slash commands that bind Ruflo's swarm/mini modes to Claude Code's extended-thinking tiers. See [The `/f*` skill family](#the-f-skill-family-effort-tier-system) below. These are 1:1 reimplementations of the existing `r*` skills (`/rswarm`, `/rmini`, etc.) with the `f` prefix and the FIDGETCODING status-line emojis.
2. **Opinionated defaults** — topology is hierarchical-mesh at 15 agents, raft consensus for hive-mind, hybrid memory. Nothing ruv doesn't already offer — just the combo I run daily.
3. **Branding only** — command names, status-line indicators, and docs. No changes to the MCP server, no forked tool semantics, no upstream divergence in logic. If Ruflo ships a fix tomorrow, FidgetFlo can rebase cleanly.

**Assumption flag:** this README assumes FidgetFlo stays a thin rebrand + skill layer. If the fork ever diverges in engine behavior, this section needs a "Divergences" sub-section with the honest list.

---

## Install

> **Status:** private repo during smoke test. Install paths below are the intended public paths — they will work once the repo goes public and `fidgetflo` is published to npm.

### Claude Code users (published path)

```bash
claude mcp add fidgetflo -- npx -y fidgetflo@latest
npx fidgetflo@latest daemon start
npx fidgetflo@latest doctor --fix
```

### From source (git clone path)

```bash
git clone https://github.com/lorecraft-io/fidgetflo.git
cd fidgetflo
npm install
npm link                               # exposes `fidgetflo` bin globally
claude mcp add fidgetflo -- fidgetflo mcp
fidgetflo daemon start
fidgetflo doctor --fix
```

### Quickstart

```bash
# Init a project
npx fidgetflo@latest init --wizard

# Spawn an agent
npx fidgetflo@latest agent spawn -t coder --name my-coder

# Start a swarm
npx fidgetflo@latest swarm init --topology hierarchical --max-agents 8

# Search memory
npx fidgetflo@latest memory search --query "authentication patterns"
```

Everything under `npx fidgetflo …` is the same CLI surface as `npx ruflo …`. If you already know Ruflo, you already know FidgetFlo.

---

## The `/f*` skill family (effort tier system)

Ten slash commands. Two columns (compact vs. full swarm), five thinking tiers.

| Tier | Mini (5 agents) | Swarm (15 agents) | Thinking trigger appended | Approx. budget |
|---|---|---|---|---|
| 0 | `/fmini` | `/fswarm` | *(none)* | 0 |
| 1 | `/fmini1` | `/fswarm1` | `Think.` | ~4k tokens |
| 2 | `/fmini2` | `/fswarm2` | `Think hard.` | ~10k tokens |
| 3 | `/fmini3` | `/fswarm3` | `Think harder.` | ~31k tokens |
| max | `/fminimax` | `/fswarmmax` | `Ultrathink.` | ~32k (max) |

Plus one more inherited from Ruflo:

- **`/fhive`** — queen-led autonomous hive-mind with raft consensus. Longer-running, self-decomposing. Use this when you want the system to break down a large objective and execute without per-step steering.

### Why these tiers exist

In Claude Code, **subagents inherit the parent session's model** (Opus stays Opus when a swarm spawns Task-tool agents) **but they do NOT inherit the parent session's extended-thinking setting.** The `/effort` slider at the top of the session does not tether down into spawned agents. So if you crank `/effort` to max and then spawn a 15-agent swarm, each of those 15 agents starts with thinking *off*.

The only way to get deep thinking inside a swarm is to **bake a trigger phrase into each agent's prompt**. That's what tiers 1–max do automatically: before the spawner fires Task tool calls, the skill prepends the matching trigger (`Think.`, `Think hard.`, `Think harder.`, `Ultrathink.`) to every agent's instruction block. Every agent then thinks at that tier in parallel.

Tier 0 (`/fmini`, `/fswarm`) is the "fast and cheap" path — no thinking overhead, good for mechanical tasks where reasoning would just burn tokens.

### Natural-language aliases

You don't have to remember the numbers. These phrases all route:

- "hard" / "deep" → tier 2 (`/fmini2` or `/fswarm2`)
- "harder" / "deeper" → tier 3 (`/fmini3` or `/fswarm3`)
- "max" / "mega" / "ultra" / "ultrathink" → max (`/fminimax` or `/fswarmmax`)
- "light" / "quick think" → tier 1

Examples that work as prompts:
- `run fmini hard on this TypeScript error` → resolves to `/fmini2`
- `spin up a swarm ultra on the auth refactor` → resolves to `/fswarmmax`
- `mini deep review of the migration script` → resolves to `/fmini2`

### Status-line indicators

While a swarm is active, the Claude Code status line shows a little signal:

- **🐝** — `/fswarm*` is running (15-agent full swarm)
- **🍯** — `/fmini*` is running (5-agent compact swarm)
- **👑** — `/fhive` is running (queen-led hive-mind)

### Concrete use cases

- **`/fminimax`** — architecture reasoning, hard debugging, cross-cutting refactors. Five agents, every one of them ultrathinking. Expensive but decisive.
- **`/fmini2`** — routine feature work where you want *some* reasoning but don't need 15 agents arguing. My daily default.
- **`/fswarm3`** — 15 agents all thinking hard. Overkill for normal tickets, right-sized for a gnarly system-design question with parallelizable subproblems.
- **`/fmini`** — one-shot transforms, scaffolding, rename-this-variable-across-the-repo. Tier 0, no thinking, fast and cheap.
- **`/fhive`** — "take this multi-day objective and go." Queen decomposes, workers execute, raft keeps state consistent. Check back later.

---

## Cues & commands quick reference

```text
─── swarms (15 agents) ───
/fswarm          tier 0, no thinking
/fswarm1         tier 1, Think.
/fswarm2         tier 2, Think hard.
/fswarm3         tier 3, Think harder.
/fswarmmax       max,   Ultrathink.

─── mini (5 agents) ───
/fmini           tier 0
/fmini1          tier 1
/fmini2          tier 2
/fmini3          tier 3
/fminimax        max

─── autonomous ───
/fhive           queen-led hive-mind, raft consensus

─── natural language (auto-routes) ───
"hard" / "deep"              → tier 2
"harder" / "deeper"          → tier 3
"max" / "mega" / "ultra"     → max

─── status-line ───
🐝  /fswarm* active
🍯  /fmini*  active
👑  /fhive   active
```

---

## Usage examples

```text
/fminimax refactor the authentication middleware to support refresh tokens,
  keeping the existing JWT contract and writing migration tests

/fmini2 fix this TypeScript error — the generic on useReducer is inferring
  `never` for the action type

/fswarm3 audit this repo for secrets committed to git history
  and draft a rotation plan that doesn't break CI

/fhive build the README, MIGRATION guide, and example workflow screenshots —
  queen orchestrates, workers execute
```

Natural-language versions of the same:

```text
run fmini hard on this TypeScript error
spin up a swarm ultra on the auth refactor
let a hive take the README
```

---

## License

```
MIT License

Copyright (c) 2024-2026 ruvnet (original Ruflo work)
Copyright (c) 2026 Nathan Davidovich / Lorecraft (FidgetFlo rebrand + skill additions)

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```

The dual copyright reflects reality: ruv wrote the engine, I wrote the wrapper. Both lines stay in every distributed copy.

---

## Links

- **Original Ruflo:** https://github.com/ruvnet/ruflo
- **ruv's website:** https://ruv.io
- **This repo:** https://github.com/lorecraft-io/fidgetflo
- **Upstream Ruflo docs:** https://github.com/ruvnet/ruflo#readme
- **Upstream Ruflo issues:** https://github.com/ruvnet/ruflo/issues (for engine bugs — file there, not here)
- **FidgetFlo issues:** https://github.com/lorecraft-io/fidgetflo/issues (for skill-layer bugs only)

---

> Credit to ruv is not a footer. It's load-bearing. Every release and every public surface should preserve the attribution block in the intro, the Built on Ruflo section, the License dual-copyright, and the Links list. If any of those go missing in a future edit, this fork stops being honest.
