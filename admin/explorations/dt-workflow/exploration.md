# Exploration: dt-workflow - Unified Workflow Orchestration

**Status:** 🔴 Scaffolding  
**Created:** 2026-01-22  
**Last Updated:** 2026-01-22

---

## 🎯 Problem Statement

We've built document infrastructure tools (dt-doc-gen, dt-doc-validate) as standalone components. But the **real value** comes from the complete pipeline:

```
Generate Structure → AI Fills Content → Validate Output → Commit
```

Should we build a unified `dt-workflow` that orchestrates this pipeline, or continue with separate tools that Cursor commands compose?

---

## 🔍 Themes

### Theme 1: Architecture Vision

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

**Key questions:**
- Is the unified architecture simpler or more complex?
- What's lost by consolidating? (composability, testing, standalone use)
- What's gained? (single command, atomic operations, clearer UX)

<!-- AI: Expand with analysis of trade-offs, examples from other tools, user experience considerations -->

---

### Theme 2: Standalone vs Internal Components

**dt-doc-validate standalone value:**
- CI pipeline validation (pre-commit, GitHub Actions)
- Manual document checking
- Validation without generation

**dt-doc-gen standalone value:**
- Generate structure for human to fill (no AI)?
- Template testing?
- Unclear use case without AI filling

**Options:**
1. **Both standalone:** Current approach - compose via commands
2. **Validate standalone, gen internal:** dt-doc-validate remains a tool, generation is internal to dt-workflow
3. **Both internal:** Everything in dt-workflow, export functions for CI

<!-- AI: Expand with analysis of each option, real-world usage scenarios, maintenance implications -->

---

### Theme 3: AI Invocation Model

**From dev-infra research - three phases:**

| Phase | AI Invocation | Model Selection |
|-------|---------------|-----------------|
| Phase 1 (Now) | Interactive in Cursor | Manual (Cursor settings) |
| Phase 2 (Near) | Interactive + config | Config suggests model |
| Phase 3 (Future) | Programmatic (Aider/LLM CLI) | Automatic per task type |

**Key insight:** Cursor CLI doesn't support programmatic agent invocation (yet).

**Implications:**
- Phase 1: dt-workflow can generate structure, but AI fill is interactive
- Phase 3: dt-workflow can do everything end-to-end

**Question:** Should dt-workflow be designed for Phase 3 now, even if Phase 1 is limited?

<!-- AI: Expand with analysis of phased approach, interface design that works across phases -->

---

### Theme 4: Cursor Command Future

**Current state:** 6 Cursor commands with inline templates
- /explore, /research, /decision, /transition-plan, /task-phase, /fix-batch

**Options:**

**Option A: Commands remain, call dt-workflow**
```
/explore [topic]
  → calls: dt-workflow explore [topic] --interactive
  → dt-workflow generates structure
  → AI (in Cursor) fills content
  → dt-workflow validates
```

**Option B: Commands become optional orchestrators**
```
# Via Cursor command
/explore [topic]

# OR via CLI directly (when programmatic AI available)
dt-workflow explore [topic] --model claude-opus-4
```

**Option C: Commands deprecated, dt-workflow only**
```
# CLI only
dt-workflow explore [topic]
dt-workflow research [topic] --from-explore
```

**Key questions:**
- Do Cursor commands add value if dt-workflow exists?
- Is the command migration research still relevant?
- Should commands be thin wrappers or full implementations?

<!-- AI: Expand with analysis of each option, user workflow implications -->

---

### Theme 5: Naming & Organization

**Current worktree:** `feat/doc-infrastructure`
- Focused on dt-doc-gen and dt-doc-validate
- Name reflects document generation/validation

**If we build dt-workflow:**
- Scope expands beyond "doc infrastructure"
- Encompasses workflow orchestration, AI invocation, git integration

**Naming options:**
1. **Keep name:** doc-infrastructure includes dt-workflow as a component
2. **Rename worktree:** `feat/dev-workflow` or `feat/dt-workflow`
3. **New feature:** Close doc-infrastructure, start new feature for dt-workflow
4. **Split:** dt-doc-validate stays in doc-infrastructure, dt-workflow is new feature

**Questions:**
- Is dt-workflow a natural evolution or a new feature?
- Should completed work (dt-doc-gen, dt-doc-validate) be considered "done"?
- What's the relationship between doc-infrastructure and dt-workflow?

<!-- AI: Expand with organizational considerations, git branch implications -->

---

### Theme 6: Model Selection Integration

**From dev-infra research - task type to model mapping:**

```yaml
task_models:
  explore: claude-opus-4
  research: claude-opus-4
  decision: claude-opus-4
  naming: gemini-2.5-pro
  pr: claude-sonnet-4
  task-phase: composer-1
```

**Questions:**
- Should dt-workflow have built-in model selection config?
- How does this integrate with Cursor's model selection?
- Is model selection a dt-workflow feature or separate (`dt-model-select`)?

<!-- AI: Expand with configuration design, integration patterns -->

---

### Theme 7: Cross-Project Coordination (dev-toolkit ↔ dev-infra)

**Current relationship:**
- **dev-infra:** Templates, validation rules, template doc infrastructure
- **dev-toolkit:** CLI tools (dt-doc-gen, dt-doc-validate), Cursor commands

**Question:** Where does dt-workflow live?
- **dev-toolkit:** Alongside other dt-* tools
- **dev-infra:** With templates it consumes
- **Shared:** Core in dev-toolkit, templates in dev-infra

**Template consumption:**
- dt-workflow needs templates from dev-infra
- Should templates be bundled, fetched, or configurable?

<!-- AI: Expand with project boundary considerations, template management -->

---

## ❓ Key Questions

1. **Unified or separate?** - Should dt-workflow be one command or composable tools?
2. **Standalone validation?** - Does dt-doc-validate remain independent?
3. **Phase 1 interface?** - How does dt-workflow work before programmatic AI?
4. **Command relationship?** - Are Cursor commands wrappers, orchestrators, or deprecated?
5. **Naming/scope?** - Is this doc-infrastructure or something bigger?
6. **Model selection?** - Built-in or separate concern?
7. **Project location?** - dev-toolkit, dev-infra, or split?

---

## 💭 Initial Thoughts

<!-- AI: Add initial analysis, hypotheses, preliminary recommendations -->

**Hypothesis 1:** dt-doc-validate should remain standalone for CI value.

**Hypothesis 2:** dt-doc-gen's value is primarily as internal component.

**Hypothesis 3:** dt-workflow should be designed for Phase 3, with Phase 1 compatibility.

**Hypothesis 4:** Cursor commands become optional orchestrators (Option B).

---

## 🔗 Related

- [dev-infra: Cursor CLI Model Selection](/Users/cdwilson/Projects/dev-infra/admin/research/template-doc-infrastructure/research-cursor-cli-model-selection.md)
- [doc-infrastructure Feature](../../planning/features/doc-infrastructure/)
- [Command Migrations Exploration](../command-migrations/)

---

**Last Updated:** 2026-01-22
