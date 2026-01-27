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

@test "explore workflow recommends claude-3-5-sonnet" {
    run "$DT_WORKFLOW" explore test-topic --interactive
    [ "$status" -eq 0 ]
    [[ "$output" =~ "**Recommended Model:** claude-3-5-sonnet" ]]
}

@test "research workflow recommends claude-3-5-sonnet" {
    run "$DT_WORKFLOW" research test-topic --interactive
    [ "$status" -eq 0 ]
    [[ "$output" =~ "**Recommended Model:** claude-3-5-sonnet" ]]
}

@test "decision workflow recommends claude-3-opus" {
    run "$DT_WORKFLOW" decision test-topic --interactive
    [ "$status" -eq 0 ]
    [[ "$output" =~ "**Recommended Model:** claude-3-opus" ]]
}

@test "model recommendation appears in output header" {
    run "$DT_WORKFLOW" explore test-topic --interactive
    [ "$status" -eq 0 ]
    # Check that recommendation appears early in output (header section)
    header=$(echo "$output" | head -20)
    [[ "$header" =~ "**Recommended Model:** claude-3-5-sonnet" ]]
}

@test "model recommendation includes rationale" {
    run "$DT_WORKFLOW" explore test-topic --interactive
    [ "$status" -eq 0 ]
    # Check that recommendation includes brief explanation
    [[ "$output" =~ "**Recommended Model:** claude-3-5-sonnet" ]]
    # Rationale should be included in the recommendation output
    [[ "$output" =~ "fast iteration" ]] || [[ "$output" =~ "brainstorming" ]]
}
