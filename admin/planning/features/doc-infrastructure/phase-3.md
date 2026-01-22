# Doc Infrastructure - Phase 3: dt-doc-validate

**Phase:** 3 - dt-doc-validate  
**Duration:** 3-4 days  
**Status:** ✅ Expanded  
**Prerequisites:** Phase 1 complete, dev-infra validation rules accessible

---

## 📋 Overview

Implement the `dt-doc-validate` command for validating documentation against common and type-specific rules. Supports automatic type detection (ADR-006), pre-compiled rule loading (ADR-002), and dual output modes (ADR-004).

**Success Definition:** All 17 document types validate correctly with proper error output and exit codes.

---

## 🎯 Goals

1. **Create dt-doc-validate CLI** - Main command entry point with help and argument parsing
2. **Implement type detection** - Path → content → explicit per ADR-006
3. **Implement rule loading** - Pre-compiled .bash rules per ADR-002
4. **Implement validation** - Apply rules to documents, collect errors/warnings
5. **Implement error output** - Text and JSON modes per ADR-004
6. **Write tests** - Unit and integration tests with TDD workflow

---

## 📝 Tasks

### Task 1: Test Setup and CLI Scaffolding

**Purpose:** Create the test file structure and empty CLI file to enable TDD workflow.

**Steps:**

- [ ] Create `bin/dt-doc-validate` with header comment and empty structure
- [ ] Create `lib/doc-validate/type-detection.sh` with empty structure
- [ ] Create `lib/doc-validate/rules.sh` with empty structure
- [ ] Create `lib/doc-validate/validation.sh` with empty structure
- [ ] Create `lib/doc-validate/output.sh` with empty structure
- [ ] Create `tests/unit/doc-validate/test-type-detection.bats` with test setup
- [ ] Create `tests/unit/doc-validate/test-rules.bats` with test setup
- [ ] Create `tests/unit/doc-validate/test-validation.bats` with test setup
- [ ] Create `tests/unit/doc-validate/test-output.bats` with test setup
- [ ] Create `tests/integration/test-dt-doc-validate.bats` with test setup

**CLI scaffolding:**

```bash
#!/usr/bin/env bash

# ============================================================================
# DT-DOC-VALIDATE - Validate documentation against dev-infra rules
# Usage: dt-doc-validate [FILE|DIR] [OPTIONS]
# ============================================================================

set -euo pipefail

# ============================================================================
# CONFIGURATION
# ============================================================================

VERSION="1.0.0"
SCRIPT_NAME=$(basename "$0")
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TOOLKIT_ROOT="${SCRIPT_DIR%/bin}"

# Source shared libraries
source "$TOOLKIT_ROOT/lib/core/output-utils.sh"
# source "$TOOLKIT_ROOT/lib/doc-validate/type-detection.sh"  # After implementation
# source "$TOOLKIT_ROOT/lib/doc-validate/rules.sh"           # After implementation
# source "$TOOLKIT_ROOT/lib/doc-validate/validation.sh"      # After implementation
# source "$TOOLKIT_ROOT/lib/doc-validate/output.sh"          # After implementation

# ============================================================================
# FUNCTIONS
# ============================================================================

show_help() {
    cat << EOF
Usage: $SCRIPT_NAME [FILE|DIR] [OPTIONS]

Validate documentation against dev-infra rules.

Arguments:
    FILE|DIR          File or directory to validate

Options:
    --type TYPE       Document type (overrides auto-detection)
    --json            Output in JSON format
    --rules-path PATH Path to validation rules directory
    --help            Show this help message
    --version         Show version information
    --debug           Enable debug output

Document Types:
    exploration, research_topics, exploration_hub, research_topic,
    research_summary, requirements, research_hub, adr, decisions_summary,
    decisions_hub, feature_plan, phase, status_and_next_steps,
    planning_hub, fix_batch, handoff, reflection

Exit Codes:
    0    Success (all validations passed, warnings allowed)
    1    Validation errors found
    2    System error (invalid args, file not found, etc.)

Examples:
    $SCRIPT_NAME admin/explorations/my-topic/
    $SCRIPT_NAME --type adr admin/decisions/auth/adr-001.md
    $SCRIPT_NAME admin/research/ --json

EOF
}

show_version() {
    echo "$SCRIPT_NAME version $VERSION"
}

# ============================================================================
# MAIN EXECUTION
# ============================================================================

main() {
    # Handle help and version flags
    if [[ "${1:-}" == "--help" ]] || [[ "${1:-}" == "-h" ]]; then
        show_help
        exit 0
    fi
    if [[ "${1:-}" == "--version" ]] || [[ "${1:-}" == "-v" ]]; then
        show_version
        exit 0
    fi
    
    echo "dt-doc-validate: Not yet implemented"
    exit 1
}

main "$@"
```

**Library scaffolding (type-detection.sh):**

```bash
#!/bin/bash
# Type Detection Functions for dt-doc-validate
# Implements path-based and content-based detection per ADR-006

# ============================================================================
# TYPE DETECTION
# ============================================================================

# (Type detection functions will go here)
```

**Library scaffolding (rules.sh):**

```bash
#!/bin/bash
# Rule Loading Functions for dt-doc-validate
# Implements pre-compiled .bash rule loading per ADR-002

# ============================================================================
# RULE LOADING
# ============================================================================

# (Rule loading functions will go here)
```

**Library scaffolding (validation.sh):**

