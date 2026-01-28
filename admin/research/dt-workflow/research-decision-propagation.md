# Research: Decision Propagation Patterns

**Research Topic:** dt-workflow  
**Question:** How do decisions made here inform future work on remaining and new workflows?  
**Status:** ✅ Complete  
**Priority:** 🔴 HIGH  
**Created:** 2026-01-23  
**Last Updated:** 2026-01-23  
**Completed:** 2026-01-23

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

- [x] Goal 1: Identify decisions from this exploration that apply universally
- [x] Goal 2: Design pattern documentation location/format
- [x] Goal 3: Define process for propagating decisions to other workflows
- [x] Goal 4: Design pattern evolution/update process

---

## 📚 Research Methodology

**Sources:**
- [x] Decisions made in this exploration (spike, context gathering, etc.)
- [x] Existing pattern documentation (Cursor rules, workflow.mdc)
- [x] ADR patterns and best practices
- [x] Web search: Pattern documentation best practices
- [x] Web search: Design system governance

---

## 📊 Findings

### Finding 1: Universal vs Workflow-Specific Decisions

**Universal patterns identified from this exploration:**

| Pattern | Applies To | Propagation Priority |
|---------|------------|---------------------|
| **Spike Determination** | All explorations | 🔴 HIGH - already documented in workflow.mdc |
| **Explicit Context Injection** | All dt-workflow outputs | 🔴 HIGH - addresses user trust |
| **Phase 1 --interactive** | All dt-* tools | 🔴 HIGH - Phase 1 constraint |
| **L1/L2/L3 Validation Levels** | All workflow I/O | 🔴 HIGH - error handling pattern |
| **Handoff File Pattern** | All workflow chaining | 🔴 HIGH - enables automation |
| **Context Ordering (start/middle/end)** | All context injection | 🟡 MEDIUM - optimization |

