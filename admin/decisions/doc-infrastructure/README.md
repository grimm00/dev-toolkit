# Doc Infrastructure - Decisions Hub

**Purpose:** Architecture Decision Records for dt-doc-gen and dt-doc-validate implementation  
**Status:** ✅ Decisions Made  
**Created:** 2026-01-20  
**Last Updated:** 2026-01-20

---

## 📋 Quick Links

- **[Decisions Summary](decisions-summary.md)** - Summary of all decisions
- **[Research Hub](../../research/doc-infrastructure/README.md)** - Related research
- **[Requirements](../../research/doc-infrastructure/requirements.md)** - 80 requirements
- **[Iteration Plan](../../research/doc-infrastructure/iteration-plan.md)** - Per-command iteration strategy

### ADR Documents

| ADR | Decision | Status |
|-----|----------|--------|
| [ADR-001](adr-001-template-location-strategy.md) | Template Location and Discovery Strategy | ✅ Accepted |
| [ADR-002](adr-002-validation-rule-loading.md) | Validation Rule Loading Strategy | ✅ Accepted |
| [ADR-003](adr-003-variable-expansion.md) | Variable Expansion Approach | ✅ Accepted |
| [ADR-004](adr-004-error-output-design.md) | Error Output and Exit Code Design | ✅ Accepted |
| [ADR-005](adr-005-shared-infrastructure.md) | Shared Infrastructure Pattern | ✅ Accepted |
| [ADR-006](adr-006-type-detection.md) | Document Type Detection Strategy | ✅ Accepted |
| [ADR-007](adr-007-migration-strategy.md) | Command Migration and Iteration Strategy | ✅ Accepted |

---

## 🎯 Decisions Overview

This hub documents the architectural decisions for implementing the doc-infrastructure feature:

- **`dt-doc-gen`** — Generate documentation from 17 templates with variable expansion
- **`dt-doc-validate`** — Validate documents against common + type-specific rules

**Decision Points:** 7 architectural decisions  
**Status:** ✅ All decisions accepted

---

## 📊 Decision Summary

### Core Architecture Decisions

| # | Decision | Choice | Rationale |
|---|----------|--------|-----------|
| 1 | Template Location | dev-infra (not bundled) | Single source of truth |
| 2 | Rule Loading | Build-time YAML→Bash conversion | Zero runtime dependencies |
| 3 | Variable Expansion | Selective envsubst | Safe, preserves non-template content |
| 4 | Error Output | Text + JSON dual mode | Human + machine readable |
| 5 | Shared Code | `lib/core/output-utils.sh` | Follows existing patterns |
| 6 | Type Detection | Path → Content → Explicit | Reliable auto-detection |
| 7 | Migration | Per-command sprints | Incremental, low risk |

### Iteration Plan Decisions (from ADR-007)

| ID | Decision Point | Resolution |
|----|----------------|------------|
| DP-1 | Template override mechanism | Layered discovery (flag → env → config → defaults) |
| DP-2 | Dev-infra coordination | PR per sprint (batched) |
| DP-3 | Fallback duration | Remove when next sprint validates |
| DP-4 | Validation strictness | Match inline first, then tighten |
| DP-5 | Test fixture source | Capture baseline from inline templates |

---

## 🔗 Related Documents

### Research (Input)
- [Research Summary](../../research/doc-infrastructure/research-summary.md)
- [Requirements](../../research/doc-infrastructure/requirements.md) (80 requirements)
- [Iteration Plan](../../research/doc-infrastructure/iteration-plan.md)

### Individual Research Topics
- [Topic 1: Template Fetching](../../research/doc-infrastructure/research-template-fetching.md)
- [Topic 2: YAML Parsing](../../research/doc-infrastructure/research-yaml-parsing.md)
- [Topic 3: Command Integration](../../research/doc-infrastructure/research-command-integration.md)
- [Topic 4: Type Detection](../../research/doc-infrastructure/research-type-detection.md)
- [Topic 5: Variable Expansion](../../research/doc-infrastructure/research-variable-expansion.md)
- [Topic 6: Error Output](../../research/doc-infrastructure/research-error-output.md)
- [Topic 7: Shared Infrastructure](../../research/doc-infrastructure/research-shared-infrastructure.md)

---

## 🚀 Next Steps

1. ✅ Review ADR documents
2. ✅ Decisions accepted
3. **Next:** Use `/transition-plan doc-infrastructure --from-adr` to create implementation plan

---

**Last Updated:** 2026-01-20
