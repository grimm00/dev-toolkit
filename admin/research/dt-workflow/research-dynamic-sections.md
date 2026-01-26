# Research: Dynamic Section Management

**Topic:** 7 - Dynamic Section Management  
**Priority:** 🔴 HIGH  
**Status:** ✅ Complete  
**Created:** 2026-01-22  
**Completed:** 2026-01-22  
**Last Updated:** 2026-01-22

---

## 📋 Research Question

**How should dt-workflow handle variable-length sections (topics, phases, fixes) in generated documents?**

### Context

Multiple workflows generate documents with variable numbers of sections:
- `/explore` → N themes, N questions
- `/research` → N topics
- `/transition-plan` → N phases
- `/fix-plan` → N fixes

**Current Problems:**
1. AI generates all sections at once (inconsistent quality)
2. No way to add "one more phase" incrementally
3. Numbering done manually (error-prone)
4. Validation can't verify counts/sequences
5. Different workflows handle this differently (no pattern)

---

## 📊 Findings

### Finding 1: Current State Analysis

**Source:** Analysis of `.cursor/commands/` and generated documents

Examined 23 Cursor commands. Key patterns found:

**Hardcoded Section Templates:**
- Commands include literal "Phase 1", "Phase 2", "Phase 3" templates
- `transition-plan.md` explicitly warns: "Extract **ALL phases** (Phase 1, Phase 2, Phase 3, Phase 4, etc.). Do not stop at Phase 2."
- This warning exists because AI frequently truncates

**Inconsistent Numbering:**
- Some use "Topic 1:", others use "### Topic 1:"
- Some use explicit `#` column in tables, others rely on order
- Research hub uses `| # | Topic |` table format (explicit)

**Hub-and-Spoke Pattern:**
- README.md lists sections with links
- Individual `phase-N.md` or `research-topic.md` files
- Count must be maintained in hub when sections added

**Relevance:** Current approach is template-heavy with manual numbering. No programmatic section management exists.

---

### Finding 2: ADR Sequential Numbering Pattern

