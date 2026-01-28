#!/usr/bin/env bats

# Test file for template variable documentation (Phase 2, Task 4)
# Location: tests/unit/test-template-variables-doc.bats
# 
# These tests validate that template variable documentation exists and is complete.

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
    source "$TOOLKIT_ROOT/lib/doc-gen/render.sh" 2>/dev/null || true
    
    # Expected documentation file
    DOC_FILE="$TOOLKIT_ROOT/lib/doc-gen/TEMPLATE-VARIABLES.md"
}

# ============================================================================
# Task 4: Template Variable Documentation Tests (RED)
# ============================================================================

@test "template variable documentation file exists" {
    # Documentation file should exist
    [ -f "$DOC_FILE" ] || {
        echo "FAIL: Template variable documentation not found: $DOC_FILE"
        echo "Expected file: lib/doc-gen/TEMPLATE-VARIABLES.md"
        return 1
    }
}

@test "template variable documentation includes universal variables" {
    skip_if_no_doc
    
    # Universal variables should be documented
    grep -q "## Universal Variables" "$DOC_FILE" || {
        echo "FAIL: Universal Variables section not found"
        return 1
    }
    
    # Check for common universal variables
    grep -q "\${DATE}" "$DOC_FILE" || {
        echo "FAIL: DATE variable not documented"
        return 1
    }
    
    grep -q "\${STATUS}" "$DOC_FILE" || {
        echo "FAIL: STATUS variable not documented"
        return 1
    }
    
    grep -q "\${PURPOSE}" "$DOC_FILE" || {
        echo "FAIL: PURPOSE variable not documented"
        return 1
    }
}

@test "template variable documentation includes exploration variables" {
    skip_if_no_doc
    
    # Exploration variables section should exist
    grep -q "## Exploration Variables" "$DOC_FILE" || {
        echo "FAIL: Exploration Variables section not found"
        return 1
    }
    
    # Check for exploration-specific variables
    grep -q "\${TOPIC_NAME}" "$DOC_FILE" || {
        echo "FAIL: TOPIC_NAME variable not documented"
        return 1
    }
    
    grep -q "\${TOPIC_TITLE}" "$DOC_FILE" || {
        echo "FAIL: TOPIC_TITLE variable not documented"
        return 1
    }
}

@test "template variable documentation includes research variables" {
    skip_if_no_doc
    
    # Research variables section should exist
    grep -q "## Research Variables" "$DOC_FILE" || {
        echo "FAIL: Research Variables section not found"
        return 1
    }
    
    # Check for research-specific variables
    grep -q "\${QUESTION}" "$DOC_FILE" || {
        echo "FAIL: QUESTION variable not documented"
        return 1
    }
    
    grep -q "\${QUESTION_NAME}" "$DOC_FILE" || {
        echo "FAIL: QUESTION_NAME variable not documented"
        return 1
    }
    
    grep -q "\${TOPIC_COUNT}" "$DOC_FILE" || {
        echo "FAIL: TOPIC_COUNT variable not documented"
        return 1
    }
    
    grep -q "\${DOC_COUNT}" "$DOC_FILE" || {
        echo "FAIL: DOC_COUNT variable not documented"
        return 1
    }
}

@test "template variable documentation includes decision variables" {
    skip_if_no_doc
    
    # Decision variables section should exist
    grep -q "## Decision Variables" "$DOC_FILE" || {
        echo "FAIL: Decision Variables section not found"
        return 1
    }
    
    # Check for decision-specific variables
    grep -q "\${ADR_NUMBER}" "$DOC_FILE" || {
        echo "FAIL: ADR_NUMBER variable not documented"
        return 1
    }
    
    grep -q "\${DECISION_TITLE}" "$DOC_FILE" || {
        echo "FAIL: DECISION_TITLE variable not documented"
        return 1
    }
    
    grep -q "\${DECISION_COUNT}" "$DOC_FILE" || {
        echo "FAIL: DECISION_COUNT variable not documented"
        return 1
    }
    
    grep -q "\${BATCH_NUMBER}" "$DOC_FILE" || {
        echo "FAIL: BATCH_NUMBER variable not documented"
        return 1
    }
}

@test "template variable documentation includes planning variables" {
    skip_if_no_doc
    
    # Planning variables section should exist
    grep -q "## Planning Variables" "$DOC_FILE" || {
        echo "FAIL: Planning Variables section not found"
        return 1
    }
    
    # Check for planning-specific variables
    grep -q "\${FEATURE_NAME}" "$DOC_FILE" || {
        echo "FAIL: FEATURE_NAME variable not documented"
        return 1
    }
    
    grep -q "\${PHASE_NUMBER}" "$DOC_FILE" || {
        echo "FAIL: PHASE_NUMBER variable not documented"
        return 1
    }
    
    grep -q "\${PHASE_NAME}" "$DOC_FILE" || {
        echo "FAIL: PHASE_NAME variable not documented"
        return 1
    }
}

@test "template variable documentation includes setter function references" {
    skip_if_no_doc
    
    # Should reference setter functions
    grep -q "dt_set_exploration_vars" "$DOC_FILE" || {
        echo "FAIL: dt_set_exploration_vars not referenced"
        return 1
    }
    
    grep -q "dt_set_research_vars" "$DOC_FILE" || {
        echo "FAIL: dt_set_research_vars not referenced"
        return 1
    }
    
    grep -q "dt_set_decision_vars" "$DOC_FILE" || {
        echo "FAIL: dt_set_decision_vars not referenced"
        return 1
    }
    
    grep -q "dt_set_planning_vars" "$DOC_FILE" || {
        echo "FAIL: dt_set_planning_vars not referenced"
        return 1
    }
}

@test "template variable documentation includes variable descriptions" {
    skip_if_no_doc
    
    # Documentation should include descriptions (check for table structure)
    grep -q "| Variable |" "$DOC_FILE" || {
        echo "FAIL: Variable table structure not found"
        return 1
    }
    
    grep -q "| Description |" "$DOC_FILE" || {
        echo "FAIL: Description column not found in table"
        return 1
    }
}

@test "all variables from render.sh are documented" {
    skip_if_no_doc
    
    # Extract all variables from render.sh
    local render_file="$TOOLKIT_ROOT/lib/doc-gen/render.sh"
    
    # Get all variable names from DT_*_VARS definitions
    # Extract ${VAR} patterns, remove ${ and }, get unique list
    local vars_in_code
    vars_in_code=$(grep -E "^DT_.*_VARS=" "$render_file" | \
        sed 's/.*=//' | \
        grep -oE '\$\{[A-Z_]+\}' | \
        sed 's/\${//' | \
        sed 's/}//' | \
        sort -u)
    
    # Check each variable is documented (check for ${VAR} pattern in doc)
    local missing_vars=()
    while IFS= read -r var; do
        [ -z "$var" ] && continue
        # Check for ${VAR} pattern in documentation
        if ! grep -q "\${$var}" "$DOC_FILE"; then
            missing_vars+=("$var")
        fi
    done <<< "$vars_in_code"
    
    if [ ${#missing_vars[@]} -gt 0 ]; then
        echo "FAIL: Variables not documented: ${missing_vars[*]}"
        echo "Found variables in code:"
        echo "$vars_in_code"
        return 1
    fi
}

# Helper function to skip tests if documentation not available
skip_if_no_doc() {
    if [ ! -f "$DOC_FILE" ]; then
        skip "Template variable documentation not found: $DOC_FILE"
    fi
}
