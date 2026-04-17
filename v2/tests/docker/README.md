# Docker Validation Suite for FidgetFlo

This directory contains Docker-based testing infrastructure to validate fidgetflo functionality in a clean, isolated environment that simulates a remote deployment.

## 🎯 Purpose

- **Clean Environment Testing**: Validates installation in a fresh environment without local dependencies
- **Production Simulation**: Tests the actual user experience of installing and using fidgetflo
- **CI/CD Integration**: Can be used in automated testing pipelines
- **Cross-Platform Validation**: Tests on Linux (Alpine) to ensure portability

## 📁 Files

- `Dockerfile.test` - Main test container with Node 18 and required dependencies
- `docker-compose.test.yml` - Multi-container setup for integration testing
- `run-validation.sh` - Comprehensive validation script (50+ tests)
- `README.md` - This file

## 🚀 Quick Start

### Option 1: Build and Run Validation (Recommended)

```bash
# From project root
cd tests/docker

# Build the test container
docker build -f Dockerfile.test -t fidgetflo-test ../..

# Run validation suite
docker run --rm fidgetflo-test sh -c "cd /home/testuser && tests/docker/run-validation.sh"
```

### Option 2: Interactive Testing

```bash
# Start container with docker-compose
docker-compose -f docker-compose.test.yml up -d

# Enter the container
docker exec -it fidgetflo-test sh

# Inside container, run tests
cd /home/testuser
./tests/docker/run-validation.sh

# Or test individual commands
./bin/fidgetflo --help
./bin/fidgetflo memory store test "value"
./bin/fidgetflo agent agents
```

### Option 3: Full Integration Test Suite

```bash
# Start all services (including SQLite)
docker-compose -f docker-compose.test.yml up -d

# Run integration tests
docker-compose -f docker-compose.test.yml exec fidgetflo-integration \
  sh -c "cd /home/testuser && ./tests/docker/run-validation.sh"

# Clean up
docker-compose -f docker-compose.test.yml down -v
```

## 🧪 Test Coverage

The validation suite tests:

### Phase 1: Installation & Build
- ✅ NPM and Node.js versions
- ✅ Build completion
- ✅ Binary generation

### Phase 2: CLI Basic Commands
- ✅ Help command
- ✅ Version command
- ✅ Agent help

### Phase 3: Memory Commands (Basic Mode)
- ✅ Memory store
- ✅ Memory query
- ✅ Memory stats
- ✅ Memory list
- ✅ Memory export/import

### Phase 4: ReasoningBank Commands
- ✅ Mode detection
- ✅ Mode configuration
- ✅ Status display

### Phase 5: Agent Commands
- ✅ Agent listing
- ✅ Agent info
- ✅ Agent configuration

### Phase 6: Proxy Commands
- ✅ Proxy help
- ✅ Proxy configuration
- ✅ OpenRouter integration

### Phase 7: Help System
- ✅ Main help with all features
- ✅ Agent help with memory
- ✅ Feature discoverability

### Phase 8: Security Features
- ✅ API key redaction
- ✅ Secure storage
- ✅ Redacted queries

### Phase 9: File Structure
- ✅ Memory directory creation
- ✅ Memory store file
- ✅ Proper permissions

### Phase 10: Integration Tests
- ✅ Import/export workflows
- ✅ Namespace operations
- ✅ Error handling

## 📊 Expected Output

```
🐳 FidgetFlo Docker Validation Suite
========================================

📦 Phase 1: Installation & Build
--------------------------------
Testing: NPM install... ✓ PASS
Testing: Node version... ✓ PASS
Testing: Build completed... ✓ PASS
Testing: Binary exists... ✓ PASS

🔧 Phase 2: CLI Basic Commands
------------------------------
Testing: Help command... ✓ PASS
...

========================================
📊 Test Results Summary
========================================
Total Tests: 50
Passed: 50
Failed: 0

✅ All tests passed!
🚀 FidgetFlo is ready for production release
```

## 🔧 Troubleshooting

### Issue: Build fails in Docker

```bash
# Clean build
docker build --no-cache -f Dockerfile.test -t fidgetflo-test ../..
```

### Issue: Permission errors

```bash
# The Dockerfile uses a non-root user (testuser)
# This is intentional to simulate real user environment
# If you need root, modify the Dockerfile
```

### Issue: Tests timeout

```bash
# Increase timeout in validation script
# Or run specific test phases individually
docker exec -it fidgetflo-test ./bin/fidgetflo --help
```

## 🎯 CI/CD Integration

### GitHub Actions Example

```yaml
name: Docker Validation

on: [push, pull_request]

jobs:
  docker-test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3

      - name: Build test container
        run: |
          cd tests/docker
          docker build -f Dockerfile.test -t fidgetflo-test ../..

      - name: Run validation suite
        run: |
          docker run --rm fidgetflo-test \
            sh -c "cd /home/testuser && tests/docker/run-validation.sh"
```

## 📝 Adding New Tests

To add new validation tests, edit `run-validation.sh`:

```bash
test_command "Your test description" \
    "./bin/fidgetflo your-command" \
    "expected-output-pattern"
```

## 🌐 Multi-Platform Testing

```bash
# Build for multiple platforms
docker buildx build --platform linux/amd64,linux/arm64 \
    -f Dockerfile.test -t fidgetflo-test ../..
```

## 🔒 Security Testing

The validation suite includes security tests:
- API key redaction
- Secure storage validation
- Permission checks

## 📚 Related Documentation

- [COMMAND-VERIFICATION-REPORT.md](../../docs/COMMAND-VERIFICATION-REPORT.md)
- [INTEGRATION_COMPLETE.md](../../docs/INTEGRATION_COMPLETE.md)
- [REASONINGBANK-INTEGRATION-COMPLETE.md](../../docs/REASONINGBANK-INTEGRATION-COMPLETE.md)

## 🤝 Contributing

When adding new features to fidgetflo:
1. Add corresponding tests to `run-validation.sh`
2. Update the test coverage section in this README
3. Run full validation suite before submitting PR

## 📞 Support

For issues with Docker validation:
- Check Docker logs: `docker logs fidgetflo-test`
- Review test output for specific failures
- Open issue on GitHub with validation output