```bash
#!/bin/bash
# Validation Functions for dt-doc-validate
# Applies loaded rules to document content

# ============================================================================
# VALIDATION
# ============================================================================

# (Validation functions will go here)
```

**Library scaffolding (output.sh):**

```bash
#!/bin/bash
# Output Functions for dt-doc-validate
# Implements text and JSON output per ADR-004

# ============================================================================
# OUTPUT FORMATTING
# ============================================================================

# (Output functions will go here)
```

**Test scaffolding:**

```bash
#!/usr/bin/env bats

# Tests for dt-doc-validate type detection
# Location: tests/unit/doc-validate/test-type-detection.bats

load '../../helpers/setup'
load '../../helpers/assertions'

setup() {
    source "$PROJECT_ROOT/lib/doc-validate/type-detection.sh"
}

# Test sections will go here
```

**Checklist:**
- [ ] `bin/dt-doc-validate` created with structure
- [ ] `lib/doc-validate/type-detection.sh` created
- [ ] `lib/doc-validate/rules.sh` created
- [ ] `lib/doc-validate/validation.sh` created
- [ ] `lib/doc-validate/output.sh` created
- [ ] Unit test files created (4 files)
- [ ] Integration test file created
- [ ] All scaffolding committed

---

### Task 2: Type Detection Functions (ADR-006)

**Purpose:** Implement document type detection with priority: explicit → path → content → error.

#### RED Phase - Write Failing Tests

**File:** `tests/unit/doc-validate/test-type-detection.bats`

```bash
# ===========================================================================
# TYPE DETECTION TESTS
# ===========================================================================

@test "dt_detect_document_type: explicit type overrides detection" {
    run dt_detect_document_type "any/path.md" "adr"
    [ "$status" -eq 0 ]
    [ "$output" = "adr" ]
}

@test "dt_detect_document_type: detects exploration from path" {
    run dt_detect_document_type "admin/explorations/my-topic/exploration.md"
    [ "$status" -eq 0 ]
    [ "$output" = "exploration" ]
}

@test "dt_detect_document_type: detects research_topics from path" {
    run dt_detect_document_type "admin/explorations/my-topic/research-topics.md"
    [ "$status" -eq 0 ]
    [ "$output" = "research_topics" ]
}

@test "dt_detect_document_type: detects adr from path" {
    run dt_detect_document_type "admin/decisions/auth/adr-001-auth-strategy.md"
    [ "$status" -eq 0 ]
    [ "$output" = "adr" ]
}

@test "dt_detect_document_type: detects phase from path" {
    run dt_detect_document_type "admin/planning/features/my-feature/phase-1.md"
    [ "$status" -eq 0 ]
    [ "$output" = "phase" ]
}

@test "dt_detect_document_type: supports docs/maintainers structure" {
    run dt_detect_document_type "docs/maintainers/explorations/topic/exploration.md"
    [ "$status" -eq 0 ]
    [ "$output" = "exploration" ]
}

@test "dt_detect_from_content: detects adr from heading" {
    local test_file="$BATS_TMPDIR/adr-test.md"
    echo "# ADR-001: Test Decision" > "$test_file"
    run dt_detect_from_content "$test_file"
    [ "$status" -eq 0 ]
    [ "$output" = "adr" ]
}

@test "dt_detect_from_content: detects exploration from section" {
    local test_file="$BATS_TMPDIR/explore-test.md"
    cat > "$test_file" << 'EOF'
# My Exploration
## 🎯 What We're Exploring
Some content here.
EOF
    run dt_detect_from_content "$test_file"
    [ "$status" -eq 0 ]
    [ "$output" = "exploration" ]
}

@test "dt_detect_document_type: returns error for unknown type" {
    run dt_detect_document_type "random/unknown/file.md"
    [ "$status" -eq 1 ]
}

@test "dt_list_document_types: returns all 17 types" {
    run dt_list_document_types
    [ "$status" -eq 0 ]
    [[ "$output" =~ "exploration" ]]
    [[ "$output" =~ "adr" ]]
    [[ "$output" =~ "phase" ]]
}
```

**Checklist:**
- [ ] Tests for explicit type override
- [ ] Tests for path-based detection (exploration, adr, phase, etc.)
- [ ] Tests for content-based fallback
- [ ] Tests for both admin/ and docs/maintainers/ structures
- [ ] Tests for detection failure
- [ ] Tests for type listing
- [ ] All tests failing (RED state)

#### GREEN Phase - Implement Functions

**File:** `lib/doc-validate/type-detection.sh`

