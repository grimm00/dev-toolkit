#!/bin/bash
# Validation Functions for dt-doc-validate
# Applies loaded rules to document content
#
# This library provides functions to validate documents against loaded rules.
# It checks required sections, patterns, and other validation criteria,
# collecting errors and warnings for output.
#
# Related: admin/decisions/doc-infrastructure/adr-002-validation-rule-loading.md

# Source dependencies (if not already sourced)
# Note: These assume the calling script has already sourced type-detection.sh and rules.sh

# ============================================================================
# VALIDATION RESULTS
# ============================================================================

# Global arrays to collect validation results
# Use declare -g to ensure global scope (important for bats tests)
declare -ga DT_VALIDATION_ERRORS=()
declare -ga DT_VALIDATION_WARNINGS=()
declare -gi DT_VALIDATION_PASSED=0
declare -gi DT_VALIDATION_FAILED=0

dt_reset_validation_results() {
    DT_VALIDATION_ERRORS=()
    DT_VALIDATION_WARNINGS=()
    DT_VALIDATION_PASSED=0
    DT_VALIDATION_FAILED=0
}

# ============================================================================
# VALIDATION FUNCTIONS
# ============================================================================

dt_validate_required_sections() {
    local file="$1"
    local -n section_rules="$2"
    local errors=()
    
    # Check each required section rule
    for rule in "${section_rules[@]}"; do
        # Parse rule: id|pattern|message
        IFS='|' read -r id pattern message <<< "$rule"
        
        # Check if pattern matches in file
        if ! grep -qE "$pattern" "$file" 2>/dev/null; then
            errors+=("MISSING_SECTION|$message|$file")
        fi
    done
    
    # Return errors if any found
    if [ ${#errors[@]} -gt 0 ]; then
        printf '%s\n' "${errors[@]}"
        return 1
    fi
    
    return 0
}

dt_validate_file() {
    local file="$1"
    local doc_type="${2:-}"
    local rules_path="${3:-}"
    
    # Auto-detect type if not provided
    if [ -z "$doc_type" ]; then
        if ! command -v dt_detect_document_type >/dev/null 2>&1; then
            DT_VALIDATION_ERRORS+=("TYPE_DETECTION_FAILED|Could not determine document type (dt_detect_document_type not available)|$file")
            ((DT_VALIDATION_FAILED++))
            return 1
        fi
        
        doc_type=$(dt_detect_document_type "$file") || {
            DT_VALIDATION_ERRORS+=("TYPE_DETECTION_FAILED|Could not determine document type|$file")
            ((DT_VALIDATION_FAILED++))
            return 1
        }
    fi
    
    # Load rules for this type
    if ! command -v dt_load_rules >/dev/null 2>&1; then
        DT_VALIDATION_WARNINGS+=("NO_RULES|Rule loading function not available|$file")
        ((DT_VALIDATION_PASSED++))  # No rules = pass with warning
        return 0
    fi
    
    if ! dt_load_rules "$doc_type" "$rules_path" 2>/dev/null; then
        DT_VALIDATION_WARNINGS+=("NO_RULES|No validation rules for type: $doc_type|$file")
        DT_VALIDATION_PASSED=$((DT_VALIDATION_PASSED + 1))  # No rules = pass with warning
        return 0
    fi
    
    # Get required sections for this type
    if ! command -v dt_get_required_sections >/dev/null 2>&1; then
        DT_VALIDATION_WARNINGS+=("NO_RULES|Required sections function not available|$file")
        DT_VALIDATION_PASSED=$((DT_VALIDATION_PASSED + 1))
        return 0
    fi
    
    local -a required_sections
    # Get required sections - handle both success and failure cases
    if ! mapfile -t required_sections < <(dt_get_required_sections "$doc_type" 2>/dev/null); then
        # Function failed or returned no sections
        DT_VALIDATION_WARNINGS+=("NO_RULES|Could not get required sections for type: $doc_type|$file")
        DT_VALIDATION_PASSED=$((DT_VALIDATION_PASSED + 1))
        return 0
    fi
    
    # If no sections found, pass (no rules to validate against)
    if [ ${#required_sections[@]} -eq 0 ]; then
        DT_VALIDATION_PASSED=$((DT_VALIDATION_PASSED + 1))
        return 0
    fi
    
    # Validate required sections
    local section_errors
    if section_errors=$(dt_validate_required_sections "$file" required_sections 2>&1); then
        DT_VALIDATION_PASSED=$((DT_VALIDATION_PASSED + 1))
        return 0
    else
        # Collect errors
        while IFS= read -r error; do
            [ -n "$error" ] && DT_VALIDATION_ERRORS+=("$error")
        done <<< "$section_errors"
        DT_VALIDATION_FAILED=$((DT_VALIDATION_FAILED + 1))
        return 1
    fi
}

dt_validate_directory() {
    local dir="$1"
    local doc_type="${2:-}"  # Optional type override for all files
    local rules_path="${3:-}"
    
    local exit_code=0
    
    # Find all markdown files and validate each
    while IFS= read -r -d '' file; do
        if ! dt_validate_file "$file" "$doc_type" "$rules_path"; then
            exit_code=1
        fi
    done < <(find "$dir" -name "*.md" -type f -print0 2>/dev/null)
    
    return $exit_code
}
