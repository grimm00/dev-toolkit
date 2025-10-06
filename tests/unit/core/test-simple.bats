#!/usr/bin/env bats

# Simple smoke tests to verify bats is working

@test "bats is installed and working" {
  run echo "hello world"
  [ "$status" -eq 0 ]
  [ "$output" = "hello world" ]
}

@test "basic arithmetic works" {
  result=$((2 + 2))
  [ "$result" -eq 4 ]
}

@test "can check if file exists" {
  load '../../helpers/setup'
  [ -f "$PROJECT_ROOT/README.md" ]
}

@test "PROJECT_ROOT is set correctly" {
  load '../../helpers/setup'
  [ -n "$PROJECT_ROOT" ]
  [ -d "$PROJECT_ROOT" ]
  [ -f "$PROJECT_ROOT/README.md" ]
}

@test "can source github-utils without errors" {
  load '../../helpers/setup'
  # Just verify we can source the file
  source "$PROJECT_ROOT/lib/core/github-utils.sh"
  # Check that some functions are defined
  type gh_print_header >/dev/null 2>&1
}
