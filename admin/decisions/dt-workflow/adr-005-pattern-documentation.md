# ADR-005: Pattern Documentation Approach

**Status:** ✅ Accepted  
**Created:** 2026-01-22  
**Last Updated:** 2026-01-22

---

## Context

This exploration identified several universal patterns:
1. Spike Determination
2. Explicit Context Injection
3. L1/L2/L3 Validation Levels
4. Handoff File Contract
5. Phase-Based Evolution

We need to decide how to document these patterns so future workflows follow them.

**Related Research:**
- [Decision Propagation Research](../../research/dt-workflow/research-decision-propagation.md)
- ADR best practices
- Design system governance patterns

**Related Requirements:**
- FR-14: Two-Tier Pattern Documentation
- FR-15: Pattern Checklist in Explore
- FR-16: Pattern Rationale Documentation
- FR-17: Create Pattern Library

---

## Decision

**Decision:** Use a **two-tier pattern documentation** approach with ADRs for significant decisions.

### Three Tiers

```
┌─────────────────────────────────────────────────┐
│  TIER 1: Cursor Rules (.cursor/rules/)          │
│  • AI-discoverable, concise                     │
│  • Must-follow patterns                         │
│  • Format: Brief description + when to use      │
└─────────────────────────────────────────────────┘
                    │ links to
                    ▼
┌─────────────────────────────────────────────────┐
│  TIER 2: Pattern Library (docs/patterns/)       │
│  • Detailed documentation with rationale        │
│  • Intent, when/when-not, trade-offs, examples  │
│  • Human reference                              │
└─────────────────────────────────────────────────┘
                    │ significant decisions become
                    ▼
┌─────────────────────────────────────────────────┐
│  TIER 3: ADRs (admin/decisions/)                │
│  • Architecturally significant choices          │
│  • Full context, alternatives, rationale        │
└─────────────────────────────────────────────────┘
```

### Pattern Documentation Format (Tier 2)

```markdown
## Pattern: [Name]

**Intent:** What problem does this pattern solve?

**When to Use:**
- [Applicability criterion 1]
- [Applicability criterion 2]

**When NOT to Use:**
- [Exception 1]
- [Exception 2]

**Pattern:**
[Description of the pattern]

**Rationale (Y-Statement):**
In the context of [use case], facing [concern], we decided for [option]
to achieve [quality], accepting [downside].

**Examples:**
[Concrete examples]
```

---

## Consequences

### Positive

- **AI discoverability:** Tier 1 in Cursor rules means AI sees patterns automatically
- **Human reference:** Tier 2 provides detailed documentation for developers
- **Formal decisions:** Tier 3 ADRs capture significant architectural choices
- **Pattern evolution:** Clear process for updating patterns

### Negative

- **Maintenance:** Three locations to keep in sync
- **Overhead:** New patterns require multi-tier documentation

---

## Alternatives Considered

### Alternative A: ADRs Only

**Description:** Document all patterns as ADRs. No separate pattern library.

**Pros:**
- Single documentation location
- Formal process for all patterns

**Cons:**
- ADRs may be overkill for simple patterns
- AI doesn't automatically read ADRs
- Verbose for pattern reference

**Why not chosen:** ADRs are heavy for simple patterns. Need AI-discoverable location.

### Alternative B: Cursor Rules Only

**Description:** Put all patterns in `.cursor/rules/workflow.mdc`.

**Pros:**
- AI always sees them
- Single location

**Cons:**
- Rules files get large
- No detailed rationale
- Hard for humans to reference

**Why not chosen:** Cursor rules should be concise. Detailed documentation needed elsewhere.

---

## Decision Rationale

**Key Factors:**
1. **AI discoverability:** Patterns must be in Cursor rules for AI to follow
2. **Human reference:** Developers need detailed documentation
3. **Formal decisions:** Some decisions warrant full ADR treatment
4. **Design system best practices:** Two-tier approach common in design systems

**Research Support:**
- [Research: Decision Propagation](../../research/dt-workflow/research-decision-propagation.md)
- Design system governance patterns
- ADR best practices (adr.github.io)

**Pattern Evolution Process:**
```
Initiation → Consolidation → Documentation → Communication
```

---

## Requirements Impact

**Requirements Satisfied:**
- FR-14: Two-Tier Pattern Documentation ✅
- FR-15: Pattern Checklist in Explore ✅ (documented, implementation pending)
- FR-16: Pattern Rationale Documentation ✅ (Y-statement format)
- FR-17: Create Pattern Library ✅ (location decided)

**Action Items:**
- [ ] Create `docs/patterns/workflow-patterns.md`
- [ ] Add pattern checklist to `/explore` command

---

## References

- [Research: Decision Propagation](../../research/dt-workflow/research-decision-propagation.md)
- [ADR best practices](https://adr.github.io/)
- Design system governance (Brad Frost)

---

**Last Updated:** 2026-01-22
