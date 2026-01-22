#!/usr/bin/env bats

# Tests for dt-doc-validate rule loading
# Location: tests/unit/doc-validate/test-rules.bats
#
# Tests rule loading functions including:
# - Loading pre-compiled .bash rules
# - Rules path resolution (default and override)
# - Error handling for missing rules
# - Required sections extraction
#
# Related: admin/decisions/doc-infrastructure/adr-002-validation-rule-loading.md

load '../../helpers/setup'
load '../../helpers/assertions'

setup() {
    source "$PROJECT_ROOT/lib/doc-validate/rules.sh"
}

# Test sections will go here
