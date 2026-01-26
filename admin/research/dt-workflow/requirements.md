# Requirements - dt-workflow

**Source:** Research on dt-workflow unified workflow orchestration  
**Status:** Draft  
**Created:** 2026-01-23  
**Last Updated:** 2026-01-23

---

## 📋 Overview

This document captures requirements discovered during research on dt-workflow.

**Research Source:** [research-summary.md](research-summary.md)

---

## ✅ Functional Requirements

### Spike-Validated Requirements

These requirements are confirmed by spike implementation:

#### FR-1: Unified Workflow Command

**Description:** dt-workflow must provide a unified command for workflow orchestration

**Source:** Spike validation (Topic 1)

**Priority:** High

**Status:** ✅ Spike implemented

---

#### FR-2: Phase 1 Interactive Mode

**Description:** dt-workflow must support --interactive mode for Phase 1 (manual AI fill)

**Source:** Spike validation (Topic 2)

**Priority:** High

**Status:** ✅ Spike implemented

---

#### FR-3: Explicit Context Injection

**Description:** dt-workflow must explicitly inject context (rules, project identity) in output

**Source:** Spike validation (Topic 10 partial)

**Priority:** High

**Status:** ✅ Spike implemented

---

### Context Gathering Requirements (Research Complete)

#### FR-4: Context Ordering

**Description:** Context must be ordered with critical rules at START of output, task instructions at END (addresses "lost in the middle" problem)

**Source:** [research-context-gathering.md](research-context-gathering.md)

**Priority:** High

**Status:** ✅ Research complete

---

#### FR-5: Token Count Reporting

**Description:** dt-workflow should report approximate token count in output for transparency

**Source:** [research-context-gathering.md](research-context-gathering.md)

**Priority:** Medium

**Status:** ✅ Research complete

---

#### FR-6: Universal Context Inclusion

**Description:** Universal context (Cursor rules, project identity) must always be included in output

**Source:** [research-context-gathering.md](research-context-gathering.md)

**Priority:** High

**Status:** ✅ Research complete

---

#### FR-7: Configurable Workflow Context

**Description:** Workflow-specific context should be configurable per workflow type

**Source:** [research-context-gathering.md](research-context-gathering.md)

**Priority:** Medium

**Status:** ✅ Research complete

---

### Pending Research Requirements

---

#### FR-5: Standalone Validation

**Description:** dt-doc-validate must remain usable standalone for CI/automation

**Source:** [research-component-decisions.md](research-component-decisions.md)

**Priority:** High

**Status:** 🟡 Pending validation

---

#### FR-6: Model Recommendation

**Description:** dt-workflow must output recommended model for each workflow type

**Source:** [research-model-selection.md](research-model-selection.md)

**Priority:** Medium

**Status:** 🟡 Pending validation

---

## 🎯 Non-Functional Requirements

#### NFR-1: Token Budget

**Description:** Total context should stay under 50K tokens for optimal LLM performance (current: ~10K, well within limits)

**Source:** [research-context-gathering.md](research-context-gathering.md)

**Priority:** High

**Status:** ✅ Research complete (current output validated as safe)

---

#### NFR-2: Context Injection Speed

**Description:** Context injection should complete in under 1 second

**Source:** [research-context-gathering.md](research-context-gathering.md)

**Priority:** Medium

**Status:** ✅ Research complete

---

#### NFR-2: Portability

**Description:** dt-workflow must work across different projects without modification

**Source:** dev-toolkit core principle

**Priority:** High

**Status:** 🟡 Inherited from dev-toolkit

---

#### NFR-3: Backward Compatibility

**Description:** Existing dt-doc-validate users must not be broken

**Source:** [research-component-decisions.md](research-component-decisions.md)

**Priority:** Medium

**Status:** 🟡 Pending decision

---

## ⚠️ Constraints

#### C-1: Phase 1 Limitations

**Description:** Cursor CLI cannot invoke AI agents programmatically (Phase 1 constraint)

**Source:** dev-infra research

---

#### C-2: Bash Implementation

**Description:** dt-workflow must be implemented in Bash (dev-toolkit standard)

**Source:** dev-toolkit script standards

---

#### C-3: Full Content Preferred

**Description:** Full content injection is preferred over pointers for rules (rules need full fidelity, not summarization)

**Source:** [research-context-gathering.md](research-context-gathering.md)

---

#### C-4: Hybrid Escape Hatch

**Description:** Switch to hybrid approach (summaries + pointers) ONLY if hitting: performance degradation, token limits, or cost blockers

**Source:** [research-context-gathering.md](research-context-gathering.md)

---

## 💭 Assumptions

#### A-1: User Has Cursor

**Description:** Primary use case assumes user has Cursor IDE for AI interaction (Phase 1)

**Source:** Target audience analysis

---

#### A-2: Rules in Standard Location

**Description:** Cursor rules are in `.cursor/rules/` directory

**Source:** Cursor convention

---

## 🔗 Related Documents

- [Research Summary](research-summary.md)
- [Research Documents](README.md)
- [Exploration](../../explorations/dt-workflow/)

---

## 🚀 Next Steps

1. Complete research to validate pending requirements
2. Refine requirements based on research findings
3. Use `/decision dt-workflow --from-research` to formalize

---

**Last Updated:** 2026-01-23
