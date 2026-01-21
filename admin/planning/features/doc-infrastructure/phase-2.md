# Doc Infrastructure - Phase 2: dt-doc-gen

**Phase:** 2 - dt-doc-gen  
**Duration:** 3-4 days  
**Status:** 🟠 In Progress  
**Prerequisites:** Phase 1 complete, dev-infra templates accessible

---

## 📋 Overview

Implement the `dt-doc-gen` command for generating documentation from dev-infra templates. Supports layered template discovery (ADR-001), selective variable expansion (ADR-003), and two-mode operation (setup/conduct).

**Success Definition:** All 17 document types generate correctly with proper variable expansion and mode support.

---

## 🎯 Goals

1. **Create dt-doc-gen CLI** - Main command entry point with help and argument parsing
2. **Implement template discovery** - Layered discovery per ADR-001
3. **Implement variable expansion** - Selective envsubst per ADR-003
4. **Support two modes** - Setup mode (structure) and conduct mode (content zones)
5. **Write tests** - Unit and integration tests with TDD workflow

---

## 📝 Tasks

### Task 1: Test Setup and CLI Scaffolding

**Purpose:** Create the test file structure and empty CLI file to enable TDD workflow.

**Steps:**

- [x] Create `bin/dt-doc-gen` with header comment and empty structure
- [x] Create `lib/doc-gen/templates.sh` with empty structure
- [x] Create `lib/doc-gen/render.sh` with empty structure
- [x] Create `tests/unit/doc-gen/test-templates.bats` with test setup
- [x] Create `tests/unit/doc-gen/test-render.bats` with test setup
- [x] Create `tests/integration/test-dt-doc-gen.bats` with test setup

**CLI scaffolding:**

```bash
#!/usr/bin/env bash

# ============================================================================
# DT-DOC-GEN - Generate documentation from dev-infra templates
# Usage: dt-doc-gen <type> <topic> [OPTIONS]
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
# source "$TOOLKIT_ROOT/lib/doc-gen/templates.sh"  # After implementation
# source "$TOOLKIT_ROOT/lib/doc-gen/render.sh"     # After implementation

# ============================================================================
# FUNCTIONS
# ============================================================================

show_help() {
    cat << EOF
Usage: $SCRIPT_NAME <type> <topic> [OPTIONS]

Generate documentation from dev-infra templates.

Arguments:
    type              Document type (exploration, research, decision, planning, etc.)
    topic             Topic or feature name for the document

Options:
    --mode MODE       Generation mode: setup (scaffolding) or conduct (expand)
    --output PATH     Output directory (default: auto-detect from project structure)
    --template-path   Explicit path to templates directory
    --help            Show this help message
    --version         Show version information
    --debug           Enable debug output

Document Types:
    exploration       Exploration documents (exploration.md, research-topics.md, README.md)
    research          Research documents (research-topic.md, requirements.md, etc.)
    decision          Decision documents (adr.md, decisions-summary.md)
    planning          Planning documents (feature-plan.md, phase.md, etc.)
    handoff           Session handoff document
    fix-batch         Fix batch planning document

Examples:
    $SCRIPT_NAME exploration my-feature
    $SCRIPT_NAME research my-topic --mode setup
    $SCRIPT_NAME decision auth-system --output admin/decisions/auth/

EOF
}

show_version() {
    echo "$SCRIPT_NAME version $VERSION"
}

# ============================================================================
# MAIN EXECUTION
# ============================================================================

main() {
    # Parse arguments (to be implemented)
    echo "dt-doc-gen: Not yet implemented"
    exit 1
}

main "$@"
```

**Library scaffolding (templates.sh):**

```bash
#!/bin/bash
# Template Discovery Functions for dt-doc-gen
# Implements layered template discovery per ADR-001

# ============================================================================
# TEMPLATE DISCOVERY
# ============================================================================

# (Template discovery functions will go here)
```

**Library scaffolding (render.sh):**

```bash
#!/bin/bash
# Template Rendering Functions for dt-doc-gen
# Implements selective variable expansion per ADR-003

# ============================================================================
# VARIABLE EXPANSION
# ============================================================================

# (Rendering functions will go here)
```

**Test scaffolding:**

```bash
#!/usr/bin/env bats

# Tests for dt-doc-gen template discovery
# Location: tests/unit/doc-gen/test-templates.bats

load '../../helpers/setup'
load '../../helpers/assertions'

setup() {
    source "$PROJECT_ROOT/lib/doc-gen/templates.sh"
}

# Test sections will go here
```

**Checklist:**
- [ ] `bin/dt-doc-gen` created with structure
- [ ] `lib/doc-gen/templates.sh` created
- [ ] `lib/doc-gen/render.sh` created
- [x] Test files created with setup
- [x] All files source correctly without errors

---

### Task 2: Template Discovery Functions

**Purpose:** Implement layered template discovery per ADR-001.

**Discovery Priority:**
1. `--template-path` flag (explicit override)
2. `$DT_TEMPLATES_PATH` environment variable
3. Config file setting (XDG-compliant)
4. Default local paths
5. Error with setup help

**TDD Flow:**

#### 2.1 RED - Write failing tests for template discovery

- [ ] Write test: `dt_find_templates` returns explicit path when provided
- [ ] Write test: `dt_find_templates` returns `$DT_TEMPLATES_PATH` if set
- [ ] Write test: `dt_find_templates` reads config file path
- [ ] Write test: `dt_find_templates` checks default locations
- [ ] Write test: `dt_find_templates` returns error if not found
- [ ] Write test: `dt_get_template_path` returns correct path for doc type
- [ ] Write test: `dt_validate_templates_dir` checks required files exist
- [ ] Verify tests fail (no implementation yet)

**Test code:**

