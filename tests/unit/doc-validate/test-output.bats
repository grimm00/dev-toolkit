#!/usr/bin/env bats

# Tests for dt-doc-validate output formatting
# Location: tests/unit/doc-validate/test-output.bats
#
# Tests output formatting functions including:
# - Text format (default, human-readable)
# - JSON format (--json flag, machine-readable)
# - Exit code determination (0/1/2)
# - Color support with TTY detection
#
# Related: admin/decisions/doc-infrastructure/adr-004-error-output-design.md

load '../../helpers/setup'
load '../../helpers/assertions'

setup() {
    source "$PROJECT_ROOT/lib/core/output-utils.sh"
    source "$PROJECT_ROOT/lib/doc-validate/output.sh"
    source "$PROJECT_ROOT/lib/doc-validate/validation.sh"
    
    # Initialize validation state
    dt_reset_validation_results 2>/dev/null || true
}

teardown() {
    dt_reset_validation_results 2>/dev/null || true
}

# ===========================================================================
# TEXT OUTPUT TESTS
# ===========================================================================

@test "dt_format_error_text: formats error with file and fix" {
    run dt_format_error_text "MISSING_SECTION" "Missing required section" "test.md" "Add the section"
    [ "$status" -eq 0 ]
    [[ "$output" =~ "ERROR" ]] || [[ "$output" =~ "error" ]]
    [[ "$output" =~ "test.md" ]]
    [[ "$output" =~ "Fix:" ]] || [[ "$output" =~ "fix" ]]
}

@test "dt_format_error_text: formats error without fix" {
    run dt_format_error_text "MISSING_SECTION" "Missing required section" "test.md"
    [ "$status" -eq 0 ]
    [[ "$output" =~ "ERROR" ]] || [[ "$output" =~ "error" ]]
    [[ "$output" =~ "test.md" ]]
}

@test "dt_format_warning_text: formats warning" {
    run dt_format_warning_text "STALE_DATE" "Last updated is stale" "test.md" "Update date"
    [ "$status" -eq 0 ]
    [[ "$output" =~ "WARNING" ]] || [[ "$output" =~ "warning" ]]
    [[ "$output" =~ "test.md" ]]
}

@test "dt_format_warning_text: formats warning without fix" {
    run dt_format_warning_text "STALE_DATE" "Last updated is stale" "test.md"
    [ "$status" -eq 0 ]
    [[ "$output" =~ "WARNING" ]] || [[ "$output" =~ "warning" ]]
}

@test "dt_format_summary_text: shows pass/fail counts" {
    DT_VALIDATION_PASSED=3
    DT_VALIDATION_FAILED=2
    DT_VALIDATION_ERRORS=("error1" "error2")
    DT_VALIDATION_WARNINGS=("warn1")
    
    run dt_format_summary_text
    [ "$status" -eq 0 ]
    [[ "$output" =~ "5 files" ]] || [[ "$output" =~ "5" ]]
    [[ "$output" =~ "3 passed" ]] || [[ "$output" =~ "3" ]]
    [[ "$output" =~ "2 failed" ]] || [[ "$output" =~ "2" ]]
}

@test "dt_format_summary_text: shows PASSED when no failures" {
    DT_VALIDATION_PASSED=3
    DT_VALIDATION_FAILED=0
    DT_VALIDATION_ERRORS=()
    DT_VALIDATION_WARNINGS=("warn1")
    
    run dt_format_summary_text
    [ "$status" -eq 0 ]
    [[ "$output" =~ "PASSED" ]] || [[ "$output" =~ "passed" ]]
}

@test "dt_format_summary_text: shows FAILED when failures exist" {
    DT_VALIDATION_PASSED=1
    DT_VALIDATION_FAILED=2
    DT_VALIDATION_ERRORS=("error1")
    DT_VALIDATION_WARNINGS=()
    
    run dt_format_summary_text
    [ "$status" -eq 0 ]
    [[ "$output" =~ "FAILED" ]] || [[ "$output" =~ "failed" ]]
}

