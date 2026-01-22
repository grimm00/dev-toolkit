# Doc Infrastructure Learnings - Phase 3: dt-doc-validate

**Project:** dev-toolkit  
**Feature:** doc-infrastructure  
**Phase:** 3 - dt-doc-validate  
**Date:** 2026-01-22  
**Status:** ✅ Complete  
**Last Updated:** 2026-01-22

---

## 📋 Overview

Phase 3 implemented the `dt-doc-validate` CLI command with type detection, rule loading, validation logic, and dual output modes. The phase produced 81 tests (19 type-detection, 11 rules, 14 validation, 16 output, 21 integration) and addressed several Bash-specific challenges with global variables and `set -e` behavior.

---

## ✅ What Worked Exceptionally Well

### TDD Workflow with RED-GREEN Pattern

**Why it worked:**
- Each task had explicit RED phase (write failing tests) and GREEN phase (implement to pass)
- Tests defined behavior before implementation, reducing ambiguity
- Immediate feedback loop caught issues early

**What made it successful:**
- Clear task breakdown in phase document (7 tasks with explicit steps)
- Test files created first in scaffolding task
- Mock rules setup in test fixtures enabled isolated testing

**Template implications:**
- Phase documents should include explicit RED/GREEN checklists
- Scaffolding task should create test file structure early
- Mock data patterns should be documented for test authors

**Key examples:**
```bash
# Task structure in phase document
### Task 2: Type Detection Functions (ADR-006)
- [x] RED Phase: Write failing tests
- [x] GREEN Phase: Implement to pass
- [x] Commit with message: feat(phase-3): implement type detection
```

**Benefits:**
- Consistent progress tracking
- Clear definition of done for each task
- Reduced debugging time (tests catch issues immediately)

---

### Type Detection Priority Strategy (ADR-006)

**Why it worked:**
- Clear priority: explicit `--type` flag → path patterns → content detection
- Fallback chain ensures something is always returned
- Path patterns cover 17 document types with specific directory matching

**What made it successful:**
- Comprehensive path patterns for both `admin/` and `docs/maintainers/` structures
- Content-based fallback as safety net
- `DT_DOCUMENT_TYPES` array provides canonical list for validation

**Template implications:**
- Always prioritize explicit user input over auto-detection
- Path patterns should match both legacy and current directory structures
- Content detection should be conservative (only detect high-confidence types)

**Key examples:**
```bash
# Priority chain
dt_detect_document_type() {
    # 1. Explicit type (highest priority)
    if [ -n "${explicit_type:-}" ]; then
        echo "$explicit_type"; return 0
    fi
    # 2. Path-based detection
    if type=$(dt_detect_type_from_path "$file_path"); then
        echo "$type"; return 0
    fi
    # 3. Content-based detection (fallback)
    dt_detect_type_from_content "$file_path"
}
```

**Benefits:**
- User control when needed
- Automatic detection in most cases
- Graceful fallback prevents failures

---

### Pre-Compiled Rule Loading (ADR-002)

**Why it worked:**
- No runtime YAML parsing dependency
- Rules converted to `.bash` files at build-time (in dev-infra)
- Simple `source` command to load rules

**What made it successful:**
- Clear contract: rule files export arrays like `DT_EXPLORATION_REQUIRED_SECTIONS`
- Rules path resolution with override support (`DT_RULES_PATH` env var)
- Graceful handling when rules don't exist (warning, not error)

**Template implications:**
- Build-time rule compilation eliminates runtime dependencies
- Environment variable overrides enable testing and customization
- Missing rules should warn, not fail (allows partial validation)

**Key examples:**
```bash
# Rule loading
dt_load_rules() {
    local rules_file="$rules_path/${doc_type}.bash"
    # shellcheck source=/dev/null
    source "$rules_file"  # Exports DT_*_REQUIRED_SECTIONS arrays
}

# Usage
dt_load_rules "exploration"
# Now DT_EXPLORATION_REQUIRED_SECTIONS is available
```

**Benefits:**
- Zero runtime dependencies
- Fast rule loading (just source a file)
- Easy testing with mock rule files

---

