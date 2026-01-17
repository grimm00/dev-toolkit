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

## ✅ Functional Requirements (YAML Parsing - Topic 2)

### FR-YP1: Pre-compiled Bash Rules

**Description:** dt-doc-validate MUST load pre-compiled bash validation rules

**Source:** [research-yaml-parsing.md](research-yaml-parsing.md)

**Priority:** 🔴 High

**Status:** 🔴 Pending

---

### FR-YP2: Build-Time YAML Conversion

**Description:** Build system MUST convert YAML rules to bash format before release

**Source:** [research-yaml-parsing.md](research-yaml-parsing.md)

**Priority:** 🔴 High

**Status:** 🔴 Pending

---

### FR-YP3: yq for Conversion

**Description:** Conversion script MUST use yq for reliable YAML parsing

**Source:** [research-yaml-parsing.md](research-yaml-parsing.md)

**Priority:** 🔴 High

**Status:** 🔴 Pending

---

### FR-YP4: Optional Direct YAML Parsing

**Description:** dt-doc-validate SHOULD support direct YAML parsing if yq available

**Source:** [research-yaml-parsing.md](research-yaml-parsing.md)

**Priority:** 🟢 Low

**Status:** 🔴 Pending

---

### FR-YP5: Clear Rule Loading Errors

**Description:** dt-doc-validate MUST provide clear error if no rules available

**Source:** [research-yaml-parsing.md](research-yaml-parsing.md)

**Priority:** 🔴 High

**Status:** 🔴 Pending

---

### FR-YP6: Rule Content Support

**Description:** Validation rules MUST support: path patterns, required sections, error messages

**Source:** [research-yaml-parsing.md](research-yaml-parsing.md)

**Priority:** 🔴 High

**Status:** 🔴 Pending

---

## 🎯 Non-Functional Requirements (YAML Parsing - Topic 2)

### NFR-YP1: Fast Rule Loading

**Description:** Rule loading MUST complete in <100ms (pre-compiled target)

**Source:** [research-yaml-parsing.md](research-yaml-parsing.md)

**Priority:** 🟡 Medium

**Status:** 🔴 Pending

---

### NFR-YP2: Offline Operation

**Description:** dt-doc-validate MUST work offline without yq (using pre-compiled rules)

**Source:** [research-yaml-parsing.md](research-yaml-parsing.md)

**Priority:** 🔴 High

**Status:** 🔴 Pending

---

### NFR-YP3: Documented YAML Subset

**Description:** YAML subset restrictions MUST be documented

**Source:** [research-yaml-parsing.md](research-yaml-parsing.md)

**Priority:** 🟡 Medium

**Status:** 🔴 Pending

---

## ⚠️ Constraints (YAML Parsing - Topic 2)

### C-YP1: YAML Subset Conformance

**Description:** Validation rules YAML must conform to supported subset (no anchors, no flow style)

**Source:** [research-yaml-parsing.md](research-yaml-parsing.md)

---

### C-YP2: Rule Regeneration Required

**Description:** Pre-compiled bash rules must be regenerated when YAML changes

**Source:** [research-yaml-parsing.md](research-yaml-parsing.md)

---

### C-YP3: yq as Dev Dependency

**Description:** yq is required for build-time conversion (dev dependency only, not runtime)

**Source:** [research-yaml-parsing.md](research-yaml-parsing.md)

---

## ✅ Functional Requirements (Command Integration - Topic 3)

### FR-CI1: Two-Mode Support

**Description:** dt-doc-gen MUST support `--mode setup|conduct` for two-mode commands

**Source:** [research-command-integration.md](research-command-integration.md)

**Priority:** 🔴 High

**Status:** 🔴 Pending

---

### FR-CI2: Output Path Control

**Description:** dt-doc-gen MUST output files to specified `--output` path

**Source:** [research-command-integration.md](research-command-integration.md)

**Priority:** 🔴 High

**Status:** 🔴 Pending

---

### FR-CI3: Directory Validation

**Description:** dt-doc-validate MUST accept directory path for batch validation

**Source:** [research-command-integration.md](research-command-integration.md)

**Priority:** 🔴 High

**Status:** 🔴 Pending

---

### FR-CI4: Exit Codes

**Description:** dt-doc-validate MUST return exit code 0 (pass), 1 (errors), 2 (system error)

**Source:** [research-command-integration.md](research-command-integration.md)

**Priority:** 🔴 High

**Status:** 🔴 Pending

---

### FR-CI5: Pre-Commit Validation

**Description:** Commands MUST invoke dt-doc-validate before commit

**Source:** [research-command-integration.md](research-command-integration.md)

**Priority:** 🟡 Medium

**Status:** 🔴 Pending

---

### FR-CI6: Script Invocation

**Description:** Commands MUST invoke dt-doc-gen instead of inline templates (post-migration)

**Source:** [research-command-integration.md](research-command-integration.md)

**Priority:** 🟡 Medium

**Status:** 🔴 Pending

---

## 🎯 Non-Functional Requirements (Command Integration - Topic 3)

