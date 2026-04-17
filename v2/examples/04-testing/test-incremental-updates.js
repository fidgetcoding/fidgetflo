#!/usr/bin/env node

/**
 * Demonstration of incremental update functionality in FidgetFlo
 * This script tests various incremental update scenarios across the system
 */

const { SwarmMemory } = require('../../dist/swarm/memory');
const { ConfigurationManager } = require('../../dist/core/config');
const { SimpleCache } = require('../../dist/memory/cache');
const { deepMerge } = require('../../dist/utils/helpers');

console.log('🧪 Testing Incremental Updates in FidgetFlo\n');

// Test 1: SwarmMemory Version Tracking
console.log('1️⃣ Testing SwarmMemory Version Tracking');
async function testSwarmMemoryVersions() {
  const memory = new SwarmMemory();
  
  // Initial set
  await memory.set('counter', 0);
  console.log('  ✓ Initial value set');
  
  // Perform incremental updates
  for (let i = 1; i <= 5; i++) {
    const current = await memory.get('counter');
    await memory.update('counter', current.value + 1);
    console.log(`  ✓ Update ${i}: value=${current.value + 1}, version=${current.version + 1}`);
  }
  
  const final = await memory.get('counter');
  console.log(`  📊 Final state: value=${final.value}, version=${final.version}`);
  console.log(`  📜 Version history: ${final.previousVersions.length} entries`);
  
  return final.version === 6 && final.value === 5;
}

// Test 2: Configuration Updates
console.log('\n2️⃣ Testing Configuration Manager Updates');
function testConfigurationUpdates() {
  const configManager = new ConfigurationManager({
    defaultConfig: {
      model: 'claude-3',
      temperature: 0.7,
      maxTokens: 4096,
      tools: { webSearch: true, memory: true }
    }
  });
  
  console.log('  ✓ Initial config created');
  
  // Partial update
  configManager.update({
    temperature: 0.9,
    tools: { webSearch: false }
  });
  
  const config = configManager.getConfig();
  console.log(`  ✓ Temperature updated: ${config.temperature}`);
  console.log(`  ✓ Tools.webSearch updated: ${config.tools.webSearch}`);
  console.log(`  ✓ Tools.memory preserved: ${config.tools.memory}`);
  
  const diff = configManager.getDiff();
  console.log(`  📊 Config diff: ${JSON.stringify(diff)}`);
  
  return config.temperature === 0.9 && 
         config.tools.webSearch === false && 
         config.tools.memory === true;
}

// Test 3: Cache Hit/Miss Counters
console.log('\n3️⃣ Testing Cache Hit/Miss Counters');
function testCacheCounters() {
  const cache = new SimpleCache({ maxSize: 3 });
  
  // Add items
  cache.set('key1', 'value1');
  cache.set('key2', 'value2');
  console.log('  ✓ Added 2 items to cache');
  
  // Generate hits
  cache.get('key1'); // hit
  cache.get('key2'); // hit
  cache.get('key1'); // hit
  console.log('  ✓ Generated 3 cache hits');
  
  // Generate misses
  cache.get('key3'); // miss
  cache.get('key4'); // miss
  console.log('  ✓ Generated 2 cache misses');
  
  const stats = cache.stats();
  console.log(`  📊 Cache stats: ${JSON.stringify(stats)}`);
  
  return stats.hits === 3 && stats.misses === 2;
}

// Test 4: Deep Merge Updates
console.log('\n4️⃣ Testing Deep Merge Incremental Updates');
function testDeepMerge() {
  const original = {
    settings: {
      ui: {
        theme: 'light',
        fontSize: 14
      },
      features: ['search', 'export']
    }
  };
  
  const update = {
    settings: {
      ui: {
        theme: 'dark'
      },
      features: ['search', 'export', 'share']
    }
  };
  
  const result = deepMerge(original, update);
  
  console.log('  ✓ Deep merge completed');
  console.log(`  ✓ Theme updated: ${result.settings.ui.theme}`);
  console.log(`  ✓ FontSize preserved: ${result.settings.ui.fontSize}`);
  console.log(`  ✓ Features updated: ${result.settings.features.join(', ')}`);
  
  return result.settings.ui.theme === 'dark' && 
         result.settings.ui.fontSize === 14 &&
         result.settings.features.length === 3;
}

