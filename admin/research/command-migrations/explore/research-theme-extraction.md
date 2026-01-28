# Research: Theme Extraction Location

**Research Topic:** /explore Command Migration  
**Question:** Should AI-powered theme extraction be in dt-doc-gen or the command wrapper?  
**Status:** 🔴 Research  
**Priority:** 🟠 Medium  
**Created:** 2026-01-22  
**Last Updated:** 2026-01-22

---

## 🎯 Research Question

The /explore command transforms unstructured input into themes and questions using AI. Where does this intelligence live post-migration?

**Why Medium Priority:** Important for architecture clarity, but likely answer is "command wrapper" since dt-doc-gen is a CLI tool.

---

## 🔍 Research Goals

- [ ] Goal 1: Map current /explore data flow (input → themes → output)
- [ ] Goal 2: Identify where AI work happens today
- [ ] Goal 3: Confirm dt-doc-gen receives pre-extracted variables
- [ ] Goal 4: Document handoff points between Cursor and dt-doc-gen

---

## 📚 Research Methodology

**Sources:**

- [ ] /explore command implementation (`.cursor/commands/explore.md`)
- [ ] dt-doc-gen variable passing mechanism
- [ ] Separation of concerns analysis

---

## 📊 Findings

### Finding 1: Current /explore Data Flow

<!-- PLACEHOLDER: Map the data flow -->

**Input sources:**
- Raw text (`--input`)
- start.txt (`--from-start`)
- Reflection files (`--from-reflect`)
- Topic name (interactive)

**Processing steps:**
1. Input received
2. [Where does AI extract themes?]
3. [Where are questions identified?]
4. Templates populated
5. Output written

**Source:** [/explore command documentation]

**Relevance:** Defines current architecture

---

### Finding 2: AI Work Boundaries

<!-- PLACEHOLDER: Document where AI work happens -->

**AI responsibilities:**
- [ ] Theme extraction from unstructured input
- [ ] Question identification
- [ ] Content expansion (Conduct Mode)
- [ ] Scaffolding generation

**Non-AI responsibilities:**
- [ ] File creation
- [ ] Variable substitution
- [ ] Validation

**Source:** [/explore command, Cursor capabilities]

**Relevance:** Defines what moves to dt-doc-gen vs stays in Cursor

---

### Finding 3: Variable Handoff

<!-- PLACEHOLDER: Document how variables pass from Cursor to dt-doc-gen -->

**Variables that Cursor extracts:**
- THEMES (array of theme objects)
- QUESTIONS (array of question objects)
- TOPIC_NAME
- DATE
- STATUS

**How dt-doc-gen receives variables:**
- [ ] Environment variables
- [ ] Command-line arguments
- [ ] Stdin?

**Array handling:**
- [ ] Can dt-doc-gen handle arrays?
- [ ] How would themes iterate in template?

**Source:** [dt-doc-gen implementation]

**Relevance:** Defines integration complexity

---

## 🔍 Analysis

<!-- PLACEHOLDER: Analysis after findings collected -->

**Architecture recommendation:**

```
┌─────────────────────────────────────────┐
│ Cursor Command (/explore)               │
│ - Receives unstructured input           │
│ - AI extracts themes, questions         │
│ - Prepares variables                    │
│ - Calls dt-doc-gen with variables       │
└────────────────┬────────────────────────┘
                 │ Variables
                 ▼
┌─────────────────────────────────────────┐
│ dt-doc-gen                              │
│ - Fetches template                      │
│ - Substitutes variables                 │
│ - Outputs document                      │
└─────────────────────────────────────────┘
```

**Key Insights:**
- [ ] Insight 1: [Description]
- [ ] Insight 2: [Description]

---

## 💡 Recommendations

**Recommended architecture:** [TBD - likely "AI stays in Cursor, dt-doc-gen just formats"]

**Rationale:** [TBD]

---

## 📋 Requirements Discovered

- [ ] REQ-1: [Description]
- [ ] REQ-2: [Description]

---

## 🚀 Next Steps

1. Confirm expected architecture
2. Document variable passing mechanism
3. Ensure dt-doc-gen can handle theme/question arrays

---

**Last Updated:** 2026-01-22
