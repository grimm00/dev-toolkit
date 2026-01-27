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

# ============================================================================
# Task 2: Research Template Enhancement Tests (RED)
# ============================================================================

@test "research template includes research goals checklist structure" {
    skip_if_no_templates
    
    # Set template variables
    dt_set_research_vars "test-research" "Test research question"
    
    # Render template
    local template="$TEMPLATE_DIR/research/research-topic.md.tmpl"
    if [ ! -f "$template" ]; then
        skip "Research template not found: $template"
    fi
    
    dt_render_template "$template" "$TEST_OUTPUT" "research_topic"
    
    # Research Goals checklist structure should exist
    grep -q "## 🔍 Research Goals" "$TEST_OUTPUT" || {
        echo "FAIL: Research Goals section not found"
        return 1
    }
    
    # Should have checklist items (check for bracket pattern)
    grep -q "\[ \]" "$TEST_OUTPUT" || grep -q "\[x\]" "$TEST_OUTPUT" || {
        echo "FAIL: Research Goals checklist structure not found"
        echo "Expected pattern: - [ ] Goal: <!-- AI: ... -->"
        return 1
    }
    
    # Should have AI placeholder in goals section
    grep -q "<!-- AI:" "$TEST_OUTPUT" || {
        echo "FAIL: AI placeholder not found in Research Goals"
        return 1
    }
}

@test "research template includes findings structure" {
    skip_if_no_templates
    
    dt_set_research_vars "test-research" "Test research question"
    
    local template="$TEMPLATE_DIR/research/research-topic.md.tmpl"
    if [ ! -f "$template" ]; then
        skip "Research template not found: $template"
    fi
    
    dt_render_template "$template" "$TEST_OUTPUT" "research_topic"
    
    # Findings section should exist
    grep -q "## 📊 Findings" "$TEST_OUTPUT" || {
        echo "FAIL: Findings section not found"
        return 1
    }
    
    # Should have EXPAND placeholder for detailed findings
    grep -q "<!-- EXPAND:" "$TEST_OUTPUT" || {
        echo "FAIL: EXPAND placeholder not found in Findings section"
        return 1
    }
}

@test "research template includes key insights numbered list structure" {
    skip_if_no_templates
    
    dt_set_research_vars "test-research" "Test research question"
    
    local template="$TEMPLATE_DIR/research/research-topic.md.tmpl"
    if [ ! -f "$template" ]; then
        skip "Research template not found: $template"
    fi
    
    dt_render_template "$template" "$TEST_OUTPUT" "research_topic"
    
    # Key Insights section should exist
    grep -q "Key Insights:" "$TEST_OUTPUT" || {
        echo "FAIL: Key Insights section not found"
        return 1
    }
    
    # Should have numbered list structure with AI placeholders
    # Check for pattern like "1. <!-- AI:" or "  1. <!-- AI:"
    grep -q "1\. <!-- AI:" "$TEST_OUTPUT" || grep -q "2\. <!-- AI:" "$TEST_OUTPUT" || {
        echo "FAIL: Numbered insights list with AI placeholders not found"
        echo "Expected pattern: 1. <!-- AI: ... -->"
        return 1
    }
}

@test "research template includes two-phase placeholders" {
    skip_if_no_templates
    
    dt_set_research_vars "test-research" "Test research question"
    
    local template="$TEMPLATE_DIR/research/research-topic.md.tmpl"
    if [ ! -f "$template" ]; then
        skip "Research template not found: $template"
    fi
    
    dt_render_template "$template" "$TEST_OUTPUT" "research_topic"
    
    # Should have both AI and EXPAND placeholders (two-phase pattern)
    grep -q "<!-- AI:" "$TEST_OUTPUT" || {
        echo "FAIL: AI placeholder not found (required for two-phase pattern)"
        return 1
    }
    
    grep -q "<!-- EXPAND:" "$TEST_OUTPUT" || {
        echo "FAIL: EXPAND placeholder not found (required for two-phase pattern)"
        return 1
    }
}

@test "research template includes REQUIRED markers" {
    skip_if_no_templates
    
    dt_set_research_vars "test-research" "Test research question"
    
    local template="$TEMPLATE_DIR/research/research-topic.md.tmpl"
    if [ ! -f "$template" ]; then
        skip "Research template not found: $template"
    fi
    
    dt_render_template "$template" "$TEST_OUTPUT" "research_topic"
    
    # REQUIRED markers should exist per FR-26
    grep -q "<!-- REQUIRED:" "$TEST_OUTPUT" || {
        echo "FAIL: REQUIRED markers not found (FR-26)"
        echo "Template should include markers like: <!-- REQUIRED: At least 3 goals -->"
        return 1
    }
}

@test "research template includes methodology section structure" {
    skip_if_no_templates
    
    dt_set_research_vars "test-research" "Test research question"
    
    local template="$TEMPLATE_DIR/research/research-topic.md.tmpl"
    if [ ! -f "$template" ]; then
        skip "Research template not found: $template"
    fi
    
    dt_render_template "$template" "$TEST_OUTPUT" "research_topic"
    
    # Methodology section should exist
    grep -q "## 📚 Research Methodology" "$TEST_OUTPUT" || {
        echo "FAIL: Research Methodology section not found"
        return 1
    }
    
    # Should have EXPAND placeholder for methodology details
    grep -q "<!-- EXPAND:" "$TEST_OUTPUT" || {
        echo "FAIL: EXPAND placeholder not found in Methodology section"
        return 1
    }
}

