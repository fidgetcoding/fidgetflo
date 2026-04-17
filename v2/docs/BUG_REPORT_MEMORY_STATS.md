# Bug Report: `memory stats` Command Returns Zero for ReasoningBank Data

## Executive Summary

The `memory stats` command always returns zero entries/namespaces/size, even when ReasoningBank contains data. This is caused by the command exclusively reading from the legacy JSON file (`./memory/memory-store.json`) instead of querying the active ReasoningBank SQLite database.

## Bug Details

### Issue
- **Command**: `npx fidgetflo@alpha memory stats`
- **Expected**: Shows statistics for ReasoningBank database (19 entries found via direct SQL query)
- **Actual**: Returns all zeros (0 entries, 0 namespaces, 0.00 KB)
- **Severity**: High - Users cannot see their stored data statistics
- **Affected Versions**: v2.7.30 and likely earlier

### Evidence

```bash
# Command returns zeros
$ npx fidgetflo@alpha memory stats
✅ Memory Bank Statistics:
   Total Entries: 0
   Namespaces: 0
   Size: 0.00 KB

# But ReasoningBank list shows 10+ entries
$ npx fidgetflo@alpha memory list --reasoningbank
✅ ReasoningBank memories (10 shown):
📌 test-key
📌 test-sqlite
📌 api-design
[... 16 more entries]

# Direct SQL query confirms 19 entries exist
$ sqlite3 .swarm/memory.db "SELECT COUNT(*) FROM patterns WHERE type = 'reasoning_memory';"
19

# ReasoningBank status confirms data exists
$ npx fidgetflo@alpha memory status --reasoningbank
✅ 📊 ReasoningBank Status:
   Total memories: 19
   Average confidence: 80.0%
   Embeddings: 19
   Trajectories: 0
```

## Root Cause Analysis

### Code Analysis (src/cli/simple-commands/memory.js)

**Problem Location**: Lines 217-244

```javascript
async function showMemoryStats(loadMemory) {
  try {
    const data = await loadMemory();  // ❌ Only reads JSON file
    let totalEntries = 0;
    const namespaceStats = {};

    for (const [namespace, entries] of Object.entries(data)) {
      namespaceStats[namespace] = entries.length;
      totalEntries += entries.length;
    }

    printSuccess('Memory Bank Statistics:');
    console.log(`   Total Entries: ${totalEntries}`);
    console.log(`   Namespaces: ${Object.keys(data).length}`);
    console.log(`   Size: ${(new TextEncoder().encode(JSON.stringify(data)).length / 1024).toFixed(2)} KB`);
    // ...
  }
}
```

**The `loadMemory()` function** (line 26-33):
```javascript
async function loadMemory() {
  try {
    const content = await fs.readFile(memoryStore, 'utf8');  // hardcoded JSON path
    return JSON.parse(content);
  } catch {
    return {};
  }
}
```

Where `memoryStore = './memory/memory-store.json'` (line 14)

### Why It's Broken

1. **Hardcoded JSON File**: `showMemoryStats()` only reads from `./memory/memory-store.json`
2. **No Mode Detection**: Unlike other commands (`store`, `query`, `list`), `stats` doesn't call `detectMemoryMode()` (line 23)
3. **No ReasoningBank Support**: The switch statement (lines 56-87) routes `stats` directly to `showMemoryStats()` without checking if ReasoningBank is active
4. **Inconsistent with Other Commands**: `store`, `query`, and `list` all support `--reasoningbank` flag via `handleReasoningBankCommand()`, but `stats` doesn't

### Working Commands for Comparison

```javascript
// ✅ These commands properly detect mode and support ReasoningBank
case 'store':
  await storeMemory(subArgs, loadMemory, saveMemory, namespace, enableRedaction);
  break;

case 'query':
  await queryMemory(subArgs, loadMemory, namespace, enableRedaction);
  break;

case 'list':
  await listNamespaces(loadMemory);
  break;

// ❌ This command ignores mode detection
case 'stats':
  await showMemoryStats(loadMemory);  // Never checks ReasoningBank!
  break;
```

## Expected Behavior

The `memory stats` command should:

1. **Detect the active memory mode** (basic JSON vs ReasoningBank SQLite)
2. **Show appropriate statistics** based on the active mode:
   - **ReasoningBank mode**: Query SQLite database for accurate counts
   - **Basic mode**: Read JSON file (current behavior)
   - **Auto mode**: Check both and show combined statistics
3. **Support `--reasoningbank` flag** to force ReasoningBank stats
4. **Display backend information**: Show which storage backend is being used

### Proposed Output

```bash
# Auto mode (should detect ReasoningBank if initialized)
$ npx fidgetflo@alpha memory stats
✅ Memory Bank Statistics:
   Storage Backend: ReasoningBank (SQLite)
   Total Entries: 19
   Namespaces: 3
   Size: 9.14 MB

📁 Namespace Breakdown:
   default: 12 entries
   test-namespace: 5 entries
   api: 2 entries

💡 Use 'memory stats --basic' for JSON statistics

# Force ReasoningBank mode
$ npx fidgetflo@alpha memory stats --reasoningbank
✅ ReasoningBank Statistics:
   Database: .swarm/memory.db
   Total Memories: 19
   Total Embeddings: 19
   Average Confidence: 80.0%
   Trajectories: 0
   Links: 0
   Database Size: 9.14 MB

# Force basic mode
$ npx fidgetflo@alpha memory stats --basic
✅ JSON Memory Statistics:
   Total Entries: 0
   Namespaces: 0
   Size: 0.00 KB
   ⚠️  Consider migrating to ReasoningBank for better performance
```

## Proposed Solution

### Option 1: Add ReasoningBank Support to stats (Recommended)

Modify `src/cli/simple-commands/memory.js`:

```javascript
// Line 65-67: Add mode detection to stats case
case 'stats':
  if (mode === 'reasoningbank') {
    await handleReasoningBankStats(getStatus);
  } else {
    await showMemoryStats(loadMemory);
  }
  break;

// Add new handler function (around line 718)
async function handleReasoningBankStats(getStatus) {
  try {
    const stats = await getStatus();

    printSuccess('ReasoningBank Statistics:');
    console.log(`   Database: ${stats.database_path || '.swarm/memory.db'}`);
    console.log(`   Total Memories: ${stats.total_memories}`);
    console.log(`   Total Categories: ${stats.total_categories}`);
    console.log(`   Average Confidence: ${(stats.avg_confidence * 100).toFixed(1)}%`);
    console.log(`   Embeddings: ${stats.total_embeddings}`);
    console.log(`   Trajectories: ${stats.total_trajectories}`);
    console.log(`   Links: ${stats.total_links || 0}`);
    console.log(`   Storage Backend: ${stats.storage_backend}`);

    if (stats.database_path) {
      const dbSize = await getFileSize(stats.database_path);
      console.log(`   Database Size: ${(dbSize / 1024 / 1024).toFixed(2)} MB`);
    }
  } catch (error) {
    printError(`Failed to get ReasoningBank stats: ${error.message}`);
  }
}

// Helper function
async function getFileSize(path) {
  try {
    const stats = await fs.stat(path);
    return stats.size;
  } catch {
    return 0;
  }
}
```

### Option 2: Create Unified Stats Command

Show both JSON and ReasoningBank statistics in one output:

```javascript
async function showMemoryStats(loadMemory, mode) {
  const rbInitialized = await isReasoningBankInitialized();

  printSuccess('Memory Bank Statistics:\n');

  // Show JSON stats
  const jsonData = await loadMemory();
  let totalEntries = Object.values(jsonData).reduce((sum, arr) => sum + arr.length, 0);

  console.log('📁 JSON Storage (./memory/memory-store.json):');
  console.log(`   Total Entries: ${totalEntries}`);
  console.log(`   Namespaces: ${Object.keys(jsonData).length}`);
  console.log(`   Size: ${(new TextEncoder().encode(JSON.stringify(jsonData)).length / 1024).toFixed(2)} KB`);

  // Show ReasoningBank stats if initialized
  if (rbInitialized) {
    const { getStatus } = await import('../../reasoningbank/reasoningbank-adapter.js');
    const rbStats = await getStatus();

    console.log('\n🧠 ReasoningBank Storage (.swarm/memory.db):');
    console.log(`   Total Memories: ${rbStats.total_memories}`);
    console.log(`   Categories: ${rbStats.total_categories}`);
    console.log(`   Average Confidence: ${(rbStats.avg_confidence * 100).toFixed(1)}%`);
    console.log(`   Embeddings: ${rbStats.total_embeddings}`);

    console.log('\n💡 Active Mode: ReasoningBank (auto-selected)');
  } else {
    console.log('\n⚠️  ReasoningBank not initialized (using JSON storage)');
    console.log('   Run "memory init --reasoningbank" to enable AI features');
  }
}
```