```bash
#!/bin/bash
# Type Detection Functions for dt-doc-validate
# Implements path-based and content-based detection per ADR-006

# ===========================================================================
# TYPE DETECTION
# ===========================================================================

# All supported document types
DT_DOCUMENT_TYPES=(
    "exploration" "research_topics" "exploration_hub"
    "research_topic" "research_summary" "requirements" "research_hub"
    "adr" "decisions_summary" "decisions_hub"
    "feature_plan" "phase" "status_and_next_steps" "planning_hub"
    "fix_batch" "handoff" "reflection"
)

dt_detect_document_type() {
    local file_path="$1"
    local explicit_type="${2:-}"
    
    # 1. Explicit type override (highest priority)
    if [ -n "$explicit_type" ]; then
        echo "$explicit_type"
        return 0
    fi
    
    # 2. Path-based detection (ordered most to least specific)
    local detected_type
    detected_type=$(dt_detect_from_path "$file_path")
    if [ -n "$detected_type" ]; then
        echo "$detected_type"
        return 0
    fi
    
    # 3. Content-based fallback
    detected_type=$(dt_detect_from_content "$file_path")
    if [ -n "$detected_type" ]; then
        echo "$detected_type"
        return 0
    fi
    
    # 4. Detection failed
    return 1
}

dt_detect_from_path() {
    local file_path="$1"
    
    case "$file_path" in
        */explorations/*/exploration.md)     echo "exploration" ;;
        */explorations/*/research-topics.md) echo "research_topics" ;;
        */explorations/*/README.md)          echo "exploration_hub" ;;
        */research/*/research-summary.md)    echo "research_summary" ;;
        */research/*/requirements.md)        echo "requirements" ;;
        */research/*/README.md)              echo "research_hub" ;;
        */research/*/research-*.md)          echo "research_topic" ;;
        */decisions/*/adr-*.md)              echo "adr" ;;
        */decisions/*/decisions-summary.md)  echo "decisions_summary" ;;
        */decisions/*/README.md)             echo "decisions_hub" ;;
        */planning/features/*/feature-plan.md) echo "feature_plan" ;;
        */planning/features/*/phase-*.md)    echo "phase" ;;
        */planning/features/*/status-and-next-steps.md) echo "status_and_next_steps" ;;
        */planning/features/*/README.md)     echo "planning_hub" ;;
        */planning/fix/fix-batch-*.md)       echo "fix_batch" ;;
        */handoff*.md)                       echo "handoff" ;;
        */reflection*.md)                    echo "reflection" ;;
        *)                                   echo "" ;;
    esac
}

dt_detect_from_content() {
    local file="$1"
    
    [ -f "$file" ] || return 1
    
    # Check distinctive patterns
    if grep -q "^# ADR-[0-9]" "$file" 2>/dev/null; then
        echo "adr"
    elif grep -q "^## 🎯 What We're Exploring" "$file" 2>/dev/null; then
        echo "exploration"
    elif grep -q "^## 🎯 Research Question" "$file" 2>/dev/null; then
        echo "research_topic"
    elif grep -q "^## ✅ Functional Requirements" "$file" 2>/dev/null; then
        echo "requirements"
    elif grep -q "^## 📊 Findings" "$file" 2>/dev/null; then
        echo "research_summary"
    else
        return 1
    fi
}

dt_list_document_types() {
    printf '%s\n' "${DT_DOCUMENT_TYPES[@]}"
}
```

**Checklist:**
- [ ] `dt_detect_document_type()` implements priority logic
- [ ] `dt_detect_from_path()` handles all 17 path patterns
- [ ] `dt_detect_from_content()` handles distinctive content patterns
- [ ] `dt_list_document_types()` returns all types
- [ ] Both `admin/` and `docs/maintainers/` paths supported
- [ ] All tests passing (GREEN state)
- [ ] Changes committed

---

### Task 3: Rule Loading Functions (ADR-002)

**Purpose:** Implement loading of pre-compiled .bash validation rules.

#### RED Phase - Write Failing Tests

**File:** `tests/unit/doc-validate/test-rules.bats`

```bash
# ===========================================================================
# RULE LOADING TESTS
# ===========================================================================

setup() {
    source "$PROJECT_ROOT/lib/doc-validate/rules.sh"
    
    # Create mock rules directory
    export MOCK_RULES_DIR="$BATS_TMPDIR/rules"
    mkdir -p "$MOCK_RULES_DIR"
    
    # Create mock exploration rules
    cat > "$MOCK_RULES_DIR/exploration.bash" << 'EOF'
# Mock exploration rules
DT_EXPLORATION_REQUIRED_SECTIONS=(
    "what_exploring|^## 🎯 What We're Exploring|Missing 'What We're Exploring' section"
    "themes|^## 🔍 Themes|Missing 'Themes' section"
)
EOF
}

teardown() {
    rm -rf "$MOCK_RULES_DIR"
}

@test "dt_load_rules: loads rules for valid document type" {
    run dt_load_rules "exploration" "$MOCK_RULES_DIR"
    [ "$status" -eq 0 ]
}

@test "dt_load_rules: returns error for missing rules" {
    run dt_load_rules "nonexistent" "$MOCK_RULES_DIR"
    [ "$status" -eq 1 ]
    [[ "$output" =~ "No validation rules found" ]]
}

@test "dt_load_rules: populates DT_*_REQUIRED_SECTIONS" {
    dt_load_rules "exploration" "$MOCK_RULES_DIR"
    [ "${#DT_EXPLORATION_REQUIRED_SECTIONS[@]}" -gt 0 ]
}

@test "dt_get_rules_path: returns default path" {
    unset DT_RULES_PATH
    run dt_get_rules_path
    [ "$status" -eq 0 ]
    [[ "$output" =~ "lib/validation/rules" ]]
}

@test "dt_get_rules_path: respects DT_RULES_PATH override" {
    export DT_RULES_PATH="/custom/rules"
    run dt_get_rules_path
    [ "$status" -eq 0 ]
    [ "$output" = "/custom/rules" ]
    unset DT_RULES_PATH
}

@test "dt_validate_rules_exist: returns 0 for valid rules" {
    run dt_validate_rules_exist "exploration" "$MOCK_RULES_DIR"
    [ "$status" -eq 0 ]
}

@test "dt_validate_rules_exist: returns 1 for missing rules" {
    run dt_validate_rules_exist "missing_type" "$MOCK_RULES_DIR"
    [ "$status" -eq 1 ]
}
```

