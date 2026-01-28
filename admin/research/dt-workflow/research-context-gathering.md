# Research: Context Gathering Scalability

**Research Topic:** dt-workflow  
**Question:** How should context be gathered and injected at scale?  
**Status:** ✅ Complete  
**Priority:** 🔴 HIGH - Primary research focus  
**Created:** 2026-01-23  
**Last Updated:** 2026-01-23  
**Completed:** 2026-01-23

---

## 🎯 Research Question

The spike validated that explicit context injection works and addresses user trust concerns. However, it revealed scalability questions:

**Primary Question:** What happens when rules/context are numerous? Should context be full content, pointers (file references), or a hybrid approach?

**Sub-questions:**
1. What's the practical token budget for context injection?
2. How do we prioritize context when constrained?
3. Should context strategy vary by project size?
4. What's the AI behavior difference between content vs pointers?

---

## 🔍 Research Goals

- [x] Goal 1: Determine token impact of current spike approach
- [x] Goal 2: Compare AI behavior with content vs pointers
- [x] Goal 3: Define context prioritization strategy
- [x] Goal 4: Design tiered/dynamic context approach
- [x] Goal 5: Establish practical recommendations

---

## 📚 Research Methodology

**Sources:**
- [x] Spike output analysis (measure actual token counts)
- [x] AI tool documentation (Cursor, Aider context handling)
- [x] Web search: LLM context window best practices
- [x] Web search: RAG vs full context approaches
- [x] Aider repository map approach

---

## 📊 Findings

### Finding 1: Current Spike Token Usage

**Measurement from spike output (`dt-workflow explore test-topic --interactive`):**

| Metric | Value |
|--------|-------|
| Characters | ~38,000 |
| Lines | ~1,559 |
| Words | ~4,913 |
| **Estimated tokens** | **~7,000-10,000** |

**Token estimation methods:**
- Character-based (4 chars/token): 38,128 / 4 ≈ 9,500 tokens
- Word-based (1.3 tokens/word): 4,913 × 1.3 ≈ 6,400 tokens

**Context:** Modern LLMs support 100K-200K+ tokens (Claude: 100K, GPT-4: 128K, Gemini: 1M). Our current output of ~10K tokens is well within limits for current models.

**Source:** Spike measurement + LLM documentation

**Relevance:** Current approach is viable for typical projects. Scalability concerns are for edge cases (very large rule sets).

---

### Finding 2: Full Context vs RAG/Pointers Trade-offs

**Industry guidance: Full context injection should be your starting point.**

From research: "Frontier LLMs handle large volumes of structured context exceptionally well, especially when properly formatted (e.g., with XML-style tags)."

**When to use full context injection:**
- Knowledge base fits within token limits (our case: ~10K tokens)
- Maximum accuracy is needed
- Latency and cost aren't major constraints

**When RAG/pointers become necessary (three blockers):**
1. **Performance**: More tokens cause slower responses
2. **Token limits**: You run out of context window space
3. **Cost**: Per-token billing becomes prohibitively expensive

**For dt-workflow:** None of these blockers apply currently. Full context injection is appropriate.

**Source:** Web search: RAG vs full context injection tradeoffs

**Relevance:** Validates our current approach; defines when to pivot

---

### Finding 3: "Lost in the Middle" Problem

**Key finding:** LLMs exhibit a U-shaped performance curve. They attend best to information at the beginning and end of context, with up to 30% performance degradation for middle content.

**Implications for dt-workflow:**
- Place most important rules at the START of context
- Place workflow-specific instructions at the END (closest to the task)
- Less critical context can go in the middle

**Recommended context ordering:**
```
1. [START] Critical rules (coding standards, must-follow patterns)
2. [MIDDLE] Project identity, background context
3. [END] Workflow-specific context + task instructions
```

**Source:** Web search: "Lost in the middle" LLM problem

**Relevance:** Informs context ordering strategy

---

### Finding 4: Aider's Repository Map Approach

**Aider's solution:** Instead of injecting full file contents, create a "repository map" - a concise summary containing:
- List of files in repository
- Key symbols (classes, functions, methods) per file
- Function signatures and call relationships

**Key characteristics:**
- Default budget: **1K tokens** for repo map
- Dynamically adjusts based on chat state
- Uses graph ranking to prioritize relevant files
- LLM can request specific files be added if needed

**Applicability to dt-workflow:**
- For rules: Full content is better (rules are instructions, not code)
- For project files: Summary/map approach could work
- For related documents: Pointers + summaries

**Source:** Aider documentation (aider.chat/docs/repomap.html)

**Relevance:** Provides hybrid model inspiration

---

