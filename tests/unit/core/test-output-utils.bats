#!/usr/bin/env bats

# Tests for output-utils.sh shared library

load '../../helpers/setup'
load '../../helpers/assertions'

setup() {
    source "$PROJECT_ROOT/lib/core/output-utils.sh"
}

# ============================================================================
# XDG Helper Tests
# ============================================================================

@test "dt_get_xdg_config_home: returns XDG_CONFIG_HOME if set" {
    export XDG_CONFIG_HOME="/custom/config"
    run dt_get_xdg_config_home
    [ "$status" -eq 0 ]
    [ "$output" = "/custom/config" ]
}

@test "dt_get_xdg_config_home: returns ~/.config if XDG_CONFIG_HOME not set" {
    unset XDG_CONFIG_HOME
    run dt_get_xdg_config_home
    [ "$status" -eq 0 ]
    [ "$output" = "$HOME/.config" ]
}

@test "dt_get_xdg_data_home: returns XDG_DATA_HOME if set" {
    export XDG_DATA_HOME="/custom/data"
    run dt_get_xdg_data_home
    [ "$status" -eq 0 ]
    [ "$output" = "/custom/data" ]
}

@test "dt_get_xdg_data_home: returns ~/.local/share if XDG_DATA_HOME not set" {
    unset XDG_DATA_HOME
    run dt_get_xdg_data_home
    [ "$status" -eq 0 ]
    [ "$output" = "$HOME/.local/share" ]
}

@test "dt_get_config_dir: returns dev-toolkit config directory" {
    unset XDG_CONFIG_HOME
    run dt_get_config_dir
    [ "$status" -eq 0 ]
    [ "$output" = "$HOME/.config/dev-toolkit" ]
}

@test "dt_get_data_dir: returns dev-toolkit data directory" {
    unset XDG_DATA_HOME
    run dt_get_data_dir
    [ "$status" -eq 0 ]
    [ "$output" = "$HOME/.local/share/dev-toolkit" ]
}

@test "dt_get_config_file: returns config file path" {
    unset XDG_CONFIG_HOME
    run dt_get_config_file
    [ "$status" -eq 0 ]
    [ "$output" = "$HOME/.config/dev-toolkit/config" ]
}

# ============================================================================
# Color Setup Tests
# ============================================================================

@test "dt_setup_colors: sets color variables" {
    # Reset any existing colors
    DT_RED=""
    DT_GREEN=""
    dt_setup_colors
    # Colors should be set (either with codes or empty for non-TTY)
    [ -n "${DT_NC+x}" ]  # Variable exists (may be empty)
}

# ============================================================================
# Print Status Tests
# ============================================================================

@test "dt_print_status: ERROR includes error emoji and message" {
    dt_setup_colors
    run dt_print_status "ERROR" "Test error message"
    [ "$status" -eq 0 ]
    [[ "$output" =~ "❌" ]]
    [[ "$output" =~ "Test error message" ]]
}

@test "dt_print_status: WARNING includes warning emoji and message" {
    dt_setup_colors
    run dt_print_status "WARNING" "Test warning"
    [ "$status" -eq 0 ]
    [[ "$output" =~ "⚠️" ]]
    [[ "$output" =~ "Test warning" ]]
}

@test "dt_print_status: SUCCESS includes success emoji and message" {
    dt_setup_colors
    run dt_print_status "SUCCESS" "Test success"
    [ "$status" -eq 0 ]
    [[ "$output" =~ "✅" ]]
    [[ "$output" =~ "Test success" ]]
}

@test "dt_print_status: INFO includes info emoji and message" {
    dt_setup_colors
    run dt_print_status "INFO" "Test info"
    [ "$status" -eq 0 ]
    [[ "$output" =~ "ℹ️" ]]
    [[ "$output" =~ "Test info" ]]
}

@test "dt_print_status: unknown type returns error and shows UNKNOWN prefix" {
    dt_setup_colors
    run dt_print_status "INVALID" "Test message"
    [ "$status" -eq 1 ]
    [[ "$output" =~ "UNKNOWN:INVALID" ]]
    [[ "$output" =~ "Test message" ]]
}

# ============================================================================
# Debug Output Tests
# ============================================================================

@test "dt_print_debug: outputs when DT_DEBUG=true" {
    export DT_DEBUG=true
    dt_setup_colors
    run dt_print_debug "Debug message"
    [ "$status" -eq 0 ]
    [[ "$output" =~ "Debug message" ]]
}

@test "dt_print_debug: silent when DT_DEBUG not set" {
    unset DT_DEBUG
    dt_setup_colors
    run dt_print_debug "Debug message"
    [ "$status" -eq 0 ]
    [ -z "$output" ]
}

# ============================================================================
# Print Header Tests
# ============================================================================

@test "dt_print_header: outputs header with title" {
    dt_setup_colors
    run dt_print_header "Test Header"
    [ "$status" -eq 0 ]
    [[ "$output" =~ "Test Header" ]]
}

