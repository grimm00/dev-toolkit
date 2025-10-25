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

## Integration Test Issues

### Issue: Tests Hanging on User Input

**Symptom:**
Integration tests hang indefinitely when commands prompt for user input.

**Example:**
```bash
@test "dt-install-hooks installs hook" {
  TEST_DIR="$(mktemp -d)"
  cd "$TEST_DIR"
  git init
  
  run dt-install-hooks  # Hangs waiting for y/n input
}
```

**Cause:**
Commands like `dt-install-hooks` prompt for confirmation when a hook already exists.

**Solutions:**

#### 1. Pipe Input to Command
```bash
@test "dt-install-hooks with piped input" {
  TEST_DIR="$(mktemp -d)"
  cd "$TEST_DIR"
  git init > /dev/null 2>&1
  
  # Pipe 'y' to answer prompt
  run bash -c "echo 'y' | dt-install-hooks"
  [ "$status" -eq 0 ]
  
  cd - > /dev/null
  rm -rf "$TEST_DIR"
}
```

#### 2. Mock EDITOR for Edit Commands
```bash
@test "dt-config edit with mocked EDITOR" {
  TEST_DIR="$(mktemp -d)"
  HOME="$TEST_DIR" dt-config create > /dev/null 2>&1
  
  # Mock EDITOR to just echo the file path
  EDITOR="echo" run dt-config edit
  [ "$status" -eq 0 ]
  
  rm -rf "$TEST_DIR"
}
```

#### 3. Use Non-Interactive Flags (if available)
```bash
# If command supports --yes or --no-prompt flags
run dt-install-hooks --yes
```

---

### Issue: Temporary Directory Cleanup

**Symptom:**
`/tmp` directory fills up with test directories after running tests.

**Cause:**
Tests create temporary directories but don't clean them up properly.

**Solutions:**

#### 1. Manual Cleanup (Simple)
```bash
@test "my integration test" {
  TEST_DIR="$(mktemp -d)"
  ORIG_DIR="$PWD"
  cd "$TEST_DIR"
  
  # Test code here
  
  # Always cleanup
  cd "$ORIG_DIR"
  rm -rf "$TEST_DIR"
}
```

#### 2. Trap for Guaranteed Cleanup (Recommended)
```bash
@test "my integration test with trap" {
  TEST_DIR="$(mktemp -d)"
  trap "cd - > /dev/null 2>&1; rm -rf '$TEST_DIR'" EXIT
  
  cd "$TEST_DIR"
  
  # Test code here
  # Cleanup happens automatically even if test fails
}
```

#### 3. Use Helper Functions
```bash
setup() {
  setup_file
  setup_test_dir  # Creates TEST_DIR and cd's into it
}

teardown() {
  teardown_test_dir  # Cleans up and restores PWD
}

@test "my test" {
  # TEST_DIR is already set and cleaned up automatically
  git init
  # ...
}
```

---

### Issue: Integration Tests Fail in CI but Pass Locally

**Symptom:**
Tests pass on your machine but fail in GitHub Actions or other CI environments.

**Common Causes:**

#### 1. Git Configuration Missing
```bash
# CI environments don't have git user configured
@test "test that commits" {
  TEST_DIR="$(mktemp -d)"
  cd "$TEST_DIR"
  
  git init
  # ❌ This will fail in CI without user config
  git commit -m "test"
}
```

**Solution:** Always configure git in tests:
```bash
@test "test that commits" {
  TEST_DIR="$(mktemp -d)"
  cd "$TEST_DIR"
  
  git init
  git config user.email "test@example.com"
  git config user.name "Test User"
  
  echo "test" > file.txt
  git add file.txt
  git commit -m "test"  # ✅ Now works in CI
  
  cd - > /dev/null
  rm -rf "$TEST_DIR"
}
```

#### 2. HOME Directory Differences
```bash
# CI may have different HOME directory
@test "test with config" {
  # ❌ Assumes specific HOME location
  [ -f "$HOME/.dev-toolkit/config.conf" ]
}
```

**Solution:** Use temporary HOME for tests:
```bash
@test "test with config" {
  TEST_DIR="$(mktemp -d)"
  
  # ✅ Use temporary HOME
  HOME="$TEST_DIR" dt-config create
  [ -f "$TEST_DIR/.dev-toolkit/config.conf" ]
  
  rm -rf "$TEST_DIR"
}
```

