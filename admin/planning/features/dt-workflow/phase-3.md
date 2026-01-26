# dt-workflow - Phase 3: Cursor Integration

**Phase:** 3 - Cursor Integration  
**Duration:** 6-8 hours  
**Status:** 🔴 Scaffolding (needs expansion)  
**Prerequisites:** Phase 2 complete

---

## 📋 Overview

Update Cursor commands (`/explore`, `/research`, `/decision`) to use dt-workflow as the orchestrator, per ADR-004 (Cursor commands as orchestrators).

**Success Definition:** Cursor commands invoke dt-workflow for core logic, maintaining IDE integration while preserving portability.

---

## 🎯 Goals

1. **Orchestrator Pattern** - Cursor commands call dt-workflow
2. **End-to-End Chain** - Full workflow from `/explore` to `/decision`
3. **Documentation** - Updated command documentation

---

## 📝 Tasks

> **Scaffolding:** Run `/transition-plan dt-workflow --expand --phase 3` to add detailed TDD tasks.

### Task Categories

- [ ] **Update /explore Command** - Use dt-workflow for structure generation
- [ ] **Update /research Command** - Use dt-workflow for research scaffolding
- [ ] **Update /decision Command** - Use dt-workflow for ADR generation
- [ ] **End-to-End Testing** - Validate full workflow chain
- [ ] **Documentation Update** - Command help and usage

---

## ✅ Completion Criteria

- [ ] `/explore topic` uses `dt-workflow explore topic --interactive`
- [ ] `/research topic` uses `dt-workflow research topic --interactive`
- [ ] `/decision topic` uses `dt-workflow decision topic --interactive`
- [ ] Full workflow chain tested (`/explore` → `/research` → `/decision`)
- [ ] Command documentation updated

---

## 📦 Deliverables

- Updated `.cursor/commands/explore.md`
- Updated `.cursor/commands/research.md`
- Updated `.cursor/commands/decision.md`
- End-to-end test documentation

---

## 🔗 Dependencies

### Prerequisites

- [ ] Phase 2 complete (all workflows working)

### Blocks

- Phase 4: Enhancement (requires stable integration)

---

## 🔗 Related Documents

- [Feature Hub](README.md)
- [Previous Phase: Phase 2](phase-2.md)
- [Next Phase: Phase 4](phase-4.md)
- [ADR-004: Cursor Command Role](../../decisions/dt-workflow/adr-004-cursor-command-role.md)

---

**Last Updated:** 2026-01-22  
**Status:** 🔴 Scaffolding  
**Next:** Expand with `/transition-plan dt-workflow --expand --phase 3`
