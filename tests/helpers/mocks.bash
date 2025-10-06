#!/usr/bin/env bash

# Mock functions for external commands

# Mock git remote to return specific URL
mock_git_remote() {
  local url="$1"
  git() {
    if [ "$1" = "remote" ] && [ "$2" = "get-url" ]; then
      echo "$url"
    else
      command git "$@"
    fi
  }
  export -f git
}

# Mock gh repo view to return specific data
mock_gh_repo_view() {
  local owner="$1"
  local repo="$2"
  gh() {
    if [ "$1" = "repo" ] && [ "$2" = "view" ]; then
      cat <<EOF
{
  "owner": {"login": "$owner"},
  "name": "$repo",
  "nameWithOwner": "$owner/$repo"
}
EOF
    else
      command gh "$@"
    fi
  }
  export -f gh
}

# Restore original commands
restore_commands() {
  unset -f git gh 2>/dev/null || true
}
