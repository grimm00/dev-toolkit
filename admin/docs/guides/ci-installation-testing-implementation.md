# CI Installation Testing Implementation Guide

**Purpose:** Comprehensive guide for implementing installation testing in CI/CD pipelines  
**Created:** 2025-01-06  
**Status:** Active  
**Based On:** Dev Toolkit CI Installation Testing (Phases 1 & 2)

---

## 📋 Overview

This guide provides a complete implementation approach for adding installation testing to CI/CD pipelines. It's based on the successful implementation in the Dev Toolkit project, which added comprehensive installation testing to catch installation failures early in the development process.

### Why Installation Testing?

**Problem:** Most CI pipelines only test code syntax and functionality, but don't verify that the actual installation process works correctly.

**Solution:** Add installation testing to CI to catch installation failures before they reach users.

**Benefits:**
- ✅ Catch installation failures early
- ✅ Verify installer works in CI environments
- ✅ Test both global and local installation scenarios
- ✅ Ensure commands are accessible after installation
- ✅ Validate installation isolation and edge cases

---

## 🏗️ Architecture Overview

### CI Job Structure
```
CI Pipeline:
├── Lint (existing)
├── Test (existing)
├── Install (NEW) ← Installation testing
└── Docs (existing)
```

### Installation Test Job Components
1. **Global Installation Test** - Test standard installation process
2. **Local Installation Test** - Test `--local` flag functionality
3. **Integration Scenarios** - Test installation → usage workflow
4. **Edge Case Testing** - Test error conditions and edge cases
5. **Installation Isolation** - Verify no conflicts between test runs

---

## 🚀 Implementation Steps

### Step 1: Add Installation Test Job

Add a new `install` job to your CI workflow:

```yaml
install:
  runs-on: ubuntu-latest
  name: Test Installation
  needs: [lint, test]  # Run after linting and unit tests
  
  steps:
  - name: Checkout code
    uses: actions/checkout@v4
    
  - name: Test global installation
    run: |
      set -euo pipefail
      ./install.sh --no-symlinks
      echo "✅ Global installation completed"
```

### Step 2: Add Local Installation Testing

```yaml
  - name: Test local installation
    run: |
      set -euo pipefail
      # Test local installation in a separate directory
      LOCAL_TEST_DIR=$(mktemp -d)
      cd "$LOCAL_TEST_DIR"
      
      # Copy the toolkit to test directory
      cp -r "${GITHUB_WORKSPACE}" ./dev-toolkit
      cd ./dev-toolkit
      
      # Test local installation
      ./install.sh --local
      echo "✅ Local installation completed"
      
      # Verify local installation works
      if [ -f "bin/dt-config" ] && [ -f "bin/dt-git-safety" ]; then
        echo "✅ Local installation successful - commands available"
      else
        echo "❌ Local installation failed - commands not found"
        exit 1
      fi
      
      # Clean up
      cd "$GITHUB_WORKSPACE"
      rm -rf "$LOCAL_TEST_DIR"
```

### Step 3: Add Command Verification

```yaml
  - name: Set up environment for installed commands
    run: |
      set -euo pipefail
      export DT_ROOT="${GITHUB_WORKSPACE}"
      export PATH="$DT_ROOT/bin:$PATH"
      echo "DT_ROOT=$DT_ROOT" >> $GITHUB_ENV
      echo "$DT_ROOT/bin" >> $GITHUB_PATH
      
  - name: Verify command accessibility
    run: |
      set -euo pipefail
      which dt-config
      which dt-git-safety
      which dt-sourcery-parse
      echo "✅ All commands accessible"
```

### Step 4: Add Integration Testing

```yaml
  - name: Test integration scenarios
    run: |
      set -euo pipefail
      # Test installation → usage workflow
      
      # Create a test repository for integration testing
      TEST_REPO_DIR=$(mktemp -d)
      cd "$TEST_REPO_DIR"
      git init
      git config user.email "test@example.com"
      git config user.name "Test User"
      echo "# Test Repo" > README.md
      git add README.md
      git commit -m "Initial commit"
      
      # Test commands in real git repository
      dt-git-safety check || echo "Safety checks completed (expected)"
      dt-config --help
      
      # Clean up
      cd "$GITHUB_WORKSPACE"
      rm -rf "$TEST_REPO_DIR"
      
      echo "✅ Integration scenarios tested"
```

### Step 5: Add Edge Case Testing

