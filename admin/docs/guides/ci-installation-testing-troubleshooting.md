# CI Installation Testing Troubleshooting Guide

**Purpose:** Comprehensive troubleshooting guide for CI installation testing issues  
**Created:** 2025-01-06  
**Status:** Active  
**Based On:** Dev Toolkit CI Installation Testing (Phases 1 & 2)

---

## 🚨 Common Issues & Solutions

### Issue 1: Commands Not Found After Installation

**Symptoms:**
```
which: command-name: not found
./install.sh: line 45: command-name: command not found
```

**Root Causes:**
- Environment variables not set correctly
- PATH not updated
- Installation failed silently
- Commands installed in wrong location

**Solutions:**

#### Solution 1: Check Environment Variables
```yaml
- name: Debug environment
  run: |
    echo "DT_ROOT: $DT_ROOT"
    echo "PATH: $PATH"
    echo "Current directory: $(pwd)"
    ls -la bin/
```

#### Solution 2: Verify Installation Location
```yaml
- name: Check installation
  run: |
    if [ -d ~/.toolkit ]; then
      echo "✅ Global installation directory exists"
      ls -la ~/.toolkit/bin/
    else
      echo "❌ Global installation directory missing"
    fi
```

#### Solution 3: Set Environment Correctly
```yaml
- name: Set environment properly
  run: |
    export TOOL_ROOT="${GITHUB_WORKSPACE}"
    export PATH="$TOOL_ROOT/bin:$PATH"
    echo "TOOL_ROOT=$TOOL_ROOT" >> $GITHUB_ENV
    echo "$TOOL_ROOT/bin" >> $GITHUB_PATH
```

---

### Issue 2: Local Installation Test Fails

**Symptoms:**
```
❌ Local .dev-toolkit directory not found
❌ Local installation failed - commands not found
```

**Root Causes:**
- Local installation doesn't create expected directory structure
- Wrong verification logic
- Installation script behavior differs from expectations

**Solutions:**

#### Solution 1: Check Actual Local Installation Behavior
```yaml
- name: Debug local installation
  run: |
    ./install.sh --local
    echo "Contents after local installation:"
    ls -la
    echo "Bin directory contents:"
    ls -la bin/ || echo "No bin directory"
```

#### Solution 2: Fix Verification Logic
```yaml
# ✅ Correct: Check for actual files created
- name: Verify local installation
  run: |
    if [ -f "bin/command-name" ]; then
      echo "✅ Local installation successful - commands available"
    else
      echo "❌ Local installation failed - commands not found"
      exit 1
    fi
```

#### Solution 3: Use Correct Installation Flags
```yaml
- name: Test local installation correctly
  run: |
    # For local installation, don't expect .dev-toolkit directory
    ./install.sh --local
    # Check for commands in current directory
    test -f "bin/command-name"
```

---

### Issue 3: Integration Test Fails

**Symptoms:**
```
dt-config show: Error: Cannot locate dev-toolkit installation
GitHub API rate limit exceeded
```

**Root Causes:**
- Commands require external services not available in CI
- Missing authentication tokens
- Network connectivity issues

**Solutions:**

#### Solution 1: Use Commands That Don't Require External Services
```yaml
# ✅ Good: Use --help instead of show
- name: Test integration
  run: |
    dt-config --help
    dt-git-safety --help

# ❌ Avoid: Commands requiring external services
- name: Test integration
  run: |
    dt-config show  # Requires GitHub token
```

#### Solution 2: Mock External Dependencies
```yaml
- name: Test with mocked dependencies
  run: |
    # Mock external service responses
    export GITHUB_TOKEN="mock-token"
    dt-config show || echo "Expected to fail in CI without real token"
```

#### Solution 3: Skip External Service Tests in CI
```yaml
- name: Test integration
  run: |
    if [ -n "${GITHUB_TOKEN:-}" ]; then
      dt-config show
    else
      echo "Skipping external service test in CI"
      dt-config --help
    fi
```

---

### Issue 4: Edge Case Tests Fail

**Symptoms:**
```
❌ Installation works in non-git directory
❌ Re-installation handled gracefully
```

**Root Causes:**
- Installation script doesn't handle edge cases
- Test logic doesn't match actual behavior
- Environment differences between test scenarios

**Solutions:**

#### Solution 1: Debug Edge Case Behavior
```yaml
- name: Debug edge cases
  run: |
    echo "Testing in non-git directory:"
    NON_GIT_DIR=$(mktemp -d)
    cd "$NON_GIT_DIR"
    cp -r "${GITHUB_WORKSPACE}" ./toolkit
    cd ./toolkit
    ./install.sh --no-symlinks
    echo "Result: $?"
    cd "$GITHUB_WORKSPACE"
    rm -rf "$NON_GIT_DIR"
```

#### Solution 2: Adjust Test Expectations
```yaml
- name: Test edge cases with correct expectations
  run: |
    # Test re-installation (should work, not fail)
    ./install.sh --no-symlinks
    ./install.sh --no-symlinks  # This should succeed
    echo "✅ Re-installation handled gracefully"
```

#### Solution 3: Handle Expected Failures
```yaml
- name: Test edge cases
  run: |
    # Some edge cases might fail, which is OK
    ./install.sh --invalid-flag || echo "Expected failure with invalid flag"
```

---

### Issue 5: Installation Isolation Test Fails

**Symptoms:**
```
❌ Global installation directory missing
❌ Installation isolation verified
```

**Root Causes:**
- Global installation not working
- Environment variables not persisting
- Cleanup happening too early

**Solutions:**

#### Solution 1: Check Global Installation
```yaml
- name: Debug global installation
  run: |
    ./install.sh --no-symlinks
    echo "Checking global installation:"
    ls -la ~/.toolkit/ || echo "No global installation found"
    which command-name || echo "Command not in PATH"
```

