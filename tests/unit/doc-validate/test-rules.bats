#!/usr/bin/env bats

# Tests for dt-doc-validate rule loading
# Location: tests/unit/doc-validate/test-rules.bats
#
# Tests rule loading functions including:
# - Loading pre-compiled .bash rules
# - Rules path resolution (default and override)
# - Error handling for missing rules
# - Required sections extraction
#
# Related: admin/decisions/doc-infrastructure/adr-002-validation-rule-loading.md

load '../../helpers/setup'
load '../../helpers/assertions'

setup() {
    source "$PROJECT_ROOT/lib/core/output-utils.sh"
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
    
    # Create mock research rules
    cat > "$MOCK_RULES_DIR/research_topic.bash" << 'EOF'
# Mock research_topic rules
DT_RESEARCH_REQUIRED_SECTIONS=(
    "research_question|^## 🎯 Research Question|Missing 'Research Question' section"
)
EOF
}

teardown() {
    rm -rf "$MOCK_RULES_DIR"
    unset DT_RULES_PATH
}

# ===========================================================================
# RULE LOADING TESTS
# ===========================================================================

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
    [ "${DT_EXPLORATION_REQUIRED_SECTIONS[0]}" = "what_exploring|^## 🎯 What We're Exploring|Missing 'What We're Exploring' section" ]
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

@test "dt_get_required_sections: returns sections for exploration type" {
    dt_load_rules "exploration" "$MOCK_RULES_DIR"
    run dt_get_required_sections "exploration"
    [ "$status" -eq 0 ]
    [[ "$output" =~ "what_exploring" ]]
    [[ "$output" =~ "themes" ]]
}

@test "dt_get_required_sections: returns sections for research_topic type" {
    dt_load_rules "research_topic" "$MOCK_RULES_DIR"
    run dt_get_required_sections "research_topic"
    [ "$status" -eq 0 ]
    [[ "$output" =~ "research_question" ]]
}

@test "dt_get_required_sections: maps exploration_hub to exploration sections" {
    dt_load_rules "exploration" "$MOCK_RULES_DIR"
    run dt_get_required_sections "exploration_hub"
    [ "$status" -eq 0 ]
    [[ "$output" =~ "what_exploring" ]]
}

@test "dt_get_required_sections: returns error for unmapped type" {
    run dt_get_required_sections "unknown_type"
    [ "$status" -eq 1 ]
}
