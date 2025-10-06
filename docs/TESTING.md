# Testing Guide

**Dev Toolkit Testing Documentation**

This guide covers everything you need to know about testing the Dev Toolkit, including running tests, writing new tests, and understanding our testing patterns.

---

## 📋 Table of Contents

- [Quick Start](#quick-start)
- [Test Structure](#test-structure)
- [Running Tests](#running-tests)
- [Writing Tests](#writing-tests)
- [Testing Patterns](#testing-patterns)
- [Mocking Guide](#mocking-guide)
- [Troubleshooting](#troubleshooting)
- [Best Practices](#best-practices)

---

## 🚀 Quick Start

### Prerequisites

```bash
# Install bats-core (testing framework)
brew install bats-core

# Verify installation
bats --version
```

### Run All Tests

```bash
# From project root
./scripts/test.sh

# Or directly with bats
bats tests/
```

### Run Specific Tests

```bash
# Single test file
bats tests/unit/core/test-github-utils-basic.bats

# Specific directory
bats tests/unit/core/

# With the test runner script
./scripts/test.sh tests/unit/core/
```

---

## 📁 Test Structure

```
tests/
├── helpers/                    # Shared test utilities
│   ├── setup.bash             # Common setup functions
│   ├── mocks.bash             # Command mocking utilities
│   └── assertions.bash        # Custom assertions
├── unit/                      # Unit tests
│   ├── core/                  # Core utilities tests
│   │   ├── test-simple.bats           # Smoke tests
│   │   ├── test-github-utils-basic.bats
│   │   ├── test-github-utils-git.bats
│   │   ├── test-github-utils-output.bats
│   │   └── test-github-utils-validation.bats
│   └── git-flow/              # Git Flow tests
│       ├── test-git-flow-utils.bats
│       └── test-git-flow-safety.bats
└── integration/               # Integration tests (future)
```

### Test File Naming

- **Smoke tests**: `test-simple.bats`
- **Unit tests**: `test-<module>-<category>.bats`
- **Integration tests**: `test-<feature>-integration.bats`

---

## 🏃 Running Tests

### Test Runner Script

The `scripts/test.sh` script provides a convenient way to run tests:

```bash
# Run all tests
./scripts/test.sh

# Run specific directory (recursively finds .bats files)
./scripts/test.sh tests/unit/core/

# Run single file
./scripts/test.sh tests/unit/core/test-simple.bats
```

**Features:**
- ✅ Recursive test discovery
- ✅ Color-coded output
- ✅ Clear success/failure messages
- ✅ Works with directories or individual files

### Direct Bats Usage

```bash
# Run all tests
bats tests/

# Run with tap output (for CI)
bats --tap tests/

# Run with timing information
bats --timing tests/

# Filter tests by name
bats --filter "github-utils" tests/
```

### Performance

**Current Stats:**
- **Total Tests:** 129
- **Execution Time:** < 10 seconds
- **Success Rate:** 100%

---

## ✍️ Writing Tests

### Basic Test Structure

```bash
#!/usr/bin/env bats

# Load test helpers
load '../../helpers/setup'
load '../../helpers/mocks'
load '../../helpers/assertions'

# Setup runs before each test
setup() {
  setup_file  # Sets PROJECT_ROOT and PATH
}

# Teardown runs after each test
teardown() {
  restore_commands  # Restore mocked commands
}

# Test case
@test "descriptive test name" {
  # Arrange
  local expected="value"
  
  # Act
  run some_command
  
  # Assert
  [ "$status" -eq 0 ]
  [ "$output" = "$expected" ]
}
```

### Test Naming Conventions

**Format:** `function_name: behavior description`

**Examples:**
```bash
@test "gh_command_exists: returns 0 for existing command"
@test "gh_command_exists: returns 1 for non-existing command"
@test "gh_is_valid_branch_name: accepts feat/ prefix"
@test "gh_is_valid_branch_name: rejects invalid prefix"
```

**Guidelines:**
- Use descriptive names that explain what's being tested
- Include expected behavior in the name
- Group related tests with common prefixes
- Keep names concise but clear

### Assertions

#### Standard Bats Assertions

```bash
# Exit code checks
[ "$status" -eq 0 ]      # Success
[ "$status" -eq 1 ]      # Specific error code
[ "$status" -ne 0 ]      # Any error

# Output checks
[ "$output" = "exact match" ]
[[ "$output" =~ "pattern" ]]     # Regex match
[ -z "$output" ]                  # Empty output
[ -n "$output" ]                  # Non-empty output

# File checks
[ -f "$file" ]           # File exists
[ -d "$dir" ]            # Directory exists
[ -x "$file" ]           # File is executable
```

#### Custom Assertions (from helpers/assertions.bash)

```bash
assert_success              # Status is 0
assert_failure              # Status is non-zero
assert_output "text"        # Output matches exactly
assert_output --partial "text"  # Output contains text
assert_line "text"          # Specific line matches
```

### Test Organization

#### Section Headers

Use clear section headers to organize tests:

```bash
# ============================================================================
# Command Existence Tests
# ============================================================================

@test "gh_command_exists: returns 0 for existing command" {
  # ...
}

# ============================================================================
# Branch Validation Tests
# ============================================================================

@test "gh_is_valid_branch_name: accepts feat/ prefix" {
  # ...
}
```

---

## 🎭 Testing Patterns

### Pattern 1: Pure Function Testing

For functions with no external dependencies:

```bash
@test "gh_generate_secret: generates non-empty secret" {
  result=$(gh_generate_secret)
  [ -n "$result" ]
}

@test "gh_generate_secret: generates different secrets each time" {
  secret1=$(gh_generate_secret)
  secret2=$(gh_generate_secret)
  [ "$secret1" != "$secret2" ]
}
```

### Pattern 2: Testing with Mocked Commands

For functions that call external commands:

```bash
@test "gh_get_current_branch: returns current branch name" {
  # Mock git command
  git() {
    if [ "$1" = "branch" ] && [ "$2" = "--show-current" ]; then
      echo "feat/my-feature"
      return 0
    fi
    command git "$@"
  }
  export -f git
  
  run gh_get_current_branch
  [ "$status" -eq 0 ]
  [ "$output" = "feat/my-feature" ]
}
```

### Pattern 3: Testing Error Conditions

Always test both success and failure paths:

```bash
@test "gh_command_exists: returns 0 for existing command" {
  run gh_command_exists "ls"
  [ "$status" -eq 0 ]
}

@test "gh_command_exists: returns 1 for non-existing command" {
  run gh_command_exists "nonexistent_command_12345"
  [ "$status" -eq 1 ]
}
```

### Pattern 4: Testing with Temporary Files

Use `setup_test_dir` and `teardown_test_dir` helpers:

```bash
setup() {
  setup_file
  setup_test_dir  # Creates TEST_DIR and cd's into it
}

teardown() {
  teardown_test_dir  # Cleans up TEST_DIR and restores PWD
}

@test "function creates config file" {
  # TEST_DIR is available and we're cd'd into it
  some_function_that_creates_file
  [ -f "config.txt" ]
}
```

### Pattern 5: Testing Configuration Loading

```bash
@test "gh_load_config_file: loads MAIN_BRANCH setting" {
  setup_test_dir
  cat > config.test <<EOF
MAIN_BRANCH=trunk
EOF
  
  gh_load_config_file "$TEST_DIR/config.test"
  result="$GH_MAIN_BRANCH"
  teardown_test_dir
  
  [ "$result" = "trunk" ]
}
```

### Pattern 6: Integration Testing

Test multiple functions working together:

```bash
@test "full workflow: check deps, auth, validate repo" {
  # Mock all required commands
  git() { return 0; }
  gh() { 
    if [ "$1" = "auth" ]; then
      echo "Logged in"
      return 0
    fi
    return 0
  }
  export -f git gh
  
  # Test the workflow
  run gh_check_dependencies
  [ "$status" -eq 0 ]
  
  run gh_check_authentication
  [ "$status" -eq 0 ]
  
  run gh_validate_repository
  [ "$status" -eq 0 ]
}
```

---

## 🎭 Mocking Guide

### Why Mock?

Mocking allows us to:
- Test functions in isolation
- Avoid external dependencies (network, filesystem)
- Simulate error conditions
- Speed up test execution

### Basic Command Mocking

```bash
# Mock a command to return specific output
git() {
  echo "mocked output"
  return 0
}
export -f git

# Mock with conditional logic
git() {
  if [ "$1" = "branch" ]; then
    echo "main"
    return 0
  fi
  command git "$@"  # Fall through to real git
}
export -f git
```

### Mock Patterns

#### Pattern 1: Simple Mock

```bash
gh() {
  echo "mocked response"
  return 0
}
export -f gh
```

#### Pattern 2: Conditional Mock

```bash
git() {
  case "$1" in
    "branch")
      echo "feat/test"
      return 0
      ;;
    "rev-parse")
      echo "/path/to/repo"
      return 0
      ;;
    *)
      command git "$@"
      ;;
  esac
}
export -f git
```

#### Pattern 3: Mock with State

```bash
gh() {
  if [ "$1" = "auth" ] && [ "$2" = "status" ]; then
    echo "Logged in to github.com"
    return 0
  fi
  return 1
}
export -f gh
```

### Restoring Commands

Always restore mocked commands in teardown:

```bash
teardown() {
  restore_commands  # From helpers/mocks.bash
}
```

### Mock Helpers

The `helpers/mocks.bash` file provides utilities:

```bash
# Initialize git repo for testing
init_test_repo()

# Create initial commit
create_initial_commit()

# Mock git remote
mock_git_remote "https://github.com/owner/repo.git"

# Mock gh repo view
mock_gh_repo_view "owner/repo" "Description"

# Restore all mocked commands
restore_commands()
```

---

## 🐛 Troubleshooting

### Common Issues

#### Issue 1: Tests Not Found

**Symptom:** `bats tests/` doesn't find tests in subdirectories

**Solution:** Use the test runner script or find command:
```bash
./scripts/test.sh tests/
# or
find tests/ -name "*.bats" | xargs bats
```

#### Issue 2: PROJECT_ROOT Not Set

**Symptom:** Tests fail with "file not found" errors

**Solution:** Ensure `setup_file` is called:
```bash
setup() {
  setup_file  # This sets PROJECT_ROOT
}
```

#### Issue 3: Mocks Not Working

**Symptom:** Mocked commands still call real commands

**Solution:** Ensure you export the function:
```bash
git() { echo "mocked"; }
export -f git  # Don't forget this!
```

#### Issue 4: Exit Code Inconsistencies

**Symptom:** Test expects exit code 1 but gets 128

**Solution:** Test for non-zero instead of specific code:
```bash
# Instead of:
[ "$status" -eq 1 ]

# Use:
[ "$status" -ne 0 ]
```

See `docs/troubleshooting/testing-issues.md` for more details.

#### Issue 5: Test Isolation Problems

**Symptom:** Tests pass individually but fail when run together

**Solution:** Use proper setup/teardown:
```bash
setup() {
  setup_file
  setup_test_dir  # Creates isolated temp directory
}

teardown() {
  teardown_test_dir  # Cleans up and restores PWD
  restore_commands   # Restores mocked commands
}
```

### Debug Tips

#### Enable Debug Output

```bash
# Add to test
set -x  # Enable bash debug mode

# Or run bats with verbose output
bats -t tests/unit/core/test-simple.bats
```

#### Print Variables

```bash
@test "debug test" {
  echo "DEBUG: status=$status" >&3
  echo "DEBUG: output=$output" >&3
  # Test assertions...
}
```

#### Run Single Test

```bash
# Run just one test file
bats tests/unit/core/test-simple.bats

# Run with filter
bats --filter "command_exists" tests/
```

---

## ✅ Best Practices

### Test Design

1. **One Assertion Per Test (When Possible)**
   ```bash
   # Good
   @test "returns 0 for valid input" { ... }
   @test "returns 1 for invalid input" { ... }
   
   # Avoid (unless testing a workflow)
   @test "handles all cases" {
     # Multiple unrelated assertions
   }
   ```

2. **Descriptive Test Names**
   ```bash
   # Good
   @test "gh_is_valid_branch_name: accepts feat/ prefix"
   
   # Bad
   @test "test branch validation"
   ```

3. **Test Both Success and Failure**
   ```bash
   @test "succeeds with valid input" { ... }
   @test "fails with invalid input" { ... }
   @test "handles edge case" { ... }
   ```

4. **Use Arrange-Act-Assert Pattern**
   ```bash
   @test "example" {
     # Arrange
     local input="value"
     
     # Act
     run some_function "$input"
     
     # Assert
     [ "$status" -eq 0 ]
     [ "$output" = "expected" ]
   }
   ```

### Test Organization

1. **Group Related Tests**
   - Use section headers
   - Keep related tests together
   - Order from simple to complex

2. **Keep Tests Fast**
   - Mock external commands
   - Avoid real network calls
   - Use temporary directories

3. **Make Tests Independent**
   - Each test should work in isolation
   - Use setup/teardown properly
   - Don't rely on test execution order

### Code Coverage Goals

- **Critical Functions:** 100% coverage
- **Core Utilities:** 80%+ coverage
- **Helper Functions:** 60%+ coverage
- **Error Paths:** Test all error conditions

### Documentation

1. **Comment Complex Mocks**
   ```bash
   # Mock git to simulate a merge conflict
   git() {
     if [ "$1" = "diff-index" ]; then
       return 1  # Indicates uncommitted changes
     fi
     command git "$@"
   }
   ```

2. **Explain Non-Obvious Tests**
   ```bash
   @test "handles git exit code 128" {
     # Note: git returns 128, not 1, when not in a repo
     # This is expected behavior - we just need non-zero
     run gh_is_git_repo
     [ "$status" -ne 0 ]
   }
   ```

3. **Document Test Patterns**
   - Update this guide when you discover new patterns
   - Add examples to `docs/troubleshooting/testing-issues.md`
   - Share learnings in PR descriptions

---

## 📚 Additional Resources

### Internal Documentation

- **Troubleshooting:** `docs/troubleshooting/testing-issues.md`
- **Phase 1 Plan:** `admin/planning/features/testing-suite/phase-1.md`
- **Phase 2 Plan:** `admin/planning/features/testing-suite/phase-2.md`
- **Feature Plan:** `admin/planning/features/testing-suite/feature-plan.md`

### External Resources

- **Bats Documentation:** https://bats-core.readthedocs.io/
- **Bats GitHub:** https://github.com/bats-core/bats-core
- **Bash Testing Guide:** https://github.com/sstephenson/bats/wiki

### Test Examples

All test files in `tests/unit/` serve as examples:
- `test-simple.bats` - Basic smoke tests
- `test-github-utils-*.bats` - Comprehensive unit tests
- `test-git-flow-*.bats` - Git Flow testing patterns

---

## 🎯 Quick Reference

### Running Tests

```bash
./scripts/test.sh                    # All tests
./scripts/test.sh tests/unit/core/   # Specific directory
bats tests/unit/core/test-simple.bats  # Single file
```

### Writing Tests

```bash
@test "function: behavior" {
  run function_name
  [ "$status" -eq 0 ]
  [[ "$output" =~ "expected" ]]
}
```

### Mocking

```bash
command() { echo "mock"; return 0; }
export -f command
```

### Helpers

```bash
setup_file          # Set PROJECT_ROOT
setup_test_dir      # Create temp directory
teardown_test_dir   # Clean up temp directory
restore_commands    # Restore mocked commands
```

---

**Last Updated:** October 6, 2025  
**Test Count:** 129 tests  
**Coverage:** 80%+ for core utilities  
**Execution Time:** < 10 seconds
