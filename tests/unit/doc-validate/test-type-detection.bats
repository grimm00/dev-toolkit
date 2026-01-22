#!/usr/bin/env bats

# Tests for dt-doc-validate type detection
# Location: tests/unit/doc-validate/test-type-detection.bats
#
# Tests document type detection functions including:
# - Explicit type override
# - Path-based detection (all 17 document types)
# - Content-based fallback detection
# - Error handling for unknown types
#
# Related: admin/decisions/doc-infrastructure/adr-006-type-detection.md

load '../../helpers/setup'
load '../../helpers/assertions'

setup() {
    source "$PROJECT_ROOT/lib/doc-validate/type-detection.sh"
}

# Test sections will go here
