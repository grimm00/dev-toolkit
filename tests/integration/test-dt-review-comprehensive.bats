#!/usr/bin/env bats

# Comprehensive integration tests for dt-review command
# Tests functionality with real dt-sourcery-parse integration

load '../helpers/setup'
load '../helpers/assertions'

setup() {
  setup_file
}

# ============================================================================
# Core Functionality Tests (with real API calls)
# ============================================================================

@test "dt-review: creates default output file structure" {
  # Test with a PR that likely doesn't exist (to avoid API calls)
  # This tests the file creation logic without requiring real Sourcery data
  run dt-review 99999
  [ "$status" -ne 0 ]  # Should fail due to no Sourcery review
  
  # But it should create the directory structure
  [ -d "admin/feedback/sourcery" ]
  
  # And should not create the file (since no review found)
  [ ! -f "admin/feedback/sourcery/pr99999.md" ]
}

@test "dt-review: creates custom output file structure" {
  local custom_output="/tmp/test-dt-review-output.md"
  
  # Test with a PR that likely doesn't exist
  run dt-review 99999 "$custom_output"
  [ "$status" -ne 0 ]  # Should fail due to no Sourcery review
  
  # Should not create the file (since no review found)
  [ ! -f "$custom_output" ]
  
  # Cleanup
  rm -f "$custom_output"
}

@test "dt-review: handles custom output path with spaces" {
  local custom_output="/tmp/test review with spaces.md"
  
  # Test with a PR that likely doesn't exist
  run dt-review 99999 "$custom_output"
  [ "$status" -ne 0 ]  # Should fail due to no Sourcery review
  
  # Should not create the file (since no review found)
  [ ! -f "$custom_output" ]
  
  # Cleanup
  rm -f "$custom_output"
}

@test "dt-review: handles custom output path in non-existent directory" {
  local custom_output="/tmp/nonexistent/test.md"
  
  # Test with a PR that likely doesn't exist
  run dt-review 99999 "$custom_output"
  [ "$status" -ne 0 ]  # Should fail due to no Sourcery review
  
  # Should not create the directory or file
  [ ! -d "/tmp/nonexistent" ]
  [ ! -f "$custom_output" ]
}

# ============================================================================
# Error Handling Tests
# ============================================================================

@test "dt-review: handles negative PR numbers" {
  run dt-review -1
  [ "$status" -ne 0 ]
  [[ "$output" =~ "PR number must be numeric" ]]
}

@test "dt-review: handles zero PR number" {
  run dt-review 0
  [ "$status" -ne 0 ]
  # Should fail due to PR not found
  [[ "$output" =~ "PR #0 not found" ]]
}

@test "dt-review: handles very large PR numbers" {
  run dt-review 999999999
  [ "$status" -ne 0 ]
  # Should fail due to PR not found
  [[ "$output" =~ "PR #999999999 not found" ]]
}

@test "dt-review: handles decimal PR numbers" {
  run dt-review 1.5
  [ "$status" -ne 0 ]
  [[ "$output" =~ "PR number must be numeric" ]]
}

@test "dt-review: handles PR numbers with leading zeros" {
  run dt-review 001
  [ "$status" -ne 0 ]
  # Should fail due to rate limit or other error (PR exists)
  [[ "$output" =~ "rate limit" ]] || [[ "$output" =~ "Failed to parse" ]] || [[ "$output" =~ "Error" ]]
}

# ============================================================================
# Output Format Tests
# ============================================================================

@test "dt-review: shows helpful error messages for missing reviews" {
  run dt-review 99999
  [ "$status" -ne 0 ]
  [[ "$output" =~ "PR #99999 not found" ]]
}

@test "dt-review: shows helpful error messages for invalid PRs" {
  run dt-review 999999999
  [ "$status" -ne 0 ]
  # Should show some kind of error message
  [[ "$output" =~ "Error" ]] || [[ "$output" =~ "not found" ]] || [[ "$output" =~ "No Sourcery review found" ]]
}

# ============================================================================
# Path Detection Tests
# ============================================================================

@test "dt-review: works from dev-toolkit directory" {
  # Ensure we're in the dev-toolkit directory
  [ -f "bin/dt-review" ]
  [ -f "lib/sourcery/parser.sh" ]
  
  # Test that dt-review can find the local parser
  run dt-review 99999
  [ "$status" -ne 0 ]  # Should fail due to no review, not path issues
  # Should not show "Cannot locate dev-toolkit installation"
  [[ ! "$output" =~ "Cannot locate dev-toolkit installation" ]]
}

# ============================================================================
# Edge Case Tests
# ============================================================================

@test "dt-review: handles empty string as PR number" {
  run dt-review ""
  [ "$status" -ne 0 ]
  [[ "$output" =~ "Usage:" ]]
}

@test "dt-review: handles whitespace-only PR number" {
  run dt-review "   "
  [ "$status" -ne 0 ]
  [[ "$output" =~ "PR number must be numeric" ]]
}

@test "dt-review: handles PR number with whitespace" {
  run dt-review " 123 "
  [ "$status" -ne 0 ]
  [[ "$output" =~ "PR number must be numeric" ]]
}

# ============================================================================
# Cleanup
# ============================================================================

teardown() {
  # Clean up any test files created
  rm -f admin/feedback/sourcery/pr*.md
  rm -f /tmp/test*.md
  rm -f /tmp/*review*.md
}
