# Doc Infrastructure - Phase 3: dt-doc-validate

**Phase:** 3 - dt-doc-validate  
**Duration:** 3-4 days  
**Status:** 🔴 Scaffolding (needs expansion)  
**Prerequisites:** Phase 1 complete, dev-infra validation rules accessible

---

## 📋 Overview

Implement the `dt-doc-validate` command for validating documentation against common and type-specific rules. Supports automatic type detection, pre-compiled rule loading, and dual output modes (text/JSON).

**Success Definition:** All 17 document types validate correctly with proper error output and exit codes.

---

## 🎯 Goals

1. **Create dt-doc-validate CLI** - Main command entry point
2. **Implement rule loading** - Pre-compiled .bash rules per ADR-002
3. **Implement type detection** - Path → content → explicit per ADR-006
4. **Implement error output** - Text and JSON modes per ADR-004
5. **Write tests** - Unit and integration tests

---

## 📝 Tasks

> ⚠️ **Scaffolding:** Run `/transition-plan doc-infrastructure --expand --phase 3` to add detailed TDD tasks.

### Task Categories

- [ ] **CLI Implementation** - bin/dt-doc-validate with argument parsing
- [ ] **Rule Loading** - lib/doc-validate/rules.sh with dt_load_rules
- [ ] **Type Detection** - lib/doc-validate/type-detection.sh with detect_document_type
- [ ] **Error Output** - Text and JSON formatters, exit codes (0/1/2)
- [ ] **Test Suite** - Unit tests for rules/detection, integration tests for CLI

---

## ✅ Completion Criteria

- [ ] `dt-doc-validate admin/explorations/my-topic/` works correctly
- [ ] `dt-doc-validate --type adr decisions/adr-001.md` works
- [ ] Type detection follows priority: flag → path → content → error
- [ ] Error output shows location, message, severity, fix suggestion
- [ ] Exit codes: 0 (success/warnings), 1 (errors), 2 (system)
- [ ] `--json` flag produces valid JSON output
- [ ] All 17 document types validated correctly
- [ ] Tests passing (>80% coverage)

---

## 📦 Deliverables

- `bin/dt-doc-validate` - CLI entry point
- `lib/doc-validate/rules.sh` - Rule loading functions
- `lib/doc-validate/type-detection.sh` - Type detection functions
- `lib/doc-validate/output.sh` - Text and JSON formatters
- `tests/unit/doc-validate/` - Unit tests
- `tests/integration/test-dt-doc-validate.bats` - Integration tests

---

## 🔗 Dependencies

### Prerequisites

- Phase 1 complete (shared infrastructure)
- dev-infra validation rules accessible (pre-compiled .bash)

### Blocks

- Command migration Sprint 1 (/explore)

---

## 🔗 Related Documents

- [Feature Hub](README.md)
- [Previous Phase: Phase 2](phase-2.md)
- [ADR-002: Validation Rule Loading](../../../decisions/doc-infrastructure/adr-002-validation-rule-loading.md)
- [ADR-004: Error Output Design](../../../decisions/doc-infrastructure/adr-004-error-output-design.md)
- [ADR-006: Type Detection](../../../decisions/doc-infrastructure/adr-006-type-detection.md)
- [Research: YAML Parsing](../../../research/doc-infrastructure/research-yaml-parsing.md)
- [Research: Error Output](../../../research/doc-infrastructure/research-error-output.md)

---

**Last Updated:** 2026-01-21  
**Status:** 🔴 Scaffolding  
**Next:** Expand with `/transition-plan doc-infrastructure --expand --phase 3`
