# 📖 FidgetFlo User Guide

## Complete Practical Guide for FidgetFlo v2.0.0

Welcome to the comprehensive user guide for FidgetFlo! This document provides everything you need to get started and master the platform, from basic installation to advanced swarm coordination.

---

## 📋 Table of Contents

1. [Getting Started](#-getting-started)
2. [Basic Concepts](#-basic-concepts)
3. [Common Workflows](#-common-workflows)
4. [Step-by-Step Tutorials](#-step-by-step-tutorials)
5. [Configuration Guide](#-configuration-guide)
6. [Troubleshooting](#-troubleshooting)
7. [Performance Optimization](#-performance-optimization)
8. [Integrations](#-integrations)
9. [FAQ](#-faq)

---

## 🚀 Getting Started

### Prerequisites

Before starting with FidgetFlo, ensure you have:

- **Node.js** ≥ 20.0.0 ([Download](https://nodejs.org/))
- **npm** ≥ 9.0.0 (comes with Node.js)
- **Claude Code** ([Setup guide](https://claude.ai/code))
- **API Keys** for your preferred AI providers

### Quick Installation

```bash
# Option 1: Use npx (recommended for first-time users)
npx fidgetflo@alpha --help

# Option 2: Global installation
npm install -g fidgetflo@alpha

# Option 3: Project-specific installation
npm install fidgetflo@alpha
```

### Initial Setup

```bash
# Initialize FidgetFlo in your project
npx fidgetflo@alpha init --force

# Verify installation
npx fidgetflo@alpha version

# Run health check
npx fidgetflo@alpha health
```

### First Command

Try your first FidgetFlo command:

```bash
# Simple task execution
npx fidgetflo@alpha swarm "create a simple Hello World application"
```

---

## 🧠 Basic Concepts

### Core Components

#### 1. Agents
AI-powered workers that perform specific tasks:
- **54+ specialized agents** available
- Each agent has unique capabilities
- Can work independently or in coordination

#### 2. Swarms
Groups of agents working together:
- **Multiple coordination topologies**
- Distributed decision-making
- Fault-tolerant operations

#### 3. Memory System
Persistent knowledge storage:
- Shared across agents
- Multiple storage backends
- Automatic synchronization

#### 4. MCP Integration
Model Context Protocol tools:
- **87 available tools**
- Seamless Claude Code integration
- Real-time coordination

### Agent Types Overview

| Category | Examples | Use Cases |
|----------|----------|-----------|
| **Development** | `coder`, `reviewer`, `tester` | Code implementation, quality assurance |
| **Architecture** | `architect`, `planner` | System design, project planning |
| **Specialized** | `backend-dev`, `mobile-dev`, `ml-developer` | Domain-specific development |
| **Coordination** | `coordinator`, `monitor` | Task management, progress tracking |
| **Analysis** | `researcher`, `analyzer` | Information gathering, code analysis |

### Swarm Topologies

#### Centralized (Queen-Led)
```
      👑 Queen
    /   |   \
   🐝  🐝   🐝
```
- Single coordination point
- Simple communication
- Best for sequential tasks

#### Distributed (Multi-Leader)
```
   👑 --- 👑
   /\     /\
  🐝 🐝  🐝 🐝
```
- Multiple coordination points
- Load distribution
- Fault tolerance

#### Mesh (Peer-to-Peer)
```
   🐝 ─── 🐝
   │ ╲   ╱ │
   │   ╳   │
   │ ╱   ╲ │
   🐝 ─── 🐝
```
- Direct agent communication
- Creative collaboration
- No single point of failure

#### Hierarchical (Tree)
```
       👑
      /  \
     🐝   🐝
    / \   / \
   🐝 🐝 🐝 🐝
```
- Multi-level structure
- Scalable organization
- Complex project coordination

---

## 💼 Common Workflows

### Development Workflows

#### 1. Simple Task Execution
For straightforward development tasks:

```bash
# Code generation
npx fidgetflo@alpha swarm "create a REST API for user management"

# Bug fixing
npx fidgetflo@alpha swarm "fix all TypeScript errors in the project"

# Documentation
npx fidgetflo@alpha swarm "generate comprehensive API documentation"

# Testing
npx fidgetflo@alpha swarm "create unit tests for all service classes"
```

#### 2. Project-Based Development
For larger projects requiring coordination:

```bash
# Initialize project swarm
npx fidgetflo@alpha hive-mind spawn "e-commerce platform" \
  --agents architect,backend-dev,frontend-dev,tester \
  --topology hierarchical

# Continue development in same session
npx fidgetflo@alpha swarm "implement user authentication" --continue-session

# Add new features
npx fidgetflo@alpha swarm "add payment processing integration"

# Monitor progress
npx fidgetflo@alpha swarm status --watch
```

#### 3. SPARC Development Methodology
Structured development using Specification → Pseudocode → Architecture → Refinement → Code:

```bash
# Full SPARC pipeline
npx fidgetflo@alpha sparc pipeline "user management system"

# Individual SPARC phases
npx fidgetflo@alpha sparc spec "define requirements for authentication"
npx fidgetflo@alpha sparc architecture "design microservices structure"
npx fidgetflo@alpha sparc code "implement user service"

# Test-driven development
npx fidgetflo@alpha sparc tdd "payment processing module"
```

### Operational Workflows

#### 1. Code Review and Quality
```bash
# Comprehensive code review
npx fidgetflo@alpha swarm "perform security audit and code review" \
  --agents security-analyst,reviewer,code-quality-checker

# Performance optimization
npx fidgetflo@alpha swarm "analyze and optimize application performance" \
  --agents performance-analyst,optimizer
```

#### 2. DevOps and Deployment
```bash
# CI/CD setup
npx fidgetflo@alpha swarm "setup complete CI/CD pipeline" \
  --agents devops-engineer,cicd-specialist

# Container deployment
npx fidgetflo@alpha swarm "containerize application with Docker" \
  --agents docker-specialist,devops-engineer

# Kubernetes deployment
npx fidgetflo@alpha swarm "deploy to Kubernetes cluster" \
  --agents k8s-specialist,devops-engineer
```

#### 3. Documentation and Maintenance
```bash
# Generate documentation
npx fidgetflo@alpha swarm "create comprehensive project documentation" \
  --agents technical-writer,api-docs-generator

# Code maintenance
npx fidgetflo@alpha swarm "refactor legacy code and improve maintainability" \
  --agents refactoring-specialist,code-quality-checker
```

---

## 📚 Step-by-Step Tutorials

### Tutorial 1: Building Your First API

#### Step 1: Initialize Project
```bash
# Create new directory
mkdir my-api-project
cd my-api-project

# Initialize FidgetFlo
npx fidgetflo@alpha init --force

# Initialize npm project
npm init -y
```

#### Step 2: Define Requirements
```bash
# Use SPARC specification mode
npx fidgetflo@alpha sparc spec "REST API for task management with CRUD operations, authentication, and data validation"
```

#### Step 3: Create Architecture
```bash
# Generate system architecture
npx fidgetflo@alpha sparc architecture "Node.js Express API with PostgreSQL database, JWT authentication, and comprehensive error handling"
```

#### Step 4: Implement Code
```bash
# Generate implementation
npx fidgetflo@alpha sparc code "implement the complete task management API based on the architecture"
```

#### Step 5: Add Tests
```bash
# Create comprehensive tests
npx fidgetflo@alpha swarm "create unit tests, integration tests, and API endpoint tests" \
  --agents tester,test-automation-specialist
```

#### Step 6: Setup DevOps
```bash
# Add CI/CD and deployment
npx fidgetflo@alpha swarm "setup GitHub Actions CI/CD and Docker deployment" \
  --agents devops-engineer,cicd-specialist
```

### Tutorial 2: Complex Project with Multiple Agents

#### Step 1: Project Planning
```bash
# Initialize large project swarm
npx fidgetflo@alpha hive-mind spawn "full-stack social media application" \
  --agents architect,planner,backend-dev,frontend-dev,mobile-dev,tester,devops-engineer \
  --topology hierarchical \
  --max-agents 12
```

#### Step 2: Architecture Design
```bash
# Create comprehensive architecture
npx fidgetflo@alpha swarm "design microservices architecture with event-driven communication" \
  --agents system-architect,backend-architect,frontend-architect
```

#### Step 3: Backend Development
```bash
# Develop backend services
npx fidgetflo@alpha swarm "implement user service, post service, and notification service" \
  --agents backend-dev,api-developer,database-specialist
```

#### Step 4: Frontend Development
```bash
# Create frontend applications
npx fidgetflo@alpha swarm "build React web app and React Native mobile app" \
  --agents frontend-dev,mobile-dev,ui-ux-specialist
```

#### Step 5: Testing and Quality Assurance
```bash
# Comprehensive testing
npx fidgetflo@alpha swarm "create automated test suites and perform security audit" \
  --agents tester,security-analyst,qa-specialist
```

#### Step 6: Deployment and Monitoring
```bash
# Deploy and monitor
npx fidgetflo@alpha swarm "deploy to cloud and setup monitoring" \
  --agents devops-engineer,cloud-specialist,monitoring-specialist
```

### Tutorial 3: SPARC Test-Driven Development

#### Step 1: Define Feature Requirements
```bash
# Start TDD cycle
npx fidgetflo@alpha sparc tdd "user authentication with email verification" \
  --test-framework jest \
  --coverage 95
```

#### Step 2: Write Tests First
```bash
# Create test specifications
npx fidgetflo@alpha swarm "write comprehensive test cases for authentication flow" \
  --agents test-architect,tdd-specialist
```

#### Step 3: Implement Minimal Code
```bash
# Implement just enough to pass tests
npx fidgetflo@alpha sparc code "implement minimal authentication logic to pass tests"
```

#### Step 4: Refactor and Optimize
```bash
# Improve implementation
npx fidgetflo@alpha sparc refinement "optimize authentication performance and security"
```

#### Step 5: Add Integration Tests
```bash
# Create integration tests
npx fidgetflo@alpha swarm "add integration tests for complete authentication flow" \
  --agents integration-tester,api-tester
```

---

## ⚙️ Configuration Guide

### Basic Configuration

#### Environment Variables
```bash
# Core settings
export FIDGETFLO_DEBUG=true
export FIDGETFLO_LOG_LEVEL=info
export FIDGETFLO_DATA_DIR=./data
export FIDGETFLO_MAX_AGENTS=50

# API configuration
export CLAUDE_API_KEY="your_claude_api_key"
export OPENAI_API_KEY="your_openai_api_key"
export ANTHROPIC_API_KEY="your_anthropic_api_key"

# Performance tuning
export FIDGETFLO_MEMORY_LIMIT=1024
export FIDGETFLO_TIMEOUT=300000
export FIDGETFLO_CONCURRENT_TASKS=10
```

#### Configuration File
Create `.fidgetflo.json` in your project root:

```json
{
  "orchestrator": {
    "maxConcurrentAgents": 100,
    "taskQueueSize": 1000,
    "defaultTopology": "mesh",
    "autoScaling": true,
    "timeoutMs": 300000
  },
  "memory": {
    "backend": "sqlite",
    "cacheSizeMB": 512,
    "compressionEnabled": true,
    "retentionDays": 30,
    "indexingEnabled": true
  },
  "providers": {
    "anthropic": {
      "apiKey": "${CLAUDE_API_KEY}",
      "model": "claude-3-sonnet",
      "temperature": 0.7,
      "maxTokens": 4096
    },
    "openai": {
      "apiKey": "${OPENAI_API_KEY}",
      "model": "gpt-4",
      "temperature": 0.7,
      "maxTokens": 4096
    }
  },
  "agents": {
    "defaultAgent": "coder",
    "agentProfiles": {
      "development": ["coder", "reviewer", "tester"],
      "architecture": ["architect", "planner", "system-designer"],
      "devops": ["devops-engineer", "docker-specialist", "k8s-specialist"]
    }
  },
  "swarm": {
    "defaultTopology": "mesh",
    "coordinationStrategy": "democratic",
    "faultTolerance": true,
    "loadBalancing": true
  },
  "hooks": {
    "enabled": true,
    "autoFormat": true,
    "notifications": true,
    "preTaskHooks": ["backup", "validation"],
    "postTaskHooks": ["cleanup", "metrics"]
  },
  "security": {
    "validateInputs": true,
    "sanitizeOutputs": true,
    "encryptMemory": true,
    "auditLogging": true
  },
  "performance": {
    "cacheEnabled": true,
    "compressionEnabled": true,
    "parallelExecution": true,
    "resourceLimits": {
      "maxMemoryMB": 2048,
      "maxCpuPercent": 80
    }
  }
}
```

### Advanced Configuration

#### Agent Profiles
Define custom agent combinations for specific use cases:

```json
{
  "agentProfiles": {
    "web-development": {
      "agents": ["frontend-dev", "backend-dev", "fullstack-dev"],
      "topology": "hierarchical",
      "coordination": "leader-follower"
    },
    "data-science": {
      "agents": ["ml-developer", "data-analyst", "python-specialist"],
      "topology": "mesh",
      "coordination": "collaborative"
    },
    "enterprise-security": {
      "agents": ["security-analyst", "penetration-tester", "compliance-checker"],
      "topology": "centralized",
      "coordination": "expert-led"
    }
  }
}
```

#### Custom Memory Configuration
```json
{
  "memory": {
    "backends": {
      "primary": {
        "type": "sqlite",
        "path": "./data/memory.db",
        "compression": true
      },
      "cache": {
        "type": "redis",
        "host": "localhost",
        "port": 6379,
        "ttl": 3600
      },
      "backup": {
        "type": "s3",
        "bucket": "fidgetflo-backup",
        "region": "us-east-1"
      }
    },
    "synchronization": {
      "strategy": "eventual-consistency",
      "conflictResolution": "last-write-wins",
      "replicationFactor": 3
    }
  }
}
```

#### Performance Optimization Settings
```json
{
  "performance": {
    "optimization": {
      "agentPooling": true,
      "connectionReuse": true,
      "batchProcessing": true,
      "asyncExecution": true
    },
    "monitoring": {
      "metricsEnabled": true,
      "tracingEnabled": true,
      "profilingEnabled": false,
      "alerting": {
        "cpu": 90,
        "memory": 85,
        "diskSpace": 80
      }
    },
    "scaling": {
      "autoScale": true,
      "minAgents": 2,
      "maxAgents": 50,
      "scaleUpThreshold": 80,
      "scaleDownThreshold": 30
    }
  }
}
```

### MCP Server Configuration

#### Basic MCP Setup
```bash
# Start MCP server
npx fidgetflo@alpha mcp start --port 3000

# Configure MCP tools
npx fidgetflo@alpha mcp config --tools all

# Add custom MCP server
npx fidgetflo@alpha mcp add-server \
  --name "custom-tools" \
  --command "node custom-mcp-server.js"
```

#### MCP Integration with Claude Code
```bash
# Add FidgetFlo MCP server to Claude Code
claude mcp add fidgetflo npx fidgetflo@alpha mcp start

# List available MCP tools
npx fidgetflo@alpha mcp tools --list

# Test MCP connection
npx fidgetflo@alpha mcp test --tool swarm_init
```

---

## 🔧 Troubleshooting

### Common Issues and Solutions

#### Installation Issues

**Issue: npm install fails with permission errors**
```bash
# Solution 1: Use npx instead
npx fidgetflo@alpha --help

# Solution 2: Fix npm permissions
npm config set prefix ~/.npm-global
export PATH=~/.npm-global/bin:$PATH

# Solution 3: Use node version manager
nvm install 20
nvm use 20
```

**Issue: SQLite compilation fails**
```bash
# Solution 1: Install build tools
# On Ubuntu/Debian:
sudo apt-get install build-essential python3

# On macOS:
xcode-select --install

# On Windows:
npm install --global windows-build-tools

# Solution 2: Use prebuilt binaries
npm install --no-optional
```

#### Runtime Issues

**Issue: "Agent not found" error**
```bash
# Check available agents
npx fidgetflo@alpha agents list

# Verify agent spelling
npx fidgetflo@alpha agents info coder

# Use default agent if uncertain
npx fidgetflo@alpha swarm "your task" --agent coder
```

**Issue: Memory-related errors**
```bash
# Check memory usage
npx fidgetflo@alpha memory stats

# Clear memory cache
npx fidgetflo@alpha memory clear --cache

# Optimize memory settings
npx fidgetflo@alpha config set memory.cacheSizeMB 256
```

**Issue: API rate limiting**
```bash
# Check API status
npx fidgetflo@alpha health --api

# Configure rate limiting
npx fidgetflo@alpha config set providers.anthropic.rateLimit 60

# Use multiple providers
npx fidgetflo@alpha config set providers.fallback openai
```

#### Performance Issues

**Issue: Slow task execution**
```bash
# Run diagnostics
npx fidgetflo@alpha diagnostics --performance

# Optimize configuration
npx fidgetflo@alpha optimize --auto

# Monitor real-time performance
npx fidgetflo@alpha monitor --interval 5s
```

**Issue: High memory usage**
```bash
# Check memory breakdown
npx fidgetflo@alpha memory analyze

# Enable compression
npx fidgetflo@alpha config set memory.compressionEnabled true

# Reduce cache size
npx fidgetflo@alpha config set memory.cacheSizeMB 128
```

### Debug Mode

Enable detailed logging for troubleshooting:

```bash
# Enable debug mode
export FIDGETFLO_DEBUG=true
export FIDGETFLO_LOG_LEVEL=debug

# Run with verbose output
npx fidgetflo@alpha swarm "your task" --verbose

# Generate diagnostic report
npx fidgetflo@alpha diagnostics --full --output debug-report.json
```

### Log Analysis

```bash
# View recent logs
npx fidgetflo@alpha logs --tail 100

# Filter logs by level
npx fidgetflo@alpha logs --level error

# Search logs
npx fidgetflo@alpha logs --grep "swarm"

# Export logs
npx fidgetflo@alpha logs --export logs.json
```

### Health Checks

```bash
# Comprehensive health check
npx fidgetflo@alpha health --comprehensive

# Check specific components
npx fidgetflo@alpha health --component memory
npx fidgetflo@alpha health --component agents
npx fidgetflo@alpha health --component mcp

# Automated health monitoring
npx fidgetflo@alpha health --monitor --interval 60s
```

---

## 🚀 Performance Optimization

### System Optimization

#### Hardware Recommendations

| Component | Minimum | Recommended | Optimal |
|-----------|---------|-------------|---------|
| **CPU** | 2 cores | 4 cores | 8+ cores |
| **RAM** | 4 GB | 8 GB | 16+ GB |
| **Storage** | 1 GB free | 5 GB free | 20+ GB SSD |
| **Network** | 1 Mbps | 10 Mbps | 100+ Mbps |

#### Memory Optimization

```bash
# Configure memory limits
npx fidgetflo@alpha config set memory.cacheSizeMB 512
npx fidgetflo@alpha config set memory.maxMemoryMB 2048

# Enable compression
npx fidgetflo@alpha config set memory.compressionEnabled true
npx fidgetflo@alpha config set memory.indexingEnabled true

# Set retention policies
npx fidgetflo@alpha config set memory.retentionDays 30
npx fidgetflo@alpha config set memory.autoCleanup true
```

#### Agent Pool Optimization

```bash
# Configure agent pools
npx fidgetflo@alpha config set orchestrator.maxConcurrentAgents 50
npx fidgetflo@alpha config set orchestrator.agentPoolSize 20

# Enable auto-scaling
npx fidgetflo@alpha config set swarm.autoScaling true
npx fidgetflo@alpha config set swarm.minAgents 2
npx fidgetflo@alpha config set swarm.maxAgents 100
```

### Task Optimization

#### Batch Processing
```bash
# Process multiple tasks in parallel
npx fidgetflo@alpha swarm batch \
  "create user service" \
  "create product service" \
  "create order service" \
  --parallel

# Use agent profiles for efficiency
npx fidgetflo@alpha swarm "build microservices" \
  --profile backend-development \
  --optimize-for speed
```

#### Caching Strategy
```bash
# Enable aggressive caching
npx fidgetflo@alpha config set performance.cacheEnabled true
npx fidgetflo@alpha config set performance.cacheStrategy aggressive

# Pre-warm caches
npx fidgetflo@alpha cache warm --agents common
npx fidgetflo@alpha cache warm --tools frequent
```

### Network Optimization

```bash
# Configure connection pooling
npx fidgetflo@alpha config set network.connectionPooling true
npx fidgetflo@alpha config set network.maxConnections 100

# Enable compression
npx fidgetflo@alpha config set network.compressionEnabled true
npx fidgetflo@alpha config set network.timeout 30000
```

### Monitoring and Metrics

```bash
# Real-time performance monitoring
npx fidgetflo@alpha monitor --dashboard

# Generate performance report
npx fidgetflo@alpha performance report --period 7d

# Set up performance alerts
npx fidgetflo@alpha alerts configure \
  --cpu-threshold 80 \
  --memory-threshold 85 \
  --response-time-threshold 5000
```

---

## 🔗 Integrations

### GitHub Integration

#### Setup
```bash
# Initialize GitHub integration
npx fidgetflo@alpha github init --token YOUR_GITHUB_TOKEN

# Configure repository
npx fidgetflo@alpha github config \
  --repo "username/repository" \
  --default-branch main
```

#### Common GitHub Workflows
```bash
# Pull Request Management
npx fidgetflo@alpha github pr-manager \
  "review and merge pending PRs" \
  --auto-merge \
  --require-reviews 2

# Issue Management
npx fidgetflo@alpha github issue-tracker \
  "analyze and categorize open issues" \
  --auto-label \
  --assign-to-team

# Release Management
npx fidgetflo@alpha github release-manager \
  "prepare v2.1.0 release" \
  --generate-changelog \
  --create-release-notes
```

#### Advanced GitHub Features
```bash
# Automated code review
npx fidgetflo@alpha github code-review \
  --pr-number 123 \
  --agents security-analyst,code-reviewer \
  --auto-comment

# Repository analysis
npx fidgetflo@alpha github analyze-repo \
  --metrics code-quality,security,performance \
  --generate-report
```

### Docker Integration

#### Container Management
```bash
# Containerize application
npx fidgetflo@alpha docker containerize \
  --app-type node \
  --multi-stage \
  --optimize-size

# Build and push images
npx fidgetflo@alpha docker build-push \
  --registry docker.io \
  --tags latest,v2.0.0

# Container orchestration
npx fidgetflo@alpha docker compose \
  --services api,database,redis \
  --environment production
```

### Kubernetes Integration

#### Cluster Management
```bash
# Deploy to Kubernetes
npx fidgetflo@alpha k8s deploy \
  --cluster production \
  --namespace default \
  --replicas 3

# Manage services
npx fidgetflo@alpha k8s services \
  "setup load balancer and ingress" \
  --ssl-enabled \
  --auto-scaling

# Monitor cluster
npx fidgetflo@alpha k8s monitor \
  --real-time \
  --alerts \
  --dashboard
```

### CI/CD Integration

#### GitHub Actions
```bash
# Setup CI/CD pipeline
npx fidgetflo@alpha cicd github-actions \
  "create complete CI/CD workflow" \
  --tests \
  --security-scan \
  --deploy-staging

# Custom workflows
npx fidgetflo@alpha cicd custom \
  --provider github-actions \
  --stages "lint,test,build,deploy" \
  --environments "staging,production"
```

#### Jenkins Integration
```bash
# Jenkins pipeline
npx fidgetflo@alpha cicd jenkins \
  "setup Jenkins pipeline with parallel stages" \
  --agents 4 \
  --parallel-tests
```

### Cloud Platform Integration

#### AWS Integration
```bash
# Deploy to AWS
npx fidgetflo@alpha aws deploy \
  --service ecs \
  --region us-east-1 \
  --auto-scaling

# Infrastructure as Code
npx fidgetflo@alpha aws infrastructure \
  "create complete AWS infrastructure" \
  --terraform \
  --best-practices
```

#### Azure Integration
```bash
# Azure deployment
npx fidgetflo@alpha azure deploy \
  --service app-service \
  --resource-group production \
  --scaling-rules
```

#### Google Cloud Integration
```bash
# GCP deployment
npx fidgetflo@alpha gcp deploy \
  --service cloud-run \
  --region us-central1 \
  --auto-scaling
```

---

## ❓ FAQ

### General Questions

**Q: What is FidgetFlo?**
A: FidgetFlo is an enterprise-grade AI agent orchestration platform that enables distributed AI development through swarm intelligence, featuring 54+ specialized agents and 87 MCP tools.

**Q: How is FidgetFlo different from other AI tools?**
A: FidgetFlo provides true multi-agent coordination with swarm intelligence, persistent memory management, and enterprise-grade features like security, monitoring, and scalability.

**Q: Do I need Claude Code to use FidgetFlo?**
A: While FidgetFlo can work independently, Claude Code integration provides the best experience with full MCP protocol support and seamless agent coordination.

### Installation and Setup

**Q: Which Node.js version should I use?**
A: FidgetFlo requires Node.js ≥ 20.0.0. We recommend using the latest LTS version for best performance and security.

**Q: Can I use FidgetFlo without global installation?**
A: Yes! Using `npx fidgetflo@alpha` is actually recommended as it always uses the latest version without requiring global installation.

**Q: How do I handle API key configuration?**
A: Set your API keys as environment variables or in the `.fidgetflo.json` configuration file. Never commit API keys to version control.

### Usage and Functionality

**Q: How many agents can I run simultaneously?**
A: By default, FidgetFlo can handle up to 100 concurrent agents. This can be configured based on your system resources and API limits.

**Q: Can I create custom agents?**
A: Currently, FidgetFlo provides 54+ pre-built agents. Custom agent creation is planned for a future release.

**Q: How does the memory system work?**
A: FidgetFlo uses a distributed memory system with SQLite backend by default. Memory is automatically synchronized across agents and persists between sessions.

**Q: What swarm topology should I choose?**
A: 
- **Mesh**: Best for creative collaboration and fault tolerance
- **Hierarchical**: Ideal for large, structured projects
- **Centralized**: Good for simple, sequential tasks
- **Distributed**: Perfect for parallel processing with load balancing

### Performance and Optimization

**Q: How can I improve task execution speed?**
A: Enable parallel processing, use appropriate swarm topologies, configure caching, and ensure adequate system resources.

**Q: What should I do if I hit API rate limits?**
A: Configure multiple providers, adjust rate limiting settings, or implement request batching and queuing.

**Q: How much disk space does FidgetFlo use?**
A: Base installation requires ~100MB. Memory database and cache can grow based on usage, typically 10-100MB for most projects.

### Integration and Compatibility

**Q: Can FidgetFlo work with my existing CI/CD pipeline?**
A: Yes, FidgetFlo provides integrations for GitHub Actions, Jenkins, and other CI/CD platforms.

**Q: Is FidgetFlo compatible with Docker and Kubernetes?**
A: Absolutely! FidgetFlo includes specialized agents for Docker containerization and Kubernetes orchestration.

**Q: Can I use FidgetFlo in enterprise environments?**
A: Yes, FidgetFlo is designed for enterprise use with security features, audit logging, and scalable architecture.

### Troubleshooting

**Q: What should I do if an agent fails?**
A: FidgetFlo includes automatic fault recovery. You can also check logs with `npx fidgetflo@alpha logs` and restart failed tasks.

**Q: How do I debug performance issues?**
A: Use the built-in diagnostics: `npx fidgetflo@alpha diagnostics --performance` and monitor real-time metrics.

**Q: Where can I get help if I'm stuck?**
A: Check this guide, review the comprehensive documentation, search GitHub issues, or join our Discord community.

### Advanced Features

**Q: How does SPARC methodology work?**
A: SPARC (Specification → Pseudocode → Architecture → Refinement → Code) is a structured development methodology that ensures thorough planning and high-quality implementation.

**Q: Can I use FidgetFlo for machine learning projects?**
A: Yes! FidgetFlo includes specialized ML agents for model development, training, and deployment.

**Q: How secure is FidgetFlo?**
A: FidgetFlo includes enterprise-grade security features including input validation, data encryption, audit logging, and role-based access control.

---

## 📞 Support and Community

### Getting Help

- **📖 Documentation**: [Complete Documentation](https://github.com/ruvnet/claude-flow/docs)
- **💬 Discord Community**: [Join Discord](https://discord.gg/fidgetflo)
- **🐛 Issue Tracker**: [GitHub Issues](https://github.com/ruvnet/claude-flow/issues)
- **📧 Email Support**: support@fidgetflo.ai

### Contributing

We welcome contributions! Please see our [Contributing Guide](../CONTRIBUTING.md) for details on:

- 🐛 Bug reports and fixes
- ✨ Feature requests and implementations
- 📚 Documentation improvements
- 🧪 Test coverage enhancements
- 🎨 UI/UX improvements

### Stay Updated

- 🐦 **Twitter/X**: [@claudeflow](https://twitter.com/claudeflow)
- 📰 **Blog**: [blog.fidgetflo.ai](https://blog.fidgetflo.ai)
- 📺 **YouTube**: [FidgetFlo Channel](https://youtube.com/@claudeflow)
- 🌟 **GitHub**: [Star the Repository](https://github.com/ruvnet/claude-flow)

---

<div align="center">

## 🎉 Ready to Get Started?

You now have everything you need to master FidgetFlo!

[🚀 Start Building](../README.md#-quick-start) | [📖 API Reference](API_DOCUMENTATION.md) | [🏗️ Architecture Guide](ARCHITECTURE.md)

---

**FidgetFlo User Guide v2.0.0**

*Built with ❤️ by the FidgetFlo Community*

</div>