# Exploration: /explore Command Migration

**Status:** ✅ Expanded  
**Created:** 2026-01-22  
**Expanded:** 2026-01-22

---

## 🎯 What We're Exploring

How to migrate the `/explore` Cursor command from inline templates to using `dt-doc-gen` for document generation and `dt-doc-validate` for validation. This is Sprint 1 because it sets patterns for all subsequent command migrations.

**Context:** This exploration must also consider the broader question of **migration scope and complexity**. Some migrations may require:
- Phased implementation within a single command
- Cross-project coordination between dev-toolkit and dev-infra
- Bulk template changes in dev-infra affecting multiple commands

**Key Trade-off:** We must weigh structured migration approaches against the simpler alternative of inline restructuring. Over-engineering the migration process could be worse than pragmatic, targeted changes.

---

## 🔍 Themes

### Theme 1: Two-Mode Architecture

The /explore command has two distinct modes that fundamentally affect how we approach migration:

**Setup Mode (~60-80 lines):**
- Creates lightweight scaffolding for human review
- Uses `<!-- PLACEHOLDER: -->` markers for expansion points
- Status: `🔴 Scaffolding (needs expansion)`
- Stays on current branch (no worktree)

**Conduct Mode (~200-300 lines):**
- Expands existing scaffolding with detailed analysis
- Fills in placeholders with AI-generated content
- Status: `✅ Expanded`
- Prompts for worktree creation

**Connections:**
- This two-mode pattern may apply to `/research` (Sprint 2) as well
- The mode distinction is a **command-level concern**, not a dt-doc-gen concern
- dt-doc-gen should be "mode-agnostic" - it just generates from templates

**Implications:**
- dt-doc-gen needs a `--mode` parameter OR separate template paths
- The command wrapper (Cursor command) decides which mode/template to invoke
- Validation rules may need to know about mode (scaffolding vs expanded)

**Concerns:**
- Template proliferation: `exploration-setup.tmpl` vs `exploration-conduct.tmpl` vs `exploration.tmpl`
- Should we have 2x templates for every two-mode command?
- **Simpler alternative:** Single template with conditional sections marked by comments

---

### Theme 2: Template Mapping & Gap Analysis

Current inline templates need to map to dev-infra templates. This is where **cross-project coordination** becomes critical.

**Current State:**

| Output File | Dev-infra Template | Variables Needed |
|-------------|-------------------|------------------|
| `README.md` | `exploration/README.tmpl` | TOPIC_NAME, TOPIC_TITLE, DATE |
| `exploration.md` | `exploration/exploration.tmpl` | TOPIC_NAME, TOPIC_TITLE, DATE, STATUS, THEMES |
| `research-topics.md` | `exploration/research-topics.tmpl` | TOPIC_NAME, DATE, TOPICS |

