#!/usr/bin/env bats

# Test file for dt-workflow
# Location: tests/unit/test-dt-workflow.bats

load '../helpers/setup'
load '../helpers/assertions'
load '../helpers/mocks'

# Path to command under test
DT_WORKFLOW="$BATS_TEST_DIRNAME/../../bin/dt-workflow"

setup() {
    # Create temp directory for test project
    TEST_PROJECT=$(mktemp -d)
    mkdir -p "$TEST_PROJECT/.cursor/rules"
    mkdir -p "$TEST_PROJECT/admin/explorations"
    mkdir -p "$TEST_PROJECT/admin/planning"
    
    # Initialize git repo for testing
    cd "$TEST_PROJECT"
    git init > /dev/null 2>&1
    git config user.email "test@example.com"
    git config user.name "Test User"
    echo "# Test Project" > README.md
    git add README.md
    git commit -m "Initial commit" > /dev/null 2>&1
}

teardown() {
    # Clean up temp directory
    if [ -n "$TEST_PROJECT" ] && [ -d "$TEST_PROJECT" ]; then
        rm -rf "$TEST_PROJECT"
    fi
}

# Placeholder test to verify infrastructure works
@test "test infrastructure is set up correctly" {
    [ -f "$DT_WORKFLOW" ]
    [ -d "$TEST_PROJECT" ]
    [ -d "$TEST_PROJECT/.cursor/rules" ]
}

# ============================================================================
# Task 2: Help and Version Tests (TDD)
# ============================================================================

@test "dt-workflow shows help with --help" {
    run "$DT_WORKFLOW" --help
    [ "$status" -eq 0 ]
    [[ "$output" =~ "Usage:" ]]
    [[ "$output" =~ "dt-workflow" ]]
}

@test "dt-workflow shows help with -h" {
    run "$DT_WORKFLOW" -h
    [ "$status" -eq 0 ]
    [[ "$output" =~ "Usage:" ]]
}

@test "dt-workflow shows version with --version" {
    run "$DT_WORKFLOW" --version
    [ "$status" -eq 0 ]
    [[ "$output" =~ "dt-workflow version" ]]
}

@test "dt-workflow shows version with -v" {
    run "$DT_WORKFLOW" -v
    [ "$status" -eq 0 ]
    [[ "$output" =~ "version" ]]
}

# ============================================================================
# Task 3: Input Validation Tests (TDD)
# ============================================================================

@test "dt-workflow requires workflow argument" {
    run "$DT_WORKFLOW"
    [ "$status" -eq 1 ]
    [[ "$output" =~ "Workflow type is required" ]]
    [[ "$output" =~ "💡" ]]  # Actionable suggestion
}

@test "dt-workflow requires topic argument" {
    run "$DT_WORKFLOW" explore
    [ "$status" -eq 1 ]
    [[ "$output" =~ "Topic is required" ]]
    [[ "$output" =~ "💡" ]]
}

@test "dt-workflow rejects unknown workflow" {
    run "$DT_WORKFLOW" unknown-workflow test-topic --interactive
    [ "$status" -eq 1 ]
    [[ "$output" =~ "Unknown workflow" ]]
}

@test "dt-workflow requires --interactive in Phase 1" {
    run "$DT_WORKFLOW" explore test-topic
    [ "$status" -eq 1 ]
    [[ "$output" =~ "Phase 1 requires --interactive" ]]
}

@test "dt-workflow --validate checks L1 existence" {
    run "$DT_WORKFLOW" research nonexistent-topic --validate --project "$TEST_PROJECT"
    [ "$status" -eq 1 ]
    [[ "$output" =~ "Exploration directory not found" ]]
}

@test "dt-workflow --validate passes for explore (no prereqs)" {
    run "$DT_WORKFLOW" explore test-topic --validate --project "$TEST_PROJECT"
    [ "$status" -eq 0 ]
    [[ "$output" =~ "L1 checks passed" ]]
}

# ============================================================================
# Task 4: Context Gathering Functions Tests (TDD)
# ============================================================================

@test "gather_cursor_rules outputs rules when present" {
    # Setup: Create mock rules
    echo "# Test Rule" > "$TEST_PROJECT/.cursor/rules/test.mdc"
    
    # Source the script to access functions
    # Script checks if sourced vs executed, so main won't run
    source "$DT_WORKFLOW"
    
    run gather_cursor_rules "$TEST_PROJECT"
    [ "$status" -eq 0 ]
    [[ "$output" =~ "Cursor Rules" ]]
    [[ "$output" =~ "test.mdc" ]]
    [[ "$output" =~ "# Test Rule" ]]
}

