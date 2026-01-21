#!/usr/bin/env bats

# Integration tests for dt-doc-gen
# Location: tests/integration/test-dt-doc-gen.bats

load '../helpers/setup'
load '../helpers/assertions'
load '../helpers/mocks'

DT_DOC_GEN="$PROJECT_ROOT/bin/dt-doc-gen"

setup() {
    # Create test environment
    TEST_DIR=$(mktemp -d)
    mkdir -p "$TEST_DIR/admin/explorations"
    mkdir -p "$TEST_DIR/admin/research"
    mkdir -p "$TEST_DIR/admin/decisions"
    mkdir -p "$TEST_DIR/admin/planning/features"
    
    # Set up mock templates
    MOCK_TEMPLATES="$TEST_DIR/templates"
    mkdir -p "$MOCK_TEMPLATES/exploration"
    mkdir -p "$MOCK_TEMPLATES/research"
    mkdir -p "$MOCK_TEMPLATES/decision"
    mkdir -p "$MOCK_TEMPLATES/planning"
    mkdir -p "$MOCK_TEMPLATES/other"
    
    # Create minimal test templates
    cat > "$MOCK_TEMPLATES/exploration/exploration.md.tmpl" << 'EOF'
# ${TOPIC_TITLE} - Exploration

**Status:** ${STATUS}
**Created:** ${DATE}

## 🎯 What We're Exploring

<!-- AI: Add exploration context -->
EOF
    
    cat > "$MOCK_TEMPLATES/exploration/research-topics.md.tmpl" << 'EOF'
# Research Topics - ${TOPIC_TITLE}

**Status:** ${STATUS}
**Created:** ${DATE}

## Topics

<!-- AI: Add research topics -->
EOF

    cat > "$MOCK_TEMPLATES/exploration/README.md.tmpl" << 'EOF'
# ${TOPIC_TITLE}

Exploration hub for ${TOPIC_NAME}.
EOF
    
    export DT_TEMPLATES_PATH="$MOCK_TEMPLATES"
}

teardown() {
    unset DT_TEMPLATES_PATH
    rm -rf "$TEST_DIR"
}

# ============================================================================
# Basic CLI Tests
# ============================================================================

@test "dt-doc-gen: shows help with --help" {
    run "$DT_DOC_GEN" --help
    [ "$status" -eq 0 ]
    [[ "$output" =~ "Usage:" ]]
    [[ "$output" =~ "dt-doc-gen" ]]
}

@test "dt-doc-gen: shows version with --version" {
    run "$DT_DOC_GEN" --version
    [ "$status" -eq 0 ]
    [[ "$output" =~ "version" ]]
}

@test "dt-doc-gen: shows error with no arguments" {
    run "$DT_DOC_GEN"
    [ "$status" -ne 0 ]
    [[ "$output" =~ "Error" ]] || [[ "$output" =~ "Usage" ]]
}

# ============================================================================
# Document Generation Tests
# ============================================================================

@test "dt-doc-gen: generates exploration documents" {
    # Skip if envsubst not available
    if ! command -v envsubst >/dev/null 2>&1; then
        skip "envsubst not installed"
    fi
    
    cd "$TEST_DIR"
    run "$DT_DOC_GEN" exploration test-topic --output "$TEST_DIR/admin/explorations/test-topic"
    [ "$status" -eq 0 ]
    
    # Check files created
    [ -f "$TEST_DIR/admin/explorations/test-topic/exploration.md" ]
}

@test "dt-doc-gen: expands variables in generated files" {
    # Skip if envsubst not available
    if ! command -v envsubst >/dev/null 2>&1; then
        skip "envsubst not installed"
    fi
    
    cd "$TEST_DIR"
    run "$DT_DOC_GEN" exploration test-topic --output "$TEST_DIR/admin/explorations/test-topic"
    [ "$status" -eq 0 ]
    
    # Check variable expansion
    local output_file="$TEST_DIR/admin/explorations/test-topic/exploration.md"
    grep -q "Test Topic" "$output_file"
    grep -q "$(date +%Y-%m-%d)" "$output_file"
}

@test "dt-doc-gen: preserves AI markers in generated files" {
    # Skip if envsubst not available
    if ! command -v envsubst >/dev/null 2>&1; then
        skip "envsubst not installed"
    fi
    
    cd "$TEST_DIR"
    run "$DT_DOC_GEN" exploration test-topic --output "$TEST_DIR/admin/explorations/test-topic"
    [ "$status" -eq 0 ]
    
    # Check AI markers preserved
    local output_file="$TEST_DIR/admin/explorations/test-topic/exploration.md"
    grep -q '<!-- AI:' "$output_file"
}

@test "dt-doc-gen: respects --output flag" {
    # Skip if envsubst not available
    if ! command -v envsubst >/dev/null 2>&1; then
        skip "envsubst not installed"
    fi
    
    local custom_output="$TEST_DIR/custom/location"
    mkdir -p "$custom_output"
    
    cd "$TEST_DIR"
    run "$DT_DOC_GEN" exploration test-topic --output "$custom_output"
    [ "$status" -eq 0 ]
    
    # Check file in custom location
    [ -f "$custom_output/exploration.md" ]
}

@test "dt-doc-gen: mode setup generates scaffolding structure" {
    # Skip if envsubst not available
    if ! command -v envsubst >/dev/null 2>&1; then
        skip "envsubst not installed"
    fi
    
    cd "$TEST_DIR"
    run "$DT_DOC_GEN" exploration test-topic --mode setup --output "$TEST_DIR/admin/explorations/test-topic"
    [ "$status" -eq 0 ]
    
    # Check all scaffolding files created
    [ -f "$TEST_DIR/admin/explorations/test-topic/exploration.md" ]
    [ -f "$TEST_DIR/admin/explorations/test-topic/research-topics.md" ]
    [ -f "$TEST_DIR/admin/explorations/test-topic/README.md" ]
}

# ============================================================================
# Error Handling Tests
# ============================================================================

@test "dt-doc-gen: errors on invalid document type" {
    cd "$TEST_DIR"
    run "$DT_DOC_GEN" invalid-type test-topic
    [ "$status" -ne 0 ]
    [[ "$output" =~ "Unknown" ]] || [[ "$output" =~ "Invalid" ]]
}

@test "dt-doc-gen: errors when templates not found" {
    unset DT_TEMPLATES_PATH
    
    cd "$TEST_DIR"
    # Create isolated environment
    export HOME="$TEST_DIR/fake-home"
    mkdir -p "$HOME"
    
    run "$DT_DOC_GEN" exploration test-topic
    [ "$status" -ne 0 ]
    [[ "$output" =~ "template" ]] || [[ "$output" =~ "not found" ]]
}
