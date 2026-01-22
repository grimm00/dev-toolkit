# Doc Infrastructure Learnings - Phase 2: dt-doc-gen

**Project:** dev-toolkit  
**Feature:** doc-infrastructure  
**Phase:** 2 - dt-doc-gen  
**Date:** 2026-01-22  
**Status:** ✅ Complete  
**Last Updated:** 2026-01-22

---

## 📋 Overview

Phase 2 implemented the `dt-doc-gen` CLI command with template discovery, variable expansion, and document generation. The phase produced 37 tests (18 unit templates, 9 unit render, 10 integration) and established patterns for selective variable expansion and layered template discovery.

---

## ✅ What Worked Exceptionally Well

### Selective envsubst Variable Expansion (ADR-003)

**Why it worked:**
- Only explicitly listed variables are expanded, preventing accidental data corruption
- Preserves special markers like `<!-- AI: -->` in templates
- Much safer than `eval` for shell expansion

**What made it successful:**
- Document-type-specific variable lists: `DT_EXPLORATION_VARS`, `DT_RESEARCH_VARS`, etc.
- Clear separation between template content and expansion targets
- `envsubst` availability check with graceful fallback

**Template implications:**
- Always use selective envsubst over eval for template expansion
- Document which variables each template type expects
- Preserve AI/special markers by not including them in variable lists

**Key examples:**
```bash
# Variable lists per document type
DT_EXPLORATION_VARS='${DATE} ${STATUS} ${TOPIC_NAME} ${TOPIC_TITLE}'
DT_RESEARCH_VARS='${DATE} ${STATUS} ${TOPIC_NAME} ${TOPIC_TITLE} ${RESEARCH_QUESTIONS}'

# Selective expansion (only listed variables)
dt_render_template() {
    local template_path="$1" vars="$2"
    envsubst "$vars" < "$template_path"
}
```

**Benefits:**
- Security: No shell injection risk
- Predictability: Only intended variables are replaced
- Preservation: AI markers and other special content remain intact

---

### Layered Template Discovery (ADR-001)

**Why it worked:**
- Flexible template sourcing: CLI flag → env var → config → default paths
- Supports development (local dev-infra) and production (installed) scenarios
- Clear priority order that users can understand and override

**What made it successful:**
- Environment variable `DEV_INFRA_PATH` for easy development testing
- Auto-detection of sibling `dev-infra` directory
- Sensible default paths in standard locations

**Key examples:**
```bash
dt_find_templates() {
    local explicit_path="$1"
    
    # 1. CLI override (highest priority)
    if [ -n "$explicit_path" ]; then ...
    
    # 2. Environment variable
    if [ -n "${DEV_INFRA_PATH:-}" ]; then ...
    
    # 3. Config file (XDG compliant)
    local config_dir=$(dt_get_xdg_config_home)
    
    # 4. Sibling directory (development)
    # 5. Default paths (production)
}
```

**Template implications:**
- Template discovery should always be layered with clear priorities
- Support both development and production scenarios
- Document the priority order for users

---

### Associative Arrays for Document Type Mapping

**Why it worked:**
- Clean mapping from document types to categories, templates, and output paths
- Single source of truth for type definitions (mostly)
- Easy to extend for new document types

**What made it successful:**
- Bash 4.0+ associative arrays with `declare -gA` for global scope
- Initialization functions called on source
- Consistent naming: `DT_TYPE_CATEGORY`, `DT_TYPE_TEMPLATE`, `DT_TYPE_OUTPUT_DIR`

**Key examples:**
```bash
declare -gA DT_TYPE_CATEGORY=(
    ["exploration"]="exploration"
    ["research"]="research"
    ["adr"]="decision"
    ["planning"]="planning"
)

declare -gA DT_TYPE_OUTPUT_DIR=(
    ["exploration"]="explorations"
    ["research"]="research"
    ["adr"]="decisions"
)
```

**Template implications:**
- Use associative arrays for type→value mappings in Bash 4.0+
- Use `declare -gA` for global scope (critical for sourced libraries)
- Call initialization immediately after declaration

---

