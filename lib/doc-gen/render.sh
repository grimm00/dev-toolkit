#!/bin/bash
# Template Rendering Functions for dt-doc-gen
# Implements selective variable expansion per ADR-003

# ============================================================================
# VARIABLE EXPANSION (per ADR-003)
# ============================================================================

# Variable lists per template type
# Each list includes variables used in templates for that category
# PURPOSE is universal - brief description of the document's purpose
DT_EXPLORATION_VARS='${DATE} ${STATUS} ${TOPIC_NAME} ${TOPIC_TITLE} ${PURPOSE}'
DT_RESEARCH_VARS='${DATE} ${STATUS} ${TOPIC_NAME} ${TOPIC_TITLE} ${QUESTION} ${QUESTION_NAME} ${PURPOSE} ${TOPIC_COUNT} ${DOC_COUNT}'
DT_DECISION_VARS='${DATE} ${STATUS} ${TOPIC_NAME} ${TOPIC_TITLE} ${ADR_NUMBER} ${DECISION_TITLE} ${PURPOSE} ${DECISION_COUNT} ${BATCH_NUMBER}'
DT_PLANNING_VARS='${DATE} ${STATUS} ${FEATURE_NAME} ${PHASE_NUMBER} ${PHASE_NAME} ${PURPOSE}'
DT_OTHER_VARS='${DATE} ${STATUS} ${TOPIC_NAME} ${PURPOSE}'

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
        # Use exit status directly to avoid set -e issues with type in subshell
        if ! type _dt_init_template_arrays >/dev/null 2>&1; then
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
    export PURPOSE="${PURPOSE:-[Purpose TBD]}"
}

dt_set_exploration_vars() {
    local topic_name="$1"
    local purpose="${2:-Exploration of $topic_name}"
    
    dt_set_common_vars
    
    export TOPIC_NAME="$topic_name"
    # Convert kebab-case to Title Case
    export TOPIC_TITLE=$(echo "$topic_name" | sed 's/-/ /g' | awk '{for(i=1;i<=NF;i++) $i=toupper(substr($i,1,1)) tolower(substr($i,2))}1')
    export PURPOSE="$purpose"
}

dt_set_research_vars() {
    local topic_name="$1"
    local question="${2:-}"
    local purpose="${3:-Research for $topic_name}"
    local topic_count="${4:-0}"
    local doc_count="${5:-0}"
    
    dt_set_common_vars
    
    export TOPIC_NAME="$topic_name"
    # Convert kebab-case to Title Case
    export TOPIC_TITLE=$(echo "$topic_name" | sed 's/-/ /g' | awk '{for(i=1;i<=NF;i++) $i=toupper(substr($i,1,1)) tolower(substr($i,2))}1')
    export QUESTION="${question:-Research Question TBD}"
    export QUESTION_NAME=$(echo "$topic_name" | sed 's/-/ /g')
    export PURPOSE="$purpose"
    export TOPIC_COUNT="$topic_count"
    export DOC_COUNT="$doc_count"
}

dt_set_decision_vars() {
    local topic_name="$1"
    local adr_number="$2"
    local decision_title="$3"
    local purpose="${4:-Decisions for $topic_name}"
    local decision_count="${5:-0}"
    local batch_number="${6:-1}"
    
    dt_set_common_vars
    
    export TOPIC_NAME="$topic_name"
    # Convert kebab-case to Title Case
    export TOPIC_TITLE=$(echo "$topic_name" | sed 's/-/ /g' | awk '{for(i=1;i<=NF;i++) $i=toupper(substr($i,1,1)) tolower(substr($i,2))}1')
    export ADR_NUMBER="$adr_number"
    export DECISION_TITLE="$decision_title"
    export PURPOSE="$purpose"
    export DECISION_COUNT="$decision_count"
    export BATCH_NUMBER="$batch_number"
}

dt_set_planning_vars() {
    local feature_name="$1"
    local phase_number="${2:-1}"
    local phase_name="${3:-Foundation}"
    local purpose="${4:-Planning for $feature_name}"
    
    dt_set_common_vars
    
    export FEATURE_NAME="$feature_name"
    export PHASE_NUMBER="$phase_number"
    export PHASE_NAME="$phase_name"
    export PURPOSE="$purpose"
}
