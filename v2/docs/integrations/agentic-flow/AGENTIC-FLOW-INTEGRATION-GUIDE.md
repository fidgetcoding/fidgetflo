# Agentic-Flow Integration Guide for FidgetFlo

## 🎯 Overview

FidgetFlo v2.6.0+ includes deep integration with agentic-flow, providing access to 66+ specialized AI agents with multi-provider support, ReasoningBank memory, and intelligent model optimization.

## 🚀 Quick Start

```bash
# Initialize ReasoningBank for learning agents
fidgetflo agent memory init

# Run your first agent
fidgetflo agent run coder "Build a REST API with authentication"

# Run with memory enabled (learns from experience)
fidgetflo agent run coder "Add user management API" --enable-memory

# Check what the agent learned
fidgetflo agent memory status
```

## 📚 Complete Command Reference

### 1. Agent Execution

#### Basic Agent Execution

```bash
# Execute any of the 66+ available agents
fidgetflo agent run <agent-type> "<task>" [options]

# Examples
fidgetflo agent run coder "Create Express.js REST API"
fidgetflo agent run researcher "Research GraphQL best practices"
fidgetflo agent run security-auditor "Audit authentication code"
fidgetflo agent run full-stack-developer "Build Next.js app"
fidgetflo agent run tester "Create Jest test suite"
```

#### Multi-Provider Support

```bash
# Use different LLM providers
fidgetflo agent run coder "Build API" --provider anthropic
fidgetflo agent run coder "Build API" --provider openrouter
fidgetflo agent run coder "Build API" --provider onnx        # Local
fidgetflo agent run coder "Build API" --provider gemini

# With specific models
fidgetflo agent run coder "Build API" --provider anthropic --model claude-3-5-sonnet-20241022
fidgetflo agent run coder "Build API" --provider openrouter --model meta-llama/llama-3.1-70b-instruct
```

#### Execution Options

```bash
# Temperature control (creativity vs consistency)
fidgetflo agent run coder "Write code" --temperature 0.3

# Max tokens (output length)
fidgetflo agent run researcher "Research topic" --max-tokens 4096

# Output format
fidgetflo agent run analyst "Analyze data" --format json
fidgetflo agent run researcher "Research" --format markdown

# Streaming output
fidgetflo agent run coder "Build API" --stream

# Verbose logging
fidgetflo agent run coder "Build API" --verbose

# Retry on errors
fidgetflo agent run coder "Build API" --retry

# Custom timeout
fidgetflo agent run coder "Complex task" --timeout 600000  # 10 minutes
```

### 2. Model Optimization (85-98% Cost Savings)

```bash
# Auto-select optimal model based on task
fidgetflo agent run coder "Fix simple bug" --optimize

# Optimize for cost (cheapest model that works)
fidgetflo agent run coder "Add logging" --optimize --priority cost

# Optimize for quality (best model)
fidgetflo agent run coder "Critical security fix" --optimize --priority quality

# Optimize for speed (fastest model)
fidgetflo agent run coder "Quick refactor" --optimize --priority speed

# Optimize for privacy (local models only)
fidgetflo agent run coder "Sensitive code" --optimize --priority privacy

# Balanced optimization (cost + quality)
fidgetflo agent run coder "Feature implementation" --optimize --priority balanced

# With budget cap
fidgetflo agent run coder "Build API" --optimize --max-cost 0.10  # Max $0.10
```

### 3. ReasoningBank Memory System

#### Initialize Memory

```bash
# First time setup
fidgetflo agent memory init

# With custom database location
fidgetflo agent memory init --db /path/to/memory.db
```

#### Run Agents with Memory

```bash
# Enable learning from experience
fidgetflo agent run coder "Build authentication API" --enable-memory

# With domain filtering (organize memories)
fidgetflo agent run coder "Add JWT auth" --enable-memory --memory-domain authentication

# Customize memory retrieval
fidgetflo agent run coder "Add OAuth" --enable-memory \
  --memory-k 5 \
  --memory-min-confidence 0.7 \
  --memory-domain authentication

# Custom task ID for tracking
fidgetflo agent run coder "Deploy app" --enable-memory \
  --memory-task-id deploy-v1.0.0

# Read memories without creating new ones
fidgetflo agent run researcher "Check patterns" --enable-memory --no-memory-learning

# Custom memory database
fidgetflo agent run coder "Build API" --enable-memory --memory-db .swarm/custom.db
```