# ============================================================================
# dev-infra Detection Tests
# ============================================================================

@test "dt_detect_dev_infra: returns path when DEV_INFRA_PATH set" {
    local test_dir=$(mktemp -d)
    mkdir -p "$test_dir"
    export DEV_INFRA_PATH="$test_dir"
    run dt_detect_dev_infra
    [ "$status" -eq 0 ]
    [ "$output" = "$test_dir" ]
    rm -rf "$test_dir"
    unset DEV_INFRA_PATH
}

@test "dt_detect_dev_infra: returns error when not found" {
    unset DEV_INFRA_PATH
    # Create temp dir with no dev-infra sibling and not in Projects
    local test_dir=$(mktemp -d)
    # Temporarily change HOME to isolate from real dev-infra
    local old_home="$HOME"
    export HOME="$test_dir"
    cd "$test_dir"
    run dt_detect_dev_infra
    [ "$status" -eq 1 ]
    export HOME="$old_home"
    rm -rf "$test_dir"
}

# ============================================================================
# Project Structure Detection Tests
# ============================================================================

@test "dt_detect_project_structure: returns 'admin' when admin/ exists" {
    local test_dir=$(mktemp -d)
    mkdir -p "$test_dir/admin/explorations"
    run dt_detect_project_structure "$test_dir"
    [ "$status" -eq 0 ]
    [ "$output" = "admin" ]
    rm -rf "$test_dir"
}

@test "dt_detect_project_structure: returns 'docs/maintainers' when that exists" {
    local test_dir=$(mktemp -d)
    mkdir -p "$test_dir/docs/maintainers/explorations"
    run dt_detect_project_structure "$test_dir"
    [ "$status" -eq 0 ]
    [ "$output" = "docs/maintainers" ]
    rm -rf "$test_dir"
}

@test "dt_detect_project_structure: prioritizes 'admin' over 'docs/maintainers'" {
    local test_dir=$(mktemp -d)
    mkdir -p "$test_dir/admin/explorations"
    mkdir -p "$test_dir/docs/maintainers/explorations"
    run dt_detect_project_structure "$test_dir"
    [ "$status" -eq 0 ]
    [ "$output" = "admin" ]
    rm -rf "$test_dir"
}

@test "dt_detect_project_structure: returns 'unknown' when neither exists" {
    local test_dir=$(mktemp -d)
    run dt_detect_project_structure "$test_dir"
    [ "$status" -eq 0 ]
    [ "$output" = "unknown" ]
    rm -rf "$test_dir"
}

@test "dt_get_docs_root: returns 'admin' path for admin structure" {
    local test_dir=$(mktemp -d)
    mkdir -p "$test_dir/admin/explorations"
    run dt_get_docs_root "$test_dir"
    [ "$status" -eq 0 ]
    [ "$output" = "$test_dir/admin" ]
    rm -rf "$test_dir"
}

@test "dt_get_docs_root: returns 'docs/maintainers' path for that structure" {
    local test_dir=$(mktemp -d)
    mkdir -p "$test_dir/docs/maintainers/explorations"
    run dt_get_docs_root "$test_dir"
    [ "$status" -eq 0 ]
    [ "$output" = "$test_dir/docs/maintainers" ]
    rm -rf "$test_dir"
}

# ============================================================================
# Integration Tests
# ============================================================================

@test "output-utils.sh: sources without errors" {
    run source "$PROJECT_ROOT/lib/core/output-utils.sh"
    [ "$status" -eq 0 ]
}

@test "output-utils.sh: all dt_* functions are defined" {
    source "$PROJECT_ROOT/lib/core/output-utils.sh"
    
    # XDG helpers
    [ "$(type -t dt_get_xdg_config_home)" = "function" ]
    [ "$(type -t dt_get_xdg_data_home)" = "function" ]
    [ "$(type -t dt_get_config_dir)" = "function" ]
    [ "$(type -t dt_get_data_dir)" = "function" ]
    [ "$(type -t dt_get_config_file)" = "function" ]
    
    # Output functions
    [ "$(type -t dt_setup_colors)" = "function" ]
    [ "$(type -t dt_print_status)" = "function" ]
    [ "$(type -t dt_print_debug)" = "function" ]
    [ "$(type -t dt_print_header)" = "function" ]
    [ "$(type -t dt_show_version)" = "function" ]
    
    # Detection functions
    [ "$(type -t dt_detect_dev_infra)" = "function" ]
    [ "$(type -t dt_detect_project_structure)" = "function" ]
    [ "$(type -t dt_get_docs_root)" = "function" ]
}

@test "dt_show_version: outputs version from VERSION file" {
    run dt_show_version
    [ "$status" -eq 0 ]
    [[ "$output" =~ ^[0-9]+\.[0-9]+\.[0-9]+ ]]
}
