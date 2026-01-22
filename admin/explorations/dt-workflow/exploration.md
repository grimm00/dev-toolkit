# Exploration: dt-workflow - Unified Workflow Orchestration

**Status:** ✅ Expanded  
**Created:** 2026-01-22  
**Expanded:** 2026-01-22

---

## 🎯 What We're Exploring

We've built document infrastructure tools (dt-doc-gen, dt-doc-validate) as standalone components. But the **real value** comes from the complete pipeline:

```
Generate Structure → AI Fills Content → Validate Output → Commit
```

This exploration examines whether to build a unified `dt-workflow` command that orchestrates this entire pipeline, or continue with separate tools composed by Cursor commands.

The question emerged after completing Phase 2 (dt-doc-gen) and Phase 3 (dt-doc-validate) when we realized the individual tools, while functional, don't capture the full workflow vision documented in dev-infra research. That research outlined a three-phase evolution from interactive AI usage to fully programmatic workflow orchestration.

**Core tension:** Individual tools are simpler to build and test, but the real user value comes from the complete pipeline. Do we optimize for developer experience (composable tools) or user experience (unified workflow)?

---

## 🔍 Themes

### Theme 1: Architecture Vision - Unified vs Composable

The fundamental architectural question is whether dt-workflow should be a monolithic command or an orchestrator of composable tools.

**Current architecture (separate tools):**
```
┌─────────────┐     ┌──────────────┐     ┌─────────────────┐
│ dt-doc-gen  │ ──► │ Cursor AI    │ ──► │ dt-doc-validate │
│ (structure) │     │ (fills)      │     │ (checks)        │
└─────────────┘     └──────────────┘     └─────────────────┘
      ▲                    ▲                     ▲
      │                    │                     │
      └──────── Cursor command composes ─────────┘
```

**Proposed architecture (unified workflow):**
```
┌────────────────────────────────────────────────────────────┐
│                       dt-workflow                           │
│  ┌───────────┐   ┌───────────┐   ┌───────────┐   ┌──────┐ │
│  │ structure │ → │ invoke-ai │ → │ validate  │ → │ git  │ │
│  │ (internal)│   │ (internal)│   │ (internal)│   │commit│ │
│  └───────────┘   └───────────┘   └───────────┘   └──────┘ │
└────────────────────────────────────────────────────────────┘
         ▲
         │
    Single command: dt-workflow explore [topic]
```

**Analysis of trade-offs:**

| Aspect | Unified | Composable |
|--------|---------|------------|
| User Experience | Single command, clear workflow | Multiple steps, more flexibility |
| Testing | Integration tests needed | Unit tests per tool |
| Maintenance | One codebase | Multiple tools to update |
| Flexibility | Opinionated workflow | Mix-and-match |
| Error Handling | Atomic operations | Per-step recovery |

**Examples from other tools:**
- **Aider:** Unified - handles edit→commit in one session
- **Copilot Workspace:** Unified - spec→plan→implement→PR
- **Unix Philosophy:** Composable - small tools, pipes
- **Git:** Hybrid - `git commit -am` combines add+commit

**Connections:**
- Relates to Theme 3 (AI Invocation) - unified enables end-to-end automation
- Relates to Theme 4 (Cursor Commands) - determines command role

**Implications:**
- Unified architecture requires AI invocation strategy (Phase 3 dependency)
- Composable maintains current flexibility but fragments UX
- Hybrid (Option C) may offer best of both worlds

**Concerns:**
- Unified may be over-engineering for current needs
- Composable may never achieve the full vision
- Hybrid risks maintaining two interfaces

---

### Theme 2: Standalone vs Internal Components

This theme examines whether dt-doc-gen and dt-doc-validate should remain standalone tools or become internal components of dt-workflow.

**dt-doc-validate standalone value analysis:**

| Use Case | Frequency | Standalone Required? |
|----------|-----------|---------------------|
| CI pipeline validation | High | Yes - runs without user |
| Pre-commit hooks | High | Yes - automated |
| Manual document checking | Medium | Helpful but not required |
| Post-generation validation | High | Can be internal |

