#!/usr/bin/env bats

# Tests for dt-doc-gen template rendering
# Location: tests/unit/doc-gen/test-render.bats

load '../../helpers/setup'
load '../../helpers/assertions'

setup() {
    source "$PROJECT_ROOT/lib/doc-gen/render.sh"
}

# Test sections will go here
