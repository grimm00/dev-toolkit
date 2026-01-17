# Research: YAML Parsing in Bash

**Research Topic:** Doc Infrastructure  
**Question:** How to parse validation-rules/*.yaml files in pure bash without external dependencies?  
**Status:** ✅ Complete  
**Priority:** 🔴 High (Blocking)  
**Created:** 2026-01-16  
**Completed:** 2026-01-17  
**Last Updated:** 2026-01-17

---

## 🎯 Research Question

How to parse validation-rules/*.yaml files in pure bash without external dependencies? The 6 YAML validation rule files define required sections, patterns, and error messages for each document type. dev-toolkit's core principle is "zero dependencies" for core features.

---

## 🔍 Research Goals

- [x] Goal 1: Analyze actual YAML structure in validation-rules/*.yaml
- [x] Goal 2: Prototype grep/awk parser for the specific YAML subset used
- [x] Goal 3: Evaluate yq as optional dependency (graceful degradation)
- [x] Goal 4: Consider build-time conversion to bash-native format
- [x] Goal 5: Define recommended approach for dev-toolkit implementation

---

## 📚 Research Methodology

**Note:** Web search is **allowed and encouraged** for research.

**Sources:**
- [x] Source 1: Analyze validation-rules/*.yaml structure in dev-infra
- [x] Source 2: Review YAML parsing approaches in bash (grep, awk, sed)
- [x] Source 3: Evaluate yq availability and installation complexity
- [x] Source 4: Web search: "parse yaml bash without dependencies"

---

## 📊 Findings

### Finding 1: Actual YAML Structure is Constrained and Predictable

Analysis of all 6 validation rule files (`exploration.yaml`, `research.yaml`, `decision.yaml`, `planning.yaml`, `handoff.yaml`, `fix.yaml`) reveals a well-defined, constrained YAML subset:

**Structure Summary:**
- 17 document subtypes across 6 files
- Maximum nesting depth: 3-4 levels
- No anchors (`&`) or aliases (`*`) used
- No flow-style collections (`[ ]` or `{ }`)
- Multi-line strings only in `examples:` section (using `|`)
- Consistent indentation (2 spaces)

**Key Elements:**
```yaml
# Document subtype definition
subtype_name:
  description: "string"
  path_pattern: "glob pattern"
  
  common_rules:
    - rule_id: STRING
      enabled: true|false
      threshold_days: number  # optional
  
  required_sections:
    - section_id: string
      pattern: "regex"
      error_code: STRING
      error_message: "string"
      fix_suggestion: "string"
  
  optional_sections:
    - pattern: "regex"
      description: "string"
```

**Source:** Analysis of dev-infra/scripts/doc-gen/templates/validation-rules/*.yaml

**Relevance:** The constrained structure makes pure bash parsing feasible - no need to handle complex YAML features.

---

### Finding 2: Pure Bash YAML Parsing is Feasible for Constrained Subsets

Web research identified several pure-bash YAML parsing approaches:

| Tool/Approach | Capabilities | Limitations |
|--------------|--------------|-------------|
| **parse_yaml** (mrbaseman) | Maps, lists, nested structures, multiline | No anchors/tags, flat variable namespace |
| **yb** (bash yaml parser) | Query, add, modify YAML values | Performance issues, complexity |
| **sed/awk scripts** | Simple key-value extraction | Very brittle, breaks on edge cases |

**Key Insight:** Pure bash can work for:
- Flat or shallow structures (2-3 levels)
- No anchors, aliases, or tags
- Consistent indentation
- Known structure (not arbitrary YAML)

Our validation rules meet ALL these criteria.

**Source:** Web search: github.com/mrbaseman/parse_yaml, sam4uk.github.io/yb

**Relevance:** We CAN implement a bash-only parser, but should constrain what YAML features we support.

---

### Finding 3: Build-Time Conversion is the Optimal Strategy

Rather than parsing YAML at runtime, a **build-time conversion** approach offers significant advantages:

**Strategy:** Convert YAML to bash-native format (associative arrays or source-able scripts) during dev-infra release:

```bash
# validation-rules/exploration.bash (generated from exploration.yaml)

declare -A EXPLORATION_SUBTYPES=(
  ["exploration"]="exploration"
  ["research_topics"]="research_topics" 
  ["exploration_hub"]="exploration_hub"
)

EXPLORATION_EXPLORATION_PATH_PATTERN="admin/explorations/*/exploration.md"
EXPLORATION_EXPLORATION_REQUIRED_SECTIONS=(
  "what_exploring:^## 🎯 What We're Exploring"
  "themes:^## 🔍 Themes"
  "key_questions:^## ❓ Key Questions"
)

get_section_error() {
  local subtype=$1 section_id=$2
  # Return error message for section
}
```

**Benefits:**
| Aspect | YAML Runtime | Bash Pre-compiled |
|--------|--------------|-------------------|
| **Parse time** | Every invocation | Zero (already parsed) |
| **Dependencies** | Parser needed | None |
| **Complexity** | High (full parser) | Low (source file) |
| **Portability** | Parser must work | Standard bash |
| **Validation** | Runtime errors | Build-time errors |

**Source:** Web research on YAML preprocessing patterns

**Relevance:** This eliminates the runtime YAML parsing problem entirely.

---

### Finding 4: yq Provides Excellent Fallback for Development

The `yq` tool (Mike Farah's Go implementation) offers:

- Full YAML spec support
- Clean query syntax similar to jq
- Cross-platform binaries available
- Fast execution

**Installation:**
```bash
# macOS
brew install yq

# Linux (via package manager or binary)
sudo apt install yq  # or download binary

