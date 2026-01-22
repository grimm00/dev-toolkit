# Research: Template Inspection & Gap Analysis

**Research Topic:** /explore Command Migration  
**Question:** What's the actual structure of dev-infra exploration templates, and what gaps exist?  
**Status:** ✅ Complete  
**Priority:** 🔴 BLOCKING  
**Created:** 2026-01-22  
**Completed:** 2026-01-22  
**Last Updated:** 2026-01-22

---

## 🎯 Research Question

This research combines Topics 2 and 6 from the exploration:
1. What's the actual structure of dev-infra exploration templates?
2. What variables does /explore need that dev-infra templates don't provide?

**Why BLOCKING:** Can't make any migration decisions without knowing what dev-infra templates actually contain.

---

## 🔍 Research Goals

- [x] Goal 1: Document dev-infra exploration template structure (files, sections, variables)
- [x] Goal 2: Document /explore inline template structure (from `.cursor/commands/explore.md`)
- [x] Goal 3: Create comparison matrix of Expected vs Available
- [x] Goal 4: List gaps and proposed solutions

---

## 📚 Research Methodology

**Sources:**

- [x] Dev-infra repository: `scripts/doc-gen/templates/exploration/`
- [x] Dev-toolkit Cursor command: `.cursor/commands/explore.md`
- [x] Dev-infra VARIABLES.md: Complete variable reference
- [x] Dev-infra validation rules: `validation-rules/exploration.yaml`

**Note:** Direct file inspection of actual templates - no web search needed.

---

## 📊 Findings

### Finding 1: Dev-Infra Template Structure

**Files found (3 templates):**

| File | Lines | Purpose |
|------|-------|---------|
| `README.md.tmpl` | 32 lines | Exploration hub with quick links |
| `exploration.md.tmpl` | 44 lines | Main exploration document |
| `research-topics.md.tmpl` | 21 lines | Research topics listing |

**Variables expected (from VARIABLES.md):**

| Variable | Description | Example |
|----------|-------------|---------|
| `${TOPIC_NAME}` | Topic identifier (kebab-case) | `template-doc-infrastructure` |
| `${TOPIC_TITLE}` | Topic display name (Title Case) | `Template Doc Infrastructure` |
| `${DATE}` | Current date (YYYY-MM-DD) | `2026-01-22` |
| `${STATUS}` | Status indicator | `🔴 Scaffolding` |
| `${PURPOSE}` | Document purpose statement | `Research for template infrastructure` |
| `${TOPIC_COUNT}` | Number of topics identified | `7` |

**Section structure (exploration.md.tmpl):**

```markdown
# Exploration: ${TOPIC_TITLE}

**Status:** ${STATUS}
**Created:** ${DATE}

## 🎯 What We're Exploring
<!-- AI: Provide a 2-3 sentence summary extracted from input -->
<!-- EXPAND: Detailed description with context, background, and motivation -->

## 🔍 Themes
<!-- AI: Extract initial themes from input -->
<!-- EXPAND: Expand themes with detailed analysis, connections, implications, and concerns -->

## ❓ Key Questions
<!-- AI: Extract key questions from input -->
<!-- EXPAND: Add context, sub-questions, and research approach -->

## 💡 Initial Thoughts
<!-- EXPAND: Add detailed initial thinking with evidence, opportunities, and concerns -->

## 🚀 Next Steps
## 🔗 Related
```

**AI markers found:**
- `<!-- AI: [instruction] -->` - For AI-generated content
- `<!-- EXPAND: [instruction] -->` - For Conduct Mode expansion

**Source:** Direct inspection of `/Users/cdwilson/Projects/dev-infra/scripts/doc-gen/templates/exploration/`

**Relevance:** Templates are well-structured and use AI markers to support both Setup and Conduct modes

---

### Finding 2: /explore Inline Template Structure

**Setup Mode output (~60-80 lines total):**

| File | Lines | Structure |
|------|-------|-----------|
| `README.md` | ~20 lines | Hub with quick links |
| `exploration.md` | ~40-50 lines | Scaffolding with placeholders |
| `research-topics.md` | ~20-30 lines | Prioritized questions |

**Conduct Mode output (~200-300 lines total):**
- Same files but expanded with detailed analysis
- Status changes from `🔴 Scaffolding (needs expansion)` to `✅ Expanded`
- Adds `**Expanded:** YYYY-MM-DD` metadata field

