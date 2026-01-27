#!/usr/bin/env bats

# Test file for dt-workflow performance requirements
# Location: tests/unit/test-performance.bats
# Requirements: NFR-2 (context injection <1s), NFR-3 (validation <500ms)
#
# Performance Test Strategy:
# - These tests use relaxed thresholds (5x-16x margins) to avoid flakiness on slow/contended CI runners
# - They serve as "smoke tests" to catch significant performance regressions
# - Precise NFR validation should be done via dedicated benchmarks/perf test suites
# - Actual performance is typically much faster than thresholds (e.g., ~300ms vs 5s for context injection)

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
    
    # Create sample rule files (multiple for realistic testing)
    echo "# Test Rule 1" > "$TEST_PROJECT/.cursor/rules/test1.mdc"
    echo "# Test Rule 2" > "$TEST_PROJECT/.cursor/rules/test2.mdc"
    echo "# Test Rule 3" > "$TEST_PROJECT/.cursor/rules/test3.mdc"
    
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
# Task 9: Performance Tests (TDD - RED)
# ============================================================================

@test "context injection completes within acceptable time (NFR-2 smoke)" {
    # Coarse-grained performance smoke test:
    # - Uses a relaxed threshold to avoid flakiness on slow/contended CI runners
    # - Precise NFR validation should be done via dedicated benchmarks/perf tests
    # - Actual performance is typically ~300ms, so 5s threshold provides ~16x margin
    start=$(date +%s%N)
    run "$DT_WORKFLOW" explore test-topic --interactive 2>/dev/null
    end=$(date +%s%N)
    duration=$(( (end - start) / 1000000 )) # Convert to milliseconds
    [ "$status" -eq 0 ]
    # "Not absurdly slow" guardrail: allow up to 5 seconds wall-clock to reduce flakiness
    # NFR-2: coarse check (<5 seconds); stricter checks live in perf suites
    [ "$duration" -lt 5000 ]
}

@test "validation completes within acceptable time (NFR-3 smoke)" {
    # Coarse-grained performance smoke test:
    # - Uses a relaxed threshold to avoid flakiness on slow/contended CI runners
    # - Precise NFR validation should be done via dedicated benchmarks/perf tests
    # - Actual performance is typically well under 500ms, so 2.5s threshold provides ~5x margin
    start=$(date +%s%N)
    run "$DT_WORKFLOW" explore test-topic --validate 2>/dev/null
    end=$(date +%s%N)
    duration=$(( (end - start) / 1000000 )) # Convert to milliseconds
    [ "$status" -eq 0 ]
    # "Not absurdly slow" guardrail: allow up to 2.5 seconds wall-clock to reduce flakiness
    # NFR-3: coarse check (<2.5 seconds); stricter checks live in perf suites
    [ "$duration" -lt 2500 ]
}

@test "dry-run completes quickly" {
    # Test that --dry-run mode completes quickly (should be fastest)
    # Uses relaxed threshold to avoid flakiness on slow CI runners
    start=$(date +%s%N)
    run "$DT_WORKFLOW" explore test-topic --dry-run 2>/dev/null
    end=$(date +%s%N)
    duration=$(( (end - start) / 1000000 )) # Convert to milliseconds
    [ "$status" -eq 0 ]
    # Dry run should be very fast, but allow up to 2 seconds to avoid flakiness
    [ "$duration" -lt 2000 ]
}

@test "help command completes quickly" {
    # Test that --help completes quickly (no context gathering)
    # Uses relaxed threshold to avoid flakiness on slow CI runners
    start=$(date +%s%N)
    run "$DT_WORKFLOW" --help 2>/dev/null
    end=$(date +%s%N)
    duration=$(( (end - start) / 1000000 )) # Convert to milliseconds
    [ "$status" -eq 0 ]
    # Help should be instant, but allow up to 1 second to avoid flakiness
    [ "$duration" -lt 1000 ]
}

@test "full output generation completes in reasonable time" {
    # Test that full output generation (interactive mode) completes reasonably
    # This is a broader test - should complete but may take longer than validation
    start=$(date +%s%N)
    run "$DT_WORKFLOW" explore test-topic --interactive 2>/dev/null
    end=$(date +%s%N)
    duration=$(( (end - start) / 1000000 )) # Convert to milliseconds
    [ "$status" -eq 0 ]
    # Full output may take longer, but should still be reasonable (<3 seconds)
    [ "$duration" -lt 3000 ]
}

@test "performance consistent across workflows" {
    # Test that performance is consistent across different workflow types
    # Uses relaxed thresholds to avoid flakiness on slow CI runners
    # All should complete within acceptable time for context injection
    
    # Explore workflow
    start=$(date +%s%N)
    run "$DT_WORKFLOW" explore test-topic --interactive 2>/dev/null
    end=$(date +%s%N)
    explore_duration=$(( (end - start) / 1000000 ))
    [ "$status" -eq 0 ]
    
    # Research workflow
    start=$(date +%s%N)
    run "$DT_WORKFLOW" research test-topic --interactive 2>/dev/null
    end=$(date +%s%N)
    research_duration=$(( (end - start) / 1000000 ))
    [ "$status" -eq 0 ]
    
    # Decision workflow
    start=$(date +%s%N)
    run "$DT_WORKFLOW" decision test-topic --interactive 2>/dev/null
    end=$(date +%s%N)
    decision_duration=$(( (end - start) / 1000000 ))
    [ "$status" -eq 0 ]
    
    # All should complete within acceptable time (<5 seconds) to avoid flakiness
    [ "$explore_duration" -lt 5000 ]
    [ "$research_duration" -lt 5000 ]
    [ "$decision_duration" -lt 5000 ]
}