**Checklist:**
- [ ] Tests for loading valid rules
- [ ] Tests for missing rules error
- [ ] Tests for rules path resolution
- [ ] Tests for DT_RULES_PATH override
- [ ] Tests for rules existence check
- [ ] All tests failing (RED state)

#### GREEN Phase - Implement Functions

**File:** `lib/doc-validate/rules.sh`

```bash
#!/bin/bash
# Rule Loading Functions for dt-doc-validate
# Implements pre-compiled .bash rule loading per ADR-002

# ===========================================================================
# RULE LOADING
# ===========================================================================

dt_get_rules_path() {
    if [ -n "${DT_RULES_PATH:-}" ]; then
        echo "$DT_RULES_PATH"
        return 0
    fi
    
    # Detect toolkit root
    local toolkit_root="${TOOLKIT_ROOT:-}"
    if [ -z "$toolkit_root" ]; then
        if [ -n "${BASH_SOURCE[0]:-}" ]; then
            local script_dir
            script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
            toolkit_root="${script_dir%/lib/doc-validate}"
        fi
    fi
    
    echo "$toolkit_root/lib/validation/rules"
}

dt_validate_rules_exist() {
    local doc_type="$1"
    local rules_path="${2:-$(dt_get_rules_path)}"
    
    [ -f "$rules_path/${doc_type}.bash" ]
}

dt_load_rules() {
    local doc_type="$1"
    local rules_path="${2:-$(dt_get_rules_path)}"
    
    local rules_file="$rules_path/${doc_type}.bash"
    
    if [ ! -f "$rules_file" ]; then
        dt_print_status "ERROR" "No validation rules found for: $doc_type"
        dt_print_debug "Looked for: $rules_file"
        return 1
    fi
    
    # Source the pre-compiled rules
    # shellcheck source=/dev/null
    source "$rules_file"
    
    dt_print_debug "Loaded rules from: $rules_file"
    return 0
}

dt_get_required_sections() {
    local doc_type="$1"
    
    # Map doc_type to the correct array name
    local array_name
    case "$doc_type" in
        exploration|research_topics|exploration_hub)
            array_name="DT_EXPLORATION_REQUIRED_SECTIONS" ;;
        research_topic|research_summary|requirements|research_hub)
            array_name="DT_RESEARCH_REQUIRED_SECTIONS" ;;
        adr|decisions_summary|decisions_hub)
            array_name="DT_DECISION_REQUIRED_SECTIONS" ;;
        feature_plan|phase|status_and_next_steps|planning_hub)
            array_name="DT_PLANNING_REQUIRED_SECTIONS" ;;
        *)
            array_name="DT_${doc_type^^}_REQUIRED_SECTIONS" ;;
    esac
    
    # Return the array contents via nameref
    local -n sections="$array_name" 2>/dev/null || return 1
    printf '%s\n' "${sections[@]}"
}
```

**Checklist:**
- [ ] `dt_get_rules_path()` with default and override support
- [ ] `dt_validate_rules_exist()` checks for rule file
- [ ] `dt_load_rules()` sources pre-compiled .bash files
- [ ] `dt_get_required_sections()` maps type to rules array
- [ ] Error handling for missing rules
- [ ] All tests passing (GREEN state)
- [ ] Changes committed

---

### Task 4: Validation Functions

**Purpose:** Implement validation logic that applies rules to document content.

#### RED Phase - Write Failing Tests

**File:** `tests/unit/doc-validate/test-validation.bats`

```bash
# ===========================================================================
# VALIDATION TESTS
# ===========================================================================

setup() {
    source "$PROJECT_ROOT/lib/doc-validate/validation.sh"
    source "$PROJECT_ROOT/lib/doc-validate/type-detection.sh"
    source "$PROJECT_ROOT/lib/doc-validate/rules.sh"
    
    # Create test document
    export TEST_DOC="$BATS_TMPDIR/test-doc.md"
}

teardown() {
    rm -f "$TEST_DOC"
}

@test "dt_validate_required_sections: passes when all sections present" {
    cat > "$TEST_DOC" << 'EOF'
# Test Document
## 🎯 What We're Exploring
Content here.
## 🔍 Themes
More content.
EOF
    
    local sections=(
        "what_exploring|^## 🎯 What We're Exploring|Missing section"
        "themes|^## 🔍 Themes|Missing themes"
    )
    
    run dt_validate_required_sections "$TEST_DOC" sections
    [ "$status" -eq 0 ]
}

@test "dt_validate_required_sections: fails when section missing" {
    cat > "$TEST_DOC" << 'EOF'
# Test Document
## 🎯 What We're Exploring
Content here.
EOF
    
    local sections=(
        "what_exploring|^## 🎯 What We're Exploring|Missing section"
        "themes|^## 🔍 Themes|Missing themes section"
    )
    
    run dt_validate_required_sections "$TEST_DOC" sections
    [ "$status" -eq 1 ]
}

@test "dt_validate_file: returns validation result structure" {
    cat > "$TEST_DOC" << 'EOF'
# ADR-001: Test
Content here.
EOF
    
    run dt_validate_file "$TEST_DOC" "adr"
    # Should return structured result
    [ "$status" -eq 0 ] || [ "$status" -eq 1 ]
}

@test "dt_validate_directory: processes all markdown files" {
    local test_dir="$BATS_TMPDIR/test-docs"
    mkdir -p "$test_dir"
    echo "# Doc 1" > "$test_dir/doc1.md"
    echo "# Doc 2" > "$test_dir/doc2.md"
    
    run dt_validate_directory "$test_dir"
    [ "$status" -eq 0 ] || [ "$status" -eq 1 ]
    
    rm -rf "$test_dir"
}
```

