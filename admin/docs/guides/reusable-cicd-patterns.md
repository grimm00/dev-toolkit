# Reusable CI/CD Patterns

**Purpose:** Reusable patterns and templates for CI/CD installation testing  
**Created:** 2025-01-06  
**Status:** Active  
**Based On:** Dev Toolkit CI Installation Testing (Phases 1 & 2)

---

## 📋 Overview

This document provides reusable patterns and templates that can be adapted for different projects and CI/CD systems. These patterns are based on the successful implementation in the Dev Toolkit project.

### Pattern Categories
1. **Basic Installation Testing** - Core installation verification
2. **Advanced Installation Testing** - Comprehensive testing with edge cases
3. **Multi-Environment Testing** - Testing across different environments
4. **Performance-Optimized Testing** - Fast, efficient testing patterns
5. **Integration Testing** - Installation → usage workflow testing

---

## 🏗️ Pattern 1: Basic Installation Testing

### Use Case
Simple projects that need basic installation verification without complex edge cases.

### Template
```yaml
install:
  runs-on: ubuntu-latest
  name: Test Installation
  needs: [lint, test]
  
  steps:
  - name: Checkout code
    uses: actions/checkout@v4
    
  - name: Test installation
    run: |
      set -euo pipefail
      ./install.sh --no-symlinks
      echo "✅ Installation completed"
      
  - name: Verify commands
    run: |
      set -euo pipefail
      export TOOL_ROOT="${GITHUB_WORKSPACE}"
      export PATH="$TOOL_ROOT/bin:$PATH"
      which command-name
      command-name --help
      echo "✅ Commands verified"
      
  - name: Cleanup
    run: |
      rm -rf ~/.toolkit
      echo "✅ Cleanup completed"
```

### Customization Points
- Replace `install.sh` with your installation script
- Replace `command-name` with your actual commands
- Replace `~/.toolkit` with your installation directory
- Adjust environment variable names (`TOOL_ROOT`)

---

## 🚀 Pattern 2: Advanced Installation Testing

### Use Case
Complex projects that need comprehensive testing including local installation, edge cases, and integration scenarios.

### Template
```yaml
install:
  runs-on: ubuntu-latest
  name: Test Installation
  needs: [lint, test]
  
  steps:
  - name: Checkout code
    uses: actions/checkout@v4
    
  # Global Installation
  - name: Test global installation
    run: |
      set -euo pipefail
      ./install.sh --no-symlinks
      echo "✅ Global installation completed"
      
  # Local Installation
  - name: Test local installation
    run: |
      set -euo pipefail
      LOCAL_TEST_DIR=$(mktemp -d)
      cd "$LOCAL_TEST_DIR"
      cp -r "${GITHUB_WORKSPACE}" ./project
      cd ./project
      ./install.sh --local
      if [ -f "bin/command-name" ]; then
        echo "✅ Local installation successful"
      else
        echo "❌ Local installation failed"
        exit 1
      fi
      cd "$GITHUB_WORKSPACE"
      rm -rf "$LOCAL_TEST_DIR"
      
  # Environment Setup
  - name: Set up environment
    run: |
      set -euo pipefail
      export TOOL_ROOT="${GITHUB_WORKSPACE}"
      export PATH="$TOOL_ROOT/bin:$PATH"
      echo "TOOL_ROOT=$TOOL_ROOT" >> $GITHUB_ENV
      echo "$TOOL_ROOT/bin" >> $GITHUB_PATH
      
  # Command Verification
  - name: Verify command accessibility
    run: |
      set -euo pipefail
      which command-name
      which another-command
      echo "✅ All commands accessible"
      
  # Integration Testing
  - name: Test integration scenarios
    run: |
      set -euo pipefail
      TEST_REPO_DIR=$(mktemp -d)
      cd "$TEST_REPO_DIR"
      git init
      git config user.email "test@example.com"
      git config user.name "Test User"
      echo "# Test" > README.md
      git add README.md
      git commit -m "Initial commit"
      command-name check || echo "Expected result"
      cd "$GITHUB_WORKSPACE"
      rm -rf "$TEST_REPO_DIR"
      echo "✅ Integration scenarios tested"
      
  # Edge Case Testing
  - name: Test edge cases
    run: |
      set -euo pipefail
      NON_GIT_DIR=$(mktemp -d)
      cd "$NON_GIT_DIR"
      cp -r "${GITHUB_WORKSPACE}" ./project
      cd ./project
      ./install.sh --no-symlinks
      ./install.sh --no-symlinks  # Re-installation
      echo "✅ Edge cases tested"
      cd "$GITHUB_WORKSPACE"
      rm -rf "$NON_GIT_DIR"
      
  # Isolation Verification
  - name: Verify installation isolation
    run: |
      set -euo pipefail
      if [ -d ~/.toolkit ]; then
        echo "✅ Global installation exists"
      fi
      which command-name
      TEMP_DIR=$(mktemp -d)
      cd "$TEMP_DIR"
      command-name --help
      cd "$GITHUB_WORKSPACE"
      rm -rf "$TEMP_DIR"
      echo "✅ Installation isolation verified"
      
  # Cleanup
  - name: Cleanup
    run: |
      rm -rf ~/.toolkit
      echo "✅ Cleanup completed"
```

