#!/usr/bin/env bats

# Integration tests for dt-review command
# Tests dt-review wrapper functionality end-to-end

load '../helpers/setup'
load '../helpers/mocks'
load '../helpers/assertions'

setup() {
  setup_file
}

# ============================================================================
# Help Command Tests
# ============================================================================

@test "dt-review: shows help with --help flag" {
  run dt-review --help
  [ "$status" -eq 0 ]
  [[ "$output" =~ "dt-review" ]]
  [[ "$output" =~ "Usage:" ]]
  [[ "$output" =~ "convenience wrapper" ]]
}

@test "dt-review: shows help with -h flag" {
  run dt-review -h
  [ "$status" -eq 0 ]
  [[ "$output" =~ "dt-review" ]]
  [[ "$output" =~ "Usage:" ]]
}

@test "dt-review: shows help with no arguments" {
  run dt-review
  [ "$status" -eq 1 ]
  [[ "$output" =~ "Usage:" ]]
}

# ============================================================================
# Core Functionality Tests
# ============================================================================

@test "dt-review: creates default output file with valid PR" {
  # Mock successful Sourcery review
  mock_gh_pr_view_success "9" "sourcery_review_with_overall_comments"
  
  run dt-review 9
  [ "$status" -eq 0 ]
  [[ "$output" =~ "Review saved to:" ]]
  [[ "$output" =~ "admin/feedback/sourcery/pr09.md" ]]
  
  # Verify file was created
  [ -f "admin/feedback/sourcery/pr09.md" ]
  
  # Verify file contains expected content
  run cat "admin/feedback/sourcery/pr09.md"
  [[ "$output" =~ "Sourcery Review Analysis" ]]
  [[ "$output" =~ "PR.*#9" ]]
}

@test "dt-review: creates custom output file with valid PR" {
  # Mock successful Sourcery review
  mock_gh_pr_view_success "9" "sourcery_review_with_overall_comments"
  
  local custom_output="/tmp/test-review.md"
  run dt-review 9 "$custom_output"
  [ "$status" -eq 0 ]
  [[ "$output" =~ "Review saved to:" ]]
  [[ "$output" =~ "$custom_output" ]]
  
  # Verify file was created
  [ -f "$custom_output" ]
  
  # Verify file contains expected content
  run cat "$custom_output"
  [[ "$output" =~ "Sourcery Review Analysis" ]]
  [[ "$output" =~ "PR.*#9" ]]
  
  # Cleanup
  rm -f "$custom_output"
}

@test "dt-review: handles PR with Overall Comments" {
  # Mock Sourcery review with Overall Comments
  mock_gh_pr_view_success "9" "sourcery_review_with_overall_comments"
  
  run dt-review 9
  [ "$status" -eq 0 ]
  
  # Verify Overall Comments are included
  run cat "admin/feedback/sourcery/pr09.md"
  [[ "$output" =~ "## Overall Comments" ]]
  [[ "$output" =~ "Total Individual Comments.*Overall Comments" ]]
}

@test "dt-review: handles PR with only Individual Comments" {
  # Mock Sourcery review with only Individual Comments
  mock_gh_pr_view_success "10" "sourcery_review_individual_only"
  
  run dt-review 10
  [ "$status" -eq 0 ]
  
  # Verify Individual Comments are included
  run cat "admin/feedback/sourcery/pr10.md"
  [[ "$output" =~ "## Individual Comments" ]]
  [[ "$output" =~ "Total Individual Comments:" ]]
}

@test "dt-review: handles PR with no Sourcery review" {
  # Mock PR with no Sourcery review
  mock_gh_pr_view_no_sourcery "11"
  
  run dt-review 11
  [ "$status" -eq 0 ]
  [[ "$output" =~ "No Sourcery review found" ]]
  [[ "$output" =~ "Sourcery is optional" ]]
}

# ============================================================================
# Error Handling Tests
# ============================================================================

@test "dt-review: handles invalid PR number format" {
  run dt-review "abc"
  [ "$status" -ne 0 ]
  [[ "$output" =~ "Error" ]] || [[ "$output" =~ "Invalid" ]]
}

@test "dt-review: handles non-existent PR number" {
  # Mock non-existent PR
  mock_gh_pr_view_not_found "99999"
  
  run dt-review 99999
  [ "$status" -ne 0 ]
  [[ "$output" =~ "Error" ]] || [[ "$output" =~ "not found" ]]
}

@test "dt-review: handles network/API errors" {
  # Mock network error
  mock_gh_pr_view_error "12" "network_error"
  
  run dt-review 12
  [ "$status" -ne 0 ]
  [[ "$output" =~ "Error" ]] || [[ "$output" =~ "Failed" ]]
}