```bash
# ============================================================================
# Template Discovery Tests
# ============================================================================

@test "dt_find_templates: returns explicit path when provided" {
    local test_dir=$(mktemp -d)
    mkdir -p "$test_dir/exploration"
    touch "$test_dir/exploration/exploration.md.tmpl"
    
    run dt_find_templates "$test_dir"
    [ "$status" -eq 0 ]
    [ "$output" = "$test_dir" ]
    
    rm -rf "$test_dir"
}

@test "dt_find_templates: returns DT_TEMPLATES_PATH if set" {
    local test_dir=$(mktemp -d)
    mkdir -p "$test_dir/exploration"
    touch "$test_dir/exploration/exploration.md.tmpl"
    
    export DT_TEMPLATES_PATH="$test_dir"
    run dt_find_templates
    [ "$status" -eq 0 ]
    [ "$output" = "$test_dir" ]
    
    unset DT_TEMPLATES_PATH
    rm -rf "$test_dir"
}

@test "dt_find_templates: reads config file path" {
    local test_dir=$(mktemp -d)
    local config_dir=$(mktemp -d)
    
    mkdir -p "$test_dir/exploration"
    touch "$test_dir/exploration/exploration.md.tmpl"
    
    # Create config file
    echo "DT_TEMPLATES_PATH=$test_dir" > "$config_dir/config"
    
    # Override config location
    export XDG_CONFIG_HOME="$config_dir"
    mkdir -p "$config_dir/dev-toolkit"
    mv "$config_dir/config" "$config_dir/dev-toolkit/config"
    
    unset DT_TEMPLATES_PATH
    run dt_find_templates
    [ "$status" -eq 0 ]
    [ "$output" = "$test_dir" ]
    
    unset XDG_CONFIG_HOME
    rm -rf "$test_dir" "$config_dir"
}

@test "dt_find_templates: returns error if not found" {
    unset DT_TEMPLATES_PATH
    # Create isolated environment with no templates
    local test_dir=$(mktemp -d)
    cd "$test_dir"
    
    # Override config to empty location
    export XDG_CONFIG_HOME="$test_dir/config"
    export HOME="$test_dir/home"
    
    run dt_find_templates
    [ "$status" -eq 1 ]
    
    unset XDG_CONFIG_HOME
    rm -rf "$test_dir"
}

@test "dt_get_template_path: returns correct path for exploration type" {
    export DT_TEMPLATES_PATH="/mock/templates"
    
    run dt_get_template_path "exploration" "exploration"
    [ "$status" -eq 0 ]
    [ "$output" = "/mock/templates/exploration/exploration.md.tmpl" ]
    
    unset DT_TEMPLATES_PATH
}

@test "dt_get_template_path: returns correct path for research type" {
    export DT_TEMPLATES_PATH="/mock/templates"
    
    run dt_get_template_path "research" "research-topic"
    [ "$status" -eq 0 ]
    [ "$output" = "/mock/templates/research/research-topic.md.tmpl" ]
    
    unset DT_TEMPLATES_PATH
}

@test "dt_get_template_path: returns correct path for decision type" {
    export DT_TEMPLATES_PATH="/mock/templates"
    
    run dt_get_template_path "decision" "adr"
    [ "$status" -eq 0 ]
    [ "$output" = "/mock/templates/decision/adr.md.tmpl" ]
    
    unset DT_TEMPLATES_PATH
}

@test "dt_validate_templates_dir: passes with valid structure" {
    local test_dir=$(mktemp -d)
    
    # Create expected template structure
    for category in exploration research decision planning other; do
        mkdir -p "$test_dir/$category"
        touch "$test_dir/$category/test.md.tmpl"
    done
    
    run dt_validate_templates_dir "$test_dir"
    [ "$status" -eq 0 ]
    
    rm -rf "$test_dir"
}

@test "dt_validate_templates_dir: fails with missing directories" {
    local test_dir=$(mktemp -d)
    
    run dt_validate_templates_dir "$test_dir"
    [ "$status" -eq 1 ]
    
    rm -rf "$test_dir"
}
```

#### 2.2 GREEN - Implement template discovery functions

- [ ] Implement `dt_find_templates()` with layered discovery
- [ ] Implement `dt_get_template_path()` for doc type to path mapping
- [ ] Implement `dt_validate_templates_dir()` for validation
- [ ] Implement `dt_list_document_types()` helper
- [ ] Run tests, verify they pass

**Implementation:**

