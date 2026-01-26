# dt-workflow - Feature Hub

**Purpose:** Unified workflow orchestration command for dev-toolkit  
**Status:** 🟠 In Progress  
**Created:** 2026-01-22  
**Last Updated:** 2026-01-22

---

## 📋 Quick Links

### Planning Documents

- **[Feature Plan](feature-plan.md)** - Overview and success criteria
- **[Transition Plan](transition-plan.md)** - ADR-to-implementation roadmap
- **[Status and Next Steps](status-and-next-steps.md)** - Current progress

### Implementation Phases

| Phase | Name | Status |
|-------|------|--------|
| [Phase 1](phase-1.md) | Foundation (Production Quality) | ✅ Complete |
| [Phase 2](phase-2.md) | Workflow Expansion + Template Enhancement | ✅ Expanded |
| [Phase 3](phase-3.md) | Cursor Integration | 🔴 Scaffolding |
| [Phase 4](phase-4.md) | Enhancement | 🔴 Scaffolding |

### Related Documents

- **[Decisions](../../decisions/dt-workflow/)** - Architecture Decision Records
- **[Research](../../research/dt-workflow/)** - Research findings
- **[Exploration](../../explorations/dt-workflow/)** - Initial exploration
- **[Pattern Library](../../../../docs/patterns/workflow-patterns.md)** - Universal patterns

---

## 🎯 Feature Overview

**dt-workflow** is a unified command for orchestrating the exploration→research→decision workflow pipeline. It provides explicit context injection, standardized output formats, and preparation for future AI automation.

### Key Capabilities

1. **Unified Command** - Single entry point for all workflow operations
2. **Explicit Context** - Visible context injection (rules, project identity)
3. **L1/L2/L3 Validation** - Tiered input validation with actionable errors
4. **Workflow Chaining** - Standardized handoff files between workflows
5. **Phase-Based Evolution** - Phase 1 (interactive) → Phase 3 (automated)

### Architecture Decisions

| ADR | Decision |
|-----|----------|
| [ADR-001](../../decisions/dt-workflow/adr-001-unified-architecture.md) | Unified command (not composable) |
| [ADR-002](../../decisions/dt-workflow/adr-002-context-injection.md) | Full context injection with ordering |
| [ADR-003](../../decisions/dt-workflow/adr-003-component-integration.md) | dt-doc-validate standalone, dt-doc-gen internal |
| [ADR-004](../../decisions/dt-workflow/adr-004-cursor-command-role.md) | Cursor commands as orchestrators |
| [ADR-005](../../decisions/dt-workflow/adr-005-pattern-documentation.md) | Two-tier pattern documentation |

---

## 📊 Progress Summary

**Current Phase:** Phase 2 (Expanded, Ready for Implementation)  
**Overall Progress:** 30% (Phase 1 complete, Phase 2 expanded)

| Milestone | Status |
|-----------|--------|
| Exploration | ✅ Complete |
| Spike Validation | ✅ Complete |
| Research (Topics 1-3) | ✅ Complete |
| ADRs | ✅ Complete |
| Pattern Library | ✅ Complete |
| Transition Plan | ✅ Complete |
| Phase Implementation | 🔴 Not Started |

---

## 🚀 Next Steps

1. **Implement Phase 2** - Begin with Task 1 (Enhance Exploration Templates)
2. **Run TDD cycle** - RED → GREEN → REFACTOR for each task
3. **Coordinate dev-infra** - Template changes require dev-infra updates
4. **Validate** - Run full test suite before marking complete

---

**Last Updated:** 2026-01-26
