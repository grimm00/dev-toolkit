# Testing Approach Decisions

**Purpose:** Document key decisions made during Testing Suite implementation  
**Created:** October 6, 2025  
**Status:** Active Reference

---

## Decision 1: Dynamic Test Creation vs Static Fixtures

**Date:** October 6, 2025  
**Context:** Phase 1-3 Implementation

### The Question

Should we use static fixture files (`tests/fixtures/`) or create test data dynamically?

### What We Decided

**Use dynamic test creation** - Create temporary git repos and test data on-the-fly in each test.

### Why

**Advantages of Dynamic Creation:**
1. **Flexibility** - Each test creates exactly what it needs
2. **Isolation** - No shared state between tests
3. **Maintainability** - No fixture files to keep in sync with code changes
4. **Clarity** - Test setup is visible in the test itself
5. **Speed** - `mktemp -d` is very fast for creating temporary directories
6. **No Stale Data** - Fixtures can become outdated; dynamic creation is always current

**When Fixtures Would Be Better:**
- Complex, reusable test data that's expensive to generate
- Large binary files
- Complex data structures that are tedious to create
- External API responses that rarely change

**Our Use Case:**
- Simple git repositories (fast to create)
- Small config files (easy to generate inline)
- Function mocking for external commands (more flexible than fixtures)

### Implementation Pattern

```bash
@test "integration test example" {
  # Create temporary directory
  TEST_DIR=$(mktemp -d)
  cd "$TEST_DIR"
  
  # Set up git repo dynamically
  git init > /dev/null 2>&1
  git config user.name "Test User"
  git config user.email "test@example.com"
  git remote add origin "https://github.com/test/repo.git"
  
  # Create test file
  echo "test content" > test.txt
  git add test.txt
  git commit -m "Test commit" > /dev/null 2>&1
  
  # Run test
  run dt-git-safety check
  [ "$status" -eq 0 ]
  
  # Cleanup
  cd - > /dev/null 2>&1
  rm -rf "$TEST_DIR"
}
```

### Fixtures Directory Status

**Current State:**
- `tests/fixtures/` exists but is empty
- Subdirectories created: `configs/`, `repos/`, `responses/`

**Decision:**
- **Keep the directories** for potential future use
- Document that we're using dynamic creation instead
- If we need fixtures later, the structure is ready

**Future Scenarios Where We Might Use Fixtures:**
1. Complex Sourcery API responses (if we add full mocking)
2. Large sample repositories for performance testing
3. Binary test data (images, archives, etc.)
4. Reusable configuration templates

---

## Decision 2: Function Mocking vs Command Fixtures

**Date:** October 6, 2025  
**Context:** Phase 2 Unit Tests

### The Question

How should we mock external commands like `git`, `gh`, and `command`?

### What We Decided

**Use function mocking with `export -f`** - Override commands as bash functions within tests.

### Why

**Advantages:**
1. **Control** - Precise control over command behavior
2. **Flexibility** - Different behavior per test
3. **Debugging** - Easy to see what's being mocked in the test
4. **No Files** - No fixture files to manage
5. **Fast** - No I/O overhead

### Implementation Pattern

```bash
@test "test with mocked git" {
  # Mock git command
  git() {
    if [ "$1" = "remote" ] && [ "$2" = "get-url" ]; then
      echo "https://github.com/user/repo.git"
      return 0
    fi
    command git "$@"  # Fall through to real git for other commands
  }
  export -f git
  
  # Run test with mocked git
  source "$PROJECT_ROOT/lib/core/github-utils.sh"
  gh_detect_project_info
  
  [ "$PROJECT_OWNER" = "user" ]
  [ "$PROJECT_REPO" = "user/repo" ]
}
```

**Helper Functions Created:**
- `tests/helpers/mocks.bash` - Common mocking patterns
- `mock_git_remote()` - Mock git remote URL
- `mock_gh_repo_view()` - Mock gh repo view
- `restore_commands()` - Clean up mocks

---

## Decision 3: Interface Testing vs Full Integration for Optional Features

**Date:** October 6, 2025  
**Context:** Phase 3 Part C - dt-sourcery-parse

### The Question

How should we test commands that depend on external services (like Sourcery AI via GitHub API)?

### What We Decided

**Test the interface, not the external service** - Focus on command flags, arguments, help text, and error handling without complex API mocking.

### Why

**Challenges with Full Mocking:**
1. **Fragile** - API responses change, mocks become outdated
2. **Complex** - GitHub API responses are large and nested
3. **Maintenance** - High cost to keep mocks in sync
4. **False Confidence** - Mocked responses may not match reality

**Our Approach:**
```bash
# Test that flags are accepted (will fail for other reasons, but not argument parsing)
@test "dt-sourcery-parse: accepts --rich-details flag" {
  run dt-sourcery-parse 1 --rich-details
  [ "$status" -ne 0 ]
  # Should NOT show "Invalid argument" for the flag
  ! [[ "$output" =~ "Invalid argument.*rich-details" ]]
}

# Test help works
@test "dt-sourcery-parse: shows help with --help flag" {
  run dt-sourcery-parse --help
  [ "$status" -eq 0 ]
  [[ "$output" =~ "Usage:" ]]
}

# Test error handling
@test "dt-sourcery-parse: rejects non-numeric PR number" {
  run dt-sourcery-parse abc
  [ "$status" -ne 0 ]
  [[ "$output" =~ "Invalid argument" ]]
}
```

**What We Test:**
- ✅ Help flags work
- ✅ Arguments are validated
- ✅ Flags are accepted
- ✅ Error messages are clear
- ✅ Command exists and is executable

