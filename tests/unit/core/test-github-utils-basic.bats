#!/usr/bin/env bats

# Tests for basic github-utils.sh functions (pure bash, no external dependencies)

load '../../helpers/setup'
load '../../helpers/assertions'

setup() {
  source "$PROJECT_ROOT/lib/core/github-utils.sh"
}

# ============================================================================
# Command Existence Tests
# ============================================================================

@test "gh_command_exists: returns 0 for existing command" {
  run gh_command_exists "bash"
  [ "$status" -eq 0 ]
}

@test "gh_command_exists: returns 1 for non-existing command" {
  run gh_command_exists "this-command-does-not-exist-12345"
  [ "$status" -eq 1 ]
}

# ============================================================================
# Git Repository Tests
# ============================================================================

@test "gh_is_git_repo: returns 0 in a git repository" {
  # We're in the dev-toolkit repo
  run gh_is_git_repo
  [ "$status" -eq 0 ]
}

@test "gh_is_git_repo: returns non-zero outside git repository" {
  # Test in a temp directory that's not a git repo
  setup_test_dir
  run gh_is_git_repo
  # Capture status before teardown changes directory
  # Note: git returns 128, not 1, when not in a repo
  local result=$status
  teardown_test_dir
  # Now check the result - should be non-zero
  [ "$result" -ne 0 ]
}

# ============================================================================
# Branch Name Validation Tests
# ============================================================================

@test "gh_is_valid_branch_name: accepts feat/ prefix" {
  run gh_is_valid_branch_name "feat/my-feature"
  [ "$status" -eq 0 ]
}

@test "gh_is_valid_branch_name: accepts fix/ prefix" {
  run gh_is_valid_branch_name "fix/bug-fix"
  [ "$status" -eq 0 ]
}

@test "gh_is_valid_branch_name: accepts chore/ prefix" {
  run gh_is_valid_branch_name "chore/update-deps"
  [ "$status" -eq 0 ]
}

@test "gh_is_valid_branch_name: accepts hotfix/ prefix" {
  run gh_is_valid_branch_name "hotfix/critical-fix"
  [ "$status" -eq 0 ]
}

@test "gh_is_valid_branch_name: accepts feature/ prefix" {
  run gh_is_valid_branch_name "feature/new-feature"
  [ "$status" -eq 0 ]
}

@test "gh_is_valid_branch_name: rejects invalid prefix" {
  run gh_is_valid_branch_name "invalid/branch-name"
  [ "$status" -eq 1 ]
}

@test "gh_is_valid_branch_name: rejects no prefix" {
  run gh_is_valid_branch_name "no-prefix-branch"
  [ "$status" -eq 1 ]
}

# ============================================================================
# Protected Branch Tests
# ============================================================================

@test "gh_is_protected_branch: identifies main as protected" {
  run gh_is_protected_branch "main"
  [ "$status" -eq 0 ]
}

@test "gh_is_protected_branch: identifies develop as protected" {
  run gh_is_protected_branch "develop"
  [ "$status" -eq 0 ]
}

@test "gh_is_protected_branch: feature branch is not protected" {
  run gh_is_protected_branch "feat/my-feature"
  [ "$status" -eq 1 ]
}

@test "gh_is_protected_branch: master is not protected by default" {
  run gh_is_protected_branch "master"
  [ "$status" -eq 1 ]
}

@test "gh_is_protected_branch: identifies custom protected branch from config" {
  # Set custom protected branch via environment
  export GH_PROTECTED_BRANCHES=("main" "develop" "release")
  
  run gh_is_protected_branch "release"
  [ "$status" -eq 0 ]
  
  # Clean up
  unset GH_PROTECTED_BRANCHES
}

# ============================================================================
# Secret Generation Tests
# ============================================================================

@test "gh_generate_secret: generates non-empty secret" {
  result=$(gh_generate_secret)
  [ -n "$result" ]
}

@test "gh_generate_secret: generates different secrets each time" {
  secret1=$(gh_generate_secret)
  secret2=$(gh_generate_secret)
  [ "$secret1" != "$secret2" ]
}

@test "gh_generate_secret: generates base64 encoded secrets" {
  result=$(gh_generate_secret)
  # Base64 output contains alphanumeric, +, /, and = characters
  [[ "$result" =~ ^[a-zA-Z0-9+/=]+$ ]]
}

@test "gh_generate_secret: generates secure secrets with sufficient length and entropy" {
  result=$(gh_generate_secret)
  
  # Base64 format check
  [[ "$result" =~ ^[a-zA-Z0-9+/=]+$ ]]
  
  # Minimum length check (32 characters for security)
  [ "${#result}" -ge 32 ]
  
  # Entropy checks - base64 should have variety of characters
  [[ "$result" =~ [A-Z] ]]  # Has uppercase letters
  [[ "$result" =~ [a-z] ]]  # Has lowercase letters
  [[ "$result" =~ [0-9] ]]  # Has digits
  # Note: +/= may not always be present in every string, but the above checks ensure variety
}
