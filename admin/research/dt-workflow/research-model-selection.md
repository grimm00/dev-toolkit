# Research: Model Selection Integration

**Research Topic:** dt-workflow  
**Question:** How does model selection integrate with dt-workflow?  
**Status:** 🔴 Research  
**Priority:** 🟡 MEDIUM  
**Created:** 2026-01-23  
**Last Updated:** 2026-01-23

---

## 🎯 Research Question

dev-infra research established task-type-to-model mapping. How should dt-workflow integrate with model selection?

**From dev-infra research:**
```yaml
task_models:
  explore: claude-opus-4       # Deep thinking
  research: claude-opus-4      # Analysis
  decision: claude-opus-4      # Judgment
  naming: gemini-2.5-pro       # Creative
  pr: claude-sonnet-4          # Structured
  task-phase: composer-1       # Implementation
```

---

## 🔍 Research Goals

- [ ] Goal 1: Design config file format for model selection
- [ ] Goal 2: Determine Phase 1 vs Phase 3 integration
- [ ] Goal 3: Research Aider/LLM CLI model selection patterns
- [ ] Goal 4: Decide per-project vs global config

---

## 📚 Research Methodology

**Sources:**
- [ ] dev-infra research on model selection
- [ ] Aider model selection implementation
- [ ] LLM CLI tool patterns
- [ ] Web search: AI tool model configuration

---

## 📊 Findings

### Finding 1: Phase-Based Integration

**From exploration Theme 6:**

| Phase | Model Selection |
|-------|-----------------|
| Phase 1 (Now) | Informational - recommend model, user selects manually |
| Phase 2 (Near) | Config-based - read models.yaml, suggest model |
| Phase 3 (Future) | Automatic - dt-workflow invokes with correct model |

**Source:** Exploration Theme 6

**Relevance:** Defines implementation timeline

---

### Finding 2: Integration Options

**Option A: Built-in to dt-workflow**
```bash
dt-workflow explore topic  # Uses claude-opus-4 automatically
```
- Pros: Single tool handles everything
- Cons: Couples model selection to workflow

**Option B: Separate tool**
```bash
model=$(dt-model-select explore)
dt-workflow explore topic --model $model
```
- Pros: Separation of concerns
- Cons: Extra tool

**Option C: Config only (recommended for Phase 1)**
```bash
dt-workflow explore topic --interactive
# Output includes: "Recommended model: claude-opus-4"
```
- Pros: Works now, no AI invocation needed
- Cons: Not automated

**Source:** Exploration Theme 6

**Relevance:** Option C for Phase 1, evolve to Option A

---

### Finding 3: [Aider Model Selection]

<!-- TODO: Research how Aider handles model selection -->

**Source:** [To be researched]

**Relevance:** Learn from existing implementations

---

## 🔍 Analysis

**Preliminary analysis:**

For Phase 1, model selection is informational only:
- Output recommended model in --interactive output
- User manually selects in Cursor

Phase 2/3 require config file and possibly programmatic invocation.

**Key Insights:**
- [x] Insight 1: Phase 1 can use informational approach
- [ ] Insight 2: Config format should be stable across phases
- [ ] Insight 3: [Research Aider patterns]

---

## 💡 Recommendations

**Based on exploration analysis:**

- [x] Recommendation 1: Phase 1 - Include recommended model in output
- [ ] Recommendation 2: Design stable config format for Phase 2+
- [ ] Recommendation 3: Research Aider for implementation patterns

---

## 📋 Requirements Discovered

- [ ] REQ-MS-1: dt-workflow must output recommended model for workflow type
- [ ] REQ-MS-2: Config file format must be designed for future phases
- [ ] REQ-MS-3: Model recommendations must be configurable

---

## 🚀 Next Steps

1. Implement Phase 1 (informational) model recommendation
2. Design config file format for Phase 2
3. Research Aider/LLM CLI for implementation patterns
4. This may be deferred until after core implementation

---

**Last Updated:** 2026-01-23
