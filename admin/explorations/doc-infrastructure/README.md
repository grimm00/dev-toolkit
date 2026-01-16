# Doc Infrastructure - Exploration Hub

**Status:** ✅ Expanded  
**Created:** 2026-01-16  
**Expanded:** 2026-01-16

---

## 📋 Quick Links

- **[Exploration](exploration.md)** - Main exploration document (~200 lines)
- **[Research Topics](research-topics.md)** - 6 topics to investigate

---

## 🎯 Overview

Implement `dt-doc-gen` and `dt-doc-validate` commands based on specifications from dev-infra's template-doc-infrastructure feature. These commands will:

1. **`dt-doc-gen`** - Generate documentation from 17 templates with variable expansion
2. **`dt-doc-validate`** - Validate documents against common + type-specific rules

**Why This Matters:** 154 inline template instances across 23 Cursor commands cause format drift that breaks automation.

---

## 📊 Exploration Summary

### Key Themes

| Theme | Focus |
|-------|-------|
| Document Generation | Template fetching, envsubst, mode handling, output paths |
| Document Validation | Common rules, type-specific rules, YAML parsing, error format |
| Template Integration | 17 templates, 29 variables, 6 validation rule files |
| Architecture Patterns | CLI conventions, library organization, testing approach |

### High-Priority Research Topics

1. **Template Fetching Strategy** - How to locate templates from dev-infra
2. **YAML Parsing in Bash** - How to parse rule files without external deps

### Source Specifications (dev-infra)

| File | Purpose |
|------|---------|
| `FORMAT.md` | Placeholder types (`${VAR}`, `<!-- AI: -->`, `<!-- EXPAND: -->`) |
| `VARIABLES.md` | 29 standard variables |
| `VALIDATION.md` | Validation rules and error output spec |
| `validation-rules/*.yaml` | Machine-readable rule definitions |

---

## 🚀 Next Steps

1. `/research doc-infrastructure --from-explore doc-infrastructure`
2. Focus on high-priority topics (Template Fetching, YAML Parsing)
3. `/decision doc-infrastructure --from-research`

---

**Next:** Use `/research` to investigate research topics.
