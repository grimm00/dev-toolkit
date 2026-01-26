# Research: Workflow Input/Output Specifications

**Research Topic:** dt-workflow  
**Question:** What inputs does each workflow need, and how should outputs prepare for the next workflow?  
**Status:** 🔴 Research  
**Priority:** 🔴 HIGH  
**Created:** 2026-01-23  
**Last Updated:** 2026-01-23

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

- [ ] Goal 1: Document input requirements for each workflow type
- [ ] Goal 2: Document output specifications for each workflow type
- [ ] Goal 3: Design input validation strategy
- [ ] Goal 4: Design output format for workflow chaining
- [ ] Goal 5: Define `--from-*` flag specifications

---

## 📚 Research Methodology

**Sources:**
- [ ] Current command implementations (explore, research, decision)
- [ ] Existing `--from-explore`, `--from-research` patterns
- [ ] Exploration/research document structures
- [ ] Web search: Workflow orchestration input/output patterns

---

## 📊 Findings

### Finding 1: Current Workflow Chain

**Observed pattern:**
```
/explore [topic]
    → Creates: exploration.md, research-topics.md, README.md
    → Output enables: /research --from-explore

/research [topic] --from-explore [topic]
    → Reads: exploration's research-topics.md
    → Creates: research-*.md, requirements.md, research-summary.md
    → Output enables: /decision --from-research

/decision [topic] --from-research
    → Reads: research-summary.md, requirements.md
    → Creates: ADRs, transition-plan.md
    → Output enables: /transition-plan --from-adr
```

**Source:** Current command implementations

**Relevance:** Establishes existing pattern to formalize

---

### Finding 2: Input Requirements (Draft)

| Workflow | Required Inputs | Optional Inputs |
|----------|-----------------|-----------------|
| explore | topic name | related explorations |
| research | exploration (research-topics.md) | external sources |
| decision | research (summary, requirements) | constraints |
| transition | ADR documents | timeline preferences |

**Source:** [To be validated]

**Relevance:** Defines what dt-workflow must check before proceeding

---

### Finding 3: Output Specifications (Draft)

| Workflow | Required Outputs | Format |
|----------|------------------|--------|
| explore | README.md (hub), exploration.md, research-topics.md | Standard templates |
| research | README.md, research-*.md, requirements.md, summary.md | Standard templates |
| decision | ADR documents, decisions-summary.md | ADR format |
| transition | feature-plan.md, phase-*.md | Planning templates |

**Source:** [To be validated]

**Relevance:** Defines what dt-workflow must produce

---

### Finding 4: Input Validation Strategy

<!-- TODO: Research how to validate inputs exist and are valid -->

**Questions:**
- Should dt-workflow fail if required inputs missing?
- Should it prompt for missing inputs?
- Should it create placeholder inputs?

**Source:** [To be researched]

**Relevance:** Error handling design

---

## 🔍 Analysis

[Analysis of findings - to be completed during research]

**Key Insights:**
- [ ] Insight 1: [To be determined]
- [ ] Insight 2: [To be determined]

---

## 💡 Recommendations

- [ ] Recommendation 1: [To be determined]
- [ ] Recommendation 2: [To be determined]

---

## 📋 Requirements Discovered

- [ ] REQ-IO-1: Each workflow must validate required inputs before proceeding
- [ ] REQ-IO-2: Each workflow must produce standardized outputs
- [ ] REQ-IO-3: Outputs must be machine-parseable for chaining
- [ ] REQ-IO-4: `--from-*` flags must specify input source clearly

---

## 🚀 Next Steps

1. Document all current workflow input/output patterns
2. Identify gaps in current handoff process
3. Design standardized input validation
4. Design output format specifications
5. Update dt-workflow to enforce specs

---

## 🔗 Related

- [Context Gathering Research](research-context-gathering.md) - Related: what context to include
- [Current Commands](.cursor/commands/) - Existing implementations
- [dev-infra: Command Integration](/Users/cdwilson/Projects/dev-infra/admin/research/template-doc-infrastructure/research-command-integration.md)

---

**Last Updated:** 2026-01-23
