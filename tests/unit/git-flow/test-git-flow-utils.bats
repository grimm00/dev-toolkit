#!/usr/bin/env bats

# Tests for git-flow/utils.sh

load '../../helpers/setup'
load '../../helpers/mocks'
load '../../helpers/assertions'

setup() {
  source "$PROJECT_ROOT/lib/git-flow/utils.sh"
}

teardown() {
  restore_commands
}

# ============================================================================
# Command Existence Tests
# ============================================================================

@test "gf_command_exists: returns 0 for existing command" {
  run gf_command_exists "bash"
  [ "$status" -eq 0 ]
}

@test "gf_command_exists: returns 1 for non-existing command" {
  run gf_command_exists "this-command-does-not-exist-12345"
  [ "$status" -eq 1 ]
}

# ============================================================================
# Git Repository Tests
# ============================================================================

@test "gf_is_git_repo: returns 0 in a git repository" {
  run gf_is_git_repo
  [ "$status" -eq 0 ]
}

@test "gf_is_git_repo: returns non-zero outside git repository" {
  setup_test_dir
  run gf_is_git_repo
  result=$status
  teardown_test_dir
  [ "$result" -ne 0 ]
}

# ============================================================================
# Branch Name Validation Tests
# ============================================================================

@test "gf_is_valid_branch_name: accepts feat/ prefix" {
  run gf_is_valid_branch_name "feat/my-feature"
  [ "$status" -eq 0 ]
}

@test "gf_is_valid_branch_name: accepts fix/ prefix" {
  run gf_is_valid_branch_name "fix/bug-fix"
  [ "$status" -eq 0 ]
}

@test "gf_is_valid_branch_name: accepts chore/ prefix" {
  run gf_is_valid_branch_name "chore/update-deps"
  [ "$status" -eq 0 ]
}

@test "gf_is_valid_branch_name: accepts hotfix/ prefix" {
  run gf_is_valid_branch_name "hotfix/critical-fix"
  [ "$status" -eq 0 ]
}

@test "gf_is_valid_branch_name: rejects invalid prefix" {
  run gf_is_valid_branch_name "invalid/branch-name"
  [ "$status" -eq 1 ]
}

@test "gf_is_valid_branch_name: rejects no prefix" {
  run gf_is_valid_branch_name "no-prefix-branch"
  [ "$status" -eq 1 ]
}

# ============================================================================
# Protected Branch Tests
# ============================================================================

@test "gf_is_protected_branch: identifies main as protected" {
  run gf_is_protected_branch "main"
  [ "$status" -eq 0 ]
}

@test "gf_is_protected_branch: identifies develop as protected" {
  run gf_is_protected_branch "develop"
  [ "$status" -eq 0 ]
}

@test "gf_is_protected_branch: identifies master as protected" {
  run gf_is_protected_branch "master"
  [ "$status" -eq 0 ]
}

@test "gf_is_protected_branch: feature branch is not protected" {
  run gf_is_protected_branch "feat/my-feature"
  [ "$status" -eq 1 ]
}

@test "gf_is_protected_branch: identifies custom protected branch from config" {
  # Set custom protected branch via environment
  export GF_PROTECTED_BRANCHES=("main" "develop" "release")
  
  run gf_is_protected_branch "release"
  [ "$status" -eq 0 ]
  
  # Clean up
  unset GF_PROTECTED_BRANCHES
}

# ============================================================================
# Current Branch Tests
# ============================================================================

@test "gf_get_current_branch: returns current branch name" {
  # Mock git to return a branch name
  git() {
    if [ "$1" = "branch" ] && [ "$2" = "--show-current" ]; then
      echo "feat/my-feature"
      return 0
    fi
    command git "$@"
  }
  export -f git
  
  result=$(gf_get_current_branch)
  [ "$result" = "feat/my-feature" ]
}

