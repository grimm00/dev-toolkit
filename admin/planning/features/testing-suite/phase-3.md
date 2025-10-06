# Testing Suite - Phase 3: Edge Cases & Enhancements

**Status:** 📋 Planned  
**Started:** TBD  
**Target Completion:** 1-2 days  
**Branch:** `feat/testing-suite-phase-3`

**Goal:** Address Sourcery feedback from PR #8, adding edge case tests and error handling coverage

---

## 🎯 Phase Goal

Enhance test coverage by addressing all 10 Sourcery suggestions from PR #8, focusing on edge cases, error handling, and configuration scenarios.

**Success Criteria:**
- [ ] Address all 10 Sourcery suggestions from PR #8
- [ ] Add ~8-10 new tests (some suggestions are duplicates)
- [ ] Maintain 100% test pass rate
- [ ] Keep execution time under 15 seconds
- [ ] Document new testing patterns

---

## 📊 Sourcery Feedback Analysis

Based on `admin/feedback/sourcery/pr08.md`, we have 10 suggestions grouped into 4 themes:

### Theme 1: Custom Protected Branches (3 suggestions - duplicates)
**Comments:** #1, #7, #9  
**Priority:** 🟢 LOW  
**Effort:** 🟢 LOW  
**Impact:** 🟡 MEDIUM

These are the same suggestion across three different test files. Implement once to satisfy all three.

### Theme 2: Multiple Missing Dependencies (2 suggestions)
**Comments:** #3, #8  
**Priority:** 🟡 MEDIUM  
**Effort:** 🟢 LOW  
**Impact:** 🟡 MEDIUM

Test behavior when multiple required dependencies are missing simultaneously.

### Theme 3: Error Handling (3 suggestions)
**Comments:** #2, #6, #10  
**Priority:** 🟡 MEDIUM  
**Effort:** 🟢 LOW  
**Impact:** 🟡 MEDIUM

Strengthen error handling coverage:
- Secret validation (length/entropy)
- Malformed remote URLs
- Active merge conflicts

### Theme 4: Optional Dependencies (2 suggestions)
**Comments:** #4, #5  
**Priority:** 🟢 LOW  
**Effort:** 🟡 MEDIUM  
**Impact:** 🟢 LOW

Test optional dependency scenarios:
- jq not installed
- Multiple git remotes

---

## 📋 Tasks

### 1. Custom Protected Branch Configuration (Addresses #1, #7, #9)

**Files to Update:**
- `tests/unit/core/test-github-utils-basic.bats`
- `tests/unit/git-flow/test-git-flow-utils.bats`
- `tests/unit/git-flow/test-git-flow-safety.bats`

**Tests to Add:** 3 tests (one per file)

#### Test 1: github-utils custom protected branch
```bash
@test "gh_is_protected_branch: identifies custom protected branch from config" {
  # Set custom protected branch via environment
  export GH_PROTECTED_BRANCHES=("main" "develop" "release")
  
  run gh_is_protected_branch "release"
  [ "$status" -eq 0 ]
  
  unset GH_PROTECTED_BRANCHES
}
```

#### Test 2: git-flow utils custom protected branch
```bash
@test "gf_is_protected_branch: identifies custom protected branch from config" {
  # Set custom protected branch via environment
  export GF_PROTECTED_BRANCHES=("main" "develop" "release")
  
  run gf_is_protected_branch "release"
  [ "$status" -eq 0 ]
  
  unset GF_PROTECTED_BRANCHES
}
```

#### Test 3: git-flow safety custom protected branch
```bash
@test "safety script: detects custom protected branch from config" {
  # Set custom protected branch and mock git
  export GF_PROTECTED_BRANCHES=("main" "develop" "release")
  
  git() {
    if [ "$1" = "branch" ] && [ "$2" = "--show-current" ]; then
      echo "release"
      return 0
    elif [ "$1" = "rev-parse" ]; then
      return 0
    fi
    command git "$@"
  }
  export -f git
  
  run bash "$PROJECT_ROOT/lib/git-flow/safety.sh" branch
  [ "$status" -eq 1 ]
  [[ "$output" =~ "protected branch" ]]
  
  unset GF_PROTECTED_BRANCHES
}
```

**Estimated Time:** 30 minutes

---

### 2. Multiple Missing Dependencies (Addresses #3, #8)

**Files to Update:**
- `tests/unit/core/test-github-utils-validation.bats`
- `tests/unit/git-flow/test-git-flow-utils.bats`

**Tests to Add:** 2 tests

#### Test 1: github-utils multiple missing deps
```bash
@test "gh_check_required_dependencies: fails when both git and gh missing" {
  # Mock both git and gh as missing
  command() {
    if [ "$1" = "-v" ] && { [ "$2" = "git" ] || [ "$2" = "gh" ]; }; then
      return 1
    fi
    builtin command "$@"
  }
  export -f command
  
  run gh_check_required_dependencies
  [ "$status" -eq 1 ]
  [[ "$output" =~ "git" ]]
  [[ "$output" =~ "gh" ]]
}
```