### NFR-CI1: Incremental Migration

**Description:** Migration MUST be incremental (one command at a time)

**Source:** [research-command-integration.md](research-command-integration.md)

**Priority:** 🔴 High

**Status:** 🔴 Pending

---

### NFR-CI2: Backward Compatibility

**Description:** Migration MUST NOT break existing command workflows

**Source:** [research-command-integration.md](research-command-integration.md)

**Priority:** 🔴 High

**Status:** 🔴 Pending

---

### NFR-CI3: Output Compatibility

**Description:** dt-doc-gen output MUST match current inline template output

**Source:** [research-command-integration.md](research-command-integration.md)

**Priority:** 🔴 High

**Status:** 🔴 Pending

---

### NFR-CI4: Fast Invocation

**Description:** Command invocation time for dt-doc-gen MUST be <1 second

**Source:** [research-command-integration.md](research-command-integration.md)

**Priority:** 🟡 Medium

**Status:** 🔴 Pending

---

## ⚠️ Constraints (Command Integration - Topic 3)

### C-CI1: Commands as Orchestrators

**Description:** Commands remain workflow orchestrators (no change to orchestration logic)

**Source:** [research-command-integration.md](research-command-integration.md)

---

### C-CI2: AI Content Scope

**Description:** AI generates content only for placeholders, not structure

**Source:** [research-command-integration.md](research-command-integration.md)

---

### C-CI3: Migration Fallback

**Description:** Inline templates may remain as fallback during migration (Phase 2)

**Source:** [research-command-integration.md](research-command-integration.md)

---

## ✅ Functional Requirements (Type Detection - Topic 4)

### FR-TD1: Explicit Type Override

**Description:** dt-doc-validate MUST support `--type` flag for explicit type override

**Source:** [research-type-detection.md](research-type-detection.md)

**Priority:** 🔴 High

**Status:** 🔴 Pending

---

### FR-TD2: Path-Based Detection

**Description:** dt-doc-validate MUST implement path-based type detection

**Source:** [research-type-detection.md](research-type-detection.md)

**Priority:** 🔴 High

**Status:** 🔴 Pending

---

### FR-TD3: Content-Based Fallback

**Description:** dt-doc-validate MUST implement content-based type detection as fallback

**Source:** [research-type-detection.md](research-type-detection.md)

**Priority:** 🟡 Medium

**Status:** 🔴 Pending

---

### FR-TD4: Detection Failure Reporting

**Description:** dt-doc-validate MUST report TYPE_DETECTION_FAILED with available types

**Source:** [research-type-detection.md](research-type-detection.md)

**Priority:** 🔴 High

**Status:** 🔴 Pending

---

### FR-TD5: Full Subtype Coverage

**Description:** dt-doc-validate MUST detect all 17 document subtypes

**Source:** [research-type-detection.md](research-type-detection.md)

**Priority:** 🔴 High

**Status:** 🔴 Pending

---

## 🎯 Non-Functional Requirements (Type Detection - Topic 4)

### NFR-TD1: Fast Detection

**Description:** Type detection MUST complete in <50ms per file

**Source:** [research-type-detection.md](research-type-detection.md)

**Priority:** 🟡 Medium

**Status:** 🔴 Pending

---

### NFR-TD2: Documented Detection Order

**Description:** Detection order MUST be documented (explicit → path → content)

**Source:** [research-type-detection.md](research-type-detection.md)

**Priority:** 🟡 Medium

**Status:** 🔴 Pending

---

### NFR-TD3: Helpful Error Messages

**Description:** Error messages MUST list all available type values

**Source:** [research-type-detection.md](research-type-detection.md)

**Priority:** 🟡 Medium

**Status:** 🔴 Pending

---

## ⚠️ Constraints (Type Detection - Topic 4)

### C-TD1: README.md Path Requirement

**Description:** README.md files REQUIRE path context (cannot detect from content alone)

**Source:** [research-type-detection.md](research-type-detection.md)

---

### C-TD2: Pattern Ordering

**Description:** Path patterns must be ordered from most specific to least specific

**Source:** [research-type-detection.md](research-type-detection.md)

---

## ✅ Functional Requirements (Variable Expansion - Topic 5)

### FR-VE1: Selective envsubst Mode

**Description:** dt-doc-gen MUST use selective envsubst mode (explicit variable list)

**Source:** [research-variable-expansion.md](research-variable-expansion.md)

**Priority:** 🔴 High

**Status:** 🔴 Pending

---

### FR-VE2: Variables Per Template Type

**Description:** dt-doc-gen MUST define required variables per template type

**Source:** [research-variable-expansion.md](research-variable-expansion.md)

**Priority:** 🔴 High

**Status:** 🔴 Pending

---

### FR-VE3: envsubst Availability Check

**Description:** dt-doc-gen MUST check for envsubst availability at startup

**Source:** [research-variable-expansion.md](research-variable-expansion.md)

**Priority:** 🔴 High

**Status:** 🔴 Pending

---

### FR-VE4: Missing envsubst Error

**Description:** dt-doc-gen MUST provide helpful error if envsubst is missing

