# dt-workflow - Feature Plan

**Feature:** dt-workflow - Unified Workflow Orchestration  
**Status:** 🟠 In Progress  
**Created:** 2026-01-22  
**Priority:** High

---

## 📋 Overview

Build a unified `dt-workflow` command that orchestrates the exploration→research→decision workflow pipeline, replacing individual ad-hoc commands with a consistent, context-aware system.

**Source:** ADRs from [admin/decisions/dt-workflow/](../../decisions/dt-workflow/)  
**Research:** [admin/research/dt-workflow/](../../research/dt-workflow/)  
**Spike:** [bin/dt-workflow](../../../../bin/dt-workflow) (v0.1.0-spike)

---

## 🎯 Success Criteria

- [ ] **SC-1:** `dt-workflow explore <topic> --interactive` produces valid exploration structure
- [ ] **SC-2:** `dt-workflow research <topic> --from-explore --interactive` produces research scaffolding
- [ ] **SC-3:** `dt-workflow decision <topic> --from-research --interactive` produces ADR structure
- [ ] **SC-4:** All outputs include explicit context injection (rules, project identity)
- [ ] **SC-5:** L1/L2/L3 validation provides actionable feedback
- [ ] **SC-6:** Token count reported in all outputs
- [ ] **SC-7:** Cursor commands (`/explore`, `/research`, `/decision`) use dt-workflow as orchestrator
- [ ] **SC-8:** Full test coverage (unit + integration)
- [ ] **SC-9:** Documentation complete (help text, user guide)

---

## 📋 Requirements Summary

### Functional Requirements (from Research)

| ID | Requirement | Priority | Status |
|----|-------------|----------|--------|
| FR-1 | Unified command | High | ✅ Spike |
| FR-2 | Phase 1 interactive mode | High | ✅ Spike |
| FR-3 | Explicit context injection | High | ✅ Spike |
| FR-4 | Context ordering (START/MIDDLE/END) | High | ✅ Spike |
| FR-5 | Token count reporting | Medium | ✅ Spike |
| FR-6 | Universal context inclusion | High | ✅ Spike |
| FR-8 | L1 validation (existence) | High | ✅ Spike |
| FR-9 | L2/L3 validation (structure/content) | Medium | ✅ Spike |
| FR-10 | Standardized handoff files | High | 🔴 Pending |
| FR-11 | --from-* flag auto-detection | Medium | 🔴 Pending |
| FR-12 | --validate flag | Low | ✅ Spike |
| FR-13 | Next Steps section | Medium | ✅ Spike |
| FR-14 | Two-tier pattern documentation | High | ✅ Complete |

### Non-Functional Requirements

| ID | Requirement | Priority |
|----|-------------|----------|
| NFR-1 | Token budget <50K | High |
| NFR-2 | Context injection <1s | Medium |
| NFR-3 | Validation <500ms | Medium |
| NFR-4 | Actionable error messages | High |

---

## 📅 Implementation Phases

### Phase 1: Foundation (Production Quality)

**Goal:** Refactor spike to production-quality code with full testing

**Estimated Effort:** 8-12 hours

**Tasks:**
- Refactor spike code structure
- Implement explore workflow completely
- Add comprehensive unit tests
- Add integration tests
- Update help text and documentation

**Deliverables:**
- Production `bin/dt-workflow` (v0.2.0)
- `tests/unit/test-dt-workflow.bats`
- `tests/integration/test-dt-workflow-integration.bats`

---

### Phase 2: Workflow Expansion

**Goal:** Implement research and decision workflows

**Estimated Effort:** 10-14 hours

**Prerequisites:** Phase 1 complete

**Tasks:**
- Implement research workflow
- Implement decision workflow
- Add workflow-specific context gathering
- Add handoff file generation
- Add --from-* flag support with auto-detection
- Add tests for new workflows

**Deliverables:**
- Research workflow support
- Decision workflow support
- Workflow chaining via handoff files

---

### Phase 3: Cursor Integration

**Goal:** Integrate with Cursor commands per ADR-004 (orchestrator pattern)

**Estimated Effort:** 6-8 hours

**Prerequisites:** Phase 2 complete

**Tasks:**
- Update `/explore` command to use dt-workflow
- Update `/research` command to use dt-workflow
- Update `/decision` command to use dt-workflow
- Test end-to-end workflow chain
- Update Cursor command documentation

**Deliverables:**
- Updated `.cursor/commands/explore.md`
- Updated `.cursor/commands/research.md`
- Updated `.cursor/commands/decision.md`

---

### Phase 4: Enhancement

**Goal:** Add advanced features and prepare for Phase 2/3 evolution

**Estimated Effort:** 8-10 hours

**Prerequisites:** Phase 3 complete

**Tasks:**
- Add model recommendations per workflow type
- Add context profiles (configurable context sets)
- Add performance optimizations
- Add --dry-run flag
- Document Phase 2/3 evolution path

**Deliverables:**
- Model recommendation in output
- Context profile support
- Performance benchmarks
- Evolution roadmap

---

## 📊 Effort Summary

| Phase | Effort | Cumulative |
|-------|--------|------------|
| Phase 1: Foundation | 8-12 hours | 8-12 hours |
| Phase 2: Workflow Expansion | 10-14 hours | 18-26 hours |
| Phase 3: Cursor Integration | 6-8 hours | 24-34 hours |
| Phase 4: Enhancement | 8-10 hours | 32-44 hours |

**Total Estimated:** 32-44 hours

---

## 🚀 Next Steps

1. Review phase scaffolding documents
2. Expand Phase 1 with detailed TDD tasks
3. Begin implementation

---

## 🔗 Related

- [Transition Plan](transition-plan.md)
- [ADRs](../../decisions/dt-workflow/)
- [Requirements](../../research/dt-workflow/requirements.md)
- [Pattern Library](../../../../docs/patterns/workflow-patterns.md)

---

**Last Updated:** 2026-01-22
