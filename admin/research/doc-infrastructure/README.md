# Doc Infrastructure - Research Hub

**Purpose:** Research for dt-doc-gen and dt-doc-validate implementation  
**Status:** 🟠 In Progress  
**Created:** 2026-01-16  
**Last Updated:** 2026-01-17

---

## 📋 Quick Links

- **[Research Summary](research-summary.md)** - Summary of all research findings
- **[Requirements](requirements.md)** - Requirements discovered during research

### Research Documents

| # | Topic | Priority | Status | Document |
|---|-------|----------|--------|----------|
| 1 | Template Fetching Strategy | 🔴 High | ✅ Complete | [research-template-fetching.md](research-template-fetching.md) |
| 2 | YAML Parsing in Bash | 🔴 High | 🔴 Not Started | [research-yaml-parsing.md](research-yaml-parsing.md) |
| 3 | Command Workflow Integration | 🔴 High | 🔴 Not Started | [research-command-integration.md](research-command-integration.md) |
| 4 | Document Type Detection | 🟡 Medium | 🔴 Not Started | [research-type-detection.md](research-type-detection.md) |
| 5 | Variable Expansion Edge Cases | 🟡 Medium | 🔴 Not Started | [research-variable-expansion.md](research-variable-expansion.md) |
| 6 | Error Output Format | 🟡 Medium | 🔴 Not Started | [research-error-output.md](research-error-output.md) |
| 7 | Shared Infrastructure Design | 🟢 Low | 🔴 Not Started | [research-shared-infrastructure.md](research-shared-infrastructure.md) |

---

## 🎯 Research Overview

Implementing two new dev-toolkit commands based on specifications from dev-infra:

- **`dt-doc-gen`** - Generate documentation from 17 templates with variable expansion
- **`dt-doc-validate`** - Validate documents against common + type-specific rules

**Research Topics:** 7 topics  
**Estimated Time:** 8-11 hours  
**Blocking Topics:** Template Fetching, YAML Parsing, Command Integration

---

## 📚 Prior Research (dev-infra)

Significant research was completed in dev-infra that informs our implementation:

| Document | Location | Key Findings |
|----------|----------|--------------|
| Generation Architecture | `dev-infra/admin/research/.../research-generation-architecture.md` | Shared library + template files; envsubst rendering |
| Validation Approach | `dev-infra/admin/research/.../research-validation-approach.md` | On-demand CLI primary; layered architecture |
| Command Integration | `dev-infra/admin/research/.../research-command-integration.md` | Commands invoke scripts; hybrid generation |
| Requirements | `dev-infra/admin/research/.../requirements.md` | 36 FRs, 18 NFRs, 18 constraints |

**Key Requirements from dev-infra:**
- FR-16: Tooling in dev-toolkit (`bin/dt-doc-gen`, `bin/dt-doc-validate`)
- FR-26: Commands invoke `dt-doc-gen` for structure
- FR-27: Commands invoke `dt-doc-validate` before commit
- C-7: Scripts generate structure, AI fills content
- C-13: Commands remain orchestrators

---

## 🚀 Next Steps

1. Conduct research for high-priority blocking topics first:
   - `/research doc-infrastructure --conduct --topic-num 1` (Template Fetching)
   - `/research doc-infrastructure --conduct --topic-num 2` (YAML Parsing)
   - `/research doc-infrastructure --conduct --topic-num 3` (Command Integration)
2. Review requirements in `requirements.md`
3. Use `/decision doc-infrastructure --from-research` to make decisions

---

**Last Updated:** 2026-01-17
