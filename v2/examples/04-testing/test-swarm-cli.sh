#!/bin/bash
# Test FidgetFlo Swarm CLI functionality

echo "🔬 Testing FidgetFlo Swarm CLI System"
echo "========================================"
echo ""
echo "This test will demonstrate the swarm system creating real applications"
echo "using various strategies and options."
echo ""

# Set up test directory
TEST_DIR="/tmp/swarm-cli-test-$(date +%s)"
mkdir -p "$TEST_DIR"
cd "$TEST_DIR"

echo "📁 Test directory: $TEST_DIR"
echo ""

# Test 1: Development Strategy - Create TODO App
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📋 Test 1: Development Strategy - TODO App"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "🚀 Running: npx fidgetflo@latest swarm \"create a TODO list application with add, remove, and list functions\" --strategy development --max-agents 4 --dry-run"
echo ""

npx fidgetflo@latest swarm "create a TODO list application with add, remove, and list functions" \
  --strategy development \
  --max-agents 4 \
  --dry-run

echo ""
echo "✅ Dry run completed - showing what would be created"
echo ""

# Test 2: Research Strategy
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📋 Test 2: Research Strategy"  
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "🚀 Running: npx fidgetflo@latest swarm \"research best practices for Node.js microservices\" --strategy research --monitor"
echo ""

timeout 30s npx fidgetflo@latest swarm "research best practices for Node.js microservices" \
  --strategy research \
  --monitor \
  --dry-run

echo ""

# Test 3: Analysis Strategy with Advanced Options
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📋 Test 3: Analysis Strategy with Advanced Options"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "🚀 Running: npx fidgetflo@latest swarm \"analyze code quality in the src directory\" --strategy analysis --parallel --quality-threshold 0.9"
echo ""

npx fidgetflo@latest swarm "analyze code quality in the src directory" \
  --strategy analysis \
  --parallel \
  --quality-threshold 0.9 \
  --task-scheduling priority \
  --dry-run

echo ""

# Test 4: Testing Strategy
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📋 Test 4: Testing Strategy"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "🚀 Running: npx fidgetflo@latest swarm \"create comprehensive test suite for authentication module\" --strategy testing --testing --review"
echo ""

npx fidgetflo@latest swarm "create comprehensive test suite for authentication module" \
  --strategy testing \
  --testing \
  --review \
  --dry-run

echo ""

# Test 5: Distributed Mode with Background Execution
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📋 Test 5: Distributed Mode Configuration"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "🚀 Running: npx fidgetflo@latest swarm \"build a REST API with CRUD operations\" --mode distributed --distributed --background"
echo ""

npx fidgetflo@latest swarm "build a REST API with CRUD operations" \
  --mode distributed \
  --distributed \
  --background \
  --max-agents 8 \
  --memory-namespace api-project \
  --dry-run

echo ""

# Test 6: Show all available options
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📋 Test 6: Help and Available Options"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

npx fidgetflo@latest swarm --help

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📊 Test Summary"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "✅ All swarm CLI tests completed!"
echo ""
echo "The tests demonstrated:"
echo "  • Development strategy for building applications"
echo "  • Research strategy for gathering information"  
echo "  • Analysis strategy for code quality assessment"
echo "  • Testing strategy for test suite creation"
echo "  • Distributed mode for scalable execution"
echo "  • Various coordination and quality options"
echo ""
echo "Note: These were dry-run tests showing configuration."
echo "Remove --dry-run flag to execute actual swarm tasks."
echo ""
echo "📁 Test artifacts location: $TEST_DIR"
echo ""