# ADR-001: Unified Workflow Architecture

**Status:** ✅ Accepted  
**Created:** 2026-01-22  
**Last Updated:** 2026-01-22

---

## Context

We need to decide whether dt-workflow should be a unified command that orchestrates the entire workflow pipeline, or a thin wrapper that composes separate tools (dt-doc-gen, dt-doc-validate, etc.).

**Related Research:**
- [Exploration: Theme 1](../../explorations/dt-workflow/exploration.md)
- [Spike Implementation](../../../bin/dt-workflow)

**Related Requirements:**
- FR-1: Unified Workflow Command
- FR-2: Phase 1 Interactive Mode

---

## Decision

**Decision:** Build dt-workflow as a **unified command** that internalizes structure generation and orchestrates the complete workflow pipeline.

```
dt-workflow explore topic --interactive
    → Gathers context (universal + workflow-specific)
    → Generates structure (templates)
    → Outputs for AI consumption
    → Validates results (post-fill)
```

---

## Consequences

### Positive

- **Better UX:** Single command for complete workflow
- **Consistent context:** All workflows get same context injection pattern
- **Easier maintenance:** One codebase to update
- **Clearer mental model:** Users learn one tool, not many

### Negative

- **Less flexibility:** Opinionated workflow, less mix-and-match
- **Integration tests needed:** Must test end-to-end, not just unit
- **Larger single command:** More code in one file

---

## Alternatives Considered

### Alternative A: Composable Tools (Unix Philosophy)

**Description:** Keep dt-doc-gen, dt-doc-validate as separate tools. Cursor commands compose them via pipes/scripts.

**Pros:**
- Maximum flexibility
- Each tool testable in isolation
- Follows Unix philosophy

**Cons:**
- Fragmented UX
- Context must be passed between tools
- Users must learn multiple tools

**Why not chosen:** The spike demonstrated that unified feels more natural and provides better UX. User research (single developer workflow) doesn't require composition flexibility.

### Alternative B: Hybrid (Unified with Escape Hatches)

**Description:** Unified command but expose sub-commands for advanced users.

**Pros:**
- Best of both worlds
- Power users can customize

**Cons:**
- Two interfaces to maintain
- Documentation complexity

**Why not chosen:** Added complexity without clear benefit. If escape hatches are needed, can be added later.

---

## Decision Rationale

**Key Factors:**
1. **Spike validated the UX:** Running `dt-workflow explore topic --interactive` felt right
2. **Context injection works better unified:** Gathering rules once, outputting once
3. **User is single developer:** No need for tool composition across teams
4. **Phase 1 constraints:** Interactive mode is already opinionated

**Research Support:**
- Exploration Theme 1 analyzed trade-offs
- Spike implementation proved feasibility
- Similar tools (Aider, Copilot Workspace) use unified approach

---

## Requirements Impact

**Requirements Satisfied:**
- FR-1: Unified Workflow Command ✅
- FR-2: Phase 1 Interactive Mode ✅
- FR-3: Explicit Context Injection ✅

---

## References

- [Exploration: dt-workflow](../../explorations/dt-workflow/)
- [Spike Implementation](../../../bin/dt-workflow)

---

**Last Updated:** 2026-01-22
