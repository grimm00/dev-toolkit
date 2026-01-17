# Research Summary - Doc Infrastructure

**Purpose:** Summary of all research findings for dt-doc-gen and dt-doc-validate  
**Status:** 🟠 In Progress  
**Created:** 2026-01-16  
**Last Updated:** 2026-01-17

---

## 📋 Research Overview

This research supports the implementation of two new dev-toolkit commands:

- **`dt-doc-gen`** - Generate documentation from 17 templates with variable expansion
- **`dt-doc-validate`** - Validate documents against common + type-specific rules

**Research Topics:** 7 topics  
**Research Documents:** 7 documents  
**Status:** 🟠 In Progress (1/7 complete)

---

## 📊 Research Progress

| # | Topic | Priority | Status |
|---|-------|----------|--------|
| 1 | Template Fetching Strategy | 🔴 High | ✅ Complete |
| 2 | YAML Parsing in Bash | 🔴 High | 🔴 Not Started |
| 3 | Command Workflow Integration | 🔴 High | 🔴 Not Started |
| 4 | Document Type Detection | 🟡 Medium | 🔴 Not Started |
| 5 | Variable Expansion Edge Cases | 🟡 Medium | 🔴 Not Started |
| 6 | Error Output Format | 🟡 Medium | 🔴 Not Started |
| 7 | Shared Infrastructure Design | 🟢 Low | 🔴 Not Started |

---

## 🔍 Key Findings

### Finding 1: Layered Template Discovery is the Recommended Strategy

Research on template fetching identified a layered discovery approach as optimal, following the priority order:

1. **Explicit CLI flag** (`--template-path`) - highest priority
2. **Environment variable** (`$DT_TEMPLATES_PATH`)
3. **Config file** (global or project)
4. **Default locations** (`$HOME/Projects/dev-infra/...`, `$HOME/.dev-infra/...`)
5. **Remote fetch** (optional, with version pinning)

This aligns with dev-toolkit's existing pattern for `$DT_ROOT` and provides maximum flexibility while maintaining simplicity for typical use cases.

**Source:** [research-template-fetching.md](research-template-fetching.md)

---

### Finding 2: Templates Must NOT Be Bundled

Bundling templates in dev-toolkit would create a version synchronization nightmare and violate the single-source-of-truth principle. Templates live in dev-infra and should be accessed via path configuration.

**Source:** [research-template-fetching.md](research-template-fetching.md)

---

### Finding 3: Dev-Infra Template Structure is Predictable

The 17 templates follow a clear hierarchical structure by document type:
- `exploration/` (3 templates)
- `research/` (4 templates)
- `decision/` (3 templates)
- `planning/` (4 templates)
- `other/` (3 templates)

Template paths follow pattern: `{TEMPLATES_ROOT}/{doc_type}/{template_name}.tmpl`

**Source:** [research-template-fetching.md](research-template-fetching.md)

---

## 💡 Key Insights

- [x] **Insight 1:** Environment variable approach aligns with dev-toolkit's existing patterns
- [x] **Insight 2:** Remote fetching is useful as fallback but shouldn't be primary
- [x] **Insight 3:** Local clone with config is simplest UX for regular users
- [ ] Insight 4: *Pending from YAML Parsing research*
- [ ] Insight 5: *Pending from Command Integration research*

---

## 📋 Requirements Summary

**See:** [requirements.md](requirements.md) for complete requirements document

### Requirements from Template Fetching Research

**Functional:**
- FR-DT-1: Explicit template path via `--template-path` CLI flag
- FR-DT-2: Environment variable template discovery (`$DT_TEMPLATES_PATH`)
- FR-DT-3: Config file template path support
- FR-DT-4: Default location checking
- FR-DT-5: Optional remote fetch with `--fetch` flag
- FR-DT-6: Version pinning for remote fetch

**Non-Functional:**
- NFR-DT-1: Offline template discovery
- NFR-DT-2: Clear setup error messages
- NFR-DT-3: Documented discovery order

**Constraints:**
- C-DT-1: No bundled templates
- C-DT-2: Bash-only core functionality

**Prior Requirements (from dev-infra):**
- FR-16: Tooling in dev-toolkit (`bin/dt-doc-gen`, `bin/dt-doc-validate`)
- FR-26: Commands invoke `dt-doc-gen` for structure
- FR-27: Commands invoke `dt-doc-validate` before commit
- C-7: Scripts generate structure, AI fills content
- C-13: Commands remain orchestrators

---

## 🎯 Recommendations

- [x] **Recommendation 1:** Implement layered discovery with environment variable as primary method
- [x] **Recommendation 2:** Use `$DT_TEMPLATES_PATH` as the standard environment variable name
- [x] **Recommendation 3:** Support `--template-path` CLI flag for explicit override
- [x] **Recommendation 4:** Add config file support for persistent configuration
- [x] **Recommendation 5:** Implement optional remote fetch with `--fetch` flag and version pinning
- [x] **Recommendation 6:** Provide clear error messages with setup instructions
- [ ] Recommendation 7: *Pending from YAML Parsing research*
- [ ] Recommendation 8: *Pending from Command Integration research*

---

## 🚀 Next Steps

1. ✅ ~~Research Topic 1: Template Fetching Strategy~~ Complete
2. Continue with remaining high-priority topics:
   - `/research doc-infrastructure --conduct --topic-num 2` (YAML Parsing)
   - `/research doc-infrastructure --conduct --topic-num 3` (Command Integration)
3. Review requirements in `requirements.md`
4. Use `/decision doc-infrastructure --from-research` when all research complete

---

**Last Updated:** 2026-01-17