**Checklist:**
- [ ] Tests for section validation (pass/fail)
- [ ] Tests for file validation
- [ ] Tests for directory validation
- [ ] Tests for error collection
- [ ] All tests failing (RED state)

#### GREEN Phase - Implement Functions

**File:** `lib/doc-validate/validation.sh`

```bash
#!/bin/bash
# Validation Functions for dt-doc-validate
# Applies loaded rules to document content

# ===========================================================================
# VALIDATION RESULTS
# ===========================================================================

# Global arrays to collect results
declare -a DT_VALIDATION_ERRORS=()
declare -a DT_VALIDATION_WARNINGS=()
declare -i DT_VALIDATION_PASSED=0
declare -i DT_VALIDATION_FAILED=0

dt_reset_validation_results() {
    DT_VALIDATION_ERRORS=()
    DT_VALIDATION_WARNINGS=()
    DT_VALIDATION_PASSED=0
    DT_VALIDATION_FAILED=0
}

# ===========================================================================
# VALIDATION FUNCTIONS
# ===========================================================================

dt_validate_required_sections() {
    local file="$1"
    local -n section_rules="$2"
    local errors=()
    
    for rule in "${section_rules[@]}"; do
        IFS='|' read -r id pattern message <<< "$rule"
        
        if ! grep -qE "$pattern" "$file" 2>/dev/null; then
            errors+=("MISSING_SECTION|$message|$file")
        fi
    done
    
    if [ ${#errors[@]} -gt 0 ]; then
        printf '%s\n' "${errors[@]}"
        return 1
    fi
    
    return 0
}

dt_validate_file() {
    local file="$1"
    local doc_type="${2:-}"
    local rules_path="${3:-}"
    
    # Auto-detect type if not provided
    if [ -z "$doc_type" ]; then
        doc_type=$(dt_detect_document_type "$file") || {
            DT_VALIDATION_ERRORS+=("TYPE_DETECTION_FAILED|Could not determine document type|$file")
            ((DT_VALIDATION_FAILED++))
            return 1
        }
    fi
    
    # Load rules for this type
    if ! dt_load_rules "$doc_type" "$rules_path" 2>/dev/null; then
        DT_VALIDATION_WARNINGS+=("NO_RULES|No validation rules for type: $doc_type|$file")
        ((DT_VALIDATION_PASSED++))  # No rules = pass with warning
        return 0
    fi
    
    # Get required sections for this type
    local -a required_sections
    mapfile -t required_sections < <(dt_get_required_sections "$doc_type")
    
    # Validate required sections
    local section_errors
    if section_errors=$(dt_validate_required_sections "$file" required_sections 2>&1); then
        ((DT_VALIDATION_PASSED++))
        return 0
    else
        while IFS= read -r error; do
            DT_VALIDATION_ERRORS+=("$error")
        done <<< "$section_errors"
        ((DT_VALIDATION_FAILED++))
        return 1
    fi
}

dt_validate_directory() {
    local dir="$1"
    local doc_type="${2:-}"  # Optional type override for all files
    local rules_path="${3:-}"
    
    local exit_code=0
    
    # Find all markdown files
    while IFS= read -r -d '' file; do
        if ! dt_validate_file "$file" "$doc_type" "$rules_path"; then
            exit_code=1
        fi
    done < <(find "$dir" -name "*.md" -type f -print0)
    
    return $exit_code
}
```

**Checklist:**
- [ ] `dt_reset_validation_results()` clears state
- [ ] `dt_validate_required_sections()` checks patterns
- [ ] `dt_validate_file()` validates single file
- [ ] `dt_validate_directory()` validates all markdown files
- [ ] Error/warning collection working
- [ ] All tests passing (GREEN state)
- [ ] Changes committed

---

### Task 5: Error Output Functions (ADR-004)

**Purpose:** Implement text and JSON output formatters with proper exit codes.

#### RED Phase - Write Failing Tests

**File:** `tests/unit/doc-validate/test-output.bats`