**Source:** [research-variable-expansion.md](research-variable-expansion.md)

**Priority:** 🟡 Medium

**Status:** 🔴 Pending

---

### FR-VE5: Variable Export

**Description:** dt-doc-gen MUST export all required variables before expansion

**Source:** [research-variable-expansion.md](research-variable-expansion.md)

**Priority:** 🔴 High

**Status:** 🔴 Pending

---

## 🎯 Non-Functional Requirements (Variable Expansion - Topic 5)

### NFR-VE1: Preserve Dollar Syntax

**Description:** Variable expansion MUST preserve `$VAR` syntax (no braces)

**Source:** [research-variable-expansion.md](research-variable-expansion.md)

**Priority:** 🔴 High

**Status:** 🔴 Pending

---

### NFR-VE2: Preserve HTML Comments

**Description:** Variable expansion MUST preserve HTML comments (AI markers)

**Source:** [research-variable-expansion.md](research-variable-expansion.md)

**Priority:** 🔴 High

**Status:** 🔴 Pending

---

### NFR-VE3: Unicode Support

**Description:** Variable expansion MUST handle Unicode/emoji correctly

**Source:** [research-variable-expansion.md](research-variable-expansion.md)

**Priority:** 🔴 High

**Status:** 🔴 Pending

---

## ⚠️ Constraints (Variable Expansion - Topic 5)

### C-VE1: gettext Dependency

**Description:** envsubst requires gettext package (not pre-installed on macOS)

**Source:** [research-variable-expansion.md](research-variable-expansion.md)

---

### C-VE2: No Backslash Escape

**Description:** Backslash escaping does NOT work - must use selective mode

**Source:** [research-variable-expansion.md](research-variable-expansion.md)

---

### C-VE3: Multi-line Values

**Description:** Multi-line variable values may affect markdown formatting

**Source:** [research-variable-expansion.md](research-variable-expansion.md)

---

## ✅ Functional Requirements (Error Output - Topic 6)

### FR-EO1: Text Output Format

**Description:** dt-doc-validate MUST support text output format (default)

**Source:** [research-error-output.md](research-error-output.md)

**Priority:** 🔴 High

**Status:** 🔴 Pending

---

### FR-EO2: JSON Output Format

**Description:** dt-doc-validate MUST support JSON output format (`--json`)

**Source:** [research-error-output.md](research-error-output.md)

**Priority:** 🔴 High

**Status:** 🔴 Pending

---

### FR-EO3: Complete Error Information

**Description:** Every error MUST include file, message, and fix suggestion

**Source:** [research-error-output.md](research-error-output.md)

**Priority:** 🔴 High

**Status:** 🔴 Pending

---

### FR-EO4: Exit Codes

**Description:** dt-doc-validate MUST return exit code 0 (success), 1 (validation error), 2 (system error)

**Source:** [research-error-output.md](research-error-output.md)

**Priority:** 🔴 High

**Status:** 🔴 Pending

---

### FR-EO5: Summary Statistics

**Description:** Multi-file validation MUST provide summary statistics

**Source:** [research-error-output.md](research-error-output.md)

**Priority:** 🟡 Medium

**Status:** 🔴 Pending

---

### FR-EO6: Error Code Convention

**Description:** Error codes MUST follow `CATEGORY_SPECIFIC_ERROR` convention

**Source:** [research-error-output.md](research-error-output.md)

**Priority:** 🟡 Medium

**Status:** 🔴 Pending

---

## 🎯 Non-Functional Requirements (Error Output - Topic 6)

### NFR-EO1: Human Readable Text

**Description:** Text output MUST be human-readable without tooling

**Source:** [research-error-output.md](research-error-output.md)

**Priority:** 🔴 High

**Status:** 🔴 Pending

---

### NFR-EO2: Valid JSON

**Description:** JSON output MUST be valid JSON parseable by jq

**Source:** [research-error-output.md](research-error-output.md)

**Priority:** 🔴 High

**Status:** 🔴 Pending

---

### NFR-EO3: Color Degradation

**Description:** Color output MUST detect TTY and degrade gracefully

**Source:** [research-error-output.md](research-error-output.md)

**Priority:** 🟡 Medium

**Status:** 🔴 Pending

---

### NFR-EO4: Actionable Fixes

**Description:** Fix suggestions MUST be specific and actionable

**Source:** [research-error-output.md](research-error-output.md)

**Priority:** 🔴 High

**Status:** 🔴 Pending

---

## ⚠️ Constraints (Error Output - Topic 6)

### C-EO1: Severity Impact

**Description:** ERROR severity causes exit 1; WARNING does not affect exit code

**Source:** [research-error-output.md](research-error-output.md)

---

### C-EO2: JSON Mode Colors

**Description:** JSON output disables colors and emoji symbols

**Source:** [research-error-output.md](research-error-output.md)

---

### C-EO3: Exit Code 2 Reserved

**Description:** Exit code 2 reserved for system errors (not validation failures)

**Source:** [research-error-output.md](research-error-output.md)

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