@test "gather_cursor_rules handles missing rules directory" {
    # Setup: No .cursor/rules directory
    rm -rf "$TEST_PROJECT/.cursor/rules"
    
    source "$DT_WORKFLOW"
    run gather_cursor_rules "$TEST_PROJECT"
    [ "$status" -eq 0 ]
    # Should not error, just no output or debug message
}

@test "gather_project_identity finds roadmap" {
    mkdir -p "$TEST_PROJECT/admin/planning"
    echo "# Roadmap" > "$TEST_PROJECT/admin/planning/roadmap.md"
    
    source "$DT_WORKFLOW"
    run gather_project_identity "$TEST_PROJECT"
    [ "$status" -eq 0 ]
    [[ "$output" =~ "Project Roadmap" ]]
}

@test "gather_project_identity handles missing files gracefully" {
    source "$DT_WORKFLOW"
    run gather_project_identity "$TEST_PROJECT"
    [ "$status" -eq 0 ]
    # Should not error
}

@test "estimate_tokens returns approximate count" {
    source "$DT_WORKFLOW"
    
    # ~100 chars = ~25 tokens (4 chars per token)
    result=$(estimate_tokens "This is a test string with approximately one hundred characters in it for testing purposes here.")
    [ "$result" -gt 20 ]
    [ "$result" -lt 30 ]
}

# ============================================================================
# Task 5: Template Integration Tests (RED)
# ============================================================================

@test "dt-workflow explore uses template-rendered structure" {
    TEST_OUTPUT=$(mktemp)
    
    run "$DT_WORKFLOW" explore test-topic --interactive --output "$TEST_OUTPUT" --project "$TEST_PROJECT"
    [ "$status" -eq 0 ]
    
    # Check that output contains template-rendered content
    # Template should include "Themes Analyzed" section (from enhanced template)
    grep -q "### Themes Analyzed" "$TEST_OUTPUT" || {
        echo "FAIL: Themes Analyzed section not found (should be from template)"
        cat "$TEST_OUTPUT"
        rm -f "$TEST_OUTPUT"
        return 1
    }
    
    # Check for template structure markers (not heredoc placeholders)
    grep -q "| Theme | Key Finding |" "$TEST_OUTPUT" || {
        echo "FAIL: Themes table structure not found (should be from template)"
        rm -f "$TEST_OUTPUT"
        return 1
    }
    
    # Check for Initial Recommendations (from enhanced template)
    grep -q "### Initial Recommendations" "$TEST_OUTPUT" || {
        echo "FAIL: Initial Recommendations section not found (should be from template)"
        rm -f "$TEST_OUTPUT"
        return 1
    }
    
    rm -f "$TEST_OUTPUT"
}

@test "dt-workflow explore substitutes template variables correctly" {
    TEST_OUTPUT=$(mktemp)
    
    run "$DT_WORKFLOW" explore my-test-topic --interactive --output "$TEST_OUTPUT" --project "$TEST_PROJECT"
    [ "$status" -eq 0 ]
    
    # Check that topic name is substituted in output
    grep -q "my-test-topic" "$TEST_OUTPUT" || {
        echo "FAIL: Topic name not substituted in output"
        rm -f "$TEST_OUTPUT"
        return 1
    }
    
    # Check for date substitution (should be current date format)
    grep -qE "[0-9]{4}-[0-9]{2}-[0-9]{2}" "$TEST_OUTPUT" || {
        echo "FAIL: Date not substituted in output"
        rm -f "$TEST_OUTPUT"
        return 1
    }
    
    rm -f "$TEST_OUTPUT"
}

@test "dt-workflow explore structure matches template output format" {
    TEST_OUTPUT=$(mktemp)
    
    run "$DT_WORKFLOW" explore test-topic --interactive --output "$TEST_OUTPUT" --project "$TEST_PROJECT"
    [ "$status" -eq 0 ]
    
    # Check for REQUIRED markers (from enhanced templates)
    grep -q "<!-- REQUIRED:" "$TEST_OUTPUT" || {
        echo "FAIL: REQUIRED markers not found (should be from enhanced template)"
        rm -f "$TEST_OUTPUT"
        return 1
    }
    
    # Check for AI placeholders (from templates)
    grep -q "<!-- AI:" "$TEST_OUTPUT" || {
        echo "FAIL: AI placeholders not found (should be from template)"
        rm -f "$TEST_OUTPUT"
        return 1
    }
    
    rm -f "$TEST_OUTPUT"
}

