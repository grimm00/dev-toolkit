#!/usr/bin/env bash

# Custom assertion helpers

# Assert that output contains a string
assert_output_contains() {
  local expected="$1"
  if [[ ! "$output" =~ $expected ]]; then
    echo "Expected output to contain: $expected"
    echo "Actual output: $output"
    return 1
  fi
}

# Assert that a variable is set
assert_var_set() {
  local var_name="$1"
  if [ -z "${!var_name}" ]; then
    echo "Expected variable $var_name to be set"
    return 1
  fi
}

# Assert that a variable equals a value
assert_var_equals() {
  local var_name="$1"
  local expected="$2"
  local actual="${!var_name}"
  if [ "$actual" != "$expected" ]; then
    echo "Expected $var_name to equal: $expected"
    echo "Actual value: $actual"
    return 1
  fi
}

# Assert that a file exists
assert_file_exists() {
  local file="$1"
  if [ ! -f "$file" ]; then
    echo "Expected file to exist: $file"
    return 1
  fi
}

# Assert that a directory exists
assert_dir_exists() {
  local dir="$1"
  if [ ! -d "$dir" ]; then
    echo "Expected directory to exist: $dir"
    return 1
  fi
}
