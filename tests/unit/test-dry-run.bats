#!/usr/bin/env bats

# Test file for dt-workflow --dry-run flag
# Location: tests/unit/test-dry-run.bats

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
# Task 7: Dry Run Tests (TDD - RED)
# ============================================================================

@test "--dry-run shows preview only" {
    run "$DT_WORKFLOW" explore test-topic --dry-run
    [ "$status" -eq 0 ]
    [[ "$output" =~ "Dry Run Preview" ]] || [[ "$output" =~ "dry run" ]] || [[ "$output" =~ "preview" ]]
    [[ "$output" =~ "Would include" ]] || [[ "$output" =~ "would include" ]]
    # Should NOT include full template content
    [[ ! "$output" =~ "# dt-workflow Output:" ]]
}

@test "--dry-run shows what would be included" {
    run "$DT_WORKFLOW" explore test-topic --dry-run
    [ "$status" -eq 0 ]
    # Should show workflow type
    [[ "$output" =~ "explore" ]] || [[ "$output" =~ "Workflow:" ]]
    # Should show topic
    [[ "$output" =~ "test-topic" ]] || [[ "$output" =~ "Topic:" ]]
}

@test "--dry-run completes quickly" {
    start=$(date +%s%N)
    run "$DT_WORKFLOW" explore test-topic --dry-run
    end=$(date +%s%N)
    duration=$(( (end - start) / 1000000 )) # ms
    [ "$status" -eq 0 ]
    [ "$duration" -lt 500 ]
}

@test "--dry-run works with all workflows" {
    # Test explore
    run "$DT_WORKFLOW" explore test-topic --dry-run
    [ "$status" -eq 0 ]
    
    # Test research
    run "$DT_WORKFLOW" research test-topic --dry-run
    [ "$status" -eq 0 ]
    
    # Test decision
    run "$DT_WORKFLOW" decision test-topic --dry-run
    [ "$status" -eq 0 ]
}

@test "--dry-run shows estimated output size" {
    run "$DT_WORKFLOW" explore test-topic --dry-run
    [ "$status" -eq 0 ]
    # Should mention tokens or size estimate
    [[ "$output" =~ "token" ]] || [[ "$output" =~ "size" ]] || [[ "$output" =~ "estimate" ]] || [[ "$output" =~ "output" ]]
}