# ============================================================================
# Task 7: Research Structure Generation Tests (RED)
# ============================================================================

@test "dt-workflow research generates structure via template" {
    TEST_OUTPUT=$(mktemp)
    
    # Create exploration directory for L1 validation
    mkdir -p "$TEST_PROJECT/admin/explorations/test-topic"
    echo "# Exploration" > "$TEST_PROJECT/admin/explorations/test-topic/exploration.md"
    
    run "$DT_WORKFLOW" research test-topic --interactive --output "$TEST_OUTPUT" --project "$TEST_PROJECT"
    [ "$status" -eq 0 ]
    
    # Research structure sections
    grep -q "## 🎯 Research Question" "$TEST_OUTPUT" || {
        echo "FAIL: Research Question section not found"
        rm -f "$TEST_OUTPUT"
        return 1
    }
    
    grep -q "## 🔍 Research Goals" "$TEST_OUTPUT" || {
        echo "FAIL: Research Goals section not found"
        rm -f "$TEST_OUTPUT"
        return 1
    }
    
    grep -q "## 📊 Findings" "$TEST_OUTPUT" || {
        echo "FAIL: Findings section not found"
        rm -f "$TEST_OUTPUT"
        return 1
    }
    
    grep -q "## 💡 Recommendations" "$TEST_OUTPUT" || {
        echo "FAIL: Recommendations section not found"
        rm -f "$TEST_OUTPUT"
        return 1
    }
    
    rm -f "$TEST_OUTPUT"
}

@test "dt-workflow research uses template rendering" {
    TEST_OUTPUT=$(mktemp)
    
    # Create exploration directory for L1 validation
    mkdir -p "$TEST_PROJECT/admin/explorations/test-topic"
    echo "# Exploration" > "$TEST_PROJECT/admin/explorations/test-topic/exploration.md"
    
    run "$DT_WORKFLOW" research test-topic --interactive --output "$TEST_OUTPUT" --project "$TEST_PROJECT"
    [ "$status" -eq 0 ]
    
    # Check for template-rendered content (AI placeholders)
    grep -q "<!-- AI:" "$TEST_OUTPUT" || {
        echo "FAIL: AI placeholders not found (should be from template)"
        rm -f "$TEST_OUTPUT"
        return 1
    }
    
    # Check for REQUIRED markers (from enhanced templates)
    grep -q "<!-- REQUIRED:" "$TEST_OUTPUT" || {
        echo "FAIL: REQUIRED markers not found (should be from enhanced template)"
        rm -f "$TEST_OUTPUT"
        return 1
    }
    
    rm -f "$TEST_OUTPUT"
}

@test "dt-workflow research substitutes template variables correctly" {
    TEST_OUTPUT=$(mktemp)
    
    # Create exploration directory for L1 validation
    mkdir -p "$TEST_PROJECT/admin/explorations/my-research-topic"
    echo "# Exploration" > "$TEST_PROJECT/admin/explorations/my-research-topic/exploration.md"
    
    run "$DT_WORKFLOW" research my-research-topic --interactive --output "$TEST_OUTPUT" --project "$TEST_PROJECT"
    [ "$status" -eq 0 ]
    
    # Check that topic name is substituted in output
    grep -q "my-research-topic" "$TEST_OUTPUT" || grep -q "My Research Topic" "$TEST_OUTPUT" || {
        echo "FAIL: Topic name not substituted in output"
        rm -f "$TEST_OUTPUT"
        return 1
    }
    
    # Check for date substitution (should be current date format)
    grep -qE "[0-9]{4}-[0-9]{2}-[0-9]{2}" "$TEST_OUTPUT" || {
        echo "FAIL: Date not substituted in output"
        rm -f "$TEST_OUTPUT"
        return 1
    }
    
    rm -f "$TEST_OUTPUT"
}

# ============================================================================
# Task 8: Research Context Gathering Tests (RED)
# ============================================================================

@test "dt-workflow research includes exploration context" {
    TEST_OUTPUT=$(mktemp)
    
    # Setup: create exploration
    mkdir -p "$TEST_PROJECT/admin/explorations/test-topic"
    echo "# Exploration: test-topic" > "$TEST_PROJECT/admin/explorations/test-topic/exploration.md"
    echo "Some exploration content here" >> "$TEST_PROJECT/admin/explorations/test-topic/exploration.md"
    
    run "$DT_WORKFLOW" research test-topic --interactive --output "$TEST_OUTPUT" --project "$TEST_PROJECT"
    [ "$status" -eq 0 ]
    
    # Context section should include exploration
    grep -q "## Workflow-Specific Context" "$TEST_OUTPUT" || {
        echo "FAIL: Workflow-Specific Context section not found"
        rm -f "$TEST_OUTPUT"
        return 1
    }
    
    grep -q "exploration.md" "$TEST_OUTPUT" || grep -q "Related Exploration" "$TEST_OUTPUT" || {
        echo "FAIL: Exploration context not found in output"
        rm -f "$TEST_OUTPUT"
        return 1
    }
    
    rm -f "$TEST_OUTPUT"
}

