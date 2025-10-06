#!/usr/bin/env bash

# Common setup for all tests

# Set up project root (called before each test file)
setup_file() {
  # Get the project root (parent of tests/ directory)
  # BATS_TEST_DIRNAME is the directory containing the test file
  # We need to go up to tests/, then up one more to project root
  local test_dir="$BATS_TEST_DIRNAME"
  # Keep going up until we find the tests directory, then go up one more
  while [ "$(basename "$test_dir")" != "tests" ] && [ "$test_dir" != "/" ]; do
    test_dir="$(dirname "$test_dir")"
  done
  export PROJECT_ROOT="$(dirname "$test_dir")"
  export PATH="$PROJECT_ROOT/bin:$PATH"
  export DT_ROOT="$PROJECT_ROOT"
}

# Also set it up for individual tests if setup_file isn't called
if [ -z "$PROJECT_ROOT" ]; then
  # BASH_SOURCE[0] is this file (tests/helpers/setup.bash)
  # Go up two levels: helpers/ -> tests/ -> project root
  export PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
  export PATH="$PROJECT_ROOT/bin:$PATH"
  export DT_ROOT="$PROJECT_ROOT"
fi

# Create temporary test directory
setup_test_dir() {
  ORIGINAL_PWD="$PWD"
  TEST_DIR="$(mktemp -d)"
  cd "$TEST_DIR"
}

# Cleanup temporary directory
teardown_test_dir() {
  if [ -n "$ORIGINAL_PWD" ]; then
    cd "$ORIGINAL_PWD"
  fi
  if [ -n "$TEST_DIR" ] && [ -d "$TEST_DIR" ]; then
    rm -rf "$TEST_DIR"
  fi
}

# Initialize a git repository for testing
init_test_repo() {
  git init
  git config user.email "test@example.com"
  git config user.name "Test User"
}

# Create initial commit
create_initial_commit() {
  echo "# Test Repository" > README.md
  git add README.md
  git commit -m "Initial commit"
}
