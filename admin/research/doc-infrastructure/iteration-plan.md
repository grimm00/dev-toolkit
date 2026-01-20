# Iteration Plan - Doc Infrastructure

**Purpose:** Per-command iteration strategy for finalizing templates and implementing dt-doc-gen/dt-doc-validate  
**Status:** 🟠 Draft (Pending Decision Phase)  
**Created:** 2026-01-20  
**Last Updated:** 2026-01-20

---

## 📋 Overview

This document defines the **iteration strategy** for implementing doc-infrastructure commands (`dt-doc-gen`, `dt-doc-validate`) with a focus on **per-command template refinement**.

### The Challenge

Dev-infra provides **basic templates** (17 templates, 29 variables, 6 validation rule files), but each Cursor command has specific needs that may require:

- Additional variables not in the base template
- Section structure adjustments for command workflow
- AI expansion zone (`<!-- AI: -->`, `<!-- EXPAND: -->`) placement refinement
- Validation rule tuning for real-world usage

### The Approach

**Command-Focused Sprints:** Implement and refine templates one command at a time, using a feedback loop between dev-toolkit implementation and dev-infra templates.

```
dev-infra (templates) ──→ dev-toolkit (CLI tools) ──→ Cursor commands
         ↑                                                    │
         └────────── feedback loop for refinement ────────────┘
```

---

## 🎯 Iteration Cycle

Each command follows a 5-phase iteration cycle:

