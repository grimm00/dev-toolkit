# dt-workflow - Phase 4: Enhancement

**Phase:** 4 - Enhancement  
**Duration:** 8-10 hours  
**Status:** 🟠 In Progress  
**Prerequisites:** Phase 3 complete
**Last Updated:** 2026-01-26

---

## 📋 Overview

Add advanced features including model recommendations, context profiles, --dry-run flag, and performance optimizations. Document evolution path for future config-assisted and automated modes.

**Success Definition:** Enhanced dt-workflow with model recommendations, configurable context, performance benchmarks, and documented evolution path.

---

## 🎯 Goals

1. **Model Recommendations** - Output recommended model per workflow type (FR-6)
2. **Context Profiles** - Configurable context sets (FR-7)
3. **Dry Run Mode** - Preview output without full generation
4. **Performance** - Optimize for speed and token efficiency (NFR-2, NFR-3)
5. **Evolution Path** - Document Phase 2/3 preparation

---

## 📝 Tasks

### Task Group 1: Model Recommendations (2-3 hours)

#### Task 1: Write Model Recommendation Tests (TDD - RED)

**Purpose:** Test model recommendation output per workflow type.

**Steps:**

1. **Create test file:**
   - [x] Create `tests/unit/test-model-recommendations.bats`
   - [x] Add test helper setup

2. **Write tests for model recommendations:**
   - [x] Test explore workflow recommends appropriate model
   - [x] Test research workflow recommends appropriate model
   - [x] Test decision workflow recommends appropriate model
   - [x] Test recommendation appears in output header

**Test examples:**

```bash
@test "explore workflow recommends model in output" {
    run "$DT_WORKFLOW" explore test-topic --interactive
    [ "$status" -eq 0 ]
    [[ "$output" =~ "Recommended Model:" ]]
}

@test "research workflow recommends model in output" {
    run "$DT_WORKFLOW" research test-topic --interactive
    [ "$status" -eq 0 ]
    [[ "$output" =~ "Recommended Model:" ]]
}

@test "decision workflow recommends model in output" {
    run "$DT_WORKFLOW" decision test-topic --interactive
    [ "$status" -eq 0 ]
    [[ "$output" =~ "Recommended Model:" ]]
}
```

**Checklist:**
- [x] Test file created
- [x] Tests written for all workflow types
- [x] Tests run and FAIL (RED phase complete)

---

#### Task 2: Implement Model Recommendations (TDD - GREEN)

**Purpose:** Add model recommendation to dt-workflow output.

**Steps:**

1. **Add model recommendation function:**
   - [x] Create `get_recommended_model()` function in dt-workflow
   - [x] Return model based on workflow type
   - [x] Consider output size (explore=smaller, decision=larger)

2. **Add to output header:**
   - [x] Include recommendation in output header section
   - [x] Format: `Recommended Model: [model-name]`
   - [x] Add brief rationale

**Implementation example:**

```bash
get_recommended_model() {
    local workflow="$1"
    case "$workflow" in
        explore)
            echo "claude-3-5-sonnet (fast iteration, good for brainstorming)"
            ;;
        research)
            echo "claude-3-5-sonnet (balanced analysis)"
            ;;
        decision)
            echo "claude-3-opus (complex reasoning for ADRs)"
            ;;
        *)
            echo "claude-3-5-sonnet (general purpose)"
            ;;
    esac
}
```

**Checklist:**
- [ ] Function implemented
- [ ] Output includes recommendation
- [ ] All tests PASS (GREEN phase complete)

---

#### Task 3: Refactor Model Recommendations (TDD - REFACTOR)

**Purpose:** Clean up and document model recommendation feature.

**Steps:**

1. **Extract configuration:**
   - [x] Consider making recommendations configurable (noted in comments for future)
   - [x] Add comments explaining rationale

2. **Update documentation:**
   - [x] Add to dt-workflow --help output
   - [x] Document in TEMPLATE-VARIABLES.md

