#!/bin/bash
# Rule Loading Functions for dt-doc-validate
# Implements pre-compiled .bash rule loading per ADR-002
#
# This library provides functions to load validation rules from pre-compiled
# .bash files. Rules are converted from YAML to bash at build-time in dev-infra,
# eliminating runtime YAML parsing dependencies.
#
# Related: admin/decisions/doc-infrastructure/adr-002-validation-rule-loading.md

# Source output utilities for dt_print_status and dt_print_debug
# Note: This assumes output-utils.sh is already sourced by the calling script
# If not, we'll handle gracefully by checking if functions exist

# ============================================================================
# RULE LOADING
# ============================================================================

dt_get_rules_path() {
    # 1. Check DT_RULES_PATH environment variable (highest priority)
    if [ -n "${DT_RULES_PATH:-}" ]; then
        echo "$DT_RULES_PATH"
        return 0
    fi
    
    # 2. Detect toolkit root from TOOLKIT_ROOT or script location
    local toolkit_root="${TOOLKIT_ROOT:-}"
    if [ -z "$toolkit_root" ]; then
        if [ -n "${BASH_SOURCE[0]:-}" ]; then
            local script_dir
            script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
            toolkit_root="${script_dir%/lib/doc-validate}"
        fi
    fi
    
    # Default path: toolkit_root/lib/validation/rules
    echo "$toolkit_root/lib/validation/rules"
}

dt_validate_rules_exist() {
    local doc_type="$1"
    local rules_path="${2:-$(dt_get_rules_path)}"
    
    [ -f "$rules_path/${doc_type}.bash" ]
}

dt_load_rules() {
    local doc_type="$1"
    local rules_path="${2:-$(dt_get_rules_path)}"
    
    local rules_file="$rules_path/${doc_type}.bash"
    
    if [ ! -f "$rules_file" ]; then
        # Use dt_print_status if available, otherwise echo
        if command -v dt_print_status >/dev/null 2>&1; then
            dt_print_status "ERROR" "No validation rules found for: $doc_type"
            dt_print_debug "Looked for: $rules_file"
        else
            echo "❌ Error: No validation rules found for: $doc_type" >&2
        fi
        return 1
    fi
    
    # Source the pre-compiled rules
    # shellcheck source=/dev/null
    source "$rules_file"
    
    # Debug output if available
    if command -v dt_print_debug >/dev/null 2>&1; then
        dt_print_debug "Loaded rules from: $rules_file"
    fi
    
    return 0
}

dt_get_required_sections() {
    local doc_type="$1"
    
    # Map doc_type to the correct array name based on category
    local array_name
    case "$doc_type" in
        exploration|research_topics|exploration_hub)
            array_name="DT_EXPLORATION_REQUIRED_SECTIONS" ;;
        research_topic|research_summary|requirements|research_hub)
            array_name="DT_RESEARCH_REQUIRED_SECTIONS" ;;
        adr|decisions_summary|decisions_hub)
            array_name="DT_DECISION_REQUIRED_SECTIONS" ;;
        feature_plan|phase|status_and_next_steps|planning_hub)
            array_name="DT_PLANNING_REQUIRED_SECTIONS" ;;
        *)
            # Try uppercase conversion for other types
            array_name="DT_${doc_type^^}_REQUIRED_SECTIONS" ;;
    esac
    
    # Use nameref to access the array (Bash 4.3+)
    # Check if array exists and has elements
    local -n sections="$array_name" 2>/dev/null || return 1
    
    # Return array contents
    if [ ${#sections[@]} -eq 0 ]; then
        return 1
    fi
    
    printf '%s\n' "${sections[@]}"
}
