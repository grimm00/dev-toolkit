# Workflow Patterns Library

**Purpose:** Universal patterns for dt-workflow and future workflow tools  
**Status:** ✅ Active  
**Created:** 2026-01-22  
**Last Updated:** 2026-01-22

---

## 📋 Overview

This document captures universal patterns discovered during dt-workflow development. These patterns apply across all workflow commands and should be followed when building new workflows.

**Patterns:** 5 universal patterns  
**Source:** dt-workflow exploration, research, and spike validation

---

## 📖 How to Use This Document

1. **Before building a new workflow:** Review applicable patterns
2. **When making decisions:** Check if an existing pattern applies
3. **When discovering new patterns:** Add them following the format below

**Pattern Format:**
- Intent (what problem it solves)
- When to Use / When NOT to Use
- Pattern description
- Rationale (Y-statement)
- Examples

---

## Pattern 1: Spike Determination

### Intent

Determine when to prototype ("spike") vs when to research formally, reducing wasted effort on either over-analysis or under-validated implementations.

### When to Use

- High-risk architectural decisions (hard to pivot once committed)
- User-facing UX that needs to be "felt"
- Technical uncertainty ("can it even work?")
- Decisions with high pivot cost

### When NOT to Use

- Low-risk decisions with clear paths
- Pure comparison of known options
- Investigation of best practices
- Well-understood approaches

### Pattern

```
During exploration, assess each decision topic:

┌─────────────────────────────────────────────────────────────┐
│  Risk Level Assessment                                       │
├─────────────────────────────────────────────────────────────┤
│  🔴 HIGH risk    → Spike first (prototype before research)  │
│  🟠 MEDIUM-HIGH  → Consider spike (may benefit from feeling)│
│  🟡 MEDIUM       → Research only (depends on other decisions)│
│  🟢 LOW          → Research only (clear path, low risk)     │
└─────────────────────────────────────────────────────────────┘

Spike Characteristics:
- Time-boxed: 2-4 hours maximum
- Throwaway mindset: Code may be discarded
- Learning-focused: Output is knowledge, not production code
- Question-driven: Clear success criteria before starting

Spike Outputs:
- Learnings document (what we learned, what surprised us)
- Refined questions (new questions revealed by implementation)
- Go/no-go decision (is the approach validated?)
```

### Rationale

> In the context of feature development, facing uncertainty about architectural decisions, we decided for spike-first approach on high-risk topics to achieve early validation and reduced pivot cost, accepting time spent on potentially throwaway code.

### Examples

**dt-workflow exploration:**

| Topic | Risk | Determination |
|-------|------|---------------|
| Unified vs Composable | 🔴 HIGH | Spike first |
| Phase 1 Interface | 🟠 MEDIUM-HIGH | Spike first |
| Context Gathering | 🟡 MEDIUM | Consider spike |
| Validation Standalone | 🟢 LOW | Research only |

**Spike result:** Built minimal `dt-workflow explore --interactive` in 3 hours. Validated unified architecture and Phase 1 UX. Revealed new questions about context scalability.

### Related

- [ADR-001: Unified Architecture](../admin/decisions/dt-workflow/adr-001-unified-architecture.md)
- [Workflow Rules: Spike Workflow](../.cursor/rules/workflow.mdc)

---

## Pattern 2: Explicit Context Injection

### Intent

Make AI context visible to users, building trust that the AI is following project rules and receiving relevant information.

### When to Use

- Any workflow that outputs content for AI consumption
- When user trust in AI behavior is important
- When debugging AI responses (need to see what AI saw)

### When NOT to Use

- Internal tools not consumed by AI
- When context is truly implicit and unchangeable

### Pattern

```
Output Structure:

┌─────────────────────────────────────────────────────┐
│  # CONTEXT                                          │
│                                                     │
│  ## Cursor Rules (Universal Context)                │
│  [Full content of .cursor/rules/*.mdc]              │
│                                                     │
│  ## Project Identity (Universal Context)            │
│  [Roadmap, admin structure]                         │
│                                                     │
│  ## Workflow-Specific Context                       │
│  [Related documents, existing work]                 │
│                                                     │
│  ---                                                │
│  # TASK                                             │
│  [What the AI should do]                            │
└─────────────────────────────────────────────────────┘

Key Principles:
- Explicit > Implicit: User can see what AI receives
- Universal context always included: Rules, project identity
- Workflow-specific context as needed: Varies by workflow type
- Full content preferred: Don't summarize rules
```

### Rationale

> In the context of AI-assisted workflows, facing user trust concerns about implicit rules, we decided for explicit context injection to achieve transparency and debuggability, accepting higher token usage.

### Examples

