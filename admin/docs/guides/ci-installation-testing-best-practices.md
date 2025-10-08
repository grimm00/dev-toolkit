# CI Installation Testing Best Practices

**Purpose:** Best practices and patterns for implementing robust installation testing in CI/CD pipelines  
**Created:** 2025-01-06  
**Status:** Active  
**Based On:** Dev Toolkit CI Installation Testing (Phases 1 & 2)

---

## 🎯 Core Principles

### 1. Test Real Installation Scenarios
**Do:** Test the actual installation process that users will experience
**Don't:** Only test code syntax or mock installation steps

```yaml
# ✅ Good: Test actual installation
- name: Test global installation
  run: |
    ./install.sh --no-symlinks
    which command-name

# ❌ Avoid: Mocking installation
- name: Mock installation
  run: |
    echo "Installation would work here"
```

### 2. Test Both Global and Local Installations
**Do:** Verify both installation modes work correctly
**Don't:** Only test one installation method

```yaml
# ✅ Good: Test both modes
- name: Test global installation
  run: ./install.sh --no-symlinks

- name: Test local installation
  run: ./install.sh --local
```

### 3. Verify Command Accessibility
**Do:** Test that installed commands are actually accessible
**Don't:** Assume installation success means commands work

```yaml
# ✅ Good: Verify commands work
- name: Verify command accessibility
  run: |
    which command-name
    command-name --help
    command-name actual-functionality
```

### 4. Test Integration Scenarios
**Do:** Test installation → usage workflow
**Don't:** Only test installation in isolation

```yaml
# ✅ Good: Test real usage
- name: Test integration scenarios
  run: |
    # Create test environment
    git init
    # Test command in real context
    command-name check
```

---

## 🏗️ Architecture Patterns

### Pattern 1: Isolated Test Environments
Use temporary directories to avoid conflicts between test runs.

```yaml
- name: Test in isolated environment
  run: |
    set -euo pipefail
    TEST_DIR=$(mktemp -d)
    cd "$TEST_DIR"
    # Run tests
    cd "$GITHUB_WORKSPACE"
    rm -rf "$TEST_DIR"
```

### Pattern 2: Environment Variable Management
Properly set up environment variables for installed commands.

```yaml
- name: Set up environment
  run: |
    export TOOL_ROOT="${GITHUB_WORKSPACE}"
    export PATH="$TOOL_ROOT/bin:$PATH"
    echo "TOOL_ROOT=$TOOL_ROOT" >> $GITHUB_ENV
    echo "$TOOL_ROOT/bin" >> $GITHUB_PATH
```

### Pattern 3: Comprehensive Cleanup
Always clean up temporary resources to avoid conflicts.

```yaml
- name: Cleanup
  run: |
    rm -rf ~/.toolkit
    rm -rf /tmp/toolkit-test-*
    echo "✅ Cleanup completed"
```

---

## 🔧 Implementation Patterns

### Pattern 1: Progressive Testing
Start with basic tests and add complexity progressively.

```yaml
# Phase 1: Basic installation
- name: Test basic installation
  run: ./install.sh

# Phase 2: Command verification
- name: Verify commands
  run: which command-name

# Phase 3: Integration testing
- name: Test integration
  run: command-name actual-functionality
```

### Pattern 2: Error Handling
Use strict error handling to catch issues early.

```yaml
- name: Test with error handling
  run: |
    set -euo pipefail  # Exit on error, undefined vars, pipe failures
    ./install.sh
    if ! which command-name; then
      echo "❌ Command not found after installation"
      exit 1
    fi
```

### Pattern 3: Conditional Testing
Skip tests that require external services in CI.

```yaml
- name: Test commands
  run: |
    # Use --help instead of commands requiring external services
    command-name --help
    
    # Or test with mock data
    if [ -n "${GITHUB_TOKEN:-}" ]; then
      command-name show
    else
      echo "Skipping external service test in CI"
    fi
```

---

## 📊 Performance Optimization

### 1. Minimize Test Execution Time
Keep installation tests fast to avoid slowing down CI.