```bash
# ============================================================================
# TEMPLATE DISCOVERY
# ============================================================================

# Document type to template category mapping
declare -A DT_TYPE_CATEGORY=(
    ["exploration"]="exploration"
    ["research_topics"]="exploration"
    ["exploration_hub"]="exploration"
    ["research_topic"]="research"
    ["research_summary"]="research"
    ["requirements"]="research"
    ["research_hub"]="research"
    ["adr"]="decision"
    ["decisions_summary"]="decision"
    ["decisions_hub"]="decision"
    ["feature_plan"]="planning"
    ["phase"]="planning"
    ["status_and_next_steps"]="planning"
    ["planning_hub"]="planning"
    ["fix_batch"]="other"
    ["handoff"]="other"
    ["reflection"]="other"
)

# Document type to template filename mapping
declare -A DT_TYPE_TEMPLATE=(
    ["exploration"]="exploration.md.tmpl"
    ["research_topics"]="research-topics.md.tmpl"
    ["exploration_hub"]="README.md.tmpl"
    ["research_topic"]="research-topic.md.tmpl"
    ["research_summary"]="research-summary.md.tmpl"
    ["requirements"]="requirements.md.tmpl"
    ["research_hub"]="README.md.tmpl"
    ["adr"]="adr.md.tmpl"
    ["decisions_summary"]="decisions-summary.md.tmpl"
    ["decisions_hub"]="README.md.tmpl"
    ["feature_plan"]="feature-plan.md.tmpl"
    ["phase"]="phase.md.tmpl"
    ["status_and_next_steps"]="status-and-next-steps.md.tmpl"
    ["planning_hub"]="README.md.tmpl"
    ["fix_batch"]="fix-batch.md.tmpl"
    ["handoff"]="handoff.md.tmpl"
    ["reflection"]="reflection.md.tmpl"
)

dt_find_templates() {
    local explicit_path="${1:-}"
    
    # 1. Explicit path (highest priority)
    if [ -n "$explicit_path" ] && [ -d "$explicit_path" ]; then
        echo "$explicit_path"
        return 0
    fi
    
    # 2. Environment variable
    if [ -n "${DT_TEMPLATES_PATH:-}" ] && [ -d "$DT_TEMPLATES_PATH" ]; then
        echo "$DT_TEMPLATES_PATH"
        return 0
    fi
    
    # 3. Config file (XDG-compliant)
    local config_file
    config_file=$(dt_get_config_file)
    if [ -f "$config_file" ]; then
        local config_path
        config_path=$(grep "^DT_TEMPLATES_PATH=" "$config_file" 2>/dev/null | cut -d= -f2)
        if [ -n "$config_path" ] && [ -d "$config_path" ]; then
            echo "$config_path"
            return 0
        fi
    fi
    
    # 3b. Legacy config path (backward compatibility)
    local legacy_config="$HOME/.dev-toolkit/config.conf"
    if [ -f "$legacy_config" ]; then
        local config_path
        config_path=$(grep "^DT_TEMPLATES_PATH=" "$legacy_config" 2>/dev/null | cut -d= -f2)
        if [ -n "$config_path" ] && [ -d "$config_path" ]; then
            dt_print_status "WARNING" "Using legacy config at $legacy_config"
            dt_print_status "INFO" "Consider migrating to $(dt_get_config_file)"
            echo "$config_path"
            return 0
        fi
    fi
    
    # 4. Default locations
    local default_paths=(
        "$HOME/Projects/dev-infra/scripts/doc-gen/templates"
        "$HOME/dev-infra/scripts/doc-gen/templates"
    )
    
    # Also check sibling to dev-toolkit
    if [ -n "${TOOLKIT_ROOT:-}" ]; then
        local sibling="${TOOLKIT_ROOT%/*}/dev-infra/scripts/doc-gen/templates"
        default_paths=("$sibling" "${default_paths[@]}")
    fi
    
    for path in "${default_paths[@]}"; do
        if [ -d "$path" ]; then
            echo "$path"
            return 0
        fi
    done
    
    # 5. Not found - error
    return 1
}

dt_get_template_path() {
    local doc_type="$1"
    local template_name="${2:-$doc_type}"
    local templates_root="${3:-}"
    
    # Get templates root if not provided
    if [ -z "$templates_root" ]; then
        templates_root=$(dt_find_templates) || return 1
    fi
    
    # Get category for this doc type
    local category="${DT_TYPE_CATEGORY[$doc_type]:-}"
    if [ -z "$category" ]; then
        # Fall back to template_name as category
        category="$doc_type"
    fi
    
    # Get template filename
    local template_file="${DT_TYPE_TEMPLATE[$template_name]:-${template_name}.md.tmpl}"
    
    echo "$templates_root/$category/$template_file"
}

dt_validate_templates_dir() {
    local templates_dir="$1"
    
    if [ ! -d "$templates_dir" ]; then
        return 1
    fi
    
    # Check for required category directories
    local required_dirs=("exploration" "research" "decision" "planning" "other")
    local missing=()
    
    for dir in "${required_dirs[@]}"; do
        if [ ! -d "$templates_dir/$dir" ]; then
            missing+=("$dir")
        fi
    done
    
    if [ ${#missing[@]} -gt 0 ]; then
        dt_print_debug "Missing template directories: ${missing[*]}"
        return 1
    fi
    
    return 0
}

dt_list_document_types() {
    local category="${1:-}"
    
    if [ -n "$category" ]; then
        # List types for specific category
        for type in "${!DT_TYPE_CATEGORY[@]}"; do
            if [ "${DT_TYPE_CATEGORY[$type]}" = "$category" ]; then
                echo "$type"
            fi
        done
    else
        # List all types
        for type in "${!DT_TYPE_CATEGORY[@]}"; do
            echo "$type"
        done | sort
    fi
}
```

#### 2.3 REFACTOR - Review and clean up

- [ ] Ensure function naming is consistent with `dt_*` prefix
- [ ] Add function documentation comments
- [ ] Extract magic strings to constants
- [ ] Verify tests still pass

**Checklist:**
- [ ] All template discovery tests pass
- [ ] Layered discovery works correctly
- [ ] Error message includes setup instructions
- [ ] Legacy config path supported with deprecation warning

---

### Task 3: Variable Expansion Functions

**Purpose:** Implement selective variable expansion per ADR-003.

**Key Requirements:**
- Use selective `envsubst` mode (explicit variable list)
- Define variables per template type
- Check for `envsubst` availability
- Preserve `$VAR` syntax (no braces), HTML comments, and AI markers

**TDD Flow:**

#### 3.1 RED - Write failing tests for variable expansion

- [ ] Write test: `dt_check_envsubst` returns success if envsubst available
- [ ] Write test: `dt_check_envsubst` returns error with message if missing
- [ ] Write test: `dt_get_template_vars` returns correct vars for exploration
- [ ] Write test: `dt_get_template_vars` returns correct vars for research
- [ ] Write test: `dt_get_template_vars` returns correct vars for decision
- [ ] Write test: `dt_render_template` expands only listed variables
- [ ] Write test: `dt_render_template` preserves `$VAR` syntax (no braces)
- [ ] Write test: `dt_render_template` preserves AI markers (`<!-- AI: -->`)
- [ ] Verify tests fail (no implementation yet)

**Test code:**