@test "dt_output_text: outputs all errors and warnings" {
    DT_VALIDATION_ERRORS=(
        "MISSING_SECTION|Missing section|file1.md"
        "MISSING_SECTION|Missing section|file2.md"
    )
    DT_VALIDATION_WARNINGS=(
        "STALE_DATE|Stale date|file1.md"
    )
    DT_VALIDATION_PASSED=1
    DT_VALIDATION_FAILED=2
    
    run dt_output_text
    [ "$status" -eq 0 ]
    # Should contain errors
    local error_count=$(echo "$output" | grep -c "ERROR\|error" || echo "0")
    [ "$error_count" -ge 2 ]
    # Should contain warnings
    local warning_count=$(echo "$output" | grep -c "WARNING\|warning" || echo "0")
    [ "$warning_count" -ge 1 ]
    # Should contain summary
    [[ "$output" =~ "Summary" ]] || [[ "$output" =~ "summary" ]]
}

# ===========================================================================
# JSON OUTPUT TESTS
# ===========================================================================

@test "dt_format_results_json: produces valid JSON" {
    DT_VALIDATION_PASSED=1
    DT_VALIDATION_FAILED=1
    DT_VALIDATION_ERRORS=("MISSING_SECTION|Missing section|file.md")
    DT_VALIDATION_WARNINGS=("STALE_DATE|Stale date|file.md")
    
    run dt_format_results_json
    [ "$status" -eq 0 ]
    # Validate JSON structure (basic check)
    [[ "$output" =~ '"summary":' ]]
    [[ "$output" =~ '"errors":' ]]
    [[ "$output" =~ '"warnings":' ]]
}

@test "dt_format_results_json: includes correct counts" {
    DT_VALIDATION_PASSED=3
    DT_VALIDATION_FAILED=2
    DT_VALIDATION_ERRORS=("error1" "error2")
    DT_VALIDATION_WARNINGS=("warn1")
    
    run dt_format_results_json
    [ "$status" -eq 0 ]
    [[ "$output" =~ '"total_files": 5' ]]
    [[ "$output" =~ '"passed": 3' ]]
    [[ "$output" =~ '"failed": 2' ]]
    [[ "$output" =~ '"errors": 2' ]]
    [[ "$output" =~ '"warnings": 1' ]]
}

@test "dt_format_errors_json_array: formats error array" {
    DT_VALIDATION_ERRORS=(
        "MISSING_SECTION|Missing section|file1.md"
        "MISSING_SECTION|Missing section|file2.md"
    )
    
    run dt_format_errors_json_array
    [ "$status" -eq 0 ]
    [[ "$output" =~ '"code": "MISSING_SECTION"' ]]
    [[ "$output" =~ '"file": "file1.md"' ]]
    [[ "$output" =~ '"file": "file2.md"' ]]
}

@test "dt_format_warnings_json_array: formats warning array" {
    DT_VALIDATION_WARNINGS=(
        "STALE_DATE|Stale date|file1.md"
        "STALE_DATE|Stale date|file2.md"
    )
    
    run dt_format_warnings_json_array
    [ "$status" -eq 0 ]
    [[ "$output" =~ '"code": "STALE_DATE"' ]]
    [[ "$output" =~ '"file": "file1.md"' ]]
    [[ "$output" =~ '"file": "file2.md"' ]]
}

@test "dt_format_results_json: handles empty arrays" {
    DT_VALIDATION_PASSED=2
    DT_VALIDATION_FAILED=0
    DT_VALIDATION_ERRORS=()
    DT_VALIDATION_WARNINGS=()
    
    run dt_format_results_json
    [ "$status" -eq 0 ]
    [[ "$output" =~ '"errors": \[\]' ]]
    [[ "$output" =~ '"warnings": \[\]' ]]
}

# ===========================================================================
# EXIT CODE TESTS
# ===========================================================================

@test "dt_get_exit_code: returns 0 for no errors" {
    DT_VALIDATION_ERRORS=()
    run dt_get_exit_code
    [ "$status" -eq 0 ]
    [ "$output" = "0" ]
}

@test "dt_get_exit_code: returns 1 for validation errors" {
    DT_VALIDATION_ERRORS=("MISSING_SECTION|Missing section|file.md")
    run dt_get_exit_code
    [ "$status" -eq 0 ]
    [ "$output" = "1" ]
}

@test "dt_get_exit_code: returns 0 for warnings only" {
    DT_VALIDATION_ERRORS=()
    DT_VALIDATION_WARNINGS=("STALE_DATE|Stale date|file.md")
    run dt_get_exit_code
    [ "$status" -eq 0 ]
    [ "$output" = "0" ]
}
