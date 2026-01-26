# Research: Workflow Input/Output Specifications

**Research Topic:** dt-workflow  
**Question:** What inputs does each workflow need, and how should outputs prepare for the next workflow?  
**Status:** ✅ Complete  
**Priority:** 🔴 HIGH  
**Created:** 2026-01-23  
**Last Updated:** 2026-01-23  
**Completed:** 2026-01-23

---

## 🎯 Research Question

Workflows chain together: explore → research → decision → implementation. Each workflow needs specific inputs and should produce outputs that prepare for the next stage.

**Primary Questions:**
1. What inputs does each workflow require?
2. What outputs should each workflow produce?
3. How should dt-workflow validate inputs before proceeding?
4. How should outputs be formatted for optimal handoff?

---

## 🔍 Research Goals

- [x] Goal 1: Document input requirements for each workflow type
- [x] Goal 2: Document output specifications for each workflow type
- [x] Goal 3: Design input validation strategy
- [x] Goal 4: Design output format for workflow chaining
- [x] Goal 5: Define `--from-*` flag specifications

---

## 📚 Research Methodology

**Sources:**
- [x] Current command implementations (explore, research, decision)
- [x] Existing `--from-explore`, `--from-research` patterns
- [x] Exploration/research document structures
- [x] Web search: Workflow orchestration input/output patterns

---

## 📊 Findings

### Finding 1: Current Workflow Chain (Validated)

**Observed pattern from existing commands:**

```
/explore [topic]
    INPUT:  Raw text, topic name, or --from-start/--from-reflect
    OUTPUT: exploration.md, research-topics.md, README.md
    ENABLES: /research --from-explore

/research [topic] --from-explore [topic]
    INPUT:  exploration/research-topics.md
    OUTPUT: research-*.md, requirements.md, research-summary.md
    ENABLES: /decision --from-research

/decision [topic] --from-research
    INPUT:  research-summary.md, requirements.md, research-*.md
    OUTPUT: adr-*.md, decisions-summary.md
    ENABLES: /transition-plan --from-adr

/transition-plan --from-adr
    INPUT:  ADR documents
    OUTPUT: feature-plan.md, phase-*.md
    ENABLES: Implementation
```

**Source:** Current Cursor command implementations

**Relevance:** Establishes the pattern to formalize in dt-workflow

---

### Finding 2: Complete Input/Output Specification

| Workflow | Required Inputs | Optional Inputs | Required Outputs | Handoff File |
|----------|-----------------|-----------------|------------------|--------------|
| **explore** | topic name OR raw text | --from-start, --from-reflect | README.md, exploration.md, research-topics.md | `research-topics.md` |
| **spike** | topic, questions | time-box duration | spike-learnings.md, code (optional) | `spike-learnings.md` |
| **research** | research-topics.md | external sources | research-*.md, requirements.md, summary.md | `research-summary.md` + `requirements.md` |
| **decision** | research-summary.md, requirements.md | constraints | adr-*.md, decisions-summary.md | `decisions-summary.md` |
| **transition** | ADR documents | timeline preferences | feature-plan.md, phase-*.md | `feature-plan.md` |

**Key insight:** Each workflow has a **primary handoff file** that the next workflow depends on.

**Source:** Command analysis + workflow documentation

**Relevance:** Defines the "contract" between workflow stages

---

### Finding 3: Input Validation Strategy

**Industry patterns (AWS Step Functions, Data Contracts):**

1. **InputPath filtering:** Only pass relevant data to the task
2. **Validation before execution:** Fail early if inputs invalid
3. **Schema validation:** Machine-readable format compliance
4. **Graceful degradation:** Handle optional inputs gracefully

**Recommended validation levels for dt-workflow:**

| Level | Check | Action on Failure |
|-------|-------|-------------------|
| **L1: Existence** | Required files exist | Hard fail with helpful message |
| **L2: Structure** | Files have expected sections | Warn, proceed with available data |
| **L3: Content** | Key fields populated | Warn, allow user to continue |
| **L4: Quality** | Content meets expectations | Informational only |

**Example validation flow:**

```bash
# dt-workflow research --from-explore topic
# 
# L1: Check research-topics.md exists
#     → FAIL: "Missing research-topics.md. Run /explore first."
#
# L2: Check research-topics.md has ## Topics section
#     → WARN: "No topics found in research-topics.md"
#
# L3: Check at least one topic is defined
#     → WARN: "No research topics defined. Add topics first?"
```

**Source:** AWS Step Functions patterns, Data Contract CLI

**Relevance:** Defines error handling strategy for dt-workflow

---

### Finding 4: Output Format for Chaining

**Unix philosophy insight:** Use structured intermediate formats for reliable handoffs.

**Recommendations:**

1. **Markdown with machine-parseable sections:**
   ```markdown
   ## 📋 Topics
   
   | # | Topic | Priority | Status |
   |---|-------|----------|--------|
   | 1 | Context Gathering | HIGH | Pending |
   ```

