# Cross-Session Memory

## Purpose
Maintain context and learnings across Claude Code sessions for continuous improvement.

## Memory Features

### 1. Automatic State Persistence
At session end, automatically saves:
- Active agents and specializations
- Task history and patterns
- Performance metrics
- Neural network weights
- Knowledge base updates

### 2. Session Restoration
```javascript
// Using MCP tools for memory operations
mcp__fidgetflo__memory_usage({
  "action": "retrieve",
  "key": "session-state",
  "namespace": "sessions"
})

// Restore swarm state
mcp__fidgetflo__context_restore({
  "snapshotId": "sess-123"
})
```

**Fallback with npx:**
```bash
npx fidgetflo hook session-restore --session-id "sess-123"
```

### 3. Memory Types

**Project Memory:**
- File relationships
- Common edit patterns
- Testing approaches
- Build configurations

**Agent Memory:**
- Specialization levels
- Task success rates
- Optimization strategies
- Error patterns

**Performance Memory:**
- Bottleneck history
- Optimization results
- Token usage patterns
- Efficiency trends

### 4. Privacy & Control
```javascript
// List memory contents
mcp__fidgetflo__memory_usage({
  "action": "list",
  "namespace": "sessions"
})

// Delete specific memory
mcp__fidgetflo__memory_usage({
  "action": "delete",
  "key": "session-123",
  "namespace": "sessions"
})

// Backup memory
mcp__fidgetflo__memory_backup({
  "path": "./backups/memory-backup.json"
})
```

**Manual control:**
```bash
# View stored memory
ls .fidgetflo/memory/

# Disable memory
export FIDGETFLO_MEMORY_PERSIST=false
```

## Benefits
- 🧠 Contextual awareness
- 📈 Cumulative learning
- ⚡ Faster task completion
- 🎯 Personalized optimization