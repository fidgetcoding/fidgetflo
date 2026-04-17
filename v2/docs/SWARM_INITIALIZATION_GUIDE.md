# Swarm Initialization Guide
**Date:** 2025-10-25
**FidgetFlo Version:** 2.7.14

---

## ❌ Common Mistake

```bash
# THIS DOES NOT EXIST:
npx fidgetflo@alpha hooks swarm-init --topology adaptive --max-agents 6
# Error: ❌ Unknown hooks command: swarm-init
```

**Why?** Hooks are for **lifecycle events** (pre-task, post-task, etc.), NOT swarm initialization.

---

## ✅ Correct Methods

### Method 1: MCP Tools (In Claude Code)

**For ruv-swarm (WASM-powered):**
```javascript
// Call this from within Claude Code:
mcp__ruv-swarm__swarm_init({
  topology: "mesh",        // mesh, hierarchical, ring, star
  maxAgents: 6,
  strategy: "adaptive"     // balanced, specialized, adaptive
})
```

**For fidgetflo MCP:**
```javascript
// Call this from within Claude Code:
mcp__fidgetflo__swarm_init({
  topology: "hierarchical",
  maxAgents: 8,
  strategy: "balanced"
})
```

**Example Result:**
```json
{
  "id": "swarm-1761410358918",
  "message": "Successfully initialized mesh swarm with 6 max agents",
  "topology": "mesh",
  "strategy": "adaptive",
  "maxAgents": 6,
  "features": {
    "cognitive_diversity": true,
    "neural_networks": true,
    "forecasting": false,
    "simd_support": true
  },
  "performance": {
    "initialization_time_ms": 1.28,
    "memory_usage_mb": 48
  }
}
```

---

### Method 2: FidgetFlo CLI (High-Level)

**For task-based swarm deployment:**
```bash
# Requires Claude Code CLI
npx fidgetflo@alpha swarm "Build a REST API with authentication" --max-agents 6

# With options:
npx fidgetflo@alpha swarm "Analyze codebase" \
  --max-agents 6 \
  --strategy research \
  --mode mesh \
  --read-only
```

**CLI Options:**
- `--strategy` - research, development, analysis, testing, optimization
- `--mode` - centralized, distributed, hierarchical, mesh, hybrid
- `--max-agents` - Maximum number of agents (default: 5)
- `--parallel` - Enable parallel execution (2.8-4.4x speedup)
- `--monitor` - Real-time swarm monitoring
- `--background` - Run in background
- `--claude` - Open Claude Code CLI
- `--executor` - Use built-in executor
- `--read-only` - Analysis mode (no code changes)

---

### Method 3: Hive Mind System (Recommended for Complex Tasks)

**Interactive wizard:**
```bash
npx fidgetflo@alpha hive-mind wizard
```

**Direct spawn:**
```bash
npx fidgetflo@alpha hive-mind spawn "Build REST API with auth"
npx fidgetflo@alpha hive-mind spawn "Analyze security" --claude
```

**Check status:**
```bash
npx fidgetflo@alpha hive-mind status
npx fidgetflo@alpha hive-mind metrics
```

---

## 🎯 When to Use Each Method

### Use MCP Tools When:
- ✅ Working inside Claude Code
- ✅ Need low-level control over swarm topology
- ✅ Want to integrate with other MCP operations
- ✅ Building custom coordination workflows

### Use CLI Commands When:
- ✅ Running from terminal/scripts
- ✅ Need quick swarm deployment
- ✅ Want high-level task orchestration
- ✅ Prefer command-line interface

### Use Hive Mind When:
- ✅ Complex multi-objective tasks
- ✅ Need persistent swarm coordination
- ✅ Want intelligent agent self-organization
- ✅ Require SQLite-backed memory

---

## 🔧 Hooks System (Lifecycle Events)

**Hooks are for lifecycle management, NOT swarm creation:**

