# Testing Framework Comparison for Dev Toolkit

**Date:** October 6, 2025  
**Purpose:** Evaluate testing frameworks for bash scripts

---

## Options Considered

1. **bats-core** (Bash Automated Testing System)
2. **shunit2** (Shell Unit Test Framework)
3. **Custom Solution** (Roll our own)
4. **shellspec** (BDD-style testing)

---

## 1. bats-core

**Repository:** https://github.com/bats-core/bats-core  
**Stars:** ~4.8k  
**Last Updated:** Active (2024)  
**License:** MIT

### Pros ✅

1. **Most Popular** - De facto standard for bash testing
2. **Active Development** - Regular updates, maintained
3. **Great Documentation** - Lots of examples, tutorials
4. **Helper Libraries** - bats-support, bats-assert, bats-file
5. **TAP Output** - Test Anything Protocol (CI-friendly)
6. **Simple Syntax** - Easy to read and write
7. **Parallel Execution** - Can run tests in parallel
8. **Good Error Messages** - Clear failure output

### Cons ❌

1. **External Dependency** - Need to install bats
2. **Learning Curve** - Team needs to learn bats syntax
3. **Subshell Isolation** - Each test runs in subshell (can be tricky)
4. **Mock Complexity** - Mocking external commands requires workarounds

### Example

```bash
#!/usr/bin/env bats

@test "addition works" {
  result="$(echo 2+2 | bc)"
  [ "$result" -eq 4 ]
}

@test "can detect git repository" {
  run git rev-parse --git-dir
  [ "$status" -eq 0 ]
}
```

### Installation

```bash
# macOS
brew install bats-core

# Linux
git clone https://github.com/bats-core/bats-core.git
cd bats-core
./install.sh /usr/local

# CI (GitHub Actions)
- uses: bats-core/bats-action@2.0.0
```

---

## 2. shunit2

**Repository:** https://github.com/kward/shunit2  
**Stars:** ~1.5k  
**Last Updated:** Less active  
**License:** Apache 2.0

### Pros ✅

1. **Single File** - Just source one file, no installation
2. **xUnit Style** - Familiar to developers (setUp, tearDown)
3. **Portable** - Works on many shells (bash, zsh, dash)
4. **Mature** - Been around since 2008
5. **Simple** - Straightforward assertion functions

### Cons ❌

1. **Less Active** - Not as frequently updated
2. **Smaller Community** - Fewer examples, less support
3. **Verbose** - More boilerplate than bats
4. **No Parallel** - Tests run sequentially only
5. **Limited Helpers** - No ecosystem of helper libraries

### Example

```bash
#!/bin/bash

testAddition() {
  result="$(echo 2+2 | bc)"
  assertEquals "addition failed" 4 "$result"
}

testGitRepository() {
  git rev-parse --git-dir
  assertTrue "not a git repo" $?
}

# Load shunit2
. shunit2
```

---

## 3. Custom Solution

**Cost:** Development time  
**Maintenance:** Ongoing

### Pros ✅

1. **No Dependencies** - Pure bash
2. **Full Control** - Customize exactly to our needs
3. **Learning Tool** - Understand testing deeply
4. **Lightweight** - Only what we need

### Cons ❌

1. **Time Investment** - Need to build and maintain
2. **Reinventing Wheel** - Others solved this already
3. **Missing Features** - Would need to add parallel, TAP, etc.
4. **No Community** - No external help or examples
5. **Testing the Tests** - Who tests our test framework?

### Example

```bash
#!/bin/bash

# Simple test runner
test_count=0
pass_count=0
fail_count=0

assert_equals() {
  test_count=$((test_count + 1))
  if [ "$1" = "$2" ]; then
    pass_count=$((pass_count + 1))
    echo "✓ Test $test_count passed"
  else
    fail_count=$((fail_count + 1))
    echo "✗ Test $test_count failed: expected '$2', got '$1'"
  fi
}

# Tests
result="$(echo 2+2 | bc)"
assert_equals "$result" "4"

# Summary
echo "Passed: $pass_count, Failed: $fail_count"
```

---

## 4. shellspec

**Repository:** https://github.com/shellspec/shellspec  
**Stars:** ~1.1k  
**Last Updated:** Active  
**License:** MIT

### Pros ✅

1. **BDD Style** - Describe/It syntax (RSpec-like)
2. **Modern** - More recent than shunit2
3. **Good Features** - Mocking, stubbing, coverage
4. **Active** - Regular updates
5. **Readable** - Natural language style

### Cons ❌

1. **Less Popular** - Smaller community than bats
2. **More Complex** - Steeper learning curve
3. **Heavier** - More features = more complexity
4. **Overkill?** - May be too much for our needs

### Example

```bash
Describe 'Calculator'
  It 'adds numbers correctly'
    When call echo "2+2" | bc
    The output should equal 4
  End

  It 'detects git repository'
    When call git rev-parse --git-dir
    The status should be success
  End
End
```

---

## Comparison Matrix

