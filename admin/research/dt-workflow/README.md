# dt-workflow - Research Hub

**Purpose:** Research for unified workflow orchestration  
**Status:** 🟡 Research  
**Created:** 2026-01-23  
**Last Updated:** 2026-01-23

---

## 📋 Quick Links

- **[Research Summary](research-summary.md)** - Summary of all research findings
- **[Requirements](requirements.md)** - Requirements discovered during research

### Research Documents

| # | Topic | Priority | Status | Document |
|---|-------|----------|--------|----------|
| 1 | Context Gathering Scalability | 🔴 HIGH | ✅ Complete | [research-context-gathering.md](research-context-gathering.md) |
| 2 | Workflow Input/Output Specs | 🔴 HIGH | ✅ Complete | [research-workflow-io-specs.md](research-workflow-io-specs.md) |
| 3 | Decision Propagation Patterns | 🔴 HIGH | ✅ Complete | [research-decision-propagation.md](research-decision-propagation.md) |
| 4 | Component Decisions | 🟠 HIGH | 🔴 Not Started | [research-component-decisions.md](research-component-decisions.md) |
| 5 | Cursor Command Role | 🟡 MEDIUM | 🔴 Not Started | [research-cursor-command-role.md](research-cursor-command-role.md) |
| 6 | Model Selection | 🟡 MEDIUM | 🔴 Not Started | [research-model-selection.md](research-model-selection.md) |
| 7 | Dynamic Section Management | 🔴 HIGH | ✅ Complete | [research-dynamic-sections.md](research-dynamic-sections.md) |
| 8 | Template Structure | 🔴 HIGH | ✅ Complete | [research-template-structure.md](research-template-structure.md) |

### Spike-Validated (No Research Needed)

| Topic | Spike Result | Notes |
|-------|--------------|-------|
| Unified vs Composable (Topic 1) | ✅ Validated | Unified architecture feels right |
| Phase 1 Interface (Topic 2) | ✅ Validated | --interactive mode provides value |

---

## 🎯 Research Overview

Research for the dt-workflow unified workflow orchestration feature.

**Source Exploration:** [admin/explorations/dt-workflow/](../../explorations/dt-workflow/)

**Research Focus:** The spike validated core architecture (Topics 1, 2). Research now focuses on:
1. **Context Gathering Scalability** (Topic 10) - Primary focus, new questions from spike
2. **Component Decisions** (Topics 3, 4) - Validate exploration analysis
3. **Integration Decisions** (Topics 5, 6, 7) - How dt-workflow integrates with existing systems

---

## 🧪 Spike Learnings Applied

The spike (`bin/dt-workflow`) validated:
- Unified command architecture works
- Phase 1 --interactive mode provides value
- Explicit context injection addresses user trust

**New questions revealed:**
- What happens when rules are numerous? (Token limits)
- Should context be pointers instead of content?
- How to prioritize context when constrained?

---

## 📊 Research Status

| Research Topic | Priority | Status | Focus |
|----------------|----------|--------|-------|
| Context Gathering | 🔴 HIGH | 🔴 Not Started | **PRIMARY** - Token limits, content vs pointers |
| Component Decisions | 🟠 HIGH | 🔴 Not Started | Validate exploration analysis |
| Cursor Command Role | 🟡 MEDIUM | 🔴 Not Started | Integration pattern |
| Model Selection | 🟡 MEDIUM | 🔴 Not Started | Config design |

---

## 🚀 Next Steps

1. **Conduct Topic 10 research** (Context Gathering) - Primary focus
2. Review component decisions (Topics 3, 4) - May be quick decisions
3. Use `/decision dt-workflow --from-research` to make formal decisions

---

**Last Updated:** 2026-01-22
