# ADR-003: Component Integration

**Status:** ✅ Accepted  
**Created:** 2026-01-22  
**Last Updated:** 2026-01-22

---

## Context

dt-toolkit has existing tools (dt-doc-gen, dt-doc-validate) that dt-workflow could use. We need to decide whether to:
1. Keep them standalone and compose from dt-workflow
2. Internalize them into dt-workflow
3. Some hybrid approach

**Related Research:**
- [Exploration: Theme 2](../../explorations/dt-workflow/exploration.md)
- [Component Decisions Research](../../research/dt-workflow/research-component-decisions.md)

**Related Requirements:**
- FR-5 (old): Standalone Validation
- NFR-3 (old): Backward Compatibility

---

## Decision

**Decision:** **dt-doc-validate stays standalone**, **dt-doc-gen becomes internal** to dt-workflow.

### Rationale by Component

| Component | Decision | Rationale |
|-----------|----------|-----------|
| **dt-doc-validate** | Standalone | Has CI/automation value independent of dt-workflow |
| **dt-doc-gen** | Internal | No standalone value; always used with AI fill step |

### Integration Pattern

```
dt-workflow explore topic --interactive
    └── [internal] generate_exploration_structure()   # Was dt-doc-gen logic
    
# dt-doc-validate remains usable independently
dt-doc-validate admin/explorations/my-topic/         # CI pipelines
dt-workflow explore topic --validate                  # Calls validation internally
```

---

## Consequences

### Positive

- **dt-doc-validate stays useful:** CI pipelines can validate docs without dt-workflow
- **Cleaner dt-workflow:** Structure generation is internal, simpler API
- **Backward compatibility:** Existing dt-doc-validate users unaffected
- **No external dependency:** dt-workflow doesn't shell out to dt-doc-gen

### Negative

- **Code duplication possibility:** Template logic in two places if not careful
- **dt-doc-gen deprecated:** Users expecting standalone generator will need to use dt-workflow

---

## Alternatives Considered

### Alternative A: Both Standalone

**Description:** Keep both dt-doc-gen and dt-doc-validate as standalone tools. dt-workflow shells out to them.

**Pros:**
- Maximum flexibility
- Tools usable independently

**Cons:**
- dt-doc-gen has no standalone value (who generates templates without AI fill?)
- Shell-out complexity
- Error handling across process boundaries

**Why not chosen:** dt-doc-gen has no standalone use case. Always followed by AI fill.

### Alternative B: Both Internal

**Description:** Internalize both into dt-workflow. Deprecate standalone tools.

**Pros:**
- Simplest integration
- One codebase

**Cons:**
- Breaks CI pipelines using dt-doc-validate
- Loses validation-only capability

**Why not chosen:** dt-doc-validate has clear CI value. Breaking existing automation is unacceptable.

---

## Decision Rationale

**Key Factors:**
1. **Use case analysis:**
   - dt-doc-gen: Always followed by AI → no standalone value
   - dt-doc-validate: Used in CI pipelines → clear standalone value
2. **Backward compatibility:** Existing dt-doc-validate users must not break
3. **Simplicity:** Internal generation avoids shell-out complexity

**Research Support:**
- Exploration Theme 2 analysis
- Use case frequency analysis

---

## Requirements Impact

**Requirements Satisfied:**
- FR-5 (old): Standalone Validation ✅ (dt-doc-validate remains)
- NFR-3 (old): Backward Compatibility ✅

**Migration Path:**
- dt-doc-gen → `dt-workflow [workflow] --interactive`
- dt-doc-validate → unchanged

---

## References

- [Exploration: dt-workflow Theme 2](../../explorations/dt-workflow/exploration.md)
- [Research: Component Decisions](../../research/dt-workflow/research-component-decisions.md)

---

**Last Updated:** 2026-01-22