### Dual Output Modes (ADR-004)

**Why it worked:**
- Human-readable text output as default
- Machine-readable JSON for tooling integration
- Simple `--json` flag to switch modes

**What made it successful:**
- Color support with TTY detection for text mode
- Structured JSON with consistent schema
- Exit codes independent of output format (0=success, 1=errors, 2=system)

**Template implications:**
- Always support both human and machine output modes
- TTY detection prevents colors in piped/redirected output
- Exit codes should be consistent regardless of output format

**Key examples:**
```bash
# Exit code logic (independent of output format)
dt_get_exit_code() {
    if [ "${#DT_VALIDATION_ERRORS[@]}" -gt 0 ]; then
        echo 1  # Validation errors
    else
        echo 0  # Success (even with warnings)
    fi
}

# Output selection
if [ "$json_mode" = true ]; then
    dt_format_results_json
else
    dt_output_text
fi
exit "$(dt_get_exit_code)"
```

**Benefits:**
- CI/CD integration via JSON output
- Human-friendly default for interactive use
- Consistent exit codes for scripting

---

## 🟡 What Needs Improvement

### JSON Escaping Completeness

**What the problem was:**
- Only backslashes and quotes were escaped in JSON output
- Newlines, tabs, carriage returns would produce invalid JSON

**Why it occurred:**
- Minimal escaping was implemented for initial functionality
- Edge cases (messages with special characters) not prioritized

**Impact:**
- JSON output could be invalid for certain error messages
- Would break tooling that consumes JSON output

**How to prevent:**
- Use `jq` for JSON generation when available
- Create comprehensive JSON escaping helper function
- Test with messages containing all special characters

**Template changes needed:**
- Add JSON escaping utility function to output-utils.sh
- Document JSON escaping requirements in ADRs

---

### Rules Path Fallback Safety

**What the problem was:**
- If toolkit_root couldn't be determined, would return `/lib/validation/rules`
- Could point to system `/lib` directory (unexpected behavior)

**Why it occurred:**
- Defensive coding gap in `dt_get_rules_path()`
- No explicit failure when toolkit root detection fails

**Impact:**
- Confusing error messages when rules "not found"
- Potential security concern (loading from unexpected path)

**How to prevent:**
- Add explicit guard: fail if toolkit_root is empty
- Return non-zero exit code instead of invalid path
- Clear error message explaining the issue

**Template changes needed:**
- Pattern: Always validate path components before constructing paths
- Pattern: Fail fast rather than return potentially invalid paths