**Variables used in inline templates:**

| Variable | Example |
|----------|---------|
| `[Topic]` / `[topic]` | Placeholder for topic name |
| `YYYY-MM-DD` | Placeholder for date |
| Status indicators | `🔴 Scaffolding`, `✅ Expanded` |

**Placeholder pattern:**
```markdown
<!-- PLACEHOLDER: Expand with detailed analysis in conduct mode -->
```

**Key structural differences (Setup Mode):**

| Section | /explore Inline | Dev-Infra Template |
|---------|-----------------|---------------------|
| Theme header | `## 🔍 Initial Themes` | `## 🔍 Themes` |
| Theme format | `### Theme 1: [Name]` + placeholder | AI marker only |
| Question format | Numbered list | AI marker only |
| Status format | `🔴 Scaffolding (needs expansion)` | `${STATUS}` (customizable) |

**Source:** `.cursor/commands/explore.md` lines 400-600

**Relevance:** Inline templates are more prescriptive about structure; dev-infra templates defer to AI

---

### Finding 3: Validation Rules

**Dev-infra validation rules exist (`exploration.yaml`):**

**exploration.md validation:**
- Required sections: `## 🎯 What We're Exploring`, `## 🔍 Themes`, `## ❓ Key Questions`
- Status header required
- Created date required
- Stale threshold: 30 days

**research-topics.md validation:**
- Required section: `## 📋 Topics Identified`
- Status header required
- Created date required

**README.md (hub) validation:**
- Required sections: `## 📋 Quick Links`, `## 🎯 Overview`
- Status, created date, last updated all required

**Source:** `/Users/cdwilson/Projects/dev-infra/scripts/doc-gen/templates/validation-rules/exploration.yaml`

**Relevance:** Validation rules are already comprehensive and match /explore expected output

---

### Finding 4: Gap Analysis Matrix

| Element | /explore Needs | Dev-Infra Has | Gap? | Solution |
|---------|----------------|---------------|------|----------|
| **Files** | | | | |
| README.md | ✅ Yes | ✅ Yes | ❌ No | - |
| exploration.md | ✅ Yes | ✅ Yes | ❌ No | - |
| research-topics.md | ✅ Yes | ✅ Yes | ❌ No | - |
| **Variables** | | | | |
| TOPIC_NAME | ✅ Yes | ✅ Yes | ❌ No | - |
| TOPIC_TITLE | ✅ Yes | ✅ Yes | ❌ No | - |
| DATE | ✅ Yes | ✅ Yes | ❌ No | - |
| STATUS | ✅ Yes | ✅ Yes | ❌ No | - |
| PURPOSE | ✅ Yes (hub only) | ✅ Yes | ❌ No | - |
| TOPIC_COUNT | ⚠️ Optional | ✅ Yes | ❌ No | - |
| **Dynamic Content** | | | | |
| THEMES (array) | ✅ Yes | ⚠️ AI marker | ⚠️ Minor | AI fills in |
| QUESTIONS (array) | ✅ Yes | ⚠️ AI marker | ⚠️ Minor | AI fills in |
| **Mode Support** | | | | |
| Setup Mode | ✅ Yes | ✅ Via AI/EXPAND markers | ❌ No | - |
| Conduct Mode | ✅ Yes | ✅ Via EXPAND markers | ❌ No | - |
| **Markers** | | | | |
| `<!-- PLACEHOLDER: -->` | ✅ Yes | ⚠️ Uses `<!-- EXPAND: -->` | ⚠️ Minor | Use dev-infra convention |
| `<!-- AI: -->` | ⚠️ Not explicit | ✅ Yes | ❌ No | Adopt dev-infra pattern |
| **Sections** | | | | |
| What We're Exploring | ✅ Yes | ✅ Yes | ❌ No | - |
| Themes/Initial Themes | ✅ `Initial Themes` | ✅ `Themes` | ⚠️ Minor | Align naming |
| Key Questions | ✅ Yes | ✅ Yes | ❌ No | - |
| Initial Thoughts | ✅ Yes | ✅ Yes | ❌ No | - |
| Next Steps | ✅ Yes | ✅ Yes | ❌ No | - |
| Related | ⚠️ Optional | ✅ Yes | ❌ No | - |
| **Validation** | | | | |
| Required sections | ✅ Yes | ✅ Yes | ❌ No | - |
| Status validation | ✅ Yes | ✅ Yes | ❌ No | - |