// Test 5: Batch Updates
console.log('\n5️⃣ Testing Batch Incremental Updates');
async function testBatchUpdates() {
  const memory = new SwarmMemory();
  const batchSize = 10;
  
  // Store initial batch
  for (let i = 0; i < batchSize; i++) {
    await memory.set(`item-${i}`, { count: i });
  }
  console.log(`  ✓ Stored ${batchSize} initial items`);
  
  // Batch update all items
  const updatePromises = [];
  for (let i = 0; i < batchSize; i++) {
    const promise = memory.get(`item-${i}`).then(item => 
      memory.update(`item-${i}`, { count: item.value.count + 10 })
    );
    updatePromises.push(promise);
  }
  
  await Promise.all(updatePromises);
  console.log('  ✓ Completed batch updates');
  
  // Verify updates
  let allUpdated = true;
  for (let i = 0; i < batchSize; i++) {
    const item = await memory.get(`item-${i}`);
    if (item.value.count !== i + 10 || item.version !== 2) {
      allUpdated = false;
      break;
    }
  }
  
  console.log(`  📊 All items updated correctly: ${allUpdated}`);
  return allUpdated;
}

// Test 6: Concurrent Counter Updates
console.log('\n6️⃣ Testing Concurrent Counter Updates');
async function testConcurrentCounters() {
  const memory = new SwarmMemory();
  await memory.set('shared-counter', 0);
  
  const numAgents = 5;
  const incrementsPerAgent = 10;
  
  // Simulate multiple agents incrementing counter
  const agentPromises = [];
  for (let agent = 0; agent < numAgents; agent++) {
    const agentWork = async () => {
      for (let i = 0; i < incrementsPerAgent; i++) {
        const current = await memory.get('shared-counter');
        await memory.update('shared-counter', current.value + 1);
        // Small random delay to simulate real work
        await new Promise(resolve => setTimeout(resolve, Math.random() * 10));
      }
    };
    agentPromises.push(agentWork());
  }
  
  await Promise.all(agentPromises);
  
  const final = await memory.get('shared-counter');
  console.log(`  ✓ ${numAgents} agents completed ${incrementsPerAgent} increments each`);
  console.log(`  📊 Final counter: value=${final.value}, version=${final.version}`);
  console.log(`  ✓ Expected: ${numAgents * incrementsPerAgent}, Actual: ${final.value}`);
  
  return final.value === numAgents * incrementsPerAgent;
}

// Run all tests
async function runAllTests() {
  const tests = [
    { name: 'SwarmMemory Versions', fn: testSwarmMemoryVersions },
    { name: 'Configuration Updates', fn: testConfigurationUpdates },
    { name: 'Cache Counters', fn: testCacheCounters },
    { name: 'Deep Merge', fn: testDeepMerge },
    { name: 'Batch Updates', fn: testBatchUpdates },
    { name: 'Concurrent Counters', fn: testConcurrentCounters }
  ];
  
  let passed = 0;
  let failed = 0;
  
  for (const test of tests) {
    try {
      const result = await test.fn();
      if (result) {
        passed++;
        console.log(`\n✅ ${test.name}: PASSED`);
      } else {
        failed++;
        console.log(`\n❌ ${test.name}: FAILED`);
      }
    } catch (error) {
      failed++;
      console.log(`\n❌ ${test.name}: ERROR - ${error.message}`);
    }
  }
  
  console.log('\n📊 Test Summary:');
  console.log(`   ✅ Passed: ${passed}`);
  console.log(`   ❌ Failed: ${failed}`);
  console.log(`   📈 Total: ${tests.length}`);
  console.log(`   🎯 Success Rate: ${((passed / tests.length) * 100).toFixed(1)}%`);
  
  process.exit(failed > 0 ? 1 : 0);
}

// Execute tests
runAllTests().catch(console.error);