# Check availability
command -v yq >/dev/null && echo "yq available"
```

**Use Cases for yq:**
1. **Build-time conversion** - Convert YAML to bash format during release
2. **Development/debugging** - Query rules during dt-doc-validate development
3. **Advanced users** - Direct YAML access for customization

**Source:** github.com/mikefarah/yq, web research

**Relevance:** yq can power build-time conversion even if runtime uses bash-only format.

---

### Finding 5: Graceful Degradation Pattern Works Well

A layered approach provides maximum flexibility:

```bash
# dt-doc-validate validation rule loading

load_validation_rules() {
    local doc_type=$1
    
    # 1. Try pre-compiled bash rules (fastest, no deps)
    if [ -f "$DT_RULES_PATH/${doc_type}.bash" ]; then
        source "$DT_RULES_PATH/${doc_type}.bash"
        return 0
    fi
    
    # 2. Try parsing YAML with yq (if available)
    if command -v yq >/dev/null 2>&1; then
        _parse_yaml_with_yq "$DT_RULES_PATH/${doc_type}.yaml"
        return 0
    fi
    
    # 3. Try simple bash parser (limited features)
    if [ -f "$DT_RULES_PATH/${doc_type}.yaml" ]; then
        _parse_yaml_simple "$DT_RULES_PATH/${doc_type}.yaml"
        return 0
    fi
    
    # 4. Error - no rules available
    echo "❌ No validation rules found for: $doc_type"
    return 1
}
```

**Source:** Analysis of dev-toolkit's existing graceful degradation patterns

**Relevance:** Users get the best experience based on what's available in their environment.

---

## 🔍 Analysis

### Key Insights

- [x] **Insight 1:** The validation YAML is constrained enough for pure bash parsing
- [x] **Insight 2:** Build-time conversion eliminates runtime parsing complexity
- [x] **Insight 3:** yq is the ideal tool for the conversion step
- [x] **Insight 4:** Pre-compiled bash files are faster and more portable
- [x] **Insight 5:** Graceful degradation supports multiple environments

### YAML Subset Specification

Based on analysis, dt-doc-validate should support this YAML subset:

**Supported:**
- [x] Key-value pairs (string, number, boolean)
- [x] Nested mappings (up to 4 levels)
- [x] Arrays of objects
- [x] Arrays of scalars
- [x] Regex patterns as strings
- [x] Multi-line strings with `|` (in examples only)

**NOT Supported:**
- [ ] Anchors (`&anchor`) and aliases (`*alias`)
- [ ] Flow-style collections (`[ ]`, `{ }`)
- [ ] Tags (`!tag`)
- [ ] Multiple documents (`---` separators beyond first)
- [ ] Complex keys

### Trade-off Matrix

| Approach | Complexity | Runtime Deps | Performance | Maintainability |
|----------|------------|--------------|-------------|-----------------|
| **Pure bash runtime** | 🔴 High | 🟢 None | 🟡 Medium | 🔴 Poor |
| **yq runtime** | 🟢 Low | 🟡 yq | 🟢 Fast | 🟢 Good |
| **Build-time + bash** | 🟡 Medium | 🟢 None | 🟢 Fastest | 🟢 Good |
| **Hybrid** | 🟡 Medium | 🟢 Optional yq | 🟢 Fast | 🟢 Good |

**Recommendation:** Build-time conversion with hybrid fallback

---

## 💡 Recommendations

- [x] **Recommendation 1:** Implement build-time YAML → bash conversion script
- [x] **Recommendation 2:** Ship pre-compiled `.bash` rule files with dev-toolkit
- [x] **Recommendation 3:** Use yq for the conversion script (not runtime)
- [x] **Recommendation 4:** Implement simple bash YAML parser as fallback for users without pre-compiled rules
- [x] **Recommendation 5:** Document the supported YAML subset clearly
- [x] **Recommendation 6:** Add CI validation that YAML rules conform to supported subset

### Implementation Architecture

```
dev-infra (source):
  validation-rules/*.yaml  →  build script (uses yq)
                           ↓
dev-toolkit (dist):
  lib/validation/rules/*.bash  (pre-compiled)
                           ↓
dt-doc-validate:
  source rules/*.bash  →  Fast validation, no parsing
```

### Example Conversion Output

```bash
# lib/validation/rules/exploration.bash
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

---

## 📋 Requirements Discovered

### Functional Requirements

- [x] **FR-YP1:** dt-doc-validate MUST load pre-compiled bash validation rules
- [x] **FR-YP2:** Build system MUST convert YAML rules to bash format before release
- [x] **FR-YP3:** Conversion script MUST use yq for reliable YAML parsing
- [x] **FR-YP4:** dt-doc-validate SHOULD support direct YAML parsing if yq available
- [x] **FR-YP5:** dt-doc-validate MUST provide clear error if no rules available
- [x] **FR-YP6:** Validation rules MUST support: path patterns, required sections, error messages

### Non-Functional Requirements

- [x] **NFR-YP1:** Rule loading MUST complete in <100ms (pre-compiled target)
- [x] **NFR-YP2:** dt-doc-validate MUST work offline without yq (using pre-compiled)
- [x] **NFR-YP3:** YAML subset restrictions MUST be documented

### Constraints

- [x] **C-YP1:** Validation rules YAML must conform to supported subset (no anchors, no flow style)
- [x] **C-YP2:** Pre-compiled bash rules must be regenerated when YAML changes
- [x] **C-YP3:** yq is required for build-time conversion (dev dependency only)

---

## 🚀 Next Steps

1. ~~Conduct research~~ ✅ Complete
2. Update requirements.md with discovered requirements
3. Create `scripts/compile-validation-rules.sh` conversion script
4. Implement rule loading in `lib/validation/rules.sh`
5. Test with all 6 validation rule files

---

**Last Updated:** 2026-01-17