@test "dt-workflow research includes research-topics.md from exploration" {
    TEST_OUTPUT=$(mktemp)
    
    # Setup: create exploration with research-topics.md
    mkdir -p "$TEST_PROJECT/admin/explorations/test-topic"
    echo "# Exploration" > "$TEST_PROJECT/admin/explorations/test-topic/exploration.md"
    echo "# Research Topics" > "$TEST_PROJECT/admin/explorations/test-topic/research-topics.md"
    echo "Topic 1: Some research question" >> "$TEST_PROJECT/admin/explorations/test-topic/research-topics.md"
    
    run "$DT_WORKFLOW" research test-topic --interactive --output "$TEST_OUTPUT" --project "$TEST_PROJECT"
    [ "$status" -eq 0 ]
    
    # Should include research-topics.md content
    grep -q "Research Topics" "$TEST_OUTPUT" || grep -q "research-topics.md" "$TEST_OUTPUT" || {
        echo "FAIL: Research topics from exploration not found"
        rm -f "$TEST_OUTPUT"
        return 1
    }
    
    rm -f "$TEST_OUTPUT"
}

@test "dt-workflow research discovers existing research documents" {
    TEST_OUTPUT=$(mktemp)
    
    # Setup: create exploration and existing research
    mkdir -p "$TEST_PROJECT/admin/explorations/test-topic"
    echo "# Exploration" > "$TEST_PROJECT/admin/explorations/test-topic/exploration.md"
    mkdir -p "$TEST_PROJECT/admin/research/test-topic"
    echo "# Research Document 1" > "$TEST_PROJECT/admin/research/test-topic/research-1.md"
    echo "# Research Document 2" > "$TEST_PROJECT/admin/research/test-topic/research-2.md"
    
    run "$DT_WORKFLOW" research test-topic --interactive --output "$TEST_OUTPUT" --project "$TEST_PROJECT"
    [ "$status" -eq 0 ]
    
    # Should mention existing research
    grep -q "Existing Research" "$TEST_OUTPUT" || grep -q "research-1.md" "$TEST_OUTPUT" || grep -q "research-2.md" "$TEST_OUTPUT" || {
        echo "FAIL: Existing research documents not discovered"
        rm -f "$TEST_OUTPUT"
        return 1
    }
    
    rm -f "$TEST_OUTPUT"
}

# ============================================================================
# Task 9: Research Handoff File Generation Tests (RED)
# ============================================================================

@test "dt-workflow research generates handoff file guidance" {
    TEST_OUTPUT=$(mktemp)
    
    # Create exploration directory for L1 validation
    mkdir -p "$TEST_PROJECT/admin/explorations/test-topic"
    echo "# Exploration" > "$TEST_PROJECT/admin/explorations/test-topic/exploration.md"
    
    run "$DT_WORKFLOW" research test-topic --interactive --output "$TEST_OUTPUT" --project "$TEST_PROJECT"
    [ "$status" -eq 0 ]
    
    # Handoff guidance should be in output
    grep -q "research-summary.md" "$TEST_OUTPUT" || {
        echo "FAIL: research-summary.md handoff file not mentioned"
        rm -f "$TEST_OUTPUT"
        return 1
    }
    
    grep -q "## 🚀 Next Steps" "$TEST_OUTPUT" || {
        echo "FAIL: Next Steps section not found"
        rm -f "$TEST_OUTPUT"
        return 1
    }
    
    grep -q "/decision" "$TEST_OUTPUT" || grep -q "decision" "$TEST_OUTPUT" || {
        echo "FAIL: Decision workflow not mentioned in Next Steps"
        rm -f "$TEST_OUTPUT"
        return 1
    }
    
    rm -f "$TEST_OUTPUT"
}

