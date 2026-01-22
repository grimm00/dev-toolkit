#!/bin/bash
# Template Discovery Functions for dt-doc-gen
# Implements layered template discovery per ADR-001

# ============================================================================
# TEMPLATE DISCOVERY
# ============================================================================

# Initialize arrays (call this function to ensure arrays are set up)
_dt_init_template_arrays() {
    # Document type to template category mapping
    declare -gA DT_TYPE_CATEGORY
    DT_TYPE_CATEGORY=(
        ["exploration"]="exploration"
        ["research_topics"]="exploration"
        ["exploration_hub"]="exploration"
        ["research_topic"]="research"
        ["research_summary"]="research"
        ["requirements"]="research"
        ["research_hub"]="research"
        ["adr"]="decision"
        ["decisions_summary"]="decision"
        ["decisions_hub"]="decision"
        ["feature_plan"]="planning"
        ["phase"]="planning"
        ["status_and_next_steps"]="planning"
        ["planning_hub"]="planning"
        ["fix_batch"]="other"
        ["handoff"]="other"
        ["reflection"]="other"
    )

    # Document type to template filename mapping
    declare -gA DT_TYPE_TEMPLATE
    DT_TYPE_TEMPLATE=(
        ["exploration"]="exploration.md.tmpl"
        ["research_topics"]="research-topics.md.tmpl"
        ["exploration_hub"]="README.md.tmpl"
        ["research_topic"]="research-topic.md.tmpl"
        ["research_summary"]="research-summary.md.tmpl"
        ["requirements"]="requirements.md.tmpl"
        ["research_hub"]="README.md.tmpl"
        ["adr"]="adr.md.tmpl"
        ["decisions_summary"]="decisions-summary.md.tmpl"
        ["decisions_hub"]="README.md.tmpl"
        ["feature_plan"]="feature-plan.md.tmpl"
        ["phase"]="phase.md.tmpl"
        ["status_and_next_steps"]="status-and-next-steps.md.tmpl"
        ["planning_hub"]="README.md.tmpl"
        ["fix_batch"]="fix-batch.md.tmpl"
        ["handoff"]="handoff.md.tmpl"
        ["reflection"]="reflection.md.tmpl"
    )
}

# Initialize arrays when script is sourced
_dt_init_template_arrays

dt_find_templates() {
    local explicit_path="${1:-}"
    
    # 1. Explicit path (highest priority)
    if [ -n "$explicit_path" ] && [ -d "$explicit_path" ]; then
        echo "$explicit_path"
        return 0
    fi
    
    # 2. Environment variable
    if [ -n "${DT_TEMPLATES_PATH:-}" ] && [ -d "$DT_TEMPLATES_PATH" ]; then
        echo "$DT_TEMPLATES_PATH"
        return 0
    fi
    
    # 3. Config file (XDG-compliant)
    local config_file
    config_file=$(dt_get_config_file)
    if [ -f "$config_file" ]; then
        local config_path
        config_path=$(grep "^DT_TEMPLATES_PATH=" "$config_file" 2>/dev/null | cut -d= -f2)
        if [ -n "$config_path" ] && [ -d "$config_path" ]; then
            echo "$config_path"
            return 0
        fi
    fi
    
    # 3b. Legacy config path (backward compatibility)
    local legacy_config="$HOME/.dev-toolkit/config.conf"
    if [ -f "$legacy_config" ]; then
        local config_path
        config_path=$(grep "^DT_TEMPLATES_PATH=" "$legacy_config" 2>/dev/null | cut -d= -f2)
        if [ -n "$config_path" ] && [ -d "$config_path" ]; then
            dt_print_status "WARNING" "Using legacy config at $legacy_config"
            dt_print_status "INFO" "Consider migrating to $(dt_get_config_file)"
            echo "$config_path"
            return 0
        fi
    fi
    
    # 4. Default locations
    local default_paths=(
        "$HOME/Projects/dev-infra/scripts/doc-gen/templates"
        "$HOME/dev-infra/scripts/doc-gen/templates"
    )
    
    # Also check sibling to dev-toolkit
    if [ -n "${TOOLKIT_ROOT:-}" ]; then
        local sibling="${TOOLKIT_ROOT%/*}/dev-infra/scripts/doc-gen/templates"
        default_paths=("$sibling" "${default_paths[@]}")
    fi
    
    for path in "${default_paths[@]}"; do
        if [ -d "$path" ]; then
            echo "$path"
            return 0
        fi
    done
    
    # 5. Not found - error
    return 1
}

dt_get_template_path() {
    local doc_type="$1"
    local template_name="${2:-$doc_type}"
    local templates_root="${3:-}"
    
    # Ensure arrays are initialized
    _dt_init_template_arrays
    
    # Get templates root if not provided
    if [ -z "$templates_root" ]; then
        templates_root=$(dt_find_templates) || return 1
    fi
    
    # Get category for this doc type
    local category="${DT_TYPE_CATEGORY[$doc_type]:-}"
    if [ -z "$category" ]; then
        # Fall back to template_name as category
        category="$doc_type"
    fi
    
    # Get template filename
    local template_file="${DT_TYPE_TEMPLATE[$template_name]:-${template_name}.md.tmpl}"
    
    echo "$templates_root/$category/$template_file"
}

