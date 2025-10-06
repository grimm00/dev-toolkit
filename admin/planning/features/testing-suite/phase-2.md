# Testing Suite - Phase 2: Core Utilities Testing

**Status:** 📋 Planning  
**Started:** October 6, 2025  
**Target Completion:** 1-2 weeks  
**Branch:** `feat/testing-suite-phase-2`

---

## 🎯 Phase Goal

Write comprehensive unit tests for core utility functions, addressing Sourcery feedback from Phase 1, and achieving 80%+ coverage of critical paths.

**Success Criteria:**
- ✅ Address Sourcery feedback from PR #6
- ✅ Test all core utility functions
- ✅ 80%+ coverage of `lib/core/github-utils.sh`
- ✅ 80%+ coverage of `lib/git-flow/utils.sh`
- ✅ 80%+ coverage of `lib/git-flow/safety.sh`
- ✅ All tests run in < 30 seconds

---

## 📋 Tasks

### 1. Address Sourcery Feedback from PR #6

**From:** `admin/feedback/sourcery/pr06.md`

#### Fix #1: README.md Assumption (LOW Priority)
- [ ] Update test to use `$PROJECT_ROOT/README.md`
- [ ] Or create temp file in setup

**Current:**
```bash
@test "can check if file exists" {
  [ -f "README.md" ]
}
```

**Fixed:**
```bash
@test "can check if file exists" {
  [ -f "$PROJECT_ROOT/README.md" ]
}
```

---

#### Fix #2: PWD Side Effects (MEDIUM Priority)
- [ ] Save original PWD in `setup_test_dir()`
- [ ] Restore PWD in `teardown_test_dir()`

**Current:**
```bash
setup_test_dir() {
  TEST_DIR="$(mktemp -d)"
  cd "$TEST_DIR"
}

teardown_test_dir() {
  rm -rf "$TEST_DIR"
}
```

**Fixed:**
```bash
setup_test_dir() {
  ORIGINAL_PWD="$PWD"
  TEST_DIR="$(mktemp -d)"
  cd "$TEST_DIR"
}

teardown_test_dir() {
  cd "$ORIGINAL_PWD"
  rm -rf "$TEST_DIR"
}
```

---

#### Fix #3: Mock Isolation (MEDIUM Priority)
- [ ] Improve mock cleanup
- [ ] Consider subshell approach for better isolation
- [ ] Document mocking best practices

**Current:** We have `restore_commands()` but could be more robust

**Options:**
1. Keep current approach, improve `restore_commands()`
2. Use Sourcery's subshell suggestion
3. Hybrid: subshells for complex tests, current for simple

**Decision:** Start with improving `restore_commands()`, evaluate subshells if issues arise

---

### 2. Test `lib/core/github-utils.sh`

**Functions to Test:**

#### Configuration Functions
- [ ] `gh_load_config()` - Load from global/project configs
- [ ] `gh_create_default_config()` - Create config files
- [ ] `gh_show_config()` - Display current config

#### Project Detection
- [ ] `gh_detect_project_info()` - Extract from git remote
  - [ ] HTTPS URLs
  - [ ] SSH URLs
  - [ ] With/without .git extension
  - [ ] Invalid URLs (error handling)

#### API Helpers
- [ ] `gh_api_safe()` - Safe API calls with error handling
- [ ] `gh_validate_repository()` - Check repo exists

#### Utility Functions
- [ ] `gh_print_header()` - Format output
- [ ] `gh_print_section()` - Format sections
- [ ] `gh_print_status()` - Status messages

**Test Strategy:**
- Mock `git` and `gh` commands
- Use fixtures for API responses
- Test error conditions
- Verify environment variable handling

---

### 3. Test `lib/git-flow/utils.sh`

**Functions to Test:**

#### Configuration
- [ ] `gf_load_config()` - Load Git Flow config
- [ ] Branch name validation
- [ ] Protected branch checks

#### Branch Operations
- [ ] `gf_get_current_branch()` - Get active branch
- [ ] `gf_is_protected_branch()` - Check if protected
- [ ] `gf_validate_branch_name()` - Check naming convention

