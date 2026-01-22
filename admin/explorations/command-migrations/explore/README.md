# /explore Command Migration - Exploration Hub

**Status:** 🔴 Scaffolding (needs expansion)  
**Created:** 2026-01-22  
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

1. Review [exploration.md](exploration.md) for detailed analysis
2. Identify research topics in [research-topics.md](research-topics.md)
3. Run `/explore explore-command-migration --conduct` to expand
4. Move to `/research` if questions need investigation

---

**Last Updated:** 2026-01-22
