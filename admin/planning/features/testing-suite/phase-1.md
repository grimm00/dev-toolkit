# Testing Suite - Phase 1: Foundation

**Status:** 📋 Planning  
**Started:** October 6, 2025  
**Target Completion:** 1 week  
**Branch:** `feat/testing-suite-phase-1`

---

## 🎯 Phase Goal

Set up testing infrastructure and write first proof-of-concept tests.

**Success Criteria:**
- ✅ bats-core installed and working
- ✅ Test directory structure created
- ✅ First unit test passing
- ✅ First integration test passing
- ✅ Documentation written

---

## 📋 Tasks

### 1. Install bats-core and Helpers
- [ ] Install bats-core
- [ ] Install bats-support (better assertions)
- [ ] Install bats-assert (assertion helpers)
- [ ] Install bats-file (file system assertions)
- [ ] Verify installation works

**Commands:**
```bash
# macOS
brew install bats-core

# Install helper libraries
brew tap kaos/shell
brew install bats-assert bats-file bats-support

# Verify
bats --version
```

---

### 2. Create Test Directory Structure
- [ ] Create `tests/` directory
- [ ] Create `tests/unit/` for unit tests
- [ ] Create `tests/integration/` for integration tests
- [ ] Create `tests/helpers/` for test utilities
- [ ] Create `tests/fixtures/` for test data

**Structure:**
```
tests/
├── unit/
│   ├── core/
│   │   └── test-github-utils.bats
│   ├── git-flow/
│   │   ├── test-utils.bats
│   │   └── test-safety.bats
│   └── sourcery/
│       └── test-parser.bats
├── integration/
│   ├── test-dt-git-safety.bats
│   ├── test-dt-config.bats
│   └── test-dt-install-hooks.bats
├── helpers/
│   ├── setup.bash
│   ├── mocks.bash
│   └── assertions.bash
└── fixtures/
    ├── repos/
    ├── configs/
    └── responses/
```

---

### 3. Create Test Helpers
- [ ] `helpers/setup.bash` - Common setup functions
- [ ] `helpers/mocks.bash` - Mock external commands
- [ ] `helpers/assertions.bash` - Custom assertions

**Example `helpers/setup.bash`:**
```bash
#!/usr/bin/env bash

# Common setup for all tests
setup_file() {
  export PROJECT_ROOT="$(cd "$(dirname "$BATS_TEST_FILENAME")/../.." && pwd)"
  export PATH="$PROJECT_ROOT/bin:$PATH"
  export DT_ROOT="$PROJECT_ROOT"
}

# Create temporary test directory
setup_test_dir() {
  TEST_DIR="$(mktemp -d)"
  cd "$TEST_DIR"
}

# Cleanup temporary directory
teardown_test_dir() {
  if [ -n "$TEST_DIR" ] && [ -d "$TEST_DIR" ]; then
    rm -rf "$TEST_DIR"
  fi
}
```

---

### 4. Write First Unit Test
- [ ] Test `gh_detect_project_info()` function
- [ ] Test with HTTPS URL
- [ ] Test with SSH URL
- [ ] Test with invalid URL

**Example:**
```bash
#!/usr/bin/env bats

load '../helpers/setup'

setup() {
  source "$PROJECT_ROOT/lib/core/github-utils.sh"
}

@test "gh_detect_project_info: extracts owner from HTTPS URL" {
  # Mock git command
  git() { echo "https://github.com/grimm00/dev-toolkit.git"; }
  export -f git
  
  gh_detect_project_info
  
  [ "$PROJECT_OWNER" = "grimm00" ]
  [ "$PROJECT_REPO" = "grimm00/dev-toolkit" ]
  [ "$PROJECT_NAME" = "dev-toolkit" ]
}

@test "gh_detect_project_info: extracts owner from SSH URL" {
  git() { echo "git@github.com:grimm00/dev-toolkit.git"; }
  export -f git
  
  gh_detect_project_info
  
  [ "$PROJECT_OWNER" = "grimm00" ]
  [ "$PROJECT_REPO" = "grimm00/dev-toolkit" ]
}
```

---

### 5. Write First Integration Test
- [ ] Test `dt-git-safety check` command
- [ ] Test in clean git repo
- [ ] Test with uncommitted changes
- [ ] Test on protected branch