@test "dt-workflow research handoff includes required sections" {
    TEST_OUTPUT=$(mktemp)
    
    # Create exploration directory for L1 validation
    mkdir -p "$TEST_PROJECT/admin/explorations/test-topic"
    echo "# Exploration" > "$TEST_PROJECT/admin/explorations/test-topic/exploration.md"
    
    run "$DT_WORKFLOW" research test-topic --interactive --output "$TEST_OUTPUT" --project "$TEST_PROJECT"
    [ "$status" -eq 0 ]
    
    # Required sections per Pattern 4
    grep -q "Key Findings" "$TEST_OUTPUT" || grep -q "🔍 Key Findings" "$TEST_OUTPUT" || {
        echo "FAIL: Key Findings section not mentioned in handoff guidance"
        rm -f "$TEST_OUTPUT"
        return 1
    }
    
    grep -q "Recommendations" "$TEST_OUTPUT" || grep -q "💡 Recommendations" "$TEST_OUTPUT" || {
        echo "FAIL: Recommendations section not mentioned in handoff guidance"
        rm -f "$TEST_OUTPUT"
        return 1
    }
    
    rm -f "$TEST_OUTPUT"
}

# ============================================================================
# Task 10: Decision Structure Generation Tests (RED)
# ============================================================================

@test "dt-workflow decision generates ADR structure via template" {
    TEST_OUTPUT=$(mktemp)
    
    # Create research directory for L1 validation
    mkdir -p "$TEST_PROJECT/admin/research/test-topic"
    echo "# Research Summary" > "$TEST_PROJECT/admin/research/test-topic/research-summary.md"
    
    run "$DT_WORKFLOW" decision test-topic --interactive --output "$TEST_OUTPUT" --project "$TEST_PROJECT"
    [ "$status" -eq 0 ]
    
    # ADR structure sections
    grep -q "## Context" "$TEST_OUTPUT" || grep -q "## Decision" "$TEST_OUTPUT" || {
        echo "FAIL: ADR structure sections not found"
        rm -f "$TEST_OUTPUT"
        return 1
    }
    
    grep -q "## Consequences" "$TEST_OUTPUT" || grep -q "## Alternatives Considered" "$TEST_OUTPUT" || {
        echo "FAIL: ADR structure sections not found"
        rm -f "$TEST_OUTPUT"
        return 1
    }
    
    rm -f "$TEST_OUTPUT"
}

@test "dt-workflow decision uses template rendering" {
    TEST_OUTPUT=$(mktemp)
    
    # Create research directory for L1 validation
    mkdir -p "$TEST_PROJECT/admin/research/test-topic"
    echo "# Research Summary" > "$TEST_PROJECT/admin/research/test-topic/research-summary.md"
    
    run "$DT_WORKFLOW" decision test-topic --interactive --output "$TEST_OUTPUT" --project "$TEST_PROJECT"
    [ "$status" -eq 0 ]
    
    # Check for template-rendered content (AI placeholders)
    grep -q "<!-- AI:" "$TEST_OUTPUT" || {
        echo "FAIL: AI placeholders not found (should be from template)"
        rm -f "$TEST_OUTPUT"
        return 1
    }
    
    # Check for REQUIRED markers (from enhanced templates)
    grep -q "<!-- REQUIRED:" "$TEST_OUTPUT" || {
        echo "FAIL: REQUIRED markers not found (should be from enhanced template)"
        rm -f "$TEST_OUTPUT"
        return 1
    }
    
    rm -f "$TEST_OUTPUT"
}

@test "dt-workflow decision substitutes template variables correctly" {
    TEST_OUTPUT=$(mktemp)
    
    # Create research directory for L1 validation
    mkdir -p "$TEST_PROJECT/admin/research/my-decision-topic"
    echo "# Research Summary" > "$TEST_PROJECT/admin/research/my-decision-topic/research-summary.md"
    
    run "$DT_WORKFLOW" decision my-decision-topic --interactive --output "$TEST_OUTPUT" --project "$TEST_PROJECT"
    [ "$status" -eq 0 ]
    
    # Check that topic name is substituted in output
    grep -q "my-decision-topic" "$TEST_OUTPUT" || grep -q "My Decision Topic" "$TEST_OUTPUT" || {
        echo "FAIL: Topic name not substituted in output"
        rm -f "$TEST_OUTPUT"
        return 1
    }
    
    # Check for date substitution (should be current date format)
    grep -qE "[0-9]{4}-[0-9]{2}-[0-9]{2}" "$TEST_OUTPUT" || {
        echo "FAIL: Date not substituted in output"
        rm -f "$TEST_OUTPUT"
        return 1
    }
    
    rm -f "$TEST_OUTPUT"
}

# ============================================================================
# Task 11: Decision Context Gathering Tests (RED)
# ============================================================================

