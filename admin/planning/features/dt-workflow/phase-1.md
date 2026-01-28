# dt-workflow - Phase 1: Foundation (Production Quality)

**Phase:** 1 - Foundation  
**Duration:** 8-12 hours  
**Status:** ✅ Complete  
**Completed:** 2026-01-26
**Merged:** PR #32 (2026-01-26)
**Prerequisites:** Spike complete, ADRs accepted

---

## 📋 Overview

Refactor the spike implementation into production-quality code with comprehensive testing, following dev-toolkit script standards and TDD practices.

**Success Definition:** Production-ready `dt-workflow` with explore workflow, full test coverage, and validated portability.

---

## 🎯 Goals

1. **Restructure Code** - Organize per script-standards.mdc
2. **Implement Tests** - Full unit and integration test coverage
3. **Complete Explore Workflow** - Production-quality explore implementation
4. **Validate Portability** - Test in multiple repository contexts

---

## 📝 Tasks

### Task 1: Create Test Infrastructure

**Purpose:** Set up bats test files and helpers before writing tests (TDD foundation)

**Steps:**

1. **Create test file structure:**
   - [x] Create `tests/unit/test-dt-workflow.bats`
   - [x] Create `tests/integration/test-dt-workflow-integration.bats`
   - [x] Verify test helpers exist (`tests/helpers/`)

2. **Set up test configuration:**
   - [x] Define `DT_WORKFLOW` path variable in tests
   - [x] Create mock project structure for testing
   - [x] Set up test fixtures (mock rules, mock explorations)

**Test file skeleton:**

```bash
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
}

teardown() {
    # Clean up temp directory
    rm -rf "$TEST_PROJECT"
}
```

**Checklist:**
- [x] Unit test file created
- [x] Integration test file created
- [x] Test helpers available
- [x] Mock fixtures defined

---

### Task 2: Test Help and Version (TDD)

**Purpose:** Ensure --help and --version work correctly

**TDD Flow:**

1. **RED - Write failing tests:**

```bash
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
```

2. **GREEN - Verify spike passes:**
   - [x] Run tests: `bats tests/unit/test-dt-workflow.bats`
   - [x] Spike should already pass these tests
   - [x] If not, fix implementation

3. **REFACTOR - Update help text:**
   - [x] Remove "SPIKE" references from help
   - [x] Update version to 0.2.0
   - [x] Ensure help text matches script-standards.mdc

**Checklist:**
- [x] Help tests written and passing
- [x] Version tests written and passing
- [x] Help text production-ready

---

### Task 3: Test Input Validation (TDD)

**Purpose:** Test L1/L2/L3 validation with actionable error messages

**TDD Flow:**

1. **RED - Write failing tests:**

```bash
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
```

2. **GREEN - Verify/fix implementation:**
   - [x] Run tests: `bats tests/unit/test-dt-workflow.bats`
   - [x] Fix any failing tests
   - [x] Ensure error messages are actionable

3. **REFACTOR - Improve error messages:**
   - [x] Consistent format: "❌ Error: [message]"
   - [x] Always include "💡 Suggestion:" with corrective action
   - [x] NFR-4 compliance (actionable errors)

**Checklist:**
- [x] Missing workflow argument test passing
- [x] Missing topic argument test passing
- [x] Unknown workflow test passing
- [x] --interactive requirement test passing
- [x] --validate L1 tests passing
- [x] All error messages actionable

---

### Task 4: Test Context Gathering Functions (TDD)

**Purpose:** Test individual context gathering functions

**TDD Flow:**

1. **RED - Write failing tests for gather_cursor_rules:**

```bash
@test "gather_cursor_rules outputs rules when present" {
    # Setup: Create mock rules
    echo "# Test Rule" > "$TEST_PROJECT/.cursor/rules/test.mdc"
    
    # Source the script to access functions
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
```

2. **RED - Write failing tests for gather_project_identity:**

```bash
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
```

3. **RED - Write failing tests for estimate_tokens:**

```bash
@test "estimate_tokens returns approximate count" {
    source "$DT_WORKFLOW"
    
    # ~100 chars = ~25 tokens
    result=$(estimate_tokens "This is a test string with approximately one hundred characters in it for testing purposes here.")
    [ "$result" -gt 20 ]
    [ "$result" -lt 30 ]
}
```

4. **GREEN - Run tests and verify:**
   - [x] Run: `bats tests/unit/test-dt-workflow.bats`
   - [x] Fix any failing tests

5. **REFACTOR - Clean up functions:**
   - [x] Add inline comments per script-standards.mdc
   - [x] Ensure consistent error handling

**Checklist:**
- [x] gather_cursor_rules tests passing
- [x] gather_project_identity tests passing
- [x] estimate_tokens tests passing
- [x] Functions documented with comments

---

### Task 5: Test Output Generation (TDD)

**Purpose:** Test explore workflow output structure

**TDD Flow:**