### TDD Workflow Continuation

**Why it worked:**
- Phase 1 established the pattern; Phase 2 built on it seamlessly
- 37 tests provided confidence during refactoring (e.g., Sourcery fixes)
- Integration tests caught CLI-level issues unit tests missed

**What made it successful:**
- Test scaffolding created first (Task 1)
- Each function had corresponding unit tests
- Integration tests validated end-to-end behavior

**Benefits:**
- Safely addressed Sourcery review comments (eval→envsubst, type check)
- High confidence in code correctness
- Fast iteration on fixes

---

## 🟡 What Needs Improvement

### Bash Associative Array Scoping in Bats

**What the problem was:**
- Associative arrays declared in library files were empty in bats test subshells
- `declare -A` creates function-local arrays; tests couldn't see them
- Initial tests for `dt_get_template_path` all failed

**Why it occurred:**
- Bats runs each `@test` in a subshell
- Regular `declare -A` doesn't persist across subshells
- Library was sourced, but arrays weren't in global scope

**Impact:**
- Significant debugging time during Task 2
- Required restructuring array declarations

**How to prevent:**
- Always use `declare -gA` (global) for associative arrays in libraries
- Call initialization functions both at source time AND at function start (belt & suspenders)
- Document this gotcha in Bash testing guides

**Template changes needed:**
- [ ] Document Bash associative array scoping in testing guide
- [ ] Template pattern: `declare -gA` + initialization function

**Resolution:**
```bash
# Before (broken in bats)
declare -A DT_TYPE_CATEGORY=(...)

# After (works in bats)
declare -gA DT_TYPE_CATEGORY
_dt_init_template_arrays() {
    DT_TYPE_CATEGORY=(...)
}
_dt_init_template_arrays  # Call immediately
```

---

### Initial eval Usage for Variable Expansion

**What the problem was:**
- Used `eval "echo \"$filename\""` to expand `${VAR}` placeholders in filenames
- Sourcery flagged as security risk (shell injection)
- Even with controlled templates, eval is brittle for future changes

**Why it occurred:**
- Quick implementation path; eval is familiar for shell expansion
- Didn't initially consider safer alternatives for this use case

**Impact:**
- Security concern in code review
- Required fix before PR merge

**How to prevent:**
- Default to envsubst for any variable expansion
- Consider security implications during initial implementation
- Add security review to TDD checklist

**Template changes needed:**
- [ ] Document "prefer envsubst over eval" pattern
- [ ] Add security considerations to implementation guidelines

**Resolution:**
```bash
# Before (security risk)
expanded=$(eval "echo \"$filename\"")

# After (safe)
if command -v envsubst >/dev/null 2>&1; then
    expanded=$(printf '%s\n' "$filename" | envsubst)
else
    expanded="$filename"  # Fallback
fi
```

---

### CLI Validation Order

**What the problem was:**
- Integration test "errors on invalid document type" was failing
- CLI was calling `dt_get_output_dir` before validating document type
- Generic error ("Could not determine output directory") instead of specific error

**Why it occurred:**
- Output directory calculation happened before document type validation
- Validation logic was at end of argument parsing, not before usage

**Impact:**
- Confusing error messages for users
- Test failure

**How to prevent:**
- Validate inputs before using them
- Place validation logic immediately after input gathering
- Write specific test cases for error messages

**Resolution:**
- Moved document type validation case statement before `dt_get_output_dir` call
- Specific error: "Unknown or invalid document type: xyz"

---

## 💡 Unexpected Discoveries

### Pre-existing CI Failures Can Block Unrelated PRs

**Finding:**
The "Check Documentation" CI job failed on PR #30 due to broken links in files NOT modified by the PR (`.cursor/commands/task-improvement.md`, `docs/SOURCERY-SETUP.md`).

**Why it's valuable:**
- CI failures aren't always caused by PR changes
- Need to distinguish pre-existing failures from new regressions
- Documentation link checking runs on entire repo, not just changed files

**How to leverage:**
- Check if failing CI is in files modified by PR
- Document pre-existing CI issues separately
- Consider scoped documentation checking (only changed files)

