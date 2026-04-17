# ReasoningBank Integration Architecture

## System Overview

```
┌──────────────────────────────────────────────────────────────────┐
│                     fidgetflo v2.7.0                           │
│                                                                  │
│  ┌────────────────┐         ┌─────────────────┐                │
│  │  CLI Layer     │────────▶│  Agent Executor │                │
│  │  (agent.js)    │         │  (TypeScript)   │                │
│  └────────────────┘         └─────────────────┘                │
│         │                            │                          │
│         │                            ▼                          │
│         │                   ┌─────────────────┐                │
│         │                   │ Provider Manager│                │
│         │                   │  + RB Config    │                │
│         │                   └─────────────────┘                │
│         │                            │                          │
│         └────────────────────────────┼──────────────────────┐  │
│                                      │                      │  │
│                                      ▼                      ▼  │
└──────────────────────────────────────┼──────────────────────┼──┘
                                       │                      │
                   ┌───────────────────┴──────────────────────┴────┐
                   │        agentic-flow@1.4.11                    │
                   │                                                │
                   │  ┌──────────────────────────────────────┐    │
                   │  │     ReasoningBank Engine             │    │
                   │  │                                      │    │
                   │  │  ┌─────────────────────────────┐    │    │
                   │  │  │  1. RETRIEVE                │    │    │
                   │  │  │  • Top-k similarity search  │    │    │
                   │  │  │  • 4-factor scoring         │    │    │
                   │  │  │  • Domain filtering         │    │    │
                   │  │  └─────────────────────────────┘    │    │
                   │  │              ▼                       │    │
                   │  │  ┌─────────────────────────────┐    │    │
                   │  │  │  2. JUDGE                   │    │    │
                   │  │  │  • LLM-based evaluation     │    │    │
                   │  │  │  • Heuristic fallback       │    │    │
                   │  │  │  • Confidence scoring       │    │    │
                   │  │  └─────────────────────────────┘    │    │
                   │  │              ▼                       │    │
                   │  │  ┌─────────────────────────────┐    │    │
                   │  │  │  3. DISTILL                 │    │    │
                   │  │  │  • Extract patterns         │    │    │
                   │  │  │  • PII scrubbing            │    │    │
                   │  │  │  • Store with confidence    │    │    │
                   │  │  └─────────────────────────────┘    │    │
                   │  │              ▼                       │    │
                   │  │  ┌─────────────────────────────┐    │    │
                   │  │  │  4. CONSOLIDATE (every 20)  │    │    │
                   │  │  │  • Deduplicate              │    │    │
                   │  │  │  • Detect contradictions    │    │    │
                   │  │  │  • Prune old memories       │    │    │
                   │  │  └─────────────────────────────┘    │    │
                   │  └──────────────────────────────────────┘    │
                   │                    │                          │
                   │                    ▼                          │
                   │         ┌─────────────────────┐              │
                   │         │  SQLite Database    │              │
                   │         │  .swarm/memory.db   │              │
                   │         │                     │              │
                   │         │  • patterns         │              │
                   │         │  • embeddings       │              │
                   │         │  • trajectories     │              │
                   │         │  • metrics          │              │
                   │         └─────────────────────┘              │
                   └────────────────────────────────────────────────┘
```

## Data Flow: Task Execution with Memory