1. **RED - Write integration tests:**

```bash
@test "explore workflow generates valid markdown structure" {
    # Create minimal test project
    mkdir -p "$TEST_PROJECT/.cursor/rules"
    echo "# Test Rule" > "$TEST_PROJECT/.cursor/rules/main.mdc"
    
    run "$DT_WORKFLOW" explore test-feature --interactive --project "$TEST_PROJECT"
    [ "$status" -eq 0 ]
    
    # Check output structure per ADR-002 (context ordering)
    [[ "$output" =~ "# dt-workflow Output:" ]]
    [[ "$output" =~ "CRITICAL RULES (START" ]]
    [[ "$output" =~ "BACKGROUND CONTEXT (MIDDLE" ]]
    [[ "$output" =~ "TASK (END" ]]
}

@test "explore workflow includes token estimate" {
    mkdir -p "$TEST_PROJECT/.cursor/rules"
    
    run "$DT_WORKFLOW" explore test-feature --interactive --project "$TEST_PROJECT"
    [ "$status" -eq 0 ]
    [[ "$output" =~ "Token Estimate:" ]]
}

@test "explore workflow includes next steps" {
    mkdir -p "$TEST_PROJECT/.cursor/rules"
    
    run "$DT_WORKFLOW" explore test-feature --interactive --project "$TEST_PROJECT"
    [ "$status" -eq 0 ]
    [[ "$output" =~ "NEXT STEPS" ]]
    [[ "$output" =~ "/research" ]]
}

@test "explore workflow generates valid exploration structure" {
    mkdir -p "$TEST_PROJECT/.cursor/rules"
    
    run "$DT_WORKFLOW" explore my-feature --interactive --project "$TEST_PROJECT"
    [ "$status" -eq 0 ]
    
    # Check generated structure templates
    [[ "$output" =~ "README.md" ]]
    [[ "$output" =~ "exploration.md" ]]
    [[ "$output" =~ "research-topics.md" ]]
}
```

2. **GREEN - Run and verify:**
   - [x] Run: `bats tests/integration/test-dt-workflow-integration.bats`
   - [x] Fix any structural issues

3. **REFACTOR - Optimize output:**
   - [x] Ensure output is clean and readable
   - [x] Verify markdown renders correctly

**Checklist:**
- [x] Output structure tests passing
- [x] Token estimate included
- [x] Next steps included
- [x] Exploration structure valid

---

### Task 6: Test --output Flag (TDD)

**Purpose:** Test file output functionality

**TDD Flow:**

1. **RED - Write tests:**

```bash
@test "dt-workflow --output saves to file" {
    mkdir -p "$TEST_PROJECT/.cursor/rules"
    local output_file="$TEST_PROJECT/output.md"
    
    run "$DT_WORKFLOW" explore test-feature --interactive --project "$TEST_PROJECT" --output "$output_file"
    [ "$status" -eq 0 ]
    [ -f "$output_file" ]
    
    # Check file contains expected content
    grep -q "dt-workflow Output:" "$output_file"
}

@test "dt-workflow --output shows success message" {
    mkdir -p "$TEST_PROJECT/.cursor/rules"
    local output_file="$TEST_PROJECT/output.md"
    
    run "$DT_WORKFLOW" explore test-feature --interactive --project "$TEST_PROJECT" --output "$output_file"
    [ "$status" -eq 0 ]
    [[ "$output" =~ "Output saved to:" ]]
}
```

2. **GREEN - Verify implementation**
   - [x] Run tests: `bats tests/integration/test-dt-workflow-integration.bats`
   - [x] All tests passing

3. **REFACTOR - Handle edge cases:**
   - [x] Invalid output path
   - [x] Permission errors

**Checklist:**
- [x] --output writes file correctly
- [x] Success message displayed
- [x] Edge cases handled

---

### Task 7: Code Restructuring

**Purpose:** Refactor spike to production structure per script-standards.mdc

**Steps:**

1. **Update header:**
   - [x] Remove "SPIKE" references
   - [x] Update VERSION to "0.2.0"
   - [x] Update description

2. **Add section comments:**
   - [x] Verify CONFIGURATION section
   - [x] Verify FUNCTIONS section (organized as CONTEXT GATHERING, STRUCTURE GENERATION, VALIDATION, OUTPUT GENERATION, HELP AND VERSION)
   - [x] Verify MAIN EXECUTION section
   - [x] Add CONTEXT GATHERING section header
   - [x] Add VALIDATION section header
   - [x] Add OUTPUT GENERATION section header

3. **Add inline documentation:**
   - [x] Document complex logic (context ordering rationale - ADR-002)
   - [x] Document validation levels (L1/L2/L3 with clear explanations)
   - [x] Document token estimation approach (already in function)

4. **Update show_help():**
   - [x] Remove "SPIKE VERSION" text
   - [x] Update phase limitations text
   - [x] Add all supported workflows
   - [x] Add examples section

