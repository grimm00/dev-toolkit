# Research: Command Workflow Integration

**Research Topic:** Doc Infrastructure  
**Question:** How will Cursor commands invoke dt-doc-gen and dt-doc-validate?  
**Status:** 🔴 Research  
**Priority:** 🔴 High (Blocking)  
**Created:** 2026-01-16  
**Last Updated:** 2026-01-16

---

## 🎯 Research Question

How will Cursor commands (`/explore`, `/research`, `/decision`, etc.) invoke dt-doc-gen and dt-doc-validate? Dev-infra research established that commands should invoke scripts for structure generation while AI fills content. This creates a three-layer architecture: Library → CLI → Command Integration.

---

## 🔍 Research Goals

- [ ] Goal 1: Review dev-infra research-command-integration.md findings
- [ ] Goal 2: Design command invocation patterns for dev-toolkit context
- [ ] Goal 3: Define migration order (start with `/explore`, `/research` per R7)
- [ ] Goal 4: Document how two-mode commands (setup/conduct) map to dt-doc-gen modes
- [ ] Goal 5: Plan integration testing strategy

---

## 📚 Research Methodology

**Note:** Web search is **allowed and encouraged** for research.

**Sources:**
- [ ] Source 1: dev-infra research-command-integration.md (prior research)
- [ ] Source 2: Cursor command definitions in `.cursor/commands/`
- [ ] Source 3: dev-infra requirements.md (FR-26, FR-27, C-13)
- [ ] Source 4: Existing dev-toolkit command patterns

---

## 📊 Prior Research Summary (dev-infra)

The following was established in dev-infra research:

### Integration Architecture

```
Command (orchestrator)
    │
    ├─→ dt-doc-gen (structure, 0 AI tokens)
    │
    ├─→ AI (content, targeted tokens)
    │
    └─→ dt-doc-validate (verify before commit)
```

### Key Requirements

| ID | Requirement |
|----|-------------|
| FR-26 | Commands invoke `dt-doc-gen` for structure |
| FR-27 | Commands invoke `dt-doc-validate` before commit |
| FR-28 | Three placeholder types: `${VAR}`, `<!-- AI: -->`, `<!-- EXPAND: -->` |
| FR-30 | Migration is incremental, one command at a time |
| C-13 | Commands remain orchestrators; scripts are tools |

### Command-to-DocType Mapping

| Command | Doc Types | Mode Pattern |
|---------|-----------|--------------|
| `/explore` | exploration.md, research-topics.md, README.md | Two-mode |
| `/research` | research-*.md, requirements.md | Two-mode |
| `/decision` | adr-NNN.md, decisions-summary.md | Single |
| `/transition-plan` | feature-plan.md, phase-N.md | Single |
| `/handoff` | handoff.md | Single |
| `/fix-plan` | fix-batch-N.md | Single |

---

## 📊 Findings

### Finding 1: [Title]

[Description of finding]

**Source:** [Source reference]

**Relevance:** [Why this finding matters]

---

### Finding 2: [Title]

[Description of finding]

**Source:** [Source reference]

**Relevance:** [Why this finding matters]

---

## 🔍 Analysis

[Analysis of findings]

**Key Insights:**
- [ ] Insight 1: [Description]
- [ ] Insight 2: [Description]

---

## 💡 Recommendations

- [ ] Recommendation 1: [Description]
- [ ] Recommendation 2: [Description]

---

## 📋 Requirements Discovered

[Any requirements discovered during this research]

- [ ] Requirement 1: [Description]
- [ ] Requirement 2: [Description]

---

## 🚀 Next Steps

1. Analyze Cursor command patterns
2. Design invocation patterns
3. Update requirements.md with discovered requirements

---

**Last Updated:** 2026-01-16
