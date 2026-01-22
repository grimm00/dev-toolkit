# dt-workflow - Exploration Hub

**Purpose:** Explore unified workflow orchestration for dev-toolkit  
**Status:** 🔴 Scaffolding  
**Created:** 2026-01-22  
**Last Updated:** 2026-01-22

---

## 📋 Quick Links

- **[Exploration Document](exploration.md)** - Main exploration analysis
- **[Research Topics](research-topics.md)** - Questions requiring investigation

### Related Context

- **[dev-infra: Cursor CLI Model Selection](/Users/cdwilson/Projects/dev-infra/admin/research/template-doc-infrastructure/research-cursor-cli-model-selection.md)** - Research on programmatic AI invocation
- **[doc-infrastructure Feature](../../planning/features/doc-infrastructure/)** - Current dt-doc-gen/dt-doc-validate work
- **[Command Migrations](../command-migrations/)** - Previous exploration (may be superseded)

---

## 🎯 Context

We've built:
- **dt-doc-gen** (Phase 2) - Template-based document generation
- **dt-doc-validate** (Phase 3) - Rule-based document validation

The question: Should these be **standalone tools** or **internal components** of a unified `dt-workflow` command?

### The Vision (from dev-infra research)

```
Phase 1 (Now):     /explore → dt-doc-gen → structure → AI fills interactively
Phase 2 (Near):    /explore → dt-doc-gen → structure → AI fills (model from config)
Phase 3 (Future):  dt-workflow → structure → invoke-ai → fill → validate
```

### Key Questions

1. **What is dt-workflow?** - Unified orchestration or just another tool?
2. **Standalone vs internal?** - Do dt-doc-gen and dt-doc-validate exist separately?
3. **AI invocation?** - How does the tool invoke AI (now vs future)?
4. **Cursor commands?** - What happens to /explore, /research, etc.?
5. **Naming?** - Is this still "doc-infrastructure" or something bigger?

---

## 📊 Exploration Status

| Theme | Status |
|-------|--------|
| Architecture Vision | 🔴 Scaffolding |
| Tool Separation | 🔴 Scaffolding |
| AI Invocation Model | 🔴 Scaffolding |
| Cursor Command Future | 🔴 Scaffolding |
| Naming & Organization | 🔴 Scaffolding |

---

## 🚀 Next Steps

1. Review and expand exploration scaffolding
2. Identify key research questions
3. Make architectural decisions
4. Determine impact on current work (dt-doc-gen, dt-doc-validate, worktree)

---

**Last Updated:** 2026-01-22