**Checklist:**
- [x] Code reviewed for improvements
- [x] Tests still pass
- [x] Documentation updated

---

### Task Group 2: Context Profiles (2-3 hours)

#### Task 4: Write Context Profile Tests (TDD - RED)

**Purpose:** Test configurable context profiles.

**Steps:**

1. **Write tests for context profiles:**
   - [x] Test default profile includes all context
   - [x] Test --profile flag accepts profile name
   - [x] Test minimal profile excludes optional context
   - [x] Test custom profile from config file (deferred - config file support future)

**Test examples:**

```bash
@test "default profile includes all context" {
    run "$DT_WORKFLOW" explore test-topic --interactive
    [ "$status" -eq 0 ]
    [[ "$output" =~ "CRITICAL RULES" ]]
    [[ "$output" =~ "PROJECT IDENTITY" ]]
}

@test "--profile minimal reduces context" {
    run "$DT_WORKFLOW" explore test-topic --interactive --profile minimal
    [ "$status" -eq 0 ]
    [[ "$output" =~ "CRITICAL RULES" ]]
    # Minimal profile skips optional context
}

@test "--profile flag validates profile name" {
    run "$DT_WORKFLOW" explore test-topic --interactive --profile nonexistent
    [ "$status" -eq 1 ]
    [[ "$output" =~ "Unknown profile" ]]
}
```

**Checklist:**
- [x] Tests written for profile functionality
- [x] Tests run and FAIL (RED phase complete)

---

#### Task 5: Implement Context Profiles (TDD - GREEN)

**Purpose:** Add configurable context profiles.

**Steps:**

1. **Define profile structure:**
   - [x] `default` - All context (current behavior)
   - [x] `minimal` - Rules only, skip project identity
   - [x] `full` - All context + additional (future)

2. **Add --profile flag:**
   - [x] Parse --profile argument
   - [x] Validate profile name
   - [x] Apply profile to context selection

3. **Implement profile logic:**
   - [x] Modify context injection based on profile
   - [x] Keep backward compatibility (default = current)

**Implementation example:**

```bash
apply_context_profile() {
    local profile="${1:-default}"
    
    case "$profile" in
        default)
            INCLUDE_RULES=true
            INCLUDE_PROJECT_IDENTITY=true
            INCLUDE_WORKFLOW_CONTEXT=true
            ;;
        minimal)
            INCLUDE_RULES=true
            INCLUDE_PROJECT_IDENTITY=false
            INCLUDE_WORKFLOW_CONTEXT=true
            ;;
        full)
            INCLUDE_RULES=true
            INCLUDE_PROJECT_IDENTITY=true
            INCLUDE_WORKFLOW_CONTEXT=true
            # Future: additional context
            ;;
        *)
            echo "❌ Unknown profile: $profile" >&2
            return 1
            ;;
    esac
}
```

**Checklist:**
- [ ] Profile structure defined
- [ ] --profile flag implemented
- [ ] All tests PASS (GREEN phase complete)

---

#### Task 6: Refactor Context Profiles (TDD - REFACTOR)

**Purpose:** Clean up and make profiles extensible.

**Steps:**

1. **Consider config file support:**
   - [x] Design config format for custom profiles (documented in comments)
   - [x] Document extension points (config file location, format notes)

2. **Update help text:**
   - [x] Add --profile to --help output (already done in Task 3)
   - [x] List available profiles (improved description)

**Checklist:**
- [x] Code reviewed for improvements
- [x] Tests still pass
- [x] Help text updated

---

### Task Group 3: Dry Run Mode (1-2 hours)

#### Task 7: Write Dry Run Tests (TDD - RED)

**Purpose:** Test --dry-run flag functionality.

**Steps:**

1. **Write tests for dry run:**
   - [x] Test --dry-run shows preview without full output
   - [x] Test --dry-run shows what would be included
   - [x] Test --dry-run completes quickly

**Test examples:**