**Template implications:**
- CI workflows should distinguish pre-existing vs new failures
- Known issues registry can help track chronic CI problems

---

### envsubst Selective Mode is Powerful

**Finding:**
`envsubst '$VAR1 $VAR2'` only expands the listed variables, leaving all others untouched. This is perfect for templates with mixed content.

**Why it's valuable:**
- Preserves `<!-- AI: ${PROMPT} -->` markers in templates
- Prevents accidental expansion of unintended patterns
- Explicit is better than implicit for template expansion

**How to leverage:**
- Define explicit variable lists per document type
- Export only the variables needed for each render
- Use selective mode by default

---

### Document Type Centralization is Needed

**Finding:**
Document type definitions appear in multiple places:
- CLI help text (`bin/dt-doc-gen`)
- Category mapping (`DT_TYPE_CATEGORY`)
- Output directory mapping (`DT_TYPE_OUTPUT_DIR`)
- Output filename mapping (`DT_TYPE_OUTPUT_FILE`)

**Why it's valuable:**
- Risk of definitions drifting out of sync
- Adding a new document type requires changes in multiple places
- Sourcery noted this as MEDIUM priority improvement

**How to leverage:**
- Future improvement: centralize type definitions
- Generate CLI help from type arrays
- Single source of truth for all type metadata

**Template implications:**
- [ ] Design centralized type definition pattern
- [ ] Document where type definitions should live

---

## ⏱️ Time Investment Analysis

**Breakdown:**

- Task 1 (CLI Scaffolding): ~15 minutes
- Task 2 (Template Discovery): ~45 minutes (including array scoping debug)
- Task 3 (Variable Expansion): ~30 minutes
- Task 4 (Output Path Handling): ~20 minutes
- Task 5 (CLI Implementation): ~30 minutes
- Task 6 (Integration Testing): ~20 minutes
- PR Validation + Fixes: ~30 minutes
- Post-PR Documentation: ~20 minutes

**Total:** ~3-4 hours active implementation

**What took longer:**
- Task 2: Debugging associative array scoping in bats
- PR Fixes: Addressing Sourcery security comment (eval→envsubst)

**What was faster:**
- Tasks 3-6: Foundation from Phase 1 + ADRs made implementation straightforward
- Integration tests: Clear patterns from existing dt-* commands

**Estimation lessons:**
- Phase estimate (3-4 days) was conservative; ~1 day with good preparation
- Research/Decision phase (ADRs) pays dividends in implementation speed
- Bash-specific gotchas (array scoping) are hard to estimate

---

## 📊 Metrics & Impact

**Code metrics:**
- Lines of code: 251 (dt-doc-gen) + 317 (templates.sh) + 134 (render.sh) = 702 total
- Test lines: 242 (test-templates.bats) + 166 (test-render.bats) + 192 (test-dt-doc-gen.bats) = 600 total
- Total functions: ~20 (across 3 files)
- Test coverage: 100% (37 tests)

**Quality metrics:**
- Sourcery issues: 2 HIGH (fixed), 2 MEDIUM (deferred)
- Test pass rate: 100%
- Pre-merge fixes: eval→envsubst, type check pattern

**Developer experience:**
- Clear TDD workflow continued from Phase 1
- Layered template discovery provides flexibility
- Selective variable expansion is intuitive once understood

---

## 🎯 Actionable Improvements for Templates

### For Bash Library Development

- [ ] Document `declare -gA` pattern for associative arrays
- [ ] Template initialization function pattern for global arrays
- [ ] Add "Bash scoping in bats" section to testing guide

### For Security

- [ ] Document "prefer envsubst over eval" as default pattern
- [ ] Add security review checklist item for TDD workflow
- [ ] Template secure variable expansion patterns

### For CLI Development

- [ ] Template validation-before-use pattern
- [ ] Document error message best practices
- [ ] Template layered discovery function

### For Template Management

- [ ] Design centralized type definition pattern (deferred MEDIUM)
- [ ] Document where type metadata should live
- [ ] Consider generating CLI help from type definitions

---

**Last Updated:** 2026-01-22