**Checklist:**
- [x] Header updated (no SPIKE references)
- [x] Version bumped to 0.2.0
- [x] Section comments complete
- [x] Inline documentation added
- [x] Help text production-ready

---

### Task 8: Portability Validation

**Purpose:** Verify dt-workflow works in different repository contexts (NFR-2)

**Steps:**

1. **Test in dev-toolkit:**
   ```bash
   cd ~/Projects/dev-toolkit
   ./bin/dt-workflow explore test-portability --interactive | head -50
   ```

2. **Test in another project:**
   ```bash
   cd ~/Projects/[other-project]
   ~/.dev-toolkit/bin/dt-workflow explore test-portability --interactive | head -50
   ```

3. **Test with no .cursor/rules:**
   ```bash
   cd /tmp
   mkdir test-project && cd test-project
   git init
   ~/.dev-toolkit/bin/dt-workflow explore test-feature --interactive | head -50
   ```

4. **Verify no hardcoded paths:**
   - [x] Search for hardcoded paths: `grep -n "cdwilson\|dev-toolkit" bin/dt-workflow`
   - [x] Should return no matches (only "dev-toolkit" in help text description, which is acceptable)

**Checklist:**
- [x] Works in dev-toolkit
- [x] Works in other projects (tested in minimal project)
- [x] Works with minimal project (no rules)
- [x] No hardcoded paths

---

### Task 9: Final Validation

**Purpose:** Complete validation before marking phase complete

**Steps:**

1. **Run full test suite:**
   ```bash
   bats tests/unit/test-dt-workflow.bats
   bats tests/integration/test-dt-workflow-integration.bats
   ```

2. **Validate script syntax:**
   ```bash
   bash -n bin/dt-workflow
   ```

3. **Run linter (if available):**
   ```bash
   shellcheck bin/dt-workflow
   ```

4. **Manual testing:**
   - [x] `dt-workflow --help` displays correctly
   - [x] `dt-workflow --version` shows 0.2.0
   - [x] `dt-workflow explore test --interactive` produces valid output

5. **Documentation check:**
   - [x] Help text is complete
   - [x] Inline comments explain complex logic (10+ documented functions)
   - [x] Version is 0.2.0

**Checklist:**
- [x] All unit tests passing (25/25 tests)
- [x] All integration tests passing
- [x] Script syntax valid (bash -n passed)
- [x] Manual testing complete
- [x] Documentation complete

---

## 📊 Progress Tracking

| Task | Status | Notes |
|------|--------|-------|
| Task 1: Test Infrastructure | ✅ Complete | Test files created and verified |
| Task 2: Help/Version Tests | ✅ Complete | RED/GREEN/REFACTOR complete |
| Task 3: Validation Tests | ✅ Complete | RED/GREEN/REFACTOR complete |
| Task 4: Context Gathering Tests | ✅ Complete | RED/GREEN/REFACTOR complete |
| Task 5: Output Generation Tests | ✅ Complete | RED/GREEN/REFACTOR complete |
| Task 6: --output Flag Tests | ✅ Complete | RED/GREEN/REFACTOR complete |
| Task 7: Code Restructuring | ✅ Complete | All restructuring complete |
| Task 8: Portability Validation | ✅ Complete | Validated in dev-toolkit and minimal project |
| Task 9: Final Validation | ✅ Complete | All tests passing, syntax valid, documentation complete |

---

## ✅ Completion Criteria

- [x] All unit tests passing (25/25 tests)
- [x] All integration tests passing
- [x] Script syntax validated (`bash -n bin/dt-workflow`)
- [x] Help text complete and accurate
- [x] Portability verified in 2+ different repositories (dev-toolkit + minimal project)
- [x] Code follows script-standards.mdc
- [x] Version updated to 0.2.0

---

## 📦 Deliverables

- `bin/dt-workflow` (v0.2.0) - Production implementation
- `tests/unit/test-dt-workflow.bats` - Unit tests
- `tests/integration/test-dt-workflow-integration.bats` - Integration tests
- Updated `bin/dt-workflow --help` text

---

## 🔗 Dependencies

### Prerequisites

- [x] Spike implementation (`bin/dt-workflow` v0.1.0-spike)
- [x] ADRs accepted
- [x] Pattern library created

### Blocks

- Phase 2: Workflow Expansion (requires Phase 1 foundation)

---

## 🔗 Related Documents

- [Feature Hub](README.md)
- [Feature Plan](feature-plan.md)
- [Next Phase: Phase 2](phase-2.md)
- [Script Standards](../../../../.cursor/rules/script-standards.mdc)
- [ADR-002: Context Injection](../../decisions/dt-workflow/adr-002-context-injection.md)
- [Pattern Library](../../../../docs/patterns/workflow-patterns.md)

---

**Last Updated:** 2026-01-26  
**Status:** 🟠 In Progress  
**Next:** Task 1 in progress
