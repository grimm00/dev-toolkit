# dt-workflow Evolution Path

**Purpose:** Document the evolution path for dt-workflow from interactive to automated modes  
**Status:** ✅ Active  
**Created:** 2026-01-26  
**Last Updated:** 2026-01-26

---

## 📋 Overview

`dt-workflow` is designed to evolve through three phases, progressively increasing automation while maintaining human oversight and quality. This document outlines the current state and future vision.

---

## 🔄 Current: Phase 1 - Interactive Mode

**Status:** ✅ Complete (v0.2.0)  
**Focus:** Manual workflow initiation with AI-assisted content generation

### Characteristics

- **Manual Initiation:** User runs `dt-workflow` commands explicitly
- **AI-Assisted Generation:** Output provides context + structure for AI to fill
- **Human-in-the-Loop:** All content generation requires human review and editing
- **Explicit Context Injection:** Full context (rules, project identity) included in output
- **Workflow Chaining:** Manual handoff via `--from-explore` and `--from-research` flags

### Capabilities

- ✅ Unified command for explore/research/decision workflows
- ✅ Explicit context injection (Cursor rules, project identity)
- ✅ L1/L2/L3 validation with actionable errors
- ✅ Model recommendations per workflow type
- ✅ Configurable context profiles (default, minimal, full)
- ✅ Dry run preview mode
- ✅ Performance requirements met (<1s context injection, <500ms validation)

### Limitations

- Manual workflow initiation required
- No automatic file generation (output is for AI to use)
- No event-driven triggers
- No configuration-based automation

---

## 🔮 Future: Phase 2 - Config-Assisted Mode

**Status:** 🔴 Planned  
**Focus:** Configuration-based workflow triggers with reduced manual steps

### Vision

- **Configuration-Driven:** Workflows triggered via config file (e.g., `.dt-workflow.yml`)
- **Reduced Manual Steps:** Semi-automated handoffs between workflows
- **Template-Based Generation:** Direct file creation from templates (not just context)
- **Workflow Templates:** Pre-defined workflow patterns (e.g., "new-feature", "bug-fix")
- **Partial Automation:** Human review still required, but less manual work

### Planned Features

- Configuration file support (`.dt-workflow.yml` or `config/dt-workflow.yml`)
- Workflow templates (pre-defined patterns)
- Auto-generation of handoff files (`research-topics.md`, `research-summary.md`)
- Batch workflow execution (multiple topics in one run)
- Workflow state tracking (which workflows completed for a topic)
- Template variable expansion (direct file creation)

### Example Configuration

```yaml
# .dt-workflow.yml
workflows:
  new-feature:
    steps:
      - explore
      - research
      - decision
    auto-handoff: true
    template: feature-template
```

### Benefits

- Faster workflow execution (less manual copying/pasting)
- Consistent workflow patterns across team
- Reduced cognitive load (config handles routing)
- Still maintains human oversight (review before commit)

---

## 🚀 Future: Phase 3 - Automated Mode

**Status:** 🔴 Vision  
**Focus:** Full automation for routine workflows with minimal human intervention

### Vision

- **Event-Driven Triggers:** Workflows triggered by git events (branch creation, PR opened)
- **Full Automation:** Complete workflow execution without manual steps
- **AI Integration:** Direct AI API calls for content generation (not just context)
- **Quality Gates:** Automated validation and quality checks
- **Minimal Human Intervention:** Human review only for critical decisions

### Planned Features

- Git hook integration (pre-commit, post-merge triggers)
- AI API integration (direct content generation)
- Automated quality checks (validation, linting, testing)
- Workflow orchestration (multi-step workflows run automatically)
- Notification system (status updates, completion alerts)
- Rollback capabilities (undo automated changes if needed)

### Example Trigger

```bash
# Git hook: post-merge
# When feature branch merged to develop:
dt-workflow auto-explore --trigger=merge --branch=feat/new-feature
# → Automatically creates exploration for new feature
```

### Benefits

- Zero manual work for routine workflows
- Consistent quality (automated checks)
- Faster iteration cycles
- Scales to large teams

### Risks & Mitigations

- **Risk:** Over-automation reduces human understanding
  - **Mitigation:** Always show what was automated, require review for critical decisions
- **Risk:** AI-generated content may be incorrect
  - **Mitigation:** Quality gates, human review for ADRs and critical decisions
- **Risk:** Configuration complexity
  - **Mitigation:** Sensible defaults, clear documentation, gradual rollout

---

## 📊 Evolution Timeline

| Phase | Status | Timeline | Key Deliverable |
|-------|--------|----------|----------------|
| Phase 1: Interactive | ✅ Complete | 2026-01-22 to 2026-01-26 | v0.2.0 with full workflow support |
| Phase 2: Config-Assisted | 🔴 Planned | TBD | Configuration system + templates |
| Phase 3: Automated | 🔴 Vision | TBD | Event-driven automation |

**Note:** Timeline depends on user feedback, adoption, and priority. Phase 2 may be prioritized if there's strong demand for reduced manual work.

---

## 🔗 Related Documents

- **[Feature Plan](../admin/planning/features/dt-workflow/feature-plan.md)** - Overall feature overview
- **[Phase 1](../admin/planning/features/dt-workflow/phase-1.md)** - Foundation implementation
- **[Phase 2](../admin/planning/features/dt-workflow/phase-2.md)** - Workflow expansion
- **[Phase 3](../admin/planning/features/dt-workflow/phase-3.md)** - Cursor integration
- **[Phase 4](../admin/planning/features/dt-workflow/phase-4.md)** - Enhancement (model recommendations, profiles)
- **[Architecture Decisions](../admin/decisions/dt-workflow/)** - ADRs guiding evolution

---

## 💡 Design Principles

Throughout all phases, `dt-workflow` maintains these principles:

1. **Explicit Over Implicit:** Context injection is always visible, not hidden
2. **Human Oversight:** Critical decisions always require human review
3. **Progressive Enhancement:** Each phase builds on previous, doesn't break existing workflows
4. **Quality First:** Automation never sacrifices quality or correctness
5. **Configurable:** Users can opt-in to automation features, not forced

---

**Last Updated:** 2026-01-26  
**Status:** ✅ Active
