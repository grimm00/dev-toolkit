# Exploration: dt-workflow - Unified Workflow Orchestration

**Status:** ✅ Expanded  
**Created:** 2026-01-22  
**Expanded:** 2026-01-22  
**Context Gathering Added:** 2026-01-22

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

### Theme 8: Context Gathering

This theme addresses what context each workflow needs and how it's provided to AI - a critical piece of the orchestration puzzle identified but not fully developed in dev-infra research.

**Background from dev-infra research:**

The research established the concept of scripts gathering context to reduce AI token usage:

```
Scripts (0 tokens)              AI (targeted tokens)
├── Context gathering           ├── Analysis
├── Structure generation        ├── Insights  
├── Model selection             ├── Connections
└── ...                         └── Content fill
```

**Token efficiency:** ~80-90% savings on input tokens by pre-gathering context into manifests instead of AI discovery.

**However:** The research didn't define WHAT context each workflow needs.

**Two categories of context:**

**1. Universal Context (Always Needed)**

| Context Type | Files/Data | Why Universal |
|--------------|------------|---------------|
| Cursor rules | `.cursor/rules/*.mdc` | Coding standards, workflow patterns |
| Project identity | `admin/README.md`, `admin/planning/roadmap.md` | Project direction, conventions |
| Current state | Git branch, recent changes | Situational awareness |
| Workflow patterns | Hub-and-spoke, status indicators | Consistency |

**2. Workflow-Specific Context**

| Workflow | Specific Context Needed |
|----------|------------------------|
| `/explore` | roadmap.md, explorations hub, related explorations |
| `/research` | Source exploration, existing research in topic area |
| `/decision` | Research findings, ADR templates, existing ADRs |
| `/pr` | Branch diff, commit history, PR template |
| `/fix-plan` | Sourcery review file, affected source files |
| `/task-phase` | Feature plan, phase docs, implementation status |

**The Trust Problem (User Insight)**

A key concern: users don't trust that Cursor rules are always being followed, especially in new chats. The current system relies on Cursor's implicit rule loading, which:
- May not happen reliably in new chats
- Is invisible to the user (did it load?)
- Varies based on context window limits
- Provides no confirmation it was applied

**Solution:** dt-workflow should **explicitly gather and inject** universal context (including rules) so that:
- **Transparency** - User sees what's being loaded
- **Reliability** - Context is explicitly provided every time
- **Auditability** - Context gathering is deterministic, not magical

**Three context injection approaches:**

**Option A: Header Injection**
```bash
dt-workflow explore topic --interactive
# Outputs:
# 1. Universal context block (rules, identity)
# 2. Workflow-specific context (roadmap, explorations)
# 3. Generated structure
# All combined into single output for AI consumption
```
- Pros: Everything in one place, explicit
- Cons: Large initial context, may hit token limits

**Option B: Manifest + File References**
```bash
dt-workflow explore topic --interactive
# Outputs:
# 1. Context manifest (list of files with summaries)
# 2. Generated structure with @file references
# AI reads files as needed
```
- Pros: Smaller initial context, on-demand
- Cons: AI may not read all needed files

**Option C: Tiered Context**
```bash
dt-workflow explore topic --interactive
# Outputs:
# Tier 1 (always inline): Rules, project identity
# Tier 2 (as references): Workflow-specific files
# Tier 3 (on request): Deep context
```
- Pros: Balance of explicit + efficient
- Cons: More complex implementation

**Phase implications:**

| Phase | Context Handling |
|-------|------------------|
| Phase 1 (Now) | Script outputs context block; Cursor AI reads it |
| Phase 2 (Near) | Same, but context optimized per workflow |
| Phase 3 (Future) | Script passes context directly to AI API |

**Connections:**
- Theme 1 (architecture) - Unified workflow simplifies context management
- Theme 3 (AI invocation) - Phase 3 enables direct context passing
- Theme 4 (Cursor commands) - Commands could inject additional IDE context

**Implications:**
- Each workflow type needs a defined context profile
- Universal context should be versioned with toolkit
- Workflow-specific context requires project analysis

**Concerns:**
- Context size vs token limits (especially for large projects)
- Keeping context profiles up to date
- Balance between explicit rules and overwhelming AI
- Cross-project context (e.g., dev-infra templates used in dev-toolkit)

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

### Question 5: How should context be gathered and injected?

**Context:** Different workflows need different context (rules, project files, related documents). Universal context (Cursor rules) should always be included explicitly for reliability and user trust. The current system relies on implicit rule loading which is invisible and unreliable.

**Sub-questions:**
- What context is truly universal vs workflow-specific?
- How do we balance explicit context with token limits?
- Should context be injected inline or as file references?
- How do we handle cross-project context (e.g., dev-infra templates)?

**Research Approach:**
- Inventory context needs per workflow type
- Analyze token impact of different approaches
- Design context profile format
- Test with real workflows

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

## 🧪 Spike vs Research Determination

**Insight:** With AI-accelerated development, the traditional POC→MVP separation may not always be necessary. However, spikes still provide value when decision risk is high. This determination should be part of every exploration.

