#!/usr/bin/env bats

# Tests for github-utils.sh git-related functions (requires mocking)

load '../../helpers/setup'
load '../../helpers/mocks'
load '../../helpers/assertions'

setup() {
  source "$PROJECT_ROOT/lib/core/github-utils.sh"
}

teardown() {
  # Clean up any mocked functions
  restore_commands
}

# ============================================================================
# Current Branch Tests
# ============================================================================

@test "gh_get_current_branch: returns current branch name" {
  # Mock git to return a branch name
  git() {
    if [ "$1" = "branch" ] && [ "$2" = "--show-current" ]; then
      echo "feat/my-feature"
      return 0
    fi
    command git "$@"
  }
  export -f git
  
  result=$(gh_get_current_branch)
  [ "$result" = "feat/my-feature" ]
}

@test "gh_get_current_branch: returns empty string on error" {
  # Mock git to fail
  git() {
    if [ "$1" = "branch" ] && [ "$2" = "--show-current" ]; then
      return 1
    fi
    command git "$@"
  }
  export -f git
  
  result=$(gh_get_current_branch)
  [ -z "$result" ]
}

# ============================================================================
# Project Root Tests
# ============================================================================

@test "gh_get_project_root: returns git root directory" {
  # Mock git to return a path
  git() {
    if [ "$1" = "rev-parse" ] && [ "$2" = "--show-toplevel" ]; then
      echo "/Users/test/my-project"
      return 0
    fi
    command git "$@"
  }
  export -f git
  
  result=$(gh_get_project_root)
  [ "$result" = "/Users/test/my-project" ]
}

@test "gh_get_project_root: falls back to pwd on error" {
  # Mock git to fail
  git() {
    if [ "$1" = "rev-parse" ] && [ "$2" = "--show-toplevel" ]; then
      return 1
    fi
    command git "$@"
  }
  export -f git
  
  result=$(gh_get_project_root)
  # Should return current directory
  [ -n "$result" ]
  [ -d "$result" ]
}

# ============================================================================
# Branch Existence Tests
# ============================================================================

@test "gh_branch_exists: returns 0 for existing branch" {
  # Mock git to succeed
  git() {
    if [ "$1" = "show-ref" ]; then
      return 0
    fi
    command git "$@"
  }
  export -f git
  
  run gh_branch_exists "main"
  [ "$status" -eq 0 ]
}

@test "gh_branch_exists: returns 1 for non-existing branch" {
  # Mock git to fail
  git() {
    if [ "$1" = "show-ref" ]; then
      return 1
    fi
    command git "$@"
  }
  export -f git
  
  run gh_branch_exists "nonexistent-branch"
  [ "$status" -eq 1 ]
}

# ============================================================================
# Remote Branch Existence Tests
# ============================================================================

@test "gh_remote_branch_exists: returns 0 for existing remote branch" {
  # Mock git to succeed
  git() {
    if [ "$1" = "show-ref" ] && [[ "$*" =~ "remotes/origin" ]]; then
      return 0
    fi
    command git "$@"
  }
  export -f git
  
  run gh_remote_branch_exists "main"
  [ "$status" -eq 0 ]
}

@test "gh_remote_branch_exists: returns 1 for non-existing remote branch" {
  # Mock git to fail
  git() {
    if [ "$1" = "show-ref" ] && [[ "$*" =~ "remotes/origin" ]]; then
      return 1
    fi
    command git "$@"
  }
  export -f git
  
  run gh_remote_branch_exists "nonexistent-remote"
  [ "$status" -eq 1 ]
}

# ============================================================================
# Project Info Detection Tests (Complex)
# ============================================================================

@test "gh_detect_project_info: extracts info from HTTPS URL" {
  # Mock git to return HTTPS URL
  git() {
    if [ "$1" = "remote" ] && [ "$2" = "get-url" ]; then
      echo "https://github.com/testowner/testrepo.git"
      return 0
    fi
    command git "$@"
  }
  export -f git
  
  # Mock gh to fail (test git fallback)
  gh() {
    return 1
  }
  export -f gh
  
  gh_detect_project_info
  
  [ "$PROJECT_OWNER" = "testowner" ]
  [ "$PROJECT_NAME" = "testrepo" ]
  [ "$PROJECT_REPO" = "testowner/testrepo" ]
}

@test "gh_detect_project_info: extracts info from SSH URL" {
  # Mock git to return SSH URL
  git() {
    if [ "$1" = "remote" ] && [ "$2" = "get-url" ]; then
      echo "git@github.com:testowner/testrepo.git"
      return 0
    fi
    command git "$@"
  }
  export -f git
  
  # Mock gh to fail (test git fallback)
  gh() {
    return 1
  }
  export -f gh
  
  gh_detect_project_info
  
  [ "$PROJECT_OWNER" = "testowner" ]
  [ "$PROJECT_NAME" = "testrepo" ]
  [ "$PROJECT_REPO" = "testowner/testrepo" ]
}

