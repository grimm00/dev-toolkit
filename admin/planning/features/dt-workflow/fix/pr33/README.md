# PR #33 Fix Tracking

**PR:** #33 - feat: Workflow Expansion + Template Enhancement (Phase 2)  
**Merged:** 2026-01-26  
**Status:** 🟡 **DEFERRED ISSUES TRACKED**

---

## 📋 Overview

This directory tracks deferred issues from PR #33's Sourcery review. All issues are documentation improvements or future enhancements.

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