```
┌─────────────────────────────────────────────────────────────┐
│  COMMAND ITERATION CYCLE                                     │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  Phase 1: ASSESS                                             │
│     • Inventory current inline templates in command          │
│     • Map to dev-infra template(s)                           │
│     • Identify gaps/mismatches                               │
│     • Document required variables and sections               │
│                                                              │
│  Phase 2: IMPLEMENT                                          │
│     • Wire dt-doc-gen to produce output for this doc type    │
│     • Create test fixtures                                   │
│     • Compare output to inline template (parity check)       │
│                                                              │
│  Phase 3: REFINE                                             │
│     • Document needed template changes                       │
│     • Create local override OR PR to dev-infra               │
│     • Update validation rules if needed                      │
│     • Iterate until output matches command needs             │
│                                                              │
│  Phase 4: VALIDATE                                           │
│     • dt-doc-validate passes on generated output             │
│     • AI expansion zones work correctly                      │
│     • Full workflow test (generate → AI expand → validate)   │
│                                                              │
│  Phase 5: MIGRATE                                            │
│     • Update command to invoke dt-doc-gen                    │
│     • Keep inline template as fallback (Phase 2 migration)   │
│     • Real-world usage testing                               │
│     • Remove fallback when stable (Phase 3 migration)        │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

---

## 📊 Command Iteration Order

Commands are prioritized based on complexity, frequency, and pattern-setting value:

| Sprint | Command | Doc Types | Mode | Complexity | Rationale |
|--------|---------|-----------|------|------------|-----------|
| **1** | `/explore` | exploration.md, research-topics.md, README.md | Two-mode | 🔴 High | Sets patterns for all two-mode commands |
| **2** | `/research` | research-*.md, requirements.md, research-summary.md | Two-mode | 🔴 High | Similar patterns to /explore, high frequency |
| **3** | `/decision` | adr-NNN.md, decisions-summary.md | Single | 🟡 Medium | ADR format is well-defined |
| **4** | `/transition-plan` | feature-plan.md, phase-N.md, status.md | Single | 🟡 Medium | Planning documents |
| **5** | `/handoff` | handoff.md | Single | 🟢 Low | Simpler single-file output |
| **6** | `/fix-plan` | fix-batch-N.md | Single | 🟢 Low | Simpler single-file output |

### Why This Order?

1. **`/explore` first:** Most complex (two-mode, 3 files), highest frequency, sets patterns
2. **`/research` second:** Builds on /explore patterns, validates two-mode approach
3. **Single-mode commands last:** Simpler, benefit from lessons learned

---

## 🔧 Sprint 1: `/explore` Command

### 1.1 Assessment Scope

| Item | Details |
|------|---------|
| **Command Location** | `.cursor/commands/explore.md` (in dev-infra) |
| **Inline Templates** | ~6-7 inline template instances |
| **Dev-infra Templates** | `exploration/exploration.tmpl`, `exploration/research-topics.tmpl`, `exploration/README.tmpl` |
| **Variables Used** | `${TOPIC_NAME}`, `${TOPIC_TITLE}`, `${TOPIC_COUNT}`, `${CREATED_DATE}` |
| **Modes** | Setup (scaffolding) / Conduct (expand) |

### 1.2 Assessment Deliverables

- [ ] **Gap Analysis:** Document differences between inline templates and dev-infra templates
- [ ] **Variable Inventory:** List all variables /explore needs vs what templates provide
- [ ] **Section Comparison:** Map inline sections to template sections
- [ ] **AI Zone Analysis:** Identify where `<!-- AI: -->` and `<!-- EXPAND: -->` should be placed

### 1.3 Implementation Deliverables

- [ ] `dt-doc-gen exploration <topic> --mode setup` produces 3 files
- [ ] `dt-doc-gen exploration <topic> --mode conduct` handles expansion prep
- [ ] Test fixtures for exploration documents
- [ ] Output parity with current inline templates (diff should be minimal)

### 1.4 Refinement Deliverables

- [ ] Template refinement spec documenting needed changes
- [ ] Local template overrides for testing
- [ ] PR to dev-infra (when changes stabilize)
- [ ] Validation rule adjustments (if needed)

### 1.5 Validation Deliverables

- [ ] `dt-doc-validate admin/explorations/<topic>/` passes
- [ ] AI expansion produces valid output
- [ ] Full workflow test documented

### 1.6 Migration Deliverables

- [ ] Updated /explore command using dt-doc-gen
- [ ] Inline template fallback preserved
- [ ] Real-world usage confirmation

---

## 🔧 Sprint 2: `/research` Command

### 2.1 Assessment Scope

| Item | Details |
|------|---------|
| **Command Location** | `.cursor/commands/research.md` (in dev-infra) |
| **Inline Templates** | ~8-10 inline template instances |
| **Dev-infra Templates** | `research/research-topic.tmpl`, `research/research-summary.tmpl`, `research/requirements.tmpl`, `research/README.tmpl` |
| **Variables Used** | `${QUESTION}`, `${QUESTION_NAME}`, `${FEATURE_NAME}`, `${CREATED_DATE}` |
| **Modes** | Setup (scaffolding) / Conduct (expand) |

### 2.2 Assessment Deliverables

- [ ] Gap analysis for /research inline vs templates
- [ ] Variable inventory
- [ ] Section comparison
- [ ] AI zone analysis

### 2.3-2.6 Implementation Through Migration

*(Same deliverable structure as Sprint 1)*

---

## 🔧 Sprints 3-6: Single-Mode Commands

Single-mode commands (`/decision`, `/transition-plan`, `/handoff`, `/fix-plan`) follow the same iteration cycle but with reduced complexity:

- No setup/conduct mode distinction
- Typically single-file output
- Simpler validation rules

**Sprint 3:** `/decision` → ADR generation  
**Sprint 4:** `/transition-plan` → Planning documents  
**Sprint 5:** `/handoff` → Session handoff  
**Sprint 6:** `/fix-plan` → Fix batch planning

---

## 🔀 Template Refinement Strategy

### Option A: Local Overrides (Recommended for Development)

```bash
# During development, override templates locally
export DT_TEMPLATES_PATH=~/Projects/dev-toolkit/templates-dev/

# Structure:
templates-dev/
├── exploration/
│   ├── exploration.tmpl      # Modified version
│   ├── research-topics.tmpl
│   └── README.tmpl
└── validation-rules/
    └── exploration.yaml      # Modified rules
```

**Pros:** Fast iteration, no cross-repo coordination  
**Cons:** Changes not shared until PR'd to dev-infra

### Option B: Dev-infra Branch (Coordinated Development)

```bash
# Work directly in dev-infra branch
cd ~/Projects/dev-infra
git checkout -b feat/explore-template-refinement