```bash
@test "--dry-run shows preview only" {
    run "$DT_WORKFLOW" explore test-topic --dry-run
    [ "$status" -eq 0 ]
    [[ "$output" =~ "Dry Run Preview" ]]
    [[ "$output" =~ "Would include:" ]]
    # Should NOT include full template content
    [[ ! "$output" =~ "# dt-workflow Output:" ]]
}

@test "--dry-run completes quickly" {
    start=$(date +%s%N)
    run "$DT_WORKFLOW" explore test-topic --dry-run
    end=$(date +%s%N)
    duration=$(( (end - start) / 1000000 )) # ms
    [ "$duration" -lt 500 ]
}
```

**Checklist:**
- [x] Tests written for dry run
- [x] Tests run and FAIL (RED phase complete)

---

#### Task 8: Implement Dry Run Mode (TDD - GREEN)

**Purpose:** Add --dry-run flag for preview.

**Steps:**

1. **Add --dry-run flag parsing:**
   - [x] Parse --dry-run argument
   - [x] Set dry_run variable

2. **Implement preview output:**
   - [x] Show workflow type
   - [x] Show what context would be included
   - [x] Show estimated output size
   - [x] Skip full template rendering

**Implementation example:**

```bash
if [ "$DRY_RUN" = true ]; then
    cat << EOF
🔍 Dry Run Preview
==================

Workflow: $WORKFLOW
Topic: $TOPIC

Would include:
- Cursor rules: $([ -d ".cursor/rules" ] && echo "Yes" || echo "No")
- Project identity: $([ -f "admin/planning/roadmap.md" ] && echo "Yes" || echo "No")
- Workflow template: Yes

Profile: ${PROFILE:-default}
Estimated output: ~${ESTIMATED_TOKENS:-5000} tokens

Run without --dry-run to generate full output.
EOF
    exit 0
fi
```

**Checklist:**
- [x] --dry-run flag implemented
- [x] Preview shows useful information
- [x] All tests PASS (GREEN phase complete)

---

### Task Group 4: Performance Optimization (1-2 hours)

#### Task 9: Write Performance Tests (TDD - RED)

**Purpose:** Test performance requirements.

**Steps:**

1. **Write performance tests:**
   - [x] Test context injection completes in <1 second (NFR-2)
   - [x] Test validation completes in <500ms (NFR-3)
   - [x] Test full output generation time

**Test examples:**

```bash
@test "context injection under 1 second" {
    start=$(date +%s%N)
    run "$DT_WORKFLOW" explore test-topic --interactive 2>/dev/null
    end=$(date +%s%N)
    duration=$(( (end - start) / 1000000 )) # ms
    [ "$duration" -lt 1000 ]
}

@test "validation under 500ms" {
    start=$(date +%s%N)
    run "$DT_WORKFLOW" explore --help
    end=$(date +%s%N)
    duration=$(( (end - start) / 1000000 )) # ms
    [ "$duration" -lt 500 ]
}
```

**Checklist:**
- [x] Performance tests written
- [x] Tests run and measure baseline

---

#### Task 10: Implement Performance Optimizations (TDD - GREEN)

**Purpose:** Optimize dt-workflow for speed.

**Steps:**

1. **Profile current performance:**
   - [x] Measure context injection time (~200-400ms, well under 1s)
   - [x] Measure template rendering time (included in full output test)
   - [x] Identify bottlenecks (none found - requirements met)

2. **Optimize if needed:**
   - [x] No optimization needed - all tests pass
   - [x] Documented potential optimizations for future (caching, subshell reduction)
   - [x] Added performance notes to code comments

3. **Document benchmark results:**
   - [x] Record baseline times (documented in code comments)
   - [x] Add to phase documentation (this file)

**Checklist:**
- [x] Performance profiled
- [x] Optimizations applied (if needed) - No optimization needed
- [x] Performance tests PASS

---

### Task Group 5: Evolution Documentation (1 hour)

#### Task 11: Document Evolution Path

**Purpose:** Document future phases (config-assisted, automated modes).

**Steps:**