#### Memory Management

```bash
# Check memory statistics
fidgetflo agent memory status

# List stored memories
fidgetflo agent memory list
fidgetflo agent memory list --domain authentication
fidgetflo agent memory list --limit 20

# Consolidate (deduplicate and prune)
fidgetflo agent memory consolidate

# Run interactive demo (see 0% → 100% learning)
fidgetflo agent memory demo

# Run validation tests
fidgetflo agent memory test

# Run performance benchmarks
fidgetflo agent memory benchmark
```

### 4. Agent Discovery and Management

```bash
# List all 66+ available agents
fidgetflo agent agents

# Get detailed agent information
fidgetflo agent info coder
fidgetflo agent info security-auditor
fidgetflo agent info full-stack-developer

# Create custom agent
fidgetflo agent create \
  --name "api-specialist" \
  --description "Specialized in REST API design" \
  --category "backend" \
  --prompt "You are an expert in REST API design..." \
  --tools "web-search,code-execution"

# Check for agent conflicts (package vs local)
fidgetflo agent conflicts
```

### 5. Configuration Management

```bash
# Interactive setup wizard
fidgetflo agent config wizard

# Set API keys
fidgetflo agent config set ANTHROPIC_API_KEY sk-ant-xxx
fidgetflo agent config set OPENROUTER_API_KEY sk-or-xxx
fidgetflo agent config set GOOGLE_GEMINI_API_KEY xxx

# Set default provider/model
fidgetflo agent config set DEFAULT_PROVIDER anthropic
fidgetflo agent config set DEFAULT_MODEL claude-3-5-sonnet-20241022

# Get configuration
fidgetflo agent config get ANTHROPIC_API_KEY
fidgetflo agent config get DEFAULT_PROVIDER

# List all configurations
fidgetflo agent config list
fidgetflo agent config list --show-secrets

# Delete configuration
fidgetflo agent config delete OPENROUTER_API_KEY

# Reset to defaults
fidgetflo agent config reset --force
```

### 6. MCP Server Management

```bash
# Start MCP server
fidgetflo agent mcp start
fidgetflo agent mcp start --port 3000
fidgetflo agent mcp start --daemon  # Run in background

# Check server status
fidgetflo agent mcp status
fidgetflo agent mcp status --detailed

# List available MCP tools
fidgetflo agent mcp list
fidgetflo agent mcp list --server agent-booster
fidgetflo agent mcp list --category "code-editing"

# View logs
fidgetflo agent mcp logs
fidgetflo agent mcp logs --lines 100
fidgetflo agent mcp logs --follow

# Stop/restart server
fidgetflo agent mcp stop
fidgetflo agent mcp restart
```

## 🧠 ReasoningBank Learning Workflow

### Complete Example: Building an Authentication System

```bash
# Step 1: Initialize memory system
fidgetflo agent memory init

# Step 2: Build JWT authentication (first attempt)
fidgetflo agent run coder "Build JWT authentication with Express.js" \
  --enable-memory \
  --memory-domain authentication/jwt \
  --memory-task-id auth-v1 \
  --format markdown

# Step 3: Add OAuth2 (learns from JWT experience)
fidgetflo agent run coder "Add OAuth2 authentication" \
  --enable-memory \
  --memory-domain authentication/oauth \
  --memory-k 5

# Step 4: Check what was learned
fidgetflo agent memory list --domain authentication

# Output shows memories like:
# 1. JWT Token Validation Pattern
#    Confidence: 0.85 | Usage: 2 | Created: 2025-10-12
#    Domain: authentication/jwt
#    Always validate JWT expiration before database queries
#
# 2. OAuth2 Token Refresh Strategy
#    Confidence: 0.80 | Usage: 1 | Created: 2025-10-12
#    Domain: authentication/oauth
#    Store refresh tokens securely and implement rotation

# Step 5: Add new authentication method (benefits from both JWT and OAuth memories)
fidgetflo agent run coder "Add SAML SSO authentication" \
  --enable-memory \
  --memory-domain authentication/saml \
  --memory-k 5 \
  --memory-min-confidence 0.7

# Step 6: Consolidate memories (remove duplicates, prune old ones)
fidgetflo agent memory consolidate

# Step 7: Check improved statistics
fidgetflo agent memory status
```

