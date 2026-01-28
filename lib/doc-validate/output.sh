#!/bin/bash
# Output Functions for dt-doc-validate
# Implements text and JSON output per ADR-004
#
# This library provides functions to format validation results in both
# human-readable text format (default) and machine-readable JSON format
# (--json flag). Also handles exit code determination.
#
# Related: admin/decisions/doc-infrastructure/adr-004-error-output-design.md

# Source validation functions to access global arrays
# Note: This assumes validation.sh is already sourced by the calling script

# ============================================================================
# COLOR SETUP
# ============================================================================

dt_setup_validation_colors() {
    if [[ -t 1 ]] && command -v tput >/dev/null 2>&1; then
        DT_RED='\033[0;31m'
        DT_YELLOW='\033[1;33m'
        DT_GREEN='\033[0;32m'
        DT_NC='\033[0m'
    else
        DT_RED=''
        DT_YELLOW=''
        DT_GREEN=''
        DT_NC=''
    fi
}

# ============================================================================
# TEXT OUTPUT
# ============================================================================

dt_format_error_text() {
    local code="$1"
    local message="$2"
    local file="$3"
    local fix="${4:-}"
    
    echo -e "${DT_RED}[ERROR]${DT_NC} $message"
    echo "  File: $file"
    if [ -n "$fix" ]; then
        echo "  Fix:  $fix"
    fi
    echo ""
}

dt_format_warning_text() {
    local code="$1"
    local message="$2"
    local file="$3"
    local fix="${4:-}"
    
    echo -e "${DT_YELLOW}[WARNING]${DT_NC} $message"
    echo "  File: $file"
    if [ -n "$fix" ]; then
        echo "  Fix:  $fix"
    fi
    echo ""
}

dt_format_summary_text() {
    local total=$((DT_VALIDATION_PASSED + DT_VALIDATION_FAILED))
    local error_count=${#DT_VALIDATION_ERRORS[@]}
    local warning_count=${#DT_VALIDATION_WARNINGS[@]}
    
    echo "Summary: $total files, $DT_VALIDATION_PASSED passed, $DT_VALIDATION_FAILED failed ($error_count errors, $warning_count warnings)"
    
    if [ "$DT_VALIDATION_FAILED" -eq 0 ]; then
        echo -e "Result: ${DT_GREEN}PASSED${DT_NC}"
    else
        echo -e "Result: ${DT_RED}FAILED${DT_NC}"
    fi
}

dt_output_text() {
    dt_setup_validation_colors
    
    # Output errors
    for error in "${DT_VALIDATION_ERRORS[@]}"; do
        IFS='|' read -r code message file <<< "$error"
        dt_format_error_text "$code" "$message" "$file" ""
    done
    
    # Output warnings
    for warning in "${DT_VALIDATION_WARNINGS[@]}"; do
        IFS='|' read -r code message file <<< "$warning"
        dt_format_warning_text "$code" "$message" "$file" ""
    done
    
    # Output summary
    dt_format_summary_text
}

# ============================================================================
# JSON OUTPUT
# ============================================================================

dt_format_errors_json_array() {
    local first=true
    for error in "${DT_VALIDATION_ERRORS[@]}"; do
        IFS='|' read -r code message file <<< "$error"
        if [ "$first" = true ]; then
            first=false
        else
            echo ","
        fi
        # Escape JSON special characters in message
        local escaped_message
        escaped_message=$(printf '%s' "$message" | sed 's/\\/\\\\/g' | sed 's/"/\\"/g')
        printf '    {"code": "%s", "message": "%s", "file": "%s"}' "$code" "$escaped_message" "$file"
    done
}

dt_format_warnings_json_array() {
    local first=true
    for warning in "${DT_VALIDATION_WARNINGS[@]}"; do
        IFS='|' read -r code message file <<< "$warning"
        if [ "$first" = true ]; then
            first=false
        else
            echo ","
        fi
        # Escape JSON special characters in message
        local escaped_message
        escaped_message=$(printf '%s' "$message" | sed 's/\\/\\\\/g' | sed 's/"/\\"/g')
        printf '    {"code": "%s", "message": "%s", "file": "%s"}' "$code" "$escaped_message" "$file"
    done
}

dt_format_results_json() {
    local total=$((DT_VALIDATION_PASSED + DT_VALIDATION_FAILED))
    local error_count=${#DT_VALIDATION_ERRORS[@]}
    local warning_count=${#DT_VALIDATION_WARNINGS[@]}
    
    local errors_json
    local warnings_json
    
    if [ ${#DT_VALIDATION_ERRORS[@]} -eq 0 ]; then
        errors_json="[]"
    else
        errors_json="[
$(dt_format_errors_json_array)
  ]"
    fi
    
    if [ ${#DT_VALIDATION_WARNINGS[@]} -eq 0 ]; then
        warnings_json="[]"
    else
        warnings_json="[
$(dt_format_warnings_json_array)
  ]"
    fi
    
    cat << EOF
{
  "summary": {
    "total_files": $total,
    "passed": $DT_VALIDATION_PASSED,
    "failed": $DT_VALIDATION_FAILED,
    "errors": $error_count,
    "warnings": $warning_count
  },
  "errors": $errors_json,
  "warnings": $warnings_json
}
EOF
}

# ============================================================================
# EXIT CODES
# ============================================================================

dt_get_exit_code() {
    if [ ${#DT_VALIDATION_ERRORS[@]} -gt 0 ]; then
        echo "1"  # Validation errors
    else
        echo "0"  # Success (warnings OK)
    fi
}
