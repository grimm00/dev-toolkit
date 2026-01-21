# Doc Infrastructure - Phase 2: dt-doc-gen

**Phase:** 2 - dt-doc-gen  
**Duration:** 3-4 days  
**Status:** 🔴 Scaffolding (needs expansion)  
**Prerequisites:** Phase 1 complete, dev-infra templates accessible

---

## 📋 Overview

Implement the `dt-doc-gen` command for generating documentation from dev-infra templates. Supports layered template discovery, selective variable expansion, and two-mode operation (setup/conduct).

**Success Definition:** All 17 document types generate correctly with proper variable expansion and mode support.

---

## 🎯 Goals

1. **Create dt-doc-gen CLI** - Main command entry point
2. **Implement template discovery** - Layered discovery per ADR-001
3. **Implement variable expansion** - Selective envsubst per ADR-003
4. **Support two modes** - setup mode (structure) and conduct mode (content zones)
5. **Write tests** - Unit and integration tests

---

## 📝 Tasks

> ⚠️ **Scaffolding:** Run `/transition-plan doc-infrastructure --expand --phase 2` to add detailed TDD tasks.

### Task Categories

- [ ] **CLI Implementation** - bin/dt-doc-gen with argument parsing
- [ ] **Template Discovery** - lib/doc-gen/templates.sh with dt_find_templates
- [ ] **Variable Expansion** - lib/doc-gen/render.sh with selective envsubst
- [ ] **Mode Support** - Setup mode vs conduct mode output
- [ ] **Test Suite** - Unit tests for discovery/render, integration tests for CLI

---

## ✅ Completion Criteria

- [ ] `dt-doc-gen exploration my-topic` works correctly
- [ ] `dt-doc-gen --type research my-topic --mode setup` works
- [ ] Template discovery follows priority: flag → env → config → default
- [ ] Variable expansion preserves `$VAR`, `<!-- AI: -->` markers
- [ ] All 17 document types supported
- [ ] Tests passing (>80% coverage)

---

## 📦 Deliverables

- `bin/dt-doc-gen` - CLI entry point
- `lib/doc-gen/templates.sh` - Template discovery functions
- `lib/doc-gen/render.sh` - Variable expansion functions
- `tests/unit/doc-gen/` - Unit tests
- `tests/integration/test-dt-doc-gen.bats` - Integration tests

---

## 🔗 Dependencies

### Prerequisites

- Phase 1 complete (shared infrastructure)
- dev-infra templates accessible locally

### Blocks

- Command migration Sprint 1 (/explore)

---

## 🔗 Related Documents

- [Feature Hub](README.md)
- [Previous Phase: Phase 1](phase-1.md)
- [Next Phase: Phase 3](phase-3.md)
- [ADR-001: Template Location](../../../decisions/doc-infrastructure/adr-001-template-location-strategy.md)
- [ADR-003: Variable Expansion](../../../decisions/doc-infrastructure/adr-003-variable-expansion.md)
- [Research: Template Fetching](../../../research/doc-infrastructure/research-template-fetching.md)

---

**Last Updated:** 2026-01-21  
**Status:** 🔴 Scaffolding  
**Next:** Expand with `/transition-plan doc-infrastructure --expand --phase 2`
