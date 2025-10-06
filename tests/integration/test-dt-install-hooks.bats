#!/usr/bin/env bats

# Integration tests for dt-install-hooks command
# Tests Git hooks installation end-to-end

load '../helpers/setup'
load '../helpers/mocks'
load '../helpers/assertions'

setup() {
  setup_file
}

# ============================================================================
# Basic Installation Tests
# ============================================================================

@test "dt-install-hooks: shows header and information" {
  TEST_DIR="$(mktemp -d)"
  cd "$TEST_DIR"
  
  git init > /dev/null 2>&1
  
  # Install with auto-yes
  run bash -c "echo 'n' | dt-install-hooks"
  [ "$status" -eq 0 ]
  [[ "$output" =~ "Git Hooks Installer" ]]
  
  cd - > /dev/null
  rm -rf "$TEST_DIR"
}

@test "dt-install-hooks: installs pre-commit hook in git repo" {
  TEST_DIR="$(mktemp -d)"
  cd "$TEST_DIR"
  
  git init > /dev/null 2>&1
  
  # Install hook (auto-yes)
  bash -c "echo 'y' | dt-install-hooks" > /dev/null 2>&1
  
  # Verify hook was installed
  [ -f ".git/hooks/pre-commit" ]
  [ -x ".git/hooks/pre-commit" ]
  
  cd - > /dev/null
  rm -rf "$TEST_DIR"
}

@test "dt-install-hooks: creates hooks directory if missing" {
  TEST_DIR="$(mktemp -d)"
  cd "$TEST_DIR"
  
  git init > /dev/null 2>&1
  
  # Remove hooks directory
  rm -rf ".git/hooks"
  
  # Install should create it
  bash -c "echo 'y' | dt-install-hooks" > /dev/null 2>&1
  
  # Verify directory and hook exist
  [ -d ".git/hooks" ]
  [ -f ".git/hooks/pre-commit" ]
  
  cd - > /dev/null
  rm -rf "$TEST_DIR"
}

@test "dt-install-hooks: makes hook executable" {
  TEST_DIR="$(mktemp -d)"
  cd "$TEST_DIR"
  
  git init > /dev/null 2>&1
  
  bash -c "echo 'y' | dt-install-hooks" > /dev/null 2>&1
  
  # Check executable bit
  [ -x ".git/hooks/pre-commit" ]
  
  cd - > /dev/null
  rm -rf "$TEST_DIR"
}

# ============================================================================
# Error Handling Tests
# ============================================================================

@test "dt-install-hooks: fails gracefully outside git repository" {
  TEST_DIR="$(mktemp -d)"
  cd "$TEST_DIR"
  
  # Not a git repo
  run dt-install-hooks
  [ "$status" -eq 1 ]
  [[ "$output" =~ "Not in a git repository" ]]
  
  cd - > /dev/null
  rm -rf "$TEST_DIR"
}

@test "dt-install-hooks: provides helpful error outside git repo" {
  TEST_DIR="$(mktemp -d)"
  cd "$TEST_DIR"
  
  run dt-install-hooks
  [ "$status" -eq 1 ]
  [[ "$output" =~ "Run this command from within a git repository" ]]
  
  cd - > /dev/null
  rm -rf "$TEST_DIR"
}

# ============================================================================
# Existing Hook Tests
# ============================================================================

@test "dt-install-hooks: detects existing hook" {
  TEST_DIR="$(mktemp -d)"
  cd "$TEST_DIR"
  
  git init > /dev/null 2>&1
  
  # Install first time
  bash -c "echo 'y' | dt-install-hooks" > /dev/null 2>&1
  
  # Try to install again
  run bash -c "echo 'n' | dt-install-hooks"
  [ "$status" -eq 0 ]
  [[ "$output" =~ "already exists" ]]
  
  cd - > /dev/null
  rm -rf "$TEST_DIR"
}

@test "dt-install-hooks: prompts to overwrite existing hook" {
  TEST_DIR="$(mktemp -d)"
  cd "$TEST_DIR"
  
  git init > /dev/null 2>&1
  
  # Create existing hook
  mkdir -p ".git/hooks"
  echo "#!/bin/bash" > ".git/hooks/pre-commit"
  
  # Should detect existing hook and skip when declined
  run bash -c "echo 'n' | dt-install-hooks"
  [[ "$output" =~ "already exists" ]]
  [[ "$output" =~ "Skipping" ]]
  
  cd - > /dev/null
  rm -rf "$TEST_DIR"
}