## Testing Plan

### Test Cases

1. **Test with empty JSON, empty ReasoningBank**
   ```bash
   rm -rf memory/ .swarm/
   npx fidgetflo@alpha memory stats
   # Expected: Show zeros for both backends
   ```

2. **Test with data in ReasoningBank only**
   ```bash
   npx fidgetflo@alpha memory store "test" "value" --reasoningbank
   npx fidgetflo@alpha memory stats
   # Expected: Show ReasoningBank stats with 1 entry
   ```

3. **Test with data in JSON only**
   ```bash
   npx fidgetflo@alpha memory store "test" "value" --basic
   npx fidgetflo@alpha memory stats
   # Expected: Show JSON stats with 1 entry
   ```

4. **Test with data in both backends**
   ```bash
   npx fidgetflo@alpha memory store "json-key" "json-value" --basic
   npx fidgetflo@alpha memory store "rb-key" "rb-value" --reasoningbank
   npx fidgetflo@alpha memory stats
   # Expected: Show stats for both backends
   ```

5. **Test with flags**
   ```bash
   npx fidgetflo@alpha memory stats --reasoningbank
   npx fidgetflo@alpha memory stats --basic
   npx fidgetflo@alpha memory stats --auto
   # Expected: Respect mode flags
   ```

## Impact Assessment

### User Impact: High
- Users relying on `memory stats` are seeing incorrect information
- New users testing ReasoningBank features think it's not working
- Migration from JSON to ReasoningBank appears unsuccessful

### Workarounds
Users can check ReasoningBank data using:
1. `memory status --reasoningbank` - Shows basic stats
2. `memory list --reasoningbank` - Lists all entries
3. Direct SQLite query: `sqlite3 .swarm/memory.db "SELECT COUNT(*) FROM patterns;"`

## Related Issues

- Memory mode detection works correctly for `store`, `query`, `list` commands
- The `status --reasoningbank` command works and shows accurate statistics
- This bug affects only the `stats` command (without flags)

## Files to Modify

1. **src/cli/simple-commands/memory.js**
   - Lines 65-67: Add mode detection to `stats` case
   - Lines 217-244: Modify `showMemoryStats()` to support ReasoningBank
   - Add new `handleReasoningBankStats()` function (around line 718)

## Backward Compatibility

✅ No breaking changes - existing JSON-based stats will continue to work
✅ New flag `--reasoningbank` is optional
✅ Auto mode will fall back to JSON if ReasoningBank not initialized

## Priority Recommendation

**Priority: High** - This is a user-facing bug that makes a primary feature (statistics) non-functional for ReasoningBank users.

**Suggested for**: v2.7.31 hotfix

---

## Additional Context

### System Information
- Version: v2.7.30 (and likely earlier)
- Database: SQLite 3.x at `.swarm/memory.db`
- ReasoningBank: Initialized and contains 19 entries
- JSON Storage: Empty (0 entries)

### Reproduction Steps
1. Initialize ReasoningBank: `npx fidgetflo@alpha memory init --reasoningbank`
2. Store data: `npx fidgetflo@alpha memory store test-key "test value" --reasoningbank`
3. Verify storage: `npx fidgetflo@alpha memory list --reasoningbank` (shows data)
4. Run stats: `npx fidgetflo@alpha memory stats` (shows zeros ❌)

### Related Files
- `/workspaces/claude-code-flow/src/cli/simple-commands/memory.js` (main bug location)
- `/workspaces/claude-code-flow/src/reasoningbank/reasoningbank-adapter.js` (working `getStatus()` function)
- `.swarm/memory.db` (SQLite database with 19 entries)
- `./memory/memory-store.json` (empty JSON file)
