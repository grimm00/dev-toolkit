# Research: Decision Propagation Patterns

**Research Topic:** dt-workflow  
**Question:** How do decisions made here inform future work on remaining and new workflows?  
**Status:** 🔴 Research  
**Priority:** 🔴 HIGH  
**Created:** 2026-01-23  
**Last Updated:** 2026-01-23

---

## 🎯 Research Question

Decisions made during dt-workflow development should establish patterns that apply to all workflows. How do we capture, document, and propagate these decisions?

**Primary Questions:**
1. What decisions are "workflow-universal" vs "workflow-specific"?
2. Where should universal patterns be documented?
3. How do we ensure future workflows follow established patterns?
4. How do we update patterns when we learn better approaches?

---

## 🔍 Research Goals

- [ ] Goal 1: Identify decisions from this exploration that apply universally
- [ ] Goal 2: Design pattern documentation location/format
- [ ] Goal 3: Define process for propagating decisions to other workflows
- [ ] Goal 4: Design pattern evolution/update process

---

## 📚 Research Methodology

**Sources:**
- [ ] Decisions made in this exploration (spike, context gathering, etc.)
- [ ] Existing pattern documentation (Cursor rules, workflow.mdc)
- [ ] ADR patterns in dev-infra
- [ ] Web search: Pattern documentation best practices

---

## 📊 Findings

### Finding 1: Decisions Made in This Exploration

**Universal patterns identified:**

| Decision | Applies To | Should Propagate? |
|----------|------------|-------------------|
| Spike determination | All explorations | ✅ Yes |
| Explicit context injection | All workflows | ✅ Yes |
| Phase 1 --interactive pattern | All dt-* tools | ✅ Yes |
| Unified command architecture | New dt-* tools | ✅ Yes |
| Content vs pointers trade-off | Context-heavy workflows | ✅ Yes |

**Workflow-specific decisions:**

| Decision | Specific To | Don't Propagate |
|----------|-------------|-----------------|
| explore template structure | /explore only | Workflow-specific |
| exploration themes format | /explore only | Workflow-specific |

**Source:** This exploration

**Relevance:** Identifies what needs to be propagated

---

### Finding 2: Current Pattern Documentation Locations

| Location | Content | Audience |
|----------|---------|----------|
| `.cursor/rules/workflow.mdc` | Git Flow, PR workflow | AI assistants |
| `.cursor/rules/main.mdc` | Project identity, structure | AI assistants |
| `admin/explorations/*/` | Exploration-specific patterns | Developers |
| ADRs | Architectural decisions | All |

**Gap identified:** No centralized "universal workflow patterns" document.

**Source:** Project structure analysis

**Relevance:** Need to identify or create propagation location

---

### Finding 3: Pattern Propagation Options

**Option A: Update Cursor Rules**
- Add universal patterns to `.cursor/rules/workflow.mdc`
- Pros: AI sees patterns automatically
- Cons: Rules files getting large

**Option B: Create Patterns Document**
- New `docs/workflow-patterns.md` or `admin/patterns/`
- Pros: Centralized, discoverable
- Cons: Another document to maintain

**Option C: ADRs for Each Pattern**
- Create ADR for each universal pattern
- Pros: Formal, tracked, rationale captured
- Cons: May be overkill for some patterns

**Option D: Template Integration**
- Bake patterns into workflow templates
- Pros: Patterns enforced by structure
- Cons: Less visible, harder to update

**Source:** Analysis

**Relevance:** Need to choose propagation mechanism

---

### Finding 4: Patterns Discovered in This Session

**Spike Determination Pattern:**
```
After identifying research topics, ask:
1. Which decisions have high pivot cost?
2. Which need to be "felt" rather than analyzed?
3. Can prototyping answer what research might not?
```

**Context Injection Pattern:**
```
Explicit > Implicit for user trust
Universal context always injected
Workflow-specific context as needed
```

**Phase-Based Evolution Pattern:**
```
Phase 1: Interactive (current limitations)
Phase 2: Config-assisted
Phase 3: Fully automated
```

**Source:** This exploration

**Relevance:** Concrete patterns to propagate

---

## 🔍 Analysis

[Analysis of findings - to be completed during research]

**Key Insights:**
- [x] Insight 1: Multiple universal patterns emerged from this exploration
- [ ] Insight 2: Need to decide propagation mechanism
- [ ] Insight 3: [To be determined]

---

## 💡 Recommendations

- [ ] Recommendation 1: Choose pattern documentation location
- [ ] Recommendation 2: Document spike determination pattern
- [ ] Recommendation 3: Document context injection pattern
- [ ] Recommendation 4: Create process for pattern evolution

---

## 📋 Requirements Discovered

- [ ] REQ-DP-1: Universal patterns must be documented in discoverable location
- [ ] REQ-DP-2: New workflows must check for applicable patterns
- [ ] REQ-DP-3: Pattern updates must be communicated to dependent workflows
- [ ] REQ-DP-4: Patterns must include rationale (why, not just what)

---

## 🚀 Next Steps

1. Choose pattern documentation mechanism
2. Document patterns from this exploration
3. Define pattern discovery process for new workflows
4. Add pattern check to exploration workflow

---

## 🔗 Related

- [Exploration: dt-workflow](../../explorations/dt-workflow/) - Source of patterns
- [Cursor Rules](../../../.cursor/rules/) - Current pattern location
- [ADR Process](../../decisions/) - Formal decision documentation

---

**Last Updated:** 2026-01-23