@test "dt-install-hooks: skips installation when user declines" {
  TEST_DIR="$(mktemp -d)"
  cd "$TEST_DIR"
  
  git init > /dev/null 2>&1
  
  # Create existing hook with custom content
  mkdir -p ".git/hooks"
  echo "# CUSTOM HOOK" > ".git/hooks/pre-commit"
  
  # Decline overwrite
  bash -c "echo 'n' | dt-install-hooks" > /dev/null 2>&1
  
  # Original hook should still exist
  grep -q "CUSTOM HOOK" ".git/hooks/pre-commit"
  
  cd - > /dev/null
  rm -rf "$TEST_DIR"
}

@test "dt-install-hooks: overwrites when user confirms" {
  TEST_DIR="$(mktemp -d)"
  cd "$TEST_DIR"
  
  git init > /dev/null 2>&1
  
  # Create existing hook
  mkdir -p ".git/hooks"
  echo "# OLD HOOK" > ".git/hooks/pre-commit"
  
  # Accept overwrite
  bash -c "echo 'y' | dt-install-hooks" > /dev/null 2>&1
  
  # Hook should be replaced
  ! grep -q "OLD HOOK" ".git/hooks/pre-commit"
  
  cd - > /dev/null
  rm -rf "$TEST_DIR"
}

# ============================================================================
# Hook Content Tests
# ============================================================================

@test "dt-install-hooks: installed hook contains safety checks" {
  TEST_DIR="$(mktemp -d)"
  cd "$TEST_DIR"
  
  git init > /dev/null 2>&1
  
  bash -c "echo 'y' | dt-install-hooks" > /dev/null 2>&1
  
  # Verify hook has expected content
  grep -q "pre-commit" ".git/hooks/pre-commit"
  
  cd - > /dev/null
  rm -rf "$TEST_DIR"
}

@test "dt-install-hooks: installed hook is valid bash script" {
  TEST_DIR="$(mktemp -d)"
  cd "$TEST_DIR"
  
  git init > /dev/null 2>&1
  
  bash -c "echo 'y' | dt-install-hooks" > /dev/null 2>&1
  
  # Check syntax
  bash -n ".git/hooks/pre-commit"
  [ $? -eq 0 ]
  
  cd - > /dev/null
  rm -rf "$TEST_DIR"
}

# ============================================================================
# Information Display Tests
# ============================================================================

@test "dt-install-hooks: shows what the hook does" {
  TEST_DIR="$(mktemp -d)"
  cd "$TEST_DIR"
  
  git init > /dev/null 2>&1
  
  run bash -c "echo 'y' | dt-install-hooks"
  [[ "$output" =~ "What this hook does" ]]
  [[ "$output" =~ "branch safety" ]]
  
  cd - > /dev/null
  rm -rf "$TEST_DIR"
}

@test "dt-install-hooks: shows how to test the hook" {
  TEST_DIR="$(mktemp -d)"
  cd "$TEST_DIR"
  
  git init > /dev/null 2>&1
  
  run bash -c "echo 'y' | dt-install-hooks"
  [[ "$output" =~ "To test the hook" ]]
  [[ "$output" =~ "git commit" ]]
  
  cd - > /dev/null
  rm -rf "$TEST_DIR"
}

@test "dt-install-hooks: shows how to bypass the hook" {
  TEST_DIR="$(mktemp -d)"
  cd "$TEST_DIR"
  
  git init > /dev/null 2>&1
  
  run bash -c "echo 'y' | dt-install-hooks"
  [[ "$output" =~ "To bypass" ]]
  [[ "$output" =~ "--no-verify" ]]
  
  cd - > /dev/null
  rm -rf "$TEST_DIR"
}

# ============================================================================
# Integration Scenario Tests
# ============================================================================

@test "dt-install-hooks: complete workflow - install and verify" {
  TEST_DIR="$(mktemp -d)"
  cd "$TEST_DIR"
  
  # Initialize repo
  git init > /dev/null 2>&1
  git config user.email "test@example.com"
  git config user.name "Test User"
  
  # Install hooks
  bash -c "echo 'y' | dt-install-hooks" > /dev/null 2>&1
  
  # Verify installation
  [ -f ".git/hooks/pre-commit" ]
  [ -x ".git/hooks/pre-commit" ]
  
  # Verify hook syntax is valid
  bash -n ".git/hooks/pre-commit"
  [ $? -eq 0 ]
  
  cd - > /dev/null
  rm -rf "$TEST_DIR"
}

@test "dt-install-hooks: works in nested git repository" {
  TEST_DIR="$(mktemp -d)"
  cd "$TEST_DIR"
  
  # Create nested structure
  git init > /dev/null 2>&1
  mkdir -p subdir/nested
  cd subdir/nested
  
  # Install from nested directory
  bash -c "echo 'y' | dt-install-hooks" > /dev/null 2>&1
  
  # Hook should be in root .git directory
  [ -f "../../.git/hooks/pre-commit" ]
  
  cd - > /dev/null
  rm -rf "$TEST_DIR"
}