#### Test 2: git-flow multiple missing deps
```bash
@test "gf_check_required_dependencies: fails when multiple dependencies missing" {
  # Mock git and bash as missing
  command() {
    if [ "$1" = "-v" ] && { [ "$2" = "git" ] || [ "$2" = "bash" ]; }; then
      return 1
    fi
    builtin command "$@"
  }
  export -f command
  
  run gf_check_required_dependencies
  [ "$status" -eq 1 ]
  [[ "$output" =~ "git" ]]
  [[ "$output" =~ "bash" ]]
}
```

**Estimated Time:** 20 minutes

---

### 3. Secret Validation Enhancement (Addresses #2)

**File to Update:**
- `tests/unit/core/test-github-utils-basic.bats`

**Tests to Add:** 1 test (replace existing)

#### Enhanced secret test
```bash
@test "gh_generate_secret: generates secure secrets with sufficient length and entropy" {
  result=$(gh_generate_secret)
  
  # Base64 format check
  [[ "$result" =~ ^[a-zA-Z0-9+/=]+$ ]]
  
  # Minimum length check (32 characters)
  [ "${#result}" -ge 32 ]
  
  # Entropy checks - base64 should have variety
  [[ "$result" =~ [A-Z] ]]  # Has uppercase
  [[ "$result" =~ [a-z] ]]  # Has lowercase
  [[ "$result" =~ [0-9] ]]  # Has digits
  # Note: +/= may not always be present in short strings, so we check for variety
}
```

**Estimated Time:** 15 minutes

---

### 4. Malformed Remote URL Handling (Addresses #6)

**File to Update:**
- `tests/unit/core/test-github-utils-git.bats`

**Tests to Add:** 1 test

#### Malformed URL test
```bash
@test "gh_detect_project_info: handles malformed remote URL gracefully" {
  # Mock git to return a malformed remote URL
  git() {
    if [ "$1" = "remote" ] && [ "$2" = "get-url" ]; then
      echo "malformed-url-without-proper-format"
      return 0
    elif [ "$1" = "rev-parse" ] && [ "$2" = "--show-toplevel" ]; then
      echo "/Users/test/my-project-name"
      return 0
    fi
    command git "$@"
  }
  export -f git
  
  # Mock gh to fail
  gh() {
    return 1
  }
  export -f gh
  
  # Function should fall back to directory name
  gh_detect_project_info || true
  
  [ "$PROJECT_NAME" = "my-project-name" ]
  # PROJECT_OWNER and PROJECT_REPO should be empty or unset
  [ -z "${PROJECT_OWNER:-}" ]
  [ -z "${PROJECT_REPO:-}" ]
}
```

**Estimated Time:** 15 minutes

---

### 5. Active Merge Conflict Detection (Addresses #10)

**File to Update:**
- `tests/unit/git-flow/test-git-flow-safety.bats`

**Tests to Add:** 1 test

#### Merge conflict test
```bash
@test "safety script: detects active merge conflict" {
  setup_test_dir
  init_test_repo
  
  # Create a merge conflict scenario
  # Create MERGE_HEAD file to simulate merge in progress
  git_dir=$(git rev-parse --git-dir)
  touch "$git_dir/MERGE_HEAD"
  
  run bash "$PROJECT_ROOT/lib/git-flow/safety.sh" conflicts
  
  # Clean up
  rm -f "$git_dir/MERGE_HEAD"
  teardown_test_dir
  
  [ "$status" -ne 0 ]
  [[ "$output" =~ "Merge Conflict Check" ]]
  [[ "$output" =~ "merge" || "$output" =~ "conflict" ]]
}
```

**Estimated Time:** 20 minutes

---

### 6. Optional Dependency Missing (Addresses #4)

**File to Update:**
- `tests/unit/core/test-github-utils-validation.bats`

**Tests to Add:** 1 test

#### jq missing test
```bash
@test "gh_check_optional_dependencies: warns when jq is missing" {
  # Mock jq as not installed
  command() {
    if [ "$1" = "-v" ] && [ "$2" = "jq" ]; then
      return 1
    fi
    builtin command "$@"
  }
  export -f command
  
  run gh_check_optional_dependencies
  [ "$status" -eq 0 ]  # Should still succeed (optional)
  [[ "$output" =~ "jq" ]]
  [[ "$output" =~ "optional" || "$output" =~ "not installed" || "$output" =~ "warning" ]]
}
```

**Estimated Time:** 15 minutes

---

### 7. Multiple Git Remotes (Addresses #5)

**File to Update:**
- `tests/unit/core/test-github-utils-validation.bats`

**Tests to Add:** 1 test