#### Solution 2: Fix Environment Persistence
```yaml
- name: Set environment for all steps
  run: |
    export TOOL_ROOT="${GITHUB_WORKSPACE}"
    export PATH="$TOOL_ROOT/bin:$PATH"
    echo "TOOL_ROOT=$TOOL_ROOT" >> $GITHUB_ENV
    echo "$TOOL_ROOT/bin" >> $GITHUB_PATH
```

#### Solution 3: Verify Isolation After All Tests
```yaml
- name: Verify isolation at the end
  run: |
    # Run this after all other tests
    if [ -d ~/.toolkit ]; then
      echo "✅ Global installation still exists"
    fi
    which command-name && echo "✅ Commands still accessible"
```

---

### Issue 6: Cleanup Fails

**Symptoms:**
```
rm: cannot remove '/tmp/tmp.xyz': No such file or directory
rm: cannot remove '~/.toolkit': Permission denied
```

**Root Causes:**
- Temporary directories already cleaned up
- Permission issues
- Path resolution problems

**Solutions:**

#### Solution 1: Safe Cleanup
```yaml
- name: Safe cleanup
  run: |
    # Clean up only if directories exist
    [ -d ~/.toolkit ] && rm -rf ~/.toolkit || true
    [ -d "$TEMP_DIR" ] && rm -rf "$TEMP_DIR" || true
    echo "✅ Cleanup completed"
```

#### Solution 2: Use Absolute Paths
```yaml
- name: Cleanup with absolute paths
  run: |
    cd "$GITHUB_WORKSPACE"  # Ensure we're in the right directory
    rm -rf ~/.toolkit
    echo "✅ Cleanup completed"
```

#### Solution 3: Handle Permission Issues
```yaml
- name: Cleanup with error handling
  run: |
    rm -rf ~/.toolkit 2>/dev/null || echo "Cleanup completed (some files may remain)"
```

---

## 🔍 Debugging Techniques

### 1. Enable Verbose Logging
```yaml
- name: Debug with verbose output
  run: |
    set -x  # Enable debug mode
    ./install.sh --no-symlinks
    set +x  # Disable debug mode
```

### 2. Check Environment State
```yaml
- name: Debug environment
  run: |
    echo "=== Environment Debug ==="
    echo "PWD: $(pwd)"
    echo "PATH: $PATH"
    echo "HOME: $HOME"
    echo "GITHUB_WORKSPACE: $GITHUB_WORKSPACE"
    echo "=== File System ==="
    ls -la
    echo "=== Global Installation ==="
    ls -la ~/.toolkit/ 2>/dev/null || echo "No global installation"
```

### 3. Test Individual Components
```yaml
- name: Test components individually
  run: |
    echo "Testing installation script:"
    ./install.sh --help
    
    echo "Testing command availability:"
    which command-name || echo "Command not found"
    
    echo "Testing command functionality:"
    command-name --help || echo "Command help failed"
```

### 4. Compare Local vs CI Behavior
```yaml
- name: Compare environments
  run: |
    echo "=== CI Environment ==="
    uname -a
    bash --version
    git --version
    echo "=== Installation Test ==="
    ./install.sh --no-symlinks
```

---

## 📊 Performance Issues

### Issue: Installation Tests Take Too Long

**Symptoms:**
- CI job takes > 2 minutes
- Timeout errors
- Resource exhaustion

**Solutions:**

#### Solution 1: Optimize Installation Process
```yaml
- name: Fast installation test
  run: |
    # Use minimal installation flags
    ./install.sh --no-symlinks --minimal
    # Test only essential commands
    which command-name
    command-name --help
```

#### Solution 2: Parallel Testing
```yaml
# Split into parallel jobs
install-global:
  runs-on: ubuntu-latest
  steps: [global installation tests]

install-local:
  runs-on: ubuntu-latest
  steps: [local installation tests]
```

#### Solution 3: Skip Non-Essential Tests
```yaml
- name: Essential tests only
  run: |
    # Skip comprehensive testing in CI
    ./install.sh --no-symlinks
    which command-name
    # Skip integration tests in CI
```

---

## 🚨 Emergency Procedures

### If All Installation Tests Fail

1. **Check Installation Script**
   ```bash
   # Test locally first
   ./install.sh --help
   ./install.sh --no-symlinks
   ```

2. **Verify Dependencies**
   ```bash
   # Check required tools
   bash --version
   git --version
   which mktemp
   ```

3. **Test Minimal Installation**
   ```bash
   # Try minimal installation
   ./install.sh --minimal
   ```

4. **Disable Installation Tests Temporarily**
   ```yaml
   # Comment out install job temporarily
   # install:
   #   runs-on: ubuntu-latest
   #   steps: [...]
   ```

### If CI Becomes Unstable

1. **Revert to Previous Working Version**
   ```bash
   git revert <commit-hash>
   ```

2. **Disable Problematic Tests**
   ```yaml
   - name: Skip problematic test
     run: |
       echo "Skipping test due to instability"
       # ./problematic-test.sh
   ```

3. **Use Simpler Test Approach**
   ```yaml
   - name: Simple installation test
     run: |
       ./install.sh --no-symlinks
       echo "Installation completed"
   ```

---

## 📚 Related Resources

- [CI Installation Testing Implementation Guide](ci-installation-testing-implementation.md)
- [CI Installation Testing Best Practices](ci-installation-testing-best-practices.md)
- [Reusable CI/CD Patterns](reusable-cicd-patterns.md)
- [Dev Toolkit CI Configuration](https://github.com/grimm00/dev-toolkit/blob/main/.github/workflows/ci.yml)

---

**Last Updated:** 2025-01-06  
**Status:** Active  
**Version:** 1.0
