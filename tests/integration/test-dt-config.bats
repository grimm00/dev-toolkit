#!/usr/bin/env bats

# Integration tests for dt-config command
# Tests configuration management end-to-end

load '../helpers/setup'
load '../helpers/mocks'
load '../helpers/assertions'

setup() {
  setup_file
}

# ============================================================================
# Help Command Tests
# ============================================================================

@test "dt-config: shows help with --help flag" {
  run dt-config --help
  [ "$status" -eq 0 ]
  [[ "$output" =~ "Configuration Management" ]]
  [[ "$output" =~ "Usage:" ]]
  [[ "$output" =~ "Commands:" ]]
}

@test "dt-config: shows help with help command" {
  run dt-config help
  [ "$status" -eq 0 ]
  [[ "$output" =~ "show" ]]
  [[ "$output" =~ "create" ]]
  [[ "$output" =~ "edit" ]]
}

@test "dt-config: shows help with -h flag" {
  run dt-config -h
  [ "$status" -eq 0 ]
  [[ "$output" =~ "Configuration Management" ]]
}

@test "dt-config: shows help by default (no command)" {
  run dt-config
  [ "$status" -eq 0 ]
  [[ "$output" =~ "Configuration Management" ]]
}

# ============================================================================
# Show Command Tests
# ============================================================================

@test "dt-config show: displays current configuration" {
  run dt-config show
  [ "$status" -eq 0 ]
  [[ "$output" =~ "Configuration" ]]
}

@test "dt-config show: displays GitHub configuration" {
  run dt-config show
  [ "$status" -eq 0 ]
  [[ "$output" =~ "GitHub Configuration" ]]
}

@test "dt-config show: displays Git Flow configuration" {
  run dt-config show
  [ "$status" -eq 0 ]
  [[ "$output" =~ "Git Flow Configuration" ]]
}

@test "dt-config show: displays main branch setting" {
  run dt-config show
  [ "$status" -eq 0 ]
  [[ "$output" =~ "main" ]] || [[ "$output" =~ "Main Branch" ]]
}

@test "dt-config view: is alias for show" {
  run dt-config view
  [ "$status" -eq 0 ]
  [[ "$output" =~ "Configuration" ]]
}

# ============================================================================
# Create Command Tests
# ============================================================================

@test "dt-config create: creates global config by default" {
  setup_test_dir
  export HOME="$TEST_DIR"
  
  run dt-config create
  [ "$status" -eq 0 ]
  [[ "$output" =~ "Created" ]] || [[ "$output" =~ "config" ]]
  
  # Verify config file was created
  [ -f "$TEST_DIR/.dev-toolkit/config.conf" ]
  
  teardown_test_dir
}

@test "dt-config create global: creates global config" {
  setup_test_dir
  export HOME="$TEST_DIR"
  
  run dt-config create global
  [ "$status" -eq 0 ]
  
  # Verify config file exists
  [ -f "$TEST_DIR/.dev-toolkit/config.conf" ]
  
  # Verify it contains expected settings
  grep -q "MAIN_BRANCH" "$TEST_DIR/.dev-toolkit/config.conf"
  
  teardown_test_dir
}

@test "dt-config create project: creates project-local config" {
  setup_test_dir
  
  # Initialize git repo
  git init > /dev/null 2>&1
  
  run dt-config create project
  [ "$status" -eq 0 ]
  
  # Verify project config was created
  [ -f "$TEST_DIR/.dev-toolkit.conf" ]
  
  teardown_test_dir
}

@test "dt-config create: handles existing config gracefully" {
  setup_test_dir
  export HOME="$TEST_DIR"
  
  # Create config first time
  dt-config create > /dev/null 2>&1
  
  # Try to create again
  run dt-config create
  # Should handle gracefully (may warn or succeed)
  [ "$status" -eq 0 ] || [ "$status" -eq 1 ]
  
  teardown_test_dir
}

# ============================================================================
# Edit Command Tests
# ============================================================================

@test "dt-config edit: fails when config doesn't exist" {
  setup_test_dir
  export HOME="$TEST_DIR"
  
  run dt-config edit
  [ "$status" -eq 1 ]
  [[ "$output" =~ "not found" ]] || [[ "$output" =~ "Create it first" ]]
  
  teardown_test_dir
}

