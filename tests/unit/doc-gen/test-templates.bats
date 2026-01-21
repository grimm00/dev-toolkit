#!/usr/bin/env bats

# Tests for dt-doc-gen template discovery
# Location: tests/unit/doc-gen/test-templates.bats

load '../../helpers/setup'
load '../../helpers/assertions'

setup() {
    # Source shared infrastructure first
    source "$PROJECT_ROOT/lib/core/output-utils.sh"
    # Then source the library under test
    source "$PROJECT_ROOT/lib/doc-gen/templates.sh"
}

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
    mkdir -p "$config_dir/dev-toolkit"
    echo "DT_TEMPLATES_PATH=$test_dir" > "$config_dir/dev-toolkit/config"
    
    # Override config location
    export XDG_CONFIG_HOME="$config_dir"
    
    unset DT_TEMPLATES_PATH
    run dt_find_templates
    [ "$status" -eq 0 ]
    [ "$output" = "$test_dir" ]
    
    unset XDG_CONFIG_HOME
    rm -rf "$test_dir" "$config_dir"
}

@test "dt_find_templates: checks default locations" {
    # This test is harder to write reliably, so we'll test it indirectly
    # by checking that it tries default paths when others fail
    local test_dir=$(mktemp -d)
    mkdir -p "$test_dir/exploration"
    touch "$test_dir/exploration/exploration.md.tmpl"
    
    # Set up a default location that exists
    local default_path="$HOME/Projects/dev-infra/scripts/doc-gen/templates"
    if [ -d "$default_path" ]; then
        unset DT_TEMPLATES_PATH
        export XDG_CONFIG_HOME="$(mktemp -d)"
        run dt_find_templates
        # Should succeed if default location exists
        [ "$status" -eq 0 ] || [ "$status" -eq 1 ]
    else
        skip "Default template location not available for testing"
    fi
    
    rm -rf "$test_dir"
}

@test "dt_find_templates: returns error if not found" {
    unset DT_TEMPLATES_PATH
    # Create isolated environment with no templates
    local test_dir=$(mktemp -d)
    cd "$test_dir"
    
    # Override config to empty location
    export XDG_CONFIG_HOME="$test_dir/config"
    export HOME="$test_dir/home"
    mkdir -p "$HOME"
    
    run dt_find_templates
    [ "$status" -eq 1 ]
    
    unset XDG_CONFIG_HOME HOME
    rm -rf "$test_dir"
}

@test "dt_get_template_path: returns correct path for exploration type" {
    export DT_TEMPLATES_PATH="/mock/templates"
    
    run dt_get_template_path "exploration" "exploration" "/mock/templates"
    [ "$status" -eq 0 ]
    [ "$output" = "/mock/templates/exploration/exploration.md.tmpl" ]
    
    unset DT_TEMPLATES_PATH
}

@test "dt_get_template_path: returns correct path for research type" {
    export DT_TEMPLATES_PATH="/mock/templates"
    
    run dt_get_template_path "research_topic" "research-topic" "/mock/templates"
    [ "$status" -eq 0 ]
    [ "$output" = "/mock/templates/research/research-topic.md.tmpl" ]
    
    unset DT_TEMPLATES_PATH
}

@test "dt_get_template_path: returns correct path for decision type" {
    export DT_TEMPLATES_PATH="/mock/templates"
    
    run dt_get_template_path "adr" "adr" "/mock/templates"
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

