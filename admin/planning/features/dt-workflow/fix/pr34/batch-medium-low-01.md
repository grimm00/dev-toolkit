# Fix Plan: PR 34 Batch MEDIUM LOW - Batch 01

**PR:** 34  
**Batch:** medium-low-01  
**Priority:** 🟡 MEDIUM  
**Effort:** 🟢 LOW  
**Status:** ✅ Complete  
**Completed:** 2026-01-27  
**PR:** #36  
**Created:** 2026-01-27  
**Issues:** 1 issue

---

## Issues in This Batch

| Issue | Priority | Impact | Effort | Description |
|-------|----------|--------|--------|-------------|
| PR34-#1 | 🟡 MEDIUM | 🟢 LOW | 🟢 LOW | Strengthen model recommendation tests to assert specific models |

---

## Overview

This batch contains 1 MEDIUM priority issue with LOW effort. This issue improves test coverage by asserting specific model names instead of just checking for presence of recommendations.

**Estimated Time:** 1 hour  
**Files Affected:** `tests/unit/test-model-recommendations.bats`

---

## Issue Details

### Issue PR34-#1: Strengthen Model Recommendation Tests

**Location:** `tests/unit/test-model-recommendations.bats:41`  
**Sourcery Comment:** Comment #1  
**Priority:** 🟡 MEDIUM | **Impact:** 🟢 LOW | **Effort:** 🟢 LOW

**Description:**
These tests only assert that a recommendation header appears. To validate the feature, they should assert the exact model chosen for each workflow (e.g. `explore`/`research` → `claude-3-5-sonnet`, `decision` → `claude-3-opus`) and, if feasible, that the rationale text matches expectations. That way the tests cover the mapping logic, not just the presence of output.

**Current Code:**

```bash
@test "explore workflow recommends model in output" {
    run "$DT_WORKFLOW" explore test-topic --interactive
    [ "$status" -eq 0 ]
    [[ "$output" =~ "Recommended Model:" ]]
}
```

**Proposed Solution:**
Update tests to assert specific model names per workflow type:

```bash
@test "explore workflow recommends claude-3-5-sonnet" {
    run "$DT_WORKFLOW" explore test-topic --interactive
    [ "$status" -eq 0 ]
    [[ "$output" =~ "Recommended Model: claude-3-5-sonnet" ]]
}

@test "research workflow recommends claude-3-5-sonnet" {
    run "$DT_WORKFLOW" research test-topic --interactive
    [ "$status" -eq 0 ]
    [[ "$output" =~ "Recommended Model: claude-3-5-sonnet" ]]
}

@test "decision workflow recommends claude-3-opus" {
    run "$DT_WORKFLOW" decision test-topic --interactive
    [ "$status" -eq 0 ]
    [[ "$output" =~ "Recommended Model: claude-3-opus" ]]
}
```

**Related Files:**
- `tests/unit/test-model-recommendations.bats` - Update test assertions
- `bin/dt-workflow` - Review `get_recommended_model()` function to ensure consistent output format

---

## Implementation Steps

1. **Issue PR34-#1: Strengthen Model Recommendation Tests**
   - [ ] Review current `get_recommended_model()` function in `bin/dt-workflow`
   - [ ] Verify exact output format for each workflow type
   - [ ] Update test for explore workflow to assert `claude-3-5-sonnet`
   - [ ] Update test for research workflow to assert `claude-3-5-sonnet`
   - [ ] Update test for decision workflow to assert `claude-3-opus`
   - [ ] Consider adding test for rationale text (optional)
   - [ ] Run tests to verify they pass
   - [ ] Check for any edge cases or workflow types not covered

---

## Testing

- [ ] All existing tests pass
- [ ] Updated tests now assert specific model names
- [ ] Tests fail appropriately if wrong model is returned
- [ ] No regressions in model recommendation feature
- [ ] Manual verification: Run dt-workflow commands and verify output

**Test Command:**
```bash
bats tests/unit/test-model-recommendations.bats
```

---

## Files to Modify

- `tests/unit/test-model-recommendations.bats` - Update test assertions to check specific models

---

## Definition of Done

- [ ] All tests in batch updated with specific model assertions
- [ ] Tests passing
- [ ] Code reviewed
- [ ] No regressions in recommendation feature
- [ ] Ready for PR

---

**Batch Rationale:**
This issue is batched separately because it's a straightforward test improvement with LOW effort. Tests currently verify functional correctness (recommendations appear), but more specific assertions will catch regressions in model selection logic when it becomes more complex in future.

**Deferred Reasoning:**
- Functional correctness already verified via manual testing
- Current tests do validate the feature works
- Enhancement improves test quality but not urgent
- Can be implemented opportunistically
