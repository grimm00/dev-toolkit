# Research: Template Fetching Strategy

**Research Topic:** Doc Infrastructure  
**Question:** How should dt-doc-gen locate and fetch templates from dev-infra?  
**Status:** 🔴 Research  
**Priority:** 🔴 High (Blocking)  
**Created:** 2026-01-16  
**Last Updated:** 2026-01-16

---

## 🎯 Research Question

How should dt-doc-gen locate and fetch templates from dev-infra? The 17 templates live in dev-infra's `scripts/doc-gen/templates/` directory. dt-doc-gen needs to access these templates but shouldn't require dev-infra to be cloned in a specific location.

---

## 🔍 Research Goals

- [ ] Goal 1: Document template source options (local path, bundled, GitHub fetch)
- [ ] Goal 2: Evaluate trade-offs: simplicity vs flexibility vs maintenance
- [ ] Goal 3: Prototype environment variable approach (`$DT_TEMPLATES_PATH`)
- [ ] Goal 4: Consider version pinning strategy if fetching remotely
- [ ] Goal 5: Define recommended approach for dev-toolkit implementation

---

## 📚 Research Methodology

**Note:** Web search is **allowed and encouraged** for research.

**Sources:**
- [ ] Source 1: Review how similar CLI tools handle external templates (cookiecutter, yeoman, etc.)
- [ ] Source 2: Analyze dev-infra template structure and dependencies
- [ ] Source 3: Review dev-toolkit installation patterns (install.sh, dev-setup.sh)
- [ ] Source 4: Web search: Template location strategies in CLI tools

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

1. Conduct research using web search and source analysis
2. Document findings with sources
3. Update requirements.md with discovered requirements

---

**Last Updated:** 2026-01-16