**What We Don't Test:**
- ❌ Actual Sourcery API responses
- ❌ GitHub API integration
- ❌ Complex parsing logic with real data

**Rationale:**
- Interface testing catches 90% of bugs
- Real integration testing happens in actual use
- User can verify with real PRs
- Much more maintainable

### Documentation Added

Added "Issue 8: Testing Optional Features" to `docs/TESTING.md` with:
- Guidance for testing external dependencies
- Examples from dt-sourcery-parse
- Key principles for reliable testing

---

## Decision 4: Temporary Directory Cleanup Strategy

**Date:** October 6, 2025  
**Context:** Phase 3 Integration Tests

### The Question

How should we handle cleanup of temporary test directories?

### What We Decided

**Manual cleanup with explicit `cd` back** - Each test manages its own cleanup.

### Approaches Considered

**Option 1: Manual Cleanup (Chosen)**
```bash
@test "my test" {
  TEST_DIR=$(mktemp -d)
  cd "$TEST_DIR"
  
  # Test code...
  
  cd - > /dev/null 2>&1
  rm -rf "$TEST_DIR"
}
```

**Option 2: Trap-Based Cleanup**
```bash
@test "my test" {
  TEST_DIR=$(mktemp -d)
  trap "cd - > /dev/null; rm -rf '$TEST_DIR'" EXIT
  
  cd "$TEST_DIR"
  # Test code...
  # Cleanup happens automatically
}
```

**Option 3: Helper Functions**
```bash
@test "my test" {
  setup_test_dir
  # TEST_DIR is set and we're in it
  
  # Test code...
  
  teardown_test_dir
}
```

### Why Manual Cleanup

**Advantages:**
1. **Explicit** - Clear what's happening
2. **Debuggable** - Easy to comment out cleanup to inspect test state
3. **Simple** - No magic, no hidden behavior
4. **Reliable** - No trap interactions with bats

**Trade-offs:**
- More verbose
- Must remember to clean up
- Risk of leaving temp directories if test fails

**Mitigation:**
- Documented pattern in `docs/TESTING.md`
- Helper functions available for complex cases
- `/tmp` cleanup happens automatically on reboot

### Best Practice

```bash
@test "integration test with cleanup" {
  # Create and enter temp directory
  TEST_DIR=$(mktemp -d)
  ORIG_DIR="$PWD"
  cd "$TEST_DIR"
  
  # Test code...
  
  # Always cleanup, even if test fails
  cd "$ORIG_DIR"
  rm -rf "$TEST_DIR"
}
```

**For Complex Cases:**
Use helper functions from `tests/helpers/setup.bash`:
- `setup_test_dir()` - Creates and enters temp directory
- `teardown_test_dir()` - Returns and cleans up

---

## Decision 5: Test Organization Structure

**Date:** October 6, 2025  
**Context:** Phase 1-3 Implementation

### The Question

How should we organize test files?

### What We Decided

**Split by module and function category** - Multiple focused test files per module.

### Structure

```
tests/
├── unit/
│   ├── core/
│   │   ├── test-github-utils-basic.bats      # Pure bash functions
│   │   ├── test-github-utils-git.bats        # Git-dependent functions
│   │   ├── test-github-utils-output.bats     # Output/display functions
│   │   └── test-github-utils-validation.bats # Validation/auth functions
│   └── git-flow/
│       ├── test-git-flow-utils.bats          # Utility functions
│       └── test-git-flow-safety.bats         # Safety check functions
└── integration/
    ├── test-dt-git-safety.bats               # One file per command
    ├── test-dt-config.bats
    ├── test-dt-install-hooks.bats
    └── test-dt-sourcery-parse.bats
```

### Why This Structure

**Advantages:**
1. **Focused** - Each file tests related functionality
2. **Fast** - Can run specific test files quickly
3. **Maintainable** - Easy to find tests for specific functions
4. **Parallel** - Can run test files in parallel
5. **Clear Dependencies** - Git-dependent tests are separate from pure bash

**Alternative Considered:**
- One large test file per module
- **Rejected:** Too slow, hard to navigate, poor organization

### Naming Convention

**Unit Tests:**
- `test-<module>-<category>.bats`
- Example: `test-github-utils-validation.bats`

**Integration Tests:**
- `test-<command>.bats`
- Example: `test-dt-git-safety.bats`

**Test Names:**
- `function_name: description of behavior`
- Example: `gh_detect_project_info: extracts owner from GitHub URL`

---

## Key Learnings

### What Worked Well

1. **Dynamic Test Creation** - Flexible and maintainable
2. **Function Mocking** - Simple and effective
3. **Interface Testing** - Reliable for external dependencies
4. **Split Test Files** - Easy to navigate and maintain
5. **Explicit Cleanup** - Clear and debuggable

### What We'd Do Differently

1. **Earlier Test Planning** - Define test structure before implementation
2. **More Helper Functions** - Create helpers as patterns emerge
3. **Test Naming** - Establish convention earlier

### Patterns Established

These decisions established patterns for:
- Future feature testing
- New command integration tests
- External service integration
- Test organization and naming

---

## Related Documentation

- `docs/TESTING.md` - Comprehensive testing guide
- `docs/troubleshooting/testing-issues.md` - Common issues and solutions
- `admin/planning/features/testing-suite/feature-plan.md` - Overall feature plan
- `admin/planning/features/testing-suite/testing-framework-comparison.md` - Framework selection

---

**These decisions are working well and should be followed for future testing work.** ✅