1. **Create evolution document:**
   - [x] Create `docs/dt-workflow-evolution.md`
   - [x] Document current Phase 1 (interactive) state
   - [x] Outline Phase 2 (config-assisted) vision
   - [x] Outline Phase 3 (automated) vision

2. **Update related docs:**
   - [x] Reference in feature-plan.md
   - [x] Reference in README.md

**Evolution Document Structure:**

```markdown
# dt-workflow Evolution Path

## Current: Phase 1 - Interactive Mode
- Manual workflow initiation
- AI-assisted content generation
- Human-in-the-loop

## Future: Phase 2 - Config-Assisted Mode
- Configuration-based workflow triggers
- Reduced manual steps
- Semi-automated handoffs

## Future: Phase 3 - Automated Mode
- Full automation for routine workflows
- Event-driven triggers
- Minimal human intervention
```

**Checklist:**
- [x] Evolution document created
- [x] References added to related docs
- [x] Vision clearly documented

---

#### Task 12: Update Manual Testing Guide

**Purpose:** Add Phase 4 test scenarios to manual testing guide.

**Steps:**

1. **Add Phase 4 scenarios:**
   - [x] Scenario 4.1: Model recommendation output
   - [x] Scenario 4.2: Context profile switching
   - [x] Scenario 4.3: Dry run preview
   - [x] Scenario 4.4: Performance verification

**Checklist:**
- [x] Manual testing scenarios documented
- [x] All Phase 4 features covered

---

## ✅ Completion Criteria

- [ ] Model recommendations included in output for all workflows
- [ ] Context profiles configurable via --profile flag
- [ ] --dry-run flag shows preview without full generation
- [ ] Context injection <1 second (NFR-2)
- [ ] Validation <500ms (NFR-3)
- [ ] Evolution path documented in `docs/dt-workflow-evolution.md`
- [ ] All tests passing
- [ ] Manual testing scenarios added

---

## 📦 Deliverables

- Model recommendation feature in dt-workflow output
- Context profile system with --profile flag
- --dry-run flag for preview mode
- Performance benchmark results
- `docs/dt-workflow-evolution.md` - Future phases documentation
- Updated manual-testing.md with Phase 4 scenarios

---

## 🔗 Dependencies

### Prerequisites

- [x] Phase 3 complete (Cursor integration)

### Blocks

- Future: Phase 2 (config-assisted) implementation
- Future: Phase 3 (automated) implementation

---

## 📊 Progress Tracking

| Task | Status | Notes |
|------|--------|-------|
| Task 1: Model recommendation tests (RED) | ✅ Complete | All tests pass |
| Task 2: Model recommendation impl (GREEN) | ✅ Complete | Feature implemented |
| Task 3: Model recommendation refactor | ✅ Complete | Documentation improved |
| Task 4: Context profile tests (RED) | ✅ Complete | All tests pass |
| Task 5: Context profile impl (GREEN) | ✅ Complete | Feature implemented |
| Task 6: Context profile refactor | ✅ Complete | Documentation improved |
| Task 7: Dry run tests (RED) | ✅ Complete | All tests pass |
| Task 8: Dry run impl (GREEN) | ✅ Complete | Feature implemented |
| Task 9: Performance tests (RED) | ✅ Complete | All tests pass, baseline documented |
| Task 10: Performance optimization (GREEN) | ✅ Complete | No optimization needed - requirements met |
| Task 11: Evolution documentation | ✅ Complete | Evolution path documented |
| Task 12: Manual testing scenarios | ✅ Complete | Phase 4 scenarios added |

---

## 🔗 Related Documents

- [Feature Hub](README.md)
- [Feature Plan](feature-plan.md)
- [Previous Phase: Phase 3](phase-3.md)
- [Requirements](../../research/dt-workflow/requirements.md)
- [Pattern 5: Phase-Based Evolution](../../../../docs/patterns/workflow-patterns.md)

---

**Last Updated:** 2026-01-26  
**Status:** ✅ Expanded  
**Next:** Begin implementation with Task 1
