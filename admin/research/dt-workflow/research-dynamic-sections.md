# Research: Dynamic Section Management

**Topic:** 7 - Dynamic Section Management  
**Priority:** 🔴 HIGH  
**Status:** 🔴 Not Started  
**Created:** 2026-01-22  
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

**Why This Matters for dt-workflow:**
- dt-workflow will set the foundational pattern
- Other workflows will follow this pattern
- Poor design here propagates to all future workflows

---

## 🔍 Research Areas

### Area 1: Current State Analysis

**Questions:**
- How do existing workflows handle variable sections?
- What inconsistencies exist?
- What patterns work well? What doesn't?

**Files to examine:**
- Cursor commands: `.cursor/commands/`
- Existing generated docs: `admin/explorations/`, `admin/research/`
- Templates if any

---

### Area 2: Approaches to Investigate

| Approach | Description | Pros | Cons |
|----------|-------------|------|------|
| **Section Commands** | `dt-section add phase [doc]` | Explicit, testable | Additional command |
| **Template Markers** | `<!-- ADD_PHASE_HERE -->` markers | Simple | AI might ignore |
| **YAML + Render** | Store as YAML, render to markdown | Structured, validatable | Complex |
| **Cursor Commands** | `/add-phase`, `/add-topic` | IDE native | Not portable |
| **Hybrid** | Template slots + validation | Best of both | More complex |

**Key questions:**
- Should sections be added via CLI (`dt-section`) or IDE (`/add-phase`)?
- Per ADR-004, Cursor commands are orchestrators - does section management fit this pattern?
- How does this affect validation (`dt-doc-validate`)?

---

### Area 3: Numbering and Sequencing

**Questions:**
- How to auto-number sections (Phase 1, Phase 2...)?
- How to handle re-ordering (insert Phase 1.5 between 1 and 2)?
- How to validate sequence integrity?
- How to update cross-references when sections change?

**Considerations:**
- Some sections are ordered (phases must be sequential)
- Some sections are unordered (research topics can be reordered)
- Cross-references need updating when sections change

---

### Area 4: Validation Implications

**Questions:**
- How does `dt-doc-validate` know how many sections to expect?
- How to validate numbering is correct?
- How to validate no gaps (Phase 1, Phase 3 but no Phase 2)?

**Current validation approach:**
- L1: File exists
- L2: Structure (sections present)
- L3: Content (fields populated)

**New validation needs:**
- Section count validation
- Sequence integrity validation
- Cross-reference validation

---

### Area 5: User Experience

**Scenarios to consider:**

1. **AI generates initial document with N sections**
   - How does AI know how many to generate?
   - How to signal "more sections may be added"?

2. **User wants to add one more section**
   - Command? Manual edit? AI assistant?
   - How to maintain consistency?

3. **User wants to reorder sections**
   - Renumber automatically?
   - Update cross-references?

4. **User wants to remove a section**
   - Renumber remaining?
   - Handle orphaned references?

---

## 🔬 Research Approach

### Phase A: Current State (Analysis)

1. Examine existing Cursor commands for section handling
2. Review generated documents for patterns
3. Identify inconsistencies and pain points

### Phase B: External Research

1. How do other documentation systems handle this?
2. Static site generators (sections in frontmatter?)
3. Note-taking apps (blocks/sections?)
4. Design system documentation

### Phase C: Prototype Options

1. Spike: `dt-section add` command
2. Spike: Template marker approach
3. Spike: YAML-based approach

### Phase D: Recommendations

1. Recommended approach
2. Validation updates needed
3. Migration path for existing workflows

---

## 📊 Expected Outputs

1. **Recommended Pattern** - How dt-workflow should handle dynamic sections
2. **Command Design** - If command-based, what commands are needed
3. **Validation Updates** - How `dt-doc-validate` should change
4. **Migration Guide** - How to apply pattern to existing workflows

---

## 🔗 Related

- [ADR-004: Cursor Command Role](../../decisions/dt-workflow/adr-004-cursor-command-role.md) - Orchestrator pattern
- [Research: Workflow I/O Specs](research-workflow-io-specs.md) - Handoff file contracts
- [Pattern Library](../../../../docs/patterns/workflow-patterns.md) - Existing patterns

---

## 📝 Findings

*To be filled during research*

---

## 💡 Recommendations

*To be filled after research*

---

**Last Updated:** 2026-01-22
