# Requirements - Doc Infrastructure

**Source:** Research on doc-infrastructure  
**Status:** Draft  
**Created:** 2026-01-16  
**Last Updated:** 2026-01-17

---

## 📋 Overview

This document captures requirements discovered during research on doc-infrastructure implementation. It also incorporates prior requirements from dev-infra research.

**Research Source:** [research-summary.md](research-summary.md)  
**Prior Research:** dev-infra/admin/research/template-doc-infrastructure/requirements.md

---

## 📚 Prior Requirements (from dev-infra)

The following requirements were established in dev-infra research and are adopted here:

### Functional Requirements (Adopted)

| ID | Requirement | Priority | Source |
|----|-------------|----------|--------|
| FR-16 | Tooling in dev-toolkit (`bin/dt-doc-gen`, `bin/dt-doc-validate`) | 🔴 High | dev-infra |
| FR-26 | Commands invoke `dt-doc-gen` for structure | 🔴 High | dev-infra |
| FR-27 | Commands invoke `dt-doc-validate` before commit | 🟡 Medium | dev-infra |
| FR-28 | Three placeholder types: `${VAR}`, `<!-- AI: -->`, `<!-- EXPAND: -->` | 🔴 High | dev-infra |
| FR-29 | Two-mode templates with clear expansion zones | 🔴 High | dev-infra |

### Non-Functional Requirements (Adopted)

| ID | Requirement | Priority | Source |
|----|-------------|----------|--------|
| NFR-5 | Standard bash (no exotic dependencies) | 🔴 High | dev-infra |
| NFR-6 | Fast rendering (<1 second per file) | 🟡 Medium | dev-infra |
| NFR-11 | Fast validation (<1 second per file) | 🟡 Medium | dev-infra |
| NFR-12 | Clear exit codes (0=pass, 1=errors, 2=usage) | 🔴 High | dev-infra |

### Constraints (Adopted)

| ID | Constraint | Source |
|----|------------|--------|
| C-4 | No external dependencies beyond coreutils | dev-infra |
| C-5 | Cross-platform (macOS and Linux) | dev-infra |
| C-7 | Scripts generate structure, AI fills content | dev-infra |
| C-13 | Commands remain orchestrators; scripts are tools | dev-infra |

---

## ✅ Functional Requirements (New)

### FR-DT-1: Explicit Template Path Flag

**Description:** dt-doc-gen MUST support explicit template path via `--template-path` CLI flag

**Source:** [research-template-fetching.md](research-template-fetching.md)

**Priority:** 🔴 High

**Status:** 🔴 Pending

---

### FR-DT-2: Environment Variable Template Discovery

**Description:** dt-doc-gen MUST check `$DT_TEMPLATES_PATH` environment variable for template location

**Source:** [research-template-fetching.md](research-template-fetching.md)

**Priority:** 🔴 High

**Status:** 🔴 Pending

---

### FR-DT-3: Config File Template Path

**Description:** dt-doc-gen MUST check config file for `DT_TEMPLATES_PATH` setting

**Source:** [research-template-fetching.md](research-template-fetching.md)

**Priority:** 🟡 Medium

**Status:** 🔴 Pending

---

### FR-DT-4: Default Template Locations

**Description:** dt-doc-gen SHOULD check common default locations (`$HOME/Projects/dev-infra/...`, `$HOME/.dev-infra/...`)

**Source:** [research-template-fetching.md](research-template-fetching.md)

**Priority:** 🟡 Medium

**Status:** 🔴 Pending

---

### FR-DT-5: Optional Remote Fetch

**Description:** dt-doc-gen MAY support remote template fetch with `--fetch` flag (requires version pinning)

**Source:** [research-template-fetching.md](research-template-fetching.md)

**Priority:** 🟢 Low

**Status:** 🔴 Pending

---

### FR-DT-6: Version Pinning for Remote Fetch

**Description:** Remote fetch MUST require version pinning (`$DT_TEMPLATES_VERSION`)

**Source:** [research-template-fetching.md](research-template-fetching.md)

**Priority:** 🟢 Low (only if FR-DT-5 implemented)

**Status:** 🔴 Pending

---

## 🎯 Non-Functional Requirements (New)

### NFR-DT-1: Offline Template Discovery

**Description:** Template discovery MUST work offline (network not required for local paths)

**Source:** [research-template-fetching.md](research-template-fetching.md)

**Priority:** 🔴 High

**Status:** 🔴 Pending

---

### NFR-DT-2: Clear Setup Error Messages

**Description:** Error messages MUST include clear setup instructions when templates not found

**Source:** [research-template-fetching.md](research-template-fetching.md)

**Priority:** 🔴 High

**Status:** 🔴 Pending

---

### NFR-DT-3: Documented Discovery Order

**Description:** Template discovery order MUST be documented and predictable

**Source:** [research-template-fetching.md](research-template-fetching.md)

**Priority:** 🟡 Medium

**Status:** 🔴 Pending

---

## ⚠️ Constraints (New)

### C-DT-1: No Bundled Templates

**Description:** Templates are NOT bundled with dev-toolkit (single source of truth in dev-infra)

**Source:** [research-template-fetching.md](research-template-fetching.md)

---

### C-DT-2: Bash-Only Core Functionality

**Description:** Bash-only implementation (no external dependencies for core functionality)

**Source:** [research-template-fetching.md](research-template-fetching.md)

---

## 💭 Assumptions

### A-1: dev-infra Available Locally

**Description:** During development, dev-infra is expected to be cloned locally alongside dev-toolkit for template access.

**Source:** Project context

---

### A-2: Cursor Environment Primary

**Description:** Primary usage is within Cursor IDE where AI can execute shell commands.

**Source:** dev-infra research

---

## 🔗 Related Documents

- [Research Summary](research-summary.md)
- [Research Hub](README.md)
- [Exploration](../../explorations/doc-infrastructure/README.md)
- [dev-infra Requirements](~/Projects/dev-infra/admin/research/template-doc-infrastructure/requirements.md)

---

## 🚀 Next Steps

1. Conduct research and extract requirements
2. Review and prioritize requirements
3. Use `/decision doc-infrastructure --from-research` to make decisions
4. Decisions may refine requirements

---

**Last Updated:** 2026-01-17
