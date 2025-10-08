#!/usr/bin/env bats

# Simple integration tests for dt-review command
# Tests basic functionality without complex mocking

load '../helpers/setup'
load '../helpers/assertions'

setup() {
  setup_file
}

# ============================================================================
# Basic Help Tests
# ============================================================================

@test "dt-review: shows help with --help flag" {
  run dt-review --help
  [ "$status" -eq 0 ]
  [[ "$output" =~ "Usage:" ]]
  [[ "$output" =~ "dt-review" ]]
}

@test "dt-review: shows help with -h flag" {
  run dt-review -h
  [ "$status" -eq 0 ]
  [[ "$output" =~ "Usage:" ]]
}

@test "dt-review: shows usage with no arguments" {
  run dt-review
  [ "$status" -eq 1 ]
  [[ "$output" =~ "Usage:" ]]
}

# ============================================================================
# Basic Error Handling Tests
# ============================================================================

@test "dt-review: handles invalid PR number format" {
  run dt-review "abc"
  [ "$status" -ne 0 ]
  # Should show validation error for non-numeric PR number
  [[ "$output" =~ "PR number must be numeric" ]]
  [[ "$output" =~ "got: abc" ]]
}

@test "dt-review: handles missing PR number" {
  run dt-review ""
  [ "$status" -ne 0 ]
  [[ "$output" =~ "Usage:" ]]
}

# ============================================================================
# File Creation Tests (without API calls)
# ============================================================================

@test "dt-review: creates output directory if it doesn't exist" {
  # Remove directory if it exists
  rm -rf admin/feedback/sourcery
  
  # This should fail gracefully since we're not mocking the API
  run dt-review 99999
  [ "$status" -ne 0 ]
  
  # But it should create the directory structure
  [ -d "admin/feedback/sourcery" ]
}

# ============================================================================
# Cleanup
# ============================================================================

teardown() {
  # Clean up any test files created
  rm -f admin/feedback/sourcery/pr*.md
}
