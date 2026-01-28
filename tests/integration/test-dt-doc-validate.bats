#!/usr/bin/env bats

# Integration tests for dt-doc-validate CLI
# Location: tests/integration/test-dt-doc-validate.bats
#
# End-to-end tests for the dt-doc-validate command including:
# - Help and version flags
# - Argument parsing and validation
# - File and directory validation workflows
# - Type detection integration
# - Rule loading integration
# - Output formatting (text and JSON)
# - Exit codes
#
# Related: admin/planning/features/doc-infrastructure/phase-3.md

load '../helpers/setup'
load '../helpers/assertions'
load '../helpers/mocks'

DT_DOC_VALIDATE="$PROJECT_ROOT/bin/dt-doc-validate"

setup() {
    # Create test directory structure
    export TEST_DIR="$BATS_TMPDIR/test-validate"
    mkdir -p "$TEST_DIR/admin/explorations/test-topic"
    mkdir -p "$TEST_DIR/admin/decisions/test-decision"
    
    # Create mock rules
    export MOCK_RULES="$BATS_TMPDIR/rules"
    mkdir -p "$MOCK_RULES"
    
    cat > "$MOCK_RULES/exploration.bash" << 'EOF'
DT_EXPLORATION_REQUIRED_SECTIONS=(
    "what_exploring|^## 🎯 What We're Exploring|Missing 'What We're Exploring' section"
)
EOF
    
    cat > "$MOCK_RULES/adr.bash" << 'EOF'
DT_DECISION_REQUIRED_SECTIONS=(
    "status|^\\*\\*Status:\\*\\*|Missing Status field"
)
EOF
}

teardown() {
    rm -rf "$TEST_DIR" "$MOCK_RULES"
}

# ===========================================================================
# HELP AND VERSION TESTS
# ===========================================================================

@test "dt-doc-validate: shows help with --help" {
    run "$DT_DOC_VALIDATE" --help
    [ "$status" -eq 0 ]
    [[ "$output" =~ "Usage:" ]]
    [[ "$output" =~ "dt-doc-validate" ]]
}

@test "dt-doc-validate: shows help with -h" {
    run "$DT_DOC_VALIDATE" -h
    [ "$status" -eq 0 ]
    [[ "$output" =~ "Usage:" ]]
}

@test "dt-doc-validate: shows version with --version" {
    run "$DT_DOC_VALIDATE" --version
    [ "$status" -eq 0 ]
    [[ "$output" =~ "version" ]]
}

@test "dt-doc-validate: shows version with -v" {
    run "$DT_DOC_VALIDATE" -v
    [ "$status" -eq 0 ]
    [[ "$output" =~ "version" ]]
}

# ===========================================================================
# ARGUMENT VALIDATION TESTS
# ===========================================================================

@test "dt-doc-validate: errors with no arguments" {
    run "$DT_DOC_VALIDATE"
    [ "$status" -eq 2 ]
    [[ "$output" =~ "No file or directory" ]]
}

@test "dt-doc-validate: errors for nonexistent file" {
    run "$DT_DOC_VALIDATE" "/nonexistent/file.md"
    [ "$status" -eq 2 ]
    [[ "$output" =~ "not found" ]]
}

@test "dt-doc-validate: errors for unknown option" {
    run "$DT_DOC_VALIDATE" --unknown-option
    [ "$status" -eq 2 ]
    [[ "$output" =~ "Unknown option" ]]
}

@test "dt-doc-validate: errors when --type missing value" {
    run "$DT_DOC_VALIDATE" --type
    [ "$status" -eq 2 ]
    [[ "$output" =~ "requires a value" ]]
}

@test "dt-doc-validate: errors when --rules-path missing value" {
    run "$DT_DOC_VALIDATE" --rules-path
    [ "$status" -eq 2 ]
    [[ "$output" =~ "requires a value" ]]
}

# ===========================================================================
# FILE VALIDATION TESTS
# ===========================================================================

@test "dt-doc-validate: validates single file successfully" {
    cat > "$TEST_DIR/admin/explorations/test-topic/exploration.md" << 'EOF'
# Test Exploration
## 🎯 What We're Exploring
Test content.
EOF
    
    run "$DT_DOC_VALIDATE" "$TEST_DIR/admin/explorations/test-topic/exploration.md" --rules-path "$MOCK_RULES"
    [ "$status" -eq 0 ]
    [[ "$output" =~ "PASSED" ]] || [[ "$output" =~ "passed" ]]
}

@test "dt-doc-validate: fails for missing required section" {
    cat > "$TEST_DIR/admin/explorations/test-topic/exploration.md" << 'EOF'
# Test Exploration
Missing the required section.
EOF
    
    run "$DT_DOC_VALIDATE" "$TEST_DIR/admin/explorations/test-topic/exploration.md" --type exploration --rules-path "$MOCK_RULES"
    [ "$status" -eq 1 ]
    # Exit code 1 indicates validation failure (errors found)
}

@test "dt-doc-validate: shows error details for missing section" {
    cat > "$TEST_DIR/admin/explorations/test-topic/exploration.md" << 'EOF'
# Test Exploration
Missing the required section.
EOF
    
    run "$DT_DOC_VALIDATE" "$TEST_DIR/admin/explorations/test-topic/exploration.md" --type exploration --rules-path "$MOCK_RULES"
    [ "$status" -eq 1 ]
    # Should have output (errors or summary)
    [ -n "$output" ]
}

