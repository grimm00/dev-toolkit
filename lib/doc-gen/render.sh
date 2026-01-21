#!/bin/bash
# Template Rendering Functions for dt-doc-gen
# Implements selective variable expansion per ADR-003

# ============================================================================
# VARIABLE EXPANSION (per ADR-003)
# ============================================================================

# Variable lists per template type
DT_EXPLORATION_VARS='${DATE} ${STATUS} ${TOPIC_NAME} ${TOPIC_TITLE}'
DT_RESEARCH_VARS='${DATE} ${STATUS} ${TOPIC_NAME} ${QUESTION} ${QUESTION_NAME}'
DT_DECISION_VARS='${DATE} ${STATUS} ${ADR_NUMBER} ${DECISION_TITLE}'
DT_PLANNING_VARS='${DATE} ${STATUS} ${FEATURE_NAME} ${PHASE_NUMBER} ${PHASE_NAME}'
DT_OTHER_VARS='${DATE} ${STATUS} ${TOPIC_NAME}'

dt_check_envsubst() {
    if ! command -v envsubst >/dev/null 2>&1; then
        dt_print_status "ERROR" "envsubst is required but not installed"
        dt_print_status "INFO" "Install with: brew install gettext (macOS)"
        dt_print_status "INFO" "Install with: apt install gettext (Ubuntu)"
        return 1
    fi
    return 0
}

dt_get_template_vars() {
    local doc_type="$1"
    
    # Ensure templates library is sourced for DT_TYPE_CATEGORY
    if [ -z "${DT_TYPE_CATEGORY[$doc_type]:-}" ]; then
        # Try to source templates.sh if not already sourced
        if [ -z "$(type -t _dt_init_template_arrays)" ]; then
            local script_dir
            script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
            source "$script_dir/templates.sh" 2>/dev/null || true
        fi
    fi
    
    local category="${DT_TYPE_CATEGORY[$doc_type]:-other}"
    
    case "$category" in
        "exploration")
            echo "$DT_EXPLORATION_VARS"
            ;;
        "research")
            echo "$DT_RESEARCH_VARS"
            ;;
        "decision")
            echo "$DT_DECISION_VARS"
            ;;
        "planning")
            echo "$DT_PLANNING_VARS"
            ;;
        *)
            echo "$DT_OTHER_VARS"
            ;;
    esac
}

dt_render_template() {
    local template="$1"
    local output="$2"
    local doc_type="$3"
    
    # Check envsubst availability
    dt_check_envsubst || return 1
    
    # Check template exists
    if [ ! -f "$template" ]; then
        dt_print_status "ERROR" "Template not found: $template"
        return 1
    fi
    
    # Get variable list for this template type
    local vars
    vars=$(dt_get_template_vars "$doc_type")
    
    dt_print_debug "Rendering template: $template"
    dt_print_debug "Variables: $vars"
    
    # SELECTIVE expansion - only listed variables (per ADR-003)
    envsubst "$vars" < "$template" > "$output"
    
    return 0
}

dt_set_common_vars() {
    export DATE=$(date +%Y-%m-%d)
    export STATUS="🔴 Not Started"
}

dt_set_exploration_vars() {
    local topic_name="$1"
    
    dt_set_common_vars
    
    export TOPIC_NAME="$topic_name"
    # Convert kebab-case to Title Case
    export TOPIC_TITLE=$(echo "$topic_name" | sed 's/-/ /g' | awk '{for(i=1;i<=NF;i++) $i=toupper(substr($i,1,1)) tolower(substr($i,2))}1')
}

dt_set_research_vars() {
    local topic_name="$1"
    local question="${2:-}"
    
    dt_set_common_vars
    
    export TOPIC_NAME="$topic_name"
    export QUESTION="${question:-Research Question TBD}"
    export QUESTION_NAME=$(echo "$topic_name" | sed 's/-/ /g')
}

dt_set_decision_vars() {
    local adr_number="$1"
    local decision_title="$2"
    
    dt_set_common_vars
    
    export ADR_NUMBER="$adr_number"
    export DECISION_TITLE="$decision_title"
}

dt_set_planning_vars() {
    local feature_name="$1"
    local phase_number="${2:-1}"
    local phase_name="${3:-Foundation}"
    
    dt_set_common_vars
    
    export FEATURE_NAME="$feature_name"
    export PHASE_NUMBER="$phase_number"
    export PHASE_NAME="$phase_name"
}
