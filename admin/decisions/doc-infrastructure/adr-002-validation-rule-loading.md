# ADR-002: Validation Rule Loading Strategy

**Status:** ✅ Accepted  
**Created:** 2026-01-20  
**Last Updated:** 2026-01-20

---

## Context

dt-doc-validate needs to load validation rules from YAML files (`validation-rules/*.yaml`) that define required sections, patterns, and error messages for each document type. Dev-toolkit's core principle is "zero dependencies" for core features.

**Key Question:** How should dt-doc-validate parse YAML validation rules in pure bash without external dependencies?

**Related Research:**
- [YAML Parsing Research](../../research/doc-infrastructure/research-yaml-parsing.md)

**Related Requirements:**
- FR-YP1: Pre-compiled bash validation rules
- FR-YP2: Build-time YAML to bash conversion
- NFR-YP2: Offline operation without yq

---

## Decision

**Use build-time YAML to Bash conversion.** Validation rules are converted from YAML to bash-native format during dev-infra release, eliminating runtime YAML parsing entirely.

### Architecture

```
dev-infra (source):
  validation-rules/*.yaml  →  build script (uses yq)
                           ↓
dev-infra (dist):
  validation-rules/*.bash  (pre-compiled)
                           ↓
dt-doc-validate:
  source rules/*.bash  →  Fast validation, no parsing
```

### Pre-compiled Format

```bash
# validation-rules/exploration.bash
# Auto-generated from exploration.yaml - DO NOT EDIT

DT_EXPLORATION_SUBTYPES=("exploration" "research_topics" "exploration_hub")

declare -A DT_EXPLORATION_PATHS=(
    ["exploration"]="admin/explorations/*/exploration.md"
    ["research_topics"]="admin/explorations/*/research-topics.md"
    ["exploration_hub"]="admin/explorations/*/README.md"
)

declare -a DT_EXPLORATION_REQUIRED_SECTIONS=(
    "what_exploring|^## 🎯 What We're Exploring|Missing 'What We're Exploring' section"
    "themes|^## 🔍 Themes|Missing 'Themes' section"
    "key_questions|^## ❓ Key Questions|Missing 'Key Questions' section"
)
```

### Rule Loading

```bash
load_validation_rules() {
    local doc_type=$1
    local rules_path="${DT_RULES_PATH:-$TOOLKIT_ROOT/lib/validation/rules}"
    
    # 1. Try pre-compiled bash rules (fastest, no deps)
    if [ -f "$rules_path/${doc_type}.bash" ]; then
        source "$rules_path/${doc_type}.bash"
        return 0
    fi
    
    # 2. Error - no rules available
    dt_print_status "ERROR" "No validation rules found for: $doc_type"
    return 1
}
```

---

## Consequences

### Positive

- **Zero runtime dependencies:** No yq, no YAML parsing at runtime
- **Fast loading:** Simple `source` command, <100ms target easily met
- **Offline operation:** Works without any network or external tools
- **Build-time validation:** YAML errors caught during build, not runtime
- **Portable:** Works on any system with bash

### Negative

- **Build step required:** YAML changes require regeneration of bash files
- **Two file formats:** YAML (source) and bash (compiled) to maintain
- **yq dependency for build:** Build process requires yq

### Mitigations

- Build script validates YAML before conversion
- CI enforces bash files are regenerated when YAML changes
- Clear "DO NOT EDIT" header in generated files

---

## Alternatives Considered

### Alternative 1: Runtime YAML Parsing with yq

**Description:** Use yq to parse YAML at runtime.

**Pros:**
- Single file format (YAML only)
- No build step needed
- Changes take effect immediately

**Cons:**
- Requires yq installation
- Slower (parsing on every invocation)
- Fails if yq not installed
- Cross-platform yq installation varies

**Why not chosen:** Violates zero-dependency principle. Users without yq would have broken validation.

---

### Alternative 2: Pure Bash YAML Parser

**Description:** Implement YAML parsing in pure bash using grep/awk/sed.

**Pros:**
- No external dependencies
- Single file format

**Cons:**
- Complex implementation
- Fragile (YAML edge cases)
- Slow parsing
- Difficult to maintain
- Limited YAML feature support

**Why not chosen:** High complexity, low reliability. Research showed pure bash YAML parsing is feasible but brittle.

---

### Alternative 3: Embedded Rules in Code

**Description:** Define validation rules directly in bash scripts, no external files.

**Pros:**
- No file loading needed
- No parsing needed
- Single source

**Cons:**
- Rules scattered in code
- Hard to maintain
- No separation of concerns
- Can't update rules without code changes

**Why not chosen:** Violates separation of concerns. Rules should be data, not code.

---

## Decision Rationale

**Key Factors:**

1. **Zero Dependencies:** Core validation MUST work without external tools
2. **Performance:** Rule loading MUST be <100ms
3. **Maintainability:** Rules should be human-editable (YAML is friendlier)
4. **Reliability:** No runtime parsing failures

**Research Support:**
- Finding 3: "Build-time conversion is the optimal strategy"
- Finding 4: "yq provides excellent [build-time] tool for conversion"
- Insight 4: "Pre-compiled bash files are faster and more portable"

---

## Requirements Impact

**Requirements Addressed:**
- FR-YP1: Pre-compiled bash validation rules ✅
- FR-YP2: Build-time YAML to bash conversion ✅
- FR-YP3: yq for conversion script ✅
- FR-YP5: Clear error if no rules available ✅
- FR-YP6: Support path patterns, required sections, error messages ✅
- NFR-YP1: Rule loading <100ms ✅
- NFR-YP2: Offline operation without yq ✅

**Requirements Deferred:**
- FR-YP4: Optional direct YAML parsing with yq (future enhancement)

**Build Process Requirements:**
- C-YP2: Pre-compiled rules regenerated when YAML changes
- C-YP3: yq is dev/build dependency only

---

## References

- [YAML Parsing Research](../../research/doc-infrastructure/research-yaml-parsing.md)
- [Requirements Document](../../research/doc-infrastructure/requirements.md)
- [dev-infra validation rules](~/Projects/dev-infra/scripts/doc-gen/templates/validation-rules/)

---

**Last Updated:** 2026-01-20
