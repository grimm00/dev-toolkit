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
