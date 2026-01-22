# Research: Cross-Project Coordination Model

**Research Topic:** /explore Command Migration  
**Question:** How should dev-toolkit and dev-infra coordinate on template changes?  
**Status:** 🔴 Research  
**Priority:** 🟠 Medium  
**Created:** 2026-01-22  
**Last Updated:** 2026-01-22

---

## 🎯 Research Question

Migrations may require template changes in dev-infra. How do we manage cross-project coordination without killing velocity?

**Why Medium Priority:** Coordination friction could slow everything down. Need clear pattern, but depends on gap analysis findings.

---

## 🔍 Research Goals

- [ ] Goal 1: Review iteration plan's coordination recommendation
- [ ] Goal 2: Evaluate coordination models (PR per change vs PR per sprint vs fork)
- [ ] Goal 3: Consider if dev-toolkit should own its own templates
- [ ] Goal 4: Recommend coordination pattern

---

## 📚 Research Methodology

**Sources:**

- [ ] Iteration plan recommendations
- [ ] Gap analysis findings (dependencies)
- [ ] Web search: Multi-repo coordination patterns
- [ ] Similar project experiences

---

## 📊 Findings

### Finding 1: Iteration Plan Recommendation

<!-- PLACEHOLDER: Document what iteration plan says -->

**Coordination approach suggested:**
- [ ] PR batching strategy
- [ ] Timing recommendations
- [ ] Ownership model

**Source:** [admin/research/doc-infrastructure/iteration-plan.md]

**Relevance:** Existing recommendation to evaluate

---

### Finding 2: Coordination Model Options

<!-- PLACEHOLDER: Evaluate each model -->

**Option 1: PR per change**
- Every small change = dev-infra PR
- Pros: [List]
- Cons: [High friction, slow iteration]

---

**Option 2: PR per sprint**
- Batch all changes for one command migration
- Pros: [Balanced, manageable scope]
- Cons: [List]

---

**Option 3: PR per feature (all migrations)**
- One large dev-infra PR for all command migrations
- Pros: [Efficient, single review]
- Cons: [Large scope, delayed feedback]

---

**Option 4: Fork/override**
- dev-toolkit owns its own templates
- No coordination needed
- Pros: [Maximum velocity, independence]
- Cons: [Drift, duplication, no shared benefit]

**Source:** [Analysis]

**Relevance:** Defines coordination pattern

---

### Finding 3: Gap Analysis Dependencies

<!-- PLACEHOLDER: Link to gap analysis findings -->

**Changes likely needed in dev-infra:**
- [ ] Based on gap analysis
- [ ] How many changes?
- [ ] How significant?

**Changes that could be local overrides:**
- [ ] Minor adjustments
- [ ] dev-toolkit specific needs

**Source:** [research-template-gap-analysis.md]

**Relevance:** Determines coordination need

---

## 🔍 Analysis

<!-- PLACEHOLDER: Analysis after findings collected -->

**Decision factors:**

| Factor | Weight | Favors |
|--------|--------|--------|
| Velocity | High | Fork/override |
| Consistency | Medium | Shared templates |
| Maintenance | Medium | Shared templates |
| Flexibility | High | Fork/override |

**Key Insights:**
- [ ] Insight 1: [Description]
- [ ] Insight 2: [Description]

---

## 💡 Recommendations

**Recommended model:** [TBD]

**Rationale:** [TBD]

**Guidelines:**
- When to PR to dev-infra: [TBD]
- When to use local override: [TBD]

---

## 📋 Requirements Discovered

- [ ] REQ-1: [Description]
- [ ] REQ-2: [Description]

---

## 🚀 Next Steps

1. Wait for gap analysis results
2. Assess scope of needed changes
3. Recommend coordination model based on actual needs

---

**Last Updated:** 2026-01-22