```bash
# ============================================================================
# Variable Expansion Tests
# ============================================================================

@test "dt_check_envsubst: returns success if envsubst available" {
    # Skip if envsubst not installed
    if ! command -v envsubst >/dev/null 2>&1; then
        skip "envsubst not installed"
    fi
    
    run dt_check_envsubst
    [ "$status" -eq 0 ]
}

@test "dt_get_template_vars: returns correct vars for exploration" {
    run dt_get_template_vars "exploration"
    [ "$status" -eq 0 ]
    [[ "$output" =~ '\${DATE}' ]]
    [[ "$output" =~ '\${STATUS}' ]]
    [[ "$output" =~ '\${TOPIC_NAME}' ]]
    [[ "$output" =~ '\${TOPIC_TITLE}' ]]
}

@test "dt_get_template_vars: returns correct vars for research" {
    run dt_get_template_vars "research_topic"
    [ "$status" -eq 0 ]
    [[ "$output" =~ '\${DATE}' ]]
    [[ "$output" =~ '\${QUESTION}' ]]
    [[ "$output" =~ '\${QUESTION_NAME}' ]]
}

@test "dt_get_template_vars: returns correct vars for decision" {
    run dt_get_template_vars "adr"
    [ "$status" -eq 0 ]
    [[ "$output" =~ '\${DATE}' ]]
    [[ "$output" =~ '\${ADR_NUMBER}' ]]
    [[ "$output" =~ '\${DECISION_TITLE}' ]]
}

@test "dt_render_template: expands only listed variables" {
    # Skip if envsubst not installed
    if ! command -v envsubst >/dev/null 2>&1; then
        skip "envsubst not installed"
    fi
    
    local test_dir=$(mktemp -d)
    local template="$test_dir/test.tmpl"
    local output_file="$test_dir/output.md"
    
    # Create test template with both ${VAR} and $VAR patterns
    cat > "$template" << 'EOF'
# ${TOPIC_TITLE}

Created: ${DATE}

This should preserve $PRICE and $OTHER_VAR
EOF
    
    export DATE="2026-01-21"
    export TOPIC_TITLE="Test Topic"
    export PRICE="100"
    export OTHER_VAR="should-preserve"
    
    run dt_render_template "$template" "$output_file" "exploration"
    [ "$status" -eq 0 ]
    
    # Check expanded variables
    grep -q "# Test Topic" "$output_file"
    grep -q "Created: 2026-01-21" "$output_file"
    
    # Check preserved variables (not expanded)
    grep -q '\$PRICE' "$output_file"
    grep -q '\$OTHER_VAR' "$output_file"
    
    unset DATE TOPIC_TITLE PRICE OTHER_VAR
    rm -rf "$test_dir"
}

@test "dt_render_template: preserves AI markers" {
    # Skip if envsubst not installed
    if ! command -v envsubst >/dev/null 2>&1; then
        skip "envsubst not installed"
    fi
    
    local test_dir=$(mktemp -d)
    local template="$test_dir/test.tmpl"
    local output_file="$test_dir/output.md"
    
    # Create test template with AI markers
    cat > "$template" << 'EOF'
# ${TOPIC_TITLE}

<!-- AI: Expand this section with background context -->

## Overview

<!-- EXPAND: Add detailed overview based on research -->
EOF
    
    export TOPIC_TITLE="Test Topic"
    
    run dt_render_template "$template" "$output_file" "exploration"
    [ "$status" -eq 0 ]
    
    # Check AI markers preserved
    grep -q '<!-- AI:' "$output_file"
    grep -q '<!-- EXPAND:' "$output_file"
    
    unset TOPIC_TITLE
    rm -rf "$test_dir"
}

@test "dt_set_common_vars: sets DATE and STATUS" {
    dt_set_common_vars
    
    [ -n "$DATE" ]
    [ -n "$STATUS" ]
    [[ "$DATE" =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]]
}

@test "dt_set_exploration_vars: sets exploration-specific variables" {
    dt_set_exploration_vars "my-topic"
    
    [ "$TOPIC_NAME" = "my-topic" ]
    [ -n "$TOPIC_TITLE" ]
}
```

#### 3.2 GREEN - Implement variable expansion functions

- [ ] Implement `dt_check_envsubst()` with helpful error
- [ ] Implement `dt_get_template_vars()` per template type
- [ ] Implement `dt_render_template()` with selective expansion
- [ ] Implement `dt_set_common_vars()` for DATE, STATUS, etc.
- [ ] Implement variable setters for each doc type
- [ ] Run tests, verify they pass

**Implementation:**

```bash
# ============================================================================
# VARIABLE EXPANSION (per ADR-003)
# ============================================================================

# Variable lists per template type
DT_EXPLORATION_VARS='${DATE} ${STATUS} ${TOPIC_NAME} ${TOPIC_TITLE}'
DT_RESEARCH_VARS='${DATE} ${STATUS} ${TOPIC_NAME} ${QUESTION} ${QUESTION_NAME}'
DT_DECISION_VARS='${DATE} ${STATUS} ${ADR_NUMBER} ${DECISION_TITLE}'
DT_PLANNING_VARS='${DATE} ${STATUS} ${FEATURE_NAME} ${PHASE_NUMBER} ${PHASE_NAME}'
DT_OTHER_VARS='${DATE} ${STATUS} ${TOPIC_NAME}'

dt_check_envsubst() {
    if ! command -v envsubst >/dev/null 2>&1; then
        dt_print_status "ERROR" "envsubst is required but not installed"
        dt_print_status "INFO" "Install with: brew install gettext (macOS)"
        dt_print_status "INFO" "Install with: apt install gettext (Ubuntu)"
        return 1
    fi
    return 0
}

dt_get_template_vars() {
    local doc_type="$1"
    local category="${DT_TYPE_CATEGORY[$doc_type]:-other}"
    
    case "$category" in
        "exploration")
            echo "$DT_EXPLORATION_VARS"
            ;;
        "research")
            echo "$DT_RESEARCH_VARS"
            ;;
        "decision")
            echo "$DT_DECISION_VARS"
            ;;
        "planning")
            echo "$DT_PLANNING_VARS"
            ;;
        *)
            echo "$DT_OTHER_VARS"
            ;;
    esac
}

dt_render_template() {
    local template="$1"
    local output="$2"
    local doc_type="$3"
    
    # Check envsubst availability
    dt_check_envsubst || return 1
    
    # Check template exists
    if [ ! -f "$template" ]; then
        dt_print_status "ERROR" "Template not found: $template"
        return 1
    fi
    
    # Get variable list for this template type
    local vars
    vars=$(dt_get_template_vars "$doc_type")
    
    dt_print_debug "Rendering template: $template"
    dt_print_debug "Variables: $vars"
    
    # SELECTIVE expansion - only listed variables (per ADR-003)
    envsubst "$vars" < "$template" > "$output"
    
    return 0
}

dt_set_common_vars() {
    export DATE=$(date +%Y-%m-%d)
    export STATUS="🔴 Not Started"
}

dt_set_exploration_vars() {
    local topic_name="$1"
    
    dt_set_common_vars
    
    export TOPIC_NAME="$topic_name"
    # Convert kebab-case to Title Case
    export TOPIC_TITLE=$(echo "$topic_name" | sed 's/-/ /g' | awk '{for(i=1;i<=NF;i++) $i=toupper(substr($i,1,1)) tolower(substr($i,2))}1')
}

dt_set_research_vars() {
    local topic_name="$1"
    local question="${2:-}"
    
    dt_set_common_vars
    
    export TOPIC_NAME="$topic_name"
    export QUESTION="${question:-Research Question TBD}"
    export QUESTION_NAME=$(echo "$topic_name" | sed 's/-/ /g')
}

dt_set_decision_vars() {
    local adr_number="$1"
    local decision_title="$2"
    
    dt_set_common_vars
    
    export ADR_NUMBER="$adr_number"
    export DECISION_TITLE="$decision_title"
}

dt_set_planning_vars() {
    local feature_name="$1"
    local phase_number="${2:-1}"
    local phase_name="${3:-Foundation}"
    
    dt_set_common_vars
    
    export FEATURE_NAME="$feature_name"
    export PHASE_NUMBER="$phase_number"
    export PHASE_NAME="$phase_name"
}
```

#### 3.3 REFACTOR - Review and clean up

