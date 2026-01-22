#!/usr/bin/env bats

# Integration tests for dt-doc-validate CLI
# Location: tests/integration/test-dt-doc-validate.bats
#
# End-to-end tests for the dt-doc-validate command including:
# - Help and version flags
# - Argument parsing and validation
# - File and directory validation workflows
# - Type detection integration
# - Rule loading integration
# - Output formatting (text and JSON)
# - Exit codes
#
# Related: admin/planning/features/doc-infrastructure/phase-3.md

load '../helpers/setup'
load '../helpers/assertions'
load '../helpers/mocks'

DT_DOC_VALIDATE="$PROJECT_ROOT/bin/dt-doc-validate"

setup() {
    # Create test directory structure
    export TEST_DIR="$BATS_TMPDIR/test-validate"
    mkdir -p "$TEST_DIR/admin/explorations/test-topic"
    mkdir -p "$TEST_DIR/admin/decisions/test-decision"
}

teardown() {
    rm -rf "$TEST_DIR"
}

# Test sections will go here
