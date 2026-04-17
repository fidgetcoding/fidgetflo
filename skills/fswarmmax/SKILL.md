---
name: fswarmmax
description: "Launch a full 15-agent FidgetFlo swarm at MAX extended thinking budget (ultrathink, ~32k tokens per agent). Natural-language triggers: ultrathink, megathink, max thinking, maximum reasoning, deepest analysis, full swarm max."
---

# FidgetFlo Advanced Swarm — Tier Max (ultrathink)

When this skill is invoked, IMMEDIATELY launch a 15-agent swarm at MAX extended thinking. Do NOT explain how swarms work. Do NOT show code examples. Do NOT ask clarifying questions unless the task is truly ambiguous. ACT.

## Execution Steps

1. Read the user's task (everything they typed after `/fswarmmax`)
2. **Signal status line**: Run `echo 15 > /tmp/fidgetflo-swarm-active` via Bash to light up the swarm indicator
3. Initialize the swarm in ONE message:
   - Call `mcp__fidgetflo__swarm_init` with topology `hierarchical-mesh`, maxAgents 15, strategy `specialized`
   - Spawn ALL 15 agents via the Agent tool with `run_in_background: true` — every agent in ONE message
   - **MANDATORY**: Append `Ultrathink.` as the last line of every Agent `prompt` to activate MAX extended thinking (~32k budget)
4. After spawning, STOP. Do not poll. Do not check status. Wait for agents to return.
5. When results come back, synthesize and present the combined output.
6. **Clear status line**: Run `rm -f /tmp/fidgetflo-swarm-active` via Bash to turn off the swarm indicator

## The 15 Agents

| # | Agent Type | Role | Task Focus |
|---|-----------|------|------------|
| 1 | system-architect | Lead Architect | System design, task decomposition, coordinates all agents |
| 2 | coder | Backend Dev 1 | Core backend implementation |
| 3 | coder | Backend Dev 2 | Secondary backend / services |
| 4 | coder | Frontend Dev | UI / frontend implementation |
| 5 | backend-dev | DB Engineer | Schema, queries, data layer |
| 6 | tester | Test Engineer 1 | Unit + integration tests |
| 7 | tester | Test Engineer 2 | E2E + edge case tests |
| 8 | security-auditor | Security Auditor | Vulnerability scanning, input validation, secrets check |
| 9 | performance-engineer | Perf Engineer | Bottleneck analysis, optimization |
| 10 | reviewer | Code Reviewer | Quality, patterns, best practices |
| 11 | researcher | Researcher | Background research, prior art, docs lookup |
| 12 | analyst | Code Analyst | Architecture assessment, dependency analysis |
| 13 | coder | DevOps Engineer | CI/CD, deployment, infrastructure |
| 14 | coder | Technical Writer | Documentation, README, usage guides |
| 15 | tester | QA Coordinator | Final validation, cross-agent consistency check |

Adapt agent assignments to the task — not every task needs all 15 roles. If the task is frontend-only, shift agent roles accordingly. But ALWAYS spawn 15.

## Rules

- Model: Opus only. Never route to Haiku or Sonnet.
- Thinking: every Agent prompt MUST end with `Ultrathink.` on its own line
- Topology: hierarchical-mesh (architect leads, agents coordinate peer-to-peer within their layer)
- All agents spawned in background in ONE message
- Each agent gets a clear, specific sub-task with full context — not vague instructions
- After spawning, STOP and wait
- When results arrive, review ALL results before presenting final output