#### 3. Path Dependencies
```bash
# CI may not have commands in PATH
@test "test that uses jq" {
  # ❌ Assumes jq is installed
  result=$(echo '{"key":"value"}' | jq -r .key)
}
```

**Solution:** Check for optional dependencies:
```bash
@test "test that uses jq" {
  if ! command -v jq > /dev/null; then
    skip "jq not installed"
  fi
  
  result=$(echo '{"key":"value"}' | jq -r .key)
  [ "$result" = "value" ]
}
```

---

### Issue: Integration Tests Are Slow

**Symptom:**
Integration tests take a long time to run (> 30 seconds).

**Causes and Solutions:**

#### 1. Too Many Git Operations
```bash
# ❌ Slow: Creates full git history
@test "slow test" {
  TEST_DIR="$(mktemp -d)"
  cd "$TEST_DIR"
  
  git init
  for i in {1..100}; do
    echo "$i" > file.txt
    git add file.txt
    git commit -m "Commit $i"
  done
  
  # Test something
}
```

**Solution:** Minimize git operations:
```bash
# ✅ Fast: Only necessary operations
@test "fast test" {
  TEST_DIR="$(mktemp -d)"
  cd "$TEST_DIR"
  
  git init
  git config user.email "test@example.com"
  git config user.name "Test User"
  
  echo "test" > file.txt
  git add file.txt
  git commit -m "Initial"
  
  # Test something
  
  cd - > /dev/null
  rm -rf "$TEST_DIR"
}
```

#### 2. Redirect Output
```bash
# ❌ Slow: Shows all git output
git init
git add .
git commit -m "test"
```

**Solution:** Redirect to /dev/null:
```bash
# ✅ Fast: Suppresses output
git init > /dev/null 2>&1
git add . > /dev/null 2>&1
git commit -m "test" > /dev/null 2>&1
```

#### 3. Parallel Test Execution
```bash
# Run tests in parallel (if bats supports it)
bats --jobs 4 tests/
```

---

## Command Wrapper Help Flag Issues

**Symptom:**
```bash
dt-review --help
# Error: /path/to/dt-review: line 34: printf: --help: invalid number
```

**Cause:**
Command wrapper scripts that accept positional arguments may not handle help flags (`--help`, `-h`) before processing arguments, causing the flag to be interpreted as an invalid argument value.

**Example Problem:**
```bash
#!/usr/bin/env bash
# Get PR number
PR_NUMBER="${1:-}"

# Format PR number with leading zero
PR_PADDED=$(printf "pr%02d" "$PR_NUMBER")  # Fails if $1 is "--help"
```

**Solution:**
Handle help flags at the beginning of the script, before processing positional arguments:

```bash
#!/usr/bin/env bash

# Handle help flags FIRST
if [[ "${1:-}" == "--help" ]] || [[ "${1:-}" == "-h" ]]; then
    echo "Usage: dt-review <PR_NUMBER>"
    echo ""
    echo "Description of what this command does"
    echo ""
    echo "Example:"
    echo "  dt-review 6"
    exit 0
fi

# Now safe to process positional arguments
PR_NUMBER="${1:-}"

if [ -z "$PR_NUMBER" ]; then
    echo "Usage: dt-review <PR_NUMBER>"
    echo ""
    echo "Use --help for more information"
    exit 1
fi

# Continue with normal processing...
```

**Testing Pattern:**
```bash
@test "command: shows help with --help flag" {
  run dt-review --help
  [ "$status" -eq 0 ]
  [[ "$output" =~ "Usage:" ]]
}

@test "command: shows help with -h flag" {
  run dt-review -h
  [ "$status" -eq 0 ]
  [[ "$output" =~ "Usage:" ]]
}

@test "command: fails gracefully without arguments" {
  run dt-review
  [ "$status" -ne 0 ]
  [[ "$output" =~ "Usage:" ]]
}
```

**Key Principles:**
- Always handle help flags before processing arguments
- Test help flags early in development
- Provide clear usage messages for both help and error cases
- Exit with code 0 for help, non-zero for errors

**Related:**
- Phase 3 Part C: dt-review bug fix (commit e58876f)
- tests/integration/test-dt-sourcery-parse.bats

---

**Last Updated:** October 6, 2025  
**Version:** 0.2.0-dev  
**Related:** Phase 3 testing implementation (integration tests, command wrappers)
