# dt-workflow v1 Exploration Learnings

**Purpose:** Consolidated learnings from the dt-workflow exploration branch  
**Created:** 2026-02-13  
**Source Branch:** `feat/dt-workflow` (archived as exploration)  
**Status:** 📚 Archive - Learnings for Future Implementation

---

## 📋 Table of Contents

1. [Executive Summary](#executive-summary)
2. [The Spike Workflow (Fast-Track)](#the-spike-workflow-fast-track)
3. [Key Architectural Decisions](#key-architectural-decisions)
4. [Universal Patterns Discovered](#universal-patterns-discovered)
5. [Research Findings](#research-findings)
6. [Meta-Learnings (Agentic Coding)](#meta-learnings-agentic-coding)
7. [What to Preserve](#what-to-preserve)
8. [What to Reconsider](#what-to-reconsider)

---

## Executive Summary

The dt-workflow exploration produced valuable **conceptual frameworks** that should inform future implementation, regardless of final architecture. The implementation itself may be rebuilt, but these learnings are transferable.

**Key Outcomes:**
- ✅ Spike workflow framework (universally applicable)
- ✅ Explore → Research → Decision pipeline formalized
- ✅ Context injection patterns for AI workflows
- ✅ L1/L2/L3 validation tiering
- ✅ Two-tier documentation pattern (AI-discoverable + human-detailed)

**Why Archived (Not Merged):**
Rapid agentic development bypassed important discovery phases. The concepts are sound, but the implementation deserves fresh exploration with deeper understanding of each component.

---

## The Spike Workflow (Fast-Track)

**🚀 PRIORITY: Fast-track this pattern across all projects.**

### What is a Spike?

A **spike** is a time-boxed experiment to answer a specific technical question or reduce risk. Unlike research (which investigates options), a spike **builds something minimal** to validate assumptions.

### Key Characteristics

| Characteristic | Description |
|----------------|-------------|
| **Time-boxed** | 2-4 hours maximum |
| **Throwaway mindset** | Code may be discarded |
| **Learning-focused** | Output is knowledge, not production code |
| **Question-driven** | Clear success criteria before starting |

### When to Spike vs Research

| Situation | Use Spike | Use Research |
|-----------|-----------|--------------|
| Architectural decision with high commitment | ✅ | |
| User-facing UX that needs to be "felt" | ✅ | |
| Technical uncertainty ("can it even work?") | ✅ | |
| Comparing known options | | ✅ |
| Investigating best practices | | ✅ |
| Low-risk, well-understood path | | ✅ |

### Spike Determination Framework

During exploration, assess each topic:

| Risk Level | Determination | Rationale |
|------------|---------------|-----------|
| 🔴 HIGH | **Spike first** | Hard to pivot once committed |
| 🟠 MEDIUM-HIGH | **Consider spike** | Benefits from hands-on validation |
| 🟡 MEDIUM | Research only | Depends on other decisions |
| 🟢 LOW | Research only | Clear path, low risk |

### Spike Outputs

A completed spike should produce:

- **Learnings document:** What we learned, what surprised us
- **Refined questions:** New questions revealed by implementation
- **Go/no-go:** Is the approach validated?
- **Code (optional):** May keep, refactor, or discard

### Integration with Explore → Research → Decision

```
/explore [topic]
    → Identifies spike candidates (risk assessment)
    → Assesses each topic against framework
    
If spike candidate identified:
    → Time-box the implementation (2-4 hours)
    → Build minimal prototype
    → Document learnings
    → Feed learnings back into exploration/research

/research [topic] --from-explore
    → Uses spike learnings to refine questions
    → Some topics may be "spike-validated" (skip formal research)
    
/decision [topic] --from-research
    → Decisions backed by spike evidence have HIGH confidence
```

### Why Spikes Matter for Junior Developers

Spikes are especially valuable as time-boxed "can it work?" sessions. The strict time limit:
- **Removes pressure** to build something perfect
- **Makes failure safe** ("I couldn't figure it out" is a valid answer)
- **Prevents rabbit holes**
- **Provides structured permission to experiment**

---

## Key Architectural Decisions

These decisions were validated through exploration and spike work. They represent the "what" without mandating the "how."

### ADR-001: Unified vs Composable Architecture

**Decision:** Unified command preferred over composable tools for workflow orchestration.

**Y-Statement:** In the context of workflow orchestration, facing the choice between unified vs composable architecture, we decided for unified command to achieve better UX and consistent context injection, accepting less flexibility.

**Key Insight:** The spike demonstrated that `dt-workflow explore topic --interactive` felt natural. Users prefer learning one tool, not many.

**Evidence:**
- Similar tools (Aider, Copilot Workspace) use unified approach
- Single-developer workflow doesn't require composition flexibility
- Context injection works better when centralized

---

### ADR-002: Context Injection Strategy

**Decision:** Full content injection with strategic ordering (START/MIDDLE/END).

**Y-Statement:** In the context of AI context management, facing scalability concerns, we decided for full content injection with ordering to achieve optimal LLM attention and user trust, accepting higher token usage.

**Key Insights:**
- Current scale (~10K tokens) is well within modern LLM limits (100K+)
- "Lost in the middle" problem: Place critical rules at START, task at END
- Full context injection addresses the **trust problem** - users see what's being loaded
- Escape hatch: Switch to hybrid only if hitting performance/limit/cost blockers

---

### ADR-003: Component Integration Pattern

**Decision:** Validation tools stay standalone (CI value), generation becomes internal.

**Y-Statement:** In the context of existing tools integration, facing backward compatibility needs, we decided to keep validation standalone for CI value while internalizing generation, accepting some code restructuring.

**Analysis:**

| Tool | Standalone Value | Recommendation |
|------|------------------|----------------|
| dt-doc-validate | High (CI, pre-commit) | Keep standalone |
| dt-doc-gen | Low (always followed by AI) | Make internal |

---

### ADR-004: Cursor Command Role

**Decision:** Cursor commands are orchestrators; CLI tools handle core logic.

**Y-Statement:** In the context of IDE integration, facing portability requirements, we decided for orchestrator pattern to achieve both portability and IDE integration, accepting indirection complexity.

**Pattern:**
```
User → /explore command (Cursor)
         → calls dt-workflow explore --interactive
         → dt-workflow outputs context + structure
         → Cursor AI fills content
         → dt-workflow validates
```

**Benefits:**
- CLI tools remain portable (no IDE dependency)
- Commands handle IDE-specific concerns
- Both paths supported for different users

---

### ADR-005: Two-Tier Pattern Documentation

**Decision:** Two-tier approach for pattern documentation.

**Y-Statement:** In the context of pattern propagation, facing discoverability and detail needs, we decided for two-tier approach to achieve AI discoverability and human reference, accepting maintenance of multiple locations.

**Tiers:**

| Tier | Location | Purpose | Audience |
|------|----------|---------|----------|
| Tier 1 | `.cursor/rules/*.mdc` | AI-discoverable, concise | AI assistants |
| Tier 2 | `docs/patterns/` | Detailed, with rationale | Human developers |
| Tier 3 | ADRs | Architecturally significant | Future maintainers |

---

## Universal Patterns Discovered

These patterns emerged from the research and are applicable beyond dt-workflow.

### Pattern 1: L1/L2/L3 Validation Levels

**Problem:** Not all validation failures should block execution equally.

**Solution:** Three-tier validation:

| Level | Type | Failure Behavior |
|-------|------|------------------|
| L1 | Existence | Hard fail - missing required input |
| L2 | Structure | Warn - malformed but present |
| L3 | Content | Suggest - quality/completeness issues |

**Application:**
- L1: Does the file exist?
- L2: Does it have required sections?
- L3: Is the content complete and high quality?

---

### Pattern 2: Handoff File Contract

**Problem:** Workflows need to chain together reliably.

**Solution:** Each workflow has a **primary handoff file** that the next workflow depends on.

| Workflow | Handoff File | Required Sections |
|----------|--------------|-------------------|
| explore | `research-topics.md` | Topics table |
| research | `research-summary.md` | Key Findings, Recommendations |
| decision | `decisions-summary.md` | Decisions table |

**Rule:** `--from-*` flags should auto-detect OR accept explicit paths.

---

### Pattern 3: Phase-Based Evolution

**Problem:** Can't build everything at once, but architecture should support future.

**Solution:** Design for Phase 3, implement Phase 1.

| Phase | AI Invocation | Model Selection | Capability |
|-------|---------------|-----------------|------------|
| Phase 1 (Now) | Interactive | Manual | Structure + validate only |
| Phase 2 (Near) | Interactive + config | Config suggests | + model hints |
| Phase 3 (Future) | Programmatic | Automatic | Full end-to-end |

**Key:** Use `--interactive` flag as temporary limitation, not permanent design.

---

### Pattern 4: Explicit Context Injection

**Problem:** Users don't trust implicit rule loading (invisible, unreliable).

**Solution:** Scripts should **explicitly gather and inject** context:
- **Transparency:** User sees what's being loaded
- **Reliability:** Context is explicitly provided every time
- **Auditability:** Context gathering is deterministic, not magical

**Context Types:**

| Type | Example | When to Inject |
|------|---------|----------------|
| Universal | Cursor rules, project identity | Always |
| Workflow-specific | Related explorations, source research | Per workflow |
| Deep context | Large files, history | On request |

---

## Research Findings

### Finding 1: Token Efficiency

**Question:** How do we balance context richness with token limits?

**Answer:** At current scale (~10K tokens), full injection is correct. RAG complexity not justified until hitting blockers.

**"Lost in the Middle" Problem:** LLMs pay more attention to start and end of context. Place:
- Critical rules at START
- Task/instructions at END
- Background context in MIDDLE

---

### Finding 2: Template Structure

**Question:** What makes templates effective for AI?

**Answer:** Structural examples outperform vague placeholders.

**Bad:** `<!-- Describe the problem here -->`  
**Good:** 
```markdown
## Problem Statement

| Aspect | Description |
|--------|-------------|
| What's broken | [Specific behavior] |
| Expected behavior | [What should happen] |
| Impact | [Who is affected and how] |
```

---

### Finding 3: Dynamic Section Management

**Question:** How do we handle variable-length documents?

**Answer:** Metadata-driven section count with differentiation:
- **Ordered sections:** Gaps not acceptable (Phase 1, Phase 2, Phase 3)
- **Unordered sections:** Gaps acceptable (findings may skip numbers)

---

## Meta-Learnings (Agentic Coding)

### The Discovery Problem

**Insight:** Rapid agentic implementation can rob you of the discovery phase.

When AI writes code quickly:
- You don't struggle with edge cases (miss learning)
- You don't explore alternatives (miss options)
- You don't build intuition (miss deep understanding)
- You get a working thing without knowing why it works

**Mitigation strategies:**
1. **Use spikes first** - Build minimal versions yourself
2. **Review AI code line-by-line** - Don't just accept
3. **Deliberately break things** - See what happens
4. **Document your understanding** - Force articulation
5. **Question architectural choices** - Ask "why this way?"

### The Ownership Problem

**Insight:** It's harder to maintain code you didn't write.

When AI generates substantial code:
- Mental model is incomplete
- Debugging is harder (don't know intentions)
- Modifications are risky (don't know implications)

**Mitigation strategies:**
1. **Smaller increments** - Fewer lines, more understanding
2. **Test-first** - Write tests yourself, then AI implements
3. **Architecture yourself** - You design, AI fills in
4. **Refactor to understand** - Touch every line eventually

### When Agentic Coding Works Well

- **Boilerplate** - Repetitive code with clear patterns
- **Exploration** - "Show me how this might work"
- **Research** - Gathering options and trade-offs
- **Refactoring** - Applying known patterns

### When Agentic Coding Needs Caution

- **Architecture** - High-commitment decisions
- **Novel problems** - No established pattern
- **Core business logic** - You need deep understanding
- **Security-critical** - Must verify every line

---

## What to Preserve

These artifacts should be merged/preserved for future reference:

### Documents to Keep
- [ ] This learnings document
- [ ] Spike workflow in `workflow.mdc`
- [ ] ADR templates and patterns
- [ ] Universal patterns (L1/L2/L3, Handoff, Phase-Based)

### Concepts to Apply Elsewhere
- [ ] Spike determination framework (add to all explorations)
- [ ] Two-tier documentation pattern
- [ ] Context injection strategy
- [ ] Validation tiering

---

## What to Reconsider

These aspects should be re-explored with fresh perspective:

### Architecture
- **Unified vs Composable:** Revisit after hands-on component exploration
- **Component boundaries:** What should be a library vs command?
- **Cross-project dependencies:** dev-toolkit ↔ dev-infra relationship

### Implementation
- **Template system:** Start simpler, evolve with needs
- **Context gathering:** May not need full injection at start
- **Validation rules:** Build incrementally as documents are created

### Scope
- **Phase 1 focus:** Maybe even simpler than planned
- **Migration path:** Don't migrate everything at once
- **Feature creep:** Resist the urge to build all phases

---

## Branch Reference

**Original Branch:** `feat/dt-workflow`  
**Archive Tag:** `archive/dt-workflow-v1-exploration` (if created)

**Key Files in Original Branch:**
- `admin/explorations/dt-workflow/` - Initial exploration
- `admin/research/dt-workflow/` - Research findings
- `admin/decisions/dt-workflow/` - ADRs
- `admin/planning/features/dt-workflow/` - Feature plans
- `bin/dt-workflow` - Spike implementation (57KB)

---

**Last Updated:** 2026-02-13