2. **Consistent section headers:** Use exact headers for parsing
   - `## 📋 Quick Links`
   - `## 🎯 Research Overview`
   - `## 📊 Research Status`

3. **Status table as primary handoff data:**
   - Machine-parseable (table format)
   - Human-readable
   - Status tracking built-in

4. **Avoid prose-only sections for handoff data:**
   - Tables > paragraphs for structured data
   - Lists > paragraphs for enumerable items

**Source:** CLI data contract patterns, Unix philosophy

**Relevance:** Ensures reliable workflow chaining

---

### Finding 5: `--from-*` Flag Specifications

**Current pattern analysis:**

| Flag | Source Location | Primary File | Fallback |
|------|-----------------|--------------|----------|
| `--from-explore` | `admin/explorations/[topic]/` | `research-topics.md` | `exploration.md` |
| `--from-research` | `admin/research/[topic]/` | `research-summary.md` | Individual `research-*.md` |
| `--from-adr` | `admin/decisions/[topic]/` | `decisions-summary.md` | Individual `adr-*.md` |

**Recommended enhancements:**

1. **Auto-detection:** If topic exists, find the handoff file automatically
2. **Explicit path override:** `--from-explore /path/to/research-topics.md`
3. **Validation on flag parse:** Check file exists before workflow starts

**Source:** Existing command implementations

**Relevance:** Standardizes the `--from-*` interface

---

### Finding 6: Spike Workflow I/O (New)

Based on the spike workflow pattern we documented:

| Field | Specification |
|-------|---------------|
| **Input** | Topic name + questions to validate (from exploration) |
| **Time-box** | Duration in hours (default: 2-4h) |
| **Output** | `spike-learnings.md` with: findings, new questions, go/no-go |
| **Handoff to research** | Refined questions feed into research topics |

**Spike → Research handoff:**
```markdown
## Spike Results

Questions answered:
- [x] Can it work? → YES, validated

New questions revealed:
- [ ] How to handle scale? → Add to research topics
```

**Source:** Spike workflow documentation (workflow.mdc)

**Relevance:** Defines I/O for the new spike workflow

---

## 🔍 Analysis

### Workflow Chain Integrity

The current workflow chain has a clear pattern:
1. Each workflow produces a **handoff file** (summary, topics list, etc.)
2. The next workflow reads this handoff file via `--from-*` flag
3. Validation ensures the chain doesn't break

### Validation Strategy Decision

**Recommended approach: L1 Hard Fail + L2/L3 Warn**

- **Why not all hard fails?** Users may want to run workflows incrementally
- **Why not all soft warnings?** Silent failures lead to confusion
- **Sweet spot:** Block on missing files, warn on incomplete content

### Output Format Standardization

All handoff files should:
1. Use consistent section headers (machine-parseable)
2. Include a status table with structured data
3. Provide a "Next Steps" section pointing to the next workflow

---

## 💡 Recommendations

- [x] **R1:** Implement L1/L2/L3 validation levels in dt-workflow
- [x] **R2:** Standardize handoff files with consistent headers
- [x] **R3:** Add `--validate` flag to check inputs without running workflow
- [x] **R4:** Auto-detect topic and handoff files when possible
- [x] **R5:** Include "Next Steps" section in all outputs pointing to next workflow

---

## 📋 Requirements Discovered

### Functional Requirements

- [x] **REQ-IO-1:** dt-workflow must validate required inputs exist before proceeding (L1)
- [x] **REQ-IO-2:** dt-workflow must warn on missing optional content (L2/L3)
- [x] **REQ-IO-3:** Each workflow must produce standardized handoff file
- [x] **REQ-IO-4:** `--from-*` flags must accept explicit paths or auto-detect
- [x] **REQ-IO-5:** Add `--validate` flag to check inputs without execution
- [x] **REQ-IO-6:** All outputs must include "Next Steps" section

### Non-Functional Requirements

- [x] **REQ-IO-7:** Validation must complete in under 500ms
- [x] **REQ-IO-8:** Error messages must suggest corrective action

### Data Contract

| Workflow | Handoff File | Required Sections |
|----------|--------------|-------------------|
| explore | `research-topics.md` | ## Topics table |
| spike | `spike-learnings.md` | ## Questions Answered, ## New Questions |
| research | `research-summary.md` | ## Key Findings, ## Recommendations |
| decision | `decisions-summary.md` | ## Decisions table |
| transition | `feature-plan.md` | ## Phases table |

---

## 🚀 Next Steps

1. ✅ Research complete
2. Implement validation levels in dt-workflow
3. Standardize handoff file templates
4. Add `--validate` flag
5. Proceed to decision phase

---

## 🔗 Related

- [Context Gathering Research](research-context-gathering.md) - What context to include
- [Decision Propagation Research](research-decision-propagation.md) - How decisions flow
- [Current Commands](.cursor/commands/) - Existing implementations

---

**Last Updated:** 2026-01-23
