# dt-workflow - Phase 2: Workflow Expansion

**Phase:** 2 - Workflow Expansion  
**Duration:** 10-14 hours  
**Status:** 🔴 Scaffolding (needs expansion)  
**Prerequisites:** Phase 1 complete

---

## 📋 Overview

Implement the research and decision workflows, enabling the full explore→research→decision pipeline with standardized handoff files.

**Success Definition:** All three workflows (explore, research, decision) working end-to-end with proper chaining via handoff files.

---

## 🎯 Goals

1. **Research Workflow** - Structure generation and context gathering for research
2. **Decision Workflow** - Structure generation and context gathering for decisions
3. **Handoff Files** - Standardized output files per FR-10
4. **--from-* Flags** - Auto-detection per FR-11

---

## 📝 Tasks

> **Scaffolding:** Run `/transition-plan dt-workflow --expand --phase 2` to add detailed TDD tasks.

### Task Categories

- [ ] **Research Structure Generation** - Templates for research documents
- [ ] **Research Context Gathering** - Exploration context, existing research
- [ ] **Decision Structure Generation** - Templates for ADR documents
- [ ] **Decision Context Gathering** - Research context, requirements
- [ ] **Handoff File Contract** - Implement per Pattern 4
- [ ] **Flag Implementation** - --from-explore, --from-research with auto-detection

---

## ✅ Completion Criteria

- [ ] `dt-workflow research topic --interactive` works
- [ ] `dt-workflow decision topic --interactive` works
- [ ] `dt-workflow research --from-explore topic --interactive` chains correctly
- [ ] `dt-workflow decision --from-research topic --interactive` chains correctly
- [ ] Handoff files generated with required sections
- [ ] All tests passing

---

## 📦 Deliverables

- Research workflow implementation
- Decision workflow implementation
- `generate_research_structure()` function
- `generate_decision_structure()` function
- Handoff file templates
- Updated tests

---

## 🔗 Dependencies

### Prerequisites

- [ ] Phase 1 complete (foundation)

### Blocks

- Phase 3: Cursor Integration (requires all workflows working)

---

## 🔗 Related Documents

- [Feature Hub](README.md)
- [Previous Phase: Phase 1](phase-1.md)
- [Next Phase: Phase 3](phase-3.md)
- [Research: Workflow I/O Specs](../../research/dt-workflow/research-workflow-io-specs.md)
- [Pattern 4: Handoff File Contract](../../../../docs/patterns/workflow-patterns.md)

---

**Last Updated:** 2026-01-22  
**Status:** 🔴 Scaffolding  
**Next:** Expand with `/transition-plan dt-workflow --expand --phase 2`
