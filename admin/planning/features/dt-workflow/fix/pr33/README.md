# PR #33 Fix Tracking

**PR:** #33 - feat: Workflow Expansion + Template Enhancement (Phase 2)  
**Merged:** 2026-01-26  
**Status:** 🟡 Planned  
**Last Updated:** 2026-01-27

---

## 📋 Quick Links

### Fix Batches

- **[batch-medium-medium-01.md](batch-medium-medium-01.md)** - Hardcoded template paths (🟡 MEDIUM, 🟡 MEDIUM, 1 issue)
- **[batch-low-low-01.md](batch-low-low-01.md)** - Documentation cleanup (🟢 LOW, 🟢 LOW, 3 issues)

---

## 📊 Summary

**Total Issues:** 4  
**Batches:** 2  
**Status:** 🟡 Planned

**Priority Breakdown:**
- 🟡 MEDIUM: 1 issue (MEDIUM effort)
- 🟢 LOW: 3 issues (all LOW effort)

**Estimated Total Time:** 2.5-4 hours

---

## 🎯 Batch Overview

### Batch 1: Template Path Portability (medium-medium-01)

**Priority:** 🟡 MEDIUM | **Effort:** 🟡 MEDIUM | **Time:** ~2-3 hours

Make hardcoded dev-infra template paths configurable for CI/CD portability.

**Issues:**
- PR33-Overall-#1: Allow template root injection via environment variable

**Files:** `tests/unit/test-template-enhancement.bats`, `tests/helpers/template-paths.sh`

---

### Batch 2: Documentation Cleanup (low-low-01)

**Priority:** 🟢 LOW | **Effort:** 🟢 LOW | **Time:** ~30-45 minutes

Fix documentation clarity issues in phase-2-template-changes.md.

**Issues:**
- PR33-#1: Purpose line mismatch (Tasks 1-3 vs 1-2)
- PR33-#2: Validation section heading ambiguity
- PR33-Overall-#2: Template variable heading consideration

**Files:** `admin/planning/features/dt-workflow/phase-2-template-changes.md`

---

## 📈 Implementation Order

**Recommended order:**

1. **Batch 2** (low-low-01) - Quick documentation fixes
2. **Batch 1** (medium-medium-01) - More involved test infrastructure change

---

## 📋 Deferred Issues

**Date:** 2026-01-26  
**Review:** PR #33 (Phase 2) Sourcery feedback  
**Status:** 🟡 **DEFERRED** - All MEDIUM/LOW priority, can be handled opportunistically

**Deferred Issues:**

### Documentation Clarity (LOW Priority)

- **PR33-#1:** Purpose line mismatch in phase-2-template-changes.md (LOW priority, LOW effort)
  - **Issue:** Purpose mentions Tasks 1-3, but doc only covers Tasks 1-2
  - **Action:** Update purpose line or add Task 3 section during documentation cleanup
  - **Location:** `admin/planning/features/dt-workflow/phase-2-template-changes.md:3`

- **PR33-#2:** Validation section heading ambiguity (LOW priority, LOW effort)
  - **Issue:** Validation sections after template sections not clearly distinguished
  - **Action:** Add template name to validation headings for clarity
  - **Location:** `admin/planning/features/dt-workflow/phase-2-template-changes.md:235-244`

### Code Quality & Portability (MEDIUM Priority)

- **PR33-Overall-#1:** Hardcoded dev-infra template paths in tests (MEDIUM priority, MEDIUM effort)
  - **Issue:** Template paths hardcoded under `$HOME/.../dev-infra`, environment-specific
  - **Action:** Allow template root injection via environment variable or config
  - **Location:** `tests/unit/test-template-enhancement.bats`
  - **Impact:** Improves CI/CD portability and developer flexibility

### Template Design (LOW Priority)

- **PR33-Overall-#2:** Template variable heading in ADR test (LOW priority, LOW effort)
  - **Issue:** Test validates `# Template Variables` heading in ADR output
  - **Action:** Consider validating template docs via TEMPLATE-VARIABLES.md only
  - **Location:** Test validates template rendering capability, minor design consideration

---

## 🎯 Action Plan

**MEDIUM Priority (1 issue):**
- Can be addressed during test infrastructure improvements
- Would benefit CI/CD and multi-developer scenarios
- Not blocking current functionality

**LOW Priority (3 issues):**
- Documentation cleanup items
- Can be handled during documentation refactoring
- Template design considerations for future refinement

**When to Address:**
- Opportunistically during related work
- During dedicated code quality improvement PR
- During documentation cleanup phase
- During test infrastructure enhancements

---

## 🔗 Related

- **Sourcery Review:** `../../../feedback/sourcery/pr33.md`
- **Phase 2 Document:** `../phase-2.md`
- **Fix Tracking:** `../fix/README.md`

---

**Last Updated:** 2026-01-26  
**Status:** 🟡 Deferred issues tracked
