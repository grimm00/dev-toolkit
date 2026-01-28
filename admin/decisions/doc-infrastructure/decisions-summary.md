# Decisions Summary - Doc Infrastructure

**Purpose:** Summary of all architectural decisions for dt-doc-gen and dt-doc-validate  
**Status:** ✅ Complete  
**Created:** 2026-01-20  
**Last Updated:** 2026-01-20

---

## 📋 Decisions Overview

This document summarizes the 7 architectural decisions made for the doc-infrastructure feature, which implements two new dev-toolkit commands:

- **`dt-doc-gen`** — Generate documentation from 17 templates with variable expansion
- **`dt-doc-validate`** — Validate documents against common + type-specific rules

**Decision Points:** 7 ADRs  
**Status:** ✅ All Accepted

---

## 🎯 Key Decisions

### ADR-001: Template Location and Discovery Strategy

**Decision:** Templates remain in dev-infra (single source of truth), NOT bundled with dev-toolkit. Use layered discovery.

**Discovery Priority:**
1. `--template-path` flag (explicit)
2. `$DT_TEMPLATES_PATH` environment variable
3. Config file setting
4. Default local paths
5. Error with setup instructions

**Why:** Single source of truth prevents version drift. Layered discovery provides flexibility.

**ADR:** [adr-001-template-location-strategy.md](adr-001-template-location-strategy.md)

---

### ADR-002: Validation Rule Loading Strategy

**Decision:** Build-time YAML → Bash conversion. No runtime YAML parsing.

**Architecture:**
```
YAML (source) → yq conversion (build) → .bash files (runtime)
```

**Why:** Zero runtime dependencies. Fast loading (<100ms). Offline operation.

**ADR:** [adr-002-validation-rule-loading.md](adr-002-validation-rule-loading.md)

---

### ADR-003: Variable Expansion Approach

**Decision:** Mandatory selective envsubst mode with explicit variable lists.

**Pattern:**
```bash
envsubst '${DATE} ${TOPIC_TITLE} ${STATUS}' < template.tmpl > output.md
```

**Why:** Safe expansion. Preserves `$VAR`, `<!-- AI: -->`, and other content.

**ADR:** [adr-003-variable-expansion.md](adr-003-variable-expansion.md)

---

### ADR-004: Error Output and Exit Code Design

**Decision:** Dual output modes (text default, JSON with `--json`) and standard exit codes.

**Exit Codes:**
| Code | Meaning |
|------|---------|
| 0 | Success (warnings OK) |
| 1 | Validation errors |
| 2 | System errors |

**Why:** Human readable by default, machine parseable for CI/CD.

**ADR:** [adr-004-error-output-design.md](adr-004-error-output-design.md)

---

### ADR-005: Shared Infrastructure Pattern

**Decision:** New `lib/core/output-utils.sh` with `dt_*` prefixed functions.

**Shared Functions:**
- `dt_setup_colors()` — TTY detection
- `dt_print_status()` — ERROR/WARNING/SUCCESS/INFO
- `dt_print_debug()` — Debug output
- `dt_detect_dev_infra()` — Location detection

**Why:** Follows existing patterns (`gh_*`, `gf_*`). Avoids code duplication.

**ADR:** [adr-005-shared-infrastructure.md](adr-005-shared-infrastructure.md)

---

### ADR-006: Document Type Detection Strategy

**Decision:** Auto-detect with explicit override. Priority: `--type` → path → content → error.

**Detection Order:**
1. `--type` flag (always wins)
2. Path-based (primary, 100% reliable)
3. Content-based (fallback, ~60% reliable)
4. Error with available types

**Why:** Zero friction for standard locations. Explicit override for edge cases.

**ADR:** [adr-006-type-detection.md](adr-006-type-detection.md)

---

### ADR-007: Command Migration and Iteration Strategy

**Decision:** Per-command iteration sprints with incremental migration.

**Sprint Order:**
| Sprint | Command | Complexity |
|--------|---------|------------|
| 1 | `/explore` | High (two-mode) |
| 2 | `/research` | High (two-mode) |
| 3 | `/decision` | Medium |
| 4 | `/transition-plan` | Medium |
| 5 | `/handoff` | Low |
| 6 | `/fix-plan` | Low |

