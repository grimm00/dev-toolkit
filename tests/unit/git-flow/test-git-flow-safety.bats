#!/usr/bin/env bats

# Tests for git-flow/safety.sh
# Note: safety.sh has a CLI interface, so we test it as a command

load '../../helpers/setup'
load '../../helpers/mocks'
load '../../helpers/assertions'

setup() {
  # Set DT_ROOT to avoid toolkit location detection issues
  export DT_ROOT="$PROJECT_ROOT"
  # Source only the utils, not the full safety script
  source "$PROJECT_ROOT/lib/git-flow/utils.sh"
}

teardown() {
  restore_commands
}

# ============================================================================
# Safety Script Command Tests
# ============================================================================

@test "safety script: shows help" {
  run bash "$PROJECT_ROOT/lib/git-flow/safety.sh" help
  [ "$status" -eq 0 ]
  [[ "$output" =~ "Usage" ]]
  [[ "$output" =~ "branch" ]]
  [[ "$output" =~ "conflicts" ]]
}

@test "safety script: runs branch check on feature branch" {
  # Mock git to return a feature branch
  git() {
    if [ "$1" = "branch" ] && [ "$2" = "--show-current" ]; then
      echo "feat/my-feature"
      return 0
    elif [ "$1" = "rev-parse" ]; then
      return 0
    fi
    command git "$@"
  }
  export -f git
  
  run bash "$PROJECT_ROOT/lib/git-flow/safety.sh" branch
  [ "$status" -eq 0 ]
  [[ "$output" =~ "Branch Safety Check" ]]
}

@test "safety script: detects protected branch" {
  # Mock git to return main branch
  git() {
    if [ "$1" = "branch" ] && [ "$2" = "--show-current" ]; then
      echo "main"
      return 0
    elif [ "$1" = "rev-parse" ]; then
      return 0
    fi
    command git "$@"
  }
  export -f git
  
  run bash "$PROJECT_ROOT/lib/git-flow/safety.sh" branch
  [ "$status" -eq 1 ]
  [[ "$output" =~ "protected branch" ]]
}

# ============================================================================
# Working Directory Check Tests
# ============================================================================

@test "safety script: runs check command (default)" {
  # Just verify the check command runs
  run bash "$PROJECT_ROOT/lib/git-flow/safety.sh" check
  # Status depends on actual repo state
  [[ "$output" =~ "Safety Check" ]] || [[ "$output" =~ "Branch" ]]
}

# ============================================================================
# Merge Conflicts Check Tests
# ============================================================================

@test "safety script: checks for merge conflicts (none)" {
  # Mock git to indicate no merge in progress
  git() {
    if [ "$1" = "rev-parse" ]; then
      if [ "$2" = "--git-dir" ]; then
        echo ".git"
      fi
      return 0
    fi
    command git "$@"
  }
  export -f git
  
  run bash "$PROJECT_ROOT/lib/git-flow/safety.sh" conflicts
  [ "$status" -eq 0 ]
  [[ "$output" =~ "Merge Conflict Check" ]]
}

# ============================================================================
# Repository Health Check Tests
# ============================================================================

@test "safety script: checks repository health" {
  # Mock git fsck to succeed
  git() {
    if [ "$1" = "fsck" ]; then
      return 0
    elif [ "$1" = "rev-parse" ]; then
      return 0
    fi
    command git "$@"
  }
  export -f git
  
  run bash "$PROJECT_ROOT/lib/git-flow/safety.sh" health
  [ "$status" -eq 0 ]
  [[ "$output" =~ "Repository Health Check" ]]
}

# ============================================================================
# Full Safety Check Integration Test
# ============================================================================

@test "safety script: checks for PRs" {
  # Just verify the prs command runs
  run bash "$PROJECT_ROOT/lib/git-flow/safety.sh" prs
  [ "$status" -eq 0 ]
  [[ "$output" =~ "Pull Request Check" ]]
}
