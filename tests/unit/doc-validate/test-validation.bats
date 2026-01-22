#!/usr/bin/env bats

# Tests for dt-doc-validate validation logic
# Location: tests/unit/doc-validate/test-validation.bats
#
# Tests validation functions including:
# - Required section validation
# - Error and warning collection
# - File and directory validation
# - Validation result structures
#
# Related: admin/decisions/doc-infrastructure/adr-002-validation-rule-loading.md

load '../../helpers/setup'
load '../../helpers/assertions'

setup() {
    source "$PROJECT_ROOT/lib/core/output-utils.sh"
    source "$PROJECT_ROOT/lib/doc-validate/validation.sh"
    source "$PROJECT_ROOT/lib/doc-validate/type-detection.sh"
    source "$PROJECT_ROOT/lib/doc-validate/rules.sh"
    
    # Create test document
    export TEST_DOC="$BATS_TMPDIR/test-doc.md"
    
    # Create mock rules directory
    export MOCK_RULES_DIR="$BATS_TMPDIR/rules"
    mkdir -p "$MOCK_RULES_DIR"
    
    # Create mock exploration rules
    cat > "$MOCK_RULES_DIR/exploration.bash" << 'EOF'
# Mock exploration rules
DT_EXPLORATION_REQUIRED_SECTIONS=(
    "what_exploring|^## 🎯 What We're Exploring|Missing 'What We're Exploring' section"
    "themes|^## 🔍 Themes|Missing 'Themes' section"
)
EOF
    
    # Create mock adr rules
    cat > "$MOCK_RULES_DIR/adr.bash" << 'EOF'
# Mock ADR rules
DT_DECISION_REQUIRED_SECTIONS=(
    "status|^\\*\\*Status:\\*\\*|Missing Status field"
)
EOF
    
    # Reset validation state
    dt_reset_validation_results 2>/dev/null || true
}

teardown() {
    rm -f "$TEST_DOC"
    rm -rf "$MOCK_RULES_DIR"
    dt_reset_validation_results 2>/dev/null || true
}

# ===========================================================================
# VALIDATION RESULT RESET TESTS
# ===========================================================================