**Iteration Plan Decision Points:**
| DP | Resolution |
|----|------------|
| DP-1 | Layered discovery (per ADR-001) |
| DP-2 | PR per sprint (batched) |
| DP-3 | Remove fallback when next sprint validates |
| DP-4 | Match inline first, then tighten |
| DP-5 | Capture baseline from inline templates |

**Why:** Low risk. Early sprints inform later sprints. Backward compatible.

**ADR:** [adr-007-migration-strategy.md](adr-007-migration-strategy.md)

---

## 📋 Requirements Impact

### Requirements Fully Addressed

| Category | Count | Coverage |
|----------|-------|----------|
| Functional Requirements | 38 | ~90% addressed by decisions |
| Non-Functional Requirements | 23 | ~95% addressed by decisions |
| Constraints | 19 | 100% acknowledged |

### Key Requirements by ADR

| ADR | Key Requirements Addressed |
|-----|---------------------------|
| ADR-001 | FR-DT-1, FR-DT-2, FR-DT-3, FR-DT-4, NFR-DT-1, NFR-DT-2, C-DT-1 |
| ADR-002 | FR-YP1, FR-YP2, FR-YP3, FR-YP5, FR-YP6, NFR-YP1, NFR-YP2 |
| ADR-003 | FR-VE1, FR-VE2, FR-VE3, FR-VE4, FR-VE5, NFR-VE1, NFR-VE2, NFR-VE3 |
| ADR-004 | FR-EO1, FR-EO2, FR-EO3, FR-EO4, FR-EO5, FR-EO6, NFR-EO1-4 |
| ADR-005 | FR-SI1, FR-SI2, FR-SI3, FR-SI4, NFR-SI1, NFR-SI2, NFR-SI3 |
| ADR-006 | FR-TD1, FR-TD2, FR-TD3, FR-TD4, FR-TD5, NFR-TD1, NFR-TD2, NFR-TD3 |
| ADR-007 | NFR-CI1, NFR-CI2, NFR-CI3, NFR-CI4, C-CI1, C-CI2, C-CI3 |

---

## 🏗️ Architecture Summary

```
┌─────────────────────────────────────────────────────────────────┐
│  Cursor Commands (/explore, /research, etc.)                     │
│  • Orchestrate workflows                                         │
│  • Invoke dt-doc-gen for structure                               │
│  • Generate AI content for placeholders                          │
│  • Invoke dt-doc-validate before commit                          │
└─────────────────────────────────────────────────────────────────┘
                              │
              ┌───────────────┴───────────────┐
              ▼                               ▼
┌─────────────────────────┐     ┌─────────────────────────────────┐
│  dt-doc-gen              │     │  dt-doc-validate                 │
│  • Layered template      │     │  • Auto type detection           │
│    discovery (ADR-001)   │     │    (ADR-006)                     │
│  • Selective envsubst    │     │  • Pre-compiled rules            │
│    (ADR-003)             │     │    (ADR-002)                     │
│  • Two-mode support      │     │  • Text/JSON output              │
│    (setup/conduct)       │     │    (ADR-004)                     │
└─────────────────────────┘     └─────────────────────────────────┘
              │                               │
              └───────────────┬───────────────┘
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│  Shared Infrastructure (ADR-005)                                 │
│  lib/core/output-utils.sh                                        │
│  • dt_setup_colors(), dt_print_status(), dt_print_debug()        │
│  • dt_detect_dev_infra()                                         │
└─────────────────────────────────────────────────────────────────┘
                              │
              ┌───────────────┴───────────────┐
              ▼                               ▼
┌─────────────────────────┐     ┌─────────────────────────────────┐
│  dev-infra               │     │  dev-infra                       │
│  templates/*.tmpl        │     │  validation-rules/*.bash         │
│  (source of truth)       │     │  (pre-compiled from YAML)        │
└─────────────────────────┘     └─────────────────────────────────┘
```

---

## 🚀 Next Steps

1. ✅ Research phase complete (7 topics)
2. ✅ Decisions made (7 ADRs)
3. **Next:** Use `/transition-plan doc-infrastructure --from-adr` to create implementation plan
4. **Then:** Begin Sprint 1 (`/explore` command)

---

## 🔗 Related Documents

- [Research Hub](../../research/doc-infrastructure/README.md)
- [Requirements](../../research/doc-infrastructure/requirements.md) (80 requirements)
- [Iteration Plan](../../research/doc-infrastructure/iteration-plan.md)
- [Research Summary](../../research/doc-infrastructure/research-summary.md)

---

**Last Updated:** 2026-01-20