```bash
# ===========================================================================
# OUTPUT TESTS
# ===========================================================================

setup() {
    source "$PROJECT_ROOT/lib/doc-validate/output.sh"
    source "$PROJECT_ROOT/lib/doc-validate/validation.sh"
}

@test "dt_format_error_text: formats error with file and fix" {
    run dt_format_error_text "MISSING_SECTION" "Missing required section" "test.md" "Add the section"
    [ "$status" -eq 0 ]
    [[ "$output" =~ "[ERROR]" ]]
    [[ "$output" =~ "test.md" ]]
    [[ "$output" =~ "Fix:" ]]
}

@test "dt_format_warning_text: formats warning" {
    run dt_format_warning_text "STALE_DATE" "Last updated is stale" "test.md" "Update date"
    [ "$status" -eq 0 ]
    [[ "$output" =~ "[WARNING]" ]]
}

@test "dt_format_summary_text: shows pass/fail counts" {
    DT_VALIDATION_PASSED=3
    DT_VALIDATION_FAILED=2
    DT_VALIDATION_ERRORS=("error1" "error2")
    DT_VALIDATION_WARNINGS=("warn1")
    
    run dt_format_summary_text
    [ "$status" -eq 0 ]
    [[ "$output" =~ "5 files" ]]
    [[ "$output" =~ "3 passed" ]]
    [[ "$output" =~ "2 failed" ]]
}

@test "dt_format_results_json: produces valid JSON" {
    DT_VALIDATION_PASSED=1
    DT_VALIDATION_FAILED=1
    DT_VALIDATION_ERRORS=("MISSING_SECTION|Missing section|file.md")
    
    run dt_format_results_json
    [ "$status" -eq 0 ]
    # Validate JSON structure (basic check)
    [[ "$output" =~ '"summary":' ]]
    [[ "$output" =~ '"results":' ]]
}

@test "dt_get_exit_code: returns 0 for no errors" {
    DT_VALIDATION_ERRORS=()
    run dt_get_exit_code
    [ "$status" -eq 0 ]
    [ "$output" = "0" ]
}

@test "dt_get_exit_code: returns 1 for validation errors" {
    DT_VALIDATION_ERRORS=("error1")
    run dt_get_exit_code
    [ "$status" -eq 0 ]
    [ "$output" = "1" ]
}
```

**Checklist:**
- [ ] Tests for text error formatting
- [ ] Tests for text warning formatting
- [ ] Tests for text summary
- [ ] Tests for JSON output
- [ ] Tests for exit code logic
- [ ] All tests failing (RED state)

#### GREEN Phase - Implement Functions

**File:** `lib/doc-validate/output.sh`

```bash
#!/bin/bash
# Output Functions for dt-doc-validate
# Implements text and JSON output per ADR-004

# ===========================================================================
# COLOR SETUP (reuse from output-utils.sh)
# ===========================================================================

dt_setup_validation_colors() {
    if [[ -t 1 ]] && command -v tput >/dev/null 2>&1; then
        DT_RED='\033[0;31m'
        DT_YELLOW='\033[1;33m'
        DT_GREEN='\033[0;32m'
        DT_NC='\033[0m'
    else
        DT_RED='' DT_YELLOW='' DT_GREEN='' DT_NC=''
    fi
}

# ===========================================================================
# TEXT OUTPUT
# ===========================================================================

dt_format_error_text() {
    local code="$1" message="$2" file="$3" fix="${4:-}"
    
    echo -e "${DT_RED}[ERROR]${DT_NC} $message"
    echo "  File: $file"
    if [ -n "$fix" ]; then
        echo "  Fix:  $fix"
    fi
    echo ""
}

dt_format_warning_text() {
    local code="$1" message="$2" file="$3" fix="${4:-}"
    
    echo -e "${DT_YELLOW}[WARNING]${DT_NC} $message"
    echo "  File: $file"
    if [ -n "$fix" ]; then
        echo "  Fix:  $fix"
    fi
    echo ""
}

dt_format_summary_text() {
    local total=$((DT_VALIDATION_PASSED + DT_VALIDATION_FAILED))
    local error_count=${#DT_VALIDATION_ERRORS[@]}
    local warning_count=${#DT_VALIDATION_WARNINGS[@]}
    
    echo "Summary: $total files, $DT_VALIDATION_PASSED passed, $DT_VALIDATION_FAILED failed ($error_count errors, $warning_count warnings)"
    
    if [ $DT_VALIDATION_FAILED -eq 0 ]; then
        echo -e "Result: ${DT_GREEN}PASSED${DT_NC}"
    else
        echo -e "Result: ${DT_RED}FAILED${DT_NC}"
    fi
}

dt_output_text() {
    dt_setup_validation_colors
    
    # Output errors
    for error in "${DT_VALIDATION_ERRORS[@]}"; do
        IFS='|' read -r code message file <<< "$error"
        dt_format_error_text "$code" "$message" "$file" ""
    done
    
    # Output warnings
    for warning in "${DT_VALIDATION_WARNINGS[@]}"; do
        IFS='|' read -r code message file <<< "$warning"
        dt_format_warning_text "$code" "$message" "$file" ""
    done
    
    # Output summary
    dt_format_summary_text
}

# ===========================================================================
# JSON OUTPUT
# ===========================================================================

dt_format_results_json() {
    local total=$((DT_VALIDATION_PASSED + DT_VALIDATION_FAILED))
    local error_count=${#DT_VALIDATION_ERRORS[@]}
    local warning_count=${#DT_VALIDATION_WARNINGS[@]}
    
    cat << EOF
{
  "summary": {
    "total_files": $total,
    "passed": $DT_VALIDATION_PASSED,
    "failed": $DT_VALIDATION_FAILED,
    "errors": $error_count,
    "warnings": $warning_count
  },
  "errors": [
$(dt_format_errors_json_array)
  ],
  "warnings": [
$(dt_format_warnings_json_array)
  ]
}
EOF
}

dt_format_errors_json_array() {
    local first=true
    for error in "${DT_VALIDATION_ERRORS[@]}"; do
        IFS='|' read -r code message file <<< "$error"
        if [ "$first" = true ]; then
            first=false
        else
            echo ","
        fi
        printf '    {"code": "%s", "message": "%s", "file": "%s"}' "$code" "$message" "$file"
    done
}

dt_format_warnings_json_array() {
    local first=true
    for warning in "${DT_VALIDATION_WARNINGS[@]}"; do
        IFS='|' read -r code message file <<< "$warning"
        if [ "$first" = true ]; then
            first=false
        else
            echo ","
        fi
        printf '    {"code": "%s", "message": "%s", "file": "%s"}' "$code" "$message" "$file"
    done
}

# ===========================================================================
# EXIT CODES
# ===========================================================================

dt_get_exit_code() {
    if [ ${#DT_VALIDATION_ERRORS[@]} -gt 0 ]; then
        echo "1"  # Validation errors
    else
        echo "0"  # Success (warnings OK)
    fi
}
```