- [ ] Ensure variable lists match dev-infra VARIABLES.md
- [ ] Add documentation for variable expansion behavior
- [ ] Handle edge cases (empty variables, special characters)
- [ ] Verify tests still pass

**Checklist:**
- [ ] All variable expansion tests pass
- [ ] envsubst check provides helpful installation message
- [ ] Selective expansion preserves unmatched patterns
- [ ] AI markers (`<!-- AI: -->`, `<!-- EXPAND: -->`) preserved

---

### Task 4: Document Type and Output Path Handling

**Purpose:** Map document types to output paths based on project structure.

**TDD Flow:**

#### 4.1 RED - Write failing tests for output path handling

- [ ] Write test: `dt_get_output_dir` returns correct path for exploration
- [ ] Write test: `dt_get_output_dir` returns correct path for research
- [ ] Write test: `dt_get_output_dir` respects `--output` override
- [ ] Write test: `dt_get_output_filename` returns correct name for each type
- [ ] Write test: `dt_create_output_dir` creates directory if missing
- [ ] Verify tests fail

**Test code:**

```bash
# ============================================================================
# Output Path Tests
# ============================================================================

@test "dt_get_output_dir: returns correct path for exploration with admin structure" {
    local test_dir=$(mktemp -d)
    mkdir -p "$test_dir/admin/explorations"
    
    run dt_get_output_dir "$test_dir" "exploration" "my-topic"
    [ "$status" -eq 0 ]
    [ "$output" = "$test_dir/admin/explorations/my-topic" ]
    
    rm -rf "$test_dir"
}

@test "dt_get_output_dir: returns correct path for research with admin structure" {
    local test_dir=$(mktemp -d)
    mkdir -p "$test_dir/admin/research"
    
    run dt_get_output_dir "$test_dir" "research_topic" "my-topic"
    [ "$status" -eq 0 ]
    [ "$output" = "$test_dir/admin/research/my-topic" ]
    
    rm -rf "$test_dir"
}

@test "dt_get_output_dir: respects explicit output override" {
    local test_dir=$(mktemp -d)
    local custom_output="$test_dir/custom/output"
    
    run dt_get_output_dir "$test_dir" "exploration" "my-topic" "$custom_output"
    [ "$status" -eq 0 ]
    [ "$output" = "$custom_output" ]
    
    rm -rf "$test_dir"
}

@test "dt_get_output_filename: returns exploration.md for exploration type" {
    run dt_get_output_filename "exploration"
    [ "$status" -eq 0 ]
    [ "$output" = "exploration.md" ]
}

@test "dt_get_output_filename: returns research-topics.md for research_topics type" {
    run dt_get_output_filename "research_topics"
    [ "$status" -eq 0 ]
    [ "$output" = "research-topics.md" ]
}

@test "dt_get_output_filename: returns adr-NNN.md for adr type" {
    export ADR_NUMBER="001"
    run dt_get_output_filename "adr"
    [ "$status" -eq 0 ]
    [ "$output" = "adr-001.md" ]
    unset ADR_NUMBER
}
```

#### 4.2 GREEN - Implement output path functions

- [ ] Implement `dt_get_output_dir()` using project structure detection
- [ ] Implement `dt_get_output_filename()` per document type
- [ ] Implement `dt_create_output_dir()` for directory creation
- [ ] Run tests, verify they pass

**Implementation:**

```bash
# ============================================================================
# OUTPUT PATH HANDLING
# ============================================================================

# Document type to output directory mapping
declare -A DT_TYPE_OUTPUT_DIR=(
    ["exploration"]="explorations"
    ["research_topics"]="explorations"
    ["exploration_hub"]="explorations"
    ["research_topic"]="research"
    ["research_summary"]="research"
    ["requirements"]="research"
    ["research_hub"]="research"
    ["adr"]="decisions"
    ["decisions_summary"]="decisions"
    ["decisions_hub"]="decisions"
    ["feature_plan"]="planning/features"
    ["phase"]="planning/features"
    ["status_and_next_steps"]="planning/features"
    ["planning_hub"]="planning/features"
    ["fix_batch"]="planning/fix"
    ["handoff"]="planning"
    ["reflection"]="planning/notes"
)

# Document type to output filename mapping
declare -A DT_TYPE_OUTPUT_FILE=(
    ["exploration"]="exploration.md"
    ["research_topics"]="research-topics.md"
    ["exploration_hub"]="README.md"
    ["research_topic"]="research-{TOPIC}.md"
    ["research_summary"]="research-summary.md"
    ["requirements"]="requirements.md"
    ["research_hub"]="README.md"
    ["adr"]="adr-{ADR_NUMBER}.md"
    ["decisions_summary"]="decisions-summary.md"
    ["decisions_hub"]="README.md"
    ["feature_plan"]="feature-plan.md"
    ["phase"]="phase-{PHASE_NUMBER}.md"
    ["status_and_next_steps"]="status-and-next-steps.md"
    ["planning_hub"]="README.md"
    ["fix_batch"]="fix-batch-{BATCH_NUMBER}.md"
    ["handoff"]="handoff-{DATE}.md"
    ["reflection"]="reflection-{DATE}.md"
)

dt_get_output_dir() {
    local project_dir="$1"
    local doc_type="$2"
    local topic_name="$3"
    local explicit_output="${4:-}"
    
    # Explicit output override takes priority
    if [ -n "$explicit_output" ]; then
        echo "$explicit_output"
        return 0
    fi
    
    # Get docs root based on project structure
    local docs_root
    docs_root=$(dt_get_docs_root "$project_dir") || {
        dt_print_status "ERROR" "Could not detect project structure"
        return 1
    }
    
    # Get output subdirectory for this doc type
    local output_subdir="${DT_TYPE_OUTPUT_DIR[$doc_type]:-}"
    if [ -z "$output_subdir" ]; then
        dt_print_status "ERROR" "Unknown document type: $doc_type"
        return 1
    fi
    
    echo "$docs_root/$output_subdir/$topic_name"
}

dt_get_output_filename() {
    local doc_type="$1"
    
    local filename="${DT_TYPE_OUTPUT_FILE[$doc_type]:-}"
    if [ -z "$filename" ]; then
        filename="$doc_type.md"
    fi
    
    # Expand placeholders in filename
    filename="${filename//\{TOPIC\}/$TOPIC_NAME}"
    filename="${filename//\{ADR_NUMBER\}/$ADR_NUMBER}"
    filename="${filename//\{PHASE_NUMBER\}/$PHASE_NUMBER}"
    filename="${filename//\{BATCH_NUMBER\}/${BATCH_NUMBER:-1}}"
    filename="${filename//\{DATE\}/$DATE}"
    
    echo "$filename"
}

dt_create_output_dir() {
    local output_dir="$1"
    
    if [ ! -d "$output_dir" ]; then
        dt_print_debug "Creating directory: $output_dir"
        mkdir -p "$output_dir" || {
            dt_print_status "ERROR" "Failed to create directory: $output_dir"
            return 1
        }
    fi
    
    return 0
}
```

