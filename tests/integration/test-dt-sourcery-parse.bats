#!/usr/bin/env bats

# Integration tests for dt-sourcery-parse command
# Tests Sourcery review parsing end-to-end

load '../helpers/setup'
load '../helpers/mocks'
load '../helpers/assertions'

setup() {
  setup_file
}

# ============================================================================
# Help Command Tests
# ============================================================================

@test "dt-sourcery-parse: shows help with --help flag" {
  run dt-sourcery-parse --help
  [ "$status" -eq 0 ]
  [[ "$output" =~ "Sourcery Review Parser" ]]
  [[ "$output" =~ "Usage:" ]]
}

@test "dt-sourcery-parse: rejects invalid command" {
  run dt-sourcery-parse help
  [ "$status" -ne 0 ]
  [[ "$output" =~ "Invalid argument" ]] || [[ "$output" =~ "Error" ]]
}

@test "dt-sourcery-parse: shows help with -h flag" {
  run dt-sourcery-parse -h
  [ "$status" -eq 0 ]
  [[ "$output" =~ "Sourcery Review Parser" ]]
}

# ============================================================================
# Error Handling Tests
# ============================================================================

@test "dt-sourcery-parse: accepts numeric PR number" {
  # This will fail due to no git repo, but it validates argument parsing
  run dt-sourcery-parse 123
  # Should fail but not due to argument parsing
  [ "$status" -ne 0 ]
  # Should NOT show "Invalid argument" error
  ! [[ "$output" =~ "Invalid argument" ]]
}

@test "dt-sourcery-parse: rejects non-numeric PR number" {
  run dt-sourcery-parse abc
  [ "$status" -ne 0 ]
  [[ "$output" =~ "Invalid argument" ]] || [[ "$output" =~ "Error" ]]
}

@test "dt-sourcery-parse: handles no git repository gracefully" {
  # Create a non-git directory
  TEST_DIR=$(mktemp -d)
  cd "$TEST_DIR"
  
  run dt-sourcery-parse 1
  [ "$status" -ne 0 ]
  [[ "$output" =~ "git" ]] || [[ "$output" =~ "repository" ]] || [[ "$output" =~ "Error" ]]
  
  # Cleanup
  cd - > /dev/null 2>&1
  rm -rf "$TEST_DIR"
}

# ============================================================================
# Flag and Option Tests
# ============================================================================

@test "dt-sourcery-parse: accepts --rich-details flag" {
  # Just verify the flag is accepted (will fail due to no repo, but not due to flag)
  run dt-sourcery-parse 1 --rich-details
  [ "$status" -ne 0 ]
  # Should NOT show "Invalid argument" for the flag
  ! [[ "$output" =~ "Invalid argument.*rich-details" ]]
}

@test "dt-sourcery-parse: accepts -o output flag" {
  # Just verify the flag is accepted
  run dt-sourcery-parse 1 -o /tmp/test.md
  [ "$status" -ne 0 ]
  # Should NOT show "Invalid argument" for the flag
  ! [[ "$output" =~ "Invalid argument.*output" ]]
}

@test "dt-sourcery-parse: accepts --no-details flag" {
  run dt-sourcery-parse 1 --no-details
  [ "$status" -ne 0 ]
  ! [[ "$output" =~ "Invalid argument.*no-details" ]]
}

@test "dt-sourcery-parse: accepts --think flag" {
  run dt-sourcery-parse 1 --think
  [ "$status" -ne 0 ]
  ! [[ "$output" =~ "Invalid argument.*think" ]]
}

# ============================================================================
# dt-review Alias Tests
# ============================================================================

@test "dt-review: command exists and is executable" {
  command -v dt-review
  [ -x "$(command -v dt-review)" ]
}

@test "dt-review: shows help" {
  run dt-review --help
  [ "$status" -eq 0 ]
  [[ "$output" =~ "Usage:" ]]
  [[ "$output" =~ "dt-review" ]]
  [[ "$output" =~ "admin/feedback/sourcery" ]]
}