### Customization Points
- Add/remove commands in verification steps
- Adjust integration test scenarios
- Modify edge case tests for your specific needs
- Change cleanup patterns

---

## 🌍 Pattern 3: Multi-Environment Testing

### Use Case
Projects that need to test installation across different operating systems and environments.

### Template
```yaml
install:
  strategy:
    matrix:
      os: [ubuntu-latest, macos-latest, windows-latest]
      shell: [bash, zsh]
      
  runs-on: ${{ matrix.os }}
  name: Test Installation (${{ matrix.os }}, ${{ matrix.shell }})
  needs: [lint, test]
  
  steps:
  - name: Checkout code
    uses: actions/checkout@v4
    
  - name: Set up shell
    if: matrix.os != 'windows-latest'
    run: |
      echo "SHELL=${{ matrix.shell }}" >> $GITHUB_ENV
      
  - name: Test installation
    shell: ${{ matrix.shell }}
    run: |
      set -euo pipefail
      ./install.sh --no-symlinks
      echo "✅ Installation completed on ${{ matrix.os }}"
      
  - name: Verify commands
    shell: ${{ matrix.shell }}
    run: |
      set -euo pipefail
      export TOOL_ROOT="${GITHUB_WORKSPACE}"
      export PATH="$TOOL_ROOT/bin:$PATH"
      which command-name
      command-name --help
      echo "✅ Commands verified on ${{ matrix.os }}"
      
  - name: Cleanup
    shell: ${{ matrix.shell }}
    run: |
      rm -rf ~/.toolkit
      echo "✅ Cleanup completed on ${{ matrix.os }}"
```

### Customization Points
- Adjust OS matrix based on your supported platforms
- Add shell-specific testing logic
- Modify environment setup for different OS

---

## ⚡ Pattern 4: Performance-Optimized Testing

### Use Case
Projects where CI speed is critical and comprehensive testing can be done separately.

### Template
```yaml
install:
  runs-on: ubuntu-latest
  name: Test Installation (Fast)
  needs: [lint, test]
  timeout-minutes: 5
  
  steps:
  - name: Checkout code
    uses: actions/checkout@v4
    
  - name: Quick installation test
    run: |
      set -euo pipefail
      time ./install.sh --no-symlinks
      echo "✅ Installation completed"
      
  - name: Essential command verification
    run: |
      set -euo pipefail
      export TOOL_ROOT="${GITHUB_WORKSPACE}"
      export PATH="$TOOL_ROOT/bin:$PATH"
      which command-name
      command-name --version
      echo "✅ Essential commands verified"
      
  - name: Quick cleanup
    run: |
      rm -rf ~/.toolkit
      echo "✅ Cleanup completed"

# Separate comprehensive testing job
install-comprehensive:
  runs-on: ubuntu-latest
  name: Comprehensive Installation Testing
  needs: [install]
  if: github.event_name == 'pull_request'
  
  steps:
  - name: Checkout code
    uses: actions/checkout@v4
    
  - name: Run comprehensive tests
    run: |
      # Run full test suite
      ./test-installation-comprehensive.sh
```

### Customization Points
- Adjust timeout based on your needs
- Modify which tests are "essential" vs "comprehensive"
- Change trigger conditions for comprehensive testing

---

## 🔗 Pattern 5: Integration Testing

### Use Case
Projects where installation is part of a larger workflow that needs to be tested end-to-end.

### Template
```yaml
install-integration:
  runs-on: ubuntu-latest
  name: Installation Integration Testing
  needs: [lint, test]
  
  steps:
  - name: Checkout code
    uses: actions/checkout@v4
    
  - name: Install tool
    run: |
      set -euo pipefail
      ./install.sh --no-symlinks
      export TOOL_ROOT="${GITHUB_WORKSPACE}"
      export PATH="$TOOL_ROOT/bin:$PATH"
      echo "TOOL_ROOT=$TOOL_ROOT" >> $GITHUB_ENV
      echo "$TOOL_ROOT/bin" >> $GITHUB_PATH
      
  - name: Test complete workflow
    run: |
      set -euo pipefail
      # Create test project
      TEST_PROJECT=$(mktemp -d)
      cd "$TEST_PROJECT"
      git init
      git config user.email "test@example.com"
      git config user.name "Test User"
      
      # Test workflow
      command-name init
      command-name setup
      command-name validate
      command-name build
      
      echo "✅ Complete workflow tested"
      cd "$GITHUB_WORKSPACE"
      rm -rf "$TEST_PROJECT"
      
  - name: Test error scenarios
    run: |
      set -euo pipefail
      # Test error handling
      command-name invalid-command || echo "Expected error handled"
      command-name --invalid-flag || echo "Expected error handled"
      echo "✅ Error scenarios tested"
      
  - name: Cleanup
    run: |
      rm -rf ~/.toolkit
      echo "✅ Cleanup completed"
```

