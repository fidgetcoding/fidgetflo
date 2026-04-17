# Research Swarm Strategy

## Purpose
Deep research through parallel information gathering.

## Activation

### Using MCP Tools
```javascript
// Initialize research swarm
mcp__fidgetflo__swarm_init({
  "topology": "mesh",
  "maxAgents": 6,
  "strategy": "adaptive"
})

// Orchestrate research task
mcp__fidgetflo__task_orchestrate({
  "task": "research topic X",
  "strategy": "parallel",
  "priority": "medium"
})
```

### Using CLI (Fallback)
`npx fidgetflo swarm "research topic X" --strategy research`

## Agent Roles

### Agent Spawning with MCP
```javascript
// Spawn research agents
mcp__fidgetflo__agent_spawn({
  "type": "researcher",
  "name": "Web Researcher",
  "capabilities": ["web-search", "content-extraction", "source-validation"]
})

mcp__fidgetflo__agent_spawn({
  "type": "researcher",
  "name": "Academic Researcher",
  "capabilities": ["paper-analysis", "citation-tracking", "literature-review"]
})

mcp__fidgetflo__agent_spawn({
  "type": "analyst",
  "name": "Data Analyst",
  "capabilities": ["data-processing", "statistical-analysis", "visualization"]
})

mcp__fidgetflo__agent_spawn({
  "type": "documenter",
  "name": "Report Writer",
  "capabilities": ["synthesis", "technical-writing", "formatting"]
})
```

## Research Methods

### Information Gathering
```javascript
// Parallel information collection
mcp__fidgetflo__parallel_execute({
  "tasks": [
    { "id": "web-search", "command": "search recent publications" },
    { "id": "academic-search", "command": "search academic databases" },
    { "id": "data-collection", "command": "gather relevant datasets" }
  ]
})

// Store research findings
mcp__fidgetflo__memory_usage({
  "action": "store",
  "key": "research-findings-" + Date.now(),
  "value": JSON.stringify(findings),
  "namespace": "research",
  "ttl": 604800 // 7 days
})
```

### Analysis and Validation
```javascript
// Pattern recognition in findings
mcp__fidgetflo__pattern_recognize({
  "data": researchData,
  "patterns": ["trend", "correlation", "outlier"]
})

// Cognitive analysis
mcp__fidgetflo__cognitive_analyze({
  "behavior": "research-synthesis"
})

// Cross-reference validation
mcp__fidgetflo__quality_assess({
  "target": "research-sources",
  "criteria": ["credibility", "relevance", "recency"]
})
```

### Knowledge Management
```javascript
// Search existing knowledge
mcp__fidgetflo__memory_search({
  "pattern": "topic X",
  "namespace": "research",
  "limit": 20
})

// Create knowledge connections
mcp__fidgetflo__neural_patterns({
  "action": "learn",
  "operation": "knowledge-graph",
  "metadata": {
    "topic": "X",
    "connections": relatedTopics
  }
})
```

### Reporting
```javascript
// Generate research report
mcp__fidgetflo__workflow_execute({
  "workflowId": "research-report-generation",
  "params": {
    "findings": findings,
    "format": "comprehensive"
  }
})

// Monitor progress
mcp__fidgetflo__swarm_status({
  "swarmId": "research-swarm"
})
```