dt_validate_templates_dir() {
    local templates_dir="$1"
    
    if [ ! -d "$templates_dir" ]; then
        return 1
    fi
    
    # Check for required category directories
    local required_dirs=("exploration" "research" "decision" "planning" "other")
    local missing=()
    
    for dir in "${required_dirs[@]}"; do
        if [ ! -d "$templates_dir/$dir" ]; then
            missing+=("$dir")
        fi
    done
    
    if [ ${#missing[@]} -gt 0 ]; then
        dt_print_debug "Missing template directories: ${missing[*]}"
        return 1
    fi
    
    return 0
}

dt_list_document_types() {
    local category="${1:-}"
    
    # Ensure arrays are initialized
    _dt_init_template_arrays
    
    if [ -n "$category" ]; then
        # List types for specific category
        for type in "${!DT_TYPE_CATEGORY[@]}"; do
            if [ "${DT_TYPE_CATEGORY[$type]}" = "$category" ]; then
                echo "$type"
            fi
        done
    else
        # List all types
        for type in "${!DT_TYPE_CATEGORY[@]}"; do
            echo "$type"
        done | sort
    fi
}

# ============================================================================
# OUTPUT PATH HANDLING
# ============================================================================

# Document type to output directory mapping
declare -gA DT_TYPE_OUTPUT_DIR
DT_TYPE_OUTPUT_DIR=(
    ["exploration"]="explorations"
    ["research_topics"]="explorations"
    ["exploration_hub"]="explorations"
    ["research_topic"]="research"
    ["research_summary"]="research"
    ["requirements"]="research"
    ["research_hub"]="research"
    ["adr"]="decisions"
    ["decisions_summary"]="decisions"
    ["decisions_hub"]="decisions"
    ["feature_plan"]="planning/features"
    ["phase"]="planning/features"
    ["status_and_next_steps"]="planning/features"
    ["planning_hub"]="planning/features"
    ["fix_batch"]="planning/fix"
    ["handoff"]="planning"
    ["reflection"]="planning/notes"
)

# Document type to output filename mapping
declare -gA DT_TYPE_OUTPUT_FILE
DT_TYPE_OUTPUT_FILE=(
    ["exploration"]="exploration.md"
    ["research_topics"]="research-topics.md"
    ["exploration_hub"]="README.md"
    ["research_topic"]="research-\${TOPIC_NAME}.md"
    ["research_summary"]="research-summary.md"
    ["requirements"]="requirements.md"
    ["research_hub"]="README.md"
    ["adr"]="adr-\${ADR_NUMBER}.md"
    ["decisions_summary"]="decisions-summary.md"
    ["decisions_hub"]="README.md"
    ["feature_plan"]="feature-plan.md"
    ["phase"]="phase-\${PHASE_NUMBER}.md"
    ["status_and_next_steps"]="status-and-next-steps.md"
    ["planning_hub"]="README.md"
    ["fix_batch"]="fix-batch-\${BATCH_NUMBER}.md"
    ["handoff"]="handoff-\${DATE}.md"
    ["reflection"]="reflection-\${DATE}.md"
)

# Initialize output path arrays
_dt_init_output_arrays() {
    # Arrays already declared above with declare -gA
    # This function exists for consistency with template arrays
    :
}

# Initialize when script is sourced
_dt_init_output_arrays

dt_get_output_dir() {
    local project_dir="$1"
    local doc_type="$2"
    local topic_name="$3"
    local explicit_output="${4:-}"
    
    # Explicit output override takes priority
    if [ -n "$explicit_output" ]; then
        echo "$explicit_output"
        return 0
    fi
    
    # Get docs root based on project structure
    local docs_root
    docs_root=$(dt_get_docs_root "$project_dir") || {
        dt_print_status "ERROR" "Could not detect project structure"
        return 1
    }
    
    # Get output subdirectory for this doc type
    local output_subdir="${DT_TYPE_OUTPUT_DIR[$doc_type]:-}"
    if [ -z "$output_subdir" ]; then
        dt_print_status "ERROR" "Unknown document type: $doc_type"
        return 1
    fi
    
    echo "$docs_root/$output_subdir/$topic_name"
}

dt_get_output_filename() {
    local doc_type="$1"
    
    # Ensure arrays are initialized
    _dt_init_output_arrays
    
    local filename="${DT_TYPE_OUTPUT_FILE[$doc_type]:-}"
    if [ -z "$filename" ]; then
        filename="$doc_type.md"
    fi
    
    # Expand placeholders in filename using environment variables
    # Use envsubst to expand ${VAR} patterns safely (avoids shell injection risk)
    local expanded_filename
    if command -v envsubst >/dev/null 2>&1; then
        expanded_filename=$(printf '%s\n' "$filename" | envsubst)
    else
        # Fallback: return raw filename if envsubst not available
        expanded_filename="$filename"
    fi
    
    echo "$expanded_filename"
}

dt_create_output_dir() {
    local output_dir="$1"
    
    if [ ! -d "$output_dir" ]; then
        dt_print_debug "Creating directory: $output_dir"
        mkdir -p "$output_dir" || {
            dt_print_status "ERROR" "Failed to create directory: $output_dir"
            return 1
        }
    fi
    
    return 0
}
