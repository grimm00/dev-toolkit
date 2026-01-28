# Fix Plan: PR #32 Batch MEDIUM MEDIUM - Batch 01

**PR:** 32  
**Batch:** medium-medium-01  
**Priority:** 🟡 MEDIUM  
**Effort:** 🟡 MEDIUM  
**Status:** 🔴 Not Started  
**Created:** 2026-01-27  
**Issues:** 1 issue

---

## Issues in This Batch

| Issue | Priority | Impact | Effort | Description |
|-------|----------|--------|--------|-------------|
| PR32-Overall | 🟡 MEDIUM | 🟡 MEDIUM | 🟡 MEDIUM | Consolidate test setup/teardown logic |

---

## Overview

This batch contains 1 MEDIUM priority issue with MEDIUM effort. The issue addresses test code quality by consolidating duplicated setup/teardown logic into a shared helper.

**Estimated Time:** 2-3 hours  
**Files Affected:** `tests/unit/*.bats`, `tests/integration/*.bats`, `tests/helpers/` (new)

---

## Issue Details

### Issue PR32-Overall: Consolidate Test Setup/Teardown Logic

**Location:** Unit and integration BATS suites  
**Sourcery Comment:** Overall Comment  
**Priority:** 🟡 MEDIUM | **Impact:** 🟡 MEDIUM | **Effort:** 🟡 MEDIUM

**Description:**
Both unit and integration BATS suites reimplement very similar `setup`/`teardown` logic (mktemp project, git init, directory scaffolding). Moving this into a shared helper would ensure tests only declare what's unique to each suite and the common project bootstrap stays in one place.

**Current Code (example pattern):**

```bash
# In tests/unit/test-something.bats
setup() {
    TEST_DIR=$(mktemp -d)
    cd "$TEST_DIR"
    git init --quiet
    mkdir -p admin/exploration
    mkdir -p admin/research
    # ... more scaffolding
}

teardown() {
    cd /
    rm -rf "$TEST_DIR"
}

# In tests/integration/test-other.bats
setup() {
    TEST_DIR=$(mktemp -d)
    cd "$TEST_DIR"
    git init --quiet
    mkdir -p admin/exploration
    mkdir -p admin/research
    # ... same scaffolding repeated
}

teardown() {
    cd /
    rm -rf "$TEST_DIR"
}
```

**Proposed Solution:**

1. **Create shared test helper:**
   ```bash
   # tests/helpers/project-setup.bash
   
   # Create a temporary test project with standard structure
   # Usage: setup_test_project [options]
   # Options:
   #   --no-git     Skip git initialization
   #   --minimal    Only create TEST_DIR, no scaffolding
   setup_test_project() {
       local no_git=false
       local minimal=false
       
       while [[ $# -gt 0 ]]; do
           case "$1" in
               --no-git) no_git=true; shift ;;
               --minimal) minimal=true; shift ;;
               *) shift ;;
           esac
       done
       
       TEST_DIR=$(mktemp -d)
       export TEST_DIR
       cd "$TEST_DIR" || exit 1
       
       if [ "$minimal" = false ]; then
           # Standard project structure
           mkdir -p admin/exploration
           mkdir -p admin/research
           mkdir -p admin/decisions
           mkdir -p admin/planning/features
           mkdir -p docs
       fi
       
       if [ "$no_git" = false ]; then
           git init --quiet
       fi
   }
   
   # Clean up test project
   # Usage: teardown_test_project
   teardown_test_project() {
       cd / || true
       if [ -n "${TEST_DIR:-}" ] && [ -d "$TEST_DIR" ]; then
           rm -rf "$TEST_DIR"
       fi
   }
   ```

2. **Update test files to use helper:**
   ```bash
   # In tests/unit/test-something.bats
   load '../helpers/project-setup.bash'
   
   setup() {
       setup_test_project
       # Test-specific setup only
   }
   
   teardown() {
       teardown_test_project
   }
   ```

**Benefits:**
- Single source of truth for test project structure
- Easier to maintain and update scaffolding
- Tests focus on what's unique to each suite
- Consistent behavior across all test files
- Options for customization (--no-git, --minimal)

---

## Implementation Steps

1. **Issue PR32-Overall**

   - [ ] Audit existing test files for setup/teardown patterns
   - [ ] Identify common vs test-specific setup logic
   - [ ] Create `tests/helpers/project-setup.bash` with helper functions
   - [ ] Add `setup_test_project()` with configurable options
   - [ ] Add `teardown_test_project()` for cleanup
   - [ ] Update unit test files to use shared helper
   - [ ] Update integration test files to use shared helper
   - [ ] Run all tests to verify no regressions
   - [ ] Document helper usage in test README (if exists)

---

## Testing

- [ ] All existing unit tests pass
- [ ] All existing integration tests pass
- [ ] Helper functions work with --no-git option
- [ ] Helper functions work with --minimal option
- [ ] No regressions introduced
- [ ] Tests still create correct directory structure

---

## Files to Modify

- `tests/helpers/project-setup.bash` (new) - Shared setup/teardown helper
- `tests/unit/*.bats` - Update to use shared helper
- `tests/integration/*.bats` - Update to use shared helper

---

## Definition of Done

- [ ] Shared helper created with setup_test_project and teardown_test_project
- [ ] All test files updated to use shared helper
- [ ] Tests passing
- [ ] Code reviewed
- [ ] Ready for PR

---

**Batch Rationale:**
This issue is in its own batch because:
- It's a MEDIUM priority refactoring task
- Requires touching multiple test files
- Needs careful testing to avoid regressions
- Is a distinct improvement from other issues

---

**Last Updated:** 2026-01-27  
**Next Step:** Use `/fix-implement batch-medium-medium-01` to begin work