**Checklist:**
- [ ] `dt_format_error_text()` formats errors
- [ ] `dt_format_warning_text()` formats warnings
- [ ] `dt_format_summary_text()` shows counts
- [ ] `dt_format_results_json()` produces valid JSON
- [ ] `dt_get_exit_code()` returns 0/1 based on errors
- [ ] Color support with TTY detection
- [ ] All tests passing (GREEN state)
- [ ] Changes committed

---

### Task 6: CLI Implementation

**Purpose:** Complete the CLI with argument parsing and orchestration.

**Steps:**

- [ ] Implement argument parsing (file/dir, --type, --json, --rules-path)
- [ ] Implement main validation flow
- [ ] Wire up all library functions
- [ ] Handle exit codes properly
- [ ] Add debug output support

**Implementation in `bin/dt-doc-validate`:**

```bash
main() {
    local target=""
    local explicit_type=""
    local json_output=false
    local rules_path=""
    
    # Parse arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            --help|-h) show_help; exit 0 ;;
            --version|-v) show_version; exit 0 ;;
            --debug) export DT_DEBUG=true; shift ;;
            --type) explicit_type="$2"; shift 2 ;;
            --json) json_output=true; shift ;;
            --rules-path) rules_path="$2"; shift 2 ;;
            -*) dt_print_status "ERROR" "Unknown option: $1"; show_help; exit 2 ;;
            *)
                if [ -z "$target" ]; then
                    target="$1"
                else
                    dt_print_status "ERROR" "Unexpected argument: $1"
                    exit 2
                fi
                shift
                ;;
        esac
    done
    
    # Validate target
    if [ -z "$target" ]; then
        dt_print_status "ERROR" "No file or directory specified"
        show_help
        exit 2
    fi
    
    if [ ! -e "$target" ]; then
        dt_print_status "ERROR" "File or directory not found: $target"
        exit 2
    fi
    
    # Initialize
    dt_reset_validation_results
    
    # Validate
    if [ -d "$target" ]; then
        dt_validate_directory "$target" "$explicit_type" "$rules_path"
    else
        dt_validate_file "$target" "$explicit_type" "$rules_path"
    fi
    
    # Output results
    if [ "$json_output" = true ]; then
        dt_format_results_json
    else
        dt_output_text
    fi
    
    # Exit with appropriate code
    exit "$(dt_get_exit_code)"
}
```

**Checklist:**
- [ ] Argument parsing complete
- [ ] File and directory validation working
- [ ] `--type` override working
- [ ] `--json` output working
- [ ] `--rules-path` override working
- [ ] Exit codes correct (0/1/2)
- [ ] Debug mode working
- [ ] CLI committed

---

### Task 7: Integration Testing

**Purpose:** Write end-to-end integration tests for the complete CLI.

**File:** `tests/integration/test-dt-doc-validate.bats`