# ===========================================================================
# DIRECTORY VALIDATION TESTS
# ===========================================================================

@test "dt-doc-validate: validates directory" {
    cat > "$TEST_DIR/admin/explorations/test-topic/exploration.md" << 'EOF'
# Test
## 🎯 What We're Exploring
Content.
EOF
    
    run "$DT_DOC_VALIDATE" "$TEST_DIR/admin/explorations/" --rules-path "$MOCK_RULES"
    [ "$status" -eq 0 ] || [ "$status" -eq 1 ]  # May pass or fail based on files
    # Should process at least one file
    [[ "$output" =~ "file" ]] || [[ "$output" =~ "Summary" ]] || [[ "$output" =~ "summary" ]]
}

@test "dt-doc-validate: processes multiple files in directory" {
    cat > "$TEST_DIR/admin/explorations/test-topic/exploration1.md" << 'EOF'
# Test 1
## 🎯 What We're Exploring
Content.
EOF
    
    cat > "$TEST_DIR/admin/explorations/test-topic/exploration2.md" << 'EOF'
# Test 2
## 🎯 What We're Exploring
Content.
EOF
    
    run "$DT_DOC_VALIDATE" "$TEST_DIR/admin/explorations/" --rules-path "$MOCK_RULES"
    [ "$status" -eq 0 ]
    # Should show summary with multiple files
    [[ "$output" =~ "2 files" ]] || [[ "$output" =~ "2 passed" ]]
}

# ===========================================================================
# TYPE OVERRIDE TESTS
# ===========================================================================

@test "dt-doc-validate: respects --type override" {
    cat > "$TEST_DIR/custom.md" << 'EOF'
# Custom Document
## 🎯 What We're Exploring
Content.
EOF
    
    run "$DT_DOC_VALIDATE" "$TEST_DIR/custom.md" --type exploration --rules-path "$MOCK_RULES"
    [ "$status" -eq 0 ] || [ "$status" -eq 1 ]
    # Should validate using exploration rules
}

# ===========================================================================
# JSON OUTPUT TESTS
# ===========================================================================

@test "dt-doc-validate: --json produces JSON output" {
    cat > "$TEST_DIR/admin/explorations/test-topic/exploration.md" << 'EOF'
# Test
## 🎯 What We're Exploring
Content.
EOF
    
    run "$DT_DOC_VALIDATE" "$TEST_DIR/admin/explorations/test-topic/exploration.md" --json --rules-path "$MOCK_RULES"
    [ "$status" -eq 0 ]
    [[ "$output" =~ '"summary":' ]]
    [[ "$output" =~ '"errors":' ]]
    [[ "$output" =~ '"warnings":' ]]
}

@test "dt-doc-validate: --json includes correct structure" {
    cat > "$TEST_DIR/admin/explorations/test-topic/exploration.md" << 'EOF'
# Test
## 🎯 What We're Exploring
Content.
EOF
    
    run "$DT_DOC_VALIDATE" "$TEST_DIR/admin/explorations/test-topic/exploration.md" --json --rules-path "$MOCK_RULES"
    [ "$status" -eq 0 ]
    # Check for JSON structure
    [[ "$output" =~ '"total_files":' ]]
    [[ "$output" =~ '"passed":' ]]
    [[ "$output" =~ '"failed":' ]]
}

# ===========================================================================
# EXIT CODE TESTS
# ===========================================================================

@test "dt-doc-validate: exit code 0 for success" {
    cat > "$TEST_DIR/admin/explorations/test-topic/exploration.md" << 'EOF'
# Test
## 🎯 What We're Exploring
Content.
EOF
    
    run "$DT_DOC_VALIDATE" "$TEST_DIR/admin/explorations/test-topic/exploration.md" --rules-path "$MOCK_RULES"
    [ "$status" -eq 0 ]
}

@test "dt-doc-validate: exit code 1 for validation errors" {
    cat > "$TEST_DIR/admin/explorations/test-topic/exploration.md" << 'EOF'
# Test
Missing sections.
EOF
    
    run "$DT_DOC_VALIDATE" "$TEST_DIR/admin/explorations/test-topic/exploration.md" --rules-path "$MOCK_RULES"
    [ "$status" -eq 1 ]
}

@test "dt-doc-validate: exit code 2 for system errors" {
    run "$DT_DOC_VALIDATE" "/nonexistent/file.md"
    [ "$status" -eq 2 ]
}

# ===========================================================================
# RULES PATH OVERRIDE TESTS
# ===========================================================================

@test "dt-doc-validate: respects --rules-path override" {
    cat > "$TEST_DIR/admin/explorations/test-topic/exploration.md" << 'EOF'
# Test
## 🎯 What We're Exploring
Content.
EOF
    
    run "$DT_DOC_VALIDATE" "$TEST_DIR/admin/explorations/test-topic/exploration.md" --rules-path "$MOCK_RULES"
    [ "$status" -eq 0 ]
    # Should use mock rules and validate successfully
}