## 🔥 Advanced Usage Patterns

### Pattern 1: Progressive Enhancement with Memory

```bash
# Day 1: Build initial feature
fidgetflo agent run full-stack-developer "Build user profile page" \
  --enable-memory \
  --memory-domain profiles \
  --provider anthropic

# Day 2: Add related feature (learns from Day 1)
fidgetflo agent run full-stack-developer "Add profile picture upload" \
  --enable-memory \
  --memory-domain profiles \
  --memory-k 5

# Day 3: Add another related feature (learns from Days 1-2)
fidgetflo agent run full-stack-developer "Add profile settings page" \
  --enable-memory \
  --memory-domain profiles \
  --memory-k 5

# Result: Each iteration is faster and more consistent
```

### Pattern 2: Cost-Optimized Development

```bash
# Use cheap models for simple tasks
fidgetflo agent run coder "Add console logging" \
  --optimize --priority cost \
  --enable-memory

# Use quality models for complex tasks
fidgetflo agent run coder "Implement distributed caching" \
  --optimize --priority quality \
  --max-cost 0.50 \
  --enable-memory

# Let optimizer decide based on task
fidgetflo agent run coder "Refactor authentication module" \
  --optimize --priority balanced \
  --enable-memory
```

### Pattern 3: Multi-Agent Workflow

```bash
# Research phase
fidgetflo agent run researcher "Research GraphQL best practices for authentication" \
  --enable-memory \
  --memory-domain research/graphql \
  --format markdown

# Design phase
fidgetflo agent run system-architect "Design GraphQL API schema for authentication" \
  --enable-memory \
  --memory-domain design/graphql \
  --memory-k 5

# Implementation phase
fidgetflo agent run coder "Implement GraphQL authentication API" \
  --enable-memory \
  --memory-domain implementation/graphql \
  --memory-k 10

# Testing phase
fidgetflo agent run tester "Create comprehensive GraphQL API tests" \
  --enable-memory \
  --memory-domain testing/graphql \
  --memory-k 5

# Review phase
fidgetflo agent run security-auditor "Audit GraphQL authentication security" \
  --enable-memory \
  --memory-domain security/graphql \
  --memory-k 10

# Check accumulated knowledge
fidgetflo agent memory list --domain graphql
```

### Pattern 4: Domain-Specific Knowledge Building

```bash
# Build security knowledge base
for task in \
  "Implement input validation" \
  "Add SQL injection prevention" \
  "Implement CSRF protection" \
  "Add XSS prevention" \
  "Implement rate limiting"
do
  fidgetflo agent run security-auditor "$task" \
    --enable-memory \
    --memory-domain security \
    --memory-k 10
done

# Now security agent has comprehensive security knowledge
fidgetflo agent memory list --domain security
```

### Pattern 5: Local Development with ONNX

```bash
# Run entirely locally (no API calls)
fidgetflo agent run coder "Add logging to function" \
  --provider onnx \
  --enable-memory

# Benefits:
# - $0 cost
# - Privacy (code never leaves machine)
# - No API key needed
# - Good for simple tasks
```

## 🔗 Integration with FidgetFlo Swarms

Combine agentic-flow agents with fidgetflo swarm coordination:

```bash
# Initialize swarm with agentic-flow agents
fidgetflo swarm init --topology mesh --agents 5

# Each agent runs via agentic-flow with memory
fidgetflo agent run coder "Build API endpoint" --enable-memory &
fidgetflo agent run tester "Create tests" --enable-memory &
fidgetflo agent run security-auditor "Security review" --enable-memory &

# Check swarm status
fidgetflo swarm status
```

## 📊 Understanding ReasoningBank Performance

### Memory Scoring Formula

```
score = α·similarity + β·recency + γ·reliability + δ·diversity

Default weights:
- α (similarity)  = 0.7  // Semantic relevance
- β (recency)     = 0.2  // How recent
- γ (reliability) = 0.1  // Confidence from past use
- δ (diversity)   = 0.3  // MMR diversity selection
```

