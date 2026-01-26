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

# ============================================================================
# Task 3: Input Validation Tests (TDD)
# ============================================================================

@test "dt-workflow requires workflow argument" {
    run "$DT_WORKFLOW"
    [ "$status" -eq 1 ]
    [[ "$output" =~ "Workflow type is required" ]]
    [[ "$output" =~ "💡" ]]  # Actionable suggestion
}

@test "dt-workflow requires topic argument" {
    run "$DT_WORKFLOW" explore
    [ "$status" -eq 1 ]
    [[ "$output" =~ "Topic is required" ]]
    [[ "$output" =~ "💡" ]]
}

@test "dt-workflow rejects unknown workflow" {
    run "$DT_WORKFLOW" unknown-workflow test-topic --interactive
    [ "$status" -eq 1 ]
    [[ "$output" =~ "Unknown workflow" ]]
}

@test "dt-workflow requires --interactive in Phase 1" {
    run "$DT_WORKFLOW" explore test-topic
    [ "$status" -eq 1 ]
    [[ "$output" =~ "Phase 1 requires --interactive" ]]
}

@test "dt-workflow --validate checks L1 existence" {
    run "$DT_WORKFLOW" research nonexistent-topic --validate --project "$TEST_PROJECT"
    [ "$status" -eq 1 ]
    [[ "$output" =~ "Exploration directory not found" ]]
}

@test "dt-workflow --validate passes for explore (no prereqs)" {
    run "$DT_WORKFLOW" explore test-topic --validate --project "$TEST_PROJECT"
    [ "$status" -eq 0 ]
    [[ "$output" =~ "L1 checks passed" ]]
}

# ============================================================================
# Task 4: Context Gathering Functions Tests (TDD)
# ============================================================================

@test "gather_cursor_rules outputs rules when present" {
    # Setup: Create mock rules
    echo "# Test Rule" > "$TEST_PROJECT/.cursor/rules/test.mdc"
    
    # Source the script to access functions
    # Script checks if sourced vs executed, so main won't run
    source "$DT_WORKFLOW"
    
    run gather_cursor_rules "$TEST_PROJECT"
    [ "$status" -eq 0 ]
    [[ "$output" =~ "Cursor Rules" ]]
    [[ "$output" =~ "test.mdc" ]]
    [[ "$output" =~ "# Test Rule" ]]
}

@test "gather_cursor_rules handles missing rules directory" {
    # Setup: No .cursor/rules directory
    rm -rf "$TEST_PROJECT/.cursor/rules"
    
    source "$DT_WORKFLOW"
    run gather_cursor_rules "$TEST_PROJECT"
    [ "$status" -eq 0 ]
    # Should not error, just no output or debug message
}

@test "gather_project_identity finds roadmap" {
    mkdir -p "$TEST_PROJECT/admin/planning"
    echo "# Roadmap" > "$TEST_PROJECT/admin/planning/roadmap.md"
    
    source "$DT_WORKFLOW"
    run gather_project_identity "$TEST_PROJECT"
    [ "$status" -eq 0 ]
    [[ "$output" =~ "Project Roadmap" ]]
}

@test "gather_project_identity handles missing files gracefully" {
    source "$DT_WORKFLOW"
    run gather_project_identity "$TEST_PROJECT"
    [ "$status" -eq 0 ]
    # Should not error
}

@test "estimate_tokens returns approximate count" {
    source "$DT_WORKFLOW"
    
    # ~100 chars = ~25 tokens (4 chars per token)
    result=$(estimate_tokens "This is a test string with approximately one hundred characters in it for testing purposes here.")
    [ "$result" -gt 20 ]
    [ "$result" -lt 30 ]
}
