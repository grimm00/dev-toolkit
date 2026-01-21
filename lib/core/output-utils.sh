#!/bin/bash
# Doc Infrastructure Shared Utilities
# Provides common functions for dt-doc-gen and dt-doc-validate
# Uses dt_* prefix to avoid conflicts with other dev-toolkit functions

# ============================================================================
# XDG BASE DIRECTORY COMPLIANCE
# ============================================================================

dt_get_xdg_config_home() {
    echo "${XDG_CONFIG_HOME:-$HOME/.config}"
}

dt_get_xdg_data_home() {
    echo "${XDG_DATA_HOME:-$HOME/.local/share}"
}

dt_get_config_dir() {
    echo "$(dt_get_xdg_config_home)/dev-toolkit"
}

dt_get_data_dir() {
    echo "$(dt_get_xdg_data_home)/dev-toolkit"
}

dt_get_config_file() {
    echo "$(dt_get_config_dir)/config"
}

# ============================================================================
# COLOR AND OUTPUT SETUP
# ============================================================================

# (Output functions will go here)

# ============================================================================
# DETECTION FUNCTIONS
# ============================================================================

# (Detection functions will go here)