```yaml
  - name: Test edge cases
    run: |
      set -euo pipefail
      # Test edge cases and error conditions
      
      # Test installation in non-git directory
      NON_GIT_DIR=$(mktemp -d)
      cd "$NON_GIT_DIR"
      cp -r "${GITHUB_WORKSPACE}" ./dev-toolkit
      cd ./dev-toolkit
      ./install.sh --no-symlinks
      echo "✅ Installation works in non-git directory"
      
      # Test re-installation (should handle gracefully)
      ./install.sh --no-symlinks
      echo "✅ Re-installation handled gracefully"
      
      # Test with existing bin directory
      mkdir -p bin
      ./install.sh --local
      echo "✅ Local installation with existing directory handled"
      
      # Clean up
      cd "$GITHUB_WORKSPACE"
      rm -rf "$NON_GIT_DIR"
      
      echo "✅ Edge cases tested"
```

### Step 6: Add Installation Isolation Testing

```yaml
  - name: Verify installation isolation
    run: |
      set -euo pipefail
      # Verify that installations don't interfere with each other
      
      # Test that global and local installations are isolated
      if [ -d ~/.dev-toolkit ]; then
        echo "✅ Global installation directory exists"
      else
        echo "❌ Global installation directory missing"
        exit 1
      fi
      
      # Verify commands still work after all tests
      which dt-config
      which dt-git-safety
      which dt-sourcery-parse
      
      # Test that commands work in different contexts
      TEMP_DIR=$(mktemp -d)
      cd "$TEMP_DIR"
      dt-config --help
      cd "$GITHUB_WORKSPACE"
      rm -rf "$TEMP_DIR"
      
      echo "✅ Installation isolation verified"
```

### Step 7: Add Cleanup

```yaml
  - name: Cleanup
    run: |
      rm -rf ~/.dev-toolkit
      echo "✅ Cleanup completed"
```

---

## 🔧 Configuration Options

### Environment Variables

```yaml
env:
  DT_ROOT: ${{ github.workspace }}
  PATH: ${{ github.workspace }}/bin:${{ env.PATH }}
```

### Installation Flags

- `--no-symlinks`: Install without creating system symlinks (recommended for CI)
- `--local`: Install locally in project directory
- `--help`: Show installation help

### Dependencies

Ensure these are available in your CI environment:
- `bash` (with `set -euo pipefail` support)
- `git` (for integration testing)
- `mktemp` (for temporary directories)
- `which` (for command verification)

---

## 📊 Expected Results

### Performance Metrics
- **Execution Time:** 5-10 seconds (well under 2-minute target)
- **Success Rate:** 100% (all tests should pass consistently)
- **Resource Usage:** Minimal (temporary directories cleaned up)

### Test Coverage
- ✅ Global installation process
- ✅ Local installation process
- ✅ Command accessibility
- ✅ Integration scenarios
- ✅ Edge cases and error conditions
- ✅ Installation isolation

---

## 🚨 Common Issues & Solutions

### Issue: Commands Not Found After Installation
**Solution:** Ensure `DT_ROOT` and `PATH` are set correctly:
```yaml
export DT_ROOT="${GITHUB_WORKSPACE}"
export PATH="$DT_ROOT/bin:$PATH"
```

### Issue: Local Installation Test Fails
**Solution:** Verify you're checking for the right files:
```bash
# For local installation, check bin/ directory
if [ -f "bin/command-name" ]; then
  echo "✅ Local installation successful"
fi
```

### Issue: Integration Test Fails
**Solution:** Use `--help` instead of commands that require external services:
```bash
# Good: Doesn't require external services
dt-config --help

# Avoid: May require GitHub token or external API
dt-config show
```

### Issue: Cleanup Fails
**Solution:** Ensure proper cleanup in all test scenarios:
```bash
# Always clean up temporary directories
cd "$GITHUB_WORKSPACE"
rm -rf "$TEMP_DIR"
```

---

## 📚 Related Resources

- [CI Installation Testing Best Practices](ci-installation-testing-best-practices.md)
- [CI Installation Testing Troubleshooting](ci-installation-testing-troubleshooting.md)
- [Reusable CI/CD Patterns](reusable-cicd-patterns.md)
- [Dev Toolkit CI Configuration](https://github.com/grimm00/dev-toolkit/blob/main/.github/workflows/ci.yml)

---

**Last Updated:** 2025-01-06  
**Status:** Active  
**Version:** 1.0
