# Feature Plan - Doc Infrastructure

**Feature:** dt-doc-gen and dt-doc-validate  
**Status:** 🔴 Not Started  
**Created:** 2026-01-21  
**Last Updated:** 2026-01-21  
**Source:** [Decisions Hub](../../../decisions/doc-infrastructure/README.md)

---

## 📋 Overview

Implement two new dev-toolkit commands that integrate with dev-infra templates and validation rules:

- **`dt-doc-gen`** — Generate documentation from 17 templates with variable expansion
- **`dt-doc-validate`** — Validate documents against common + type-specific rules

### Goals

1. Single source of truth for templates (dev-infra)
2. Zero runtime dependencies for core functionality
3. XDG-compliant configuration paths
4. Backward compatibility with existing project structures

---

## 🎯 Success Criteria

- [ ] `dt-doc-gen` generates all 17 document types correctly
- [ ] `dt-doc-validate` validates all 17 document types
- [ ] Both commands follow existing dev-toolkit patterns
- [ ] Test coverage >80% for both commands
- [ ] Documentation complete (help text, README)

---

## 📊 Scope

### In Scope

| Component | Description |
|-----------|-------------|
| **Shared Infrastructure** | `lib/core/output-utils.sh` with `dt_*` functions |
| **dt-doc-gen** | Template discovery, variable expansion, two-mode support |
| **dt-doc-validate** | Rule loading, type detection, error output |
| **Testing** | Unit and integration tests for both commands |

### Out of Scope (Future)

| Item | Reason |
|------|--------|
| Command migration | Separate feature after core implementation |
| Remote template fetch | Future enhancement (FR-DT-5) |
| Direct YAML parsing | Optional enhancement (FR-YP4) |

---

## 🏗️ Architecture Decisions

| ADR | Decision |
|-----|----------|
| [ADR-001](../../../decisions/doc-infrastructure/adr-001-template-location-strategy.md) | Templates in dev-infra, layered discovery, XDG config |
| [ADR-002](../../../decisions/doc-infrastructure/adr-002-validation-rule-loading.md) | Build-time YAML→Bash conversion |
| [ADR-003](../../../decisions/doc-infrastructure/adr-003-variable-expansion.md) | Selective envsubst mandatory |
| [ADR-004](../../../decisions/doc-infrastructure/adr-004-error-output-design.md) | Text + JSON dual output mode |
| [ADR-005](../../../decisions/doc-infrastructure/adr-005-shared-infrastructure.md) | `lib/core/output-utils.sh` with `dt_*` prefix |
| [ADR-006](../../../decisions/doc-infrastructure/adr-006-type-detection.md) | Path → Content → Explicit type detection |
| [ADR-007](../../../decisions/doc-infrastructure/adr-007-migration-strategy.md) | Per-command migration sprints |

---

## 📅 Phases

### Phase 1: Shared Infrastructure (2-3 days)

**Goal:** Create foundation for both commands

**Deliverables:**
- `lib/core/output-utils.sh` with all `dt_*` functions
- XDG helpers (`dt_get_config_dir`, `dt_get_data_dir`)
- Project structure detection (`dt_detect_project_structure`)
- Unit tests for shared library

**ADRs:** ADR-005, ADR-001 (XDG), ADR-006 (project structure)

---

### Phase 2: dt-doc-gen (3-4 days)

**Goal:** Implement document generation command

**Deliverables:**
- `bin/dt-doc-gen` CLI
- `lib/doc-gen/templates.sh` for template discovery
- `lib/doc-gen/render.sh` for variable expansion
- Two-mode support (setup/conduct)
- Unit and integration tests

**ADRs:** ADR-001, ADR-003

---

### Phase 3: dt-doc-validate (3-4 days)

**Goal:** Implement document validation command

**Deliverables:**
- `bin/dt-doc-validate` CLI
- `lib/doc-validate/rules.sh` for rule loading
- `lib/doc-validate/type-detection.sh` for type detection
- Text and JSON output formatters
- Unit and integration tests

**ADRs:** ADR-002, ADR-004, ADR-006

---

## 📋 Requirements Summary

| Category | Count | Key Items |
|----------|-------|-----------|
| **Functional** | 38 | Template discovery, rule loading, type detection |
| **Non-Functional** | 23 | Performance (<1s), offline operation, XDG compliance |
| **Constraints** | 19 | No bundled templates, bash-only, backward compatible |

**See:** [Requirements Document](../../../research/doc-infrastructure/requirements.md)

---

## 🔗 Related Documents

- [Decisions Summary](../../../decisions/doc-infrastructure/decisions-summary.md)
- [Research Summary](../../../research/doc-infrastructure/research-summary.md)
- [Iteration Plan](../../../research/doc-infrastructure/iteration-plan.md) (command migration)

---

**Last Updated:** 2026-01-21