**Workflow-specific decisions (don't propagate):**

| Decision | Specific To | Reason |
|----------|-------------|--------|
| Explore template structure | /explore | Workflow-specific templates |
| Research document format | /research | Research-specific needs |
| ADR numbering scheme | /decision | Decision-specific |

**Source:** This exploration + analysis

**Relevance:** Clarifies what needs propagation vs what's local

---

### Finding 2: Industry Pattern Documentation Best Practices

**From research on design patterns and ADRs:**

**Pattern documentation should include:**
1. **Intent** - What problem does this pattern solve?
2. **When to use** - Applicability criteria
3. **When NOT to use** - Anti-patterns, exceptions
4. **Trade-offs** - Pros and cons
5. **Examples** - Concrete usage
6. **Rationale** - Why this approach (from ADR best practices)

**ADR guidance (Nygard pattern):**
- Use ADRs for "architecturally significant" decisions
- Keep them small and modular (bite-sized)
- Store in project repository with sequential numbering
- Mark superseded decisions, don't delete

**Y-Statement format for quick decisions:**
> "In the context of [use case], facing [concern], we decided for [option] to achieve [quality], accepting [downside]."

**Source:** Martin Fowler's Patterns Catalog, ADR.github.io, Cognitect

**Relevance:** Provides format for documenting patterns

---

### Finding 3: Design System Governance Insights

**Key principles for pattern governance:**

1. **Transparency** - Planning, prioritization, and decisions accessible to all
2. **Enablement over enforcement** - Collaborative contribution welcomed
3. **Knowledge sharing** - Contributors have resources to understand workflows

**Pattern evolution process:**

```
┌─────────────────────────────────────────────────────────────┐
│  1. INITIATION                                               │
│     Anyone can propose enhancement when system falls short   │
├─────────────────────────────────────────────────────────────┤
│  2. CONSOLIDATION                                            │
│     Evaluate: Does it apply across multiple use cases?       │
├─────────────────────────────────────────────────────────────┤
│  3. DOCUMENTATION                                            │
│     Synchronize across all locations (rules, docs, ADRs)     │
├─────────────────────────────────────────────────────────────┤
│  4. COMMUNICATION                                            │
│     Notify dependent workflows/tools of changes              │
└─────────────────────────────────────────────────────────────┘
```

**Source:** Brad Frost, Design Systems governance research

**Relevance:** Provides process for pattern evolution

---

### Finding 4: Recommended Two-Tier Documentation Approach

**Analysis of current locations and gaps:**

| Location | Purpose | Audience | Current State |
|----------|---------|----------|---------------|
| `.cursor/rules/workflow.mdc` | Must-follow patterns | AI assistants | ✅ Active, has spike pattern |
| `.cursor/rules/main.mdc` | Project identity | AI assistants | ✅ Active |
| `docs/` | User documentation | End users | Exists |
| `admin/decisions/` | ADRs | Developers | Structure exists |
| **`docs/patterns/` (NEW)** | **Pattern library** | **Developers + AI** | **Gap identified** |

**Recommended two-tier approach:**

```
┌─────────────────────────────────────────────────────────────┐
│  TIER 1: Cursor Rules (AI-Discoverable)                     │
│  Location: .cursor/rules/workflow.mdc                        │
│  Content: Concise, must-follow patterns                      │
│  Format: Brief description + when to use                     │
│  Example: Spike determination framework (already added)      │
└─────────────────────────────────────────────────────────────┘
                            │
                            ▼ links to
┌─────────────────────────────────────────────────────────────┐
│  TIER 2: Pattern Library (Detailed Documentation)           │
│  Location: docs/patterns/workflow-patterns.md               │
│  Content: Full pattern documentation with rationale          │
│  Format: Intent, when/when-not, trade-offs, examples         │
│  Includes: Context injection, validation levels, handoffs    │
└─────────────────────────────────────────────────────────────┘
                            │
                            ▼ significant decisions become
┌─────────────────────────────────────────────────────────────┐
│  TIER 3: ADRs (Architectural Decisions)                     │
│  Location: admin/decisions/[topic]/adr-NNN-*.md             │
│  Content: Major architectural choices with full rationale    │
│  When: High-impact, hard-to-reverse decisions                │
│  Example: Unified vs composable architecture                 │
└─────────────────────────────────────────────────────────────┘
```

**Source:** Analysis + best practices synthesis

**Relevance:** Provides clear propagation mechanism

---

### Finding 5: Pattern Discovery Process for New Workflows

**Proposed "Pattern Check" step for explorations:**

Before creating a new workflow or command, check:

```markdown
## 🔍 Pattern Checklist

Before exploring [workflow], verify these established patterns:

### Universal Patterns (from docs/patterns/)
- [ ] **Context Injection**: Does this workflow need context? Use explicit injection.
- [ ] **Validation Levels**: Does this have inputs? Apply L1/L2/L3 validation.
- [ ] **Handoff Pattern**: Does this chain to another workflow? Define handoff file.
- [ ] **Phase 1 Constraint**: Is AI invocation needed? Use --interactive for now.

### Spike Determination
- [ ] High-risk decisions identified?
- [ ] Any decisions that need to be "felt"?
- [ ] Spike candidates flagged?

### Related ADRs
- [ ] Check admin/decisions/ for relevant prior decisions
- [ ] Note any constraints from previous ADRs
```

**Source:** Synthesis of governance + exploration workflow

**Relevance:** Ensures patterns are discovered and followed

---

### Finding 6: Patterns from This Exploration (Concrete)

**Pattern 1: Spike Determination** (already in workflow.mdc)
```
When: High-risk architectural decisions OR UX that needs to be "felt"
Action: Time-boxed (2-4h) prototype before research
Output: Learnings, refined questions, go/no-go
```

**Pattern 2: Explicit Context Injection**
```
When: Workflow output will be used by AI
Action: Inject context visibly at start of output
Format: # CONTEXT section with rules, identity, workflow-specific
Why: User trust ("I can see what the AI sees")
```

**Pattern 3: L1/L2/L3 Validation Levels**
```
L1 (Existence): Required inputs exist → Hard fail
L2 (Structure): Expected sections exist → Warn, proceed
L3 (Content): Key fields populated → Warn, allow continue
Why: Balance between strictness and usability
```

**Pattern 4: Handoff File Contract**
```
When: Workflow chains to another workflow
Action: Define primary handoff file with required sections
Format: research-topics.md (## Topics), research-summary.md (## Key Findings)
Why: Enables reliable workflow automation
```

**Pattern 5: Phase-Based Evolution**
```
Phase 1: Interactive (--interactive, user copies to AI)
Phase 2: Config-assisted (--model, --context-profile)
Phase 3: Fully automated (programmatic AI invocation)
Why: Acknowledges current limitations while planning for future
```

**Source:** This exploration's decisions

**Relevance:** Concrete patterns to document

---

## 🔍 Analysis

### Decision Hierarchy

Not all decisions need the same level of documentation:

| Decision Type | Documentation | Example |
|---------------|---------------|---------|
| **Architectural** | Full ADR | Unified vs composable |
| **Pattern (reusable)** | Pattern library + rules | Validation levels |
| **Local (workflow-specific)** | Exploration/research docs | Template format |

### Propagation Mechanism

```
New Pattern Discovered
        │
        ▼
Is it reusable across workflows?
        │
   ┌────┴────┐
   │ NO      │ YES
   ▼         ▼
Local doc    Add to Tier 1 (workflow.mdc summary)
             Add to Tier 2 (docs/patterns/ detail)
             │
             ▼
        Is it architecturally significant?
             │
        ┌────┴────┐
        │ NO      │ YES
        ▼         ▼
      Done       Create ADR (Tier 3)
```

### Key Insights

- [x] Insight 1: Two-tier approach balances discoverability (AI) with detail (humans)
- [x] Insight 2: Pattern checklist in exploration workflow ensures consistency
- [x] Insight 3: Governance process prevents pattern drift
- [x] Insight 4: Y-statement format useful for quick pattern decisions

---

## 💡 Recommendations

- [x] **R1:** Create `docs/patterns/workflow-patterns.md` for detailed pattern documentation
- [x] **R2:** Add pattern checklist to `/explore` command
- [x] **R3:** Document the 5 patterns from this exploration
- [x] **R4:** Use Y-statement format for quick pattern documentation in rules
- [x] **R5:** Establish pattern evolution process (initiation → consolidation → documentation)

---

## 📋 Requirements Discovered

### Functional Requirements

- [x] **REQ-DP-1:** Universal patterns must be documented in both Cursor rules (summary) and docs/patterns/ (detail)
- [x] **REQ-DP-2:** `/explore` command must include pattern checklist step
- [x] **REQ-DP-3:** New workflows must verify compliance with established patterns
- [x] **REQ-DP-4:** Pattern documentation must include rationale (why, not just what)
- [x] **REQ-DP-5:** Create `docs/patterns/workflow-patterns.md` as pattern library

### Process Requirements

- [x] **REQ-DP-6:** Pattern evolution follows: Initiation → Consolidation → Documentation → Communication
- [x] **REQ-DP-7:** Superseded patterns marked (not deleted) with reason for change
- [x] **REQ-DP-8:** ADRs required for architecturally significant decisions

### Patterns to Document

| Pattern | Location | Priority |
|---------|----------|----------|
| Spike Determination | workflow.mdc ✅, docs/patterns/ | Done (rules), Pending (full) |
| Explicit Context Injection | workflow.mdc, docs/patterns/ | 🔴 HIGH |
| L1/L2/L3 Validation | docs/patterns/ | 🔴 HIGH |
| Handoff File Contract | docs/patterns/ | 🔴 HIGH |
| Phase-Based Evolution | docs/patterns/ | 🟡 MEDIUM |

---

## 🚀 Next Steps

1. ✅ Research complete
2. Create `docs/patterns/workflow-patterns.md`
3. Add pattern checklist to `/explore` command documentation
4. Document the 5 patterns in detail
5. Proceed to decision phase

---

## 🔗 Related

- [Exploration: dt-workflow](../../explorations/dt-workflow/) - Source of patterns
- [Cursor Rules](../../../.cursor/rules/) - Tier 1 pattern location
- [ADR Process](../../decisions/) - Tier 3 decision documentation
- [ADR.github.io](https://adr.github.io/) - ADR best practices

---

**Last Updated:** 2026-01-23