```yaml
# ✅ Good: Fast, focused tests
- name: Quick installation test
  run: |
    ./install.sh --no-symlinks
    which command-name
    command-name --help

# ❌ Avoid: Slow, comprehensive tests in CI
- name: Full integration test
  run: |
    ./install.sh
    # Run full test suite (save for local testing)
```

### 2. Use Appropriate Installation Flags
Choose installation flags that work well in CI environments.

```yaml
# ✅ Good: CI-optimized installation
- name: Install for CI
  run: ./install.sh --no-symlinks

# ❌ Avoid: System-wide installation in CI
- name: Install system-wide
  run: sudo ./install.sh
```

### 3. Parallel Testing
Run independent tests in parallel when possible.

```yaml
# ✅ Good: Parallel execution
install-global:
  runs-on: ubuntu-latest
  steps: [global installation tests]

install-local:
  runs-on: ubuntu-latest
  steps: [local installation tests]
```

---

## 🚨 Error Handling Best Practices

### 1. Clear Error Messages
Provide actionable error messages when tests fail.

```yaml
- name: Test installation
  run: |
    if ! ./install.sh; then
      echo "❌ Installation failed"
      echo "Check install.sh script and dependencies"
      exit 1
    fi
```

### 2. Graceful Degradation
Handle expected failures gracefully.

```yaml
- name: Test optional features
  run: |
    # This might fail in CI, which is OK
    command-name optional-feature || echo "Optional feature not available in CI"
```

### 3. Comprehensive Logging
Log important information for debugging.

```yaml
- name: Test with logging
  run: |
    echo "Testing installation in: $(pwd)"
    echo "Environment: $GITHUB_WORKSPACE"
    ./install.sh
    echo "Installation completed successfully"
```

---

## 🔄 Maintenance Patterns

### 1. Regular Validation
Periodically validate that installation tests still work.

```yaml
# Add to your CI
- name: Validate installation tests
  run: |
    # Test the installation test itself
    ./test-installation.sh
```

### 2. Version Compatibility
Test installation with different versions of dependencies.

```yaml
strategy:
  matrix:
    bash-version: [4.4, 5.0, 5.1]
    git-version: [2.30, 2.31, 2.32]
```

### 3. Documentation Updates
Keep installation test documentation in sync with implementation.

```yaml
# Add documentation validation
- name: Validate documentation
  run: |
    # Check that docs match implementation
    grep -q "install.sh" docs/installation.md
```

---

## 📈 Monitoring and Metrics

### 1. Track Test Performance
Monitor installation test execution time.

```yaml
- name: Track performance
  run: |
    start_time=$(date +%s)
    ./install.sh
    end_time=$(date +%s)
    echo "Installation took $((end_time - start_time)) seconds"
```

### 2. Success Rate Monitoring
Track installation test success rates over time.

```yaml
- name: Record success
  run: |
    echo "Installation test: SUCCESS" >> test-results.log
    echo "Date: $(date)" >> test-results.log
```

### 3. Resource Usage
Monitor resource usage during installation tests.

```yaml
- name: Monitor resources
  run: |
    df -h  # Check disk space
    free -h  # Check memory
    ./install.sh
```

---

## 🎯 Quality Gates

### 1. Installation Success Rate
- **Target:** 100% success rate
- **Measurement:** All installation tests must pass
- **Action:** Fix any failing installation tests immediately

### 2. Execution Time
- **Target:** < 2 minutes total
- **Measurement:** Monitor CI job execution time
- **Action:** Optimize slow tests

### 3. Resource Usage
- **Target:** Minimal resource consumption
- **Measurement:** Monitor disk, memory, CPU usage
- **Action:** Optimize resource-heavy operations

---

## 📚 Related Resources

- [CI Installation Testing Implementation Guide](ci-installation-testing-implementation.md)
- [CI Installation Testing Troubleshooting](ci-installation-testing-troubleshooting.md)
- [Reusable CI/CD Patterns](reusable-cicd-patterns.md)
- [Dev Toolkit CI Configuration](https://github.com/grimm00/dev-toolkit/blob/main/.github/workflows/ci.yml)

---

**Last Updated:** 2025-01-06  
**Status:** Active  
**Version:** 1.0