| Feature | bats-core | shunit2 | Custom | shellspec |
|---------|-----------|---------|--------|-----------|
| **Popularity** | ⭐⭐⭐⭐⭐ | ⭐⭐⭐ | ⭐ | ⭐⭐⭐ |
| **Active Development** | ✅ | ⚠️ | N/A | ✅ |
| **Easy Installation** | ✅ | ✅✅ | ✅✅✅ | ✅ |
| **Learning Curve** | Low | Low | None | Medium |
| **Documentation** | ⭐⭐⭐⭐⭐ | ⭐⭐⭐ | N/A | ⭐⭐⭐⭐ |
| **Helper Libraries** | ✅✅✅ | ❌ | ❌ | ✅✅ |
| **Parallel Tests** | ✅ | ❌ | ❌ | ✅ |
| **CI Integration** | ✅✅✅ | ✅✅ | ✅ | ✅✅ |
| **Maintenance Burden** | Low | Low | High | Low |
| **Community Support** | ⭐⭐⭐⭐⭐ | ⭐⭐⭐ | ❌ | ⭐⭐⭐ |

---

## Real-World Usage

### Projects Using bats
- **Homebrew** - Package manager testing
- **Docker** - Container testing scripts
- **rbenv** - Ruby version manager
- **nvm** - Node version manager
- **Many GitHub Actions** - Workflow testing

### Projects Using shunit2
- **Google's shell style guide** examples
- Some older bash projects
- Less common in modern projects

### Projects Using shellspec
- Newer projects wanting BDD style
- Less widespread adoption

---

## Our Context: Dev Toolkit

### What We're Testing
- Core utilities (github-utils.sh, git-flow-utils.sh)
- Command wrappers (dt-git-safety, dt-config, etc.)
- Integration with external tools (git, gh)
- Configuration management
- Pre-commit hooks

### Our Constraints
1. **Portability** - Must work on macOS and Linux
2. **CI/CD** - Need GitHub Actions integration
3. **Maintainability** - Team should understand tests
4. **Speed** - Tests should run fast
5. **Coverage** - Need to track what's tested

### Our Priorities
1. **Get tests written** - Framework should be easy
2. **Catch regressions** - Reliable test execution
3. **CI integration** - Automated on every PR
4. **Community support** - Help when stuck

---

## Recommendation

### 🎯 Primary Choice: bats-core

**Reasoning:**

1. **Industry Standard** - Most bash projects use it
2. **Active & Maintained** - Won't be abandoned
3. **Great Ecosystem** - Helper libraries available
4. **CI-Friendly** - GitHub Actions support
5. **Good Documentation** - Easy to learn
6. **Parallel Execution** - Faster test runs
7. **TAP Output** - Standard format for CI

**Trade-offs Accepted:**
- Need to install bats (acceptable for dev tool)
- Small learning curve (worth it for features)
- Subshell isolation (actually a good thing)

### 🥈 Backup Choice: shunit2

**If bats doesn't work:**
- Single file, easy to vendor
- Simpler, less magic
- Good for basic testing

**When to use:**
- If bats installation is problematic
- If team prefers xUnit style
- If we need extreme portability

---

## Implementation Plan with bats

### Phase 1: Setup (Day 1)

```bash
# Install bats
brew install bats-core bats-support bats-assert bats-file

# Create test structure
mkdir -p tests/{unit,integration,helpers,fixtures}

# First test
cat > tests/unit/test-example.bats << 'EOF'
#!/usr/bin/env bats

@test "bats is working" {
  run echo "hello"
  [ "$status" -eq 0 ]
  [ "$output" = "hello" ]
}
EOF

# Run tests
bats tests/
```

### Phase 2: Real Tests (Days 2-7)

```bash
# Test github-utils.sh
cat > tests/unit/core/test-github-utils.bats << 'EOF'
#!/usr/bin/env bats

load '../../helpers/setup'

setup() {
  source "$PROJECT_ROOT/lib/core/github-utils.sh"
}

@test "gh_detect_project_info extracts owner from URL" {
  # Mock git command
  git() { echo "https://github.com/grimm00/dev-toolkit.git"; }
  export -f git
  
  gh_detect_project_info
  
  [ "$PROJECT_OWNER" = "grimm00" ]
  [ "$PROJECT_REPO" = "grimm00/dev-toolkit" ]
}
EOF
```

### Phase 3: CI Integration (Day 8)

```yaml
# .github/workflows/test.yml
name: Tests

on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: bats-core/bats-action@2.0.0
      - run: bats tests/
```

---

## Alternatives Considered & Rejected

### Why Not Custom?
- **Time:** Would take weeks to build properly
- **Features:** Would lack parallel, TAP, helpers
- **Maintenance:** Ongoing burden
- **Community:** No external help

### Why Not shellspec?
- **Overkill:** BDD style unnecessary for our use case
- **Complexity:** More to learn than benefit gained
- **Community:** Smaller than bats

### Why Not shunit2?
- **Less Active:** Fewer updates, smaller community
- **Missing Features:** No parallel, limited helpers
- **Verbosity:** More boilerplate than bats

---

## Decision

✅ **Use bats-core** for dev-toolkit testing

**Confidence Level:** High  
**Reversibility:** Medium (could switch to shunit2 if needed)  
**Risk:** Low (proven, widely used)

---

## Next Steps

1. **Approve this decision**
2. **Update feature-plan.md** with bats specifics
3. **Create phase-1.md** for implementation
4. **Install bats** and write first test
5. **Iterate** and improve

---

**Decision Owner:** AI Assistant (Claude)  
**Reviewer:** User (cdwilson)  
**Date:** October 6, 2025  
**Status:** 📋 Awaiting approval