@test "dt-workflow decision includes research context" {
    TEST_OUTPUT=$(mktemp)
    
    # Setup: create research
    mkdir -p "$TEST_PROJECT/admin/research/test-topic"
    echo "# Research Summary" > "$TEST_PROJECT/admin/research/test-topic/research-summary.md"
    echo "## Key Findings" >> "$TEST_PROJECT/admin/research/test-topic/research-summary.md"
    
    run "$DT_WORKFLOW" decision test-topic --interactive --output "$TEST_OUTPUT" --project "$TEST_PROJECT"
    [ "$status" -eq 0 ]
    
    grep -q "## Workflow-Specific Context" "$TEST_OUTPUT" || {
        echo "FAIL: Workflow-Specific Context section not found"
        rm -f "$TEST_OUTPUT"
        return 1
    }
    
    grep -q "research-summary.md" "$TEST_OUTPUT" || grep -q "Research Summary" "$TEST_OUTPUT" || {
        echo "FAIL: Research context not found in output"
        rm -f "$TEST_OUTPUT"
        return 1
    }
    
    rm -f "$TEST_OUTPUT"
}

@test "dt-workflow decision includes requirements.md if exists" {
    TEST_OUTPUT=$(mktemp)
    
    # Setup: create research with requirements.md
    mkdir -p "$TEST_PROJECT/admin/research/test-topic"
    echo "# Research Summary" > "$TEST_PROJECT/admin/research/test-topic/research-summary.md"
    echo "# Requirements" > "$TEST_PROJECT/admin/research/test-topic/requirements.md"
    echo "FR-1: Some requirement" >> "$TEST_PROJECT/admin/research/test-topic/requirements.md"
    
    run "$DT_WORKFLOW" decision test-topic --interactive --output "$TEST_OUTPUT" --project "$TEST_PROJECT"
    [ "$status" -eq 0 ]
    
    # Should include requirements
    grep -q "Requirements" "$TEST_OUTPUT" || grep -q "requirements.md" "$TEST_OUTPUT" || {
        echo "FAIL: Requirements not found in output"
        rm -f "$TEST_OUTPUT"
        return 1
    }
    
    rm -f "$TEST_OUTPUT"
}

@test "dt-workflow decision discovers existing ADRs" {
    TEST_OUTPUT=$(mktemp)
    
    # Setup: create research and existing ADRs
    mkdir -p "$TEST_PROJECT/admin/research/test-topic"
    echo "# Research Summary" > "$TEST_PROJECT/admin/research/test-topic/research-summary.md"
    mkdir -p "$TEST_PROJECT/admin/decisions/test-topic"
    echo "# ADR 001" > "$TEST_PROJECT/admin/decisions/test-topic/adr-001.md"
    echo "# ADR 002" > "$TEST_PROJECT/admin/decisions/test-topic/adr-002.md"
    
    run "$DT_WORKFLOW" decision test-topic --interactive --output "$TEST_OUTPUT" --project "$TEST_PROJECT"
    [ "$status" -eq 0 ]
    
    # Should mention existing ADRs
    grep -q "Existing ADRs" "$TEST_OUTPUT" || grep -q "adr-001.md" "$TEST_OUTPUT" || grep -q "adr-002.md" "$TEST_OUTPUT" || {
        echo "FAIL: Existing ADRs not discovered"
        rm -f "$TEST_OUTPUT"
        return 1
    }
    
    rm -f "$TEST_OUTPUT"
}

# ============================================================================
# Task 12: Decision Handoff File Generation Tests (RED)
# ============================================================================

@test "dt-workflow decision generates handoff file guidance" {
    TEST_OUTPUT=$(mktemp)
    
    # Setup: create research directory for L1 validation
    mkdir -p "$TEST_PROJECT/admin/research/test-topic"
    echo "# Research Summary" > "$TEST_PROJECT/admin/research/test-topic/research-summary.md"
    
    run "$DT_WORKFLOW" decision test-topic --interactive --output "$TEST_OUTPUT" --project "$TEST_PROJECT"
    [ "$status" -eq 0 ]
    
    # Should include handoff guidance
    grep -q "Handoff" "$TEST_OUTPUT" || grep -q "decisions-summary.md" "$TEST_OUTPUT" || {
        echo "FAIL: Handoff file guidance not found"
        rm -f "$TEST_OUTPUT"
        return 1
    }
    
    rm -f "$TEST_OUTPUT"
}