# Make changes, test with dt-doc-gen in dev-toolkit
# PR when stable
```

**Pros:** Changes immediately shared, single source of truth  
**Cons:** Slower iteration, requires cross-repo coordination

### Recommended Approach

1. **Start with Option A** for rapid iteration during implementation
2. **Batch template changes** per sprint
3. **PR to dev-infra** when sprint completes and patterns stabilize
4. **Switch to Option B** for maintenance/refinement after initial implementation

---

## ❓ Decision Points

The following require decisions before implementation begins:

### DP-1: Template Override Mechanism

**Question:** How does dt-doc-gen discover and use local template overrides?

**Options:**
1. Environment variable only (`$DT_TEMPLATES_PATH`)
2. CLI flag only (`--template-path`)
3. Layered discovery (flag → env → config → defaults) ← *Research recommendation*

**Recommendation:** Option 3 (layered discovery) per research findings

---

### DP-2: Dev-infra Coordination Model

**Question:** How do template changes flow back to dev-infra?

**Options:**
1. PR per template change (fine-grained)
2. PR per sprint (batched)
3. PR per command migration complete (coarse-grained)

**Recommendation:** Option 2 (PR per sprint) balances speed and coordination

---

### DP-3: Migration Fallback Duration

**Question:** How long do inline templates remain as fallback (Phase 2)?

**Options:**
1. Until next sprint starts
2. Until all commands migrated
3. Indefinitely (feature flag)

**Recommendation:** Option 1 - remove fallback when next sprint validates patterns

---

### DP-4: Validation Strictness Strategy

**Question:** Start strict and loosen, or start loose and tighten?

**Options:**
1. Strict initially, loosen based on false positives
2. Loose initially, tighten based on missed issues
3. Match current inline template behavior exactly

**Recommendation:** Option 3 initially, then Option 1 for progressive improvement

---

### DP-5: Test Fixture Source

**Question:** Where do test fixtures for generated documents come from?

**Options:**
1. Manually created fixtures
2. Generated from current inline templates (capture baseline)
3. Generated from dev-infra templates (forward-looking)

**Recommendation:** Option 2 first (establishes parity), then Option 3 (validates templates)

---

## 📋 Acceptance Criteria

### Per-Sprint Acceptance

A sprint is complete when:

- [ ] dt-doc-gen produces output for all doc types in that command
- [ ] dt-doc-validate passes on all generated output
- [ ] Output matches current inline template behavior (parity)
- [ ] AI expansion zones work correctly in real usage
- [ ] Command updated to use dt-doc-gen (with fallback)
- [ ] Template refinements documented and/or PR'd to dev-infra
- [ ] Test coverage for new functionality

### Overall Feature Acceptance

The doc-infrastructure feature is complete when:

- [ ] All 6 command sprints complete
- [ ] All inline templates removed from commands (Phase 3)
- [ ] Templates stable in dev-infra
- [ ] Documentation complete
- [ ] CI integration working (dt-doc-validate in pre-commit)

---

## 📅 Estimated Timeline

| Sprint | Command | Estimated Duration | Dependencies |
|--------|---------|-------------------|--------------|
| 1 | `/explore` | 3-5 days | Core dt-doc-gen implementation |
| 2 | `/research` | 2-3 days | Sprint 1 patterns |
| 3 | `/decision` | 1-2 days | Sprint 2 patterns |
| 4 | `/transition-plan` | 1-2 days | Sprint 3 patterns |
| 5 | `/handoff` | 1 day | Sprint 4 patterns |
| 6 | `/fix-plan` | 1 day | Sprint 5 patterns |

**Total Estimated:** 9-14 days for all sprints (after core implementation)

---

## 🔗 Related Documents

- [Research Summary](research-summary.md) - All research findings
- [Requirements](requirements.md) - 80 requirements from research
- [Command Integration Research](research-command-integration.md) - Integration patterns
- [Template Fetching Research](research-template-fetching.md) - Template discovery strategy

---

## 🚀 Next Steps

1. **Decision Phase:** Resolve DP-1 through DP-5
2. **Core Implementation:** Build dt-doc-gen and dt-doc-validate foundation
3. **Sprint 1:** Begin /explore command iteration

---

**Last Updated:** 2026-01-20
