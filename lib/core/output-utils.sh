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

# Color variables (set by dt_setup_colors)
DT_RED=""
DT_GREEN=""
DT_YELLOW=""
DT_BLUE=""
DT_PURPLE=""
DT_CYAN=""
DT_BOLD=""
DT_NC=""

dt_setup_colors() {
    if [[ -t 1 ]] && command -v tput >/dev/null 2>&1; then
        DT_RED='\033[0;31m'
        DT_GREEN='\033[0;32m'
        DT_YELLOW='\033[1;33m'
        DT_BLUE='\033[0;34m'
        DT_PURPLE='\033[0;35m'
        DT_CYAN='\033[0;36m'
        DT_BOLD='\033[1m'
        DT_NC='\033[0m'
    else
        DT_RED=''
        DT_GREEN=''
        DT_YELLOW=''
        DT_BLUE=''
        DT_PURPLE=''
        DT_CYAN=''
        DT_BOLD=''
        DT_NC=''
    fi
}

dt_print_status() {
    local msg_type=$1
    local message=$2
    case $msg_type in
        "ERROR")   echo -e "${DT_RED}❌ $message${DT_NC}" ;;
        "WARNING") echo -e "${DT_YELLOW}⚠️  $message${DT_NC}" ;;
        "SUCCESS") echo -e "${DT_GREEN}✅ $message${DT_NC}" ;;
        "INFO")    echo -e "${DT_BLUE}ℹ️  $message${DT_NC}" ;;
    esac
}

dt_print_debug() {
    if [ "${DT_DEBUG:-false}" = "true" ]; then
        echo -e "${DT_PURPLE}[DEBUG] $1${DT_NC}"
    fi
}

dt_print_header() {
    local title=$1
    echo -e "${DT_BOLD}${DT_CYAN}$title${DT_NC}"
    echo -e "${DT_CYAN}$(printf '═%.0s' $(seq 1 ${#title}))${DT_NC}"
}

dt_show_version() {
    local version_file="${TOOLKIT_ROOT:-$(dirname "${BASH_SOURCE[0]}")/../..}/VERSION"
    if [ -f "$version_file" ]; then
        cat "$version_file"
    else
        echo "unknown"
    fi
}

# ============================================================================
# DETECTION FUNCTIONS
# ============================================================================

# (Detection functions will go here)