**Framework:**
- **Spike (hours):** When technical uncertainty OR architectural commitment is high
- **Research only:** When the path is known but details need investigation
- **Straight to MVP:** When risk is low AND approach is well-understood

### dt-workflow Topic Assessment

| Topic | Risk Level | Determination | Rationale |
|-------|------------|---------------|-----------|
| 1. Unified vs Composable | 🔴 HIGH | **Spike first** | Architectural - hard to pivot once committed |
| 2. Phase 1 Interface | 🟠 MEDIUM-HIGH | **Spike first** | User-facing, need to feel the UX |
| 3. Validate Standalone | 🟢 LOW | Research only | Clear CI value, low risk |
| 4. Gen Internal | 🟢 LOW | Research only | Analysis already clear |
| 5. Cursor Command Role | 🟡 MEDIUM | Research only | Depends on architecture (spike results) |
| 6. Model Selection | 🟢 LOW | Research only | Enhancement, not blocking |
| 7. Project Location | 🟢 LOW | Research only | Clear precedent (dt-* in dev-toolkit) |
| 8. Naming & Scope | 🟢 LOW | Research only | Organizational, easy to change |
| 9. Migration Path | 🟢 LOW | Research only | Depends on other decisions |
| 10. Context Gathering | 🟡 MEDIUM | **Consider spike** | Format details could benefit from feeling |

### Recommended Spike Scope

**Spike Topics 1+2 together (2-3 hours):**

Build a minimal `dt-workflow explore topic --interactive` that:
1. Generates structure (reuse dt-doc-gen logic)
2. Gathers and outputs context (rules + project identity)
3. Outputs combined result for AI consumption

**Validate:**
- Does the unified interface feel right?
- Does explicit context injection work in practice?
- Does Phase 1 `--interactive` provide enough value?

**If spike succeeds:** Spike becomes MVP skeleton, proceed to full implementation  
**If spike fails:** Pivot architecture before investing more time

### Workflow Pattern Note

**This spike determination should be a standard part of exploration workflow.**

After identifying research topics, ask:
1. Which decisions have high pivot cost?
2. Which need to be "felt" rather than analyzed?
3. Can a few hours of prototyping answer what days of research might not?

Consider adding to `/explore` command output or as a section in exploration.md template.

**For junior developers:** Spikes are especially valuable as time-boxed "can it work?" sessions. The strict time limit (e.g., 2 hours) removes pressure to build something perfect, makes failure safe ("I couldn't figure it out" is a valid answer), and prevents rabbit holes. It's structured permission to experiment.

---

## 🧪 Spike Learnings (2026-01-23)

**Spike:** Built `bin/dt-workflow` to validate unified architecture + Phase 1 interface.

### What Was Validated

| Topic | Result | Confidence |
|-------|--------|------------|
| Unified Architecture | ✅ Feels right | High |
| Phase 1 --interactive | ✅ Provides value | High |
| Explicit Context Injection | ⚠️ Works, but scalability question | Medium |

### What Was Learned

1. **Unified command is natural** - `dt-workflow explore topic --interactive` flows well
2. **Context + Task + Instructions** format is clear and actionable
3. **Explicit rule injection addresses trust concern** - User sees what's loaded
4. **Phase 1 limitations are acceptable** - Clear messaging about manual AI step

### New Questions Revealed

**Context Scalability:** The spike injects full rule content inline (~500+ lines for 4 files). What happens with larger rule sets?

- Should context be pointers (file references) instead of content?
- What's the token budget before diminishing returns?
- Should we use a hybrid approach (summaries + pointers)?

This question expands Topic 10 research scope.

### Spike Artifacts

- `bin/dt-workflow` - Spike implementation (599 lines)
- Can become MVP skeleton if research confirms approach

---

## 🚀 Next Steps

1. ~~**Spike Topics 1+2**~~ ✅ Complete - Architecture validated
2. **Research Topic 10** - Context gathering scalability (new questions from spike)
3. **Quick decisions on Topics 3-9** - Most have clear answers from exploration analysis
4. **Polish spike into MVP** - Add remaining workflows, improve context strategy
5. Use `/decision dt-workflow --from-research` to formalize decisions

---

## 🔗 Related

- [dev-infra: Research Summary](/Users/cdwilson/Projects/dev-infra/admin/research/template-doc-infrastructure/research-summary.md) - Context gathering concept, token efficiency
- [dev-infra: Cursor CLI Model Selection](/Users/cdwilson/Projects/dev-infra/admin/research/template-doc-infrastructure/research-cursor-cli-model-selection.md)
- [dev-infra: Architectural Placement](/Users/cdwilson/Projects/dev-infra/admin/research/template-doc-infrastructure/research-architectural-placement.md) - lib/doc-context.sh concept
- [doc-infrastructure Feature](../../planning/features/doc-infrastructure/)
- [Command Migrations Exploration](../command-migrations/)

---

**Last Updated:** 2026-01-22
