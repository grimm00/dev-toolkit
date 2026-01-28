# /explore Command Migration - Exploration Hub

**Status:** ✅ Expanded  
**Created:** 2026-01-22  
**Expanded:** 2026-01-22  
**Sprint:** 1 (Pattern-Setting)

---

## 📋 Quick Links

- **[Exploration](exploration.md)** - Deep analysis of /explore command
- **[Research Topics](research-topics.md)** - Questions to investigate

---

## 🎯 Overview

The `/explore` command is the entry point to the exploration → research → decision → planning pipeline. It transforms unstructured thoughts into structured exploration documents.

**Why Sprint 1:** This command sets patterns for all two-mode commands. Success here validates the dt-doc-gen integration approach.

---

## 📊 Command Summary

| Aspect | Details |
|--------|---------|
| **Location** | `.cursor/commands/explore.md` (in dev-infra) |
| **Complexity** | 🔴 High (two-mode, 3 output files) |
| **Templates** | `exploration.tmpl`, `research-topics.tmpl`, `README.tmpl` |
| **Modes** | Setup (scaffolding) / Conduct (expand) |
| **Output** | ~60-80 lines (Setup) / ~200-300 lines (Conduct) |

---

## 🚀 Next Steps

1. **Research Topics 2 & 6:** Inspect dev-infra templates, document gaps (BLOCKING)
2. **Research Topic 7:** Validate if migration is worth the effort
3. Move to `/research explore-command-migration --from-explore` to investigate

### Key Themes Identified

| Theme | Summary |
|-------|---------|
| Two-Mode Architecture | Setup vs Conduct modes - command concern, not dt-doc-gen |
| Template Mapping | Gap analysis needed before migration |
| AI Work Location | Theme extraction is Cursor's job, not dt-doc-gen |
| Validation Strictness | Mode-aware validation may be over-engineering |
| Cross-Project Coordination | dev-toolkit + dev-infra PR patterns |
| Over-Engineering Risk | Weigh migration benefit vs inline restructuring |

---

**Last Updated:** 2026-01-22
