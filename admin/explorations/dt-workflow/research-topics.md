# Research Topics - dt-workflow Exploration

**Status:** 🔴 Scaffolding  
**Created:** 2026-01-22  
**Last Updated:** 2026-01-22

---

## 📋 Prioritized Research Questions

### Priority 1: Architecture Decision (BLOCKING)

| # | Topic | Question | Why Important |
|---|-------|----------|---------------|
| 1 | **Unified vs Composable** | Should dt-workflow be a single command or composable tools? | Determines entire architecture direction |
| 2 | **Phase 1 Interface** | How does dt-workflow work before programmatic AI is available? | Affects what we can build now |

---

### Priority 2: Component Decisions (HIGH)

| # | Topic | Question | Why Important |
|---|-------|----------|---------------|
| 3 | **Validate Standalone** | Should dt-doc-validate remain a standalone tool? | CI/hooks value vs consolidation |
| 4 | **Generate Internal** | Should dt-doc-gen become internal to dt-workflow? | Determines if current work is reused or refactored |

---

### Priority 3: Integration Decisions (MEDIUM)

| # | Topic | Question | Why Important |
|---|-------|----------|---------------|
| 5 | **Cursor Command Role** | What role do Cursor commands play with dt-workflow? | Affects command migration work |
| 6 | **Model Selection** | How does model selection integrate? | Affects config design |
| 7 | **Project Location** | Where does dt-workflow live (dev-toolkit vs dev-infra)? | Affects project organization |

---

### Priority 4: Organizational (LOW - After Architecture)

| # | Topic | Question | Why Important |
|---|-------|----------|---------------|
| 8 | **Naming** | Is this "doc-infrastructure" or a new scope? | Affects worktree, feature organization |
| 9 | **Migration Path** | How do we transition from current tools to dt-workflow? | Affects release planning |

---

## 🔍 Research Topic Details

### Topic 1: Unified vs Composable Architecture

**Question:** Should dt-workflow be a single command that does everything, or should tools remain composable?

**Options:**
- **A: Unified** - `dt-workflow explore topic` does gen→fill→validate→commit
- **B: Composable** - `dt-doc-gen | ai-fill | dt-doc-validate | git commit`
- **C: Hybrid** - Unified command, but components available standalone

**Research needed:**
- [ ] What do similar tools do? (Aider, Copilot Workspace, Cursor)
- [ ] What are the maintenance implications of each?
- [ ] What do users prefer (single vs composable)?

---

### Topic 2: Phase 1 Interface Design

**Question:** How does dt-workflow work in Phase 1 when AI invocation is interactive only?

**Options:**
- **A: Interactive mode** - `dt-workflow explore topic --interactive` opens Cursor with structure
- **B: Two-step** - `dt-workflow gen topic` then user manually runs AI, then `dt-workflow validate`
- **C: Cursor integration** - dt-workflow only invoked from Cursor commands

**Research needed:**
- [ ] What's the user experience for each option?
- [ ] How does this transition to Phase 3?
- [ ] Can we test Phase 1 interface without AI?

---

### Topic 3: Validate Standalone Value

**Question:** Should dt-doc-validate remain a standalone tool?

**Arguments for standalone:**
- CI pipeline integration (GitHub Actions, pre-commit)
- Manual validation without generation
- Clear separation of concerns

**Arguments against:**
- Only valuable as part of pipeline
- Extra tool to maintain
- Users rarely validate without generating

**Research needed:**
- [ ] How often would validation run standalone?
- [ ] What's the CI integration pattern?
- [ ] Can we export a function for CI while keeping it internal?

---

### Topic 4: Generate Internal Decision

**Question:** Should dt-doc-gen become an internal component of dt-workflow?

**Current state:** dt-doc-gen is standalone CLI tool

**Arguments for internal:**
- No standalone use case (always followed by AI fill)
- Simpler architecture (one tool)
- No API boundary to maintain

