# /explore Command Migration - Research Hub

**Purpose:** Research for migrating /explore Cursor command to dt-doc-gen  
**Status:** 🔴 Research  
**Created:** 2026-01-22  
**Last Updated:** 2026-01-22

---

## 📋 Quick Links

- **[Research Summary](research-summary.md)** - Summary of all research findings
- **[Requirements](requirements.md)** - Requirements discovered during research
- **[Exploration](../../../explorations/command-migrations/explore/exploration.md)** - Source exploration

### Research Documents (Priority Order)

| # | Research Document | Priority | Status |
|---|-------------------|----------|--------|
| 1 | [Template Inspection & Gap Analysis](research-template-gap-analysis.md) | 🔴 BLOCKING | ✅ Complete |
| 2 | [Migration Value Assessment](research-migration-value.md) | 🔴 STRATEGIC | ✅ Complete |
| 3 | [Two-Mode Template Strategy](research-two-mode-strategy.md) | 🔴 High | ⬜ Cancelled |
| 4 | [Theme Extraction Location](research-theme-extraction.md) | 🟠 Medium | ⬜ Cancelled |
| 5 | [Validation Strictness](research-validation-strictness.md) | 🟠 Medium | ⬜ Cancelled |
| 6 | [Cross-Project Coordination](research-cross-project.md) | 🟠 Medium | ⬜ Cancelled |

**Note:** Low-priority topics (Fallback Strategy, Bulk Updates) deferred to implementation phase.

---

## 🎯 Research Overview

This research investigates how to migrate the `/explore` Cursor command from inline templates to using `dt-doc-gen` for document generation. This is Sprint 1 of the command migration initiative and sets patterns for all subsequent command migrations.

**Key Question:** Is this migration worth the effort, or would inline restructuring be simpler?

**Research Topics:** 6 active topics (3 high priority, 3 medium priority)  
**Status:** 🔴 Research

---

## 📊 Research Status

| Research Topic | Priority | Status | Findings |
|----------------|----------|--------|----------|
| Template Inspection & Gap Analysis | 🔴 BLOCKING | ✅ Complete | **Gaps minimal** - templates highly compatible |
| Migration Value Assessment | 🔴 STRATEGIC | ✅ Complete | **Migration NOT recommended** - validate-only approach |
| Two-Mode Template Strategy | 🔴 High | ⬜ Cancelled | Not needed - migration cancelled |
| Theme Extraction Location | 🟠 Medium | ⬜ Cancelled | Not needed - migration cancelled |
| Validation Strictness | 🟠 Medium | ⬜ Cancelled | Not needed - migration cancelled |
| Cross-Project Coordination | 🟠 Medium | ⬜ Cancelled | Not needed - migration cancelled |

---

## 🔄 Recommended Research Order

1. **Template Inspection & Gap Analysis** (BLOCKING) - Must understand dev-infra templates before any other work
2. **Migration Value Assessment** (STRATEGIC) - Validate benefit before committing effort
3. **Two-Mode Template Strategy** - Pattern-setting decision for all two-mode commands
4. **Theme Extraction Location** - Quick to confirm (likely "command wrapper")
5. **Validation Strictness** - May simplify based on earlier findings
6. **Cross-Project Coordination** - Execution detail, decide based on gap analysis

---

## 🚀 Next Steps

1. Start with blocking research: Template Inspection & Gap Analysis
2. Use `/research explore-command-migration --conduct --topic-num 1`
3. After blocking research, assess migration value
4. Complete remaining topics based on findings
5. Use `/decision explore-command-migration --from-research` when complete

---

## 🔑 Key Finding: Migration NOT Recommended

**Decision: Skip migration, use validate-only approach**

### Why Not Migrate?

1. **/explore is an AI command, not a CLI tool** - dt-doc-gen solves a different problem
2. **No pain points exist** - current approach works well
3. **Main benefit achievable without migration** - use dt-doc-validate on output
4. **Migration adds complexity** - CLI calls within AI context, coordination overhead

### Recommended Approach

Use **validate-only**: Run `dt-doc-validate` on generated documents without changing generation.

| Aspect | Migration | Validate-Only |
|--------|-----------|---------------|
| Effort | 5-9 hours | 0-1 hours |
| Complexity | Higher | None |
| Validation benefit | ✅ | ✅ |
| Works today | Requires changes | ✅ |

### Impact on Other Commands

Same decision applies to all 6 Cursor commands:
- Skip migration
- Use dt-doc-validate on output
- **Saves 30-50+ hours** of migration work

---

## 🔗 Related Documents

- [Exploration](../../../explorations/command-migrations/explore/exploration.md)
- [Command Migrations Hub](../../../explorations/command-migrations/README.md)
- [Iteration Plan](../../doc-infrastructure/iteration-plan.md)
- [dt-doc-gen Phase 2](../../../planning/features/doc-infrastructure/phase-2.md)

---

**Last Updated:** 2026-01-22
