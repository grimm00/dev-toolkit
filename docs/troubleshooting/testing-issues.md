# Testing Issues and Solutions

**Purpose:** Document common issues when writing and running tests

---

## Tests Hanging or Timing Out

**Symptom:**
```bash
bats tests/unit/core/test-github-utils.bats
# Hangs indefinitely, no output
```

**Cause:**
Tests that call functions which execute external commands (like `git`, `gh`, `curl`) without proper mocking can hang waiting for input or network responses.

**Example Problem:**
```bash
@test "gh_detect_project_info works" {
  source "$PROJECT_ROOT/lib/core/github-utils.sh"
  gh_detect_project_info  # This might call 'gh' or 'git' commands
  # Test hangs here
}
```

**Solutions:**

### 1. Mock External Commands (Recommended)
```bash
@test "gh_detect_project_info with mocked commands" {
  # Mock git to return specific output
  git() {
    case "$*" in
      "remote get-url origin")
        echo "https://github.com/user/repo.git"
        ;;
      *)
        echo "Unexpected git command: $*" >&2
        return 1
        ;;
    esac
  }
  export -f git
  
  # Now safe to call
  gh_detect_project_info
}
```

### 2. Test Pure Functions First
Start with functions that don't call external commands:
```bash
@test "string manipulation works" {
  source "$PROJECT_ROOT/lib/core/github-utils.sh"
  # Test helper functions that are pure bash
  result=$(some_pure_bash_function "input")
  [ "$result" = "expected" ]
}
```

### 3. Use Timeout
Wrap tests in timeout to prevent indefinite hangs:
```bash
@test "function with timeout" {
  run timeout 5s bash -c 'source lib/core/github-utils.sh && gh_detect_project_info'
  # Will fail after 5 seconds if hanging
}
```

### 4. Skip Integration Tests Initially
Mark complex tests as skip until mocking is complete:
```bash
@test "complex integration test" {
  skip "Needs better mocking - see docs/troubleshooting/testing-issues.md"
  # Test code here
}
```

---

## Mock Not Working

**Symptom:**
Mock function is defined but test still calls real command.

**Cause:**
Function export scope or subshell issues.

**Solution:**
```bash
# Make sure to export the function
my_mock() {
  echo "mocked output"
}
export -f my_mock

# Verify it's exported
declare -F my_mock  # Should show: my_mock
```

---

## PROJECT_ROOT Not Set

**Symptom:**
```bash
/path/to/test.bats: line 8: /lib/core/github-utils.sh: No such file or directory
```

**Cause:**
PROJECT_ROOT environment variable not set correctly.

**Solution:**
Always load the setup helper:
```bash
#!/usr/bin/env bats

load '../../helpers/setup'  # Relative path from test file to helpers/

@test "my test" {
  # PROJECT_ROOT is now available
  source "$PROJECT_ROOT/lib/core/github-utils.sh"
}
```

---

## Test Isolation Issues

**Symptom:**
Tests pass individually but fail when run together.

**Cause:**
Tests are affecting each other's state (environment variables, files, etc.).

**Solution:**

### Use setup/teardown
```bash
setup() {
  # Run before each test
  export ORIGINAL_VAR="$MY_VAR"
}

teardown() {
  # Run after each test
  export MY_VAR="$ORIGINAL_VAR"
  unset -f mocked_function 2>/dev/null
}
```

### Use Temporary Directories
```bash
setup() {
  TEST_DIR="$(mktemp -d)"
  cd "$TEST_DIR"
}

teardown() {
  cd /
  rm -rf "$TEST_DIR"
}
```

---

## Best Practices for Test Development

### 1. Start Simple
```bash
# ✅ Good: Simple, fast, isolated
@test "string contains substring" {
  [[ "hello world" =~ "world" ]]
}

# ❌ Avoid initially: Complex, slow, many dependencies
@test "full end-to-end workflow" {
  # Calls 10 different functions, makes API calls, etc.
}
```

### 2. Build Up Complexity
1. Test pure bash functions
2. Test functions with mocked dependencies
3. Test command wrappers with mocked commands
4. Test full integration scenarios

### 3. Use Descriptive Test Names
```bash
# ✅ Good
@test "gh_detect_project_info: extracts owner from HTTPS URL"

# ❌ Bad
@test "test 1"
```

### 4. One Assertion Per Test (When Possible)
```bash
# ✅ Good: Clear what failed
@test "extracts owner" {
  [ "$PROJECT_OWNER" = "expected" ]
}

@test "extracts repo" {
  [ "$PROJECT_REPO" = "expected/repo" ]
}

# ⚠️ Okay but less clear
@test "extracts all fields" {
  [ "$PROJECT_OWNER" = "expected" ]
  [ "$PROJECT_REPO" = "expected/repo" ]
  [ "$PROJECT_NAME" = "repo" ]
}
```

---

## Debugging Tests

### Run Single Test
```bash
# Run specific test file
bats tests/unit/core/test-simple.bats

# Run with verbose output
bats --tap tests/unit/core/test-simple.bats

# Run with trace
bats --trace tests/unit/core/test-simple.bats
```

### Add Debug Output
```bash
@test "debug example" {
  echo "DEBUG: Variable value is $MY_VAR" >&3
  # Test continues...
}
```

### Check What's Exported
```bash
@test "check exports" {
  declare -F  # List all functions
  env | grep PROJECT  # List PROJECT_* variables
  false  # Force failure to see output
}
```

---

## Known Issues

### Issue: Complex Function Tests Hang
**Status:** Known limitation  
**Workaround:** Start with simple tests, add mocking incrementally  
**Tracking:** See `admin/planning/features/testing-suite/phase-1.md`

### Issue: Helper Libraries Not Available
**Status:** bats-support, bats-assert not in Homebrew  
**Workaround:** Using custom helpers in `tests/helpers/`  
**Future:** May vendor these libraries if needed

---

## Quick Reference

```bash
# Run all tests
bats tests/

# Run specific directory
bats tests/unit/

# Run specific file
bats tests/unit/core/test-simple.bats

# Verbose output
bats --tap tests/

# Stop on first failure
bats --no-parallelize-within-files tests/

# Show timing
bats --timing tests/
```

---

**Last Updated:** October 6, 2025  
**Version:** 0.2.0-dev  
**Related:** Phase 1 testing implementation
