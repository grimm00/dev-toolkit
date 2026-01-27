# PR #34 Fix Tracking

**PR:** 34 - feat: dt-workflow Enhancement - Model Recommendations, Profiles, Dry Run (Phase 4)  
**Date:** 2026-01-27  
**Status:** 🟠 In Progress  
**Last Updated:** 2026-01-27

---

## 📋 Quick Links

### Fix Batches

- **[batch-medium-low-01.md](batch-medium-low-01.md)** - Strengthen model recommendation tests (✅ Complete via PR #36)
- **[batch-medium-medium-01.md](batch-medium-medium-01.md)** - Performance test reliability (✅ Complete via PR #37)
- **[batch-low-medium-01.md](batch-low-medium-01.md)** - `date +%s%N` portability (🟢 LOW, 🟡 MEDIUM, 1 issue)

---

## 📊 Summary

**Total Issues:** 4  
**Batches:** 3 (2 complete, 1 pending)  
**Status:** 🟠 In Progress

**Priority Breakdown:**
- 🟡 MEDIUM: 3 issues (1 LOW effort, 2 MEDIUM effort)
- 🟢 LOW: 1 issue (MEDIUM effort)

**Effort Breakdown:**
- 🟢 LOW: 1 issue
- 🟡 MEDIUM: 3 issues

**Estimated Total Time:** 4-6 hours

---

## 🎯 Batch Overview

### Batch 1: Test Specificity (medium-low-01) ✅ Complete

**Priority:** 🟡 MEDIUM | **Effort:** 🟢 LOW | **Time:** ~1 hour  
**Status:** ✅ Complete via PR #36 (2026-01-27)

Strengthen model recommendation tests to assert specific model names per workflow type, not just that recommendations exist.

**Issues:**
- PR34-#1: Update test assertions to check specific models (claude-3-5-sonnet, claude-3-opus) ✅

**Files:** `tests/unit/test-model-recommendations.bats`

---

### Batch 2: Performance Test Reliability (medium-medium-01) ✅ Complete

**Priority:** 🟡 MEDIUM | **Effort:** 🟡 MEDIUM | **Time:** ~2-3 hours  
**Status:** ✅ Complete via PR #37 (2026-01-27)

Address concerns about performance test flakiness in CI environments by relaxing timing thresholds and improving robustness.

**Issues:**
- PR34-#2: Relax 1s threshold to 5s to reduce CI flakiness ✅
- PR34-Overall-1: Review all timing thresholds (<1s, <500ms, <200ms) ✅

**Files:** `tests/unit/test-performance.bats`

---

### Batch 3: Portability (low-medium-01)

**Priority:** 🟢 LOW | **Effort:** 🟡 MEDIUM | **Time:** ~1-2 hours

Assess and potentially improve portability of `date +%s%N` timing approach across different Unix-like systems.

**Issues:**
- PR34-Overall-2: `date +%s%N` may not be portable to all BSD variants

**Files:** `tests/unit/test-performance.bats`, potentially `tests/helpers/portable-time.sh`

---

## 📈 Implementation Order

**Recommended order:**

1. ~~**Batch 1** (medium-low-01) - Quickest win, improves test quality~~ ✅ Complete (PR #36)
2. ~~**Batch 2** (medium-medium-01) - Addresses primary robustness concern~~ ✅ Complete (PR #37)
3. **Batch 3** (low-medium-01) - Lowest priority, only if broader platform support needed

---

## 🔍 Deferred Reasoning

All issues in this PR were deferred because:

1. **Test Specificity (#1):**
   - Functional correctness already verified via manual testing
   - Current tests do validate the feature works
   - More specific assertions can be added when model selection logic becomes more complex

2. **Performance Test Reliability (#2, Overall-1):**
   - Current thresholds have 3x+ margin (1s threshold, ~300ms actual)
   - No flakiness observed in current CI runs
   - Tests do validate performance requirements
   - Will monitor CI before adjusting

3. **Portability (Overall-2):**
   - macOS and Linux both support `date +%s%N`
   - No platform-specific failures observed
   - Only relevant if supporting older macOS or other BSD variants

**Overall Assessment:** All issues are code quality improvements with no impact on functional correctness or immediate user experience.

---

## 🔗 Related

- [Phase 4 Planning](../../phase-4.md)
- [Sourcery Review](../../../../feedback/sourcery/pr34.md)
- [Main Fix Tracking](../README.md)
- [dt-workflow Feature Status](../../status-and-next-steps.md)

---

**Last Updated:** 2026-01-27  
**Next Step:** Use `/fix-implement` to begin work on batch-low-medium-01 (portability)
