#!/usr/bin/env bats

# Test file for template enhancement validation (Phase 2, Task 1)
# Location: tests/unit/test-template-enhancement.bats
# 
# These tests validate that templates (from dev-infra) produce output with
# structural examples per ADR-006 and FR-24. Tests will fail until templates
# are enhanced in dev-infra.

load '../helpers/setup'
load '../helpers/assertions'

# Path to toolkit root (calculated in setup)
TOOLKIT_ROOT=""

setup() {
    # Calculate toolkit root
    local test_dir="$BATS_TEST_DIRNAME"
    TOOLKIT_ROOT="$(cd "$test_dir/../.." && pwd)"
    
    # Source required libraries
    source "$TOOLKIT_ROOT/lib/core/output-utils.sh"
    source "$TOOLKIT_ROOT/lib/doc-gen/render.sh"
    source "$TOOLKIT_ROOT/lib/doc-gen/templates.sh" 2>/dev/null || true
    
    # Create temp directory for test project
    TEST_PROJECT=$(mktemp -d)
    TEST_OUTPUT=$(mktemp)
    
    # Try to find template directory
    # Templates are in dev-infra, so we check common locations
    TEMPLATE_DIRS=(
        "$HOME/Projects/dev-infra/scripts/doc-gen/templates"
        "$HOME/dev-infra/scripts/doc-gen/templates"
        "${TOOLKIT_ROOT%/*}/dev-infra/scripts/doc-gen/templates"
    )
    
    TEMPLATE_DIR=""
    for dir in "${TEMPLATE_DIRS[@]}"; do
        if [ -d "$dir" ]; then
            TEMPLATE_DIR="$dir"
            break
        fi
    done
    
    # If templates not found, skip tests (templates are in dev-infra)
    if [ -z "$TEMPLATE_DIR" ]; then
        skip "Templates not found (dev-infra not available)"
    fi
}

teardown() {
    # Clean up temp files
    [ -n "$TEST_PROJECT" ] && [ -d "$TEST_PROJECT" ] && rm -rf "$TEST_PROJECT"
    [ -n "$TEST_OUTPUT" ] && [ -f "$TEST_OUTPUT" ] && rm -f "$TEST_OUTPUT"
}

# ============================================================================
# Task 1: Exploration Template Enhancement Tests (RED)
# ============================================================================

@test "exploration template includes themes table structure" {
    skip_if_no_templates
    
    # Set template variables
    dt_set_exploration_vars "test-topic" "Test exploration"
    
    # Render template
    local template="$TEMPLATE_DIR/exploration/exploration.md.tmpl"
    if [ ! -f "$template" ]; then
        skip "Exploration template not found: $template"
    fi
    
    dt_render_template "$template" "$TEST_OUTPUT" "exploration"
    
    # Structural example should exist (will fail until template enhanced)
    grep -q "| Theme | Key Finding |" "$TEST_OUTPUT" || {
        echo "FAIL: Themes table header not found"
        echo "Template output:"
        cat "$TEST_OUTPUT"
        return 1
    }
    
    grep -q "|-------|-------------|" "$TEST_OUTPUT" || {
        echo "FAIL: Themes table separator not found"
        return 1
    }
    
    grep -q "<!-- AI: Fill theme rows" "$TEST_OUTPUT" || {
        echo "FAIL: AI placeholder for theme rows not found"
        return 1
    }
}

@test "exploration template includes recommendations list structure" {
    skip_if_no_templates
    
    dt_set_exploration_vars "test-topic" "Test exploration"
    
    local template="$TEMPLATE_DIR/exploration/exploration.md.tmpl"
    if [ ! -f "$template" ]; then
        skip "Exploration template not found: $template"
    fi
    
    dt_render_template "$template" "$TEST_OUTPUT" "exploration"
    
    # Recommendations numbered list structure should exist
    grep -q "### Initial Recommendations" "$TEST_OUTPUT" || {
        echo "FAIL: Initial Recommendations section not found"
        return 1
    }
    
    grep -q "1. <!-- AI:" "$TEST_OUTPUT" || {
        echo "FAIL: Numbered recommendation placeholder not found"
        return 1
    }
}

@test "exploration template includes REQUIRED markers" {
    skip_if_no_templates
    
    dt_set_exploration_vars "test-topic" "Test exploration"
    
    local template="$TEMPLATE_DIR/exploration/exploration.md.tmpl"
    if [ ! -f "$template" ]; then
        skip "Exploration template not found: $template"
    fi
    
    dt_render_template "$template" "$TEST_OUTPUT" "exploration"
    
    # REQUIRED markers should exist per FR-26
    grep -q "<!-- REQUIRED:" "$TEST_OUTPUT" || {
        echo "FAIL: REQUIRED markers not found (FR-26)"
        echo "Template should include markers like: <!-- REQUIRED: At least 2 themes -->"
        return 1
    }
}

@test "exploration template has themes analyzed section" {
    skip_if_no_templates
    
    dt_set_exploration_vars "test-topic" "Test exploration"
    
    local template="$TEMPLATE_DIR/exploration/exploration.md.tmpl"
    if [ ! -f "$template" ]; then
        skip "Exploration template not found: $template"
    fi
    
    dt_render_template "$template" "$TEST_OUTPUT" "exploration"
    
    # Themes Analyzed section should exist (from spike heredoc structure)
    grep -q "### Themes Analyzed" "$TEST_OUTPUT" || {
        echo "FAIL: Themes Analyzed section not found"
        echo "Expected section from spike heredoc structure (NFR-7)"
        return 1
    }
}

# Helper function to skip tests if templates not available
skip_if_no_templates() {
    if [ -z "$TEMPLATE_DIR" ]; then
        skip "Templates not found (dev-infra not available)"
    fi
}