**Gap Analysis Required:**
1. Read actual dev-infra templates (haven't been inspected yet)
2. Compare to inline templates in `/explore` command
3. Document missing variables, sections, markers

**Connections:**
- If gaps exist, we have two options:
  - **Option A:** PR to dev-infra to add missing elements
  - **Option B:** Local template overrides in dev-toolkit
- The iteration plan recommends Option A (batched PRs per sprint)

**Implications:**
- First sprint sets the template change pattern for all subsequent sprints
- Need clear criteria for "when to PR to dev-infra vs local override"
- **Bulk template changes** in dev-infra could affect multiple commands at once

**Concerns:**
- Template drift: dev-toolkit overrides diverging from dev-infra originals
- Coordination overhead: PRs to dev-infra slow down iteration
- **Counter-argument:** Maybe inline templates are fine if changes are small

---

### Theme 3: Input Source Handling

The /explore command is unique: it's the **only command that handles unstructured input**. This makes it the "thought organizer" that transforms raw ideas into structured exploration.

**Input Sources:**
- Raw text (`--input "text..."` or `--input file.txt`)
- start.txt (`--from-start`)
- Reflection files (`--from-reflect`)
- Interactive (topic name only)

**Theme Extraction Process:**
1. Parse input for distinct ideas, concerns, topics
2. Group related thoughts into thematic clusters
3. Name themes with descriptive titles
4. Extract questions for research-topics.md

**Connections:**
- Theme extraction is **AI work**, not template work
- dt-doc-gen receives pre-extracted themes as variables
- The command wrapper does the AI work, dt-doc-gen does the formatting

**Implications:**
- Variable population is the command's responsibility
- dt-doc-gen just needs: `THEMES`, `QUESTIONS`, `TOPIC_NAME`, `DATE`
- The intelligence stays in Cursor, the structure comes from templates

**Concerns:**
- If theme extraction changes, do templates need to change?
- How flexible should template structure be for varying numbers of themes?
- **Array variables:** Can dt-doc-gen handle `THEMES` as an array and iterate?

---

### Theme 4: AI Expansion Zones & Markers

The /explore command uses AI to expand scaffolding. How do templates support this?

**Current Markers:**
- `<!-- PLACEHOLDER: Expand with detailed analysis in conduct mode -->` - Human instruction
- `<!-- AI: -->` - Marker for AI expansion points (dev-infra convention)
- `<!-- EXPAND: -->` - Alternative marker for expansion

**Connections:**
- Setup Mode generates documents WITH placeholders
- Conduct Mode should EXPAND placeholders (not regenerate from scratch)
- dt-doc-gen generates initial structure; Cursor AI expands it

**Implications:**
- Templates need clear marker convention for AI expansion
- dt-doc-validate could warn if placeholders remain after Conduct Mode
- The expansion process is **Cursor's job**, not dt-doc-gen's

**Concerns:**
- Marker proliferation: too many marker types
- Should dt-doc-gen preserve markers or replace them?
- **Simpler approach:** Cursor reads scaffolding, regenerates with expanded content (no marker parsing)

---

### Theme 5: Validation Rules & Mode-Aware Strictness

Generated explorations need validation, but strictness should depend on mode.

**Setup Mode Validation (Lenient):**
- Required sections present (but may have placeholders)
- Status indicator shows `🔴 Scaffolding`
- Links valid (README → exploration.md)
- Placeholders are ALLOWED

**Conduct Mode Validation (Strict):**
- Required sections present AND filled in
- Status indicator shows `✅ Expanded`
- NO placeholders remaining
- Content has minimum length/depth

**Connections:**
- Validation rules in dev-infra define section requirements
- dt-doc-validate could check status field to determine strictness
- Or: separate rule sets (`exploration-setup.yaml` vs `exploration.yaml`)

**Implications:**
- Status-aware validation is more elegant (single rule set, mode detection)
- Alternative: explicit `--mode` flag to dt-doc-validate

**Concerns:**
- Over-complexity: Is mode-aware validation worth it?
- **Simpler approach:** One rule set, manual review for scaffolding documents

---

### Theme 6: Worktree Integration

The /explore command integrates with worktree workflow per ADR-002.

**Current Behavior:**
- Setup Mode: Stays on current branch (lightweight, acceptable to abandon)
- Conduct Mode: Prompts for worktree creation (serious investment)

**Connections:**
- Worktree is a **command concern**, not dt-doc-gen concern
- dt-doc-gen doesn't know or care about git branches
- The command wrapper handles worktree prompting

**Implications:**
- Migration doesn't change worktree behavior
- Worktree logic stays in Cursor command, not dev-toolkit CLI
- This theme is **out of scope** for dt-doc-gen migration

**Concerns:**
- None significant - clean separation of concerns

---

### Theme 7: Migration Scope & Phasing (NEW)

**Critical Question:** Should we migrate everything at once, or in phases?

**Full Migration (All-at-Once):**
- Replace all inline templates with dt-doc-gen calls
- Remove fallback code
- Single PR, single validation

**Phased Migration:**
- Phase 1: dt-doc-gen generates, inline templates as fallback
- Phase 2: Validate dt-doc-gen output, gradually remove fallbacks
- Phase 3: Full cutover, remove all inline templates

**Connections:**
- Iteration plan suggests phased approach with fallbacks
- Each command sprint could follow same phasing
- Cross-project work (dev-infra PRs) adds coordination points

**Implications:**
- Phased approach reduces risk but increases complexity
- Need clear criteria for "when is a phase complete?"
- Fallback code adds maintenance burden during transition

**Concerns:**
- Phasing could become over-engineering
- **Counter-argument:** If inline templates work, why change them at all?
- Need to weigh migration benefit vs cost

---

### Theme 8: Cross-Project Coordination (NEW)

**The Reality:** Migration involves two repositories:
- **dev-toolkit:** CLI tools (dt-doc-gen, dt-doc-validate)
- **dev-infra:** Templates and validation rules

**Coordination Scenarios:**

1. **Template Gap Found:**
   - Option A: PR to dev-infra (slow, shared benefit)
   - Option B: Local override in dev-toolkit (fast, local only)

2. **Bulk Template Changes:**
   - Example: Add `<!-- AI: -->` markers to ALL templates
   - This would be a dev-infra PR affecting multiple commands at once
   - Should be done BEFORE command migrations, or as part of Sprint 1?

3. **Validation Rule Updates:**
   - Similar trade-off: dev-infra PR vs local override

**Connections:**
- Iteration plan recommends "PR per sprint" for batched changes
- Local overrides enable fast iteration but create drift
- Long-term goal: dev-toolkit uses dev-infra templates directly

**Implications:**
- Sprint 1 (/explore) should establish the coordination pattern
- May need "dev-infra prep work" before migrations begin
- Clear ownership: who decides template changes?

**Concerns:**
- Coordination overhead could kill velocity
- **Simpler approach:** Accept that dev-toolkit has its own templates (fork, not dependency)

---

### Theme 9: Over-Engineering vs Pragmatic Restructuring (NEW)

**The Meta-Question:** Are we over-engineering this?

**Signs of Over-Engineering:**
- Multiple phases for a "simple" template swap
- Complex mode-aware validation rules
- Cross-project PRs for minor template tweaks
- Elaborate fallback/migration strategies

**Signs of Under-Engineering:**
- Inline templates that are hard to maintain
- No validation (bugs in generated documents)
- No consistency across commands
- Duplicated template code

**The Balance:**

| Approach | Pros | Cons |
|----------|------|------|
| **Full Migration** | Consistency, validation, single source | High effort, coordination overhead |
| **Partial Migration** | Gradual, lower risk | Mixed codebase, longer transition |
| **Inline Restructuring** | Fast, local changes | No validation, duplication |
| **No Change** | Zero effort | Status quo problems remain |

**Recommendation Questions:**
1. What problem are we actually solving?
2. What's the minimum viable change?
3. Can we validate the approach with /explore before committing to all 6 commands?

---

## ❓ Key Questions

### Question 1: Two-Mode Template Strategy

**Context:** The /explore command has Setup and Conduct modes that produce different output. How should dt-doc-gen handle this?

**Sub-questions:**
- Should dt-doc-gen have a `--mode` parameter?
- Should we have separate templates per mode?
- Should templates have conditional sections?

**Research Approach:**
- Review how other tools handle mode-based generation
- Prototype both approaches and compare complexity
- Check if dev-infra templates already support modes

---

### Question 2: Variable Gap Analysis

**Context:** We don't know what dev-infra templates actually contain. A gap analysis is required.

**Sub-questions:**
- What variables do dev-infra exploration templates expect?
- What variables does /explore currently use in inline templates?
- Can dt-doc-gen handle array variables (for themes, questions)?

**Research Approach:**
- Read dev-infra templates directly
- Document current inline template variables
- Create comparison matrix

---

### Question 3: Where Does AI Work Happen?

**Context:** The /explore command extracts themes and questions from unstructured input using AI. Where does this intelligence live?

**Sub-questions:**
- Is theme extraction a Cursor command responsibility?
- Does dt-doc-gen need any AI integration?
- How do we pass extracted themes as variables?

**Research Approach:**
- Map the current /explore data flow
- Identify AI vs template work boundaries
- Document variable handoff points

---

### Question 4: Is This Worth Migrating?

**Context:** The migration involves cross-project coordination, template changes, and validation setup. Is the benefit worth the cost?

**Sub-questions:**
- What problems do inline templates cause today?
- What benefits does dt-doc-gen provide?
- What's the minimum viable migration?

**Research Approach:**
- Document current pain points (if any)
- Estimate migration effort
- Compare to "just restructure inline" alternative

---

## 💡 Initial Thoughts

**The core value proposition:** Using dt-doc-gen and dt-doc-validate provides:
1. **Validation:** Catch malformed documents before they're committed
2. **Consistency:** All commands use the same templates
3. **Maintainability:** Templates are in one place (dev-infra), not scattered in commands
4. **Testing:** CLI tools can be tested; inline templates in commands cannot

**The core risk:** This migration could be over-engineered. The iteration plan describes a sophisticated phased approach, but if inline templates work fine today, is the investment worth it?

**Opportunities:**
- Sprint 1 (/explore) is a forcing function to validate the approach
- If /explore migration is painful, we can simplify for subsequent sprints
- Early failure is cheap; late failure is expensive

**Concerns:**
- Cross-project coordination (dev-infra PRs) adds friction
- Mode-aware validation may be unnecessary complexity
- Phased migration with fallbacks creates a long transition period

---

## 🚀 Next Steps

1. **Research Topic 2 (Variable Gap Analysis):** Read dev-infra templates, compare to /explore inline templates
2. **Research Topic 4 (Is This Worth It?):** Document current pain points, estimate effort
3. **Prototype:** Try a minimal dt-doc-gen integration for /explore Setup Mode
4. **Decision Point:** Based on prototype, decide if full migration or simpler approach

---

## 🔗 Related Documents

- [Command Migrations Hub](../README.md)
- [Iteration Plan](../../../research/doc-infrastructure/iteration-plan.md)
- [Research](../../../research/command-migrations/explore/README.md)
- [dt-doc-gen Phase 2](../../../planning/features/doc-infrastructure/phase-2.md)
- [dt-doc-validate Phase 3](../../../planning/features/doc-infrastructure/phase-3.md)

---

**Last Updated:** 2026-01-22