**Conclusion:** dt-doc-validate has clear standalone value for CI/automation.

**dt-doc-gen standalone value analysis:**

| Use Case | Frequency | Standalone Required? |
|----------|-----------|---------------------|
| Generate for AI fill | High | No - always followed by AI |
| Generate for human fill | Low | Rare use case |
| Template testing | Low | Could use test harness |
| Structure preview | Medium | Could be dt-workflow flag |

**Conclusion:** dt-doc-gen has minimal standalone value - always part of workflow.

**Three options analyzed:**

**Option 1: Both standalone (current)**
- Pros: Maximum flexibility, already built
- Cons: No unified experience, commands must compose

**Option 2: Validate standalone, gen internal (recommended)**
- Pros: CI keeps working, gen becomes internal detail
- Cons: dt-doc-gen CLI becomes deprecated
- Pattern: `dt-doc-validate` standalone, `lib/doc-gen/` as library

**Option 3: Both internal**
- Pros: Simplest architecture
- Cons: Loses CI validation, must export functions

**Connections:**
- Theme 1 architecture decision affects this
- Theme 7 (project location) affects library organization

**Implications:**
- Option 2 means dt-doc-gen becomes a library, not a command
- dt-doc-validate gains importance as the primary standalone tool
- Future dt-workflow uses lib/doc-gen internally

**Concerns:**
- Deprecating dt-doc-gen may confuse users who just learned it
- Library extraction requires some refactoring
- Need clear migration path

---

### Theme 3: AI Invocation Model

This is the most technically complex theme, as it determines what dt-workflow can actually do today vs in the future.

**From dev-infra research - three phases:**

| Phase | AI Invocation | Model Selection | dt-workflow Capability |
|-------|---------------|-----------------|------------------------|
| Phase 1 (Now) | Interactive in Cursor | Manual (Cursor settings) | Generate structure only |
| Phase 2 (Near) | Interactive + config | Config suggests model | Generate + suggest model |
| Phase 3 (Future) | Programmatic (Aider/LLM CLI) | Automatic per task type | Full end-to-end |

**Key insight:** Cursor CLI doesn't support programmatic agent invocation (yet).

**Phase 1 Interface Design Options:**

**Option A: Interactive Mode**
```bash
dt-workflow explore topic --interactive
# Opens Cursor with structure, user sees AI fill interactively
# dt-workflow validates after AI completes
```
- Pros: Clear workflow, single entry point
- Cons: Still requires manual steps, "interactive" is vague

**Option B: Two-Step Mode**
```bash
dt-workflow gen topic      # Step 1: Generate structure
# User runs AI manually
dt-workflow validate       # Step 2: Validate result
```
- Pros: Explicit steps, works without Cursor integration
- Cons: Lost context between steps, not unified

**Option C: Cursor-Only Mode**
```bash
# dt-workflow only invoked from Cursor commands
/explore topic  # Cursor command calls dt-workflow internally
```
- Pros: Clean separation, commands own interaction
- Cons: dt-workflow not usable standalone, commands required

**Recommended:** Design for Phase 3, implement Phase 1 compatibility.

```bash
# Phase 1: --interactive flag for current limitations
dt-workflow explore topic --interactive

# Phase 3: Full automation (future)
dt-workflow explore topic --model claude-opus-4
```

**Connections:**
- Theme 1 (architecture) - unified requires AI invocation
- Theme 6 (model selection) - Phase 3 needs model config

**Implications:**
- Phase 1 dt-workflow is "structure + validate" only
- Full value unlocked in Phase 3
- Interface should be designed for Phase 3 now

**Concerns:**
- Phase 1 may feel incomplete ("why not just use dt-doc-gen?")
- Phase 3 timeline unknown (depends on Cursor API or Aider integration)
- Risk of building for future that doesn't arrive

---

### Theme 4: Cursor Command Future