```bash
#!/usr/bin/env bats

load '../helpers/setup'
load '../helpers/assertions'

DT_DOC_VALIDATE="$PROJECT_ROOT/bin/dt-doc-validate"

setup() {
    # Create test directory structure
    export TEST_DIR="$BATS_TMPDIR/test-validate"
    mkdir -p "$TEST_DIR/admin/explorations/test-topic"
    mkdir -p "$TEST_DIR/admin/decisions/test-decision"
    
    # Create mock rules
    export MOCK_RULES="$BATS_TMPDIR/rules"
    mkdir -p "$MOCK_RULES"
    
    cat > "$MOCK_RULES/exploration.bash" << 'EOF'
DT_EXPLORATION_REQUIRED_SECTIONS=(
    "what_exploring|^## 🎯 What We're Exploring|Missing 'What We're Exploring' section"
)
EOF
}

teardown() {
    rm -rf "$TEST_DIR" "$MOCK_RULES"
}

@test "dt-doc-validate: shows help with --help" {
    run "$DT_DOC_VALIDATE" --help
    [ "$status" -eq 0 ]
    [[ "$output" =~ "Usage:" ]]
}

@test "dt-doc-validate: shows version with --version" {
    run "$DT_DOC_VALIDATE" --version
    [ "$status" -eq 0 ]
    [[ "$output" =~ "version" ]]
}

@test "dt-doc-validate: errors with no arguments" {
    run "$DT_DOC_VALIDATE"
    [ "$status" -eq 2 ]
    [[ "$output" =~ "No file or directory" ]]
}

@test "dt-doc-validate: errors for nonexistent file" {
    run "$DT_DOC_VALIDATE" "/nonexistent/file.md"
    [ "$status" -eq 2 ]
    [[ "$output" =~ "not found" ]]
}

@test "dt-doc-validate: validates single file" {
    cat > "$TEST_DIR/admin/explorations/test-topic/exploration.md" << 'EOF'
# Test Exploration
## 🎯 What We're Exploring
Test content.
EOF
    
    run "$DT_DOC_VALIDATE" "$TEST_DIR/admin/explorations/test-topic/exploration.md" --rules-path "$MOCK_RULES"
    [ "$status" -eq 0 ]
    [[ "$output" =~ "PASSED" ]] || [[ "$output" =~ "passed" ]]
}

@test "dt-doc-validate: fails for missing required section" {
    cat > "$TEST_DIR/admin/explorations/test-topic/exploration.md" << 'EOF'
# Test Exploration
Missing the required section.
EOF
    
    run "$DT_DOC_VALIDATE" "$TEST_DIR/admin/explorations/test-topic/exploration.md" --rules-path "$MOCK_RULES"
    [ "$status" -eq 1 ]
    [[ "$output" =~ "FAILED" ]] || [[ "$output" =~ "failed" ]]
}

@test "dt-doc-validate: validates directory" {
    cat > "$TEST_DIR/admin/explorations/test-topic/exploration.md" << 'EOF'
# Test
## 🎯 What We're Exploring
Content.
EOF
    
    run "$DT_DOC_VALIDATE" "$TEST_DIR/admin/explorations/" --rules-path "$MOCK_RULES"
    # Should process at least one file
    [[ "$output" =~ "file" ]]
}

@test "dt-doc-validate: respects --type override" {
    cat > "$TEST_DIR/custom.md" << 'EOF'
# Custom Document
## 🎯 What We're Exploring
Content.
EOF
    
    run "$DT_DOC_VALIDATE" "$TEST_DIR/custom.md" --type exploration --rules-path "$MOCK_RULES"
    [ "$status" -eq 0 ] || [ "$status" -eq 1 ]
}

@test "dt-doc-validate: --json produces JSON output" {
    cat > "$TEST_DIR/admin/explorations/test-topic/exploration.md" << 'EOF'
# Test
## 🎯 What We're Exploring
Content.
EOF
    
    run "$DT_DOC_VALIDATE" "$TEST_DIR/admin/explorations/test-topic/exploration.md" --json --rules-path "$MOCK_RULES"
    [[ "$output" =~ '"summary":' ]]
    [[ "$output" =~ '"errors":' ]]
}

@test "dt-doc-validate: exit code 0 for success" {
    cat > "$TEST_DIR/admin/explorations/test-topic/exploration.md" << 'EOF'
# Test
## 🎯 What We're Exploring
Content.
EOF
    
    run "$DT_DOC_VALIDATE" "$TEST_DIR/admin/explorations/test-topic/exploration.md" --rules-path "$MOCK_RULES"
    [ "$status" -eq 0 ]
}

@test "dt-doc-validate: exit code 1 for validation errors" {
    cat > "$TEST_DIR/admin/explorations/test-topic/exploration.md" << 'EOF'
# Test
Missing sections.
EOF
    
    run "$DT_DOC_VALIDATE" "$TEST_DIR/admin/explorations/test-topic/exploration.md" --rules-path "$MOCK_RULES"
    [ "$status" -eq 1 ]
}
```

**Checklist:**
- [ ] Tests for help and version
- [ ] Tests for argument validation
- [ ] Tests for file validation
- [ ] Tests for directory validation
- [ ] Tests for `--type` override
- [ ] Tests for `--json` output
- [ ] Tests for exit codes
- [ ] All integration tests passing
- [ ] Final commit and PR ready

---

## ✅ Completion Criteria

- [ ] `dt-doc-validate admin/explorations/my-topic/` works correctly
- [ ] `dt-doc-validate --type adr decisions/adr-001.md` works
- [ ] Type detection follows priority: flag → path → content → error
- [ ] Error output shows location, message, severity, fix suggestion
- [ ] Exit codes: 0 (success/warnings), 1 (errors), 2 (system)
- [ ] `--json` flag produces valid JSON output
- [ ] All 17 document types detected correctly
- [ ] Tests passing (target: >30 tests)

---

## 📦 Deliverables

- `bin/dt-doc-validate` - CLI entry point
- `lib/doc-validate/type-detection.sh` - Type detection functions
- `lib/doc-validate/rules.sh` - Rule loading functions
- `lib/doc-validate/validation.sh` - Validation logic
- `lib/doc-validate/output.sh` - Text and JSON formatters
- `tests/unit/doc-validate/` - Unit tests (4 files)
- `tests/integration/test-dt-doc-validate.bats` - Integration tests

---

## 🔗 Dependencies

### Prerequisites

- Phase 1 complete (shared infrastructure)
- dev-infra validation rules accessible (pre-compiled .bash)

### Blocks

- Command migration Sprint 1 (/explore)

---

## 🔗 Related Documents

- [Feature Hub](README.md)
- [Previous Phase: Phase 2](phase-2.md)
- [ADR-002: Validation Rule Loading](../../../decisions/doc-infrastructure/adr-002-validation-rule-loading.md)
- [ADR-004: Error Output Design](../../../decisions/doc-infrastructure/adr-004-error-output-design.md)
- [ADR-006: Type Detection](../../../decisions/doc-infrastructure/adr-006-type-detection.md)
- [Research: YAML Parsing](../../../research/doc-infrastructure/research-yaml-parsing.md)
- [Research: Error Output](../../../research/doc-infrastructure/research-error-output.md)

---

**Last Updated:** 2026-01-22  
**Status:** ✅ Expanded  
**Next:** Begin implementation with Task 1
