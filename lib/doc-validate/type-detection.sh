#!/bin/bash
# Type Detection Functions for dt-doc-validate
# Implements path-based and content-based detection per ADR-006
#
# This library provides functions to detect document types from file paths
# and content. Detection follows priority: explicit → path → content → error.
#
# Related: admin/decisions/doc-infrastructure/adr-006-type-detection.md

# ============================================================================
# TYPE DETECTION
# ============================================================================

# All supported document types (17 total)
# Use -ga for global array scope (required for bats subshells)
declare -ga DT_DOCUMENT_TYPES=(
    "exploration" "research_topics" "exploration_hub"
    "research_topic" "research_summary" "requirements" "research_hub"
    "adr" "decisions_summary" "decisions_hub"
    "feature_plan" "phase" "status_and_next_steps" "planning_hub"
    "fix_batch" "handoff" "reflection"
)

dt_detect_document_type() {
    local file_path="$1"
    local explicit_type="${2:-}"
    
    # 1. Explicit type override (highest priority)
    if [ -n "$explicit_type" ]; then
        echo "$explicit_type"
        return 0
    fi
    
    # 2. Path-based detection (ordered most to least specific)
    local detected_type
    detected_type=$(dt_detect_from_path "$file_path")
    if [ -n "$detected_type" ]; then
        echo "$detected_type"
        return 0
    fi
    
    # 3. Content-based fallback
    detected_type=$(dt_detect_from_content "$file_path")
    if [ -n "$detected_type" ]; then
        echo "$detected_type"
        return 0
    fi
    
    # 4. Detection failed
    return 1
}

dt_detect_from_path() {
    local file_path="$1"
    
    case "$file_path" in
        */explorations/*/exploration.md)     echo "exploration" ;;
        */explorations/*/research-topics.md) echo "research_topics" ;;
        */explorations/*/README.md)          echo "exploration_hub" ;;
        */research/*/research-summary.md)    echo "research_summary" ;;
        */research/*/requirements.md)       echo "requirements" ;;
        */research/*/README.md)              echo "research_hub" ;;
        */research/*/research-*.md)          echo "research_topic" ;;
        */decisions/*/adr-*.md)              echo "adr" ;;
        */decisions/*/decisions-summary.md)  echo "decisions_summary" ;;
        */decisions/*/README.md)             echo "decisions_hub" ;;
        */planning/features/*/feature-plan.md) echo "feature_plan" ;;
        */planning/features/*/phase-*.md)    echo "phase" ;;
        */planning/features/*/status-and-next-steps.md) echo "status_and_next_steps" ;;
        */planning/features/*/README.md)     echo "planning_hub" ;;
        */planning/fix/fix-batch-*.md)       echo "fix_batch" ;;
        */handoff*.md)                       echo "handoff" ;;
        */reflection*.md)                    echo "reflection" ;;
        *)                                   echo "" ;;
    esac
}

dt_detect_from_content() {
    local file="$1"
    
    [ -f "$file" ] || return 1
    
    # Check distinctive patterns (ordered by reliability)
    if grep -q "^# ADR-[0-9]" "$file" 2>/dev/null; then
        echo "adr"
    elif grep -q "^## 🎯 What We're Exploring" "$file" 2>/dev/null; then
        echo "exploration"
    elif grep -q "^## 🎯 Research Question" "$file" 2>/dev/null; then
        echo "research_topic"
    elif grep -q "^## ✅ Functional Requirements" "$file" 2>/dev/null; then
        echo "requirements"
    elif grep -q "^## 📊 Findings" "$file" 2>/dev/null; then
        echo "research_summary"
    else
        return 1
    fi
}

dt_list_document_types() {
    printf '%s\n' "${DT_DOCUMENT_TYPES[@]}"
}
