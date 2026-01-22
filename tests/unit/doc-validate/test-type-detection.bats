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

# ===========================================================================
# TYPE DETECTION TESTS
# ===========================================================================

@test "dt_detect_document_type: explicit type overrides detection" {
    run dt_detect_document_type "any/path.md" "adr"
    [ "$status" -eq 0 ]
    [ "$output" = "adr" ]
}

@test "dt_detect_document_type: detects exploration from path" {
    run dt_detect_document_type "admin/explorations/my-topic/exploration.md"
    [ "$status" -eq 0 ]
    [ "$output" = "exploration" ]
}

@test "dt_detect_document_type: detects research_topics from path" {
    run dt_detect_document_type "admin/explorations/my-topic/research-topics.md"
    [ "$status" -eq 0 ]
    [ "$output" = "research_topics" ]
}

@test "dt_detect_document_type: detects adr from path" {
    run dt_detect_document_type "admin/decisions/auth/adr-001-auth-strategy.md"
    [ "$status" -eq 0 ]
    [ "$output" = "adr" ]
}

@test "dt_detect_document_type: detects phase from path" {
    run dt_detect_document_type "admin/planning/features/my-feature/phase-1.md"
    [ "$status" -eq 0 ]
    [ "$output" = "phase" ]
}

@test "dt_detect_document_type: supports docs/maintainers structure" {
    run dt_detect_document_type "docs/maintainers/explorations/topic/exploration.md"
    [ "$status" -eq 0 ]
    [ "$output" = "exploration" ]
}

@test "dt_detect_from_content: detects adr from heading" {
    local test_file="$BATS_TMPDIR/adr-test.md"
    echo "# ADR-001: Test Decision" > "$test_file"
    run dt_detect_from_content "$test_file"
    [ "$status" -eq 0 ]
    [ "$output" = "adr" ]
}

@test "dt_detect_from_content: detects exploration from section" {
    local test_file="$BATS_TMPDIR/explore-test.md"
    cat > "$test_file" << 'EOF'
# My Exploration
## 🎯 What We're Exploring
Some content here.
EOF
    run dt_detect_from_content "$test_file"
    [ "$status" -eq 0 ]
    [ "$output" = "exploration" ]
}

@test "dt_detect_document_type: returns error for unknown type" {
    run dt_detect_document_type "random/unknown/file.md"
    [ "$status" -eq 1 ]
}

@test "dt_list_document_types: returns all 17 types" {
    run dt_list_document_types
    [ "$status" -eq 0 ]
    [[ "$output" =~ "exploration" ]]
    [[ "$output" =~ "adr" ]]
    [[ "$output" =~ "phase" ]]
}

@test "dt_detect_from_path: detects exploration_hub from README" {
    run dt_detect_from_path "admin/explorations/my-topic/README.md"
    [ "$status" -eq 0 ]
    [ "$output" = "exploration_hub" ]
}

@test "dt_detect_from_path: detects research_topic from research-*.md pattern" {
    run dt_detect_from_path "admin/research/my-topic/research-question.md"
    [ "$status" -eq 0 ]
    [ "$output" = "research_topic" ]
}

@test "dt_detect_from_path: detects feature_plan from path" {
    run dt_detect_from_path "admin/planning/features/my-feature/feature-plan.md"
    [ "$status" -eq 0 ]
    [ "$output" = "feature_plan" ]
}

@test "dt_detect_from_path: detects handoff from path" {
    run dt_detect_from_path "admin/handoff-session.md"
    [ "$status" -eq 0 ]
    [ "$output" = "handoff" ]
}

@test "dt_detect_from_path: detects reflection from path" {
    run dt_detect_from_path "admin/reflection-2025-12-07.md"
    [ "$status" -eq 0 ]
    [ "$output" = "reflection" ]
}

@test "dt_detect_from_content: detects research_topic from Research Question section" {
    local test_file="$BATS_TMPDIR/research-test.md"
    cat > "$test_file" << 'EOF'
# Research Topic
## 🎯 Research Question
What is the best approach?
EOF
    run dt_detect_from_content "$test_file"
    [ "$status" -eq 0 ]
    [ "$output" = "research_topic" ]
}

@test "dt_detect_from_content: detects requirements from Functional Requirements section" {
    local test_file="$BATS_TMPDIR/requirements-test.md"
    cat > "$test_file" << 'EOF'
# Requirements
## ✅ Functional Requirements
FR-1: Requirement one
EOF
    run dt_detect_from_content "$test_file"
    [ "$status" -eq 0 ]
    [ "$output" = "requirements" ]
}

@test "dt_detect_from_content: detects research_summary from Findings section" {
    local test_file="$BATS_TMPDIR/research-summary-test.md"
    cat > "$test_file" << 'EOF'
# Research Summary
## 📊 Findings
Key findings here.
EOF
    run dt_detect_from_content "$test_file"
    [ "$status" -eq 0 ]
    [ "$output" = "research_summary" ]
}

@test "dt_detect_from_content: returns error for unrecognized content" {
    local test_file="$BATS_TMPDIR/unknown-test.md"
    echo "# Unknown Document" > "$test_file"
    run dt_detect_from_content "$test_file"
    [ "$status" -eq 1 ]
}
