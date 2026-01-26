# ADR-002: Context Injection Strategy

**Status:** ✅ Accepted  
**Created:** 2026-01-22  
**Last Updated:** 2026-01-22

---

## Context

dt-workflow must inject context (Cursor rules, project identity, workflow-specific data) for AI consumption. We need to decide:
1. Full content injection vs pointers/references
2. How to order context for optimal AI attention

**Related Research:**
- [Context Gathering Research](../../research/dt-workflow/research-context-gathering.md)
- Token analysis: ~10K tokens current output

**Related Requirements:**
- FR-4: Context Ordering
- FR-5: Token Count Reporting
- FR-6: Universal Context Inclusion
- NFR-1: Token Budget (<50K)
- C-3: Full Content Preferred

---

## Decision

**Decision:** Use **full content injection** with **strategic ordering** (START/MIDDLE/END pattern).

### Context Ordering

```
┌─────────────────────────────────────────────────┐
│ 1. START - Critical Rules (highest attention)   │
│    - Cursor rules (.cursor/rules/*.mdc)         │
│    - Must-follow standards                      │
├─────────────────────────────────────────────────┤
│ 2. MIDDLE - Background Context (lower attention)│
│    - Project identity (roadmap, admin README)   │
│    - Git context (branch, recent commits)       │
│    - Workflow-specific context                  │
├─────────────────────────────────────────────────┤
│ 3. END - Task + Instructions (high attention)   │
│    - Generated structure/templates              │
│    - Instructions for AI                        │
│    - Next Steps section                         │
└─────────────────────────────────────────────────┘
```

### Token Transparency

Output includes approximate token count: `~10K tokens (well within 100K+ limits)`

---

## Consequences

### Positive

- **User trust:** Users see exactly what AI receives
- **Maximum fidelity:** Rules not summarized or truncated
- **Optimal attention:** Critical rules at start, task at end (addresses "lost in the middle")
- **Simplicity:** No RAG infrastructure needed

### Negative

- **Higher token usage:** ~10K tokens per invocation
- **Scalability ceiling:** May need hybrid if rules grow significantly

---

## Alternatives Considered

### Alternative A: RAG/Pointer Approach

**Description:** Store rules in vector DB, retrieve relevant ones per query. Output pointers (file paths) instead of content.

**Pros:**
- Scales to massive rule sets
- Lower per-query token cost

**Cons:**
- RAG infrastructure complexity
- AI may not read referenced files
- Extra round-trips

**Why not chosen:** Our current scale (~10K tokens) is well under limits (100K+). RAG complexity not justified.

### Alternative B: No Ordering (Original Spike)

**Description:** Output context in arbitrary order (rules, then identity, then task).

**Pros:**
- Simpler implementation

**Cons:**
- "Lost in the middle" problem: AI pays less attention to middle content
- Critical rules may be missed

**Why not chosen:** Research clearly showed ordering matters for LLM attention.

---

## Decision Rationale

**Key Factors:**
1. **Token analysis:** Current output ~10K tokens, well under 100K+ limits
2. **"Lost in the middle" research:** LLMs attend best to start and end
3. **User trust:** Explicit injection addresses concern about implicit rules
4. **Simplicity:** Full injection is simplest baseline (industry recommendation)

**Research Support:**
- [Research: Context Gathering Scalability](../../research/dt-workflow/research-context-gathering.md)
- Industry guidance: "Full context injection should be your starting point"

**Escape Hatch Defined:**
Switch to hybrid/RAG only if hitting:
- Performance degradation
- Token limits
- Cost blockers

---

## Requirements Impact

**Requirements Satisfied:**
- FR-4: Context Ordering ✅
- FR-5: Token Count Reporting ✅
- FR-6: Universal Context Inclusion ✅
- NFR-1: Token Budget ✅ (10K << 50K limit)
- C-3: Full Content Preferred ✅

---

## References

- [Research: Context Gathering](../../research/dt-workflow/research-context-gathering.md)
- "Lost in the middle" LLM research
- AWS Step Functions input/output patterns

---

**Last Updated:** 2026-01-22
