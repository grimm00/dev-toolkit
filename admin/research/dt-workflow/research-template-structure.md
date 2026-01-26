# Research: Template Structure for Workflow Documents

**Research Topic:** dt-workflow  
**Question:** What template structure best supports AI-assisted document generation?  
**Status:** ✅ Complete  
**Created:** 2026-01-22  
**Last Updated:** 2026-01-22

---

## 🎯 Research Question

What is the optimal template structure for workflow documents (exploration, research, decision) that:
1. Provides consistent structure across all workflows
2. Enables effective AI content generation
3. Balances minimal skeleton vs. detailed structure
4. Can be maintained as a single source of truth in dev-infra

---

## 🔍 Research Goals

- [x] Goal 1: Understand trade-offs between minimal templates + AI fill vs. detailed templates
- [x] Goal 2: Identify best practices for AI-fillable template placeholders
- [x] Goal 3: Determine which sections are essential vs. optional per workflow
- [x] Goal 4: Evaluate current dev-infra templates against spike-generated structures
- [x] Goal 5: Recommend template philosophy for dev-toolkit → dev-infra

---

## 📚 Research Methodology

**Note:** Web search is **allowed and encouraged** for research. Use web search tools to find current information, best practices, documentation, examples, and real-world implementations.

**Sources Investigated:**

- [x] Current dev-infra templates (17 .tmpl files)
- [x] dt-workflow spike heredocs (what structure works in practice)
- [x] AI prompt engineering best practices for structured output
- [x] AGENTS.md best practices for AI guidance
- [x] MADR (Markdown ADR) template patterns
- [x] envsubst variable expansion patterns
- [x] Skeleton-of-Thought prompting research

---

## 📊 Current State Analysis

### Dev-Infra Templates (Current)

| Category | Files | Approach | Lines |
|----------|-------|----------|-------|
| exploration | 3 | Minimal + AI placeholders | ~44 |
| research | 4 | Minimal + AI placeholders | ~65 |
| decision | 3 | Minimal + AI placeholders | ~62 |
| planning | 4 | Minimal + AI placeholders | ~50 |
| other | 3 | Minimal + AI placeholders | ~40 |

**Placeholder Types:**
- `<!-- AI: [instruction] -->` - AI should fill this
- `<!-- EXPAND: [instruction] -->` - AI should expand with detail
- `${VARIABLE}` - envsubst variable expansion

### Spike Heredocs (What Works)

The spike uses detailed heredocs with:
- Full section structure
- Example content patterns
- Placeholder text showing expected format
- More sections than templates

**Gap Identified:**
- Spike has ~70 lines for exploration.md vs template's ~44 lines
- Spike includes sections templates lack (Themes Analyzed table, Initial Recommendations)
- Spike shows **structure examples** not just placeholders

---

## 📊 Findings

### Finding 1: Explicit Guidelines Outperform Vague Placeholders

AGENTS.md best practices emphasize: "Be as specific and detailed as possible—AI thrives on clear guidelines." Templates should include explicit, specific instructions including exact patterns, formatting approaches, and structural preferences rather than vague `<!-- AI: fill this -->` placeholders.

