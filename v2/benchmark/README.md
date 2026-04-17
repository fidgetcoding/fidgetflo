# FidgetFlo Benchmark System v2.0

Production-ready benchmarking for FidgetFlo with **real command execution** and **authentic metrics**.

## Quick Start

```bash
cd benchmark
pip install -e .

# Run real benchmark
python examples/real_swarm_benchmark.py "Build REST API"
```

## Features

- ✅ **Real Execution**: Actual `./fidgetflo` commands via subprocess
- ✅ **Stream JSON**: Parses `--non-interactive --output-format stream-json`
- ✅ **Authentic Metrics**: Real tokens, timing, and resource usage
- ✅ **No Mocks**: 100% genuine execution

## Supported Commands

```bash
./fidgetflo swarm "task" --non-interactive --output-format stream-json
./fidgetflo hive-mind spawn "task" --non-interactive
./fidgetflo sparc run code "task" --non-interactive
```

## Usage

```python
from swarm_benchmark import BenchmarkEngine

engine = BenchmarkEngine(use_real_executor=True)
result = await engine.run_real_benchmark("Build microservices")
print(f"Tokens: {result.metrics['total_tokens']}")
```

## Testing

```bash
pytest tests/
python examples/verify_real_integration.py
```

---

**Version**: 2.0.0 | **Status**: Production Ready | **Real**: Yes | **Mocks**: None