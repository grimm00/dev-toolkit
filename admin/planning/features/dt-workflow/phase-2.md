# dt-workflow - Phase 2: Workflow Expansion + Template Enhancement

**Phase:** 2 - Workflow Expansion + Template Enhancement  
**Duration:** 14-18 hours  
**Status:** 🔴 Scaffolding (needs expansion)  
**Prerequisites:** Phase 1 complete

---

## 📋 Overview

Implement the research and decision workflows with enhanced templates. This phase combines workflow expansion with template enhancement (ADR-006) to ensure all workflows use consistent, AI-optimized templates with structural examples.

**Success Definition:** All three workflows (explore, research, decision) working end-to-end with enhanced templates and proper chaining via handoff files.

---

## 🎯 Goals

1. **Template Enhancement** - Enhance dev-infra templates with structural examples (ADR-006)
2. **Template Integration** - Replace spike heredocs with render.sh template rendering
3. **Research Workflow** - Structure generation and context gathering for research
4. **Decision Workflow** - Structure generation and context gathering for decisions
5. **Handoff Files** - Standardized output files per FR-10
6. **--from-* Flags** - Auto-detection per FR-11

---

## 📝 Tasks

> **Scaffolding:** Run `/transition-plan dt-workflow --expand --phase 2` to add detailed TDD tasks.

### Task Categories

#### Template Enhancement (ADR-006)

- [ ] **Enhance Exploration Templates** - Add structural examples to dev-infra exploration/*.tmpl
- [ ] **Enhance Research Templates** - Add structural examples to dev-infra research/*.tmpl
- [ ] **Enhance Decision Templates** - Add structural examples to dev-infra decision/*.tmpl
- [ ] **Template Variable Documentation** - Document all variables per FR-27
- [ ] **Section Completeness Markers** - Add REQUIRED markers per FR-26
- [ ] **Integrate render.sh** - Replace heredocs with `dt_render_template()` calls

#### Workflow Implementation

- [ ] **Research Structure Generation** - Use enhanced templates for research documents
- [ ] **Research Context Gathering** - Exploration context, existing research
- [ ] **Decision Structure Generation** - Use enhanced templates for ADR documents
- [ ] **Decision Context Gathering** - Research context, requirements
- [ ] **Handoff File Contract** - Implement per Pattern 4
- [ ] **Flag Implementation** - --from-explore, --from-research with auto-detection

---

## ✅ Completion Criteria

### Template Enhancement (ADR-006)
- [ ] Dev-infra exploration templates enhanced with structural examples
- [ ] Dev-infra research templates enhanced with structural examples
- [ ] Dev-infra decision templates enhanced with structural examples
- [ ] Template variable contract documented (FR-27)
- [ ] dt-workflow uses render.sh instead of heredocs (NFR-7)

### Workflow Implementation
- [ ] `dt-workflow research topic --interactive` works
- [ ] `dt-workflow decision topic --interactive` works
- [ ] `dt-workflow research --from-explore topic --interactive` chains correctly
- [ ] `dt-workflow decision --from-research topic --interactive` chains correctly
- [ ] Handoff files generated with required sections
- [ ] All tests passing

---

## 📦 Deliverables

### Template Enhancement
- Enhanced dev-infra templates (exploration/, research/, decision/)
- Template variable documentation
- PR to dev-infra with template changes

### Workflow Implementation
- Research workflow implementation via render.sh
- Decision workflow implementation via render.sh
- Handoff file generation
- Updated tests covering all workflows

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
- [ADR-006: Template Enhancement](../../decisions/dt-workflow/adr-006-template-enhancement.md)
- [Research: Template Structure](../../research/dt-workflow/research-template-structure.md)
- [Research: Workflow I/O Specs](../../research/dt-workflow/research-workflow-io-specs.md)
- [Pattern 4: Handoff File Contract](../../../../docs/patterns/workflow-patterns.md)
- [Dev-Infra Templates](~/Projects/dev-infra/scripts/doc-gen/templates/)

---

**Last Updated:** 2026-01-22  
**Status:** 🔴 Scaffolding  
**Next:** Expand with `/transition-plan dt-workflow --expand --phase 2`