This theme examines what happens to existing Cursor commands (/explore, /research, etc.) when dt-workflow exists.

**Current state:** 6+ Cursor commands with inline templates
- /explore, /research, /decision, /transition-plan, /task-phase, /fix-batch

**Four options analyzed:**

**Option A: Commands as Wrappers**
```
/explore [topic]
  → calls: dt-workflow explore [topic] --interactive
  → dt-workflow generates structure
  → AI (in Cursor) fills content
  → dt-workflow validates
```
- Pros: Commands become thin, dt-workflow owns logic
- Cons: Duplication if both command and CLI work

**Option B: Commands as Orchestrators (recommended)**
```
# Via Cursor command (Phase 1)
/explore [topic]  # Cursor handles AI interaction

# OR via CLI directly (Phase 3)
dt-workflow explore [topic] --model claude-opus-4
```
- Pros: Both paths supported, natural evolution
- Cons: Two interfaces to document

**Option C: Commands Deprecated**
```
# CLI only, commands removed
dt-workflow explore [topic]
dt-workflow research [topic] --from-explore
```
- Pros: Single interface, no duplication
- Cons: Loses Cursor-native experience, migration pain

**Option D: Parallel Existence**
- Commands and dt-workflow both exist for different use cases
- Pros: Maximum flexibility
- Cons: Confusing, maintenance burden

**Analysis:** Option B (Orchestrators) aligns with phased approach:
- Phase 1: Commands orchestrate, dt-workflow provides structure/validation
- Phase 3: dt-workflow can run standalone, commands become optional

**Connections:**
- Theme 3 (AI invocation) determines Phase 1 vs 3 split
- Command migrations exploration may be superseded

**Implications:**
- Commands gain value as "Cursor-native" interface
- dt-workflow gains value as "automation-ready" interface
- Both serve different users/contexts

**Concerns:**
- Documenting two paths adds complexity
- Risk of drift between command and CLI behavior
- Need clear guidance on when to use which

---

### Theme 5: Naming & Organization

This theme addresses whether dt-workflow fits within "doc-infrastructure" or represents a scope expansion.

**Current state:**
- Worktree: `feat/doc-infrastructure`
- Scope: dt-doc-gen + dt-doc-validate
- Focus: Document generation and validation

**If dt-workflow added:**
- Scope expands to: workflow orchestration, AI invocation, git integration
- No longer just "doc infrastructure"

**Four naming options:**

**Option 1: Keep name (doc-infrastructure includes dt-workflow)**
- Pros: No renaming overhead, continuous work
- Cons: Name doesn't reflect expanded scope

**Option 2: Rename worktree/feature**
- New name: `dev-workflow` or `workflow-orchestration`
- Pros: Accurate naming
- Cons: Git branch rename complexity, PR history

**Option 3: New feature (recommended)**
- Close doc-infrastructure as complete (dt-doc-gen, dt-doc-validate done)
- Start new feature for dt-workflow
- Pros: Clean separation, clear milestones
- Cons: Context switch, need new worktree

**Option 4: Split**
- dt-doc-validate stays in doc-infrastructure
- dt-workflow is new feature
- Pros: Honors completed work
- Cons: Artificial separation

**Analysis:** Option 3 (New feature) is cleanest:
- doc-infrastructure delivered Phase 2 + 3 successfully
- dt-workflow is genuinely new scope (AI orchestration)
- Clean git history and PRs

**Connections:**
- Theme 7 (project location) affects where new feature lives
- Theme 2 (component decisions) affects what moves

**Implications:**
- doc-infrastructure can be marked complete
- dt-workflow starts fresh with clear scope
- Libraries (lib/doc-gen, lib/doc-validate) remain available

**Concerns:**
- May feel like starting over
- Need to carry forward context
- Decision depends on Theme 1 architecture decision

---

### Theme 6: Model Selection Integration

This theme examines how task-to-model mapping integrates with dt-workflow.

**From dev-infra research - task type to model mapping:**

