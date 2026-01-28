# Fix Plan: PR #33 Batch MEDIUM MEDIUM - Batch 01

**PR:** 33  
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
| PR33-Overall-#1 | 🟡 MEDIUM | 🟡 MEDIUM | 🟡 MEDIUM | Hardcoded dev-infra template paths in tests |

---

## Overview

This batch contains 1 MEDIUM priority issue with MEDIUM effort. The issue addresses test portability by making hardcoded template paths configurable.

**Estimated Time:** 2-3 hours  
**Files Affected:** `tests/unit/test-template-enhancement.bats`, potentially test helpers

---

## Issue Details

### Issue PR33-Overall-#1: Hardcoded Template Paths

**Location:** `tests/unit/test-template-enhancement.bats`  
**Sourcery Comment:** Overall Comment #1  
**Priority:** 🟡 MEDIUM | **Impact:** 🟡 MEDIUM | **Effort:** 🟡 MEDIUM

**Description:**
The template enhancement tests hardcode dev-infra template locations under `$HOME/.../dev-infra`, which makes them environment-specific. This reduces portability and makes tests harder to run in different CI setups or by other developers.

**Current Code:**

```bash
# Example of hardcoded path (likely pattern in test file)
TEMPLATE_ROOT="$HOME/Projects/dev-infra/templates"
# or
TEMPLATE_DIR="${HOME}/.cursor/templates/dev-infra"
```

**Proposed Solution:**

1. **Environment Variable Injection:**
   ```bash
   # Allow override via environment variable with sensible default
   TEMPLATE_ROOT="${DT_TEMPLATE_ROOT:-$HOME/Projects/dev-infra/templates}"
   ```

2. **Configuration File Support:**
   ```bash
   # Check for local config file
   if [ -f ".dt-workflow-test.conf" ]; then
       source ".dt-workflow-test.conf"
   fi
   TEMPLATE_ROOT="${TEMPLATE_ROOT:-$HOME/Projects/dev-infra/templates}"
   ```

3. **Test Helper Function:**
   ```bash
   # In tests/helpers/template-paths.sh
   get_template_root() {
       # Priority: env var > config file > default
       if [ -n "${DT_TEMPLATE_ROOT:-}" ]; then
           echo "$DT_TEMPLATE_ROOT"
       elif [ -f ".dt-workflow-test.conf" ]; then
           source ".dt-workflow-test.conf"
           echo "${TEMPLATE_ROOT:-$HOME/Projects/dev-infra/templates}"
       else
           echo "$HOME/Projects/dev-infra/templates"
       fi
   }
   ```

**Benefits:**
- CI/CD can set `DT_TEMPLATE_ROOT` to appropriate path
- Other developers can configure their own template locations
- Maintains backward compatibility with default path
- Easy to test against different template versions

---

## Implementation Steps

1. **Issue PR33-Overall-#1**

   - [ ] Audit `test-template-enhancement.bats` for all hardcoded paths
   - [ ] Create `tests/helpers/template-paths.sh` helper (if not exists)
   - [ ] Add `get_template_root()` function
   - [ ] Update test file to use helper function
   - [ ] Add `DT_TEMPLATE_ROOT` environment variable documentation
   - [ ] Test with default path (ensure no regression)
   - [ ] Test with custom path via environment variable
   - [ ] Update CI configuration (if applicable) to set template root

---

## Testing

- [ ] All existing tests pass with default path
- [ ] Tests pass when `DT_TEMPLATE_ROOT` is set to valid path
- [ ] Tests fail appropriately when `DT_TEMPLATE_ROOT` is set to invalid path
- [ ] No regressions introduced
- [ ] CI/CD still works (if applicable)

---

## Files to Modify

- `tests/unit/test-template-enhancement.bats` - Replace hardcoded paths with helper
- `tests/helpers/template-paths.sh` (new) - Template path helper functions
- `README.md` or `TESTING.md` - Document `DT_TEMPLATE_ROOT` variable

---

## Definition of Done

- [ ] All hardcoded paths replaced with configurable approach
- [ ] Tests passing with default and custom paths
- [ ] Documentation updated
- [ ] Code reviewed
- [ ] Ready for PR

---

**Batch Rationale:**
This issue is in its own batch because:
- It's the only MEDIUM priority issue for PR #33
- Requires moderate effort and careful testing
- Affects test infrastructure (need focused attention)
- Other issues are documentation-only (different scope)

---

**Last Updated:** 2026-01-27  
**Next Step:** Use `/fix-implement batch-medium-medium-01` to begin work