### Customization Points
- Replace workflow steps with your actual commands
- Add/remove error scenarios
- Modify test project setup

---

## 🛠️ Pattern 6: Customizable Template

### Use Case
Projects that need a flexible template that can be easily customized.

### Template
```yaml
install:
  runs-on: ${{ matrix.os || 'ubuntu-latest' }}
  name: Test Installation
  needs: [lint, test]
  
  steps:
  - name: Checkout code
    uses: actions/checkout@v4
    
  - name: Test installation
    run: |
      set -euo pipefail
      ${{ matrix.install-command || './install.sh --no-symlinks' }}
      echo "✅ Installation completed"
      
  - name: Verify commands
    run: |
      set -euo pipefail
      export ${{ matrix.tool-root-var || 'TOOL_ROOT' }}="${GITHUB_WORKSPACE}"
      export PATH="${{ matrix.tool-root-var || 'TOOL_ROOT' }}/bin:$PATH"
      ${{ matrix.verify-commands || 'which command-name && command-name --help' }}
      echo "✅ Commands verified"
      
  - name: Cleanup
    run: |
      rm -rf ${{ matrix.cleanup-dir || '~/.toolkit' }}
      echo "✅ Cleanup completed"
```

### Usage Example
```yaml
strategy:
  matrix:
    os: [ubuntu-latest, macos-latest]
    install-command: ['./install.sh --no-symlinks', './install.sh --local']
    tool-root-var: [TOOL_ROOT, PROJECT_ROOT]
    verify-commands: ['which my-command && my-command --help', 'which other-command && other-command --version']
    cleanup-dir: ['~/.toolkit', '~/.project']
```

---

## 📊 Pattern Selection Guide

### Choose Basic Installation Testing When:
- ✅ Simple project with straightforward installation
- ✅ Limited CI time/resources
- ✅ Basic verification is sufficient
- ✅ Installation process is well-tested locally

### Choose Advanced Installation Testing When:
- ✅ Complex installation process
- ✅ Multiple installation modes (global/local)
- ✅ Need comprehensive edge case coverage
- ✅ Installation is critical to project success

### Choose Multi-Environment Testing When:
- ✅ Support multiple operating systems
- ✅ Installation behavior varies by platform
- ✅ Need to verify cross-platform compatibility
- ✅ Have sufficient CI resources

### Choose Performance-Optimized Testing When:
- ✅ CI speed is critical
- ✅ Can run comprehensive tests separately
- ✅ Need fast feedback for developers
- ✅ Have limited CI resources

### Choose Integration Testing When:
- ✅ Installation is part of larger workflow
- ✅ Need end-to-end testing
- ✅ Installation affects other tools/processes
- ✅ Complex user workflows

---

## 🔧 Customization Guidelines

### 1. Environment Variables
- Replace `TOOL_ROOT` with your project's root variable name
- Adjust `PATH` modifications for your tool's location
- Add any additional environment variables your tool needs

### 2. Commands
- Replace `command-name` with your actual command names
- Add/remove commands based on your tool's functionality
- Adjust command flags and options

### 3. Installation Scripts
- Replace `install.sh` with your installation script name
- Adjust installation flags (`--no-symlinks`, `--local`, etc.)
- Modify installation directory paths

### 4. Cleanup
- Replace `~/.toolkit` with your tool's installation directory
- Add any additional cleanup steps needed
- Adjust cleanup patterns for different environments

### 5. Testing Scenarios
- Add/remove integration test scenarios
- Modify edge case tests for your specific needs
- Adjust error handling tests

---

## 📚 Related Resources

- [CI Installation Testing Implementation Guide](ci-installation-testing-implementation.md)
- [CI Installation Testing Best Practices](ci-installation-testing-best-practices.md)
- [CI Installation Testing Troubleshooting](ci-installation-testing-troubleshooting.md)
- [Dev Toolkit CI Configuration](https://github.com/grimm00/dev-toolkit/blob/main/.github/workflows/ci.yml)

---

**Last Updated:** 2025-01-06  
**Status:** Active  
**Version:** 1.0