@test "dt-workflow decision handoff includes required sections" {
    TEST_OUTPUT=$(mktemp)
    
    # Setup: create research directory for L1 validation
    mkdir -p "$TEST_PROJECT/admin/research/test-topic"
    echo "# Research Summary" > "$TEST_PROJECT/admin/research/test-topic/research-summary.md"
    
    run "$DT_WORKFLOW" decision test-topic --interactive --output "$TEST_OUTPUT" --project "$TEST_PROJECT"
    [ "$status" -eq 0 ]
    
    # Should mention required sections (Decisions table, Impact Summary)
    grep -q "Decisions" "$TEST_OUTPUT" || grep -q "Impact Summary" "$TEST_OUTPUT" || {
        echo "FAIL: Required sections not documented in handoff guidance"
        rm -f "$TEST_OUTPUT"
        return 1
    }
    
    rm -f "$TEST_OUTPUT"
}

@test "dt-workflow decision handoff includes Next Steps pointing to transition-plan" {
    TEST_OUTPUT=$(mktemp)
    
    # Setup: create research directory for L1 validation
    mkdir -p "$TEST_PROJECT/admin/research/test-topic"
    echo "# Research Summary" > "$TEST_PROJECT/admin/research/test-topic/research-summary.md"
    
    run "$DT_WORKFLOW" decision test-topic --interactive --output "$TEST_OUTPUT" --project "$TEST_PROJECT"
    [ "$status" -eq 0 ]
    
    # Should mention transition-plan in Next Steps
    grep -q "transition-plan" "$TEST_OUTPUT" || grep -q "Next Steps" "$TEST_OUTPUT" || {
        echo "FAIL: Next Steps section not found or doesn't mention transition-plan"
        rm -f "$TEST_OUTPUT"
        return 1
    }
    
    rm -f "$TEST_OUTPUT"
}

# ============================================================================
# Task 13: --from-explore Flag Implementation Tests (RED)
# ============================================================================

@test "--from-explore auto-detects exploration directory" {
    TEST_OUTPUT=$(mktemp)
    
    # Setup: create exploration
    mkdir -p "$TEST_PROJECT/admin/explorations/test-topic"
    echo "# Exploration" > "$TEST_PROJECT/admin/explorations/test-topic/exploration.md"
    
    run "$DT_WORKFLOW" research test-topic --from-explore --interactive --output "$TEST_OUTPUT" --project "$TEST_PROJECT"
    [ "$status" -eq 0 ]
    
    # Should have loaded exploration context
    grep -q "Related Exploration" "$TEST_OUTPUT" || grep -q "exploration.md" "$TEST_OUTPUT" || {
        echo "FAIL: Exploration context not loaded"
        rm -f "$TEST_OUTPUT"
        return 1
    }
    
    rm -f "$TEST_OUTPUT"
}

@test "--from-explore with explicit path uses that path" {
    TEST_OUTPUT=$(mktemp)
    
    # Setup: create custom exploration location
    mkdir -p "$TEST_PROJECT/custom/explorations/my-topic"
    echo "# Custom Exploration" > "$TEST_PROJECT/custom/explorations/my-topic/exploration.md"
    
    run "$DT_WORKFLOW" research test-topic --from-explore "$TEST_PROJECT/custom/explorations/my-topic" --interactive --output "$TEST_OUTPUT" --project "$TEST_PROJECT"
    [ "$status" -eq 0 ]
    
    # Should have loaded custom exploration context
    grep -q "Custom Exploration" "$TEST_OUTPUT" || {
        echo "FAIL: Custom exploration context not loaded"
        rm -f "$TEST_OUTPUT"
        return 1
    }
    
    rm -f "$TEST_OUTPUT"
}

@test "--from-explore fails gracefully when exploration not found" {
    TEST_OUTPUT=$(mktemp)
    
    # No exploration directory exists
    
    run "$DT_WORKFLOW" research test-topic --from-explore --interactive --output "$TEST_OUTPUT" --project "$TEST_PROJECT"
    [ "$status" -ne 0 ]
    
    # Should show error message (check both output variable and file)
    grep -q "Exploration not found" <<< "$output" || grep -q "ERROR" <<< "$output" || grep -q "Exploration not found" "$TEST_OUTPUT" || grep -q "ERROR" "$TEST_OUTPUT" || {
        echo "FAIL: Error message not shown for missing exploration"
        echo "Output: $output"
        rm -f "$TEST_OUTPUT"
        return 1
    }
    
    rm -f "$TEST_OUTPUT"
}

# ============================================================================
# Task 6: Template-Spike Alignment Tests (RED)
# ============================================================================

