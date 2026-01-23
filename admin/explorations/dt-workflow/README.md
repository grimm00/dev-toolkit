# dt-workflow - Exploration Hub

**Purpose:** Explore unified workflow orchestration for dev-toolkit  
**Status:** ✅ Expanded  
**Created:** 2026-01-22  
**Expanded:** 2026-01-22

---

## 📋 Quick Links

- **[Exploration Document](exploration.md)** - Full exploration with theme analysis
- **[Research Topics](research-topics.md)** - Prioritized research questions

### Related Context

- **[dev-infra: Cursor CLI Model Selection](/Users/cdwilson/Projects/dev-infra/admin/research/template-doc-infrastructure/research-cursor-cli-model-selection.md)** - Research on programmatic AI invocation (3-phase vision)
- **[doc-infrastructure Feature](../../planning/features/doc-infrastructure/)** - Current dt-doc-gen/dt-doc-validate work
- **[Command Migrations](../command-migrations/)** - Previous exploration (may be superseded)

---

## 🎯 Overview

We've built document infrastructure tools (dt-doc-gen, dt-doc-validate) as standalone components. This exploration examines whether to build a unified `dt-workflow` command that orchestrates the complete pipeline:

```
Generate Structure → AI Fills Content → Validate Output → Commit
```

### The Vision (from dev-infra research)

| Phase | Current State | AI Invocation | Model Selection |
|-------|---------------|---------------|-----------------|
| Phase 1 (Now) | Interactive | Cursor AI fills interactively | Manual |
| Phase 2 (Near) | Interactive + config | Cursor AI, config suggests model | Semi-automatic |
| Phase 3 (Future) | Programmatic | dt-workflow invokes AI directly | Automatic |

### Key Questions

1. **Unified or composable?** - Single command or separate tools?
2. **Phase 1 interface?** - How does dt-workflow work before programmatic AI?
3. **Component decisions?** - Which tools stay standalone?
4. **Cursor commands?** - Wrappers, orchestrators, or deprecated?

---

## 📊 Exploration Summary

### Themes Analyzed

| Theme | Key Finding |
|-------|-------------|
| Architecture Vision | Hybrid approach (unified using composable internals) recommended |
| Component Separation | dt-doc-validate stays standalone, dt-doc-gen becomes internal |
| AI Invocation Model | Design for Phase 3, implement Phase 1 compatibility |
| Cursor Command Role | Commands as orchestrators (Phase 1), optional (Phase 3) |
| Naming & Organization | Consider doc-infrastructure complete, dt-workflow as new feature |
| Model Selection | Config-based, integrated with dt-workflow |
| Cross-Project | dt-workflow in dev-toolkit, templates in dev-infra |
| Context Gathering | Universal (rules, identity) + workflow-specific; explicit injection for trust |

### Initial Recommendations

1. **dt-doc-validate** should remain standalone (CI value)
2. **dt-doc-gen** should become internal library (no standalone use case)
3. **dt-workflow** should be designed for Phase 3 with Phase 1 `--interactive` mode
4. **Cursor commands** become orchestrators calling dt-workflow

---

## 🚀 Next Steps

1. **Research blocking questions** (Topics 1-2: Architecture + Phase 1 Interface)
   ```bash
   /research dt-workflow --from-explore dt-workflow
   ```

2. **Make architecture decision** based on research
   ```bash
   /decision dt-workflow --from-research
   ```

3. **Transition to planning** once architecture is decided
   ```bash
   /transition-plan --from-adr
   ```

---

## 📁 Files in This Exploration

| File | Purpose | Status |
|------|---------|--------|
| `README.md` | Hub with quick links | ✅ Expanded |
| `exploration.md` | Full theme analysis | ✅ Expanded |
| `research-topics.md` | Prioritized research questions | ✅ Expanded |

---

**Last Updated:** 2026-01-22
