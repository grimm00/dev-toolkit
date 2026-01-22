# Research Topics - dt-workflow Exploration

**Status:** ✅ Expanded  
**Created:** 2026-01-22  
**Expanded:** 2026-01-22

---

## 📋 Research Topics

### Priority 1: Architecture Decision (BLOCKING)

These topics must be resolved before any implementation work.

---

### Topic 1: Unified vs Composable Architecture

**Question:** Should dt-workflow be a single command that orchestrates the entire workflow, or should tools remain composable?

**Context:** This is the fundamental architecture decision that affects everything else. A unified approach (like Aider or Copilot Workspace) provides a single entry point but is opinionated. A composable approach (Unix philosophy) maintains flexibility but requires external orchestration. The right choice depends on user needs, maintenance considerations, and the Phase 1-3 evolution path.

**Priority:** BLOCKING

**Rationale:** Every other decision depends on this. Component decisions, command roles, and project organization all follow from the architecture choice.

**Options:**
- **A: Unified** - `dt-workflow explore topic` does gen→fill→validate→commit
- **B: Composable** - `dt-doc-gen | ai-fill | dt-doc-validate | git commit`
- **C: Hybrid** - Unified command using composable internal components

**Suggested Approach:**
- Survey similar tools (Aider, Copilot Workspace, Claude Code)
- Analyze user workflows with current tools
- Evaluate maintenance implications of each option
- Consider Phase 1 vs Phase 3 requirements

---

### Topic 2: Phase 1 Interface Design

**Question:** How does dt-workflow work in Phase 1 when AI invocation is interactive only?

**Context:** Cursor CLI cannot programmatically invoke AI agents (as of research date). This means Phase 1 dt-workflow can only generate structure and validate output - the AI fill step requires interactive Cursor usage. The interface must provide value despite this limitation.

**Priority:** BLOCKING

**Rationale:** Determines what we can build now. If Phase 1 interface has no value, we should wait for Phase 3 capabilities.

**Options:**
- **A: Interactive mode** - `dt-workflow explore topic --interactive` opens Cursor
- **B: Two-step mode** - `dt-workflow gen` then manual AI, then `dt-workflow validate`
- **C: Cursor-only mode** - dt-workflow only invoked from Cursor commands

**Suggested Approach:**
- Design interface mockups for each option
- Evaluate user experience for "partial" workflow
- Test Phase 1 → Phase 3 transition path
- Identify Phase 1-specific value propositions

---

### Priority 2: Component Decisions (HIGH)

These topics determine what happens to existing tools.

---

### Topic 3: Validate Standalone Value

**Question:** Should dt-doc-validate remain a standalone tool?

**Context:** dt-doc-validate provides CLI document validation. It has clear CI/automation value - GitHub Actions and pre-commit hooks need to run validation without user interaction. The question is whether this justifies maintaining it as a standalone tool or if we should export validation as a library.

**Priority:** HIGH

**Rationale:** CI integration is a real use case. Decision affects whether dt-doc-validate remains in `bin/` or becomes internal.

**Arguments for standalone:**
- CI pipelines run without user interaction
- Pre-commit hooks need CLI interface
- Manual validation without generation is useful
- Clear separation of concerns

**Arguments against:**
- Library export could serve CI equally well
- Extra tool to maintain
- Users rarely validate without generating

**Suggested Approach:**
- Document current CI integration patterns
- Analyze frequency of standalone validation
- Compare CLI vs library approaches for automation
- Evaluate maintenance cost of both

---

### Topic 4: Generate Internal Decision

**Question:** Should dt-doc-gen become an internal component of dt-workflow?

**Context:** dt-doc-gen generates document structure from templates. Analysis suggests it has minimal standalone value - generation is always followed by AI fill. The question is whether to keep it as a standalone tool or internalize it.

**Priority:** HIGH

**Rationale:** Determines if we deprecate dt-doc-gen CLI and refactor to library.

**Arguments for internal:**
- No standalone use case (always followed by AI fill)
- Simpler architecture (one tool)
- No API boundary to maintain
- Already built as library (lib/doc-gen/)

**Arguments against:**
- Already built and tested as CLI
- Could be useful for template testing
- Composability for advanced users
- Deprecation may confuse users

**Suggested Approach:**
- Survey for legitimate standalone use cases
- Evaluate refactoring effort to internalize
- Design library interface
- Plan CLI deprecation path

---

### Priority 3: Integration Decisions (MEDIUM)

These topics determine how dt-workflow integrates with existing systems.

---

### Topic 5: Cursor Command Role

**Question:** What role do Cursor commands play alongside dt-workflow?

**Context:** Six Cursor commands (/explore, /research, etc.) currently provide workflow functionality with inline templates. If dt-workflow exists, commands could become thin wrappers, orchestrators, or be deprecated entirely.

**Priority:** MEDIUM

**Rationale:** Affects command migration work and user documentation. Can be decided after architecture is clear.