```yaml
task_models:
  explore: claude-opus-4       # Deep thinking
  research: claude-opus-4      # Analysis
  decision: claude-opus-4      # Judgment
  naming: gemini-2.5-pro       # Creative
  pr: claude-sonnet-4          # Structured
  task-phase: composer-1       # Implementation
```

**Three integration options:**

**Option A: Built-in to dt-workflow**
```bash
# dt-workflow reads ~/.config/dt-workflow/models.yaml
dt-workflow explore topic  # Uses claude-opus-4 automatically
```
- Pros: Single tool handles everything
- Cons: Couples model selection to workflow

**Option B: Separate tool (dt-model-select)**
```bash
model=$(dt-model-select explore)
dt-workflow explore topic --model $model
```
- Pros: Separation of concerns, reusable
- Cons: Extra tool, more commands

**Option C: Config only (recommended for Phase 1)**
```bash
# dt-workflow documents recommended models
# User manually selects in Cursor
dt-workflow explore topic --interactive
# Shows: "Recommended model: claude-opus-4"
```
- Pros: Works now, no AI invocation needed
- Cons: Not automated

**Phased approach:**
- Phase 1: Option C (recommend only)
- Phase 2: Option A with config file
- Phase 3: Option A with automatic invocation

**Connections:**
- Theme 3 (AI invocation) determines when model selection matters
- Phase 3 requires programmatic AI to use model selection

**Implications:**
- Model config design needed regardless of phase
- Config file format should be stable across phases
- User education on model selection benefits

**Concerns:**
- Users may not understand model differences
- Config proliferation (another file to manage)
- Model names change over time

---

### Theme 7: Cross-Project Coordination (dev-toolkit ↔ dev-infra)

This theme examines where dt-workflow lives and how it consumes resources from other projects.

**Current relationship:**
- **dev-infra:** Templates, validation rules, workflow documentation
- **dev-toolkit:** CLI tools (dt-*), Cursor commands (.cursor/commands/)

**Where does dt-workflow live?**

**Option A: dev-toolkit (recommended)**
- Alongside dt-doc-gen, dt-doc-validate, dt-review
- Consistent with "dt-*" naming pattern
- Installation: `~/.dev-toolkit/bin/dt-workflow`

**Option B: dev-infra**
- With templates it consumes
- Pros: Colocation with templates
- Cons: Breaks dt-* pattern, different install

**Option C: Shared**
- CLI in dev-toolkit, templates in dev-infra
- Pros: Logical separation
- Cons: Cross-project dependencies

**Template consumption strategy:**

| Strategy | Pros | Cons |
|----------|------|------|
| Bundled | Self-contained | Stale templates |
| Fetched | Always current | Network dependency |
| Configurable | Flexible | User must configure |

**Recommended:** Templates configurable with bundled defaults.

```yaml
# ~/.config/dt-workflow/config.yaml
templates:
  source: dev-infra  # or "bundled" or path
  path: /path/to/dev-infra/templates/
```

**Connections:**
- Theme 5 (naming) affects project organization
- Template system already exists in dev-infra

**Implications:**
- dt-workflow lives in dev-toolkit
- Templates remain in dev-infra
- Config allows different template sources

**Concerns:**
- Cross-project dependency complexity
- Version sync between toolkit and infra
- Installation must handle template setup

---

## ❓ Key Questions

### Question 1: Should dt-workflow be unified or composable?

**Context:** This is the fundamental architecture decision. A unified approach creates a single command that handles the entire workflow. A composable approach keeps tools separate and relies on external composition (Cursor commands, scripts).

**Sub-questions:**
- What's the maintenance cost of unified vs composable?
- Do users want flexibility or simplicity?
- Can we achieve both with a hybrid approach?
- What do similar tools (Aider, Copilot Workspace) do?

**Research Approach:** 
- Survey existing AI development tools
- Analyze user workflows in current system
- Prototype both approaches

---

### Question 2: How does dt-workflow work in Phase 1 (interactive only)?