# ============================================================================
# Task 3: Decision Template Enhancement Tests (RED)
# ============================================================================

@test "decision template includes alternatives considered table structure" {
    skip_if_no_templates
    
    # Set template variables
    dt_set_decision_vars "test-topic" "006" "Test Decision"
    
    # Render template
    local template="$TEMPLATE_DIR/decision/adr.md.tmpl"
    if [ ! -f "$template" ]; then
        skip "Decision template not found: $template"
    fi
    
    dt_render_template "$template" "$TEST_OUTPUT" "adr"
    
    # Alternatives Considered table structure should exist
    grep -q "## Alternatives Considered" "$TEST_OUTPUT" || {
        echo "FAIL: Alternatives Considered section not found"
        return 1
    }
    
    grep -q "| Alternative | Pros | Cons | Why Not Chosen |" "$TEST_OUTPUT" || {
        echo "FAIL: Alternatives table header not found"
        return 1
    }
    
    grep -q "|-------------|------|------|----------------|" "$TEST_OUTPUT" || {
        echo "FAIL: Alternatives table separator not found"
        return 1
    }
    
    grep -q "<!-- AI: Fill alternatives table" "$TEST_OUTPUT" || {
        echo "FAIL: AI placeholder for alternatives table not found"
        return 1
    }
}

@test "decision template includes consequences section structure" {
    skip_if_no_templates
    
    dt_set_decision_vars "test-topic" "006" "Test Decision"
    
    local template="$TEMPLATE_DIR/decision/adr.md.tmpl"
    if [ ! -f "$template" ]; then
        skip "Decision template not found: $template"
    fi
    
    dt_render_template "$template" "$TEST_OUTPUT" "adr"
    
    # Consequences section should exist
    grep -q "## Consequences" "$TEST_OUTPUT" || {
        echo "FAIL: Consequences section not found"
        return 1
    }
    
    # Positive consequences subsection should exist
    grep -q "### Positive" "$TEST_OUTPUT" || {
        echo "FAIL: Positive consequences subsection not found"
        return 1
    }
    
    # Negative consequences subsection should exist
    grep -q "### Negative" "$TEST_OUTPUT" || {
        echo "FAIL: Negative consequences subsection not found"
        return 1
    }
    
    # Should have list items with AI placeholders
    grep -q "<!-- AI:" "$TEST_OUTPUT" || {
        echo "FAIL: Consequences list items with AI placeholders not found"
        return 1
    }
    
    # Verify list structure exists (check for dash followed by space)
    grep -q "^\- " "$TEST_OUTPUT" || grep -q "  - " "$TEST_OUTPUT" || {
        echo "FAIL: List structure not found in Consequences section"
        return 1
    }
}

@test "decision template includes decision rationale section" {
    skip_if_no_templates
    
    dt_set_decision_vars "test-topic" "006" "Test Decision"
    
    local template="$TEMPLATE_DIR/decision/adr.md.tmpl"
    if [ ! -f "$template" ]; then
        skip "Decision template not found: $template"
    fi
    
    dt_render_template "$template" "$TEST_OUTPUT" "adr"
    
    # Decision Rationale section should exist
    grep -q "## Decision Rationale" "$TEST_OUTPUT" || {
        echo "FAIL: Decision Rationale section not found"
        return 1
    }
    
    # Should have AI placeholder
    grep -q "<!-- AI:" "$TEST_OUTPUT" || {
        echo "FAIL: AI placeholder not found in Decision Rationale"
        return 1
    }
}

@test "decision template includes REQUIRED markers" {
    skip_if_no_templates
    
    dt_set_decision_vars "test-topic" "006" "Test Decision"
    
    local template="$TEMPLATE_DIR/decision/adr.md.tmpl"
    if [ ! -f "$template" ]; then
        skip "Decision template not found: $template"
    fi
    
    dt_render_template "$template" "$TEST_OUTPUT" "adr"
    
    # REQUIRED markers should exist per FR-26
    grep -q "<!-- REQUIRED:" "$TEST_OUTPUT" || {
        echo "FAIL: REQUIRED markers not found (FR-26)"
        echo "Template should include markers like: <!-- REQUIRED: At least 2 alternatives -->"
        return 1
    }
}

# Note: This test validates that the templating system *can* render template
# variable documentation (proving templating capabilities), not that it *must*
# appear in final user-facing ADRs. Template variables documentation is already
# properly validated via TEMPLATE-VARIABLES.md in test-template-variables-doc.bats.
@test "decision template includes template variable documentation" {
    skip_if_no_templates
    
    dt_set_decision_vars "test-topic" "006" "Test Decision"
    
    local template="$TEMPLATE_DIR/decision/adr.md.tmpl"
    if [ ! -f "$template" ]; then
        skip "Decision template not found: $template"
    fi
    
    dt_render_template "$template" "$TEST_OUTPUT" "adr"
    
    # Template variable documentation should exist (from REFACTOR phase)
    # Check for variable documentation comment
    grep -q "# Template Variables" "$TEST_OUTPUT" || {
        echo "FAIL: Template variable documentation not found"
        return 1
    }
}

# Helper function to skip tests if templates not available
skip_if_no_templates() {
    if [ -z "$TEMPLATE_DIR" ]; then
        skip "Templates not found (dev-infra not available)"
    fi
}
