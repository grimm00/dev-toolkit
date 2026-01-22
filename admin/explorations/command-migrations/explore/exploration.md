# Exploration: /explore Command Migration

**Status:** 🔴 Scaffolding (needs expansion)  
**Created:** 2026-01-22

---

## 🎯 What We're Exploring

How to migrate the `/explore` Cursor command from inline templates to using `dt-doc-gen` for document generation and `dt-doc-validate` for validation. This is Sprint 1 because it sets patterns for all subsequent command migrations.

---

## 🔍 Initial Themes

### Theme 1: Two-Mode Architecture
<!-- PLACEHOLDER: Expand with detailed analysis in conduct mode -->

The /explore command has two distinct modes:
- **Setup Mode:** Creates lightweight scaffolding (~60-80 lines)
- **Conduct Mode:** Expands scaffolding to full exploration (~200-300 lines)

**Key Questions:**
- How does dt-doc-gen handle mode switching?
- Should both modes use the same template with conditionals, or separate templates?
- How do we preserve the "human review checkpoint" between modes?

---

### Theme 2: Template Mapping
<!-- PLACEHOLDER: Expand with detailed analysis in conduct mode -->

Current inline templates need to map to dev-infra templates:

| Output File | Dev-infra Template | Variables Needed |
|-------------|-------------------|------------------|
| `README.md` | `exploration/README.tmpl` | TOPIC_NAME, TOPIC_TITLE, DATE |
| `exploration.md` | `exploration/exploration.tmpl` | TOPIC_NAME, TOPIC_TITLE, DATE, STATUS |
| `research-topics.md` | `exploration/research-topics.tmpl` | TOPIC_NAME, DATE, TOPICS |

**Key Questions:**
- Do dev-infra templates match the expected output structure?
- What variables are missing from dev-infra templates?
- How do we handle the `<!-- PLACEHOLDER: -->` markers for Setup Mode?

---

### Theme 3: Input Source Handling
<!-- PLACEHOLDER: Expand with detailed analysis in conduct mode -->

The /explore command accepts multiple input sources:
- Raw text (`--input "text..."`)
- File input (`--input file.txt`)
- start.txt (`--from-start`)
- Reflection files (`--from-reflect`)

**Key Questions:**
- How does input source affect template variable population?
- Should theme extraction be part of dt-doc-gen or the command wrapper?
- How do we handle the "question extraction" from unstructured input?

---

### Theme 4: AI Expansion Zones
<!-- PLACEHOLDER: Expand with detailed analysis in conduct mode -->

The /explore command uses AI to:
- Extract themes from unstructured input
- Generate questions for research
- Expand scaffolding in Conduct Mode

**Key Questions:**
- Where should `<!-- AI: -->` markers be placed in templates?
- How do `<!-- EXPAND: -->` markers interact with Conduct Mode?
- Should AI expansion be part of dt-doc-gen or handled by Cursor?

---

### Theme 5: Validation Rules
<!-- PLACEHOLDER: Expand with detailed analysis in conduct mode -->

Generated explorations need validation:
- Required sections present
- Status indicators correct
- Links valid (README → exploration.md, etc.)

**Key Questions:**
- What validation rules exist for exploration documents?
- How strict should validation be for Setup vs Conduct output?
- Should validation differ based on status (scaffolding vs expanded)?

---

### Theme 6: Worktree Integration
<!-- PLACEHOLDER: Expand with detailed analysis in conduct mode -->

The /explore command integrates with worktree workflow:
- Setup Mode: stays on current branch
- Conduct Mode: prompts for worktree creation

**Key Questions:**
- Is worktree integration a concern for dt-doc-gen?
- Should the command wrapper handle worktree, not dt-doc-gen?
- How does this affect the migration strategy?

---

## ❓ Key Questions

1. How does dt-doc-gen handle two-mode commands (Setup/Conduct)?
2. What dev-infra template variables are missing for /explore?
3. Where does AI theme extraction happen (dt-doc-gen vs command wrapper)?
4. How should validation rules differ between Setup and Conduct output?
5. What's the fallback strategy during migration?

---

## 🚀 Next Steps

Run `/explore explore-command-migration --conduct` to expand this exploration with detailed analysis.

---

**Last Updated:** 2026-01-22
