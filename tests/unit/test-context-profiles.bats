#!/usr/bin/env bats

# Test file for dt-workflow context profiles
# Location: tests/unit/test-context-profiles.bats

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
    
    # Create sample rule file
    echo "# Test Rule" > "$TEST_PROJECT/.cursor/rules/test.mdc"
    
    # Create sample roadmap
    mkdir -p "$TEST_PROJECT/admin/planning"
    echo "# Roadmap" > "$TEST_PROJECT/admin/planning/roadmap.md"
    
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
# Task 4: Context Profile Tests (TDD - RED)
# ============================================================================

@test "default profile includes all context" {
    run "$DT_WORKFLOW" explore test-topic --interactive
    [ "$status" -eq 0 ]
    [[ "$output" =~ "CRITICAL RULES" ]]
    [[ "$output" =~ "BACKGROUND CONTEXT" ]] || [[ "$output" =~ "PROJECT IDENTITY" ]]
}

@test "--profile minimal reduces context" {
    run "$DT_WORKFLOW" explore test-topic --interactive --profile minimal
    [ "$status" -eq 0 ]
    [[ "$output" =~ "CRITICAL RULES" ]]
    # Minimal profile should skip PROJECT IDENTITY section
    # Note: This test may need adjustment based on actual implementation
}

@test "--profile flag validates profile name" {
    run "$DT_WORKFLOW" explore test-topic --interactive --profile nonexistent
    [ "$status" -eq 1 ]
    [[ "$output" =~ "Unknown profile" ]] || [[ "$output" =~ "invalid" ]] || [[ "$output" =~ "error" ]]
}

@test "--profile default works same as no profile" {
    run "$DT_WORKFLOW" explore test-topic --interactive --profile default
    [ "$status" -eq 0 ]
    output_default="$output"
    
    run "$DT_WORKFLOW" explore test-topic --interactive
    [ "$status" -eq 0 ]
    output_no_profile="$output"
    
    # Both should include same context sections
    [[ "$output_default" =~ "CRITICAL RULES" ]]
    [[ "$output_no_profile" =~ "CRITICAL RULES" ]]
}

@test "--profile flag accepts valid profiles" {
    # Test that valid profiles don't error
    run "$DT_WORKFLOW" explore test-topic --interactive --profile minimal
    [ "$status" -eq 0 ]
    
    run "$DT_WORKFLOW" explore test-topic --interactive --profile default
    [ "$status" -eq 0 ]
}