@test "gf_get_current_branch: returns empty string on error" {
  # Mock git to fail
  git() {
    if [ "$1" = "branch" ] && [ "$2" = "--show-current" ]; then
      return 1
    fi
    command git "$@"
  }
  export -f git
  
  result=$(gf_get_current_branch)
  [ -z "$result" ]
}

# ============================================================================
# Project Root Tests
# ============================================================================

@test "gf_get_project_root: returns git root directory" {
  # Mock git to return a path
  git() {
    if [ "$1" = "rev-parse" ] && [ "$2" = "--show-toplevel" ]; then
      echo "/Users/test/my-project"
      return 0
    fi
    command git "$@"
  }
  export -f git
  
  result=$(gf_get_project_root)
  [ "$result" = "/Users/test/my-project" ]
}

@test "gf_get_project_root: falls back to pwd on error" {
  # Mock git to fail
  git() {
    if [ "$1" = "rev-parse" ] && [ "$2" = "--show-toplevel" ]; then
      return 1
    fi
    command git "$@"
  }
  export -f git
  
  result=$(gf_get_project_root)
  # Should return current directory
  [ -n "$result" ]
  [ -d "$result" ]
}

# ============================================================================
# Branch Existence Tests
# ============================================================================

@test "gf_branch_exists: returns 0 for existing branch" {
  # Mock git to succeed
  git() {
    if [ "$1" = "show-ref" ]; then
      return 0
    fi
    command git "$@"
  }
  export -f git
  
  run gf_branch_exists "main"
  [ "$status" -eq 0 ]
}

@test "gf_branch_exists: returns 1 for non-existing branch" {
  # Mock git to fail
  git() {
    if [ "$1" = "show-ref" ]; then
      return 1
    fi
    command git "$@"
  }
  export -f git
  
  run gf_branch_exists "nonexistent-branch"
  [ "$status" -eq 1 ]
}

# ============================================================================
# Remote Branch Existence Tests
# ============================================================================

@test "gf_remote_branch_exists: returns 0 for existing remote branch" {
  # Mock git to succeed
  git() {
    if [ "$1" = "show-ref" ] && [[ "$*" =~ "remotes/origin" ]]; then
      return 0
    fi
    command git "$@"
  }
  export -f git
  
  run gf_remote_branch_exists "main"
  [ "$status" -eq 0 ]
}

@test "gf_remote_branch_exists: returns 1 for non-existing remote branch" {
  # Mock git to fail
  git() {
    if [ "$1" = "show-ref" ] && [[ "$*" =~ "remotes/origin" ]]; then
      return 1
    fi
    command git "$@"
  }
  export -f git
  
  run gf_remote_branch_exists "nonexistent-remote"
  [ "$status" -eq 1 ]
}

# ============================================================================
# Print Function Tests
# ============================================================================

@test "gf_print_status: ERROR type includes error emoji" {
  run gf_print_status "ERROR" "Test error message"
  [ "$status" -eq 0 ]
  [[ "$output" =~ "❌" ]]
  [[ "$output" =~ "Test error message" ]]
}

@test "gf_print_status: WARNING type includes warning emoji" {
  run gf_print_status "WARNING" "Test warning message"
  [ "$status" -eq 0 ]
  [[ "$output" =~ "⚠️" ]]
  [[ "$output" =~ "Test warning message" ]]
}

@test "gf_print_status: SUCCESS type includes success emoji" {
  run gf_print_status "SUCCESS" "Test success message"
  [ "$status" -eq 0 ]
  [[ "$output" =~ "✅" ]]
  [[ "$output" =~ "Test success message" ]]
}

@test "gf_print_status: INFO type includes info emoji" {
  run gf_print_status "INFO" "Test info message"
  [ "$status" -eq 0 ]
  [[ "$output" =~ "ℹ️" ]]
  [[ "$output" =~ "Test info message" ]]
}

