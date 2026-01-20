# ADR-003: Variable Expansion Approach

**Status:** ✅ Accepted  
**Created:** 2026-01-20  
**Last Updated:** 2026-01-20

---

## Context

dt-doc-gen uses `envsubst` to expand `${VAR}` placeholders in templates. Templates also contain content that should NOT be expanded:
- `$100` price references
- `$VAR` in code examples
- `<!-- AI: -->` markers for AI expansion
- `<!-- EXPAND: -->` zones

**Key Question:** How should dt-doc-gen handle variable expansion safely without corrupting template content?

**Related Research:**
- [Variable Expansion Research](../../research/doc-infrastructure/research-variable-expansion.md)

**Related Requirements:**
- FR-VE1: Selective envsubst mode (explicit variable list)
- NFR-VE1: Preserve `$VAR` syntax (no braces)
- NFR-VE2: Preserve HTML comments (AI markers)

---

## Decision

**Use selective envsubst mode with explicit variable lists per template type.**

Instead of expanding ALL `${VAR}` patterns, dt-doc-gen explicitly lists which variables to expand:

```bash
# CORRECT: Selective mode - only expands listed variables
envsubst '${DATE} ${TOPIC_TITLE} ${STATUS}' < template.tmpl > output.md

# WRONG: Full mode - expands ALL ${VAR} patterns (dangerous!)
envsubst < template.tmpl > output.md
```

### Variable Lists Per Template Type

```bash
# Exploration templates
EXPLORATION_VARS='${DATE} ${STATUS} ${TOPIC_NAME} ${TOPIC_TITLE}'

# Research templates  
RESEARCH_VARS='${DATE} ${STATUS} ${TOPIC_NAME} ${QUESTION} ${QUESTION_NAME}'

# Decision templates
DECISION_VARS='${DATE} ${STATUS} ${ADR_NUMBER} ${DECISION_TITLE}'

# Planning templates
PLANNING_VARS='${DATE} ${STATUS} ${FEATURE_NAME} ${PHASE_NUMBER} ${PHASE_NAME}'
```

### Implementation

```bash
render_template() {
    local template="$1"
    local output="$2"
    local doc_type="$3"
    
    # Get variable list for this template type
    local vars
    vars=$(get_template_vars "$doc_type")
    
    # Export required variables
    export DATE=$(date +%Y-%m-%d)
    export STATUS="🔴 Scaffolding"
    # ... other exports
    
    # SELECTIVE expansion - only listed variables
    envsubst "$vars" < "$template" > "$output"
}
```

---

## Consequences

### Positive

- **Safe expansion:** Only intended variables are expanded
- **Preserves content:** `$100`, `$VAR`, code examples remain intact
- **AI markers preserved:** `<!-- AI: -->` and `<!-- EXPAND: -->` pass through
- **Predictable:** Explicit list documents what gets expanded
- **Unicode safe:** Emoji status indicators work correctly

### Negative

- **Variable list maintenance:** Must update lists when templates add variables
- **Explicit exports:** All variables must be exported before envsubst
- **envsubst dependency:** Requires gettext package (not on macOS by default)

### Mitigations

- Variable lists defined per template type (centralized)
- Startup check for envsubst with helpful installation message
- Document macOS installation: `brew install gettext`

---

## Alternatives Considered

### Alternative 1: Full envsubst Mode

**Description:** Use envsubst without variable list, expanding all `${VAR}` patterns.

**Pros:**
- Simpler invocation
- No variable list to maintain

**Cons:**
- Undefined variables become empty strings
- May corrupt template content
- `${CODE_EXAMPLE}` in templates would be emptied
- Unpredictable behavior

**Why not chosen:** Too dangerous. Undefined variables silently become empty, breaking documents.

---

### Alternative 2: Custom Bash Expansion

**Description:** Implement variable expansion in pure bash using sed/parameter expansion.

**Pros:**
- No envsubst dependency
- Full control over behavior

**Cons:**
- Complex implementation
- Regex edge cases
- Slower than envsubst
- Reinventing the wheel

**Why not chosen:** envsubst exists and works well. No need to reimplement.

---

### Alternative 3: Escape Sequences

**Description:** Use backslash escaping (`\${VAR}`) for content that shouldn't expand.

**Pros:**
- Could use full mode
- Standard escape pattern

**Cons:**
- **Doesn't work!** envsubst ignores backslash escapes
- Would require modifying all templates
- Templates become harder to read

**Why not chosen:** Research Finding 4 confirmed backslash escaping does NOT work in envsubst.

---

## Decision Rationale

**Key Factors:**

1. **Safety:** Must not corrupt template content
2. **Predictability:** Clear which variables are expanded
3. **AI Marker Preservation:** `<!-- AI: -->` zones must remain for workflow
4. **Portability:** envsubst available on all target platforms (with gettext)

**Research Support:**
- Finding 1: "Using selective mode is CRITICAL for safe template expansion"
- Finding 2: "`$VAR` (without braces) is NOT expanded by envsubst"
- Finding 4: "Backslash escaping does NOT prevent expansion"
- Insight 1: "Selective envsubst mode is MANDATORY for safe expansion"

---

## Requirements Impact

**Requirements Addressed:**
- FR-VE1: Selective envsubst mode ✅
- FR-VE2: Variables defined per template type ✅
- FR-VE3: envsubst availability check at startup ✅
- FR-VE4: Helpful error if envsubst missing ✅
- FR-VE5: Export all required variables before expansion ✅
- NFR-VE1: Preserve `$VAR` syntax ✅
- NFR-VE2: Preserve HTML comments ✅
- NFR-VE3: Handle Unicode/emoji correctly ✅

**Constraints Acknowledged:**
- C-VE1: envsubst requires gettext (documented in help)
- C-VE2: No backslash escape support (use selective mode)
- C-VE3: Multi-line values may affect formatting (avoid)

---

## References

- [Variable Expansion Research](../../research/doc-infrastructure/research-variable-expansion.md)
- [Requirements Document](../../research/doc-infrastructure/requirements.md)
- [dev-infra VARIABLES.md](~/Projects/dev-infra/scripts/doc-gen/templates/VARIABLES.md)

---

**Last Updated:** 2026-01-20