```
┌──────────────────────────────────────────────────────────────────┐
│                    User Executes Command                         │
└──────────────────────────┬───────────────────────────────────────┘
                           │
                           ▼
┌──────────────────────────────────────────────────────────────────┐
│  fidgetflo agent run coder "Build REST API" --enable-memory   │
└──────────────────────────┬───────────────────────────────────────┘
                           │
                           ▼
┌──────────────────────────────────────────────────────────────────┐
│  CLI Parser (agent.js)                                           │
│  • Parses flags: --enable-memory, --memory-domain, etc.          │
│  • Creates AgentExecutionOptions object                          │
└──────────────────────────┬───────────────────────────────────────┘
                           │
                           ▼
┌──────────────────────────────────────────────────────────────────┐
│  AgentExecutor.execute()                                         │
│                                                                  │
│  Step 1: Initialize Memory (if first time)                      │
│  ┌────────────────────────────────────────────────────────┐    │
│  │  initializeMemory()                                     │    │
│  │  • Runs: agentic-flow reasoningbank init               │    │
│  │  • Creates .swarm/memory.db                             │    │
│  │  • Sets memoryEnabled = true                            │    │
│  └────────────────────────────────────────────────────────┘    │
│                           │                                      │
│                           ▼                                      │
│  Step 2: Retrieve Memories (pre-task)                           │
│  ┌────────────────────────────────────────────────────────┐    │
│  │  retrieveMemories(task, options)                        │    │
│  │  • Query: "Build REST API"                              │    │
│  │  • Top-k: 3 memories                                    │    │
│  │  • Domain filter: "api"                                 │    │
│  │  • Returns: [                                           │    │
│  │      {id: "m1", title: "API routing pattern"},         │    │
│  │      {id: "m2", title: "Auth middleware"},             │    │
│  │      {id: "m3", title: "Error handling"}               │    │
│  │    ]                                                    │    │
│  └────────────────────────────────────────────────────────┘    │
│                           │                                      │
│                           ▼                                      │
│  Step 3: Inject Memories into Prompt                            │
│  ┌────────────────────────────────────────────────────────┐    │
│  │  buildCommand(options, memories)                        │    │
│  │  • Original: "Build REST API"                           │    │
│  │  • Enhanced:                                            │    │
│  │    "Memory 1: API routing pattern                       │    │
│  │     Use express.Router() for modularity                 │    │
│  │                                                          │    │
│  │     Memory 2: Auth middleware                           │    │
│  │     Apply JWT verification before protected routes      │    │
│  │                                                          │    │
│  │     Memory 3: Error handling                            │    │
│  │     Use async/await with try-catch wrapper             │    │
│  │                                                          │    │
│  │     ---                                                  │    │
│  │     Task: Build REST API"                               │    │
│  └────────────────────────────────────────────────────────┘    │
│                           │                                      │
│                           ▼                                      │
│  Step 4: Execute Agent                                          │
│  ┌────────────────────────────────────────────────────────┐    │
│  │  execAsync(command)                                     │    │
│  │  • Runs: npx agentic-flow --agent coder --task "..."   │    │
│  │  • Agent receives memories in context                   │    │
│  │  • Generates code using learned patterns                │    │
│  │  • Returns: { stdout, stderr }                          │    │
│  └────────────────────────────────────────────────────────┘    │
│                           │                                      │
│                           ▼                                      │
│  Step 5: Learn from Execution (post-task)                       │
│  ┌────────────────────────────────────────────────────────┐    │
│  │  learnFromExecution(taskId, result, memories)           │    │
│  │  • Verdict: "success" (task completed)                  │    │
│  │  • Confidence: 0.7                                      │    │
│  │  • Extracts: "REST API with Express boilerplate"       │    │
│  │  • Stores new memory with id: "m47"                     │    │
│  │  • Increments usage count for m1, m2, m3               │    │
│  └────────────────────────────────────────────────────────┘    │
│                           │                                      │
│                           ▼                                      │
│  Step 6: Auto-Consolidation Check                               │
│  ┌────────────────────────────────────────────────────────┐    │
│  │  taskCounter++ → 20 tasks completed                     │    │
│  │  • Triggers consolidateMemories()                       │    │
│  │  • Deduplicates: 2 similar memories merged              │    │
│  │  • Prunes: 1 old unused memory removed                  │    │
│  │  • Duration: 8ms                                        │    │
│  └────────────────────────────────────────────────────────┘    │
│                           │                                      │
│                           ▼                                      │
│  Step 7: Return Result                                          │
│  ┌────────────────────────────────────────────────────────┐    │
│  │  AgentExecutionResult {                                 │    │
│  │    success: true,                                       │    │
│  │    output: "REST API code...",                          │    │
│  │    duration: 2847ms,                                    │    │
│  │    memoryEnabled: true,                                 │    │
│  │    memoriesRetrieved: 3,                                │    │
│  │    memoriesUsed: ["m1", "m2", "m3"],                    │    │
│  │    memoryLearned: true,                                 │    │
│  │    newMemoryIds: ["m47"],                               │    │
│  │    memoryVerdict: "success",                            │    │
│  │    memoryConfidence: 0.7                                │    │
│  │  }                                                       │    │
│  └────────────────────────────────────────────────────────┘    │
└──────────────────────────┬───────────────────────────────────────┘
                           │
                           ▼
┌──────────────────────────────────────────────────────────────────┐
│  CLI Output                                                      │
│                                                                  │
│  🧠 Retrieved 3 relevant memories                                │
│     Memory 1: API routing pattern (confidence: 0.85)             │
│     Memory 2: Auth middleware (confidence: 0.78)                 │
│     Memory 3: Error handling (confidence: 0.71)                  │
│                                                                  │
│  [Agent generates code output...]                                │
│                                                                  │
│  ✅ Task completed successfully                                  │
│  📚 Learned 1 new memory: REST API with Express boilerplate      │
│  ⚡ Execution time: 2.8s (46% faster than average)               │
└──────────────────────────────────────────────────────────────────┘
```

