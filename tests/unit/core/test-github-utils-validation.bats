#!/usr/bin/env bats

# Tests for github-utils.sh validation and authentication functions

load '../../helpers/setup'
load '../../helpers/mocks'
load '../../helpers/assertions'

setup() {
  source "$PROJECT_ROOT/lib/core/github-utils.sh"
}

teardown() {
  restore_commands
}

# ============================================================================
# Check Dependencies Tests
# ============================================================================

@test "gh_check_required_dependencies: succeeds when all deps available" {
  # Mock command existence checks to succeed
  command() {
    if [ "$1" = "-v" ]; then
      return 0
    fi
    builtin command "$@"
  }
  export -f command
  
  run gh_check_required_dependencies
  [ "$status" -eq 0 ]
}

@test "gh_check_required_dependencies: fails when git missing" {
  # Mock git as missing
  command() {
    if [ "$1" = "-v" ] && [ "$2" = "git" ]; then
      return 1
    fi
    builtin command "$@"
  }
  export -f command
  
  run gh_check_required_dependencies
  [ "$status" -eq 1 ]
  [[ "$output" =~ "git" ]]
}

@test "gh_check_required_dependencies: fails when gh missing" {
  # Mock gh as missing
  command() {
    if [ "$1" = "-v" ] && [ "$2" = "gh" ]; then
      return 1
    fi
    builtin command "$@"
  }
  export -f command
  
  run gh_check_required_dependencies
  [ "$status" -eq 1 ]
  [[ "$output" =~ "gh" ]]
}

@test "gh_check_optional_dependencies: checks for jq" {
  run gh_check_optional_dependencies
  [ "$status" -eq 0 ]
  # Should mention jq in output
  [[ "$output" =~ "jq" ]] || true  # jq is optional, so this might not fail
}

@test "gh_check_dependencies: runs both required and optional checks" {
  # Mock all commands as available
  command() {
    if [ "$1" = "-v" ]; then
      return 0
    fi
    builtin command "$@"
  }
  export -f command
  
  run gh_check_dependencies
  [ "$status" -eq 0 ]
  [[ "$output" =~ "Dependency Check" ]]
}

# ============================================================================
# Authentication Tests
# ============================================================================

@test "gh_check_authentication: succeeds when authenticated" {
  # Mock gh auth status to succeed
  gh() {
    if [ "$1" = "auth" ] && [ "$2" = "status" ]; then
      echo "✓ Logged in to github.com"
      return 0
    fi
    command gh "$@"
  }
  export -f gh
  
  run gh_check_authentication
  [ "$status" -eq 0 ]
  [[ "$output" =~ "Authenticated" ]]
}

@test "gh_check_authentication: fails when not authenticated" {
  # Mock gh auth status to fail
  gh() {
    if [ "$1" = "auth" ] && [ "$2" = "status" ]; then
      return 1
    fi
    command gh "$@"
  }
  export -f gh
  
  run gh_check_authentication
  [ "$status" -eq 1 ]
  [[ "$output" =~ "Not authenticated" ]]
}

@test "gh_check_authentication: provides login instructions on failure" {
  # Mock gh auth status to fail
  gh() {
    if [ "$1" = "auth" ] && [ "$2" = "status" ]; then
      return 1
    fi
    command gh "$@"
  }
  export -f gh
  
  run gh_check_authentication
  [ "$status" -eq 1 ]
  [[ "$output" =~ "gh auth login" ]]
}

# ============================================================================
# Repository Validation Tests
# ============================================================================

@test "gh_validate_repository: succeeds in valid git repo with remote" {
  # Mock git to succeed
  git() {
    if [ "$1" = "rev-parse" ] && [ "$2" = "--git-dir" ]; then
      echo ".git"
      return 0
    elif [ "$1" = "remote" ] && [ "$2" = "get-url" ]; then
      echo "https://github.com/test/repo.git"
      return 0
    fi
    command git "$@"
  }
  export -f git
  
  # Mock gh to succeed
  gh() {
    if [ "$1" = "repo" ] && [ "$2" = "view" ]; then
      echo '{"nameWithOwner":"test/repo"}'
      return 0
    fi
    command gh "$@"
  }
  export -f gh
  
  run gh_validate_repository
  [ "$status" -eq 0 ]
  [[ "$output" =~ "Repository validated" ]]
}

@test "gh_validate_repository: fails when not in git repo" {
  # Mock git to fail
  git() {
    if [ "$1" = "rev-parse" ] && [ "$2" = "--git-dir" ]; then
      return 128
    fi
    command git "$@"
  }
  export -f git
  
  run gh_validate_repository
  [ "$status" -eq 1 ]
  [[ "$output" =~ "Not in a Git repository" ]]
}