@test "gh_detect_project_info: handles URL without .git suffix" {
  # Mock git to return URL without .git
  git() {
    if [ "$1" = "remote" ] && [ "$2" = "get-url" ]; then
      echo "https://github.com/testowner/testrepo"
      return 0
    fi
    command git "$@"
  }
  export -f git
  
  # Mock gh to fail (test git fallback)
  gh() {
    return 1
  }
  export -f gh
  
  gh_detect_project_info
  
  [ "$PROJECT_OWNER" = "testowner" ]
  [ "$PROJECT_NAME" = "testrepo" ]
  [ "$PROJECT_REPO" = "testowner/testrepo" ]
}

@test "gh_detect_project_info: falls back to directory name when no remote" {
  # Mock git to fail on remote
  git() {
    if [ "$1" = "remote" ] && [ "$2" = "get-url" ]; then
      return 1
    elif [ "$1" = "rev-parse" ] && [ "$2" = "--show-toplevel" ]; then
      echo "/Users/test/my-project-name"
      return 0
    fi
    command git "$@"
  }
  export -f git
  
  # Mock gh to fail
  gh() {
    return 1
  }
  export -f gh
  
  # Function returns 1 when it can't fully detect info, but still sets PROJECT_NAME
  gh_detect_project_info || true
  
  [ "$PROJECT_NAME" = "my-project-name" ]
}

@test "gh_detect_project_info: handles malformed remote URL gracefully" {
  # Mock git to return a malformed remote URL
  git() {
    if [ "$1" = "remote" ] && [ "$2" = "get-url" ]; then
      echo "malformed-url-without-proper-format"
      return 0
    elif [ "$1" = "rev-parse" ] && [ "$2" = "--show-toplevel" ]; then
      echo "/Users/test/my-project-name"
      return 0
    fi
    command git "$@"
  }
  export -f git
  
  # Mock gh to fail
  gh() {
    return 1
  }
  export -f gh
  
  # Function should handle malformed URL gracefully (may return error or fall back)
  gh_detect_project_info || true
  
  # At minimum, it should not crash and should set some project name
  # Either from the malformed URL or from directory fallback
  [ -n "${PROJECT_NAME:-}" ]
  # The function handled the malformed URL without crashing
}

# ============================================================================
# Config Loading Tests
# ============================================================================

@test "gh_load_config_file: returns 1 when file doesn't exist" {
  run gh_load_config_file "/nonexistent/config/file"
  [ "$status" -eq 1 ]
}

@test "gh_load_config_file: returns 0 when file exists" {
  # Create a temporary config file
  setup_test_dir
  cat > config.test <<EOF
MAIN_BRANCH=main
DEVELOP_BRANCH=develop
EOF
  
  run gh_load_config_file "$TEST_DIR/config.test"
  status_code=$status
  teardown_test_dir
  
  [ "$status_code" -eq 0 ]
}

@test "gh_load_config_file: loads MAIN_BRANCH setting" {
  # Create a temporary config file
  setup_test_dir
  cat > config.test <<EOF
MAIN_BRANCH=trunk
EOF
  
  gh_load_config_file "$TEST_DIR/config.test"
  result="$GH_MAIN_BRANCH"
  teardown_test_dir
  
  [ "$result" = "trunk" ]
}

@test "gh_load_config_file: loads DEVELOP_BRANCH setting" {
  # Create a temporary config file
  setup_test_dir
  cat > config.test <<EOF
DEVELOP_BRANCH=dev
EOF
  
  gh_load_config_file "$TEST_DIR/config.test"
  result="$GH_DEVELOP_BRANCH"
  teardown_test_dir
  
  [ "$result" = "dev" ]
}

@test "gh_load_config_file: ignores comments" {
  # Create a temporary config file with comments
  setup_test_dir
  cat > config.test <<EOF
# This is a comment
MAIN_BRANCH=main
# Another comment
DEVELOP_BRANCH=develop
EOF
  
  gh_load_config_file "$TEST_DIR/config.test"
  main_result="$GH_MAIN_BRANCH"
  dev_result="$GH_DEVELOP_BRANCH"
  teardown_test_dir
  
  [ "$main_result" = "main" ]
  [ "$dev_result" = "develop" ]
}

@test "gh_load_config_file: ignores empty lines" {
  # Create a temporary config file with empty lines
  setup_test_dir
  cat > config.test <<EOF

MAIN_BRANCH=main

DEVELOP_BRANCH=develop

EOF
  
  gh_load_config_file "$TEST_DIR/config.test"
  main_result="$GH_MAIN_BRANCH"
  dev_result="$GH_DEVELOP_BRANCH"
  teardown_test_dir
  
  [ "$main_result" = "main" ]
  [ "$dev_result" = "develop" ]
}