**dt-workflow explore output:**
```markdown
# dt-workflow Output: explore my-feature

**Mode:** --interactive (Phase 1)
**Generated:** 2026-01-22 14:30

---

# CONTEXT

## Cursor Rules (Universal Context)

These rules define project standards and must always be followed.

### main.mdc
[Full content...]

### workflow.mdc
[Full content...]

## Project Identity
[Roadmap, admin README...]

---

# TASK
[Generated structure...]
```

### Related

- [ADR-002: Context Injection Strategy](../admin/decisions/dt-workflow/adr-002-context-injection.md)
- [Research: Context Gathering](../admin/research/dt-workflow/research-context-gathering.md)

---

## Pattern 3: L1/L2/L3 Validation Levels

### Intent

Balance strictness with usability in input validation. Fail hard on critical issues, warn on less critical ones, allowing users to proceed with awareness.

### When to Use

- Any workflow with input requirements
- Workflow chaining (one workflow's output is another's input)
- When user experience matters (not just correctness)

### When NOT to Use

- Simple commands with no inputs
- When all validation must be strict (security-critical)

### Pattern

```
Validation Levels:

┌─────────────────────────────────────────────────────────────┐
│  L1: EXISTENCE (Hard Fail)                                  │
│  - Required files/directories exist                          │
│  - Critical dependencies present                             │
│  - Action: Exit with actionable error message                │
│  - Example: "Missing research-topics.md. Run /explore first."│
├─────────────────────────────────────────────────────────────┤
│  L2: STRUCTURE (Warn, Proceed)                              │
│  - Expected sections exist                                   │
│  - File format correct                                       │
│  - Action: Warn, continue with available data                │
│  - Example: "Missing ## Topics section. Proceeding anyway."  │
├─────────────────────────────────────────────────────────────┤
│  L3: CONTENT (Warn, Allow Continue)                         │
│  - Key fields populated                                      │
│  - Content meets expectations                                │
│  - Action: Inform, allow user to continue                    │
│  - Example: "No topics defined. Add topics first?"           │
└─────────────────────────────────────────────────────────────┘

Error Message Format:
- State what's wrong clearly
- Suggest corrective action
- Use 💡 for suggestions

Example:
❌ Error: Exploration directory not found: admin/explorations/my-topic

💡 Suggestion: Run '/explore my-topic' first to create the exploration
```

### Rationale

> In the context of workflow validation, facing the trade-off between strictness and usability, we decided for three-level validation to achieve both correctness and user-friendliness, accepting slightly more complex validation logic.

### Examples

**dt-workflow validation implementation:**
```bash
# L1: Existence checks (hard fail)
if [ ! -d "$exp_dir" ]; then
    dt_print_status "ERROR" "Exploration directory not found: $exp_dir"
    echo ""
    echo "💡 Suggestion: Run '/explore $topic' first"
    exit 1
fi

# L2: Structure checks (warn, proceed)
if ! grep -q "## 📋 Research Topics" "$research_topics"; then
    dt_print_status "WARNING" "Missing expected section"
    echo "   Proceeding anyway, but structure may be incomplete."
fi

# L3: Content checks (warn, allow continue)
if [ "$topic_count" -eq 0 ]; then
    dt_print_status "WARNING" "No topics found"
    echo "   You may want to add topics before continuing."
fi
```

### Related

- [ADR-002: Context Injection](../admin/decisions/dt-workflow/adr-002-context-injection.md)
- [Research: Workflow I/O Specs](../admin/research/dt-workflow/research-workflow-io-specs.md)

---

## Pattern 4: Handoff File Contract

### Intent

Enable reliable workflow chaining by defining the primary file and required sections that each workflow produces for the next workflow.

### When to Use

- Any workflow that chains to another workflow
- When building workflow orchestration
- When automation depends on predictable output

### When NOT to Use

- Standalone tools with no downstream consumers
- Ad-hoc scripts not part of workflow chain

### Pattern

```
Handoff Contract:

┌───────────────────────────────────────────────────────────────┐
│  Each workflow produces ONE primary handoff file              │
│  Handoff file has REQUIRED SECTIONS for next workflow         │
│  Next workflow can VALIDATE handoff file exists and is valid  │
└───────────────────────────────────────────────────────────────┘

Workflow Chain:

explore  →  research-topics.md  →  /research
               Required: ## Topics table
               
research →  research-summary.md →  /decision  
               Required: ## Key Findings, ## Recommendations
               
decision →  decisions-summary.md → /transition-plan
               Required: ## Decisions table
               
transition → feature-plan.md    → Implementation
               Required: ## Phases table

Handoff File Requirements:
- Machine-parseable sections (tables preferred)
- Status tracking built-in
- "Next Steps" section pointing to next workflow
- Consistent section headers (exact match for parsing)
```

