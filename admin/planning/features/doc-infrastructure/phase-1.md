# Doc Infrastructure - Phase 1: Shared Infrastructure

**Phase:** 1 - Shared Infrastructure  
**Duration:** 2-3 days  
**Status:** 🔴 Scaffolding (needs expansion)  
**Prerequisites:** ADR-005, ADR-001 (XDG), ADR-006 (project structure) accepted

---

## 📋 Overview

Create the shared infrastructure library (`lib/core/output-utils.sh`) that both `dt-doc-gen` and `dt-doc-validate` will use. This includes output formatting, XDG configuration helpers, and project structure detection.

**Success Definition:** All `dt_*` functions implemented and tested, ready for use by Phase 2 and Phase 3.

---

## 🎯 Goals

1. **Create output-utils.sh** - Shared library with `dt_*` prefixed functions
2. **Implement XDG helpers** - Configuration and data directory functions
3. **Implement project structure detection** - Support admin/ and docs/maintainers/ paths
4. **Write unit tests** - Full coverage for shared library

---

## 📝 Tasks

> ⚠️ **Scaffolding:** Run `/transition-plan doc-infrastructure --expand --phase 1` to add detailed TDD tasks.

### Task Categories

- [ ] **Output Functions** - dt_setup_colors, dt_print_status, dt_print_debug
- [ ] **XDG Helpers** - dt_get_config_dir, dt_get_data_dir, dt_get_config_file
- [ ] **Detection Functions** - dt_detect_dev_infra, dt_detect_project_structure
- [ ] **Test Suite** - Unit tests for all functions

---

## ✅ Completion Criteria

- [ ] `lib/core/output-utils.sh` exists and sources correctly
- [ ] All `dt_*` functions work as specified in ADR-005
- [ ] XDG paths honor environment variables
- [ ] Project structure detection handles both admin/ and docs/maintainers/
- [ ] Unit tests pass (>80% coverage)

---

## 📦 Deliverables

- `lib/core/output-utils.sh` - Shared library (~100-150 lines)
- `tests/unit/core/test-output-utils.bats` - Unit tests

---

## 🔗 Dependencies

### Prerequisites

- ADR-005 (Shared Infrastructure) accepted
- ADR-001 (XDG compliance) accepted
- ADR-006 (Project structure detection) accepted

### Blocks

- Phase 2 (dt-doc-gen) requires this
- Phase 3 (dt-doc-validate) requires this

---

## 🔗 Related Documents

- [Feature Hub](README.md)
- [ADR-005: Shared Infrastructure](../../../decisions/doc-infrastructure/adr-005-shared-infrastructure.md)
- [ADR-001: Template Location](../../../decisions/doc-infrastructure/adr-001-template-location-strategy.md) (XDG section)
- [ADR-006: Type Detection](../../../decisions/doc-infrastructure/adr-006-type-detection.md) (project structure section)
- [Next Phase: Phase 2](phase-2.md)

---

**Last Updated:** 2026-01-21  
**Status:** 🔴 Scaffolding  
**Next:** Expand with `/transition-plan doc-infrastructure --expand --phase 1`
