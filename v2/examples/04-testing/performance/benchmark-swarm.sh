#!/bin/bash
# Performance Benchmark - Swarm Execution Times

echo "⚡ FidgetFlo Performance Benchmark"
echo "==================================="
echo ""

cd "$(dirname "$0")/../.."

# Benchmark configuration
ITERATIONS=3
declare -A BENCHMARKS

# Timer functions
start_timer() {
    START_TIME=$(date +%s.%N)
}

end_timer() {
    END_TIME=$(date +%s.%N)
    ELAPSED=$(echo "$END_TIME - $START_TIME" | bc)
    echo "$ELAPSED"
}

# Benchmark function
benchmark() {
    local test_name=$1
    local command=$2
    local iterations=${3:-$ITERATIONS}
    
    echo "🏃 Benchmarking: $test_name"
    echo "   Command: $command"
    echo -n "   Running $iterations iterations: "
    
    local total_time=0
    local times=()
    
    for i in $(seq 1 $iterations); do
        echo -n "."
        start_timer
        eval "$command" >/dev/null 2>&1
        local elapsed=$(end_timer)
        times+=($elapsed)
        total_time=$(echo "$total_time + $elapsed" | bc)
    done
    
    echo " Done!"
    
    # Calculate statistics
    local avg_time=$(echo "scale=3; $total_time / $iterations" | bc)
    local min_time=$(printf '%s\n' "${times[@]}" | sort -n | head -1)
    local max_time=$(printf '%s\n' "${times[@]}" | sort -n | tail -1)
    
    BENCHMARKS["$test_name"]="avg=$avg_time|min=$min_time|max=$max_time"
    
    echo "   📊 Results: Avg: ${avg_time}s, Min: ${min_time}s, Max: ${max_time}s"
    echo ""
}

echo "🔧 System Information:"
echo "   CPU: $(nproc) cores"
echo "   Memory: $(free -h | awk '/^Mem:/ {print $2}')"
echo "   OS: $(uname -s) $(uname -r)"
echo ""

echo "📋 Starting benchmarks..."
echo ""

# Benchmark 1: Simple task execution
benchmark "Simple Task" \
    "../fidgetflo task 'Write hello world to file' --output /tmp/bench_simple"

# Benchmark 2: Memory operations
benchmark "Memory Store/Query" \
    "../fidgetflo memory store bench_key 'test data' && ../fidgetflo memory query bench_key"

# Benchmark 3: Small swarm
benchmark "Small Swarm (2 agents)" \
    "../fidgetflo swarm create 'Create simple calculator' --agents 2 --output /tmp/bench_swarm_small"

# Benchmark 4: Medium swarm
benchmark "Medium Swarm (5 agents)" \
    "../fidgetflo swarm create 'Create TODO app' --agents 5 --output /tmp/bench_swarm_medium" \
    2

# Benchmark 5: SPARC mode
benchmark "SPARC TDD Mode" \
    "../fidgetflo sparc run tdd 'Create add function' --output /tmp/bench_sparc" \
    2

# Benchmark 6: Workflow orchestration
if [[ -f "./02-workflows/simple/hello-world-workflow.json" ]]; then
    benchmark "Workflow Orchestration" \
        "../fidgetflo orchestrate ./02-workflows/simple/hello-world-workflow.json --output /tmp/bench_workflow" \
        2
fi

# Performance Analysis
echo "📈 Performance Analysis"
echo "====================="
echo ""

# Find fastest and slowest operations
fastest_time=999999
slowest_time=0
fastest_op=""
slowest_op=""

for op in "${!BENCHMARKS[@]}"; do
    IFS='|' read -ra STATS <<< "${BENCHMARKS[$op]}"
    avg_time=$(echo "${STATS[0]}" | cut -d'=' -f2)
    
    if (( $(echo "$avg_time < $fastest_time" | bc -l) )); then
        fastest_time=$avg_time
        fastest_op=$op
    fi
    
    if (( $(echo "$avg_time > $slowest_time" | bc -l) )); then
        slowest_time=$avg_time
        slowest_op=$op
    fi
done

echo "🚀 Fastest Operation: $fastest_op (${fastest_time}s avg)"
echo "🐌 Slowest Operation: $slowest_op (${slowest_time}s avg)"
echo ""

# Performance recommendations
echo "💡 Performance Insights:"
echo ""

if (( $(echo "$slowest_time > 10" | bc -l) )); then
    echo "⚠️  Some operations are taking >10s. Consider:"
    echo "   - Using --background flag for long operations"
    echo "   - Reducing agent count for simple tasks"
    echo "   - Using simpler models for basic operations"
else
    echo "✅ All operations completed in reasonable time (<10s)"
fi

if (( $(echo "$fastest_time < 1" | bc -l) )); then
    echo "✅ Simple operations are very fast (<1s)"
else
    echo "ℹ️  Even simple operations take >1s - check system resources"
fi

# Memory usage estimate
echo ""
echo "💾 Resource Usage:"
MEMORY_BEFORE=$(free -m | awk '/^Mem:/ {print $3}')
../fidgetflo swarm create "Test memory usage" --agents 5 --output /tmp/bench_memory >/dev/null 2>&1 &
SWARM_PID=$!
sleep 3
MEMORY_DURING=$(free -m | awk '/^Mem:/ {print $3}')
kill $SWARM_PID 2>/dev/null
wait $SWARM_PID 2>/dev/null

MEMORY_USED=$((MEMORY_DURING - MEMORY_BEFORE))
echo "   Estimated memory per swarm: ~${MEMORY_USED}MB"

# Cleanup
echo ""
echo "🧹 Cleaning up benchmark files..."
rm -rf /tmp/bench_*
../fidgetflo memory delete bench_key >/dev/null 2>&1

echo ""
echo "✅ Benchmark complete!"