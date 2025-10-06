#!/usr/bin/env bats

# Integration tests for dt-git-safety command
# Tests the command wrapper end-to-end in real scenarios

load '../helpers/setup'
load '../helpers/mocks'
load '../helpers/assertions'

setup() {
  setup_file
}

# ============================================================================
# Help Command Tests
# ============================================================================

@test "dt-git-safety: shows help with --help flag" {
  run dt-git-safety --help
  [ "$status" -eq 0 ]
  [[ "$output" =~ "Git Flow Safety Checks" ]]
  [[ "$output" =~ "Usage:" ]]
  [[ "$output" =~ "Commands:" ]]
}

@test "dt-git-safety: shows help with help command" {
  run dt-git-safety help
  [ "$status" -eq 0 ]
  [[ "$output" =~ "Git Flow Safety Checks" ]]
  [[ "$output" =~ "check" ]]
  [[ "$output" =~ "branch" ]]
  [[ "$output" =~ "conflicts" ]]
}

@test "dt-git-safety: shows help with -h flag" {
  run dt-git-safety -h
  [ "$status" -eq 0 ]
  [[ "$output" =~ "Git Flow Safety Checks" ]]
}

# ============================================================================
# Branch Safety Check Tests
# ============================================================================

@test "dt-git-safety branch: passes on feature branch" {
  # We're in the dev-toolkit repo on a feature branch
  run dt-git-safety branch
  # Should pass (status 0) or warn (status 0) but not error
  [ "$status" -eq 0 ] || [ "$status" -eq 1 ]
  [[ "$output" =~ "Branch Safety Check" ]]
}

@test "dt-git-safety branch: detects when on protected branch" {
  # Create a temporary git repo and test
  setup_test_dir
  
  git init > /dev/null 2>&1
  git config user.email "test@example.com"
  git config user.name "Test User"
  
  # Create initial commit
  echo "test" > file.txt
  git add file.txt
  git commit -m "Initial commit" > /dev/null 2>&1
  
  # We're on main (or master) by default
  run dt-git-safety branch
  [ "$status" -eq 1 ]
  [[ "$output" =~ "protected branch" ]]
  
  teardown_test_dir
}

@test "dt-git-safety branch: validates branch naming conventions" {
  setup_test_dir
  
  git init > /dev/null 2>&1
  git config user.email "test@example.com"
  git config user.name "Test User"
  
  echo "test" > file.txt
  git add file.txt
  git commit -m "Initial" > /dev/null 2>&1
  
  # Create a branch with unusual name
  git checkout -b unusual-branch-name > /dev/null 2>&1
  
  run dt-git-safety branch
  # Should warn about unusual branch name
  [[ "$output" =~ "Unusual branch name" ]] || [[ "$output" =~ "conventional branch" ]]
  
  teardown_test_dir
}

# ============================================================================
# Merge Conflicts Check Tests
# ============================================================================

@test "dt-git-safety conflicts: runs conflict check" {
  run dt-git-safety conflicts
  # Should run without crashing
  [ "$status" -ne 127 ]
  [[ "$output" =~ "Merge Conflict Check" ]]
}

@test "dt-git-safety conflicts: skips check on protected branches" {
  setup_test_dir
  
  git init > /dev/null 2>&1
  git config user.email "test@example.com"
  git config user.name "Test User"
  
  echo "test" > file.txt
  git add file.txt
  git commit -m "Initial" > /dev/null 2>&1
  
  # On main branch (protected)
  run dt-git-safety conflicts
  [[ "$output" =~ "Skipping conflict check" ]] || [ "$status" -eq 0 ]
  
  teardown_test_dir
}

# ============================================================================
# Repository Health Check Tests
# ============================================================================

@test "dt-git-safety health: checks repository health" {
  run dt-git-safety health
  [ "$status" -ne 127 ]
  [[ "$output" =~ "Repository Health" ]] || [[ "$output" =~ "health" ]]
}

