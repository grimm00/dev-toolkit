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

# Mock gh pr view for Sourcery reviews
mock_gh_pr_view_success() {
  local pr_number="$1"
  local review_type="$2"
  
  gh() {
    if [ "$1" = "pr" ] && [ "$2" = "view" ] && [ "$3" = "$pr_number" ]; then
      case "$review_type" in
        "sourcery_review_with_overall_comments")
          cat <<EOF
{
  "reviews": [
    {
      "author": {"login": "sourcery-ai"},
      "body": "~~~markdown\n## Overall Comments\n\nThis is a test overall comment with multiple lines.\n\nIt should be preserved correctly.\n\n## Individual Comments\n\n### Comment 1\n\nThis is a test individual comment.\n\n~~~"
    }
  ]
}
EOF
          ;;
        "sourcery_review_individual_only")
          cat <<EOF
{
  "reviews": [
    {
      "author": {"login": "sourcery-ai"},
      "body": "~~~markdown\n## Individual Comments\n\n### Comment 1\n\nThis is a test individual comment.\n\n### Comment 2\n\nThis is another test individual comment.\n\n~~~"
    }
  ]
}
EOF
          ;;
        "sourcery_review_large_content")
          cat <<EOF
{
  "reviews": [
    {
      "author": {"login": "sourcery-ai"},
      "body": "~~~markdown\n## Overall Comments\n\nThis is a large review with lots of content.\n\n$(printf 'Line %d with content\n' {1..50})\n\n## Individual Comments\n\n### Comment 1\n\nLarge individual comment.\n\n$(printf 'Detail line %d\n' {1..20})\n\n~~~"
    }
  ]
}
EOF
          ;;
        "sourcery_review_special_chars")
          cat <<EOF
{
  "reviews": [
    {
      "author": {"login": "sourcery-ai"},
      "body": "~~~markdown\n## Overall Comments\n\nThis review contains special characters: & < > \" ' \`\n\n## Individual Comments\n\n### Comment 1\n\nSpecial chars: \$PATH, \$(command), \${variable}\n\n~~~"
    }
  ]
}
EOF
          ;;
      esac
    else
      command gh "$@"
    fi
  }
  export -f gh
}

# Mock gh pr view for no Sourcery review
mock_gh_pr_view_no_sourcery() {
  local pr_number="$1"
  
  gh() {
    if [ "$1" = "pr" ] && [ "$2" = "view" ] && [ "$3" = "$pr_number" ]; then
      cat <<EOF
{
  "reviews": [
    {
      "author": {"login": "other-user"},
      "body": "This is a regular review, not from Sourcery."
    }
  ]
}
EOF
    else
      command gh "$@"
    fi
  }
  export -f gh
}

# Mock gh pr view for not found
mock_gh_pr_view_not_found() {
  local pr_number="$1"
  
  gh() {
    if [ "$1" = "pr" ] && [ "$2" = "view" ] && [ "$3" = "$pr_number" ]; then
      echo "pull request #$pr_number not found" >&2
      return 1
    else
      command gh "$@"
    fi
  }
  export -f gh
}

# Mock gh pr view for network error
mock_gh_pr_view_error() {
  local pr_number="$1"
  local error_type="$2"
  
  gh() {
    if [ "$1" = "pr" ] && [ "$2" = "view" ] && [ "$3" = "$pr_number" ]; then
      case "$error_type" in
        "network_error")
          echo "API rate limit exceeded" >&2
          return 1
          ;;
        *)
          echo "Unknown error" >&2
          return 1
          ;;
      esac
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
