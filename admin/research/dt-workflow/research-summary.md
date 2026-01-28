# Research Summary - dt-workflow

**Purpose:** Summary of all research findings for dt-workflow  
**Status:** 🔴 Research  
**Created:** 2026-01-23  
**Last Updated:** 2026-01-23

---

## 📋 Research Overview

Research for unified workflow orchestration (dt-workflow) feature.

**Source Exploration:** [admin/explorations/dt-workflow/](../../explorations/dt-workflow/)

**Research Topics:** 6 active topics (2 spike-validated, skipped)  
**Research Documents:** 6 documents  
**Status:** 🔴 Research in progress

---

## 🧪 Spike-Validated Topics

These topics were validated by spike and don't require formal research:

| Topic | Spike Result | Confidence |
|-------|--------------|------------|
| 1. Unified Architecture | ✅ Unified command feels right | High |
| 2. Phase 1 Interface | ✅ --interactive mode works | High |

---

## 🔍 Key Findings

### Finding 1: Context Gathering Scalability (Topic 1) ✅

**Status:** ✅ Complete

**Key findings:**
- Current spike output is ~10K tokens - well within modern LLM limits (100K+)
- **Full context injection is correct** for our scale - RAG complexity not justified
- "Lost in the middle" problem: Place critical rules at START, task at END
- Escape hatch: Switch to hybrid only if hitting performance/limit/cost blockers