#### Multiple remotes test
```bash
@test "gh_validate_repository: handles multiple remotes" {
  setup_test_dir
  init_test_repo
  
  # Add multiple remotes
  git remote add origin https://github.com/owner1/repo1.git
  git remote add upstream https://github.com/owner2/repo2.git
  
  # Mock gh to succeed
  gh() {
    return 0
  }
  export -f gh
  
  run gh_validate_repository
  
  teardown_test_dir
  
  # Should succeed and use 'origin' by default
  [ "$status" -eq 0 ]
}
```

**Estimated Time:** 20 minutes

**Note:** This is lower priority as it's an edge case. May defer if time-constrained.

---

### 8. Update Documentation

**Files to Update:**
- `docs/TESTING.md` - Add new patterns
- `docs/troubleshooting/testing-issues.md` - Add any new issues encountered
- `admin/planning/features/testing-suite/phase-3.md` - Update progress

**Tasks:**
- [ ] Document custom configuration testing pattern
- [ ] Document multiple dependency failure testing
- [ ] Document merge conflict simulation
- [ ] Add examples to TESTING.md

**Estimated Time:** 30 minutes

---

## 🧪 Testing Checklist

### For Each New Test
- [ ] Descriptive test name
- [ ] Proper setup/teardown
- [ ] Clear assertions
- [ ] Cleanup of environment variables
- [ ] Fast execution (< 1 second)
- [ ] No side effects

### Test Quality
- [ ] Tests are independent
- [ ] Mocks are properly scoped
- [ ] Error messages are clear
- [ ] Edge cases are covered

---

## 📊 Progress Tracking

### Tests Added
- [ ] Custom protected branches (3 tests)
- [ ] Multiple missing dependencies (2 tests)
- [ ] Secret validation enhancement (1 test)
- [ ] Malformed URL handling (1 test)
- [ ] Active merge conflict (1 test)
- [ ] Optional dependency missing (1 test)
- [ ] Multiple git remotes (1 test)

**Total:** 10 new tests

### Test Count Projection
- Current: 129 tests
- Phase 3 additions: +10 tests
- **Target:** 139 tests

### Performance Target
- Current: < 10 seconds
- Target: < 15 seconds
- Acceptable: < 20 seconds

---

## ✅ Success Criteria

- [ ] All 10 Sourcery suggestions addressed
- [ ] 139+ tests passing (129 + 10)
- [ ] 100% test pass rate maintained
- [ ] Execution time < 15 seconds
- [ ] Documentation updated
- [ ] No new test isolation issues
- [ ] Phase 3 complete and ready for PR

---

## 🎯 Implementation Strategy

### Approach
1. **Group by file** - Update one test file at a time
2. **Test incrementally** - Run tests after each addition
3. **Document as you go** - Note any issues in testing-issues.md
4. **Commit frequently** - One commit per theme or file

### Recommended Order
1. **Start with easy wins** - Secret validation, multiple deps (30 min)
2. **Configuration tests** - Custom protected branches (30 min)
3. **Error handling** - Malformed URLs, merge conflicts (35 min)
4. **Optional tests** - jq missing, multiple remotes (35 min)
5. **Documentation** - Update guides (30 min)

**Total Estimated Time:** 2.5 hours

---

## 📝 Notes

### Why Phase 3?

Phase 2 achieved excellent coverage (95%/90%), but Sourcery identified valuable edge cases that will make our tests even more robust:

1. **Configuration flexibility** - Test custom settings
2. **Error scenarios** - Better error handling coverage
3. **Edge cases** - Malformed data, multiple dependencies
4. **Optional features** - Graceful degradation

### Testing Philosophy

These tests follow the "defensive programming" principle:
- Test what happens when things go wrong
- Verify graceful degradation
- Ensure clear error messages
- Handle edge cases explicitly

### Benefits

After Phase 3:
- More robust error handling
- Better configuration testing
- Comprehensive edge case coverage
- Stronger test foundation for future work

---

## 🔗 Related

- **Phase 2:** `admin/planning/features/testing-suite/phase-2.md` (✅ Complete)
- **Sourcery Review:** `admin/feedback/sourcery/pr08.md`
- **Feature Plan:** `admin/planning/features/testing-suite/feature-plan.md`
- **PR #8:** https://github.com/grimm00/dev-toolkit/pull/8 (✅ Merged)

---

**Phase Owner:** AI Assistant (Claude)  
**Status:** 📋 Planned  
**Estimated Effort:** 2.5 hours  
**Priority:** 🟡 MEDIUM (enhancements, not critical)

---

## 🚀 Getting Started

When ready to begin Phase 3:

```bash
# Create feature branch from develop
git checkout develop
git pull origin develop
git checkout -b feat/testing-suite-phase-3

# Start with easy wins
# 1. Add secret validation test
# 2. Add multiple dependency tests
# 3. Continue with remaining tests

# Run tests frequently
./scripts/test.sh

# Commit incrementally
git add tests/
git commit -m "feat: Add secret validation tests"

# Create PR when complete
gh pr create --base develop --title "feat: Phase 3 Testing Suite - Edge Cases"
```

---

**Ready to enhance our already excellent test coverage!** 🎯
