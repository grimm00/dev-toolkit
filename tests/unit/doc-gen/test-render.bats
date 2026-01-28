#!/usr/bin/env bats

# Tests for dt-doc-gen variable expansion
# Location: tests/unit/doc-gen/test-render.bats

load '../../helpers/setup'
load '../../helpers/assertions'

setup() {
    # Source shared infrastructure first
    source "$PROJECT_ROOT/lib/core/output-utils.sh"
    # Source templates library (needed for DT_TYPE_CATEGORY)
    source "$PROJECT_ROOT/lib/doc-gen/templates.sh"
    # Then source the library under test
    source "$PROJECT_ROOT/lib/doc-gen/render.sh"
}

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

@test "dt_check_envsubst: returns error with message if missing" {
    # Temporarily remove envsubst from PATH
    local original_path="$PATH"
    export PATH="/usr/bin:/bin"
    
    # Only test if envsubst is actually missing
    if ! command -v envsubst >/dev/null 2>&1; then
        run dt_check_envsubst
        [ "$status" -eq 1 ]
        [[ "$output" =~ "envsubst is required" ]]
        [[ "$output" =~ "brew install gettext" ]] || [[ "$output" =~ "apt install gettext" ]]
    else
        skip "envsubst is available in minimal PATH"
    fi
    
    export PATH="$original_path"
}

@test "dt_get_template_vars: returns correct vars for exploration" {
    run dt_get_template_vars "exploration"
    [ "$status" -eq 0 ]
    # Check that output contains required variables (using grep for literal match)
    echo "$output" | grep -q '\${DATE}' || false
    echo "$output" | grep -q '\${STATUS}' || false
    echo "$output" | grep -q '\${TOPIC_NAME}' || false
    echo "$output" | grep -q '\${TOPIC_TITLE}' || false
}

@test "dt_get_template_vars: returns correct vars for research" {
    run dt_get_template_vars "research_topic"
    [ "$status" -eq 0 ]
    echo "$output" | grep -q '\${DATE}' || false
    echo "$output" | grep -q '\${QUESTION}' || false
    echo "$output" | grep -q '\${QUESTION_NAME}' || false
}

@test "dt_get_template_vars: returns correct vars for decision" {
    run dt_get_template_vars "adr"
    [ "$status" -eq 0 ]
    echo "$output" | grep -q '\${DATE}' || false
    echo "$output" | grep -q '\${ADR_NUMBER}' || false
    echo "$output" | grep -q '\${DECISION_TITLE}' || false
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
    
    unset DATE STATUS
}

@test "dt_set_exploration_vars: sets exploration-specific variables" {
    dt_set_exploration_vars "my-topic"
    
    [ "$TOPIC_NAME" = "my-topic" ]
    [ -n "$TOPIC_TITLE" ]
    
    unset TOPIC_NAME TOPIC_TITLE DATE STATUS
}
