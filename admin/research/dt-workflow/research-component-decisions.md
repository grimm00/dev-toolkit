# Research: Component Decisions

**Research Topic:** dt-workflow  
**Question:** What happens to dt-doc-validate and dt-doc-gen?  
**Status:** 🔴 Research  
**Priority:** 🟠 HIGH  
**Created:** 2026-01-23  
**Last Updated:** 2026-01-23

---

## 🎯 Research Question

With dt-workflow as unified orchestrator, what role do existing components play?

**Topic 3:** Should dt-doc-validate remain standalone?  
**Topic 4:** Should dt-doc-gen become internal to dt-workflow?

---

## 🔍 Research Goals

- [ ] Goal 1: Validate CI/automation use case for standalone validation
- [ ] Goal 2: Confirm dt-doc-gen has no standalone value
- [ ] Goal 3: Design library vs CLI architecture
- [ ] Goal 4: Plan migration/deprecation path

---

## 📚 Research Methodology

**Sources:**
- [ ] Current usage patterns (how are these tools used today?)
- [ ] CI integration requirements
- [ ] Library export feasibility
- [ ] User feedback on standalone tools

---

## 📊 Findings

### Finding 1: dt-doc-validate Standalone Value

**From exploration analysis:**

| Use Case | Frequency | Standalone Required? |
|----------|-----------|---------------------|
| CI pipeline validation | High | ✅ Yes - runs without user |
| Pre-commit hooks | High | ✅ Yes - automated |
| Manual document checking | Medium | Helpful but not required |
| Post-generation validation | High | Can be internal |

**Conclusion from exploration:** dt-doc-validate has clear standalone value for CI/automation.

**Source:** Exploration Theme 2 analysis

**Relevance:** Strong argument for keeping standalone

---

### Finding 2: dt-doc-gen Standalone Value

**From exploration analysis:**

| Use Case | Frequency | Standalone Required? |
|----------|-----------|---------------------|
| Generate for AI fill | High | ❌ No - always followed by AI |
| Generate for human fill | Low | Rare use case |
| Template testing | Low | Could use test harness |
| Structure preview | Medium | Could be dt-workflow flag |

**Conclusion from exploration:** dt-doc-gen has minimal standalone value.

**Source:** Exploration Theme 2 analysis

**Relevance:** Strong argument for internalizing

---

### Finding 3: Architecture Options

**Option 1: Both standalone (current)**
- Pros: Maximum flexibility, already built
- Cons: No unified experience

**Option 2: Validate standalone, gen internal (recommended)**
- Pros: CI keeps working, gen becomes internal detail
- Cons: dt-doc-gen CLI deprecated
- Pattern: `dt-doc-validate` in bin/, `lib/doc-gen/` as library

**Option 3: Both internal**
- Pros: Simplest architecture
- Cons: Loses CI validation capability

**Source:** Exploration analysis

**Relevance:** Option 2 appears optimal

---

## 🔍 Analysis

The exploration analysis is quite clear:

1. **dt-doc-validate** has real standalone value (CI, pre-commit)
2. **dt-doc-gen** has no compelling standalone use case
3. **Hybrid approach** (validate standalone, gen internal) is optimal

**Key Insights:**
- [x] Insight 1: CI integration is a real use case that justifies standalone validation
- [x] Insight 2: Document generation is always part of a workflow, never standalone
- [ ] Insight 3: [Verify with actual usage data if available]

---

## 💡 Recommendations

**Based on exploration analysis (pending validation):**

- [x] Recommendation 1: Keep dt-doc-validate as standalone CLI for CI/automation
- [x] Recommendation 2: Internalize dt-doc-gen as lib/doc-gen/ library
- [ ] Recommendation 3: dt-workflow uses internal library, not CLI

---

## 📋 Requirements Discovered

- [ ] REQ-CD-1: dt-doc-validate must remain callable from CI pipelines
- [ ] REQ-CD-2: dt-doc-validate must support pre-commit hook usage
- [ ] REQ-CD-3: dt-workflow must use internal doc-gen library
- [ ] REQ-CD-4: Migration path needed for dt-doc-gen CLI users (if any)

---

## 🚀 Next Steps

1. Verify exploration analysis with actual usage data
2. Confirm no critical dt-doc-gen standalone use cases
3. If analysis holds, this can move to quick decision
4. Design library interface for doc-gen

---

## 📝 Notes

**This topic may be a quick decision rather than deep research.**

The exploration analysis is already thorough. Research should focus on validating assumptions rather than re-analyzing from scratch.

---

**Last Updated:** 2026-01-23