#### 4.3 REFACTOR - Review and clean up

- [ ] Ensure all 17 document types are mapped
- [ ] Add validation for unknown document types
- [ ] Verify tests still pass

**Checklist:**
- [ ] All output path tests pass
- [ ] Project structure detection works for admin/ and docs/maintainers/
- [ ] Filename placeholders expanded correctly

---

### Task 5: CLI Implementation

**Purpose:** Implement the main `dt-doc-gen` CLI with argument parsing and execution.

**TDD Flow:**

#### 5.1 RED - Write failing integration tests

- [ ] Write test: `dt-doc-gen --help` shows usage
- [ ] Write test: `dt-doc-gen --version` shows version
- [ ] Write test: `dt-doc-gen` with no args shows error
- [ ] Write test: `dt-doc-gen exploration topic` generates files
- [ ] Write test: `dt-doc-gen --mode setup` generates scaffolding
- [ ] Write test: `dt-doc-gen --output path` respects output override
- [ ] Verify tests fail

**Test code:**

```bash
#!/usr/bin/env bats

# Integration tests for dt-doc-gen
# Location: tests/integration/test-dt-doc-gen.bats

load '../helpers/setup'
load '../helpers/assertions'
load '../helpers/mocks'

DT_DOC_GEN="$PROJECT_ROOT/bin/dt-doc-gen"

setup() {
    # Create test environment
    TEST_DIR=$(mktemp -d)
    mkdir -p "$TEST_DIR/admin/explorations"
    mkdir -p "$TEST_DIR/admin/research"
    mkdir -p "$TEST_DIR/admin/decisions"
    mkdir -p "$TEST_DIR/admin/planning/features"
    
    # Set up mock templates
    MOCK_TEMPLATES="$TEST_DIR/templates"
    mkdir -p "$MOCK_TEMPLATES/exploration"
    mkdir -p "$MOCK_TEMPLATES/research"
    mkdir -p "$MOCK_TEMPLATES/decision"
    mkdir -p "$MOCK_TEMPLATES/planning"
    mkdir -p "$MOCK_TEMPLATES/other"
    
    # Create minimal test templates
    cat > "$MOCK_TEMPLATES/exploration/exploration.md.tmpl" << 'EOF'
# ${TOPIC_TITLE} - Exploration

**Status:** ${STATUS}
**Created:** ${DATE}

## 🎯 What We're Exploring

<!-- AI: Add exploration context -->
EOF
    
    cat > "$MOCK_TEMPLATES/exploration/research-topics.md.tmpl" << 'EOF'
# Research Topics - ${TOPIC_TITLE}

**Status:** ${STATUS}
**Created:** ${DATE}

## Topics

<!-- AI: Add research topics -->
EOF

    cat > "$MOCK_TEMPLATES/exploration/README.md.tmpl" << 'EOF'
# ${TOPIC_TITLE}

Exploration hub for ${TOPIC_NAME}.
EOF
    
    export DT_TEMPLATES_PATH="$MOCK_TEMPLATES"
}

teardown() {
    unset DT_TEMPLATES_PATH
    rm -rf "$TEST_DIR"
}

# ============================================================================
# Basic CLI Tests
# ============================================================================

@test "dt-doc-gen: shows help with --help" {
    run "$DT_DOC_GEN" --help
    [ "$status" -eq 0 ]
    [[ "$output" =~ "Usage:" ]]
    [[ "$output" =~ "dt-doc-gen" ]]
}

@test "dt-doc-gen: shows version with --version" {
    run "$DT_DOC_GEN" --version
    [ "$status" -eq 0 ]
    [[ "$output" =~ "version" ]]
}

@test "dt-doc-gen: shows error with no arguments" {
    run "$DT_DOC_GEN"
    [ "$status" -ne 0 ]
    [[ "$output" =~ "Error" ]] || [[ "$output" =~ "Usage" ]]
}

# ============================================================================
# Document Generation Tests
# ============================================================================

@test "dt-doc-gen: generates exploration documents" {
    # Skip if envsubst not available
    if ! command -v envsubst >/dev/null 2>&1; then
        skip "envsubst not installed"
    fi
    
    cd "$TEST_DIR"
    run "$DT_DOC_GEN" exploration test-topic --output "$TEST_DIR/admin/explorations/test-topic"
    [ "$status" -eq 0 ]
    
    # Check files created
    [ -f "$TEST_DIR/admin/explorations/test-topic/exploration.md" ]
}

@test "dt-doc-gen: expands variables in generated files" {
    # Skip if envsubst not available
    if ! command -v envsubst >/dev/null 2>&1; then
        skip "envsubst not installed"
    fi
    
    cd "$TEST_DIR"
    run "$DT_DOC_GEN" exploration test-topic --output "$TEST_DIR/admin/explorations/test-topic"
    [ "$status" -eq 0 ]
    
    # Check variable expansion
    local output_file="$TEST_DIR/admin/explorations/test-topic/exploration.md"
    grep -q "Test Topic" "$output_file"
    grep -q "$(date +%Y-%m-%d)" "$output_file"
}

@test "dt-doc-gen: preserves AI markers in generated files" {
    # Skip if envsubst not available
    if ! command -v envsubst >/dev/null 2>&1; then
        skip "envsubst not installed"
    fi
    
    cd "$TEST_DIR"
    run "$DT_DOC_GEN" exploration test-topic --output "$TEST_DIR/admin/explorations/test-topic"
    [ "$status" -eq 0 ]
    
    # Check AI markers preserved
    local output_file="$TEST_DIR/admin/explorations/test-topic/exploration.md"
    grep -q '<!-- AI:' "$output_file"
}

@test "dt-doc-gen: respects --output flag" {
    # Skip if envsubst not available
    if ! command -v envsubst >/dev/null 2>&1; then
        skip "envsubst not installed"
    fi
    
    local custom_output="$TEST_DIR/custom/location"
    mkdir -p "$custom_output"
    
    cd "$TEST_DIR"
    run "$DT_DOC_GEN" exploration test-topic --output "$custom_output"
    [ "$status" -eq 0 ]
    
    # Check file in custom location
    [ -f "$custom_output/exploration.md" ]
}

@test "dt-doc-gen: mode setup generates scaffolding structure" {
    # Skip if envsubst not available
    if ! command -v envsubst >/dev/null 2>&1; then
        skip "envsubst not installed"
    fi
    
    cd "$TEST_DIR"
    run "$DT_DOC_GEN" exploration test-topic --mode setup --output "$TEST_DIR/admin/explorations/test-topic"
    [ "$status" -eq 0 ]
    
    # Check all scaffolding files created
    [ -f "$TEST_DIR/admin/explorations/test-topic/exploration.md" ]
    [ -f "$TEST_DIR/admin/explorations/test-topic/research-topics.md" ]
    [ -f "$TEST_DIR/admin/explorations/test-topic/README.md" ]
}

# ============================================================================
# Error Handling Tests
# ============================================================================

@test "dt-doc-gen: errors on invalid document type" {
    cd "$TEST_DIR"
    run "$DT_DOC_GEN" invalid-type test-topic
    [ "$status" -ne 0 ]
    [[ "$output" =~ "Unknown" ]] || [[ "$output" =~ "Invalid" ]]
}

@test "dt-doc-gen: errors when templates not found" {
    unset DT_TEMPLATES_PATH
    
    cd "$TEST_DIR"
    # Create isolated environment
    export HOME="$TEST_DIR/fake-home"
    mkdir -p "$HOME"
    
    run "$DT_DOC_GEN" exploration test-topic
    [ "$status" -ne 0 ]
    [[ "$output" =~ "template" ]] || [[ "$output" =~ "not found" ]]
}
```