**Source:** [AGENTS.md Best Practices](https://agentsmd.io/agents-md-best-practices)

**Relevance:** Current dev-infra templates use minimal placeholders like `<!-- AI: Extract initial themes from input -->` but don't show the expected structure. The spike's approach of showing example table formats and section structures provides clearer guidance.

---

### Finding 2: Skeleton-of-Thought Pattern Validates Two-Phase Approach

Research on "Skeleton-of-Thought" prompting shows a two-stage approach (skeleton first, then expand) delivers **over 2x speed improvement** on most models with quality equal to or better than traditional methods in 60% of cases.

**Source:** [Skeleton-of-Thought Prompting Research](https://learnprompting.org/docs/advanced/decomposition/skeleton_of_thoughts)

**Relevance:** This validates our `<!-- AI: -->` + `<!-- EXPAND: -->` two-placeholder pattern. The distinction between "initial fill" and "elaborate" is sound. However, the skeleton should include structural hints, not just instructions.

---

### Finding 3: MADR Provides Multiple Template Complexity Levels

Markdown Architectural Decision Records (MADR) offers multiple template variants:
- **Full annotated template** - Complete with all sections and guidance
- **Minimal template** - Core sections only
- **Bare format** - Absolute minimum

This allows teams to choose appropriate complexity for their needs.

**Source:** [MADR Templates](https://adr.github.io/madr/)

**Relevance:** We should consider offering template variants. For initial exploration, a detailed template with examples may work better. For experienced users, a minimal variant could suffice.

---

### Finding 4: envsubst Has Important Constraints

envsubst only substitutes explicitly listed variables when using `SHELL-FORMAT`. Undefined variables become empty strings. Advanced shell substitutions (like `${var:-default}`) are intentionally not supported for security.

**Source:** [GNU envsubst Manual](https://www.gnu.org/software/gettext/manual/html_node/envsubst-Invocation.html)

**Relevance:** Our `render.sh` correctly uses selective variable expansion. However, we need to ensure all variables used in templates are defined in the setter functions (the gap we identified earlier with `PURPOSE`, `TOPIC_COUNT`, etc.).

---

### Finding 5: Structural Examples Guide Better Than Instructions

Comparing template approaches:

| Approach | Example |
|----------|---------|
| **Placeholder-only** | `<!-- AI: Create a themes table -->` |
| **Structure + Placeholder** | `| Theme | Finding |\n|-------|----------|\n<!-- AI: Fill rows -->` |

The second approach provides structural context that AI can follow more reliably.

**Source:** Analysis of spike vs. template outputs

**Relevance:** Templates should include **structural examples** (tables, lists, section headers) not just fill instructions. The spike's heredocs work better because they show the expected format.

---

## 🔍 Analysis

### Comparison: Template vs. Spike

| Aspect | Dev-Infra Template | Spike Heredocs | Winner |
|--------|-------------------|----------------|--------|
| **Line count** | ~44 lines | ~70 lines | Spike (more guidance) |
| **Structure clarity** | Placeholder-only | Examples + placeholders | Spike |
| **Maintainability** | Single file | Embedded in code | Template |
| **Customization** | envsubst vars | Hardcoded | Template |
| **AI guidance** | Vague | Explicit | Spike |

### The Core Trade-off

**Minimal templates** are:
- Easier to maintain
- More flexible (AI decides structure)
- Faster to update
- Risk: Inconsistent output

**Detailed templates** are:
- More work to maintain
- More consistent output
- Better AI guidance
- Risk: Over-constraining

### Recommended Hybrid Approach

Combine the best of both:
1. **Keep template files** (maintainable, customizable via envsubst)
2. **Add structural examples** (not just placeholders)
3. **Use two-phase placeholders** (`<!-- AI: -->` + `<!-- EXPAND: -->`)
4. **Offer complexity variants** (minimal for experts, full for guidance)

**Key Insights:**
- [x] Insight 1: Structural examples significantly improve AI output consistency
- [x] Insight 2: Two-phase (skeleton + expand) is validated by research
- [x] Insight 3: Template complexity variants serve different user needs
- [x] Insight 4: envsubst constraints require explicit variable management
- [x] Insight 5: Spike's detailed structure should inform template enhancement

---

## 💡 Recommendations

### R1: Enhance Templates with Structural Examples

Update dev-infra templates to include structural examples, not just placeholders.

**Before:**
```markdown
## 📊 Exploration Summary

<!-- AI: Summarize themes analyzed -->
```

**After:**
```markdown
## 📊 Exploration Summary

### Themes Analyzed

| Theme | Key Finding |
|-------|-------------|
<!-- AI: Fill theme rows based on analysis -->

### Initial Recommendations

1. <!-- AI: First recommendation -->
2. <!-- AI: Second recommendation -->
```

---

### R2: Maintain Two-Phase Placeholder Pattern

Keep the `<!-- AI: -->` and `<!-- EXPAND: -->` distinction:
- `<!-- AI: [instruction] -->` - First-pass content generation
- `<!-- EXPAND: [instruction] -->` - Elaboration during `--conduct` phase

This aligns with Skeleton-of-Thought research findings.

---

### R3: Create Template Complexity Variants

Offer multiple versions per document type:
- `exploration.md.tmpl` - Full with examples (default)
- `exploration-minimal.md.tmpl` - Core sections only
- `exploration-bare.md.tmpl` - Absolute minimum

This follows MADR's successful pattern.

---

### R4: Add Section Completeness Markers

Include markers that help validate completeness:

```markdown
## 🔍 Themes
<!-- REQUIRED: At least 2 themes -->
<!-- AI: Extract and analyze themes -->
```

This enables validation and guides AI on expectations.

---

### R5: Document Template Variable Contract

Create explicit documentation of all template variables:

| Variable | Category | Description | Default |
|----------|----------|-------------|---------|
| `DATE` | All | Current date | `YYYY-MM-DD` |
| `STATUS` | All | Document status | `🔴 Not Started` |
| `TOPIC_NAME` | All | Kebab-case topic | Required |
| `TOPIC_TITLE` | All | Title-case topic | Auto-generated |
| `PURPOSE` | All | Brief description | Auto-generated |
| `TOPIC_COUNT` | Research | Number of topics | `0` |

---

## 📋 Requirements Discovered

### FR-24: Template Structural Examples

**Description:** Templates must include structural examples (tables, lists, section formats) not just AI placeholder instructions.

**Source:** Finding 1, Finding 5

**Priority:** High

---

### FR-25: Template Complexity Variants

**Description:** Provide multiple template variants (full, minimal, bare) for each document type.

**Source:** Finding 3 (MADR pattern)

**Priority:** Medium

---

### FR-26: Section Completeness Markers

**Description:** Templates should include markers indicating required vs. optional sections and minimum content expectations.

**Source:** R4 recommendation

**Priority:** Medium

---

### FR-27: Template Variable Documentation

**Description:** Maintain explicit documentation of all template variables with categories, descriptions, and defaults.

**Source:** Finding 4, R5 recommendation

**Priority:** High

---

### NFR-7: Template-Spike Alignment

**Description:** Enhanced templates must produce output structurally equivalent to spike heredocs to maintain consistency during transition.

**Source:** Analysis comparison

**Priority:** High

---

## 🚀 Next Steps

1. **Update requirements.md** with FR-24 through FR-27 and NFR-7
2. **Create ADR-006** for template enhancement decision
3. **Update Phase 1** or **create new phase** for template work
4. **Enhance dev-infra templates** based on recommendations
5. **Update dt-workflow** to use enhanced templates via `lib/doc-gen/render.sh`

---

**Last Updated:** 2026-01-22
