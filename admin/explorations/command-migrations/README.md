# Command Migrations - Exploration Hub

**Purpose:** Explore migration of Cursor commands to use dt-doc-gen/dt-doc-validate  
**Status:** 🔴 Exploration  
**Created:** 2026-01-22  
**Last Updated:** 2026-01-22

---

## 📋 Quick Links

### Command Explorations

| Sprint | Command | Status | Complexity | Notes |
|--------|---------|--------|------------|-------|
| 1 | [/explore](explore/README.md) | ✅ Expanded | 🔴 High | Two-mode, 3 files, sets patterns |
| 2 | /research | 🔴 Not Started | 🔴 High | Similar to /explore |
| 3 | /decision | 🔴 Not Started | 🟡 Medium | ADR format well-defined |
| 4 | /transition-plan | 🔴 Not Started | 🟡 Medium | Planning documents |
| 5 | /handoff | 🔴 Not Started | 🟢 Low | Single file |
| 6 | /fix-plan | 🔴 Not Started | 🟢 Low | Single file |

### Related Documents

- **[Iteration Plan](../../research/doc-infrastructure/iteration-plan.md)** - Overall migration strategy
- **[dt-doc-gen](../../planning/features/doc-infrastructure/phase-2.md)** - Phase 2 implementation
- **[dt-doc-validate](../../planning/features/doc-infrastructure/phase-3.md)** - Phase 3 implementation

---

## 🎯 Overview

This directory contains explorations for migrating each Cursor command from inline templates to using `dt-doc-gen` and `dt-doc-validate`.

### Migration Flow

```
┌─────────────────────────────────────────────────────────────────┐
│  PER-COMMAND MIGRATION WORKFLOW                                  │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  1. /explore [command]-migration                                 │
│     • Inventory inline templates                                 │
│     • Map to dev-infra templates                                 │
│     • Identify gaps, variables, AI zones                         │
│                                                                  │
│  2. /research (if questions arise)                               │
│     • Investigate integration questions                          │
│     • Document findings                                          │
│                                                                  │
│  3. /decision (if significant choices)                           │
│     • Template override vs dev-infra PR                          │
│     • Validation strictness                                      │
│                                                                  │
│  4. /transition-plan                                             │
│     • Create phased migration plan                               │
│     • Define tasks, acceptance criteria                          │
│                                                                  │
│  5. /task-phase                                                  │
│     • Execute the migration                                      │
│     • TDD workflow                                               │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

### Why This Order?

1. **`/explore` first:** Most complex (two-mode, 3 files), sets patterns for all
2. **`/research` second:** Builds on /explore patterns, validates two-mode approach
3. **Single-mode commands last:** Simpler, benefit from lessons learned

---

## 📊 Sprint Progress

| Sprint | Exploration | Research | Decision | Plan | Implementation |
|--------|-------------|----------|----------|------|----------------|
| 1: /explore | ✅ | 🔴 | ⬜ | ⬜ | ⬜ |
| 2: /research | ⬜ | ⬜ | ⬜ | ⬜ | ⬜ |
| 3: /decision | ⬜ | ⬜ | ⬜ | ⬜ | ⬜ |
| 4: /transition-plan | ⬜ | ⬜ | ⬜ | ⬜ | ⬜ |
| 5: /handoff | ⬜ | ⬜ | ⬜ | ⬜ | ⬜ |
| 6: /fix-plan | ⬜ | ⬜ | ⬜ | ⬜ | ⬜ |

**Legend:** 🔴 In Progress | ✅ Complete | ⬜ Not Started

---

## 🚀 Next Steps

1. Complete `/explore` command exploration
2. Move to research phase if questions arise
3. Create transition plan for /explore migration
4. Execute migration with `/task-phase`

---

**Last Updated:** 2026-01-22