### Available Hook Commands:
```bash
# Before task starts
npx fidgetflo@alpha hooks pre-task \
  --description "Build API" \
  --task-id "task-123"

# After task completes
npx fidgetflo@alpha hooks post-task \
  --task-id "task-123" \
  --analyze-performance

# Before file edit
npx fidgetflo@alpha hooks pre-edit \
  --file "src/api.js" \
  --operation edit

# After file edit
npx fidgetflo@alpha hooks post-edit \
  --file "src/api.js" \
  --memory-key "swarm/123/edits/api"

# End of session
npx fidgetflo@alpha hooks session-end \
  --export-metrics \
  --generate-summary
```

---

## 🌐 Flow-Nexus Cloud Platform

**For cloud-based swarm orchestration:**

```javascript
// 1. Register/Login
mcp__flow-nexus__user_register({ email, password })
mcp__flow-nexus__user_login({ email, password })

// 2. Initialize cloud swarm
mcp__flow-nexus__swarm_init({
  topology: "hierarchical",
  maxAgents: 8,
  strategy: "balanced"
})

// 3. Spawn cloud agents
mcp__flow-nexus__agent_spawn({
  type: "researcher",
  name: "researcher-1",
  capabilities: ["web-search", "data-analysis"]
})

// 4. Orchestrate tasks
mcp__flow-nexus__task_orchestrate({
  task: "Build microservices architecture",
  strategy: "parallel",
  priority: "high"
})
```

---

## 📊 Comparison Matrix

| Method | Speed | Control | Complexity | Best For |
|--------|-------|---------|------------|----------|
| **MCP Tools** | Fast (1-2ms) | High | Low | Claude Code integration |
| **CLI Swarm** | Medium | Medium | Medium | Terminal workflows |
| **Hive Mind** | Slower | High | High | Complex orchestration |
| **Flow-Nexus** | Variable | Highest | High | Cloud deployment |

---

## 🚀 Quick Start Examples

### Example 1: Simple Research Swarm
```bash
npx fidgetflo@alpha swarm "Research GraphQL best practices" \
  --strategy research \
  --max-agents 3 \
  --read-only
```

### Example 2: Development Swarm
```bash
npx fidgetflo@alpha swarm "Build authentication service" \
  --strategy development \
  --max-agents 5 \
  --parallel \
  --monitor
```

### Example 3: MCP-Based Swarm
```javascript
// In Claude Code:
mcp__ruv-swarm__swarm_init({
  topology: "mesh",
  maxAgents: 4,
  strategy: "adaptive"
})

mcp__ruv-swarm__agent_spawn({
  type: "coder",
  name: "backend-dev"
})

mcp__ruv-swarm__task_orchestrate({
  task: "Implement user authentication",
  strategy: "sequential",
  priority: "high"
})
```

### Example 4: Hive Mind with Claude Code
```bash
npx fidgetflo@alpha hive-mind spawn \
  "Build e-commerce platform" \
  --claude
```

---

## 🐞 Troubleshooting

### Issue: "Unknown hooks command: swarm-init"
**Solution:** Use `npx fidgetflo@alpha swarm` or MCP tools instead

### Issue: "Compiled swarm module not found"
**Solution:** Either:
1. Use MCP tools (recommended)
2. Install Claude Code CLI
3. Use `--executor` flag for built-in execution

### Issue: Swarm initialization fails
**Check:**
1. MCP servers running: `claude mcp list`
2. Dependencies installed: `npm install`
3. Memory available: Check `.swarm/memory.db`

---

## 📚 Additional Resources

**Documentation:**
- Main README: `/README.md`
- Tool Validation: `/docs/TOOL_VALIDATION_REPORT.md`
- Integration Review: `/docs/AGENTIC_FLOW_INTEGRATION_REVIEW.md`

**Skills:**
- Swarm Orchestration: `.claude/skills/swarm-orchestration/SKILL.md`
- Hive Mind Advanced: `.claude/skills/hive-mind-advanced/SKILL.md`

**Official Guides:**
- GitHub: https://github.com/ruvnet/claude-flow
- Hive Mind: https://github.com/ruvnet/claude-flow/tree/main/docs/hive-mind

---

**Created:** 2025-10-25
**Updated:** 2025-10-25
**Author:** Claude Code (Claude Sonnet 4.5)