### Customize Scoring (Environment Variables)

```bash
# Adjust weights
export REASONINGBANK_ALPHA=0.8    # Prioritize similarity
export REASONINGBANK_BETA=0.1     # Less weight on recency
export REASONINGBANK_GAMMA=0.1    # Keep reliability weight
export REASONINGBANK_DELTA=0.2    # Less diversity

# Other settings
export REASONINGBANK_K=5                      # Retrieve top 5 memories
export REASONINGBANK_MIN_CONFIDENCE=0.7       # Higher quality threshold
export REASONINGBANK_RECENCY_HALFLIFE=14      # 2-week half-life

# Database location
export FIDGETFLO_DB_PATH=.swarm/team-memory.db
```

### Performance Metrics

After running agents with memory, check improvements:

```bash
fidgetflo agent memory status
```

Expected metrics:
- **Success rate**: 70% → 88% (+26%)
- **Token usage**: -25% reduction
- **Learning velocity**: 3.2x faster
- **Task completion**: 0% → 95% over 5 iterations

## 🎯 Real-World Examples

### Example 1: Building a Complete REST API

```bash
#!/bin/bash

# Initialize memory
fidgetflo agent memory init

# Research phase
fidgetflo agent run researcher "Research Express.js REST API best practices 2025" \
  --enable-memory \
  --memory-domain api/research \
  --format markdown > research-notes.md

# Architecture phase
fidgetflo agent run system-architect "Design REST API architecture for task management" \
  --enable-memory \
  --memory-domain api/architecture \
  --memory-k 5

# Implementation phase - Core API
fidgetflo agent run full-stack-developer "Implement Express.js REST API with PostgreSQL" \
  --enable-memory \
  --memory-domain api/implementation \
  --memory-k 10 \
  --optimize --priority balanced

# Implementation phase - Authentication
fidgetflo agent run coder "Add JWT authentication to API" \
  --enable-memory \
  --memory-domain api/authentication \
  --memory-k 10

# Implementation phase - Validation
fidgetflo agent run coder "Add input validation with Joi" \
  --enable-memory \
  --memory-domain api/validation \
  --memory-k 10

# Testing phase
fidgetflo agent run tester "Create comprehensive Jest test suite" \
  --enable-memory \
  --memory-domain api/testing \
  --memory-k 15

# Security audit
fidgetflo agent run security-auditor "Audit API for security vulnerabilities" \
  --enable-memory \
  --memory-domain api/security \
  --memory-k 15

# Performance optimization
fidgetflo agent run performance-optimizer "Optimize API performance" \
  --enable-memory \
  --memory-domain api/performance \
  --memory-k 10

# Documentation
fidgetflo agent run technical-writer "Create API documentation" \
  --enable-memory \
  --memory-domain api/documentation \
  --format markdown > API-DOCS.md

# Check what was learned
echo "\n📚 Knowledge accumulated:"
fidgetflo agent memory list --domain api --limit 20

# Consolidate memories
fidgetflo agent memory consolidate
```

### Example 2: Debugging with Memory

```bash
# First bug: Database connection timeout
fidgetflo agent run debugger "Fix PostgreSQL connection timeout error" \
  --enable-memory \
  --memory-domain debugging/database \
  --memory-task-id bug-001

# Second bug: Similar database issue (learns from first)
fidgetflo agent run debugger "Fix database deadlock in transaction" \
  --enable-memory \
  --memory-domain debugging/database \
  --memory-k 10 \
  --memory-task-id bug-002

# Result: Second fix is faster because agent remembers:
# - Database connection pool configuration
# - Transaction isolation levels
# - Common PostgreSQL issues
```

### Example 3: Migration Project

