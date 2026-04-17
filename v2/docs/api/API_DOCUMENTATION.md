# 🔗 FidgetFlo v2.0.0 API Documentation

## Table of Contents

- [Overview](#overview)
- [Authentication](#authentication)
- [Command Syntax](#command-syntax)
- [MCP Tools Reference](#mcp-tools-reference)
  - [FidgetFlo Tools (87)](#fidgetflo-tools)
  - [Ruv-Swarm Tools (25)](#ruv-swarm-tools)
- [Agent Types](#agent-types)
- [WebSocket Integration](#websocket-integration)
- [Command Examples](#command-examples)
- [Error Handling](#error-handling)
- [Best Practices](#best-practices)

---

## Overview

FidgetFlo v2.0.0 provides comprehensive AI agent orchestration with 112 MCP tools, 54+ specialized agent types, and advanced swarm intelligence capabilities. This documentation covers the complete API surface for programmatic access to all features.

### Key Features

- **112 MCP Tools** - 87 FidgetFlo + 25 Ruv-Swarm integration tools
- **54+ Agent Types** - Specialized agents for every development need
- **Swarm Intelligence** - Multi-topology coordination (hierarchical, mesh, ring, star)
- **Neural Networks** - WASM-accelerated AI patterns and learning
- **Memory System** - Persistent, distributed memory with compression
- **Real-time Coordination** - WebSocket-based agent communication
- **GitHub Integration** - Native CI/CD and repository management
- **Auto-scaling** - Dynamic agent provisioning and resource management

## Authentication

### CLI Authentication

```bash
# Initialize with GitHub authentication (recommended)
npx fidgetflo@alpha github init

# Or use API key
export FIDGETFLO_API_KEY="your-api-key"
npx fidgetflo@alpha config set --api-key $FIDGETFLO_API_KEY
```

### MCP Integration

```javascript
// Add FidgetFlo as MCP server
claude mcp add fidgetflo npx fidgetflo@alpha mcp start

// Available MCP servers:
// - fidgetflo: 87 native tools
// - ruv-swarm: 25 advanced coordination tools
```

### Token-based Access

```bash
# Generate session token
npx fidgetflo@alpha auth login

# Use token in API calls
curl -H "Authorization: Bearer $(npx fidgetflo@alpha auth token)" \
  https://api.fidgetflo.ai/v2/agents
```

## Command Syntax

### Correct Command Format

**IMPORTANT**: Always use `npx fidgetflo@alpha` (not `npx fidgetflo`)

```bash
# ✅ CORRECT - Updated syntax
npx fidgetflo@alpha [command] [options]

# ❌ OUTDATED - Do not use
npx fidgetflo [command] [options]
```

### Core Commands

```bash
# Swarm operations
npx fidgetflo@alpha coordination swarm-init --topology hierarchical
npx fidgetflo@alpha coordination agent-spawn --type coder
npx fidgetflo@alpha coordination task-orchestrate --task "Build API"

# Memory operations
npx fidgetflo@alpha memory usage --action store --key project/context
npx fidgetflo@alpha memory search --pattern "authentication"

# Performance analysis
npx fidgetflo@alpha performance report --timeframe 24h
npx fidgetflo@alpha bottleneck analyze --component swarm

# GitHub integration
npx fidgetflo@alpha github repo-analyze --repo owner/repo
npx fidgetflo@alpha github pr-manage --action create
```

## MCP Tools Reference

### FidgetFlo Tools (87 Total)

#### 🐝 Swarm Coordination (12 tools)
- `mcp__fidgetflo__swarm_init` - Initialize swarm with topology
- `mcp__fidgetflo__agent_spawn` - Create specialized agents
- `mcp__fidgetflo__task_orchestrate` - Coordinate task execution
- `mcp__fidgetflo__swarm_status` - Monitor swarm health
- `mcp__fidgetflo__agent_list` - List active agents
- `mcp__fidgetflo__agent_metrics` - Agent performance data
- `mcp__fidgetflo__swarm_monitor` - Real-time monitoring
- `mcp__fidgetflo__topology_optimize` - Optimize coordination
- `mcp__fidgetflo__load_balance` - Balance agent workload
- `mcp__fidgetflo__coordination_sync` - Synchronize agents
- `mcp__fidgetflo__swarm_scale` - Scale agent count
- `mcp__fidgetflo__swarm_destroy` - Terminate swarm

#### 🧠 Neural Network (15 tools)
- `mcp__fidgetflo__neural_status` - Neural system status
- `mcp__fidgetflo__neural_train` - Train AI patterns
- `mcp__fidgetflo__neural_predict` - Make AI predictions
- `mcp__fidgetflo__neural_patterns` - Cognitive patterns
- `mcp__fidgetflo__model_load` - Load AI models
- `mcp__fidgetflo__model_save` - Save trained models
- `mcp__fidgetflo__wasm_optimize` - WASM performance
- `mcp__fidgetflo__inference_run` - Run AI inference
- `mcp__fidgetflo__pattern_recognize` - Pattern detection
- `mcp__fidgetflo__cognitive_analyze` - Cognitive analysis
- `mcp__fidgetflo__learning_adapt` - Adaptive learning
- `mcp__fidgetflo__neural_compress` - Model compression
- `mcp__fidgetflo__ensemble_create` - Ensemble models
- `mcp__fidgetflo__transfer_learn` - Transfer learning
- `mcp__fidgetflo__neural_explain` - AI explainability

#### 💾 Memory & Persistence (12 tools)
- `mcp__fidgetflo__memory_usage` - Store/retrieve data
- `mcp__fidgetflo__memory_search` - Search memory entries
- `mcp__fidgetflo__memory_persist` - Persistent storage
- `mcp__fidgetflo__memory_namespace` - Namespace management
- `mcp__fidgetflo__memory_backup` - Backup memory data
- `mcp__fidgetflo__memory_restore` - Restore from backup
- `mcp__fidgetflo__memory_compress` - Compress data
- `mcp__fidgetflo__memory_sync` - Synchronize memory
- `mcp__fidgetflo__cache_manage` - Cache operations
- `mcp__fidgetflo__state_snapshot` - State snapshots
- `mcp__fidgetflo__context_restore` - Context restoration
- `mcp__fidgetflo__memory_analytics` - Memory analytics

#### 📊 Analysis & Monitoring (13 tools)
- `mcp__fidgetflo__performance_report` - Performance reports
- `mcp__fidgetflo__bottleneck_analyze` - Bottleneck detection
- `mcp__fidgetflo__task_status` - Task monitoring
- `mcp__fidgetflo__task_results` - Task results
- `mcp__fidgetflo__benchmark_run` - Run benchmarks
- `mcp__fidgetflo__metrics_collect` - Collect metrics
- `mcp__fidgetflo__trend_analysis` - Trend analysis
- `mcp__fidgetflo__cost_analysis` - Cost tracking
- `mcp__fidgetflo__quality_assess` - Quality assessment
- `mcp__fidgetflo__error_analysis` - Error analysis
- `mcp__fidgetflo__usage_stats` - Usage statistics
- `mcp__fidgetflo__health_check` - System health
- `mcp__fidgetflo__token_usage` - Token tracking

#### 🔄 Workflow & Automation (11 tools)
- `mcp__fidgetflo__workflow_create` - Create workflows
- `mcp__fidgetflo__workflow_execute` - Execute workflows
- `mcp__fidgetflo__workflow_export` - Export workflows
- `mcp__fidgetflo__automation_setup` - Setup automation
- `mcp__fidgetflo__pipeline_create` - Create pipelines
- `mcp__fidgetflo__scheduler_manage` - Manage schedules
- `mcp__fidgetflo__trigger_setup` - Setup triggers
- `mcp__fidgetflo__workflow_template` - Workflow templates
- `mcp__fidgetflo__batch_process` - Batch processing
- `mcp__fidgetflo__parallel_execute` - Parallel execution
- `mcp__fidgetflo__sparc_mode` - SPARC workflows

#### 🐙 GitHub Integration (8 tools)
- `mcp__fidgetflo__github_repo_analyze` - Repository analysis
- `mcp__fidgetflo__github_pr_manage` - Pull request management
- `mcp__fidgetflo__github_issue_track` - Issue tracking
- `mcp__fidgetflo__github_release_coord` - Release coordination
- `mcp__fidgetflo__github_workflow_auto` - Workflow automation
- `mcp__fidgetflo__github_code_review` - Code review
- `mcp__fidgetflo__github_sync_coord` - Sync coordination
- `mcp__fidgetflo__github_metrics` - GitHub metrics

#### 🤖 DAA (Dynamic Agent Architecture) (8 tools)
- `mcp__fidgetflo__daa_agent_create` - Create dynamic agents
- `mcp__fidgetflo__daa_capability_match` - Match capabilities
- `mcp__fidgetflo__daa_resource_alloc` - Resource allocation
- `mcp__fidgetflo__daa_lifecycle_manage` - Lifecycle management
- `mcp__fidgetflo__daa_communication` - Agent communication
- `mcp__fidgetflo__daa_consensus` - Consensus algorithms
- `mcp__fidgetflo__daa_fault_tolerance` - Fault tolerance
- `mcp__fidgetflo__daa_optimization` - Agent optimization

#### 🛠️ System & Utilities (8 tools)
- `mcp__fidgetflo__terminal_execute` - Terminal execution
- `mcp__fidgetflo__config_manage` - Configuration management
- `mcp__fidgetflo__features_detect` - Feature detection
- `mcp__fidgetflo__security_scan` - Security scanning
- `mcp__fidgetflo__backup_create` - Create backups
- `mcp__fidgetflo__restore_system` - System restoration
- `mcp__fidgetflo__log_analysis` - Log analysis
- `mcp__fidgetflo__diagnostic_run` - Run diagnostics

### Ruv-Swarm Tools (25 Total)

#### 🌊 Advanced Swarm Operations
- `mcp__ruv-swarm__swarm_init` - Advanced swarm initialization
- `mcp__ruv-swarm__swarm_status` - Detailed swarm status
- `mcp__ruv-swarm__swarm_monitor` - Real-time monitoring
- `mcp__ruv-swarm__agent_spawn` - Spawn ruv-swarm agents
- `mcp__ruv-swarm__agent_list` - List ruv-swarm agents
- `mcp__ruv-swarm__agent_metrics` - Agent performance metrics

#### 🎯 Task Coordination
- `mcp__ruv-swarm__task_orchestrate` - Advanced task orchestration
- `mcp__ruv-swarm__task_status` - Task status monitoring
- `mcp__ruv-swarm__task_results` - Retrieve task results

#### 🧠 Neural Intelligence
- `mcp__ruv-swarm__neural_status` - Neural system status
- `mcp__ruv-swarm__neural_train` - Train neural models
- `mcp__ruv-swarm__neural_patterns` - Cognitive patterns

#### 💾 Memory Management
- `mcp__ruv-swarm__memory_usage` - Memory operations

#### ⚡ Performance
- `mcp__ruv-swarm__benchmark_run` - Performance benchmarks
- `mcp__ruv-swarm__features_detect` - Feature detection

#### 🤖 Dynamic Agent Architecture (DAA)
- `mcp__ruv-swarm__daa_init` - Initialize DAA
- `mcp__ruv-swarm__daa_agent_create` - Create DAA agents
- `mcp__ruv-swarm__daa_agent_adapt` - Adapt agent behavior
- `mcp__ruv-swarm__daa_workflow_create` - Create DAA workflows
- `mcp__ruv-swarm__daa_workflow_execute` - Execute DAA workflows
- `mcp__ruv-swarm__daa_knowledge_share` - Share knowledge
- `mcp__ruv-swarm__daa_learning_status` - Learning status
- `mcp__ruv-swarm__daa_cognitive_pattern` - Cognitive patterns
- `mcp__ruv-swarm__daa_meta_learning` - Meta-learning
- `mcp__ruv-swarm__daa_performance_metrics` - Performance metrics

## Agent Types

### Core Development Agents
| Agent | Type | Capabilities |
|-------|------|-------------|
| **coder** | Implementation | Code generation, refactoring, debugging |
| **reviewer** | Quality Assurance | Code review, best practices, standards |
| **tester** | Testing | Unit tests, integration tests, TDD |
| **researcher** | Investigation | Research, analysis, documentation |
| **planner** | Planning | Project planning, task breakdown |

### Specialized Agents
| Agent | Type | Capabilities |
|-------|------|-------------|
| **code-analyzer** | Analysis | Code quality, performance, security |
| **system-architect** | Architecture | System design, patterns, scalability |
| **backend-dev** | Development | API development, databases, services |
| **mobile-dev** | Development | React Native, mobile platforms |
| **ml-developer** | ML/AI | Machine learning, data science |
| **api-docs** | Documentation | API documentation, OpenAPI specs |
| **cicd-engineer** | DevOps | CI/CD pipelines, automation |
| **performance-benchmarker** | Performance | Load testing, optimization |
| **production-validator** | Validation | Production readiness, deployment |
| **task-orchestrator** | Coordination | Task management, workflow coordination |

### Swarm Coordination Agents
| Agent | Type | Capabilities |
|-------|------|-------------|
| **hierarchical-coordinator** | Coordination | Queen-led hierarchical swarms |
| **mesh-coordinator** | Coordination | Peer-to-peer mesh networks |
| **adaptive-coordinator** | Coordination | Dynamic topology switching |
| **collective-intelligence-coordinator** | Coordination | Hive-mind intelligence |
| **swarm-memory-manager** | Memory | Distributed memory coordination |
| **consensus-builder** | Consensus | Distributed decision making |

### GitHub Integration Agents
| Agent | Type | Capabilities |
|-------|------|-------------|
| **github-modes** | Integration | Comprehensive GitHub operations |
| **pr-manager** | Pull Requests | PR creation, review, management |
| **issue-tracker** | Issues | Issue management, tracking |
| **release-manager** | Releases | Release coordination, automation |
| **code-review-swarm** | Code Review | Multi-agent code review |
| **repo-architect** | Repository | Repository structure, organization |
| **workflow-automation** | Automation | GitHub Actions, CI/CD |
| **sync-coordinator** | Synchronization | Multi-repo coordination |

### Performance & Consensus Agents
| Agent | Type | Capabilities |
|-------|------|-------------|
| **perf-analyzer** | Performance | Bottleneck identification, optimization |
| **byzantine-coordinator** | Consensus | Byzantine fault tolerance |
| **raft-manager** | Consensus | Raft consensus algorithm |
| **gossip-coordinator** | Communication | Gossip protocol coordination |
| **quorum-manager** | Consensus | Quorum-based decisions |
| **crdt-synchronizer** | Synchronization | CRDT-based data sync |
| **security-manager** | Security | Security validation, auditing |

### SPARC Agents
| Agent | Type | Capabilities |
|-------|------|-------------|
| **sparc-coder** | SPARC Implementation | TDD-driven development |
| **sparc-coordinator** | SPARC Coordination | SPARC workflow management |

## WebSocket Integration

### Connection Setup

```javascript
const ws = new WebSocket('wss://api.fidgetflo.ai/v2/ws');

// Authentication
ws.on('open', () => {
  ws.send(JSON.stringify({
    type: 'auth',
    token: 'your-session-token'
  }));
});

// Subscribe to agent events
ws.send(JSON.stringify({
  type: 'subscribe',
  channels: ['agents', 'swarms', 'tasks', 'memory']
}));
```

### Event Types

#### Agent Events
```javascript
// Agent spawned
{
  "type": "agent.spawned",
  "data": {
    "agentId": "agent_123",
    "type": "coder",
    "name": "Backend Developer",
    "status": "active"
  }
}

// Agent status change
{
  "type": "agent.status",
  "data": {
    "agentId": "agent_123",
    "status": "busy",
    "currentTask": "implement-auth",
    "progress": 0.65
  }
}
```

#### Swarm Events
```javascript
// Swarm coordination event
{
  "type": "swarm.coordination",
  "data": {
    "swarmId": "swarm_456",
    "topology": "hierarchical",
    "agentCount": 8,
    "efficiency": 0.94
  }
}

// Task orchestration
{
  "type": "swarm.task",
  "data": {
    "taskId": "task_789",
    "assignedAgents": ["agent_123", "agent_456"],
    "strategy": "parallel",
    "progress": 0.45
  }
}
```

#### Memory Events
```javascript
// Memory synchronization
{
  "type": "memory.sync",
  "data": {
    "namespace": "project-alpha",
    "entriesSync": 1247,
    "compressionRatio": 0.65,
    "latency": "12ms"
  }
}
```

## Command Examples

### Complete Development Workflow

```bash
# 1. Initialize project with GitHub integration
npx fidgetflo@alpha github init

# 2. Set up swarm for development
npx fidgetflo@alpha coordination swarm-init \
  --topology hierarchical \
  --max-agents 8 \
  --strategy adaptive

# 3. Spawn development team (concurrent)
npx fidgetflo@alpha coordination agent-spawn --type system-architect --name "Lead Architect"
npx fidgetflo@alpha coordination agent-spawn --type backend-dev --name "API Developer"
npx fidgetflo@alpha coordination agent-spawn --type coder --name "Frontend Dev"
npx fidgetflo@alpha coordination agent-spawn --type tester --name "QA Engineer"
npx fidgetflo@alpha coordination agent-spawn --type code-analyzer --name "Code Reviewer"

# 4. Store project context in memory
npx fidgetflo@alpha memory usage \
  --action store \
  --key "project/architecture" \
  --value "Microservices with event sourcing and CQRS" \
  --namespace "development" \
  --ttl 86400

# 5. Orchestrate development task
npx fidgetflo@alpha coordination task-orchestrate \
  --task "Build complete REST API with authentication and testing" \
  --strategy parallel \
  --priority high

# 6. Monitor swarm performance
npx fidgetflo@alpha coordination swarm-status
npx fidgetflo@alpha performance report --timeframe 24h --format detailed

# 7. Analyze GitHub repository
npx fidgetflo@alpha github repo-analyze \
  --repo "myorg/my-project" \
  --analysis-type code_quality

# 8. Create workflow for automation
npx fidgetflo@alpha workflow create \
  --name "full-stack-pipeline" \
  --steps '[
    {"type": "swarm_init", "topology": "hierarchical"},
    {"type": "agent_spawn", "agents": ["architect", "coder", "tester"]},
    {"type": "task_orchestrate", "strategy": "parallel"},
    {"type": "github_integration", "automate": true}
  ]'
```

### Neural Network Training

```bash
# 1. Check neural system status
npx fidgetflo@alpha neural status

# 2. Train coordination patterns
npx fidgetflo@alpha neural train \
  --pattern-type coordination \
  --training-data "./data/coordination-patterns.json" \
  --epochs 100

# 3. Make AI predictions
npx fidgetflo@alpha neural predict \
  --model-id coordination_model_v1.2 \
  --input "complex microservices architecture with event sourcing"

# 4. Analyze cognitive patterns
npx fidgetflo@alpha neural patterns \
  --pattern convergent \
  --analysis detailed
```

### Memory and State Management

```bash
# 1. Store complex project data
npx fidgetflo@alpha memory usage \
  --action store \
  --key "decisions/architecture" \
  --value '{
    "pattern": "microservices",
    "database": "postgres",
    "auth": "jwt",
    "caching": "redis"
  }' \
  --namespace "project-alpha" \
  --ttl 604800

# 2. Search for related information
npx fidgetflo@alpha memory search \
  --pattern "microservices|architecture" \
  --namespace "project-alpha" \
  --limit 10

# 3. Create memory backup
npx fidgetflo@alpha memory backup \
  --namespace "project-alpha" \
  --format compressed

# 4. Analyze memory usage
npx fidgetflo@alpha memory analytics \
  --timeframe 7d \
  --include-compression-stats
```

### Performance Monitoring

```bash
# 1. Run comprehensive performance report
npx fidgetflo@alpha performance report \
  --timeframe 24h \
  --format detailed \
  --include-recommendations

# 2. Identify bottlenecks
npx fidgetflo@alpha bottleneck analyze \
  --component swarm_coordination \
  --metrics "response_time,throughput,error_rate" \
  --severity all

# 3. Optimize swarm topology
npx fidgetflo@alpha topology optimize \
  --swarm-id "swarm_123" \
  --target-efficiency 0.95

# 4. Health check all systems
npx fidgetflo@alpha health-check \
  --components '["swarm", "neural", "memory", "mcp"]' \
  --detailed true
```

## Error Handling

### Common Error Codes

```bash
# Agent spawn failure
{
  "error": "AGENT_SPAWN_FAILED",
  "message": "Maximum agent limit reached",
  "details": {
    "currentAgents": 8,
    "maxAgents": 8,
    "swarmId": "swarm_123"
  }
}

# Memory operation failure
{
  "error": "MEMORY_STORAGE_FULL",
  "message": "Memory storage limit exceeded",
  "details": {
    "usedMemory": "512MB",
    "maxMemory": "512MB",
    "namespace": "project-alpha"
  }
}

# Neural training failure
{
  "error": "NEURAL_TRAINING_FAILED",
  "message": "Insufficient training data",
  "details": {
    "requiredSamples": 100,
    "providedSamples": 45,
    "patternType": "coordination"
  }
}
```

### Error Recovery

```bash
# Retry with backoff
npx fidgetflo@alpha coordination agent-spawn \
  --type coder \
  --retry-attempts 3 \
  --retry-delay 1000

# Graceful degradation
npx fidgetflo@alpha coordination swarm-init \
  --topology hierarchical \
  --fallback-topology mesh \
  --max-agents 8 \
  --min-agents 3

# Error notification
npx fidgetflo@alpha hooks post-edit \
  --file "error.log" \
  --memory-key "errors/$(date +%s)" \
  --notify-on-failure true
```

## Best Practices

### 1. Efficient Agent Management

```bash
# Always batch agent operations
# ✅ Good - Single message with multiple spawns
npx fidgetflo@alpha coordination agent-spawn --type architect &
npx fidgetflo@alpha coordination agent-spawn --type coder &
npx fidgetflo@alpha coordination agent-spawn --type tester &
wait

# ❌ Bad - Sequential spawning
npx fidgetflo@alpha coordination agent-spawn --type architect
npx fidgetflo@alpha coordination agent-spawn --type coder
npx fidgetflo@alpha coordination agent-spawn --type tester
```

### 2. Memory Management

```bash
# Use namespaces effectively
npx fidgetflo@alpha memory usage \
  --action store \
  --key "config/database" \
  --namespace "project-$(date +%Y%m%d)" \
  --ttl 86400

# Regular cleanup
npx fidgetflo@alpha memory compress \
  --namespace "temporary" \
  --threshold 0.8
```

### 3. Performance Optimization

```bash
# Monitor before scaling
npx fidgetflo@alpha performance report --format summary
npx fidgetflo@alpha coordination swarm-scale --target-size 12

# Use appropriate topologies
# Complex tasks -> hierarchical
# Collaborative work -> mesh
# Sequential processing -> ring
# Centralized control -> star
```

### 4. Integration Patterns

```bash
# Hook integration for automation
npx fidgetflo@alpha hooks pre-task \
  --description "Auto-spawn agents based on task complexity"

npx fidgetflo@alpha hooks post-edit \
  --file "src/**/*.js" \
  --memory-key "code-changes/$(date +%s)"

# Workflow templates for reusability
npx fidgetflo@alpha workflow template \
  --name "api-development" \
  --export "./templates/api-dev-workflow.json"
```

### 5. Security and Access Control

```bash
# Secure authentication
npx fidgetflo@alpha github init --secure-mode
npx fidgetflo@alpha config set --api-key-encryption enabled

# Resource limits
npx fidgetflo@alpha coordination swarm-init \
  --max-agents 10 \
  --memory-limit "1GB" \
  --cpu-limit "4 cores"

# Audit logging
npx fidgetflo@alpha log-analysis \
  --include-security-events \
  --format audit
```

---

## Support & Resources

### Documentation Links
- [GitHub Repository](https://github.com/ruvnet/claude-flow)
- [Integration Guide](./INTEGRATION_GUIDE.md)
- [Agent System Documentation](./agent-system-documentation.md)
- [MCP Tools Reference](./mcp-tools-reference.md)

### CLI Help
```bash
# Get help for any command
npx fidgetflo@alpha --help
npx fidgetflo@alpha coordination --help
npx fidgetflo@alpha github --help

# Version information
npx fidgetflo@alpha --version
```

### Community
- **Discord**: [Join our community](https://discord.gg/fidgetflo)
- **GitHub Issues**: [Report bugs](https://github.com/ruvnet/claude-flow/issues)
- **Discussions**: [Feature requests](https://github.com/ruvnet/claude-flow/discussions)

---

<div align="center">

**FidgetFlo v2.0.0-alpha.59**

*Intelligent AI Agent Orchestration*

[🚀 Get Started](../README.md) | [🔧 Configure](./DEPLOYMENT.md) | [🤝 Contribute](../CONTRIBUTING.md)

</div>