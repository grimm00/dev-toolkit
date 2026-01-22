# Research: Template Inspection & Gap Analysis

**Research Topic:** /explore Command Migration  
**Question:** What's the actual structure of dev-infra exploration templates, and what gaps exist?  
**Status:** 🔴 Research  
**Priority:** 🔴 BLOCKING  
**Created:** 2026-01-22  
**Last Updated:** 2026-01-22

---

## 🎯 Research Question

This research combines Topics 2 and 6 from the exploration:
1. What's the actual structure of dev-infra exploration templates?
2. What variables does /explore need that dev-infra templates don't provide?

**Why BLOCKING:** Can't make any migration decisions without knowing what dev-infra templates actually contain.

---

## 🔍 Research Goals

- [ ] Goal 1: Document dev-infra exploration template structure (files, sections, variables)
- [ ] Goal 2: Document /explore inline template structure (from `.cursor/commands/explore.md`)
- [ ] Goal 3: Create comparison matrix of Expected vs Available
- [ ] Goal 4: List gaps and proposed solutions

---

## 📚 Research Methodology

**Sources:**

- [ ] Dev-infra repository: `scripts/doc-gen/templates/exploration/`
- [ ] Dev-toolkit Cursor command: `.cursor/commands/explore.md`
- [ ] dt-doc-gen implementation: Phase 2 documentation

**Note:** Web search may help for template pattern best practices, but primary research is reading actual files.

---

## 📊 Findings

### Finding 1: Dev-Infra Template Structure

<!-- PLACEHOLDER: Document actual dev-infra template structure -->

**Files found:**
- [ ] List template files

**Variables expected:**
- [ ] List variables

**Section structure:**
- [ ] Document sections

**AI markers:**
- [ ] Check for `<!-- AI: -->`, `<!-- EXPAND: -->` markers

**Source:** [Dev-infra exploration templates]

**Relevance:** Foundation for all migration decisions

---

### Finding 2: /explore Inline Template Structure

<!-- PLACEHOLDER: Document inline template structure from explore.md -->

**Setup Mode output:**
- [ ] Document structure (~60-80 lines)

**Conduct Mode output:**
- [ ] Document structure (~200-300 lines)

**Variables used:**
- [ ] List variables

**Placeholders/markers:**
- [ ] Document placeholder pattern

**Source:** [`.cursor/commands/explore.md`]

**Relevance:** Defines what templates must produce

---

### Finding 3: Gap Analysis Matrix

<!-- PLACEHOLDER: Create comparison matrix -->

| Element | /explore Needs | Dev-Infra Has | Gap? |
|---------|----------------|---------------|------|
| README.md | Yes | ? | ? |
| exploration.md | Yes | ? | ? |
| research-topics.md | Yes | ? | ? |
| TOPIC_NAME var | Yes | ? | ? |
| TOPIC_TITLE var | Yes | ? | ? |
| DATE var | Yes | ? | ? |
| STATUS var | Yes | ? | ? |
| THEMES var (array) | Yes | ? | ? |
| QUESTIONS var (array) | Yes | ? | ? |
| Mode support | Yes (Setup/Conduct) | ? | ? |
| AI markers | Yes (`<!-- PLACEHOLDER: -->`) | ? | ? |

**Source:** [Comparison of above findings]

**Relevance:** Defines migration scope

---

## 🔍 Analysis

<!-- PLACEHOLDER: Analysis after findings collected -->

**Key Insights:**
- [ ] Insight 1: [Description]
- [ ] Insight 2: [Description]

---

## 💡 Recommendations

- [ ] Recommendation 1: [Description]
- [ ] Recommendation 2: [Description]

---

## 📋 Requirements Discovered

- [ ] REQ-1: [Description]
- [ ] REQ-2: [Description]

---

## 🚀 Next Steps

1. Read dev-infra exploration templates
2. Document /explore inline templates
3. Complete gap analysis matrix
4. Proceed to Migration Value Assessment with findings

---

**Last Updated:** 2026-01-22