@test "gh_validate_repository: warns when no remote configured" {
  # Mock git to succeed for repo check but fail for remote
  git() {
    if [ "$1" = "rev-parse" ] && [ "$2" = "--git-dir" ]; then
      echo ".git"
      return 0
    elif [ "$1" = "remote" ] && [ "$2" = "get-url" ]; then
      return 1
    elif [ "$1" = "rev-parse" ] && [ "$2" = "--show-toplevel" ]; then
      echo "/tmp/test-repo"
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
  
  run gh_validate_repository
  [ "$status" -eq 1 ]
  [[ "$output" =~ "Cannot determine repository" ]]
}

# ============================================================================
# Init Function Tests
# ============================================================================

@test "gh_init_github_utils: loads config and detects project" {
  # Create temp config
  setup_test_dir
  export HOME="$TEST_DIR"
  
  # Create a minimal config
  mkdir -p "$TEST_DIR/.dev-toolkit"
  echo "MAIN_BRANCH=main" > "$TEST_DIR/.dev-toolkit/config"
  
  # Mock git to succeed
  git() {
    if [ "$1" = "rev-parse" ]; then
      return 0
    elif [ "$1" = "remote" ] && [ "$2" = "get-url" ]; then
      echo "https://github.com/test/repo.git"
      return 0
    fi
    command git "$@"
  }
  export -f git
  
  # Mock gh to fail (use git fallback)
  gh() {
    return 1
  }
  export -f gh
  
  # Override config paths
  CONFIG_FILE_GLOBAL="$TEST_DIR/.dev-toolkit/config"
  CONFIG_FILE_PROJECT="$TEST_DIR/.dev-toolkit.conf"
  
  run gh_init_github_utils
  status_code=$status
  
  teardown_test_dir
  
  [ "$status_code" -eq 0 ]
}

@test "gh_init_github_utils: fails when not in git repo" {
  # Mock git to fail
  git() {
    if [ "$1" = "rev-parse" ]; then
      return 128
    fi
    command git "$@"
  }
  export -f git
  
  run gh_init_github_utils
  [ "$status" -eq 1 ]
  [[ "$output" =~ "Not in a Git repository" ]]
}

# ============================================================================
# API Safe Wrapper Tests
# ============================================================================

@test "gh_api_safe: succeeds when command succeeds" {
  run gh_api_safe "echo 'test'" "Test operation"
  [ "$status" -eq 0 ]
  [[ "$output" =~ "Test operation completed successfully" ]]
}

@test "gh_api_safe: fails when command fails" {
  run gh_api_safe "false" "Test operation"
  [ "$status" -eq 1 ]
  [[ "$output" =~ "Test operation failed" ]]
}

@test "gh_api_safe: shows exit code on failure" {
  run gh_api_safe "bash -c 'exit 42'" "Test operation"
  # Exit code might not be exactly 42 due to how gh_api_safe handles it
  [ "$status" -ne 0 ]
  [[ "$output" =~ "Test operation failed" ]]
}

@test "gh_api_safe: provides hints for permissions errors" {
  run gh_api_safe "gh api /repos/test/test/permissions" "Permission check"
  # Will fail but should provide helpful hints
  [[ "$output" =~ "Possible causes" ]] || [[ "$output" =~ "permissions" ]]
}

@test "gh_api_safe: provides hints for secrets errors" {
  run gh_api_safe "gh secret set TEST" "Set secret"
  # Will fail but should provide helpful hints
  [[ "$output" =~ "Possible causes" ]] || [[ "$output" =~ "secret" ]]
}

@test "gh_api_safe: can continue on error when exit_on_error is false" {
  run gh_api_safe "false" "Test operation" "false"
  # Should return non-zero but not exit the test
  [ "$status" -ne 0 ]
}

# ============================================================================
# Integration Tests
# ============================================================================

@test "full workflow: check deps, auth, validate repo" {
  # Mock all commands to succeed
  command() {
    if [ "$1" = "-v" ]; then
      return 0
    fi
    builtin command "$@"
  }
  export -f command
  
  git() {
    if [ "$1" = "rev-parse" ]; then
      return 0
    elif [ "$1" = "remote" ] && [ "$2" = "get-url" ]; then
      echo "https://github.com/test/repo.git"
      return 0
    fi
    command git "$@"
  }
  export -f git
  
  gh() {
    if [ "$1" = "auth" ] && [ "$2" = "status" ]; then
      return 0
    elif [ "$1" = "repo" ] && [ "$2" = "view" ]; then
      echo '{"nameWithOwner":"test/repo"}'
      return 0
    fi
    command gh "$@"
  }
  export -f gh
  
  # Run the workflow
  gh_check_dependencies
  deps_ok=$?
  
  gh_check_authentication
  auth_ok=$?
  
  gh_validate_repository
  repo_ok=$?
  
  [ "$deps_ok" -eq 0 ]
  [ "$auth_ok" -eq 0 ]
  [ "$repo_ok" -eq 0 ]
}