**Note:** This was fixed during PR validation (Sourcery Comment #2).

---

### Bash Global Variable Scoping in Bats

**What the problem was:**
- Tests checking global variables (`DT_VALIDATION_PASSED`) failed when using `run`
- The `run` command executes in a subshell, isolating variable changes

**Why it occurred:**
- Bats `run` command creates subshell for capturing output/exit code
- Global variable changes in subshell don't propagate to parent shell

**Impact:**
- Tests that verify global state changes were failing
- Required workaround: call functions directly (not with `run`)

**How to prevent:**
- Document Bats subshell behavior in testing guidelines
- Use direct function calls when testing global state changes
- Use `run` only when testing output or exit codes

**Template changes needed:**
- Testing guidelines: When to use `run` vs direct calls
- Example patterns for testing global state in Bash

**Key examples:**
```bash
# Testing global state - DON'T use run
@test "validation increments pass count" {
    # Direct call - changes persist in test shell
    dt_validate_file "$valid_file"
    [ "$DT_VALIDATION_PASSED" -eq 1 ]
}

# Testing output - DO use run
@test "validation shows error message" {
    run dt_validate_file "$invalid_file"
    [[ "$output" =~ "Missing required section" ]]
}
```

---

### Arithmetic Expansion with set -e

**What the problem was:**
- `((VAR++))` caused script exit when VAR was 0
- `set -e` treats arithmetic returning 0 as failure

**Why it occurred:**
- Bash quirk: `((expression))` returns exit code 1 if expression evaluates to 0
- `((0++))` returns 1 (incrementing 0 produces 0, which is "false")

**Impact:**
- Intermittent script failures
- Hard to debug (only fails when counter is 0)

**How to prevent:**
- Use `VAR=$((VAR + 1))` instead of `((VAR++))`
- Document this Bash quirk in coding standards
- Add linting rule to catch `((var++))` patterns

**Template changes needed:**
- Script standards: Prefer assignment-style arithmetic
- Example: `count=$((count + 1))` not `((count++))`

---

## 💡 Unexpected Discoveries

### declare -ga and declare -gi for Bats Compatibility

**Finding:**
- Global arrays need `declare -ga` (not just `declare -a`)
- Global integers need `declare -gi` for proper scoping
- Without `-g`, arrays/integers are local even at file scope in Bats context

**Why it's valuable:**
- Explains mysterious scoping issues in Bash tests
- Essential for any validation library with global state

**How to leverage:**
- Use `declare -ga` for all global arrays
- Use `declare -gi` for all global integer counters
- Document in script standards

---

### Nameref Variables for Rule Extraction

**Finding:**
- `local -n` (nameref) enables dynamic array name mapping
- Allows `dt_get_required_sections` to return different arrays based on type

**Why it's valuable:**
- Clean API: caller gets array contents without knowing variable name
- Enables type → rule array mapping without massive case statements

**How to leverage:**
- Use namerefs for functions that return arrays
- Pattern: function populates caller's array via nameref

**Example:**
```bash
dt_get_required_sections() {
    local doc_type="$1"
    local -n result_array="$2"  # Nameref to caller's array
    
    case "$doc_type" in
        exploration*) result_array=("${DT_EXPLORATION_REQUIRED_SECTIONS[@]}") ;;
        research*) result_array=("${DT_RESEARCH_REQUIRED_SECTIONS[@]}") ;;
    esac
}

# Usage
local sections
dt_get_required_sections "exploration" sections
# sections array now populated
```

---

## ⏱️ Time Investment Analysis

**Breakdown:**
- Task 1 (Scaffolding): ~15 min
- Task 2 (Type Detection): ~1 hour
- Task 3 (Rule Loading): ~45 min
- Task 4 (Validation): ~1.5 hours (debugging global vars)
- Task 5 (Output): ~1 hour
- Task 6 (CLI): ~30 min
- Task 7 (Integration): ~45 min
- PR/Validation/Fixes: ~1 hour

**Total:** ~7 hours (less than 1 day)

**What took longer:**
- Task 4 (Validation): Debugging Bats subshell scoping
- Task 5 (Output): JSON formatting edge cases

**What was faster:**
- Task 1, 6: Scaffolding and CLI integration (patterns established in Phase 2)
- Task 7: Integration tests (well-defined expectations)

**Estimation lessons:**
- Phase estimated 3-4 days, completed in ~1 day
- TDD keeps each task focused and efficient
- Debugging Bash quirks takes longer than expected
- Reusing patterns from previous phases accelerates development

---

## 📊 Metrics & Impact

**Code metrics:**
- Lines of code: ~800 (CLI + 4 libraries)
- Test coverage: 81 tests passing
- Files created: 9 (1 CLI, 4 libs, 4 test files)
- Files modified: 2 (phase doc, status doc)

**Quality metrics:**
- Sourcery review: 3 individual + 3 overall comments
- Issues fixed in PR: 2 (rules path guard, doc cleanup)
- Issues deferred: 3 (JSON escaping, pipe separator, type validation)

**Developer experience:**
- Clear TDD workflow reduced context switching
- Phase document served as implementation guide
- Test-first approach caught bugs early

---

## 🔗 Related Documents

- [Phase 3 Document](../../../../features/doc-infrastructure/phase-3.md)
- [ADR-002: Validation Rule Loading](../../../../decisions/doc-infrastructure/adr-002-validation-rule-loading.md)
- [ADR-004: Error Output Design](../../../../decisions/doc-infrastructure/adr-004-error-output-design.md)
- [ADR-006: Type Detection](../../../../decisions/doc-infrastructure/adr-006-type-detection.md)
- [Sourcery Review PR #31](../../../../feedback/sourcery/pr31.md)

---

**Last Updated:** 2026-01-22