#### 5.2 GREEN - Implement CLI main function

- [ ] Implement argument parsing
- [ ] Implement `--help` and `--version`
- [ ] Implement document generation logic
- [ ] Implement `--mode` handling (setup/conduct)
- [ ] Implement `--output` handling
- [ ] Run tests, verify they pass

**Implementation (update bin/dt-doc-gen):**

```bash
#!/usr/bin/env bash

# ============================================================================
# DT-DOC-GEN - Generate documentation from dev-infra templates
# Usage: dt-doc-gen <type> <topic> [OPTIONS]
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
source "$TOOLKIT_ROOT/lib/doc-gen/templates.sh"
source "$TOOLKIT_ROOT/lib/doc-gen/render.sh"

# Initialize colors
dt_setup_colors

# ============================================================================
# FUNCTIONS
# ============================================================================

show_help() {
    cat << EOF
Usage: $SCRIPT_NAME <type> <topic> [OPTIONS]

Generate documentation from dev-infra templates.

Arguments:
    type              Document type (exploration, research, decision, planning)
    topic             Topic or feature name for the document

Options:
    --mode MODE       Generation mode: setup (scaffolding) or conduct (expand)
                      Default: setup
    --output PATH     Output directory (default: auto-detect from project)
    --template-path   Explicit path to templates directory
    --help            Show this help message
    --version         Show version information
    --debug           Enable debug output

Document Types:
    exploration       Exploration documents (exploration.md, research-topics.md, README.md)
    research          Research documents (research-topic.md, requirements.md, etc.)
    decision          Decision documents (adr.md, decisions-summary.md)
    planning          Planning documents (feature-plan.md, phase.md, etc.)
    handoff           Session handoff document
    fix-batch         Fix batch planning document

Examples:
    $SCRIPT_NAME exploration my-feature
    $SCRIPT_NAME research my-topic --mode setup
    $SCRIPT_NAME decision auth-system --output admin/decisions/auth/

EOF
}

show_version() {
    echo "$SCRIPT_NAME version $VERSION"
}

generate_exploration() {
    local topic_name="$1"
    local output_dir="$2"
    local mode="$3"
    local templates_root="$4"
    
    # Set variables
    dt_set_exploration_vars "$topic_name"
    
    # Create output directory
    dt_create_output_dir "$output_dir" || return 1
    
    # Generate files based on mode
    local files_to_generate=("exploration")
    if [ "$mode" = "setup" ]; then
        files_to_generate+=("research_topics" "exploration_hub")
    fi
    
    for doc_type in "${files_to_generate[@]}"; do
        local template_path
        template_path=$(dt_get_template_path "$doc_type" "$doc_type" "$templates_root")
        
        if [ ! -f "$template_path" ]; then
            dt_print_status "WARNING" "Template not found: $template_path"
            continue
        fi
        
        local output_filename
        output_filename=$(dt_get_output_filename "$doc_type")
        local output_file="$output_dir/$output_filename"
        
        dt_print_status "INFO" "Generating: $output_filename"
        dt_render_template "$template_path" "$output_file" "$doc_type" || {
            dt_print_status "ERROR" "Failed to generate: $output_filename"
            return 1
        }
    done
    
    dt_print_status "SUCCESS" "Generated exploration in: $output_dir"
}

# ============================================================================
# MAIN EXECUTION
# ============================================================================

main() {
    local doc_type=""
    local topic_name=""
    local mode="setup"
    local output_dir=""
    local template_path_override=""
    
    # Parse arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            --help)
                show_help
                exit 0
                ;;
            --version)
                show_version
                exit 0
                ;;
            --debug)
                export DT_DEBUG=true
                shift
                ;;
            --mode)
                mode="$2"
                shift 2
                ;;
            --output)
                output_dir="$2"
                shift 2
                ;;
            --template-path)
                template_path_override="$2"
                shift 2
                ;;
            -*)
                dt_print_status "ERROR" "Unknown option: $1"
                echo ""
                show_help
                exit 1
                ;;
            *)
                if [ -z "$doc_type" ]; then
                    doc_type="$1"
                elif [ -z "$topic_name" ]; then
                    topic_name="$1"
                else
                    dt_print_status "ERROR" "Unexpected argument: $1"
                    exit 1
                fi
                shift
                ;;
        esac
    done
    
    # Validate required arguments
    if [ -z "$doc_type" ]; then
        dt_print_status "ERROR" "Document type is required"
        echo ""
        show_help
        exit 1
    fi
    
    if [ -z "$topic_name" ]; then
        dt_print_status "ERROR" "Topic name is required"
        echo ""
        show_help
        exit 1
    fi
    
    # Validate mode
    if [[ "$mode" != "setup" && "$mode" != "conduct" ]]; then
        dt_print_status "ERROR" "Invalid mode: $mode (use 'setup' or 'conduct')"
        exit 1
    fi
    
    # Check envsubst availability
    dt_check_envsubst || exit 1
    
    # Find templates
    local templates_root
    templates_root=$(dt_find_templates "$template_path_override") || {
        dt_print_status "ERROR" "Could not locate templates"
        dt_print_status "INFO" "Set DT_TEMPLATES_PATH or use --template-path"
        dt_print_status "INFO" "Expected location: ~/Projects/dev-infra/scripts/doc-gen/templates"
        exit 1
    }
    
    dt_print_debug "Using templates: $templates_root"
    
    # Determine output directory if not specified
    if [ -z "$output_dir" ]; then
        output_dir=$(dt_get_output_dir "." "$doc_type" "$topic_name") || {
            dt_print_status "ERROR" "Could not determine output directory"
            dt_print_status "INFO" "Use --output to specify output directory"
            exit 1
        }
    fi
    
    dt_print_debug "Output directory: $output_dir"
    
    # Generate documents based on type
    case "$doc_type" in
        exploration)
            generate_exploration "$topic_name" "$output_dir" "$mode" "$templates_root"
            ;;
        research)
            dt_print_status "INFO" "Research generation not yet implemented"
            exit 1
            ;;
        decision)
            dt_print_status "INFO" "Decision generation not yet implemented"
            exit 1
            ;;
        planning)
            dt_print_status "INFO" "Planning generation not yet implemented"
            exit 1
            ;;
        *)
            dt_print_status "ERROR" "Unknown document type: $doc_type"
            dt_print_status "INFO" "Available types: exploration, research, decision, planning"
            exit 1
            ;;
    esac
}

main "$@"
```

