#!/usr/bin/env bats

# Test file for dt-workflow
# Location: tests/unit/test-dt-workflow.bats

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
@test "test infrastructure is set up correctly" {
    [ -f "$DT_WORKFLOW" ]
    [ -d "$TEST_PROJECT" ]
    [ -d "$TEST_PROJECT/.cursor/rules" ]
}

# ============================================================================
# Task 2: Help and Version Tests (TDD)
# ============================================================================

@test "dt-workflow shows help with --help" {
    run "$DT_WORKFLOW" --help
    [ "$status" -eq 0 ]
    [[ "$output" =~ "Usage:" ]]
    [[ "$output" =~ "dt-workflow" ]]
}

@test "dt-workflow shows help with -h" {
    run "$DT_WORKFLOW" -h
    [ "$status" -eq 0 ]
    [[ "$output" =~ "Usage:" ]]
}

@test "dt-workflow shows version with --version" {
    run "$DT_WORKFLOW" --version
    [ "$status" -eq 0 ]
    [[ "$output" =~ "dt-workflow version" ]]
}

@test "dt-workflow shows version with -v" {
    run "$DT_WORKFLOW" -v
    [ "$status" -eq 0 ]
    [[ "$output" =~ "version" ]]
}