@test "dt-git-safety health: runs git fsck" {
  # In a valid repo, health check should pass
  run dt-git-safety health
  # Should complete (may pass or fail depending on repo state)
  [ "$status" -ne 127 ]
}

# ============================================================================
# Pull Requests Check Tests
# ============================================================================

@test "dt-git-safety prs: checks for open pull requests" {
  run dt-git-safety prs
  [ "$status" -ne 127 ]
  [[ "$output" =~ "Pull Request" ]] || [[ "$output" =~ "PR" ]]
}

# ============================================================================
# Full Safety Check Tests
# ============================================================================

@test "dt-git-safety check: runs all safety checks" {
  run dt-git-safety check
  [ "$status" -ne 127 ]
  [[ "$output" =~ "Safety Check" ]] || [[ "$output" =~ "Branch" ]]
}

@test "dt-git-safety: runs check by default (no command)" {
  run dt-git-safety
  [ "$status" -ne 127 ]
  # Should run the default check command
  [[ "$output" =~ "Safety" ]] || [[ "$output" =~ "Branch" ]]
}

# ============================================================================
# Error Handling Tests
# ============================================================================

@test "dt-git-safety: handles invalid command gracefully" {
  run dt-git-safety invalid-command
  [ "$status" -eq 1 ]
  [[ "$output" =~ "Unknown command" ]]
}

@test "dt-git-safety: fails gracefully outside git repository" {
  setup_test_dir
  
  # Not a git repo
  run dt-git-safety branch
  [ "$status" -eq 1 ]
  [[ "$output" =~ "Not in a Git repository" ]] || [[ "$output" =~ "not a git repository" ]]
  
  teardown_test_dir
}

# ============================================================================
# Auto-fix Suggestions Tests
# ============================================================================

@test "dt-git-safety fix: shows auto-fix suggestions" {
  run dt-git-safety fix
  [ "$status" -ne 127 ]
  [[ "$output" =~ "Auto-Fix" ]] || [[ "$output" =~ "Suggestions" ]]
}

@test "dt-git-safety fix: suggests feature branch when on protected branch" {
  setup_test_dir
  
  git init > /dev/null 2>&1
  git config user.email "test@example.com"
  git config user.name "Test User"
  
  echo "test" > file.txt
  git add file.txt
  git commit -m "Initial" > /dev/null 2>&1
  
  # On main branch
  run dt-git-safety fix
  [[ "$output" =~ "feature branch" ]] || [[ "$output" =~ "feat/" ]]
  
  teardown_test_dir
}

# ============================================================================
# Integration Scenario Tests
# ============================================================================

@test "dt-git-safety: complete workflow on feature branch" {
  setup_test_dir
  
  git init > /dev/null 2>&1
  git config user.email "test@example.com"
  git config user.name "Test User"
  
  echo "test" > file.txt
  git add file.txt
  git commit -m "Initial" > /dev/null 2>&1
  
  # Create feature branch
  git checkout -b feat/test-feature > /dev/null 2>&1
  
  # Run full safety check
  run dt-git-safety check
  # Should pass on feature branch
  [ "$status" -eq 0 ] || [ "$status" -eq 1 ]
  
  # Branch check should pass
  run dt-git-safety branch
  [ "$status" -eq 0 ]
  
  teardown_test_dir
}

@test "dt-git-safety: detects issues on protected branch" {
  setup_test_dir
  
  git init > /dev/null 2>&1
  git config user.email "test@example.com"
  git config user.name "Test User"
  
  echo "test" > file.txt
  git add file.txt
  git commit -m "Initial" > /dev/null 2>&1
  
  # Stay on main branch (protected)
  run dt-git-safety branch
  [ "$status" -eq 1 ]
  [[ "$output" =~ "protected" ]]
  
  # Auto-fix should suggest solution
  run dt-git-safety fix
  [[ "$output" =~ "feat/" ]]
  
  teardown_test_dir
}
