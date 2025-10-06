# Feature Plan: Testing Suite

**Status:** 📋 Planning  
**Priority:** 🎯 HIGH  
**Target Release:** v0.2.0  
**Created:** October 6, 2025

---

## 🎯 Objective

Build a comprehensive testing suite to ensure reliability, catch regressions early, and enable confident feature development.

---

## 🤔 Problem Statement

Currently, the dev-toolkit has:
- ✅ Working features (git-safety, config, hooks, sourcery, etc.)
- ✅ Pre-commit hooks for safety
- ✅ GitHub Actions CI/CD
- ❌ **No automated tests**

**Risks without testing:**
1. **Regressions** - Changes might break existing functionality
2. **Confidence** - Uncertain if changes work across different scenarios
3. **Refactoring** - Hesitant to improve code without safety net
4. **Contributions** - Hard for others to verify their changes work
5. **Documentation** - No executable examples of how things should work

**Current validation:**
- Manual testing (time-consuming, error-prone)
- Pre-commit hooks (only catch some issues)
- CI linting (syntax only, not behavior)

---

## 💡 Proposed Solution

### Testing Strategy

#### 1. Unit Tests
**What:** Test individual functions in isolation  
**Tools:** `bats` (Bash Automated Testing System)  
**Coverage:**
- Core utilities (`lib/core/github-utils.sh`)
- Git Flow utilities (`lib/git-flow/utils.sh`, `safety.sh`)
- Sourcery parser (`lib/sourcery/parser.sh`)
- Configuration management

**Example:**
```bash
@test "gh_detect_project_info extracts owner from remote URL" {
  # Mock git remote
  git() { echo "https://github.com/grimm00/dev-toolkit.git"; }
  export -f git
  
  source lib/core/github-utils.sh
  gh_detect_project_info
  
  [ "$PROJECT_OWNER" = "grimm00" ]
  [ "$PROJECT_REPO" = "grimm00/dev-toolkit" ]
}
```

---

#### 2. Integration Tests
**What:** Test commands end-to-end  
**Tools:** `bats` with real git repos  
**Coverage:**
- `dt-git-safety check`
- `dt-config show/create`
- `dt-install-hooks`
- `dt-sourcery-parse` (with mocked gh responses)

**Example:**
```bash
@test "dt-git-safety detects uncommitted changes" {
  # Setup: Create temp git repo with changes
  cd "$BATS_TEST_TMPDIR"
  git init
  echo "test" > file.txt
  git add file.txt
  echo "modified" >> file.txt
  
  # Test: Run safety check
  run dt-git-safety check
  
  # Assert: Should warn about uncommitted changes
  [ "$status" -eq 1 ]
  [[ "$output" =~ "uncommitted changes" ]]
}
```

---

#### 3. CI/CD Integration
**What:** Run tests automatically on every PR  
**Tools:** GitHub Actions  
**Coverage:**
- All tests on push/PR
- Test multiple shell versions (bash 4, bash 5, zsh)
- Test on multiple OS (Ubuntu, macOS)
- Generate coverage reports

---

#### 4. Test Coverage Reporting
**What:** Track which code is tested  
**Tools:** `kcov` or custom bash coverage  
**Goal:** 80%+ coverage of critical paths

---

## 📋 Implementation Phases

### Phase 1: Foundation (Week 1)
**Goal:** Set up testing infrastructure

**Tasks:**
- [ ] Install and configure `bats`
- [ ] Create `tests/` directory structure
- [ ] Write first unit test (proof of concept)
- [ ] Set up test helpers and fixtures
- [ ] Document testing approach

**Deliverables:**
- `tests/unit/` - Unit test directory
- `tests/integration/` - Integration test directory
- `tests/helpers/` - Test utilities
- `tests/fixtures/` - Mock data
- `docs/TESTING.md` - Testing guide

---

### Phase 2: Core Utilities (Week 2)
**Goal:** Test core library functions

**Tasks:**
- [ ] Test `github-utils.sh` functions
  - [ ] `gh_detect_project_info()`
  - [ ] `gh_load_config()`
  - [ ] `gh_create_default_config()`
  - [ ] `gh_api_safe()`
- [ ] Test `git-flow/utils.sh` functions
  - [ ] Branch detection
  - [ ] Configuration loading
  - [ ] Validation functions
- [ ] Test `git-flow/safety.sh` functions
  - [ ] Safety checks
  - [ ] Conflict detection
  - [ ] Repository health

**Deliverables:**
- `tests/unit/core/test-github-utils.bats`
- `tests/unit/git-flow/test-utils.bats`
- `tests/unit/git-flow/test-safety.bats`

---

### Phase 3: Commands (Week 3)
**Goal:** Test command wrappers end-to-end

**Tasks:**
- [ ] Test `dt-git-safety`
  - [ ] All subcommands (check, branch, conflicts, prs, fix)
  - [ ] Different repository states
  - [ ] Error handling
- [ ] Test `dt-config`
  - [ ] Show, create, edit operations
  - [ ] Global vs project configs
  - [ ] Environment variable overrides
- [ ] Test `dt-install-hooks`
  - [ ] Hook installation
  - [ ] Hook execution
  - [ ] Error cases

**Deliverables:**
- `tests/integration/test-dt-git-safety.bats`
- `tests/integration/test-dt-config.bats`
- `tests/integration/test-dt-install-hooks.bats`

---

### Phase 4: CI/CD & Coverage (Week 4)
**Goal:** Automate testing and track coverage

