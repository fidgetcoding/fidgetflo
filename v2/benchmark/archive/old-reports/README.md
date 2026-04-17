# FidgetFlo Benchmark System v2.0

A production-ready benchmarking system for FidgetFlo that executes **real commands** and measures **actual performance metrics**.

## 🚀 Quick Start

```bash
# Install dependencies
cd benchmark
pip install -e .

# Run real benchmark
python examples/real_swarm_benchmark.py "Build REST API"

# Run comprehensive suite
python run_real_benchmarks.py --mode comprehensive
```

## ✨ Key Features

- **Real Command Execution**: Executes actual `./fidgetflo` commands via subprocess
- **Stream JSON Parsing**: Real-time parsing of `--non-interactive --output-format stream-json`
- **Authentic Metrics**: Token usage, execution time, and resource consumption from real runs
- **No Simulations**: 100% real execution, no mocks or placeholders
- **MLE-STAR Integration**: Ensemble learning benchmarks
- **CLAUDE.md Optimizer**: Generate optimized configurations for specific use cases

## 📊 Supported Commands

### Swarm Benchmarking
```bash
./fidgetflo swarm "objective" --non-interactive --output-format stream-json
```

### Hive-Mind Benchmarking
```bash
./fidgetflo hive-mind spawn "task" --non-interactive
```

### SPARC Mode Benchmarking
```bash
./fidgetflo sparc run code "task" --non-interactive
```

## 🏗️ Architecture

```
benchmark/
├── src/swarm_benchmark/
│   ├── core/
│   │   ├── claude_flow_real_executor.py  # Real command executor
│   │   ├── real_benchmark_engine_v2.py   # Production benchmark engine
│   │   └── benchmark_engine.py           # Core engine with real support
│   ├── scenarios/
│   │   └── real_benchmarks.py            # Real benchmark scenarios
│   ├── mle_star/                         # MLE-STAR ensemble integration
│   ├── claude_optimizer/                 # CLAUDE.md optimization
│   ├── automation/                       # Batch processing & pipelines
│   └── advanced_metrics/                 # Token & performance metrics
├── examples/                              # Working examples
├── tests/                                 # Comprehensive test suite
└── tools/                                 # Utility scripts
```

## 📈 Real Metrics Captured

- **Token Usage**: Input/output tokens from Claude API
- **Execution Time**: Real command runtime
- **Agent Activity**: Spawned agents, completed tasks
- **Resource Usage**: CPU, memory, disk I/O
- **Error Rates**: Command failures and recovery
- **Consensus Metrics**: Hive-mind decision quality

## 🧪 Testing

```bash
# Quick validation
python test_real_benchmarks.py --quick

# Integration tests
pytest tests/integration/test_real_claude_flow_integration.py

# Verify real integration
python examples/verify_real_integration.py
```

## 📚 Documentation

- [API Reference](docs/api_reference.md)
- [CLAUDE.md Optimizer Guide](docs/claude_optimizer_guide.md)
- [Real Benchmarks Guide](REAL_BENCHMARKS_README.md)
- [Architecture Overview](docs/real-benchmark-architecture.md)

## 🎯 Example Usage

```python
from swarm_benchmark import BenchmarkEngine

# Create engine with real executor
engine = BenchmarkEngine(use_real_executor=True)

# Run real benchmark
result = await engine.run_real_benchmark(
    objective="Build microservices architecture",
    strategy="development",
    mode="distributed",
    max_agents=5
)

# Access real metrics
print(f"Tokens used: {result.metrics['total_tokens']}")
print(f"Execution time: {result.metrics['duration_seconds']}s")
print(f"Agents spawned: {result.metrics['agents_spawned']}")
```

## 🔧 Configuration

The system uses real FidgetFlo commands with these flags:
- `--non-interactive`: Automation mode
- `--output-format stream-json`: Structured output
- `--dangerously-skip-permissions`: Skip prompts
- `--verbose`: Detailed logging

## 📊 Performance

Validated with FidgetFlo v2.0.0-alpha.87:
- Real token usage tracking
- Actual execution timing
- Live resource monitoring
- Genuine error rates

## 🤝 Contributing

This is a production system designed for real benchmarking. All contributions must:
1. Use real FidgetFlo commands
2. Parse actual responses
3. Measure genuine metrics
4. Include comprehensive tests

## 📄 License

MIT License - See LICENSE file for details

---

**Version**: 2.0.0  
**Status**: Production Ready  
**Real Execution**: Yes  
**Simulations**: None