## Memory Scoring Algorithm

```
For each candidate memory:

1. Embedding Similarity (α = 0.65)
   ┌─────────────────────────────────────┐
   │  similarity = cosine(query, memory)  │
   │             = dot(Q, M) / (||Q||·||M||) │
   │                                      │
   │  Example:                            │
   │  Query: "Build REST API"             │
   │  Memory: "API routing pattern"       │
   │  → similarity = 0.87                 │
   └─────────────────────────────────────┘

2. Recency (β = 0.15)
   ┌─────────────────────────────────────┐
   │  recency = exp(-age_days / 30)       │
   │                                      │
   │  Example:                            │
   │  Memory created 10 days ago          │
   │  → recency = exp(-10/30) = 0.72      │
   └─────────────────────────────────────┘

3. Reliability (γ = 0.20)
   ┌─────────────────────────────────────┐
   │  reliability = min(                  │
   │    confidence × sqrt(usage / 10),    │
   │    1.0                               │
   │  )                                   │
   │                                      │
   │  Example:                            │
   │  confidence = 0.8, usage = 25        │
   │  → reliability = min(                │
   │      0.8 × sqrt(25/10), 1.0          │
   │    ) = min(0.8 × 1.58, 1.0) = 1.0    │
   └─────────────────────────────────────┘

4. Diversity Penalty (δ = 0.10)
   ┌─────────────────────────────────────┐
   │  diversity = max_similarity_to_      │
   │              already_selected         │
   │                                      │
   │  Prevents redundant memories         │
   └─────────────────────────────────────┘

5. Final Score
   ┌─────────────────────────────────────┐
   │  score = α·similarity + β·recency +  │
   │          γ·reliability - δ·diversity │
   │                                      │
   │  Example:                            │
   │  = 0.65×0.87 + 0.15×0.72 +          │
   │    0.20×1.0 - 0.10×0.10             │
   │  = 0.566 + 0.108 + 0.20 - 0.01      │
   │  = 0.864                             │
   │                                      │
   │  ✅ High score → Will be retrieved   │
   └─────────────────────────────────────┘

6. Sort and Select Top-k
   ┌─────────────────────────────────────┐
   │  memories.sort(by: score)            │
   │  return memories.slice(0, k)         │
   │                                      │
   │  Example (k=3):                      │
   │  [                                   │
   │    {score: 0.864, title: "m1"},     │
   │    {score: 0.791, title: "m2"},     │
   │    {score: 0.746, title: "m3"}      │
   │  ]                                   │
   └─────────────────────────────────────┘
```

## Configuration Layers

```
┌────────────────────────────────────────────────────────────────┐
│  Layer 1: Runtime Flags (Highest Priority)                    │
│  • --enable-memory                                             │
│  • --memory-k 5                                                │
│  • --memory-domain web                                         │
│  Overrides all other layers                                    │
└────────────────────────┬───────────────────────────────────────┘
                         │
                         ▼
┌────────────────────────────────────────────────────────────────┐
│  Layer 2: User Configuration (~/.claude/settings.json)        │
│  {                                                             │
│    "fidgetflo": {                                            │
│      "execution": {                                            │
│        "reasoningbank": {                                      │
│          "enabled": true,                                      │
│          "retrievalK": 3,                                      │
│          "domains": ["web", "api"]                             │
│        }                                                       │
│      }                                                         │
│    }                                                           │
│  }                                                             │
│  Persists across sessions                                      │
└────────────────────────┬───────────────────────────────────────┘
                         │
                         ▼
┌────────────────────────────────────────────────────────────────┐
│  Layer 3: Default Configuration (provider-manager.ts)         │
│  getDefaultConfig() {                                          │
│    reasoningbank: {                                            │
│      enabled: false,                                           │
│      database: '.swarm/memory.db',                             │
│      retrievalK: 3,                                            │
│      autoConsolidate: true,                                    │
│      consolidateEvery: 20,                                     │
│      minConfidence: 0.5                                        │
│    }                                                           │
│  }                                                             │
│  Fallback when no configuration exists                         │
└────────────────────────────────────────────────────────────────┘

Resolution Order:
1. Check runtime flags
2. If not set, check user config
3. If not set, use defaults

Example:
  $ fidgetflo agent run coder "task" --memory-k 5

  Resolved config:
  {
    enabled: true,        // from --enable-memory (implicit)
    retrievalK: 5,        // from --memory-k flag
    database: '.swarm/memory.db',  // from user config
    autoConsolidate: true  // from defaults
  }
```

