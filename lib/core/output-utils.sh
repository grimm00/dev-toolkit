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

dt_detect_dev_infra() {
    # 1. Environment variable (highest priority)
    if [ -n "${DEV_INFRA_PATH:-}" ] && [ -d "$DEV_INFRA_PATH" ]; then
        echo "$DEV_INFRA_PATH"
        return 0
    fi
    
    # 2. Sibling directory (common development setup)
    local script_dir
    if [ -n "${BASH_SOURCE[0]:-}" ]; then
        script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    else
        script_dir="$(pwd)"
    fi
    
    # Look for dev-infra as sibling to dev-toolkit
    local toolkit_root="${script_dir%/lib/core}"
    local sibling_path="${toolkit_root%/*}/dev-infra"
    if [ -d "$sibling_path" ]; then
        echo "$sibling_path"
        return 0
    fi
    
    # 3. Common default locations
    local default_paths=(
        "$HOME/Projects/dev-infra"
        "$HOME/.dev-infra"
    )
    
    for path in "${default_paths[@]}"; do
        if [ -d "$path" ]; then
            echo "$path"
            return 0
        fi
    done
    
    # Not found
    return 1
}

dt_detect_project_structure() {
    local current_dir="${1:-.}"
    
    # Priority: admin/ first for backward compatibility
    if [ -d "$current_dir/admin/explorations" ] || \
       [ -d "$current_dir/admin/research" ] || \
       [ -d "$current_dir/admin/decisions" ] || \
       [ -d "$current_dir/admin/planning" ]; then
        echo "admin"
        return 0
    fi
    
    # Then check docs/maintainers/ (newer structure)
    if [ -d "$current_dir/docs/maintainers/explorations" ] || \
       [ -d "$current_dir/docs/maintainers/research" ] || \
       [ -d "$current_dir/docs/maintainers/decisions" ] || \
       [ -d "$current_dir/docs/maintainers/planning" ]; then
        echo "docs/maintainers"
        return 0
    fi
    
    echo "unknown"
    return 0
}

dt_get_docs_root() {
    local project_dir="${1:-.}"
    local structure
    structure=$(dt_detect_project_structure "$project_dir")
    
    case "$structure" in
        "admin")
            echo "$project_dir/admin"
            ;;
        "docs/maintainers")
            echo "$project_dir/docs/maintainers"
            ;;
        *)
            echo ""
            return 1
            ;;
    esac
}
