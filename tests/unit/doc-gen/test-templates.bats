#!/usr/bin/env bats

# Tests for dt-doc-gen template discovery
# Location: tests/unit/doc-gen/test-templates.bats

load '../../helpers/setup'
load '../../helpers/assertions'

setup() {
    source "$PROJECT_ROOT/lib/doc-gen/templates.sh"
}

# Test sections will go here