### Finding 5: Cursor Rules Best Practices

**From Cursor documentation:**
- Rules are included at the **start of model context**
- Modular organization recommended
- Clear naming conventions important
- Rules persist across completions (model has no memory)

**Recommendations:**
- Group related rules together
- Use descriptive names
- Document solutions in rules
- Place rules in subdirectories for scope

**Source:** Cursor documentation (cursor.com/docs/context/rules)

**Relevance:** Confirms our approach aligns with Cursor patterns

---

### Finding 6: Token Budget Guidelines

**Current model context windows (2025-2026):**

| Model | Context Window |
|-------|----------------|
| Claude 3.5/4 | 100K-200K tokens |
| GPT-4 Turbo | 128K tokens |
| Gemini 1.5 Pro | 1M tokens |
| Llama | 32K tokens |

**Practical guidance:**
- Keep context under 50% of window for best performance
- Reserve space for model output (typically 4K-8K tokens)
- Our ~10K token output is **safe for all major models**

**Source:** Web search: LLM context window best practices

**Relevance:** Confirms current approach is within safe limits

---

## 🔍 Analysis

### Current State Assessment

Our spike output (~10K tokens) is well within modern LLM limits. The concern about "numerous rules" is valid for edge cases but not blocking for typical usage.

**Key insight:** Full context injection is the RIGHT approach for our use case because:
1. Our token usage (~10K) is well under limits (100K+)
2. Rules are instructions that need full fidelity (not code to summarize)
3. User trust requires explicit visibility of what's loaded
4. RAG/pointer overhead isn't justified at our scale

### When to Consider Alternatives

Pivot to hybrid approach if ANY of these occur:
- Total context exceeds 50K tokens
- Response latency becomes noticeable
- Users report "context ignored" issues
- New workflows with massive context needs

### Context Ordering Strategy

Based on "lost in the middle" research:

```
┌─────────────────────────────────────────────────┐
│ 1. CRITICAL RULES (start - highest attention)   │
│    - Coding standards                           │
│    - Must-follow patterns                       │
│    - Project identity                           │
├─────────────────────────────────────────────────┤
│ 2. BACKGROUND CONTEXT (middle - lower attention)│
│    - Project structure                          │
│    - Git state                                  │
│    - Related documents (summaries)              │
├─────────────────────────────────────────────────┤
│ 3. TASK CONTEXT (end - high attention)          │
│    - Workflow-specific context                  │
│    - Generated structure                        │
│    - Instructions                               │
└─────────────────────────────────────────────────┘
```

### Key Insights

- [x] Insight 1: Current ~10K token output is safe for all major models
- [x] Insight 2: Full context injection is correct for our scale
- [x] Insight 3: Context ordering matters - put critical rules at start, task at end
- [x] Insight 4: Monitor for three blockers: performance, token limits, cost
- [x] Insight 5: Hybrid approach (summaries + pointers) is escape hatch, not default

---

## 💡 Recommendations

- [x] **R1: Keep full context injection** - Our scale doesn't justify RAG complexity
- [x] **R2: Implement context ordering** - Critical rules first, task last
- [x] **R3: Add token reporting** - Output token count for transparency
- [x] **R4: Define escape hatch** - Document when to switch to hybrid
- [x] **R5: Monitor usage patterns** - Watch for edge cases hitting limits

---

## 📋 Requirements Discovered

### Functional Requirements

- [x] **REQ-CG-1:** Context must be ordered with critical rules at start, task at end
- [x] **REQ-CG-2:** dt-workflow should report approximate token count in output
- [x] **REQ-CG-3:** Universal context (rules, identity) must always be included
- [x] **REQ-CG-4:** Workflow-specific context should be configurable per workflow type

### Non-Functional Requirements

- [x] **REQ-CG-5:** Total context should stay under 50K tokens for optimal performance
- [x] **REQ-CG-6:** Context injection should complete in under 1 second

### Constraints

- [x] **C-CG-1:** Full content injection is preferred over pointers for rules
- [x] **C-CG-2:** Hybrid approach only if hitting performance/limit/cost blockers

---

## 🚀 Next Steps

1. ✅ Research complete
2. Update spike to implement context ordering
3. Add token count reporting to output
4. Document escape hatch criteria
5. Proceed to decision phase

---

## 🔗 Related

- [Exploration: Topic 10](../../explorations/dt-workflow/exploration.md#theme-8-context-gathering)
- [Spike Implementation](../../../bin/dt-workflow)
- [dev-infra: Context Gathering Research](/Users/cdwilson/Projects/dev-infra/admin/research/template-doc-infrastructure/research-summary.md)

---

**Last Updated:** 2026-01-23
