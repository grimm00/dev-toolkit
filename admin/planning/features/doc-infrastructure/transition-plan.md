# Feature Transition Plan - Doc Infrastructure

**Feature:** dt-doc-gen and dt-doc-validate  
**Status:** 🔴 Not Started  
**Created:** 2026-01-21  
**Source:** [Decisions Hub](../../../decisions/doc-infrastructure/README.md)  
**Type:** Feature

---

## 📋 Overview

Transition from completed research and decisions to implementation of the doc-infrastructure feature. This plan covers the core implementation phases; command migration sprints are tracked separately in the [Iteration Plan](../../../research/doc-infrastructure/iteration-plan.md).

---

## 🎯 Transition Goals

1. Implement shared infrastructure used by both commands
2. Implement dt-doc-gen with full template support
3. Implement dt-doc-validate with full rule support
4. Achieve test coverage >80% for all new code
5. Prepare for command migration sprints

---

## ✅ Pre-Transition Checklist

- [x] Research phase complete (7 topics)
- [x] Requirements documented (80 total)
- [x] Decisions made (7 ADRs)
- [x] Iteration plan created
- [ ] dev-infra templates available locally
- [ ] dev-infra validation rules available locally

---

## 📊 Transition Phases

### Phase 1: Shared Infrastructure

**Goal:** Create foundation for both commands (ADR-005)

**Estimated Effort:** 2-3 days

**Prerequisites:**
- [x] ADR-005 accepted
- [x] ADR-001 XDG section accepted
- [x] ADR-006 project structure section accepted

**Key Deliverables:**
- `lib/core/output-utils.sh`
- XDG helper functions
- Project structure detection
- Unit tests

**Definition of Done:**
- [ ] All `dt_*` functions implemented
- [ ] XDG paths working
- [ ] Project structure detection working
- [ ] Tests passing
- [ ] Ready for Phase 2

**Phase Document:** [phase-1.md](phase-1.md)

---

### Phase 2: dt-doc-gen

**Goal:** Implement document generation command (ADR-001, ADR-003)

**Estimated Effort:** 3-4 days

**Prerequisites:**
- [ ] Phase 1 complete
- [ ] dev-infra templates accessible

**Key Deliverables:**
- `bin/dt-doc-gen` CLI
- Template discovery (`lib/doc-gen/templates.sh`)
- Variable expansion (`lib/doc-gen/render.sh`)
- Two-mode support (setup/conduct)
- Tests

**Definition of Done:**
- [ ] All 17 document types generate correctly
- [ ] Layered discovery working
- [ ] Selective envsubst working
- [ ] Two-mode support working
- [ ] Tests passing (>80% coverage)
- [ ] Ready for Phase 3

**Phase Document:** [phase-2.md](phase-2.md)

---

### Phase 3: dt-doc-validate

**Goal:** Implement document validation command (ADR-002, ADR-004, ADR-006)

**Estimated Effort:** 3-4 days

**Prerequisites:**
- [ ] Phase 1 complete
- [ ] dev-infra validation rules accessible (pre-compiled .bash)

**Key Deliverables:**
- `bin/dt-doc-validate` CLI
- Rule loading (`lib/doc-validate/rules.sh`)
- Type detection (`lib/doc-validate/type-detection.sh`)
- Error output (text + JSON)
- Tests

**Definition of Done:**
- [ ] All 17 document types validate correctly
- [ ] Type detection working (path → content → error)
- [ ] Text and JSON output working
- [ ] Exit codes correct (0/1/2)
- [ ] Tests passing (>80% coverage)
- [ ] Ready for command migration

**Phase Document:** [phase-3.md](phase-3.md)

---

## 📅 Post-Transition

After core implementation is complete:

- [ ] Update feature hub with completion status
- [ ] Begin command migration sprints (see [Iteration Plan](../../../research/doc-infrastructure/iteration-plan.md))
- [ ] Sprint 1: `/explore` command
- [ ] Sprint 2: `/research` command
- [ ] Continue through Sprint 6

---

## ✅ Definition of Done (Feature)

- [ ] All 3 phases complete
- [ ] Both commands implemented and tested
- [ ] Documentation complete (help text, README updates)
- [ ] Ready for command migration sprints

---

## 📊 Estimated Timeline

| Phase | Effort | Dependencies |
|-------|--------|--------------|
| Phase 1: Shared Infrastructure | 2-3 days | None |
| Phase 2: dt-doc-gen | 3-4 days | Phase 1 |
| Phase 3: dt-doc-validate | 3-4 days | Phase 1 |

**Total:** 8-11 days (Phases 2 and 3 can partially overlap)

---

## 🔗 Related Documents

- [Feature Plan](feature-plan.md)
- [Decisions Summary](../../../decisions/doc-infrastructure/decisions-summary.md)
- [Requirements](../../../research/doc-infrastructure/requirements.md)
- [Iteration Plan](../../../research/doc-infrastructure/iteration-plan.md) (command migration)

---

**Last Updated:** 2026-01-21
