# PR #30 - Deferred Issues

**PR:** #30 - feat: dt-doc-gen Implementation (Phase 2)  
**Date:** 2026-01-22  
**Review:** Sourcery feedback  
**Status:** 🟡 DEFERRED - MEDIUM priority items for future improvement

---

## 📋 Summary

PR #30 implemented Phase 2 (dt-doc-gen). Two MEDIUM priority items were deferred:

| Issue | Priority | Effort | Description |
|-------|----------|--------|-------------|
| PR30-Overall-#2 | 🟡 MEDIUM | 🟡 MEDIUM | Make templates.sh dependency explicit |
| PR30-Overall-#3 | 🟡 MEDIUM | 🟡 MEDIUM | Centralize doc type definitions |

**HIGH/CRITICAL issues addressed in PR:** Comments #1 and #2 were fixed before merge.

---

## 📝 Deferred Issues

### PR30-Overall-#2: Make templates.sh Dependency Explicit

**Priority:** 🟡 MEDIUM  
**Impact:** 🟢 LOW  
**Effort:** 🟡 MEDIUM

**Description:** `dt_get_template_vars` in `render.sh` depends implicitly on `DT_TYPE_CATEGORY` from `templates.sh` and tries to conditionally source it at runtime. More robust to make this dependency explicit (require caller to source templates.sh first, or have render.sh unconditionally source it).

**Location:** `lib/doc-gen/render.sh`

**Action Plan:** Address opportunistically during future work or in a dedicated code quality PR.

---

### PR30-Overall-#3: Centralize Document Type Definitions

**Priority:** 🟡 MEDIUM  
**Impact:** 🟡 MEDIUM  
**Effort:** 🟡 MEDIUM

**Description:** Document types and their mappings appear in multiple places (CLI help text, `DT_TYPE_CATEGORY`, `DT_TYPE_OUTPUT_DIR/FILE`). Consider centralizing these definitions to a single source of truth to reduce drift risk.

**Locations:**
- `bin/dt-doc-gen` (CLI help text)
- `lib/doc-gen/templates.sh` (DT_TYPE_CATEGORY, DT_TYPE_OUTPUT_DIR, DT_TYPE_OUTPUT_FILE)

**Action Plan:** Address during Phase 3 implementation or in a dedicated refactoring PR.

---

## 🔗 Related

- **Sourcery Review:** [`admin/feedback/sourcery/pr30.md`](../../../../feedback/sourcery/pr30.md)
- **Phase Document:** [`phase-2.md`](../../phase-2.md)

---

**Last Updated:** 2026-01-22