@test "dt-workflow explore template output matches spike structure (Themes Analyzed)" {
    TEST_OUTPUT=$(mktemp)
    
    run "$DT_WORKFLOW" explore test-topic --interactive --output "$TEST_OUTPUT" --project "$TEST_PROJECT"
    [ "$status" -eq 0 ]
    
    # Spike structure includes "Themes Analyzed" table
    grep -q "### Themes Analyzed" "$TEST_OUTPUT" || {
        echo "FAIL: Themes Analyzed section not found (required by spike structure)"
        rm -f "$TEST_OUTPUT"
        return 1
    }
    
    # Spike structure includes table header
    grep -q "| Theme | Key Finding |" "$TEST_OUTPUT" || {
        echo "FAIL: Themes table header not found (required by spike structure)"
        rm -f "$TEST_OUTPUT"
        return 1
    }
    
    rm -f "$TEST_OUTPUT"
}

@test "dt-workflow explore template output matches spike structure (Initial Recommendations)" {
    TEST_OUTPUT=$(mktemp)
    
    run "$DT_WORKFLOW" explore test-topic --interactive --output "$TEST_OUTPUT" --project "$TEST_PROJECT"
    [ "$status" -eq 0 ]
    
    # Spike structure includes "Initial Recommendations" numbered list
    grep -q "### Initial Recommendations" "$TEST_OUTPUT" || {
        echo "FAIL: Initial Recommendations section not found (required by spike structure)"
        rm -f "$TEST_OUTPUT"
        return 1
    }
    
    # Check for numbered list structure (spike uses numbered list)
    grep -qE "^[0-9]+\\. " "$TEST_OUTPUT" || grep -qE "^[0-9]+\\. <!-- AI:" "$TEST_OUTPUT" || {
        echo "FAIL: Numbered list structure not found (required by spike structure)"
        rm -f "$TEST_OUTPUT"
        return 1
    }
    
    rm -f "$TEST_OUTPUT"
}

@test "dt-workflow explore template output includes all spike sections" {
    TEST_OUTPUT=$(mktemp)
    
    run "$DT_WORKFLOW" explore test-topic --interactive --output "$TEST_OUTPUT" --project "$TEST_PROJECT"
    [ "$status" -eq 0 ]
    
    # Spike structure includes these core sections
    local required_sections=(
        "## 🎯 What We're Exploring"
        "## 🔍 Themes"
        "## ❓ Key Questions"
        "## 💡 Initial Thoughts"
        "## 🚀 Next Steps"
    )
    
    for section in "${required_sections[@]}"; do
        grep -q "$section" "$TEST_OUTPUT" || {
            echo "FAIL: Required section not found: $section"
            rm -f "$TEST_OUTPUT"
            return 1
        }
    done
    
    rm -f "$TEST_OUTPUT"
}

@test "dt-workflow explore template output structure equivalent to spike" {
    TEST_OUTPUT=$(mktemp)
    
    run "$DT_WORKFLOW" explore test-topic --interactive --output "$TEST_OUTPUT" --project "$TEST_PROJECT"
    [ "$status" -eq 0 ]
    
    # Verify structural elements from spike are present in the full output
    # (Themes Analyzed and Initial Recommendations are already tested separately,
    # but this test ensures overall structural equivalence)
    
    # 1. Title with topic (should appear in exploration.md section)
    grep -q "# Exploration:" "$TEST_OUTPUT" || {
        echo "FAIL: Exploration title not found"
        rm -f "$TEST_OUTPUT"
        return 1
    }
    
    # 2. Status and date metadata
    grep -qE "\*\*Status:\*\*" "$TEST_OUTPUT" || {
        echo "FAIL: Status metadata not found"
        rm -f "$TEST_OUTPUT"
        return 1
    }
    
    # 3. Themes Analyzed table (spike structure) - already verified in separate test
    grep -q "### Themes Analyzed" "$TEST_OUTPUT" || {
        echo "FAIL: Themes Analyzed section missing (spike structure requirement)"
        rm -f "$TEST_OUTPUT"
        return 1
    }
    
    # 4. Initial Recommendations list (spike structure) - already verified in separate test
    grep -q "### Initial Recommendations" "$TEST_OUTPUT" || {
        echo "FAIL: Initial Recommendations section missing (spike structure requirement)"
        rm -f "$TEST_OUTPUT"
        return 1
    }
    
    # 5. Core sections from spike structure
    grep -q "## 🎯 What We're Exploring" "$TEST_OUTPUT" || {
        echo "FAIL: What We're Exploring section missing"
        rm -f "$TEST_OUTPUT"
        return 1
    }
    
    rm -f "$TEST_OUTPUT"
}
