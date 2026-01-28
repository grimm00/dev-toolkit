# Requirements - /explore Command Migration

**Source:** Research on /explore command migration to dt-doc-gen  
**Status:** Draft  
**Created:** 2026-01-22  
**Last Updated:** 2026-01-22

---

## 📋 Overview

This document captures requirements discovered during research on migrating the /explore Cursor command to use dt-doc-gen and dt-doc-validate.

**Research Source:** [research-summary.md](research-summary.md)

---

## ✅ Functional Requirements

### FR-1: Variable Support for Exploration Templates

**Description:** dt-doc-gen must support `TOPIC_NAME`, `TOPIC_TITLE`, `DATE`, `STATUS` variables for exploration templates

**Source:** [research-template-gap-analysis.md](research-template-gap-analysis.md)

**Priority:** High

**Status:** ✅ Already Supported (Phase 2)

---

### FR-2: AI Section Population

**Description:** Command wrapper (Cursor) must populate AI/EXPAND sections with themes and questions extracted from user input

**Source:** [research-template-gap-analysis.md](research-template-gap-analysis.md)

**Priority:** High

**Status:** 🔴 Pending (Migration work)

---

### FR-3: Mode-Specific Status Handling

**Description:** dt-doc-gen must handle Setup Mode status (`🔴 Scaffolding`) and Conduct Mode status (`✅ Expanded`) via STATUS variable

**Source:** [research-template-gap-analysis.md](research-template-gap-analysis.md)

**Priority:** High

**Status:** ✅ Already Supported (STATUS variable)

---

## 🎯 Non-Functional Requirements

### NFR-1: Validation Rule Compliance

**Description:** Template output must pass dev-infra validation rules (exploration.yaml)

**Source:** [research-template-gap-analysis.md](research-template-gap-analysis.md)

**Priority:** High

**Status:** 🔴 Pending (Verify during migration)

---

### NFR-2: Marker Convention Alignment

**Description:** Marker convention should align with dev-infra (`<!-- AI: -->`, `<!-- EXPAND: -->`) instead of `<!-- PLACEHOLDER: -->`

**Source:** [research-template-gap-analysis.md](research-template-gap-analysis.md)

**Priority:** Medium

**Status:** 🔴 Pending (Convention change)

---

## ⚠️ Constraints

<!-- PLACEHOLDER: Will be filled as research discovers constraints -->

### C-1: dt-doc-gen Uses envsubst

**Description:** dt-doc-gen Phase 2 uses envsubst for variable expansion, which does not support conditionals or array iteration.

**Source:** [Exploration Theme 1]

**Implications:** Mode handling must be outside template system

---

### C-2: Cross-Project Dependency

**Description:** Templates live in dev-infra; changes may require PRs to another repository.

**Source:** [Exploration Theme 8]

**Implications:** Coordination overhead affects velocity

---

## 💭 Assumptions

<!-- PLACEHOLDER: Will be filled as research identifies assumptions -->

### A-1: AI Work Stays in Cursor

**Description:** Theme extraction and content expansion remain in the Cursor command, not dt-doc-gen.

**Source:** [Exploration Theme 3]

**Validation:** ✅ VALIDATED - Templates use AI markers, not array variables

---

### A-2: Templates Exist in Dev-Infra

**Description:** We assume dev-infra has exploration templates that can be used or modified.

**Source:** [Exploration]

**Validation:** ✅ VALIDATED - All 3 templates exist and are compatible

---

## 🔗 Related Documents

- [Research Summary](research-summary.md)
- [Research Documents](README.md)
- [Exploration](../../../explorations/command-migrations/explore/exploration.md)

---

## 🚀 Next Steps

1. Complete research to discover full requirements
2. Refine requirements based on findings
3. Use `/decision explore-command-migration --from-research` to make decisions
4. Decisions may refine or eliminate requirements

---

**Last Updated:** 2026-01-22
