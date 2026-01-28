# PR #32 - Fix Tracking

**PR:** #32 - feat: dt-workflow Phase 1 - Foundation (Production Quality)  
**Merged:** 2026-01-26  
**Phase:** Phase 1  
**Status:** 🟡 Planned  
**Review:** [Sourcery Review](../../../../feedback/sourcery/pr32.md)  
**Last Updated:** 2026-01-27

---

## 📋 Quick Links

### Fix Batches

- **[batch-medium-medium-01.md](batch-medium-medium-01.md)** - Consolidate test setup/teardown (🟡 MEDIUM, 🟡 MEDIUM, 1 issue)
- **[batch-low-medium-01.md](batch-low-medium-01.md)** - Centralize kebab-to-Title Case (🟢 LOW, 🟡 MEDIUM, 1 issue)

---

## 📊 Summary

**Total Issues:** 3  
**Fixed in PR:** 1 (Comment #2)  
**Batches:** 2  
**Status:** 🟡 Planned

**Priority Breakdown:**
- 🟡 MEDIUM: 1 issue (MEDIUM effort)
- 🟢 LOW: 1 issue (MEDIUM effort)

**Estimated Total Time:** 3-5 hours

---

## 🎯 Batch Overview

### Batch 1: Test Setup Consolidation (medium-medium-01)

**Priority:** 🟡 MEDIUM | **Effort:** 🟡 MEDIUM | **Time:** ~2-3 hours

Consolidate duplicated test setup/teardown logic into a shared helper.

**Issues:**
- PR32-Overall: Create `tests/helpers/project-setup.bash`

**Files:** `tests/unit/*.bats`, `tests/integration/*.bats`, `tests/helpers/`

---

### Batch 2: Render.sh Helper (low-medium-01)

**Priority:** 🟢 LOW | **Effort:** 🟡 MEDIUM | **Time:** ~1-2 hours

Extract kebab-to-Title Case transformation into reusable helper function.

**Issues:**
- PR32-#1: Create `dt_to_title_case()` helper

**Files:** `lib/doc-gen/render.sh`

**Note:** Deferred to Phase 2 (render.sh scope)

---

## 📈 Implementation Order

**Recommended order:**

1. **Batch 1** (medium-medium-01) - Higher priority, improves test maintainability
2. **Batch 2** (low-medium-01) - Can wait until working on render.sh (Phase 2)

---

## 📋 Deferred Issues

**Date:** 2026-01-26  
**Review:** PR #32 (Phase 1) Sourcery feedback  
**Status:** 🟢 **MINIMAL ISSUES** - 2 individual + 1 overall comment, all LOW/MEDIUM priority

**Deferred Issues:**

- **PR32-#1:** Centralize kebab-to-Title Case transformation (🟢 LOW priority, 🟡 MEDIUM effort)
  - **Location:** `lib/doc-gen/render.sh:13-19`
  - **Description:** The kebab-to-Title Case transformation appears in multiple setters. Consider extracting into a reusable helper.
  - **Action:** Deferred to Phase 2 (render.sh is Phase 2 scope)
  - **Impact:** 🟡 MEDIUM - Improves maintainability

- **PR32-#2:** Replace non-portable filesystem path (🟢 LOW priority, 🟢 LOW effort)
  - **Location:** `admin/planning/features/dt-workflow/phase-2.md:110`
  - **Description:** Local filesystem path won't work for other users
  - **Action:** ✅ **FIXED** - Replaced with note about dev-infra templates location
  - **Impact:** 🟢 LOW - Documentation clarity

- **PR32-Overall:** Consolidate test setup/teardown logic (🟡 MEDIUM priority, 🟡 MEDIUM effort)
  - **Location:** Unit and integration BATS suites
  - **Description:** Both test suites reimplement similar setup/teardown logic. Consider moving to shared helper.
  - **Action:** Deferred - Tests work fine, consolidation is future improvement
  - **Impact:** 🟡 MEDIUM - Code quality and maintainability

**Action Plan:**
- Comment #1: Will be addressed naturally in Phase 2 when working on render.sh
- Comment #2: Already fixed during PR validation
- Overall: Can be handled opportunistically during future test refactoring

---

## 📊 Summary

- **Total Comments:** 3 (2 individual + 1 overall)
- **Fixed in PR:** 1 (Comment #2)
- **Deferred:** 2 (Comment #1, Overall)
- **CRITICAL/HIGH Issues:** 0
- **Phase 2 Scope:** 1 (Comment #1)

---

## 🔗 Related

- [Phase 1 Plan](../../phase-1.md)
- [Sourcery Review](../../../../feedback/sourcery/pr32.md)
- [Feature Status](../../status-and-next-steps.md)

---

**Last Updated:** 2026-01-26