**Example:**
```bash
#!/usr/bin/env bats

load '../helpers/setup'

setup() {
  setup_test_dir
  git init
  git config user.email "test@example.com"
  git config user.name "Test User"
}

teardown() {
  teardown_test_dir
}

@test "dt-git-safety check: passes in clean repo" {
  # Create initial commit
  echo "test" > README.md
  git add README.md
  git commit -m "Initial commit"
  git checkout -b feat/test
  
  run dt-git-safety check
  
  [ "$status" -eq 0 ]
  [[ "$output" =~ "safety checks passed" ]]
}

@test "dt-git-safety check: warns about uncommitted changes" {
  echo "test" > file.txt
  git add file.txt
  echo "modified" >> file.txt
  
  run dt-git-safety check
  
  [ "$status" -eq 1 ]
  [[ "$output" =~ "uncommitted changes" ]]
}
```

---

### 6. Add Test Runner Script
- [ ] Create `scripts/test.sh` for easy test running
- [ ] Support running all tests
- [ ] Support running specific test files
- [ ] Support verbose output

**Example:**
```bash
#!/usr/bin/env bash

set -euo pipefail

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

# Run tests
echo "🧪 Running tests..."
echo ""

if [ $# -eq 0 ]; then
  # Run all tests
  bats tests/
else
  # Run specific test file
  bats "$@"
fi

# Check result
if [ $? -eq 0 ]; then
  echo ""
  echo -e "${GREEN}✅ All tests passed!${NC}"
else
  echo ""
  echo -e "${RED}❌ Some tests failed${NC}"
  exit 1
fi
```

---

### 7. Update CI/CD
- [ ] Add test job to `.github/workflows/ci.yml`
- [ ] Install bats in CI
- [ ] Run tests on every push/PR
- [ ] Report test results

**Example:**
```yaml
test:
  name: Run Tests
  runs-on: ubuntu-latest
  steps:
    - uses: actions/checkout@v3
    
    - name: Install bats
      run: |
        sudo apt-get update
        sudo apt-get install -y bats
    
    - name: Run tests
      run: bats tests/
```

---

### 8. Write Documentation
- [ ] Create `docs/TESTING.md`
- [ ] Document how to run tests
- [ ] Document how to write tests
- [ ] Document test structure
- [ ] Add examples

**Sections:**
- Running tests locally
- Writing unit tests
- Writing integration tests
- Mocking external commands
- CI/CD integration
- Troubleshooting

---

## 🧪 Testing Checklist

### Unit Tests
- [ ] Test passes with valid input
- [ ] Test fails with invalid input
- [ ] Test handles edge cases
- [ ] Test runs in < 1 second

### Integration Tests
- [ ] Test runs end-to-end
- [ ] Test uses real commands (git, etc.)
- [ ] Test cleans up after itself
- [ ] Test runs in < 5 seconds

### CI/CD
- [ ] Tests run on push
- [ ] Tests run on PR
- [ ] Test failures block merge
- [ ] Test output is readable

---

## 📊 Progress Tracking

### Completed
- [ ] bats-core installed
- [ ] Test structure created
- [ ] Test helpers written
- [ ] First unit test passing
- [ ] First integration test passing
- [ ] Test runner script created
- [ ] CI/CD updated
- [ ] Documentation written

### In Progress
- (mark tasks as you work on them)

### Blocked
- None

---

## 🐛 Issues Encountered

*Document any problems here during implementation*

---

## ✅ Success Criteria

- [ ] bats-core installed and verified
- [ ] Test directory structure created
- [ ] At least 2 unit tests passing
- [ ] At least 1 integration test passing
- [ ] Tests run in CI/CD
- [ ] Documentation complete
- [ ] Team can run tests locally

---

## 📝 Notes

### Installation Notes
- bats-core is available via Homebrew on macOS
- On Linux, may need to install from source
- Helper libraries are optional but recommended

### Testing Philosophy
- **Unit tests:** Fast, isolated, test individual functions
- **Integration tests:** Slower, test real scenarios
- **Keep tests simple:** Easy to understand and maintain
- **Mock external dependencies:** Don't rely on network, etc.

### Next Phase Preview
Phase 2 will focus on:
- Testing all core utility functions
- Achieving 80%+ coverage of lib/core/
- Testing all git-flow functions
- Expanding integration tests

---

**Phase Owner:** AI Assistant (Claude)  
**Status:** 📋 Ready to implement  
**Last Updated:** October 6, 2025