### Rationale

> In the context of workflow automation, facing the need for reliable chaining, we decided for explicit handoff file contracts to achieve predictable workflow transitions, accepting the overhead of maintaining standard formats.

### Examples

**research-topics.md (handoff from explore to research):**
```markdown
## 📋 Research Topics

| # | Topic | Priority | Status |
|---|-------|----------|--------|
| 1 | Context Gathering | HIGH | Pending |
| 2 | Workflow I/O | HIGH | Pending |

## 🚀 Next Steps

1. Run `/research topic --from-explore topic` to conduct research
```

**research-summary.md (handoff from research to decision):**
```markdown
## 🔍 Key Findings

### Finding 1: [Title]
[Summary...]

## 💡 Recommendations

1. [Recommendation...]

## 🚀 Next Steps

1. Run `/decision topic --from-research` to make decisions
```

### Related

- [Research: Workflow I/O Specs](../admin/research/dt-workflow/research-workflow-io-specs.md)
- [ADR-002: Context Injection](../admin/decisions/dt-workflow/adr-002-context-injection.md)

---

## Pattern 5: Phase-Based Evolution

### Intent

Acknowledge current technical limitations while planning for future capabilities. Build incrementally without over-engineering for features that don't exist yet.

### When to Use

- When ideal implementation isn't currently possible
- When external dependencies may change (APIs, tools)
- Long-term feature development

### When NOT to Use

- Simple features with no evolution path
- When current implementation is final

### Pattern

```
Phase Evolution Model:

┌─────────────────────────────────────────────────────────────┐
│  Phase 1: INTERACTIVE (Current Limitations)                 │
│  - Manual AI invocation (user copies output to AI)          │
│  - Manual model selection                                    │
│  - Basic error handling                                      │
│  - Focus: Validate UX and workflow                          │
├─────────────────────────────────────────────────────────────┤
│  Phase 2: CONFIG-ASSISTED                                   │
│  - Configuration-based model selection                       │
│  - Context profiles                                          │
│  - Enhanced validation                                       │
│  - Focus: Reduce manual steps                               │
├─────────────────────────────────────────────────────────────┤
│  Phase 3: FULLY AUTOMATED                                   │
│  - Programmatic AI invocation                               │
│  - Automatic model selection                                │
│  - End-to-end workflow                                      │
│  - Focus: Complete automation                               │
└─────────────────────────────────────────────────────────────┘

Design Principles:
- Build for current phase, design for next
- Don't over-engineer for unavailable features
- Make phase transitions easy (clean interfaces)
- Document phase limitations clearly
```

### Rationale

> In the context of tool evolution, facing current limitations (no programmatic AI invocation), we decided for phase-based approach to achieve useful tools now while preparing for future capabilities, accepting that some features will be manual initially.

### Examples

**dt-workflow Phase 1 implementation:**
```bash
# Phase 1: Interactive mode required
if [ "$interactive" != true ]; then
    dt_print_status "ERROR" "Phase 1 requires --interactive mode"
    echo ""
    echo "Phase 1 (current): Script outputs context + structure for manual AI fill"
    echo "Phase 3 (future):  Script will invoke AI directly"
    exit 1
fi
```

**Phase 1 help text:**
```
Phase 1 Limitations:
    This implements Phase 1 (interactive mode only).
    - AI invocation is manual (you run this, then use output with Cursor)
    - Model selection is manual (recommended: claude-opus-4)
    - Full automation (Phase 3) requires programmatic AI invocation
```

### Related

- [ADR-001: Unified Architecture](../admin/decisions/dt-workflow/adr-001-unified-architecture.md)
- [Research: Context Gathering](../admin/research/dt-workflow/research-context-gathering.md)

---

## 🔄 Pattern Evolution Process

When discovering or updating patterns:

```
1. INITIATION
   Anyone can propose enhancement when system falls short
   
2. CONSOLIDATION
   Evaluate: Does it apply across multiple use cases?
   If yes → continue. If no → document as workflow-specific.
   
3. DOCUMENTATION
   Add to this file (Tier 2)
   Add summary to .cursor/rules/workflow.mdc (Tier 1)
   Create ADR if architecturally significant (Tier 3)
   
4. COMMUNICATION
   Update dependent workflows
   Note in changelog
```

---

## 🔗 Related Documents

- **Tier 1 (AI-discoverable):** [.cursor/rules/workflow.mdc](../.cursor/rules/workflow.mdc)
- **Tier 3 (ADRs):** [admin/decisions/dt-workflow/](../admin/decisions/dt-workflow/)
- **Research:** [admin/research/dt-workflow/](../admin/research/dt-workflow/)

---

**Last Updated:** 2026-01-22