## File Structure After Integration

```
fidgetflo/
├── package.json                       # agentic-flow@1.4.11
│
├── src/
│   ├── execution/
│   │   ├── agent-executor.ts          # ✅ Extended with RB methods
│   │   └── provider-manager.ts        # ✅ Added RB config
│   │
│   ├── cli/
│   │   └── simple-commands/
│   │       └── agent.js               # ✅ Added --enable-memory flags
│   │                                  # ✅ Added memory subcommands
│   │
│   └── types/
│       └── reasoningbank.ts           # 🆕 TypeScript interfaces
│
├── tests/
│   ├── unit/
│   │   ├── agent-executor.test.ts     # 🆕 RB unit tests
│   │   └── provider-manager.test.ts   # 🆕 Config tests
│   │
│   └── integration/
│       └── reasoningbank.test.ts      # 🆕 E2E tests
│
├── docs/
│   ├── REASONINGBANK_INTEGRATION_PLAN.md    # 🆕 This doc
│   ├── REASONINGBANK_ARCHITECTURE.md        # 🆕 Architecture
│   ├── REASONINGBANK_GUIDE.md               # 🆕 User guide
│   └── examples/
│       └── reasoningbank/
│           ├── basic-usage.md               # 🆕 Examples
│           ├── domain-filtering.md          # 🆕 Examples
│           └── team-sharing.md              # 🆕 Examples
│
└── .swarm/                            # Created at runtime
    └── memory.db                      # SQLite database
```

## Performance Characteristics

```
┌───────────────────────────────────────────────────────────────┐
│  Operation Performance (ms)                                   │
├───────────────────────────────────────────────────────────────┤
│                                                               │
│  Database Connection       ██ 1ms                             │
│  Memory Retrieval (k=3)    ████ 3ms                           │
│  Memory Insertion          ██████ 1-2ms                       │
│  Batch Insert (100)        ████████████████████ 112ms         │
│  Consolidation            ██████ 5-10ms                       │
│  Embedding (Claude API)    ███████████████████████ 500ms      │
│  Judgment (Claude API)     ████████████████████████ 800ms     │
│                                                               │
└───────────────────────────────────────────────────────────────┘

Without API Keys (Heuristic Mode):
  • Retrieval: 1-3ms (local only)
  • Judgment: <1ms (rule-based)
  • Total overhead: <5ms per task

With API Keys (LLM Mode):
  • Retrieval: 1-3ms (local)
  • Judgment: 800ms (API call)
  • Total overhead: ~1s per task
  • Accuracy: 95% vs 70% heuristic

Memory Growth:
  • 1,000 memories: 1MB storage, 3ms retrieval
  • 10,000 memories: 10MB storage, 8ms retrieval
  • 100,000 memories: 100MB storage, 25ms retrieval
```

## Error Handling Flow

```
┌──────────────────────────────────────────────────────────────┐
│  Graceful Degradation Strategy                               │
└──────────────────────────────────────────────────────────────┘

Error: Memory database not found
  ↓
Auto-initialize database
  ↓
If init fails → Disable memory, continue without learning
  ✅ Task still executes

Error: Memory retrieval fails
  ↓
Log warning
  ↓
Continue with empty memory array
  ✅ Task executes without context

Error: Learning fails
  ↓
Log warning
  ↓
Skip memory creation
  ✅ Task result returned

Error: Consolidation fails
  ↓
Log warning
  ↓
Retry on next threshold
  ✅ System continues working

Error: API key missing (LLM mode)
  ↓
Fallback to heuristic judgment
  ↓
Accuracy: 70% vs 95%
  ✅ Learning still works

Error: Database corruption
  ↓
Backup and recreate
  ↓
Import from backup if available
  ✅ System recovers
```

---

**Next Steps:**
1. Review architecture with team
2. Approve integration plan
3. Begin Phase 1: Dependency update
4. Implement Phase 2: Interface extensions
5. Test and iterate

**Questions?**
- GitHub: https://github.com/ruvnet/claude-code-flow/issues
- Discord: https://discord.gg/fidgetflo