#### Git Operations
- [ ] `gf_git_safe()` - Safe git command execution
- [ ] Error handling and recovery

**Test Strategy:**
- Create temporary git repos
- Test with different branch states
- Verify error messages
- Test configuration overrides

---

### 4. Test `lib/git-flow/safety.sh`

**Functions to Test:**

#### Safety Checks
- [ ] Branch safety validation
- [ ] Merge conflict detection
- [ ] Uncommitted changes detection
- [ ] Protected branch warnings

#### Repository Health
- [ ] Check for common issues
- [ ] Verify git state
- [ ] Validate workflow compliance

**Test Strategy:**
- Set up repos in different states
- Test each safety check independently
- Verify warning messages
- Test auto-fix suggestions

---

### 5. Improve Test Infrastructure

Based on Phase 1 experience:

- [ ] Add test timeout wrapper
- [ ] Improve mock documentation
- [ ] Add more assertion helpers
- [ ] Create fixture library for common scenarios

**New Helpers:**
```bash
# tests/helpers/fixtures.bash
create_git_repo_with_changes() {
  # Creates a repo with uncommitted changes
}

create_git_repo_with_conflict() {
  # Creates a repo with merge conflict
}

mock_gh_api_response() {
  # Mocks gh api with fixture file
}
```

---

### 6. Add Test Documentation

- [ ] Update `docs/TESTING.md` with Phase 2 examples
- [ ] Document mocking patterns
- [ ] Add troubleshooting for common test issues
- [ ] Create test writing guide

---

## 🧪 Testing Checklist

### For Each Function Tested
- [ ] Happy path test (valid input)
- [ ] Error handling test (invalid input)
- [ ] Edge cases (empty, null, special chars)
- [ ] Environment variable overrides
- [ ] Configuration file handling

### Test Quality
- [ ] Descriptive test names
- [ ] One assertion per test (when possible)
- [ ] Fast execution (< 1 second per test)
- [ ] Proper cleanup (no side effects)
- [ ] Good error messages

---

## 📊 Progress Tracking

### Sourcery Feedback
- [ ] Fix #1: README.md assumption
- [ ] Fix #2: PWD side effects
- [ ] Fix #3: Mock isolation

### Core Utilities
- [ ] github-utils.sh (0/10 functions)
- [ ] git-flow/utils.sh (0/8 functions)
- [ ] git-flow/safety.sh (0/5 functions)

### Infrastructure
- [ ] Test helpers improved
- [ ] Fixtures created
- [ ] Documentation updated

---

## 🐛 Issues Encountered

*Document any problems here during implementation*

---

## ✅ Success Criteria

- [ ] All Sourcery feedback addressed
- [ ] 80%+ coverage of core functions
- [ ] All tests passing
- [ ] Tests run in < 30 seconds
- [ ] Documentation complete
- [ ] No test isolation issues

---

## 📝 Notes

### Testing Philosophy for Phase 2

**Start Simple, Build Up:**
1. Test pure bash functions first (no external commands)
2. Add mocking for functions with dependencies
3. Test error conditions
4. Test edge cases

**Mocking Strategy:**
- Mock at the command level (`git`, `gh`)
- Use fixtures for complex responses
- Keep mocks simple and focused
- Document what's being mocked and why

**Coverage Goals:**
- 100% of critical path functions
- 80%+ of all functions
- 100% of error handling paths
- Focus on behavior, not implementation

### From Phase 1 Lessons

**What Worked:**
- Simple smoke tests to verify setup
- Custom helpers (setup, mocks, assertions)
- Focused troubleshooting docs
- Test runner script

**What to Improve:**
- Better mock isolation
- More robust test helpers
- Fixture library for common scenarios
- Timeout handling for hanging tests

---

## 🔗 Related

- **Phase 1:** `admin/planning/features/testing-suite/phase-1.md` (✅ Complete)
- **Sourcery Feedback:** `admin/feedback/sourcery/pr06.md`
- **Feature Plan:** `admin/planning/features/testing-suite/feature-plan.md`

---

**Phase Owner:** AI Assistant (Claude)  
**Status:** 📋 Ready to plan implementation  
**Last Updated:** October 6, 2025
