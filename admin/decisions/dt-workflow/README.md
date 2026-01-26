# dt-workflow - Decisions Hub

**Purpose:** Architecture Decision Records for dt-workflow unified workflow orchestration  
**Status:** ✅ Decisions Made  
**Created:** 2026-01-22  
**Last Updated:** 2026-01-22

---

## 📋 Quick Links

- **[Decisions Summary](decisions-summary.md)** - Summary of all decisions
- **[Research Hub](../../research/dt-workflow/README.md)** - Related research
- **[Requirements](../../research/dt-workflow/requirements.md)** - Requirements document

### ADR Documents

| ADR | Decision | Status |
|-----|----------|--------|
| **[ADR-001](adr-001-unified-architecture.md)** | Unified workflow command architecture | ✅ Accepted |
| **[ADR-002](adr-002-context-injection.md)** | Full context injection with ordering | ✅ Accepted |
| **[ADR-003](adr-003-component-integration.md)** | dt-doc-validate standalone, dt-doc-gen internal | ✅ Accepted |
| **[ADR-004](adr-004-cursor-command-role.md)** | Cursor commands as orchestrators | ✅ Accepted |
| **[ADR-005](adr-005-pattern-documentation.md)** | Two-tier pattern documentation | ✅ Accepted |

---

## 🎯 Decisions Overview

These ADRs formalize decisions made through exploration, spike validation, and research for the dt-workflow feature.

**Decision Points:** 5 decisions  
**Status:** ✅ All Accepted

---

## 📊 Decision Summary

| Decision | Approach | Confidence |
|----------|----------|------------|
| Architecture | Unified command (not composable) | High (spike-validated) |
| Context | Full injection, ordered | High (research-backed) |
| Components | Validate=standalone, Gen=internal | High (analysis-backed) |
| Commands | Orchestrators pattern | High (analysis-backed) |
| Patterns | Two-tier (rules + docs/) | High (research-backed) |

---

## 🚀 Next Steps

1. ✅ ADRs created and accepted
2. Use `/transition-plan --from-adr` to create implementation plan
3. Begin Phase 1 production implementation

---

**Last Updated:** 2026-01-22
