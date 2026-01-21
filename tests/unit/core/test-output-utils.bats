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
