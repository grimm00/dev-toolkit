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