**Recommendations:**
- Keep full context injection (our scale doesn't need RAG)
- Implement context ordering for optimal attention
- Add token count reporting for transparency

**Source:** [research-context-gathering.md](research-context-gathering.md)

---

### Finding 2: Component Decisions (Topics 3, 4)

**Status:** 🟡 Analysis complete, pending validation

From exploration analysis:
- **dt-doc-validate:** Keep standalone (CI value)
- **dt-doc-gen:** Internalize as library (no standalone value)

**Source:** [research-component-decisions.md](research-component-decisions.md)

---

### Finding 3: Cursor Command Role (Topic 5)

**Status:** 🟡 Analysis complete, pending validation

From exploration analysis:
- **Option B (Orchestrators)** recommended
- Commands handle Cursor-specific logic
- dt-workflow handles structure/validation

**Source:** [research-cursor-command-role.md](research-cursor-command-role.md)

---

### Finding 4: Workflow Input/Output Specs (Topic 2) ✅

**Status:** ✅ Complete

**Key findings:**
- Each workflow has a **primary handoff file** that next workflow depends on
- **Validation levels:** L1 (existence) = hard fail, L2/L3 (structure/content) = warn
- `--from-*` flags should auto-detect OR accept explicit paths
- All outputs must include "Next Steps" pointing to next workflow

**Data contracts:**
| Workflow | Handoff File | Required Sections |
|----------|--------------|-------------------|
| explore | research-topics.md | ## Topics table |
| research | research-summary.md | ## Key Findings, ## Recommendations |
| decision | decisions-summary.md | ## Decisions table |

**Requirements discovered:** 8 (REQ-IO-1 through REQ-IO-8)

**Source:** [research-workflow-io-specs.md](research-workflow-io-specs.md)

---

### Finding 5: Decision Propagation Patterns (Topic 3) ✅

**Status:** ✅ Complete

**Key findings:**
- **Two-tier documentation approach:**
  - Tier 1: Cursor rules (AI-discoverable, concise)
  - Tier 2: docs/patterns/ (detailed, with rationale)
  - Tier 3: ADRs (architecturally significant decisions)

- **5 Universal Patterns identified:**
  1. Spike Determination (already in workflow.mdc)
  2. Explicit Context Injection
  3. L1/L2/L3 Validation Levels
  4. Handoff File Contract
  5. Phase-Based Evolution

- **Pattern evolution process:**
  Initiation → Consolidation → Documentation → Communication

**Action items:**
- Create `docs/patterns/workflow-patterns.md`
- Add pattern checklist to `/explore` command

**Source:** [research-decision-propagation.md](research-decision-propagation.md)

---

### Finding 6: Model Selection (Topic 6)

**Status:** 🟡 Analysis complete, pending validation

From exploration analysis:
- **Phase 1:** Informational (output recommended model)
- **Phase 2+:** Config-based selection

**Source:** [research-model-selection.md](research-model-selection.md)

---

### Finding 7: Dynamic Section Management (Topic 7) ✅

**Status:** ✅ Complete

**Key findings:**
- Metadata-driven section count (YAML frontmatter) preferred over hardcoding
- `dt-section add` command recommended for incremental additions
- Differentiate ordered vs unordered sections for validation rules
- Section gaps acceptable in unordered, not in ordered

**Requirements discovered:** FR-19 through FR-23, NFR-5, NFR-6

**Source:** [research-dynamic-sections.md](research-dynamic-sections.md)

---

### Finding 8: Template Structure (Topic 8) ✅

**Status:** ✅ Complete

**Key findings:**
- **Structural examples outperform vague placeholders** - AI needs to see expected formats
- **Skeleton-of-Thought validates two-phase approach** - `<!-- AI: -->` + `<!-- EXPAND: -->` is sound
- **MADR offers template complexity variants** - Full, minimal, bare versions per document type
- **envsubst requires explicit variable management** - All variables must be defined in setters
- **Spike heredocs work better** because they show structure, not just instructions

**Recommendations:**
1. Enhance templates with structural examples (tables, lists)
2. Maintain two-phase placeholder pattern
3. Create template complexity variants (full/minimal/bare)
4. Add section completeness markers
5. Document template variable contract

**Requirements discovered:** FR-24 through FR-27, NFR-7

**Source:** [research-template-structure.md](research-template-structure.md)

---

## 💡 Key Insights

- [x] Insight 1: Spike validated core architecture, reducing research scope
- [x] Insight 2: Full context injection is correct for our scale (~10K tokens)
- [x] Insight 3: Two-tier pattern documentation provides best AI/human balance
- [x] Insight 4: Structural template examples outperform vague placeholders
- [x] Insight 5: Dynamic sections need metadata-driven approach with `dt-section` command

---

## 📋 Requirements Summary

**See:** [requirements.md](requirements.md) for complete requirements document

**Requirements discovered:** 0 (pending research completion)

---

## 🎯 Recommendations

**Based on spike + exploration analysis:**

1. **Unified architecture** - Validated by spike
2. **Phase 1 --interactive** - Validated by spike
3. **Context gathering** - Needs research on scalability
4. **Component decisions** - Likely quick decision per exploration
5. **Command role** - Orchestrators pattern per exploration
6. **Model selection** - Phase 1 informational approach

---

## 📊 Research Status

| # | Research Topic | Priority | Status | Primary Focus |
|---|----------------|----------|--------|---------------|
| 1 | Context Gathering | 🔴 HIGH | ✅ Complete | Full injection validated |
| 2 | Workflow I/O Specs | 🔴 HIGH | ✅ Complete | Handoff contracts defined |
| 3 | Decision Propagation | 🔴 HIGH | ✅ Complete | Two-tier pattern system |
| 4 | Component Decisions | 🟠 HIGH | 🟡 Analysis Ready | Quick decision |
| 5 | Cursor Command Role | 🟡 MEDIUM | 🟡 Analysis Ready | Validate |
| 6 | Model Selection | 🟡 MEDIUM | 🟡 Analysis Ready | Defer |
| 7 | Dynamic Section Management | 🔴 HIGH | ✅ Complete | Metadata-driven approach |
| 8 | Template Structure | 🔴 HIGH | ✅ Complete | Structural examples |

---

## 🚀 Next Steps

1. **Conduct context gathering research** - Primary focus
2. **Quick decision on components** - Analysis is clear
3. **Validate command role** - If time permits
4. Use `/decision dt-workflow --from-research` to formalize

---

**Last Updated:** 2026-01-23