**Legend:** ✅ = Present/Aligned | ⚠️ = Minor difference | ❌ = Gap

**Source:** Comparison of findings 1-3

**Relevance:** **Gaps are minimal** - dev-infra templates are well-aligned with /explore needs

---

## 🔍 Analysis

**Overall Assessment:** Templates are **highly compatible**. The gaps are minor and can be addressed with minimal effort.

**Key Insights:**

- [x] **Insight 1:** Dev-infra templates use `<!-- AI: -->` and `<!-- EXPAND: -->` markers instead of `<!-- PLACEHOLDER: -->`. This is a convention difference, not a functional gap. The dev-infra convention is actually **better** because it distinguishes between initial AI content and expansion.

- [x] **Insight 2:** Dev-infra templates are **less prescriptive** than /explore inline templates. They use AI markers where /explore has explicit structure. This means **the AI (Cursor) still does the same work** - it just populates templates differently.

- [x] **Insight 3:** Variables are simple strings, **not arrays**. Themes and questions are generated by AI, not passed as array variables. This is the correct architecture - dt-doc-gen handles structure, Cursor AI handles content.

- [x] **Insight 4:** Validation rules already exist and are comprehensive. No new validation rules needed for /explore migration.

**Migration Complexity Assessment:**

| Complexity Factor | Assessment | Notes |
|-------------------|------------|-------|
| Template structure | 🟢 Low | Well-aligned |
| Variable mapping | 🟢 Low | All needed vars exist |
| Mode support | 🟢 Low | AI/EXPAND markers work |
| Validation | 🟢 Low | Rules already exist |
| AI integration | 🟢 Low | Same pattern as today |
| **Overall** | **🟢 Low** | Migration is straightforward |

---

## 💡 Recommendations

- [x] **Recommendation 1:** Proceed with migration - gaps are minimal and templates are compatible

- [x] **Recommendation 2:** Adopt dev-infra marker convention (`<!-- AI: -->` and `<!-- EXPAND: -->`) instead of `<!-- PLACEHOLDER: -->`

- [x] **Recommendation 3:** Minor section naming alignment: use `## 🔍 Themes` (dev-infra) instead of `## 🔍 Initial Themes` (/explore Setup)

- [x] **Recommendation 4:** No dev-infra PRs needed for basic migration - templates are sufficient as-is

---

## 📋 Requirements Discovered

### Functional Requirements

- [x] **REQ-1:** dt-doc-gen must support `TOPIC_NAME`, `TOPIC_TITLE`, `DATE`, `STATUS` variables for exploration templates

- [x] **REQ-2:** Command wrapper (Cursor) must populate AI/EXPAND sections with themes and questions

- [x] **REQ-3:** dt-doc-gen must handle Setup Mode status (`🔴 Scaffolding`) and Conduct Mode status (`✅ Expanded`)

### Non-Functional Requirements

- [x] **NFR-1:** Template output must pass dev-infra validation rules (exploration.yaml)

- [x] **NFR-2:** Marker convention should align with dev-infra (`<!-- AI: -->`, `<!-- EXPAND: -->`)

### Constraints

- [x] **C-1:** envsubst does not support conditionals or arrays - AI work must remain in Cursor command

### Assumptions Validated

- [x] **A-1:** ✅ Templates exist in dev-infra (VALIDATED)
- [x] **A-2:** ✅ AI work stays in Cursor (VALIDATED - templates use AI markers, not array variables)

---

## 🚀 Next Steps

1. ✅ Gap analysis complete - **migration is viable with low complexity**
2. Proceed to **Migration Value Assessment** (Topic #2) with this data
3. If value assessment is positive, implement minimal prototype
4. No dev-infra PRs needed for basic migration

---

## 🔗 Related Documents

- [Dev-infra VARIABLES.md](/Users/cdwilson/Projects/dev-infra/scripts/doc-gen/templates/VARIABLES.md)
- [Dev-infra exploration.yaml](/Users/cdwilson/Projects/dev-infra/scripts/doc-gen/templates/validation-rules/exploration.yaml)
- [/explore command](/.cursor/commands/explore.md)

---

**Last Updated:** 2026-01-22
