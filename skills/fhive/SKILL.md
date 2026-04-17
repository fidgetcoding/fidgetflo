---
name: fhive
description: "Launch a queen-led FidgetFlo hive-mind with raft consensus for autonomous task execution. The queen decomposes and delegates — hands-off."
---

# FidgetFlo Hive Mind — Queen-Led Autonomous Execution

When this skill is invoked, IMMEDIATELY initialize a hive-mind with a queen agent that autonomously manages the work. Do NOT explain how hive-minds work. Do NOT show code examples. ACT.

## How This Differs from /fswarm

- `/fswarm` = you define the task, Claude pre-assigns 15 agents with fixed roles
- `/fhive` = you define the GOAL, a queen agent takes over and autonomously manages everything

The queen decides how many workers to spawn, what roles they need, how to coordinate them, and when the work is done. You set the goal and step back.

## Execution Steps

1. Read the user's goal (everything they typed after `/fhive`)
2. **Signal status line**: Run `touch /tmp/fidgetflo-hive-active` via Bash to light up the hive indicator
3. Initialize the hive-mind in ONE message:
   - Call `mcp__fidgetflo__hive-mind_init` with consensus `raft`
   - Spawn a queen agent (hierarchical-coordinator type) via the Agent tool with `run_in_background: true`
   - The queen's prompt MUST include:
     a. The user's full goal
     b. Instructions to use `mcp__fidgetflo__hive-mind_spawn` to create workers as needed
     c. Instructions to use `mcp__fidgetflo__hive-mind_broadcast` for coordination
     d. Instructions to use `mcp__fidgetflo__hive-mind_consensus` for decisions
     e. Instructions to use `mcp__fidgetflo__hive-mind_memory` for shared state
     f. Instructions to present final synthesized output when complete
4. After spawning the queen, STOP. Do not poll. Do not check status. The queen runs the show.
5. When the queen returns results, present them to the user.
6. **Clear status line**: Run `rm -f /tmp/fidgetflo-hive-active` via Bash to turn off the hive indicator

## Queen Agent Behavior

The queen MUST:
- Decompose the goal into sub-tasks
- Decide which worker types to spawn (from the 60+ available agent types)
- Assign specific sub-tasks to each worker
- Monitor worker output and coordinate
- Use raft consensus — queen is the leader, maintains authoritative state
- Use hive-mind memory for shared context across all workers
- Synthesize all worker results into a final deliverable
- Shut down workers when done

## Rules

- Model: Opus only. Never route to Haiku or Sonnet.
- Consensus: Raft (queen is authoritative leader)
- Queen spawns workers autonomously — do not pre-define the team
- Maximum workers: 15 (respect maxAgents config)
- After spawning the queen, STOP and wait
- Trust the queen's judgment on team composition and coordination