**Options:**
- **A: Wrappers** - Commands just call dt-workflow
- **B: Orchestrators** - Commands handle Cursor-specific logic, call dt-workflow for structure
- **C: Deprecated** - dt-workflow replaces commands entirely
- **D: Parallel** - Both exist for different use cases

**Suggested Approach:**
- Analyze command vs CLI usage patterns
- Evaluate what value commands add over CLI
- Design command↔CLI interaction model
- Consider Phase 1 vs Phase 3 differences

---

### Topic 6: Model Selection Integration

**Question:** How does model selection integrate with dt-workflow?

**Context:** dev-infra research established task-type-to-model mapping (explore→opus, pr→sonnet, etc.). In Phase 1, this is informational only. In Phase 3, dt-workflow could automatically select and invoke the right model.

**Priority:** MEDIUM

**Rationale:** Affects config design but doesn't block Phase 1 implementation.

**Options:**
- **A: Built-in** - dt-workflow reads models.yaml, invokes AI with model
- **B: Separate** - dt-model-select tool, dt-workflow uses output
- **C: Config only** - dt-workflow documents recommended models, user selects

**Suggested Approach:**
- Design config file format (YAML schema)
- Evaluate Phase 1 vs Phase 3 requirements
- Research Aider/LLM CLI model selection patterns
- Determine per-project vs global config

---

### Topic 7: Project Location

**Question:** Where does dt-workflow live (dev-toolkit vs dev-infra)?

**Context:** dt-* tools live in dev-toolkit, templates live in dev-infra. dt-workflow needs templates but follows the dt-* naming pattern.

**Priority:** MEDIUM

**Rationale:** Affects installation and distribution but doesn't block architecture.

**Options:**
- **A: dev-toolkit** - Alongside dt-doc-gen, dt-doc-validate, dt-review
- **B: dev-infra** - With templates it consumes
- **C: Shared** - CLI in dev-toolkit, templates in dev-infra (current pattern)

**Suggested Approach:**
- Review current dt-* tool locations
- Analyze template consumption patterns
- Design template source configuration
- Document cross-project dependencies

---

### Priority 4: Organizational (LOW)

These topics can be decided after architecture is clear.

---

### Topic 8: Naming & Scope

**Question:** Is this "doc-infrastructure" or a new scope?

**Context:** Current worktree is feat/doc-infrastructure, focused on dt-doc-gen and dt-doc-validate. dt-workflow expands scope to workflow orchestration, AI invocation, and git integration.

**Priority:** LOW

**Rationale:** Organizational decision that doesn't affect implementation. Can be decided when ready to merge.

**Options:**
- **A: Keep scope** - dt-workflow is part of doc-infrastructure
- **B: Rename** - Feature becomes "workflow-infrastructure"
- **C: New feature** - doc-infrastructure complete, dt-workflow is separate

**Suggested Approach:**
- Evaluate logical grouping
- Consider git branch/PR strategy
- Assess user understanding of naming
- Decide when ready to merge

---

### Topic 9: Migration Path

**Question:** How do we transition from current tools to dt-workflow?

**Context:** dt-doc-gen and dt-doc-validate exist. Cursor commands exist with inline templates. Users have learned these tools. dt-workflow may change or deprecate some of them.

**Priority:** LOW

**Rationale:** Migration planning happens after architecture decisions. Depends on Topics 1-4.

**Options:**
- **A: Parallel** - dt-workflow coexists with existing tools
- **B: Replace** - dt-workflow replaces dt-doc-gen usage
- **C: Gradual** - Phase 1 uses existing, Phase 3 is unified

**Suggested Approach:**
- Document current tool usage
- Design deprecation communication
- Plan backward compatibility
- Create migration guide

---

## 🎯 Research Workflow

### Recommended Order

1. **Topics 1 + 2:** Architecture + Phase 1 interface (BLOCKING - must decide first)
2. **Topics 3 + 4:** Component decisions (depends on architecture)
3. **Topics 5 + 6 + 7:** Integration decisions (depends on components)
4. **Topics 8 + 9:** Organizational (after architecture clear)

### Research Commands

```bash
# Start research on blocking topics
/research dt-workflow --from-explore dt-workflow

# After research, make decisions
/decision dt-workflow --from-research
```

### Decision Gates

| Gate | Topics Required | Unlocks |
|------|-----------------|---------|
| Architecture | 1, 2 | Topics 3-7 |
| Components | 3, 4 | Topics 5-7, implementation start |
| Integration | 5, 6, 7 | Final design |
| Organization | 8, 9 | Merge strategy |

---

## 🔗 Related

- [Exploration Document](exploration.md)
- [dev-infra: Cursor CLI Model Selection](/Users/cdwilson/Projects/dev-infra/admin/research/template-doc-infrastructure/research-cursor-cli-model-selection.md)
- [doc-infrastructure Feature](../../planning/features/doc-infrastructure/)

---

**Last Updated:** 2026-01-22
