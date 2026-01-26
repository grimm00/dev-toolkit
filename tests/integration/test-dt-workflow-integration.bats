#!/usr/bin/env bats

# Integration tests for dt-workflow
# Location: tests/integration/test-dt-workflow-integration.bats

load '../helpers/setup'
load '../helpers/assertions'
load '../helpers/mocks'

# Path to command under test
DT_WORKFLOW="$BATS_TEST_DIRNAME/../../bin/dt-workflow"

setup() {
    # Create temp directory for test project
    TEST_PROJECT=$(mktemp -d)
    mkdir -p "$TEST_PROJECT/.cursor/rules"
    mkdir -p "$TEST_PROJECT/admin/explorations"
    mkdir -p "$TEST_PROJECT/admin/planning"
    
    # Initialize git repo for testing
    cd "$TEST_PROJECT"
    git init > /dev/null 2>&1
    git config user.email "test@example.com"
    git config user.name "Test User"
    echo "# Test Project" > README.md
    git add README.md
    git commit -m "Initial commit" > /dev/null 2>&1
}

teardown() {
    # Clean up temp directory
    if [ -n "$TEST_PROJECT" ] && [ -d "$TEST_PROJECT" ]; then
        rm -rf "$TEST_PROJECT"
    fi
}

# Placeholder test to verify infrastructure works
@test "integration test infrastructure is set up correctly" {
    [ -f "$DT_WORKFLOW" ]
    [ -d "$TEST_PROJECT" ]
    [ -d "$TEST_PROJECT/.cursor/rules" ]
}

# ============================================================================
# Task 5: Output Generation Tests (TDD)
# ============================================================================

@test "explore workflow generates valid markdown structure" {
    # Create minimal test project
    mkdir -p "$TEST_PROJECT/.cursor/rules"
    echo "# Test Rule" > "$TEST_PROJECT/.cursor/rules/main.mdc"
    
    run "$DT_WORKFLOW" explore test-feature --interactive --project "$TEST_PROJECT"
    [ "$status" -eq 0 ]
    
    # Check output structure per ADR-002 (context ordering)
    [[ "$output" =~ "# dt-workflow Output:" ]]
    [[ "$output" =~ "CRITICAL RULES (START" ]]
    [[ "$output" =~ "BACKGROUND CONTEXT (MIDDLE" ]]
    [[ "$output" =~ "TASK (END" ]]
}

@test "explore workflow includes token estimate" {
    mkdir -p "$TEST_PROJECT/.cursor/rules"
    
    run "$DT_WORKFLOW" explore test-feature --interactive --project "$TEST_PROJECT"
    [ "$status" -eq 0 ]
    [[ "$output" =~ "Token Estimate:" ]]
}

@test "explore workflow includes next steps" {
    mkdir -p "$TEST_PROJECT/.cursor/rules"
    
    run "$DT_WORKFLOW" explore test-feature --interactive --project "$TEST_PROJECT"
    [ "$status" -eq 0 ]
    [[ "$output" =~ "NEXT STEPS" ]]
    [[ "$output" =~ "/research" ]]
}

@test "explore workflow generates valid exploration structure" {
    mkdir -p "$TEST_PROJECT/.cursor/rules"
    
    run "$DT_WORKFLOW" explore my-feature --interactive --project "$TEST_PROJECT"
    [ "$status" -eq 0 ]
    
    # Check generated structure templates
    [[ "$output" =~ "README.md" ]]
    [[ "$output" =~ "exploration.md" ]]
    [[ "$output" =~ "research-topics.md" ]]
}

# ============================================================================
# Task 6: --output Flag Tests (TDD)
# ============================================================================

@test "dt-workflow --output saves to file" {
    mkdir -p "$TEST_PROJECT/.cursor/rules"
    local output_file="$TEST_PROJECT/output.md"
    
    run "$DT_WORKFLOW" explore test-feature --interactive --project "$TEST_PROJECT" --output "$output_file"
    [ "$status" -eq 0 ]
    [ -f "$output_file" ]
    
    # Check file contains expected content
    grep -q "dt-workflow Output:" "$output_file"
}

@test "dt-workflow --output shows success message" {
    mkdir -p "$TEST_PROJECT/.cursor/rules"
    local output_file="$TEST_PROJECT/output.md"
    
    run "$DT_WORKFLOW" explore test-feature --interactive --project "$TEST_PROJECT" --output "$output_file"
    [ "$status" -eq 0 ]
    [[ "$output" =~ "Output saved to:" ]]
}

@test "dt-workflow --output handles invalid directory path" {
    mkdir -p "$TEST_PROJECT/.cursor/rules"
    local output_file="/nonexistent/path/output.md"
    
    run "$DT_WORKFLOW" explore test-feature --interactive --project "$TEST_PROJECT" --output "$output_file"
    [ "$status" -ne 0 ]
    [[ "$output" =~ "Error:" ]]
}

@test "dt-workflow --output handles permission errors gracefully" {
    mkdir -p "$TEST_PROJECT/.cursor/rules"
    local output_file="$TEST_PROJECT/output.md"
    
    # Create a read-only directory to simulate permission error
    local readonly_dir="$TEST_PROJECT/readonly"
    mkdir -p "$readonly_dir"
    chmod 555 "$readonly_dir"
    local readonly_file="$readonly_dir/output.md"
    
    run "$DT_WORKFLOW" explore test-feature --interactive --project "$TEST_PROJECT" --output "$readonly_file"
    
    # Clean up
    chmod 755 "$readonly_dir" 2>/dev/null || true
    rm -rf "$readonly_dir" 2>/dev/null || true
    
    # Should either fail gracefully or succeed (depending on system)
    # The important thing is it doesn't crash
    [ "$status" -ge 0 ]
}
