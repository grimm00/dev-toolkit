# ADR-007: Command Migration and Iteration Strategy

**Status:** ✅ Accepted  
**Created:** 2026-01-20  
**Last Updated:** 2026-01-20

---

## Context

Dev-infra provides basic templates for 17 document types, but each Cursor command has specific needs that may require template refinement. There are 23 Cursor commands with 154 inline template instances that will eventually migrate to using dt-doc-gen.

**Key Questions:**
1. In what order should commands be migrated?
2. How should templates be refined during implementation?
3. How should changes flow back to dev-infra?
4. How long should inline templates remain as fallback?

**Related Research:**
- [Command Integration Research](../../research/doc-infrastructure/research-command-integration.md)
- [Iteration Plan](../../research/doc-infrastructure/iteration-plan.md)

**Related Requirements:**
- NFR-CI1: Incremental migration
- NFR-CI2: Backward compatibility
- C-CI1: Commands remain orchestrators

---

## Decision

**Use per-command iteration sprints with incremental migration and local template overrides during development.**

### Migration Order

| Sprint | Command | Mode | Rationale |
|--------|---------|------|-----------|
| **1** | `/explore` | Two-mode | Sets patterns, highest complexity |
| **2** | `/research` | Two-mode | Builds on Sprint 1 patterns |
| **3** | `/decision` | Single | ADR format is well-defined |
| **4** | `/transition-plan` | Single | Planning documents |
| **5** | `/handoff` | Single | Simpler single-file |
| **6** | `/fix-plan` | Single | Simpler single-file |

### Per-Sprint Iteration Cycle

```
┌─────────────────────────────────────────────────────────────┐
│  Phase 1: ASSESS                                             │
│     • Inventory inline templates in command                  │
│     • Map to dev-infra templates                             │
│     • Identify gaps/mismatches                               │
│                                                              │
│  Phase 2: IMPLEMENT                                          │
│     • Wire dt-doc-gen for this doc type                      │
│     • Create test fixtures                                   │
│     • Compare output to inline templates                     │
│                                                              │
│  Phase 3: REFINE                                             │
│     • Document template changes needed                       │
│     • Use local overrides for testing                        │
│     • PR to dev-infra when stable                            │
│                                                              │
│  Phase 4: VALIDATE                                           │
│     • dt-doc-validate passes on output                       │
│     • AI expansion zones work correctly                      │
│     • Full workflow test                                     │
│                                                              │
│  Phase 5: MIGRATE                                            │
│     • Update command to use dt-doc-gen                       │
│     • Keep inline template as fallback                       │
│     • Real-world usage testing                               │
└─────────────────────────────────────────────────────────────┘
```

### Decision Point Resolutions

| DP | Decision Point | Resolution |
|----|----------------|------------|
| **DP-1** | Template override mechanism | Layered discovery (flag → env → config → defaults) per ADR-001 |
| **DP-2** | Dev-infra coordination | PR per sprint (batched changes) |
| **DP-3** | Fallback duration | Remove when next sprint validates patterns |
| **DP-4** | Validation strictness | Match inline behavior first, then progressively tighten |
| **DP-5** | Test fixture source | Capture baseline from inline templates (establishes parity) |

### Template Refinement Workflow

```bash
# During development - local overrides
export DT_TEMPLATES_PATH=~/Projects/dev-toolkit/templates-dev/

# Make changes, test with dt-doc-gen
dt-doc-gen exploration my-topic --mode setup

# When stable, PR to dev-infra
cd ~/Projects/dev-infra
git checkout -b feat/sprint-1-explore-templates
# ... commit template changes
# ... create PR
```

### Migration Phases

**Phase 1: Tooling Ready (No Command Changes)**
- Implement dt-doc-gen and dt-doc-validate
- Templates remain in dev-infra
- Commands unchanged (still use inline templates)
- Tools can be run manually for testing

**Phase 2: Incremental Migration**
- Update commands one at a time (per sprint)
- Replace inline templates with dt-doc-gen calls
- Keep inline template as fallback during transition
- Validate each command before moving to next

**Phase 3: Cleanup**
- Remove inline templates from commands
- Commands only reference dt-doc-gen
- Commands become pure orchestrators

---

## Consequences

### Positive

- **Low risk:** One command at a time, with fallback
- **Fast iteration:** Local overrides enable rapid development
- **Pattern reuse:** Sprint 1 patterns inform later sprints
- **Validation:** Each sprint validates approach before continuing
- **Backward compatible:** Existing workflows continue working

### Negative

- **Coordination overhead:** PRs to dev-infra per sprint
- **Temporary duplication:** Inline templates exist alongside dt-doc-gen during Phase 2
- **Timeline:** 9-14 days estimated for all sprints

### Mitigations

- Batch template changes per sprint (not per file)
- Clear fallback removal criteria (next sprint validates)
- Sprint 1 sets patterns that accelerate later sprints

---

## Alternatives Considered

### Alternative 1: Big Bang Migration

**Description:** Migrate all commands at once.

**Pros:**
- Single coordinated release
- No transition period
- Clean cut-over

**Cons:**
- High risk (all or nothing)
- Blocks all commands if issues found
- No learning from early migrations

**Why not chosen:** Too risky. Incremental migration allows learning and reduces blast radius.

---

### Alternative 2: Template Changes First

**Description:** Finalize all templates in dev-infra before implementing dt-doc-gen.

**Pros:**
- Templates stable before tooling
- Clear specification

**Cons:**
- Can't validate templates without tooling
- Delays implementation
- Templates may need changes after testing

**Why not chosen:** Chicken-and-egg problem. Need dt-doc-gen to validate template changes.

---

### Alternative 3: Independent Command Releases

**Description:** Each command released independently on its own schedule.

**Pros:**
- Maximum flexibility
- No coordination needed

**Cons:**
- Inconsistent UX during transition
- Version matrix complexity
- Hard to track progress

**Why not chosen:** Sprint-based approach provides structure while maintaining flexibility.

---

## Decision Rationale

**Key Factors:**

1. **Risk Reduction:** Incremental migration with fallback minimizes risk
2. **Learning:** Early sprints inform later sprints
3. **Coordination:** Batched PRs balance speed and review burden
4. **Compatibility:** Inline fallback maintains backward compatibility

**Research Support:**
- Finding 5: "Migration strategy is incremental" (3 phases defined)
- Migration order from research: `/explore` → `/research` → others
- Insight 4: "Migration is incremental - one command at a time, with fallback"

---

## Requirements Impact

**Requirements Addressed:**
- NFR-CI1: Incremental migration ✅
- NFR-CI2: Backward compatibility ✅
- NFR-CI3: Output compatibility with inline templates ✅
- NFR-CI4: <1 second invocation time ✅
- C-CI1: Commands remain orchestrators ✅
- C-CI2: AI generates content only ✅
- C-CI3: Inline templates as fallback during migration ✅

**Iteration Plan Decision Points:**
- DP-1: Template override → Layered discovery ✅
- DP-2: Coordination model → PR per sprint ✅
- DP-3: Fallback duration → Next sprint validates ✅
- DP-4: Validation strictness → Match inline first ✅
- DP-5: Test fixtures → Capture baseline ✅

---

## References

- [Command Integration Research](../../research/doc-infrastructure/research-command-integration.md)
- [Iteration Plan](../../research/doc-infrastructure/iteration-plan.md)
- [Requirements Document](../../research/doc-infrastructure/requirements.md)

---

**Last Updated:** 2026-01-20
