# Phase 2 Template Enhancement Requirements

**Purpose:** Document template changes needed in dev-infra for Phase 2, Tasks 1-3  
**Status:** 🟡 Pending (dev-infra changes required)  
**Created:** 2026-01-26  
**Related:** ADR-006, FR-24, FR-26, NFR-7

---

## Overview

This document specifies the template enhancements needed in dev-infra to support Phase 2 of dt-workflow. These changes align templates with ADR-006 (structural examples) and ensure output matches spike heredoc quality (NFR-7).

**Note:** Templates are maintained in dev-infra (`scripts/doc-gen/templates/`). This document serves as a specification for dev-infra changes.

---

## Task 1: Exploration Template Enhancement

**File:** `exploration/exploration.md.tmpl`

### Current State

The current template uses minimal placeholders like:
```markdown
## 🔍 Themes

<!-- AI: Extract initial themes from input -->
<!-- EXPAND: Expand themes with detailed analysis... -->
```

### Required Changes

Add structural examples per ADR-006 and FR-24:

#### 1. Add Themes Analyzed Section

**Location:** After "## 🔍 Themes" section

**Add:**
```markdown
## 📊 Exploration Summary

### Themes Analyzed
<!-- REQUIRED: At least 2 themes -->

| Theme | Key Finding |
|-------|-------------|
<!-- AI: Fill theme rows based on analysis. Each row: | Theme Name | One-sentence finding | -->
```

**Rationale:** Provides structural example for AI to follow, improving consistency (FR-24). Matches spike heredoc structure (NFR-7).

#### 2. Add Initial Recommendations Section

**Location:** After Themes Analyzed section

**Add:**
```markdown
### Initial Recommendations

1. <!-- AI: First recommendation based on themes -->
2. <!-- AI: Second recommendation -->
3. <!-- AI: Third recommendation (if applicable) -->
```

**Rationale:** Provides numbered list structure example. Matches spike heredoc output.

#### 3. Add REQUIRED Markers

**Location:** Before sections that need minimum content

**Add markers:**
- `<!-- REQUIRED: At least 2 themes -->` before Themes Analyzed table
- `<!-- REQUIRED: At least 2 recommendations -->` before Initial Recommendations

**Rationale:** Enables validation and guides AI on expectations (FR-26).

### Expected Output Structure

After enhancement, template should produce output like:

```markdown
## 📊 Exploration Summary

### Themes Analyzed
<!-- REQUIRED: At least 2 themes -->

| Theme | Key Finding |
|-------|-------------|
<!-- AI: Fill theme rows based on analysis. Each row: | Theme Name | One-sentence finding | -->

### Initial Recommendations

1. <!-- AI: First recommendation based on themes -->
2. <!-- AI: Second recommendation -->
```

---

## Task 2: Research Template Enhancement

**File:** `research/research-topic.md.tmpl`

### Current State

The current template has placeholders but lacks structural examples:
```markdown
## 🔍 Research Goals

<!-- AI: List goals -->

## 📊 Findings

<!-- EXPAND: Document findings with sources and relevance -->

**Key Insights:**
<!-- AI: List key insights -->
```

### Required Changes

Add structural examples per ADR-006 and FR-24:

#### 1. Enhance Research Goals Section

**Location:** Replace existing "## 🔍 Research Goals" section

**Replace with:**
```markdown
## 🔍 Research Goals
<!-- REQUIRED: At least 3 goals -->

- [x] Goal 1: <!-- AI: First goal statement -->
- [ ] Goal 2: <!-- AI: Second goal statement -->
- [ ] Goal 3: <!-- AI: Third goal statement -->
```

**Rationale:** Provides checklist structure example for AI to follow (FR-24). Enables tracking goal completion.

#### 2. Enhance Findings Section

**Location:** Enhance existing "## 📊 Findings" section

**Add structure:**
```markdown
## 📊 Findings

### Finding 1: [Title]
<!-- EXPAND: Add detailed explanation with sources -->

**Source:** [Link or reference]
**Relevance:** <!-- AI: How this relates to the research question -->

### Finding 2: [Title]
<!-- EXPAND: Add detailed explanation with sources -->

**Source:** [Link or reference]
**Relevance:** <!-- AI: How this relates to the research question -->
```

**Rationale:** Provides structured format for findings with source tracking. Maintains two-phase pattern (EXPAND for details, AI for relevance).

#### 3. Enhance Key Insights Section

**Location:** Enhance existing "**Key Insights:**" section