**Context:** Cursor CLI cannot programmatically invoke AI agents. This means dt-workflow in Phase 1 can only generate structure and validate output - the AI fill step requires interactive Cursor usage.

**Sub-questions:**
- What's the user experience for a "partial" workflow tool?
- Should we wait for Phase 3 capabilities?
- How do we communicate Phase 1 limitations?
- Can Phase 1 provide enough value to be worth building?

**Research Approach:**
- Design Phase 1 interface mockups
- Test with users on acceptability
- Identify Phase 1-specific value propositions

---

### Question 3: Should dt-doc-validate remain standalone?

**Context:** dt-doc-validate provides document validation via CLI. It's valuable for CI pipelines and pre-commit hooks that run without user interaction.

**Sub-questions:**
- What CI use cases require standalone validation?
- Can we export validation as a library instead?
- What's the cost of maintaining two interfaces?

**Research Approach:**
- Document CI integration patterns
- Analyze current dt-doc-validate usage
- Compare library vs CLI approaches

---

### Question 4: What role do Cursor commands play?

**Context:** Existing Cursor commands (/explore, /research, etc.) provide AI-native workflow interaction. With dt-workflow, their role may change from "full implementation" to "orchestrator" or "thin wrapper."

**Sub-questions:**
- Do commands add value over CLI?
- Should commands call dt-workflow or vice versa?
- What's the migration path for existing command users?

**Research Approach:**
- Survey command usage patterns
- Design command↔CLI interaction model
- Document both paths

---

## 💡 Initial Thoughts

Based on the theme analysis, several patterns emerge that inform preliminary recommendations.

**The Three-Phase Vision is Key**

The dev-infra research established a clear evolution path:
- Phase 1: Interactive AI, manual model selection
- Phase 2: Interactive AI, config-based model suggestion
- Phase 3: Programmatic AI, automatic model selection

dt-workflow should be designed for Phase 3 but provide value in Phase 1. This means:
- Interface designed for full automation
- Phase 1 uses `--interactive` flag as temporary limitation
- Architecture supports future AI invocation

**Component Separation is Clear**

Analysis strongly suggests:
- **dt-doc-validate:** Remains standalone (CI value is real)
- **dt-doc-gen:** Becomes internal library (no standalone use case)
- **dt-workflow:** New command that uses lib/doc-gen internally

This matches the "hybrid" architecture option - unified command using internal components, with validation available standalone.

**Cursor Commands as Orchestrators**

The natural role for Cursor commands in this architecture:
- Commands handle Cursor-specific concerns (AI interaction, IDE context)
- dt-workflow handles workflow logic (structure, validation, git)
- Phase 1: Commands orchestrate dt-workflow
- Phase 3: dt-workflow can run independently

**Opportunities:**

1. **Unified user experience** - Single command for common workflows
2. **CI/CD integration** - dt-doc-validate standalone for automation
3. **Future-ready architecture** - Ready for programmatic AI when available
4. **Clear component roles** - Each tool has defined purpose

**Concerns:**

1. **Phase 1 value unclear** - May feel incomplete without full automation
2. **Complexity risk** - Building for Phase 3 when Phase 1 is current reality
3. **Migration burden** - Users learned dt-doc-gen, now it's internal
4. **Scope creep** - dt-workflow could become too ambitious

---

## 🚀 Next Steps

1. **Review research topics** in `research-topics.md` for prioritized investigation
2. **Decide on blocking questions** (Topics 1-2) before proceeding
3. Use `/research dt-workflow --from-explore dt-workflow` to investigate
4. After research, use `/decision dt-workflow --from-research` to make architecture decision

---

## 🔗 Related

- [dev-infra: Cursor CLI Model Selection](/Users/cdwilson/Projects/dev-infra/admin/research/template-doc-infrastructure/research-cursor-cli-model-selection.md)
- [doc-infrastructure Feature](../../planning/features/doc-infrastructure/)
- [Command Migrations Exploration](../command-migrations/)

---

**Last Updated:** 2026-01-22