@test "gf_print_section: outputs section title" {
  run gf_print_section "My Section Title"
  [ "$status" -eq 0 ]
  [[ "$output" =~ "My Section Title" ]]
}

@test "gf_print_header: outputs header with underline" {
  run gf_print_header "My Header"
  [ "$status" -eq 0 ]
  [[ "$output" =~ "My Header" ]]
  [[ "$output" =~ "═" ]]
}

# ============================================================================
# Config Loading Tests
# ============================================================================

@test "gf_load_config_file: returns 1 when file doesn't exist" {
  run gf_load_config_file "/nonexistent/config/file"
  [ "$status" -eq 1 ]
}

@test "gf_load_config_file: returns 0 when file exists" {
  setup_test_dir
  cat > config.test <<EOF
MAIN_BRANCH=main
DEVELOP_BRANCH=develop
EOF
  
  run gf_load_config_file "$TEST_DIR/config.test"
  status_code=$status
  teardown_test_dir
  
  [ "$status_code" -eq 0 ]
}

@test "gf_load_config_file: loads MAIN_BRANCH setting" {
  setup_test_dir
  cat > config.test <<EOF
MAIN_BRANCH=trunk
EOF
  
  gf_load_config_file "$TEST_DIR/config.test"
  result="$GF_MAIN_BRANCH"
  teardown_test_dir
  
  [ "$result" = "trunk" ]
}

@test "gf_load_config_file: ignores comments" {
  setup_test_dir
  cat > config.test <<EOF
# This is a comment
MAIN_BRANCH=main
# Another comment
DEVELOP_BRANCH=develop
EOF
  
  gf_load_config_file "$TEST_DIR/config.test"
  main_result="$GF_MAIN_BRANCH"
  dev_result="$GF_DEVELOP_BRANCH"
  teardown_test_dir
  
  [ "$main_result" = "main" ]
  [ "$dev_result" = "develop" ]
}

# ============================================================================
# Dependency Check Tests
# ============================================================================

@test "gf_check_required_dependencies: succeeds when all deps available" {
  # Mock command existence checks to succeed
  command() {
    if [ "$1" = "-v" ]; then
      return 0
    fi
    builtin command "$@"
  }
  export -f command
  
  run gf_check_required_dependencies
  [ "$status" -eq 0 ]
}

@test "gf_check_required_dependencies: fails when git missing" {
  # Mock git as missing
  command() {
    if [ "$1" = "-v" ] && [ "$2" = "git" ]; then
      return 1
    fi
    builtin command "$@"
  }
  export -f command
  
  run gf_check_required_dependencies
  [ "$status" -eq 1 ]
  [[ "$output" =~ "git" ]]
}

@test "gf_check_required_dependencies: fails when multiple dependencies missing" {
  # Mock git and bash as missing
  command() {
    if [ "$1" = "-v" ] && { [ "$2" = "git" ] || [ "$2" = "bash" ]; }; then
      return 1
    fi
    builtin command "$@"
  }
  export -f command
  
  run gf_check_required_dependencies
  [ "$status" -eq 1 ]
  # Should report both missing dependencies
  [[ "$output" =~ "git" ]] || [[ "$output" =~ "bash" ]]
}

# ============================================================================
# Config Display Tests
# ============================================================================

@test "gf_show_config: displays configuration header" {
  run gf_show_config
  [ "$status" -eq 0 ]
  [[ "$output" =~ "Configuration" ]]
}

@test "gf_show_config: shows main branch setting" {
  run gf_show_config
  [ "$status" -eq 0 ]
  [[ "$output" =~ "Main Branch" ]]
}

@test "gf_show_config: shows develop branch setting" {
  run gf_show_config
  [ "$status" -eq 0 ]
  [[ "$output" =~ "Develop Branch" ]]
}

@test "gf_show_config: shows protected branches" {
  run gf_show_config
  [ "$status" -eq 0 ]
  [[ "$output" =~ "Protected Branches" ]]
}