**Replace with:**
```markdown
**Key Insights:**
<!-- REQUIRED: At least 3 insights -->

1. <!-- AI: First key insight -->
2. <!-- AI: Second key insight -->
3. <!-- AI: Third key insight -->
```

**Rationale:** Provides numbered list structure example. Matches spike heredoc output patterns.

#### 4. Add REQUIRED Markers

**Location:** Before sections that need minimum content

**Add markers:**
- `<!-- REQUIRED: At least 3 goals -->` before Research Goals checklist
- `<!-- REQUIRED: At least 3 insights -->` before Key Insights list

**Rationale:** Enables validation and guides AI on expectations (FR-26).

### Expected Output Structure

After enhancement, template should produce output like:

```markdown
## 🔍 Research Goals
<!-- REQUIRED: At least 3 goals -->

- [x] Goal 1: <!-- AI: First goal statement -->
- [ ] Goal 2: <!-- AI: Second goal statement -->
- [ ] Goal 3: <!-- AI: Third goal statement -->

## 📊 Findings

### Finding 1: [Title]
<!-- EXPAND: Add detailed explanation with sources -->

**Source:** [Link or reference]
**Relevance:** <!-- AI: How this relates to the research question -->

**Key Insights:**
<!-- REQUIRED: At least 3 insights -->

1. <!-- AI: First key insight -->
2. <!-- AI: Second key insight -->
3. <!-- AI: Third key insight -->
```

### Validation

**Test File:** `dev-toolkit/tests/unit/test-template-enhancement.bats`

Tests validate:
- ✅ Research Goals checklist structure exists (`- [ ]` or `- [x]`)
- ✅ Research Goals section exists (`## 🔍 Research Goals`)
- ✅ Findings section exists (`## 📊 Findings`)
- ✅ Key Insights numbered list exists (`1. <!-- AI:`)
- ✅ Two-phase placeholders exist (`<!-- AI:` and `<!-- EXPAND:`)
- ✅ REQUIRED markers exist (`<!-- REQUIRED:`)
- ✅ Methodology section exists (`## 📚 Research Methodology`)

**Status:** Tests currently FAIL until templates are enhanced.

---

## Validation

**Test File:** `dev-toolkit/tests/unit/test-template-enhancement.bats`

Tests validate:
- ✅ Themes table structure exists (`| Theme | Key Finding |`)
- ✅ Table separator exists (`|-------|-------------|`)
- ✅ AI placeholder exists (`<!-- AI: Fill theme rows`)
- ✅ Initial Recommendations section exists
- ✅ Numbered list structure exists (`1. <!-- AI:`)
- ✅ REQUIRED markers exist (`<!-- REQUIRED:`)
- ✅ Themes Analyzed section exists

**Status:** Tests currently FAIL until templates are enhanced.

---

## Alignment with Spike Heredocs

**Reference:** Spike heredoc output from `bin/dt-workflow` (Phase 1)

The enhanced templates must produce output structurally equivalent to spike heredocs per NFR-7:

**Spike Output Includes:**
- Themes Analyzed table
- Initial Recommendations numbered list
- Structured sections with examples

**Template Output Must Match:**
- Same section names
- Same table/list structures
- Same placeholder patterns

---

## Implementation Notes

1. **Preserve Existing Structure:** Keep current sections, add new structural examples
2. **Maintain Two-Phase Placeholders:** Keep `<!-- AI: -->` and `<!-- EXPAND: -->` distinction
3. **Variable Substitution:** Ensure `${VARIABLE}` placeholders remain functional
4. **Backward Compatibility:** Enhanced templates should work with existing `render.sh`

---

## Next Steps

1. ✅ **dev-toolkit:** Tests created (RED phase complete)
2. ✅ **dev-infra:** Issue created: [#62](https://github.com/grimm00/dev-infra/issues/62)
3. 🟡 **dev-infra:** Enhance `exploration/exploration.md.tmpl` per this spec
4. 🟡 **dev-infra:** Run dev-toolkit tests to validate changes
5. 🟡 **dev-toolkit:** Verify tests pass (GREEN phase)
6. 🟡 **dev-infra:** Create PR with template changes
7. 🟡 **dev-toolkit:** Update dt-workflow to use enhanced templates

---

## Related Documents

- [ADR-006: Template Enhancement](../../decisions/dt-workflow/adr-006-template-enhancement.md)
- [Research: Template Structure](../../research/dt-workflow/research-template-structure.md)
- [Phase 2 Plan](phase-2.md)
- [Requirements](../../research/dt-workflow/requirements.md)

---

**Last Updated:** 2026-01-26
