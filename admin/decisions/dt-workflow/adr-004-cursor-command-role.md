# ADR-004: Cursor Command Role

**Status:** ✅ Accepted  
**Created:** 2026-01-22  
**Last Updated:** 2026-01-22

---

## Context

We have both:
- **Cursor commands** (`.cursor/commands/*.md`) - IDE-native, AI-integrated
- **dt-workflow** (`bin/dt-workflow`) - CLI tool, portable

We need to decide the relationship: Does dt-workflow replace Cursor commands, wrap them, or work alongside them?

**Related Research:**
- [Exploration: Theme 4](../../explorations/dt-workflow/exploration.md)
- [Cursor Command Role Research](../../research/dt-workflow/research-cursor-command-role.md)

---

## Decision

**Decision:** Cursor commands are **orchestrators** that call dt-workflow for core logic.

### Responsibility Division

| Layer | Responsibility | Example |
|-------|----------------|---------|
| **Cursor Commands** | Cursor-specific logic, AI invocation | `/explore` triggers AI chat |
| **dt-workflow** | Structure generation, validation, context | `dt-workflow explore --interactive` |

### Pattern

```
User: /explore my-feature
        │
        ▼
┌─────────────────────────────────────────────┐
│  Cursor Command (.cursor/commands/explore.md)│
│  - Handles Cursor-specific behavior          │
│  - May add Cursor context                    │
│  - Invokes dt-workflow                       │
└─────────────────────────────────────────────┘
        │
        ▼
┌─────────────────────────────────────────────┐
│  dt-workflow explore topic --interactive     │
│  - Gathers universal context                 │
│  - Generates structure                       │
│  - Outputs for AI                            │
└─────────────────────────────────────────────┘
```

---

## Consequences

### Positive

- **Portability:** dt-workflow works outside Cursor (CI, other editors)
- **Testability:** Core logic testable without Cursor
- **Separation of concerns:** Cursor-specific vs universal logic
- **Flexibility:** Can enhance Cursor commands without touching dt-workflow

### Negative

- **Two places to maintain:** Changes may need updates in both
- **Indirection:** User runs command → command runs tool

---

## Alternatives Considered

### Alternative A: Cursor Commands Replace dt-workflow

**Description:** Put all logic in Cursor commands. No CLI tool.

**Pros:**
- Single source of truth
- Deep Cursor integration

**Cons:**
- Not portable (Cursor-only)
- Hard to test
- Can't use in CI

**Why not chosen:** Violates dev-toolkit's "portable CLI toolkit" identity.

### Alternative B: dt-workflow Replaces Cursor Commands

**Description:** Remove Cursor commands. Users run dt-workflow directly.

**Pros:**
- Single tool
- Maximum portability

**Cons:**
- Loses Cursor-specific enhancements
- Less discoverable in IDE
- Can't leverage Cursor AI features

**Why not chosen:** Loses IDE integration benefits.

---

## Decision Rationale

**Key Factors:**
1. **Portability requirement:** dt-workflow must work without Cursor
2. **IDE integration value:** Cursor commands provide discoverability
3. **Testing:** CLI tools easier to test than IDE commands
4. **Phase 1 reality:** Manual AI invocation means commands add minimal value now

**Research Support:**
- Exploration Theme 4 analysis
- dev-toolkit "portable CLI toolkit" identity

**Evolution Path:**
- Phase 1: Commands are thin wrappers (dt-workflow does heavy lifting)
- Phase 3: Commands may invoke AI directly (richer integration)

---

## Requirements Impact

**Requirements Satisfied:**
- NFR-2 (old): Portability ✅
- FR-3: Explicit Context Injection ✅ (dt-workflow handles)

---

## References

- [Exploration: dt-workflow Theme 4](../../explorations/dt-workflow/exploration.md)
- [Research: Cursor Command Role](../../research/dt-workflow/research-cursor-command-role.md)

---

**Last Updated:** 2026-01-22