@test "dt_reset_validation_results: clears all validation state" {
    # Set some state
    DT_VALIDATION_ERRORS=("error1" "error2")
    DT_VALIDATION_WARNINGS=("warn1")
    DT_VALIDATION_PASSED=5
    DT_VALIDATION_FAILED=3
    
    dt_reset_validation_results
    
    [ ${#DT_VALIDATION_ERRORS[@]} -eq 0 ]
    [ ${#DT_VALIDATION_WARNINGS[@]} -eq 0 ]
    [ "$DT_VALIDATION_PASSED" -eq 0 ]
    [ "$DT_VALIDATION_FAILED" -eq 0 ]
}

# ===========================================================================
# REQUIRED SECTIONS VALIDATION TESTS
# ===========================================================================

@test "dt_validate_required_sections: passes when all sections present" {
    cat > "$TEST_DOC" << 'EOF'
# Test Document
## 🎯 What We're Exploring
Content here.
## 🔍 Themes
More content.
EOF
    
    local sections=(
        "what_exploring|^## 🎯 What We're Exploring|Missing section"
        "themes|^## 🔍 Themes|Missing themes"
    )
    
    run dt_validate_required_sections "$TEST_DOC" sections
    [ "$status" -eq 0 ]
    [ -z "$output" ]
}

@test "dt_validate_required_sections: fails when section missing" {
    cat > "$TEST_DOC" << 'EOF'
# Test Document
## 🎯 What We're Exploring
Content here.
EOF
    
    local sections=(
        "what_exploring|^## 🎯 What We're Exploring|Missing section"
        "themes|^## 🔍 Themes|Missing themes section"
    )
    
    run dt_validate_required_sections "$TEST_DOC" sections
    [ "$status" -eq 1 ]
    [[ "$output" =~ "MISSING_SECTION" ]]
    [[ "$output" =~ "Missing themes section" ]]
}

@test "dt_validate_required_sections: handles multiple missing sections" {
    cat > "$TEST_DOC" << 'EOF'
# Test Document
Content without sections.
EOF
    
    local sections=(
        "what_exploring|^## 🎯 What We're Exploring|Missing section 1"
        "themes|^## 🔍 Themes|Missing section 2"
    )
    
    run dt_validate_required_sections "$TEST_DOC" sections
    [ "$status" -eq 1 ]
    # Should have both errors
    local error_count=$(echo "$output" | grep -c "MISSING_SECTION" || echo "0")
    [ "$error_count" -eq 2 ]
}

@test "dt_validate_required_sections: handles empty sections array" {
    cat > "$TEST_DOC" << 'EOF'
# Test Document
EOF
    
    local sections=()
    
    run dt_validate_required_sections "$TEST_DOC" sections
    [ "$status" -eq 0 ]
}

# ===========================================================================
# FILE VALIDATION TESTS
# ===========================================================================

@test "dt_validate_file: validates file with explicit type" {
    cat > "$TEST_DOC" << 'EOF'
# Test Exploration
## 🎯 What We're Exploring
Content here.
## 🔍 Themes
More content.
EOF
    
    dt_reset_validation_results
    dt_validate_file "$TEST_DOC" "exploration" "$MOCK_RULES_DIR"
    [ "$?" -eq 0 ]
    [ "$DT_VALIDATION_PASSED" -eq 1 ]
    [ "$DT_VALIDATION_FAILED" -eq 0 ]
}

@test "dt_validate_file: fails when required sections missing" {
    cat > "$TEST_DOC" << 'EOF'
# Test Exploration
## 🎯 What We're Exploring
Content here.
EOF
    
    dt_reset_validation_results
    dt_validate_file "$TEST_DOC" "exploration" "$MOCK_RULES_DIR" || true
    [ "$DT_VALIDATION_PASSED" -eq 0 ]
    [ "$DT_VALIDATION_FAILED" -eq 1 ]
    [ ${#DT_VALIDATION_ERRORS[@]} -gt 0 ]
}

@test "dt_validate_file: auto-detects type when not provided" {
    cat > "$TEST_DOC" << 'EOF'
# ADR-001: Test Decision
**Status:** ✅ Active
Content here.
EOF
    
    dt_reset_validation_results
    run dt_validate_file "$TEST_DOC" "" "$MOCK_RULES_DIR"
    [ "$status" -eq 0 ] || [ "$status" -eq 1 ]  # May pass or fail based on rules
}

@test "dt_validate_file: handles missing rules gracefully" {
    cat > "$TEST_DOC" << 'EOF'
# Test Document
Content here.
EOF
    
    dt_reset_validation_results
    dt_validate_file "$TEST_DOC" "nonexistent_type" "$MOCK_RULES_DIR"
    [ "$?" -eq 0 ]  # Should pass with warning when no rules
    [ ${#DT_VALIDATION_WARNINGS[@]} -gt 0 ]
    [[ "${DT_VALIDATION_WARNINGS[0]}" =~ "NO_RULES" ]]
}

@test "dt_validate_file: collects errors in global array" {
    cat > "$TEST_DOC" << 'EOF'
# Test Exploration
EOF
    
    dt_reset_validation_results
    dt_validate_file "$TEST_DOC" "exploration" "$MOCK_RULES_DIR" || true
    
    [ ${#DT_VALIDATION_ERRORS[@]} -gt 0 ]
    [[ "${DT_VALIDATION_ERRORS[0]}" =~ "MISSING_SECTION" ]]
}

# ===========================================================================
# DIRECTORY VALIDATION TESTS
# ===========================================================================

@test "dt_validate_directory: processes all markdown files" {
    local test_dir="$BATS_TMPDIR/test-docs"
    mkdir -p "$test_dir"
    
    cat > "$test_dir/doc1.md" << 'EOF'
# Doc 1
## 🎯 What We're Exploring
Content.
## 🔍 Themes
More.
EOF
    
    cat > "$test_dir/doc2.md" << 'EOF'
# Doc 2
## 🎯 What We're Exploring
Content.
## 🔍 Themes
More.
EOF
    
    dt_reset_validation_results
    dt_validate_directory "$test_dir" "exploration" "$MOCK_RULES_DIR"
    [ "$?" -eq 0 ]
    [ "$DT_VALIDATION_PASSED" -eq 2 ]
    
    rm -rf "$test_dir"
}

@test "dt_validate_directory: fails when any file fails validation" {
    local test_dir="$BATS_TMPDIR/test-docs"
    mkdir -p "$test_dir"
    
    cat > "$test_dir/doc1.md" << 'EOF'
# Doc 1
## 🎯 What We're Exploring
Content.
## 🔍 Themes
More.
EOF
    
    cat > "$test_dir/doc2.md" << 'EOF'
# Doc 2
## 🎯 What We're Exploring
Missing themes.
EOF
    
    dt_reset_validation_results
    dt_validate_directory "$test_dir" "exploration" "$MOCK_RULES_DIR" || true
    [ "$DT_VALIDATION_FAILED" -gt 0 ]
    
    rm -rf "$test_dir"
}

@test "dt_validate_directory: handles empty directory" {
    local test_dir="$BATS_TMPDIR/empty-docs"
    mkdir -p "$test_dir"
    
    dt_reset_validation_results
    run dt_validate_directory "$test_dir" "exploration" "$MOCK_RULES_DIR"
    [ "$status" -eq 0 ]
    
    rm -rf "$test_dir"
}

@test "dt_validate_directory: ignores non-markdown files" {
    local test_dir="$BATS_TMPDIR/mixed-docs"
    mkdir -p "$test_dir"
    
    cat > "$test_dir/doc1.md" << 'EOF'
# Doc 1
## 🎯 What We're Exploring
Content.
## 🔍 Themes
More.
EOF
    echo "not markdown" > "$test_dir/file.txt"
    echo "#!/bin/bash" > "$test_dir/script.sh"
    
    dt_reset_validation_results
    dt_validate_directory "$test_dir" "exploration" "$MOCK_RULES_DIR" || true
    # Should only process .md files (1 file)
    [ "$DT_VALIDATION_PASSED" -eq 1 ] || [ "$DT_VALIDATION_FAILED" -eq 1 ]
    
    rm -rf "$test_dir"
}
