#!/usr/bin/env bats

# Test file for dt-workflow model recommendations
# Location: tests/unit/test-model-recommendations.bats

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

# ============================================================================
# Task 1: Model Recommendation Tests (TDD - RED)
# ============================================================================

@test "explore workflow recommends model in output" {
    run "$DT_WORKFLOW" explore test-topic --interactive
    [ "$status" -eq 0 ]
    [[ "$output" =~ "Recommended Model:" ]]
}

@test "research workflow recommends model in output" {
    run "$DT_WORKFLOW" research test-topic --interactive
    [ "$status" -eq 0 ]
    [[ "$output" =~ "Recommended Model:" ]]
}

@test "decision workflow recommends model in output" {
    run "$DT_WORKFLOW" decision test-topic --interactive
    [ "$status" -eq 0 ]
    [[ "$output" =~ "Recommended Model:" ]]
}

@test "model recommendation appears in output header" {
    run "$DT_WORKFLOW" explore test-topic --interactive
    [ "$status" -eq 0 ]
    # Check that recommendation appears early in output (header section)
    header=$(echo "$output" | head -20)
    [[ "$header" =~ "Recommended Model:" ]]
}

@test "model recommendation includes rationale" {
    run "$DT_WORKFLOW" explore test-topic --interactive
    [ "$status" -eq 0 ]
    # Check that recommendation includes brief explanation
    [[ "$output" =~ "Recommended Model:" ]]
    # Rationale should be on same or next line
    [[ "$output" =~ "claude" ]] || [[ "$output" =~ "fast" ]] || [[ "$output" =~ "iteration" ]]
}