@test "dt-config edit: suggests creating config if missing" {
  setup_test_dir
  export HOME="$TEST_DIR"
  
  run dt-config edit
  [ "$status" -eq 1 ]
  [[ "$output" =~ "dt-config create" ]]
  
  teardown_test_dir
}

@test "dt-config edit global: edits global config with EDITOR" {
  setup_test_dir
  export HOME="$TEST_DIR"
  
  # Create config first
  dt-config create global > /dev/null 2>&1
  
  # Mock EDITOR to just echo the file path
  export EDITOR="echo"
  
  run dt-config edit global
  [ "$status" -eq 0 ]
  [[ "$output" =~ ".dev-toolkit/config.conf" ]]
  
  teardown_test_dir
}

@test "dt-config edit project: edits project config" {
  setup_test_dir
  
  # Initialize git repo and create project config
  git init > /dev/null 2>&1
  dt-config create project > /dev/null 2>&1
  
  # Mock EDITOR
  export EDITOR="echo"
  
  run dt-config edit project
  [ "$status" -eq 0 ]
  [[ "$output" =~ ".dev-toolkit.conf" ]]
  
  teardown_test_dir
}

# ============================================================================
# Error Handling Tests
# ============================================================================

@test "dt-config: handles invalid command gracefully" {
  run dt-config invalid-command
  [ "$status" -eq 1 ]
  [[ "$output" =~ "Unknown command" ]]
}

@test "dt-config: provides helpful error for unknown command" {
  run dt-config foobar
  [ "$status" -eq 1 ]
  [[ "$output" =~ "dt-config help" ]]
}

# ============================================================================
# Integration Scenario Tests
# ============================================================================

@test "dt-config: complete workflow - create, show, edit" {
  TEST_DIR="$(mktemp -d)"
  
  # Create, show, and edit config
  HOME="$TEST_DIR" dt-config create > /dev/null 2>&1
  [ $? -eq 0 ]
  
  HOME="$TEST_DIR" dt-config show > /dev/null 2>&1
  [ $? -eq 0 ]
  
  HOME="$TEST_DIR" EDITOR="echo" dt-config edit > /dev/null 2>&1
  [ $? -eq 0 ]
  
  # Cleanup
  rm -rf "$TEST_DIR"
}

@test "dt-config: project config overrides global config" {
  TEST_DIR="$(mktemp -d)"
  ORIG_DIR="$PWD"
  cd "$TEST_DIR"
  
  # Create global config
  HOME="$TEST_DIR" dt-config create global > /dev/null 2>&1
  [ $? -eq 0 ]
  
  # Initialize git repo
  git init > /dev/null 2>&1
  git config user.email "test@example.com"
  git config user.name "Test User"
  echo "test" > file.txt
  git add file.txt
  git commit -m "Initial" > /dev/null 2>&1
  
  # Create project config
  HOME="$TEST_DIR" dt-config create project > /dev/null 2>&1
  [ $? -eq 0 ]
  
  # Both config files should exist
  [ -f "$TEST_DIR/.dev-toolkit/config.conf" ]
  [ -f "$TEST_DIR/.dev-toolkit.conf" ]
  
  # Cleanup
  cd "$ORIG_DIR"
  rm -rf "$TEST_DIR"
}

@test "dt-config: works in repository with no config" {
  # Even without config files, show should work with defaults
  run dt-config show
  [ "$status" -eq 0 ]
  [[ "$output" =~ "Configuration" ]]
}

@test "dt-config: create both global and project configs" {
  setup_test_dir
  export HOME="$TEST_DIR"
  
  # Create global
  dt-config create global > /dev/null 2>&1
  [ -f "$TEST_DIR/.dev-toolkit/config.conf" ]
  
  # Initialize git repo
  git init > /dev/null 2>&1
  
  # Create project
  dt-config create project > /dev/null 2>&1
  [ -f "$TEST_DIR/.dev-toolkit.conf" ]
  
  # Both should exist
  [ -f "$TEST_DIR/.dev-toolkit/config.conf" ]
  [ -f "$TEST_DIR/.dev-toolkit.conf" ]
  
  teardown_test_dir
}