#### 5.3 REFACTOR - Review and clean up

- [ ] Add remaining document type generators (research, decision, planning)
- [ ] Improve error messages with suggestions
- [ ] Add --dry-run option
- [ ] Verify tests still pass

**Checklist:**
- [ ] All CLI tests pass
- [ ] Help text is comprehensive
- [ ] Error messages are helpful
- [ ] All document types supported

---

### Task 6: Integration Testing

**Purpose:** Verify end-to-end functionality with real templates.

**Steps:**

- [ ] Write integration test: Generate exploration with real templates
- [ ] Write integration test: Generate research with real templates
- [ ] Write integration test: Output matches expected format
- [ ] Run full test suite
- [ ] Verify no regressions in existing tests

**Test commands:**

```bash
# Run dt-doc-gen tests only
./scripts/test.sh tests/unit/doc-gen/
./scripts/test.sh tests/integration/test-dt-doc-gen.bats

# Run all tests
./scripts/test.sh

# Run with verbose output
./scripts/test.sh -v tests/unit/doc-gen/
```

**Checklist:**
- [ ] All integration tests pass
- [ ] Generated documents match expected format
- [ ] AI markers preserved in output
- [ ] Variables expanded correctly
- [ ] Full test suite passes (no regressions)

---

## ✅ Completion Criteria

- [ ] `dt-doc-gen exploration my-topic` works correctly
- [ ] `dt-doc-gen --type research my-topic --mode setup` works
- [ ] Template discovery follows priority: flag → env → config → default
- [ ] Variable expansion preserves `$VAR`, `<!-- AI: -->` markers
- [ ] All 17 document types supported
- [ ] Tests passing (>80% coverage)

---

## 📦 Deliverables

- `bin/dt-doc-gen` - CLI entry point (~200-300 lines)
- `lib/doc-gen/templates.sh` - Template discovery functions (~150-200 lines)
- `lib/doc-gen/render.sh` - Variable expansion functions (~100-150 lines)
- `tests/unit/doc-gen/test-templates.bats` - Template discovery tests (~150 lines)
- `tests/unit/doc-gen/test-render.bats` - Rendering tests (~100 lines)
- `tests/integration/test-dt-doc-gen.bats` - Integration tests (~200 lines)

---

## 📊 Progress Tracking

| Task | Status | Notes |
|------|--------|-------|
| Task 1: Test Setup and CLI Scaffolding | 🔴 Not Started | |
| Task 2: Template Discovery Functions | 🔴 Not Started | |
| Task 3: Variable Expansion Functions | 🔴 Not Started | |
| Task 4: Output Path Handling | 🔴 Not Started | |
| Task 5: CLI Implementation | 🔴 Not Started | |
| Task 6: Integration Testing | 🔴 Not Started | |

---

## 🧪 Running Tests

```bash
# Run dt-doc-gen tests only
./scripts/test.sh tests/unit/doc-gen/
./scripts/test.sh tests/integration/test-dt-doc-gen.bats

# Run all tests
./scripts/test.sh

# Run with verbose output
./scripts/test.sh -v tests/unit/doc-gen/

# Test syntax only (no execution)
bash -n bin/dt-doc-gen
bash -n lib/doc-gen/templates.sh
bash -n lib/doc-gen/render.sh
```

---

## 🔗 Dependencies

### Prerequisites

- Phase 1 complete (shared infrastructure)
- dev-infra templates accessible locally
- `envsubst` available (gettext package)

### Blocks

- Command migration Sprint 1 (/explore)
- Phase 3 (dt-doc-validate) can run in parallel

---

## 🔗 Related Documents

- [Feature Hub](README.md)
- [Previous Phase: Phase 1](phase-1.md)
- [Next Phase: Phase 3](phase-3.md)
- [ADR-001: Template Location](../../../decisions/doc-infrastructure/adr-001-template-location-strategy.md)
- [ADR-003: Variable Expansion](../../../decisions/doc-infrastructure/adr-003-variable-expansion.md)
- [Research: Template Fetching](../../../research/doc-infrastructure/research-template-fetching.md)

---

## 📝 Implementation Notes

### envsubst Dependency

macOS does not include `envsubst` by default. Installation:
```bash
brew install gettext
brew link --force gettext
```

The command checks for availability and provides helpful error if missing.

### Template Structure

Templates are organized in dev-infra:
```
scripts/doc-gen/templates/
├── exploration/    # 3 templates
├── research/       # 4 templates
├── decision/       # 3 templates
├── planning/       # 4 templates
└── other/          # 3 templates
```

### Two-Mode Operation

- **Setup mode**: Generates full scaffolding structure (multiple files)
- **Conduct mode**: Generates single document for content expansion

---

**Last Updated:** 2026-01-21  
**Status:** 🟠 In Progress  
**Next:** Begin implementation with Task 1
