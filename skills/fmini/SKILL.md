---
name: fmini
description: "Launch a compact 5-agent FidgetFlo swarm for focused task execution. Smaller than /fswarm but still parallel and powerful."
---

# FidgetFlo Mini Swarm — Compact Execution

When this skill is invoked, IMMEDIATELY launch a 5-agent swarm. Do NOT explain how swarms work. Do NOT show code examples. Do NOT ask clarifying questions unless the task is truly ambiguous. ACT.

## Execution Steps

1. Read the user's task (everything they typed after `/fmini`)
2. **Signal status line**: Run `echo 5 > /tmp/fidgetflo-mini-active` via Bash to light up the 🍯 indicator
3. Initialize the swarm in ONE message:
   - Call `mcp__fidgetflo__swarm_init` with topology `hierarchical-mesh`, maxAgents 5, strategy `specialized`
   - Spawn ALL 5 agents via the Agent tool with `run_in_background: true` — every agent in ONE message
4. After spawning, STOP. Do not poll. Do not check status. Wait for agents to return.
5. When results come back, synthesize and present the combined output.
6. **Clear status line**: Run `rm -f /tmp/fidgetflo-mini-active` via Bash to turn off the 🍯 indicator

## The 5 Agents

| # | Agent Type | Role | Task Focus |
|---|-----------|------|------------|
| 1 | system-architect | Lead Architect | System design, task decomposition, coordinates all agents |
| 2 | coder | Primary Dev | Core implementation — frontend or backend depending on task |
| 3 | tester | Test Engineer | Unit, integration, and edge case tests |
| 4 | reviewer | Code Reviewer | Quality, patterns, best practices, security check |
| 5 | researcher | Researcher | Background research, prior art, docs lookup |

Adapt agent assignments to the task — if the task is research-heavy, shift roles accordingly. But ALWAYS spawn 5.

## Rules

- Model: Opus only. Never route to Haiku or Sonnet.
- Topology: hierarchical-mesh (architect leads, agents coordinate peer-to-peer within their layer)
- All agents spawned in background in ONE message
- Each agent gets a clear, specific sub-task with full context — not vague instructions
- After spawning, STOP and wait
- When results arrive, review ALL results before presenting final output