@test "dt-review: handles permission issues with output file" {
  # Mock successful Sourcery review
  mock_gh_pr_view_success "9" "sourcery_review_with_overall_comments"
  
  # Create read-only directory
  local readonly_dir="/tmp/readonly_test"
  mkdir -p "$readonly_dir"
  chmod 444 "$readonly_dir"
  
  run dt-review 9 "$readonly_dir/test.md"
  [ "$status" -ne 0 ]
  [[ "$output" =~ "Error" ]] || [[ "$output" =~ "Permission" ]]
  
  # Cleanup
  chmod 755 "$readonly_dir"
  rm -rf "$readonly_dir"
}

# ============================================================================
# Context Tests (Local vs Global Parser)
# ============================================================================

@test "dt-review: uses local parser when in dev-toolkit directory" {
  # Mock successful Sourcery review
  mock_gh_pr_view_success "9" "sourcery_review_with_overall_comments"
  
  # Ensure we're in dev-toolkit directory
  [ -f "bin/dt-review" ]
  [ -f "lib/sourcery/parser.sh" ]
  
  run dt-review 9
  [ "$status" -eq 0 ]
  
  # Verify Overall Comments are extracted (indicates local parser usage)
  run cat "admin/feedback/sourcery/pr09.md"
  [[ "$output" =~ "## Overall Comments" ]]
  [[ "$output" =~ "Total Individual Comments.*Overall Comments" ]]
}

@test "dt-review: provides helpful error when toolkit not found" {
  # Temporarily move dt-review to simulate missing toolkit
  local temp_review="/tmp/dt-review-test"
  cp "bin/dt-review" "$temp_review"
  
  # Mock environment without DT_ROOT and without local files
  run env -i PATH="/usr/bin:/bin" "$temp_review" 9
  [ "$status" -ne 0 ]
  [[ "$output" =~ "Cannot locate dev-toolkit installation" ]]
  [[ "$output" =~ "Set DT_ROOT environment variable" ]]
  
  # Cleanup
  rm -f "$temp_review"
}

# ============================================================================
# Edge Case Tests
# ============================================================================

@test "dt-review: handles PR with large review content" {
  # Mock Sourcery review with large content
  mock_gh_pr_view_success "13" "sourcery_review_large_content"
  
  run dt-review 13
  [ "$status" -eq 0 ]
  
  # Verify file was created and contains content
  [ -f "admin/feedback/sourcery/pr13.md" ]
  run wc -l "admin/feedback/sourcery/pr13.md"
  [ "${lines[0]}" -gt 10 ]  # Should have substantial content
}

@test "dt-review: handles PR with special characters in content" {
  # Mock Sourcery review with special characters
  mock_gh_pr_view_success "14" "sourcery_review_special_chars"
  
  run dt-review 14
  [ "$status" -eq 0 ]
  
  # Verify file was created and content is properly escaped
  [ -f "admin/feedback/sourcery/pr14.md" ]
  run cat "admin/feedback/sourcery/pr14.md"
  [[ "$output" =~ "Sourcery Review Analysis" ]]
}

@test "dt-review: handles custom output path with spaces" {
  # Mock successful Sourcery review
  mock_gh_pr_view_success "9" "sourcery_review_with_overall_comments"
  
  local custom_output="/tmp/test review with spaces.md"
  run dt-review 9 "$custom_output"
  [ "$status" -eq 0 ]
  
  # Verify file was created
  [ -f "$custom_output" ]
  
  # Cleanup
  rm -f "$custom_output"
}

@test "dt-review: handles custom output path in non-existent directory" {
  # Mock successful Sourcery review
  mock_gh_pr_view_success "9" "sourcery_review_with_overall_comments"
  
  local custom_output="/tmp/nonexistent/test.md"
  run dt-review 9 "$custom_output"
  [ "$status" -ne 0 ]
  [[ "$output" =~ "Error" ]] || [[ "$output" =~ "No such file or directory" ]]
}

# ============================================================================
# Output Format Tests
# ============================================================================

@test "dt-review: output includes helpful usage information" {
  # Mock successful Sourcery review
  mock_gh_pr_view_success "9" "sourcery_review_with_overall_comments"
  
  run dt-review 9
  [ "$status" -eq 0 ]
  [[ "$output" =~ "💡 View the review:" ]]
  [[ "$output" =~ "cat admin/feedback/sourcery/pr09.md" ]]
  [[ "$output" =~ "code admin/feedback/sourcery/pr09.md" ]]
}

@test "dt-review: output includes success confirmation" {
  # Mock successful Sourcery review
  mock_gh_pr_view_success "9" "sourcery_review_with_overall_comments"
  
  run dt-review 9
  [ "$status" -eq 0 ]
  [[ "$output" =~ "✅ Review saved to:" ]]
  [[ "$output" =~ "Sourcery review parsing completed" ]]
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