**Source:** [adr.github.io](https://adr.github.io/), Google Cloud Architecture Decision Records

ADR tools use **global sequential numbering**:
- Format: `[sequence]-[topic]` (e.g., `0001-SeparateConfigurationInterface`)
- Sequence is global across all ADRs, not per-category
- New ADR gets `max(existing) + 1`

**Key insight:** ADRs don't renumber on deletion. Gaps are acceptable.

```
0001-authentication-approach.md
0002-database-selection.md      # Later deleted
0003-api-versioning.md          # Number 0002 stays unused
```

**Relevance:** For phases (ordered), we could allow gaps. For topics (unordered), renumbering may be acceptable.

---

### Finding 3: Changelog Generation Pattern

**Source:** [Conventional Commits](https://www.conventionalcommits.org/), standard-version

Changelog generators are **data-driven**, not template-driven:
- Sections derived from commit types (`feat:`, `fix:`, `BREAKING CHANGE:`)
- Number of sections determined by data, not template
- Tool groups commits into sections dynamically

**Pattern:**
```
Commits: [fix, fix, feat, feat, fix]
Output:  ### Features (2)
         ### Bug Fixes (3)
```

**Relevance:** dt-workflow could derive section count from input (e.g., "how many research questions did exploration identify?") rather than hardcoding.

---

### Finding 4: Notion Blocks API Pattern

**Source:** [Notion API Documentation](https://developers.notion.com/reference/patch-block-children)

Notion uses **append-only** for block management:
- `PATCH /v1/blocks/{block_id}/children` - appends to end
- **Cannot insert at specific position**
- To insert in middle: retrieve all → delete all → rebuild → re-append

**Workaround pattern:**
```
1. Get all children
2. Delete all children  
3. Insert new block at desired position in list
4. Re-append all blocks
```

**Relevance:** Append-only is simpler but limits flexibility. For phases (sequential), append-only works. For topics (reorderable), need different approach.

---

### Finding 5: Template Generator Patterns (Hygen)

**Source:** [Hygen Documentation](https://www.hygen.io/docs/templates/)

Hygen separates **metadata (frontmatter) from content (body)**:

```markdown
---
to: app/<%=section%>/emails.js
inject: true
after: "// INJECT_POINT"
---
<content here>
```

**Key features:**
- `inject: true` - Add to existing file instead of creating new
- `after: "marker"` - Insert after specific marker
- Variables in frontmatter for dynamic paths

**Relevance:** Marker-based injection could work for adding sections to existing documents.

---

### Finding 6: Markdown Builder Libraries

**Source:** [Tempo](https://github.com/joggrdocs/tempo), [mdsh](https://zimbatm.github.io/mdsh/)

**Builder pattern approach:**
```javascript
doc.heading(2, "Phase 1")
   .paragraph("Description")
   .heading(2, "Phase 2")
   .paragraph("Description")
```

**Script interpolation approach (mdsh):**
```markdown
<!-- `$ cat phases.txt | while read p; do echo "## $p"; done` -->
## Phase 1
## Phase 2
<!-- /$ -->
```

**Relevance:** Builder pattern is powerful but requires code. Script interpolation is Bash-friendly but complex for users.

---

## 🔍 Analysis

### Section Types

| Type | Example | Ordered? | Gaps OK? | Renumber OK? |
|------|---------|----------|----------|--------------|
| **Phases** | Phase 1, 2, 3 | ✅ Yes | ❌ No | ❌ No |
| **Topics** | Topic 1, 2, 3 | ❓ Maybe | ✅ Yes | ✅ Yes |
| **Fixes** | Fix 1, 2, 3 | ❓ Maybe | ✅ Yes | ✅ Yes |
| **Themes** | Theme A, B, C | ❌ No | N/A | N/A |

**Key insight:** Different section types have different constraints.

### Two-Phase Problem

1. **Generation Time:** How many sections to create initially?
   - Data-driven: Derive from input (exploration → N topics)
   - User-specified: `--phases 4` flag
   - AI-determined: Let AI decide (current, inconsistent)

2. **Evolution Time:** How to add/remove/reorder later?
   - Append-only: Simple, works for phases
   - Insert-anywhere: Complex, needed for topics
   - Immutable: Don't allow changes (ADR pattern)

### Approach Comparison

| Approach | Generation | Evolution | Validation | Complexity |
|----------|------------|-----------|------------|------------|
| **Metadata-driven** | From frontmatter | Update metadata | Count from meta | Low |
| **Section command** | From flags | CLI command | CLI validates | Medium |
| **Marker injection** | Template | Insert at marker | Marker presence | Medium |
| **YAML+Render** | From YAML | Edit YAML | Schema validation | High |

---

## 💡 Recommendations

### Recommendation 1: Metadata-Driven Section Count

**Use frontmatter to declare section count, render body dynamically.**

```markdown
---
type: transition-plan
phases: 4
---

# Transition Plan

## Phases

<!-- Sections below are validated against phases: 4 -->

### Phase 1: Foundation
...

### Phase 2: Implementation
...
```

**Benefits:**
- Single source of truth for count
- Validation can check `phases: 4` matches actual sections
- AI sees expected count, generates accordingly
- Easy to update: change frontmatter, add section

**Implementation:**
- dt-workflow reads frontmatter, injects into AI context
- dt-doc-validate checks section count matches frontmatter
- `dt-section add phase [doc]` increments frontmatter and appends template

---

### Recommendation 2: Section Add Command

**Create `dt-section add` command for incremental additions.**

```bash
# Add a new phase to transition plan
dt-section add phase admin/planning/features/dt-workflow/transition-plan.md

# Add a new topic to research
dt-section add topic admin/research/dt-workflow/README.md

# Add with specific number (for gaps)
dt-section add phase --number 3 transition-plan.md
```

**Behavior:**
1. Read current section count from frontmatter (or parse document)
2. Increment count
3. Append section template at appropriate location
4. Update hub/summary if exists

**Per ADR-004:** This is a CLI command (portable), not a Cursor command. Cursor commands can orchestrate it.

---

### Recommendation 3: Differentiate Ordered vs Unordered

**Phases (ordered):**
- Append-only by default
- No renumbering
- Gaps not allowed (validation error)
- Sequential dependencies

**Topics/Fixes (unordered):**
- Add anywhere
- Auto-renumber on request (`--renumber`)
- Gaps allowed
- No dependencies

```bash
# Ordered (phases) - append only
dt-section add phase [doc]  # Always appends at end

# Unordered (topics) - insert anywhere
dt-section add topic [doc]              # Appends at end
dt-section add topic [doc] --after 2    # Insert after Topic 2
dt-section renumber topics [doc]        # Renumber all topics 1, 2, 3...
```

---

### Recommendation 4: Validation Updates

**Extend L2 validation for section integrity:**

```
L2 Validation (Structure):
- Section count matches frontmatter declaration
- No gaps in ordered sections (phases)
- All sections have required subsections
- Cross-references resolve

L2 Warnings:
- Gaps in unordered sections (topics) - warn, don't fail
- Section count mismatch - fail with specific error
```

**Error messages:**
```
❌ Error: transition-plan.md declares 4 phases but only 3 found
   Missing: Phase 4

💡 Suggestion: Add missing phase with:
   dt-section add phase transition-plan.md
```

---

### Recommendation 5: Phase 1 Implementation (Minimal)

**Start simple, iterate based on usage:**

**Phase 1 (MVP):**
- Frontmatter `sections:` or `phases:` count declaration
- dt-doc-validate checks count matches
- Manual section addition (copy template)

**Phase 2 (Enhancement):**
- `dt-section add` command
- Auto-increment frontmatter
- Template injection

**Phase 3 (Full):**
- Hub auto-update
- Cross-reference management
- Renumbering for unordered sections

---

## 📋 Requirements Discovered

### Functional Requirements

| ID | Requirement | Priority |
|----|-------------|----------|
| FR-19 | Frontmatter section count declaration | High |
| FR-20 | Validation checks section count vs actual | High |
| FR-21 | `dt-section add` command for incremental additions | Medium |
| FR-22 | Differentiate ordered vs unordered section types | Medium |
| FR-23 | Auto-renumber command for unordered sections | Low |

### Non-Functional Requirements

| ID | Requirement | Priority |
|----|-------------|----------|
| NFR-5 | Section operations complete in <1 second | Medium |
| NFR-6 | Clear error messages for section mismatches | High |

---

## 🚀 Next Steps

1. **Update requirements.md** with FR-19 through FR-23
2. **Decide on implementation phase** (include in Phase 1 vs defer)
3. **Create ADR** if this is a significant architectural decision
4. **Update Pattern Library** with "Section Management" pattern

---

## 🔗 Related

- [ADR-004: Cursor Command Role](../../decisions/dt-workflow/adr-004-cursor-command-role.md) - CLI vs Cursor
- [Research: Workflow I/O Specs](research-workflow-io-specs.md) - Handoff file contracts
- [Pattern Library](../../../../docs/patterns/workflow-patterns.md) - Add section management pattern

---

**Last Updated:** 2026-01-22