**Tasks:**
- [ ] Add test job to `.github/workflows/ci.yml`
- [ ] Test on multiple platforms (Ubuntu, macOS)
- [ ] Test multiple shell versions
- [ ] Set up coverage reporting
- [ ] Add coverage badge to README
- [ ] Document CI/CD testing

**Deliverables:**
- Updated `.github/workflows/ci.yml`
- Coverage reports in CI
- `docs/TESTING.md` updated with CI info

---

## 🧪 Testing Approach

### Test Structure

```
tests/
├── unit/                      # Unit tests (fast, isolated)
│   ├── core/
│   │   └── test-github-utils.bats
│   ├── git-flow/
│   │   ├── test-utils.bats
│   │   └── test-safety.bats
│   └── sourcery/
│       └── test-parser.bats
├── integration/               # Integration tests (slower, real scenarios)
│   ├── test-dt-git-safety.bats
│   ├── test-dt-config.bats
│   ├── test-dt-install-hooks.bats
│   └── test-dt-sourcery-parse.bats
├── helpers/                   # Test utilities
│   ├── setup.bash            # Common setup functions
│   ├── assertions.bash       # Custom assertions
│   └── mocks.bash            # Mock functions
└── fixtures/                  # Test data
    ├── repos/                # Sample git repos
    ├── configs/              # Sample configs
    └── responses/            # Mock API responses
```

---

### Test Naming Convention

```bash
@test "function_name: should do X when Y" {
  # Arrange - Set up test conditions
  # Act - Execute the function
  # Assert - Verify the results
}
```

**Examples:**
- `gh_detect_project_info: should extract owner from HTTPS URL`
- `dt-git-safety check: should fail when on protected branch`
- `dt-config create: should create global config with defaults`

---

### Mocking Strategy

**Git Commands:**
```bash
# Mock git to return specific output
git() {
  case "$1" in
    "remote") echo "https://github.com/grimm00/dev-toolkit.git" ;;
    "branch") echo "* main" ;;
  esac
}
export -f git
```

**GitHub CLI:**
```bash
# Mock gh to return fixture data
gh() {
  case "$1 $2" in
    "repo view") cat tests/fixtures/responses/repo-view.json ;;
    "pr view") cat tests/fixtures/responses/pr-view.json ;;
  esac
}
export -f gh
```

---

## 🎯 Success Criteria

### Phase 1 (Foundation)
- [ ] `bats` installed and working
- [ ] Test structure created
- [ ] First test passing
- [ ] Documentation written

### Phase 2 (Core Utilities)
- [ ] 80%+ coverage of core functions
- [ ] All critical paths tested
- [ ] Edge cases covered
- [ ] Tests run in < 5 seconds

### Phase 3 (Commands)
- [ ] All commands tested end-to-end
- [ ] Error cases handled
- [ ] Tests run in < 30 seconds
- [ ] Real-world scenarios covered

### Phase 4 (CI/CD)
- [ ] Tests run on every PR
- [ ] Multiple platforms tested
- [ ] Coverage reports generated
- [ ] Badge in README

### Overall
- [ ] 80%+ test coverage
- [ ] All tests passing
- [ ] Fast test execution (< 1 minute total)
- [ ] Easy to add new tests
- [ ] Clear documentation

---

## 📊 Benefits

### Immediate
1. **Confidence** - Know changes work before merging
2. **Regression Prevention** - Catch breaking changes automatically
3. **Documentation** - Tests show how to use functions
4. **Faster Development** - Less manual testing needed

### Long-term
1. **Refactoring Safety** - Improve code without fear
2. **Contribution Quality** - Contributors can verify their changes
3. **Stability** - Fewer bugs in production
4. **Maintenance** - Easier to understand code behavior

---

## 🚧 Challenges & Solutions

### Challenge 1: Testing Shell Scripts
**Problem:** Shell scripts are hard to test (side effects, external commands)  
**Solution:** Use `bats` with mocking strategy, isolate functions

### Challenge 2: External Dependencies
**Problem:** Tests need `git`, `gh`, etc.  
**Solution:** Mock external commands, use fixtures for responses

### Challenge 3: Test Speed
**Problem:** Integration tests can be slow  
**Solution:** Separate unit (fast) from integration (slower), run unit tests first

### Challenge 4: Coverage Measurement
**Problem:** Bash coverage tools are limited  
**Solution:** Use `kcov` or track manually, focus on critical paths first

---

## 🔗 Related

- **Roadmap:** Testing is HIGH priority for v0.2.0
- **CI/CD:** Already have `.github/workflows/ci.yml` for linting
- **Pre-commit Hooks:** Can run tests before commit (optional)

---

## 📝 Open Questions

1. **Test Framework:** `bats` vs `shunit2` vs custom?
   - **Recommendation:** `bats` (most popular, good docs, active)

2. **Coverage Tool:** `kcov` vs manual tracking?
   - **Recommendation:** Start manual, add `kcov` later if needed

3. **Test Isolation:** Docker containers vs temp directories?
   - **Recommendation:** Temp directories (simpler, faster)

4. **Mock Strategy:** Full mocking vs real commands?
   - **Recommendation:** Mock external APIs, use real git/bash

---

## 🎯 Next Steps

1. **Review this plan** - Get feedback and approval
2. **Create Phase 1 document** - Detailed implementation plan
3. **Start implementation** - Set up `bats` and first test
4. **Iterate** - Add tests incrementally, improve as we go

---

**Status:** 📋 Awaiting approval  
**Owner:** AI Assistant (Claude)  
**Reviewer:** User (cdwilson)  
**Last Updated:** October 6, 2025