**Arguments against:**
- Already built and tested
- Could be useful for template testing
- Composability for advanced users

**Research needed:**
- [ ] What's the refactoring effort to internalize?
- [ ] Are there legitimate standalone use cases?
- [ ] Can we reuse existing code as library?

---

### Topic 5: Cursor Command Role

**Question:** What role do Cursor commands play alongside dt-workflow?

**Options:**
- **A: Wrappers** - Commands just call dt-workflow
- **B: Orchestrators** - Commands handle Cursor-specific logic, call dt-workflow for structure
- **C: Deprecated** - dt-workflow replaces commands entirely
- **D: Parallel** - Both exist for different use cases

**Research needed:**
- [ ] What value do commands add over CLI?
- [ ] How do other AI tools handle this?
- [ ] What's the user preference?

---

### Topic 6: Model Selection Integration

**Question:** How does model selection integrate with dt-workflow?

**From dev-infra research:**
```yaml
task_models:
  explore: claude-opus-4
  research: claude-opus-4
  pr: claude-sonnet-4
```

**Options:**
- **A: Built-in** - dt-workflow reads models.yaml, passes to AI invocation
- **B: Separate** - dt-model-select tool, dt-workflow uses output
- **C: Config only** - dt-workflow documents recommended models, user selects

**Research needed:**
- [ ] What's the Phase 1 vs Phase 3 difference?
- [ ] How does Aider/LLM CLI handle model selection?
- [ ] Should config be per-project or global?

---

### Topic 7: Project Location

**Question:** Where does dt-workflow live?

**Options:**
- **A: dev-toolkit** - Alongside dt-doc-gen, dt-doc-validate, dt-review
- **B: dev-infra** - With templates and rules it consumes
- **C: Shared** - CLI in dev-toolkit, templates in dev-infra (current pattern)

**Research needed:**
- [ ] What's the current pattern for dt-* tools?
- [ ] Where do templates/rules live?
- [ ] What's the installation/distribution model?

---

### Topic 8: Naming & Scope

**Question:** Is this "doc-infrastructure" or a bigger scope?

**Current:** doc-infrastructure = dt-doc-gen + dt-doc-validate

**If dt-workflow included:**
- Encompasses AI invocation
- Encompasses workflow orchestration
- Encompasses model selection

**Options:**
- **A: Keep scope** - dt-workflow is part of doc-infrastructure
- **B: Rename** - "workflow-infrastructure" or "dev-workflow"
- **C: New feature** - doc-infrastructure complete, dt-workflow is separate

**Research needed:**
- [ ] What's the logical grouping?
- [ ] Does naming affect user understanding?
- [ ] What's the git branch / PR strategy?

---

### Topic 9: Migration Path

**Question:** How do we transition from current tools to dt-workflow?

**Current state:**
- dt-doc-gen: ✅ Complete
- dt-doc-validate: ✅ Complete
- Cursor commands: Inline templates

**Migration options:**
- **A: Parallel** - dt-workflow coexists with existing tools
- **B: Replace** - dt-workflow replaces dt-doc-gen usage
- **C: Gradual** - Phase 1 uses existing, Phase 3 is unified

**Research needed:**
- [ ] What's the user migration experience?
- [ ] Backward compatibility requirements?
- [ ] Release strategy?

---

## 🚀 Recommended Research Order

1. **Topic 1 + 2:** Architecture + Phase 1 interface (must decide first)
2. **Topic 3 + 4:** Component decisions (depends on architecture)
3. **Topic 5 + 6:** Integration decisions (depends on components)
4. **Topic 7 + 8 + 9:** Organizational (after architecture clear)

---

## 🔗 Related

- [Exploration Document](exploration.md)
- [dev-infra: Cursor CLI Model Selection](/Users/cdwilson/Projects/dev-infra/admin/research/template-doc-infrastructure/research-cursor-cli-model-selection.md)

---

**Last Updated:** 2026-01-22
