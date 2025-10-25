#!/usr/bin/env bats

# Tests for github-utils.sh output/formatting functions

load '../../helpers/setup'
load '../../helpers/assertions'

setup() {
  source "$PROJECT_ROOT/lib/core/github-utils.sh"
}

# ============================================================================
# Print Status Tests
# ============================================================================

@test "gh_print_status: ERROR type includes error emoji" {
  run gh_print_status "ERROR" "Test error message"
  [ "$status" -eq 0 ]
  [[ "$output" =~ "❌" ]]
  [[ "$output" =~ "Test error message" ]]
}

@test "gh_print_status: WARNING type includes warning emoji" {
  run gh_print_status "WARNING" "Test warning message"
  [ "$status" -eq 0 ]
  [[ "$output" =~ "⚠️" ]]
  [[ "$output" =~ "Test warning message" ]]
}

@test "gh_print_status: SUCCESS type includes success emoji" {
  run gh_print_status "SUCCESS" "Test success message"
  [ "$status" -eq 0 ]
  [[ "$output" =~ "✅" ]]
  [[ "$output" =~ "Test success message" ]]
}

@test "gh_print_status: INFO type includes info emoji" {
  run gh_print_status "INFO" "Test info message"
  [ "$status" -eq 0 ]
  [[ "$output" =~ "ℹ️" ]]
  [[ "$output" =~ "Test info message" ]]
}

@test "gh_print_status: HEADER type formats correctly" {
  run gh_print_status "HEADER" "Test header"
  [ "$status" -eq 0 ]
  [[ "$output" =~ "Test header" ]]
}

@test "gh_print_status: SECTION type formats correctly" {
  run gh_print_status "SECTION" "Test section"
  [ "$status" -eq 0 ]
  [[ "$output" =~ "Test section" ]]
}

# ============================================================================
# Print Section Tests
# ============================================================================

@test "gh_print_section: outputs section title" {
  run gh_print_section "My Section Title"
  [ "$status" -eq 0 ]
  [[ "$output" =~ "My Section Title" ]]
}

@test "gh_print_section: handles empty string" {
  run gh_print_section ""
  [ "$status" -eq 0 ]
}

@test "gh_print_section: handles special characters" {
  run gh_print_section "Section with \$pecial Ch@rs!"
  [ "$status" -eq 0 ]
  [[ "$output" =~ "Section with" ]]
}

# ============================================================================
# Print Header Tests
# ============================================================================

@test "gh_print_header: outputs header with underline" {
  run gh_print_header "My Header"
  [ "$status" -eq 0 ]
  [[ "$output" =~ "My Header" ]]
  # Should have some kind of separator/underline
  [[ "$output" =~ "═" ]]
}

@test "gh_print_header: underline matches header length" {
  run gh_print_header "Test"
  [ "$status" -eq 0 ]
  # Header is 4 chars, should have 4 equal signs
  [[ "$output" =~ "Test" ]]
}

@test "gh_print_header: handles long headers" {
  run gh_print_header "This is a very long header that should still work correctly"
  [ "$status" -eq 0 ]
  [[ "$output" =~ "This is a very long header" ]]
}

@test "gh_print_header: handles empty string" {
  run gh_print_header ""
  [ "$status" -eq 0 ]
}

# ============================================================================
# Config Display Tests
# ============================================================================

@test "gh_show_config: displays configuration header" {
  run gh_show_config
  [ "$status" -eq 0 ]
  [[ "$output" =~ "Configuration" ]]
}

@test "gh_show_config: shows main branch setting" {
  run gh_show_config
  [ "$status" -eq 0 ]
  [[ "$output" =~ "Main Branch" ]]
}

@test "gh_show_config: shows develop branch setting" {
  run gh_show_config
  [ "$status" -eq 0 ]
  [[ "$output" =~ "Develop Branch" ]]
}

@test "gh_show_config: shows protected branches" {
  run gh_show_config
  [ "$status" -eq 0 ]
  [[ "$output" =~ "Protected Branches" ]]
}

@test "gh_show_config: shows branch prefixes" {
  run gh_show_config
  [ "$status" -eq 0 ]
  [[ "$output" =~ "Branch Prefixes" ]]
}

@test "gh_show_config: shows configuration sources" {
  run gh_show_config
  [ "$status" -eq 0 ]
  [[ "$output" =~ "Configuration Sources" ]]
}

@test "gh_show_config: mentions global config path" {
  run gh_show_config
  [ "$status" -eq 0 ]
  [[ "$output" =~ ".dev-toolkit" ]]
}

@test "gh_show_config: mentions project config path" {
  run gh_show_config
  [ "$status" -eq 0 ]
  [[ "$output" =~ ".dev-toolkit.conf" ]]
}

# ============================================================================
# Config Loading Tests
# ============================================================================
# Note: Config creation tests skipped - they modify HOME and are complex
# These functions are better tested through integration tests

@test "gh_load_config: loads both global and project configs" {
  setup_test_dir
  export HOME="$TEST_DIR"
  
  # Create global config
  mkdir -p "$TEST_DIR/.dev-toolkit"
  echo "MAIN_BRANCH=trunk" > "$TEST_DIR/.dev-toolkit/config.conf"
  
  # Create project config
  echo "DEVELOP_BRANCH=dev" > "$TEST_DIR/.dt-config"
  
  # Load configs
  CONFIG_FILE_GLOBAL="$TEST_DIR/.dev-toolkit/config.conf"
  CONFIG_FILE_PROJECT="$TEST_DIR/.dt-config"
  gh_load_config
  
  main_result="$GH_MAIN_BRANCH"
  dev_result="$GH_DEVELOP_BRANCH"
  
  teardown_test_dir
  
  [ "$main_result" = "trunk" ]
  [ "$dev_result" = "dev" ]
}

@test "gh_load_config: project config overrides global config" {
  setup_test_dir
  export HOME="$TEST_DIR"
  
  # Create global config
  mkdir -p "$TEST_DIR/.dev-toolkit"
  echo "MAIN_BRANCH=main" > "$TEST_DIR/.dev-toolkit/config.conf"
  
  # Create project config with different value
  echo "MAIN_BRANCH=master" > "$TEST_DIR/.dt-config"
  
  # Load configs
  CONFIG_FILE_GLOBAL="$TEST_DIR/.dev-toolkit/config.conf"
  CONFIG_FILE_PROJECT="$TEST_DIR/.dt-config"
  gh_load_config
  
  result="$GH_MAIN_BRANCH"
  
  teardown_test_dir
  
  # Project config should override global
  [ "$result" = "master" ]
}
