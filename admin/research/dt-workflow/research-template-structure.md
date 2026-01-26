# Research: Template Structure for Workflow Documents

**Research Topic:** dt-workflow  
**Question:** What template structure best supports AI-assisted document generation?  
**Status:** 🔴 Not Started  
**Created:** 2026-01-22  
**Last Updated:** 2026-01-22

---

## 🎯 Research Question

What is the optimal template structure for workflow documents (exploration, research, decision) that:
1. Provides consistent structure across all workflows
2. Enables effective AI content generation
3. Balances minimal skeleton vs. detailed structure
4. Can be maintained as a single source of truth in dev-infra

---

## 🔍 Research Goals

- [ ] Goal 1: Understand trade-offs between minimal templates + AI fill vs. detailed templates
- [ ] Goal 2: Identify best practices for AI-fillable template placeholders
- [ ] Goal 3: Determine which sections are essential vs. optional per workflow
- [ ] Goal 4: Evaluate current dev-infra templates against spike-generated structures
- [ ] Goal 5: Recommend template philosophy for dev-toolkit → dev-infra

---

## 📚 Research Methodology

**Note:** Web search is **allowed and encouraged** for research. Use web search tools to find current information, best practices, documentation, examples, and real-world implementations.

**Sources to Investigate:**

- [ ] Current dev-infra templates (17 .tmpl files)
- [ ] dt-workflow spike heredocs (what structure works in practice)
- [ ] AI prompt engineering best practices for structured output
- [ ] Template systems (Jinja, Handlebars, mustache) design patterns
- [ ] Documentation generators (MkDocs, Docusaurus) template approaches
- [ ] Web search: AI-assisted document generation patterns

---

## 📊 Current State Analysis

### Dev-Infra Templates (Current)

| Category | Files | Approach |
|----------|-------|----------|
| exploration | 3 | Minimal + AI placeholders |
| research | 4 | Minimal + AI placeholders |
| decision | 3 | Minimal + AI placeholders |
| planning | 4 | Minimal + AI placeholders |
| other | 3 | Minimal + AI placeholders |

**Placeholder Types:**
- `<!-- AI: [instruction] -->` - AI should fill this
- `<!-- EXPAND: [instruction] -->` - AI should expand with detail
- `${VARIABLE}` - envsubst variable expansion

### Spike Heredocs (What Works)

The spike uses detailed heredocs with:
- Full section structure
- Example content patterns
- Placeholder text showing expected format
- More sections than templates

**Gap Identified:**
- Spike has ~70 lines for exploration.md
- Template has ~44 lines with AI placeholders
- Spike includes sections templates lack (Themes Analyzed table, Initial Recommendations)

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

1. Conduct web research on AI document generation patterns
2. Compare template philosophies
3. Make recommendation for dt-toolkit → dev-infra

---

**Last Updated:** 2026-01-22