```bash
# Phase 1: Analyze existing code
fidgetflo agent run code-analyzer "Analyze Express.js v4 API structure" \
  --enable-memory \
  --memory-domain migration/analysis

# Phase 2: Plan migration
fidgetflo agent run system-architect "Plan Express.js v4 to v5 migration" \
  --enable-memory \
  --memory-domain migration/planning \
  --memory-k 5

# Phase 3: Execute migration (benefits from phases 1-2)
fidgetflo agent run full-stack-developer "Migrate Express.js v4 to v5" \
  --enable-memory \
  --memory-domain migration/implementation \
  --memory-k 10

# Phase 4: Validate migration
fidgetflo agent run tester "Create migration validation tests" \
  --enable-memory \
  --memory-domain migration/testing \
  --memory-k 10
```

## 🔍 Troubleshooting

### Issue: Agent execution fails

```bash
# Check configuration
fidgetflo agent config list

# Check API keys are set
fidgetflo agent config get ANTHROPIC_API_KEY

# Try with explicit provider
fidgetflo agent run coder "Test task" --provider anthropic

# Check verbose output
fidgetflo agent run coder "Test task" --verbose
```

### Issue: Memory not working

```bash
# Verify memory is initialized
fidgetflo agent memory status

# Re-initialize if needed
fidgetflo agent memory init

# Test with demo
fidgetflo agent memory demo

# Check database exists
ls -la .swarm/memory.db
```

### Issue: Slow performance

```bash
# Use model optimization
fidgetflo agent run coder "Task" --optimize --priority speed

# Reduce memory retrieval
fidgetflo agent run coder "Task" --enable-memory --memory-k 3

# Consolidate old memories
fidgetflo agent memory consolidate
```

### Issue: Out of memory errors

```bash
# Consolidate to prune old memories
fidgetflo agent memory consolidate

# Check memory statistics
fidgetflo agent memory status

# Use new database if too large
fidgetflo agent run coder "Task" --enable-memory --memory-db .swarm/new.db
```

## 📈 Best Practices

### 1. Memory Organization

```bash
# Use hierarchical domains
--memory-domain project/feature/aspect

# Examples:
--memory-domain ecommerce/auth/jwt
--memory-domain ecommerce/cart/checkout
--memory-domain ecommerce/payments/stripe
```

### 2. Progressive Learning

```bash
# Start simple, build up knowledge
fidgetflo agent run coder "Build simple API" --enable-memory
fidgetflo agent run coder "Add validation" --enable-memory --memory-k 5
fidgetflo agent run coder "Add authentication" --enable-memory --memory-k 10
fidgetflo agent run coder "Add rate limiting" --enable-memory --memory-k 15
```

### 3. Cost Optimization

```bash
# Use optimize flag consistently
alias cf-run='fidgetflo agent run --optimize --enable-memory'

# Then use normally
cf-run coder "Build feature"
cf-run tester "Create tests"
```

### 4. Regular Maintenance

```bash
# Weekly: Consolidate memories
fidgetflo agent memory consolidate

# Monthly: Check memory health
fidgetflo agent memory status
fidgetflo agent memory benchmark
```

## 🚀 Migration from Direct agentic-flow Usage

If you're currently using `npx agentic-flow` directly:

### Before (direct agentic-flow):
```bash
npx agentic-flow --agent coder --task "Build API" \
  --provider anthropic \
  --enable-memory \
  --memory-domain api
```

### After (via fidgetflo):
```bash
fidgetflo agent run coder "Build API" \
  --provider anthropic \
  --enable-memory \
  --memory-domain api
```

### Benefits of using fidgetflo wrapper:
1. Shorter commands
2. Integrated with fidgetflo swarms
3. Better error handling
4. Consistent logging
5. Access to fidgetflo hooks
6. Unified configuration
7. Easier MCP integration

## 🔗 Related Documentation

- **ReasoningBank Paper**: https://arxiv.org/html/2509.25140v1
- **Agent Creation Guide**: `docs/REASONINGBANK-AGENT-CREATION-GUIDE.md`
- **Reasoning Agents**: `.claude/agents/reasoning/README.md`
- **Available Agents**: Run `fidgetflo agent agents`

## 🆘 Support

- GitHub Issues: https://github.com/ruvnet/claude-flow/issues
- Agentic-Flow Issues: https://github.com/ruvnet/agentic-flow/issues
- Documentation: https://github.com/ruvnet/claude-flow

---

**Version**: 2.6.0+
**Last Updated**: 2025-10-12
**Status**: Production-ready
