# Research: Document Type Detection

**Research Topic:** Doc Infrastructure  
**Question:** Should validation auto-detect document type from path/content, or require explicit `--type` flag?  
**Status:** 🔴 Research  
**Priority:** 🟡 Medium  
**Created:** 2026-01-16  
**Last Updated:** 2026-01-16

---

## 🎯 Research Question

Should dt-doc-validate auto-detect document type from path/content, or require explicit `--type` flag? VALIDATION.md describes both path-based detection (`admin/explorations/` → exploration) and content-based detection (`# ADR-001:` → adr).

---

## 🔍 Research Goals

- [ ] Goal 1: Map all path patterns from VALIDATION.md
- [ ] Goal 2: Map all content patterns (title formats, section headers)
- [ ] Goal 3: Define detection priority (path first, content fallback)
- [ ] Goal 4: Document cases where `--type` is required
- [ ] Goal 5: Test detection against real documents

---

## 📚 Research Methodology

**Note:** Web search is **allowed and encouraged** for research.

**Sources:**
- [ ] Source 1: VALIDATION.md type detection specifications
- [ ] Source 2: Real documents in dev-infra and dev-toolkit
- [ ] Source 3: Web search: CLI type detection patterns
- [ ] Source 4: Similar validation tools (markdownlint, etc.)

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

1. Conduct research
2. Document findings with sources
3. Update requirements.md with discovered requirements

---

**Last Updated:** 2026-01-16
