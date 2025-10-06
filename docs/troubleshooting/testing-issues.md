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

## Exit Code Inconsistencies

**Symptom:**
Test expects function to return 1 but it returns 128 or other non-standard code.

**Example:**
```bash
@test "gh_is_git_repo: returns 1 outside git repository" {
  run gh_is_git_repo
  [ "$status" -eq 1 ]  # Fails! Actually returns 128
}
```

**Cause:**
Many bash functions pass through the exit code of underlying commands. For example:
- `git rev-parse --git-dir` returns 128 when not in a git repo
- `command -v nonexistent` returns 1
- `curl` returns various codes (6, 7, 28, etc.)

**Solutions:**

### 1. Test for Non-Zero (Recommended for Most Cases)
```bash
@test "function fails appropriately" {
  run some_function_that_should_fail
  [ "$status" -ne 0 ]  # Just check it's non-zero
}
```

### 2. Test for Specific Exit Code (When It Matters)
```bash
@test "function returns specific code" {
  run some_function
  [ "$status" -eq 128 ]  # If you need the exact code
}
```

### 3. Document Expected Behavior
```bash
@test "gh_is_git_repo: returns non-zero outside git repository" {
  # Note: git returns 128, not 1, when not in a repo
  # This is expected behavior - we just need non-zero
  run gh_is_git_repo
  [ "$status" -ne 0 ]
}
```

### 4. Normalize Exit Codes in Functions (Future Enhancement)
If consistent exit codes are important, wrap commands:
```bash
gh_is_git_repo() {
  if git rev-parse --git-dir > /dev/null 2>&1; then
    return 0
  else
    return 1  # Normalize to 1 instead of passing through 128
  fi
}
```

**When to Use Each Approach:**
- **Non-zero check:** Most tests, especially for error conditions
- **Specific code:** When the exact code is part of the API contract
- **Normalization:** When building a library with documented exit codes

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
