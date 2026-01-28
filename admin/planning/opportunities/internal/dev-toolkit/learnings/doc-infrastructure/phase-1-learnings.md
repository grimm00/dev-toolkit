# Doc Infrastructure Learnings - Phase 1: Shared Infrastructure

**Project:** dev-toolkit  
**Feature:** doc-infrastructure  
**Phase:** 1 - Shared Infrastructure  
**Date:** 2026-01-21  
**Status:** ✅ Complete  
**Last Updated:** 2026-01-21

---

## 📋 Overview

Phase 1 implemented the shared infrastructure library (`lib/core/output-utils.sh`) with 13 functions and 26 tests. This phase established patterns for XDG compliance, project structure detection, and TDD workflow.

---

## ✅ What Worked Exceptionally Well

### TDD Workflow (RED → GREEN)

**Why it worked:**
- Clear task boundaries: Each task had a RED phase (write failing tests) followed by GREEN phase (implement to pass)
- Immediate feedback: Tests validated implementation as it was built
- Documentation as code: Test cases served as living documentation of expected behavior

**What made it successful:**
- Test scaffolding created first (Task 1)
- Small, focused functions that were easy to test
- Bats framework worked well for Bash testing

**Template implications:**
- TDD workflow should be standard for library/utility code
- Task structure should alternate RED/GREEN phases

**Key examples:**
```bash
# Task 2.1 RED: Write failing tests
@test "dt_get_xdg_config_home: returns XDG_CONFIG_HOME if set" {
    export XDG_CONFIG_HOME="/custom/config"
    run dt_get_xdg_config_home
    [ "$status" -eq 0 ]
    [ "$output" = "/custom/config" ]
}

# Task 2.2 GREEN: Implement to pass
dt_get_xdg_config_home() {
    echo "${XDG_CONFIG_HOME:-$HOME/.config}"
}
```

**Benefits:**
- 100% test pass rate (26/26 tests)
- Confidence in implementation correctness
- Clear definition of done for each task

---

### Function Prefix Convention (dt_*)

**Why it worked:**
- Avoided namespace conflicts with existing `lib/core/github-utils.sh`
- Clear ownership: `dt_` prefix identifies doc-infrastructure functions
- Easier to identify function source when debugging

**What made it successful:**
- Consistent naming across all 13 functions
- Documented in ADR-005

**Template implications:**
- Feature-specific libraries should use unique prefixes
- Prefix should be short but descriptive

**Benefits:**
- No conflicts with existing codebase
- Self-documenting code
- Easy to grep/search for related functions

---

### Layered Detection Strategy

**Why it worked:**
- Prioritized user preferences (environment variables first)
- Graceful fallbacks to sensible defaults
- Supported multiple installation scenarios

**What made it successful:**
- Clear priority order documented in each function
- Each layer had a clear purpose

**Key examples:**
```bash
dt_detect_dev_infra() {
    # 1. Environment variable (highest priority)
    if [ -n "${DEV_INFRA_PATH:-}" ]...
    
    # 2. Sibling directory (common development setup)
    local sibling_path="${toolkit_root%/*}/dev-infra"...
    
    # 3. Common default locations
    local default_paths=(
        "$HOME/Projects/dev-infra"
        "$HOME/.dev-infra"
    )...
}
```

**Template implications:**
- Detection functions should follow layered priority
- Document priority order in comments
- Support environment variable overrides

---

### Backward Compatibility for Project Structure

**Why it worked:**
- Detected existing `admin/` structure first (legacy projects)
- Supported new `docs/maintainers/` structure second
- No breaking changes to existing workflows

**What made it successful:**
- Clear priority: `admin/` before `docs/maintainers/`
- Function returns structure type, letting caller decide behavior
- Documented in ADR-006

**Template implications:**
- When migrating structures, support both old and new
- Detect legacy first to avoid breaking existing projects
- Provide clear migration path

---

## 🟡 What Needs Improvement

### Overlap with Existing github-utils.sh

**What the problem was:**
- Pre-phase review identified overlap between new `output-utils.sh` and existing `github-utils.sh`
- Both have color/output functions, though with different implementations

**Why it occurred:**
- Created new library for doc-infrastructure without fully auditing existing utilities
- Historical evolution: github-utils.sh was project-specific, output-utils.sh is feature-specific

**Impact:**
- Potential code duplication
- Two sources of truth for similar functionality
- Maintenance overhead

**How to prevent:**
- Audit existing utilities before creating new ones
- Consider refactoring opportunity during planning phase

**Template changes needed:**
- Document existing utilities in feature planning
- Include utility audit as part of pre-phase review

**Resolution:**
- Created internal opportunity document: `admin/planning/notes/opportunities/internal/consolidate-output-libs.md`
- Deferred to future consolidation (appropriate since both work independently)

---

### PR Size Limitations for Sourcery Review

**What the problem was:**
- Initial PR #28 included all planning docs + code (92 files, 31,080 lines)
- Exceeded GitHub API limit (20,000 lines) for Sourcery review

**Why it occurred:**
- Planning docs were only on feature branch, not develop
- PR diff included everything not in develop

**Impact:**
- Sourcery couldn't review PR: "The GitHub API does not allow us to fetch diffs exceeding 20000 lines"
- Had to close PR and create code-only PR #29

**How to prevent:**
- Push planning docs to develop separately before code PRs
- Or create code-only PRs from develop (as we did with PR #29)

**Template changes needed:**
- Document PR size best practices
- Recommend separating docs from code in PRs when starting major features

---

## 💡 Unexpected Discoveries

### MEDIUM Priority Discretion Framework

**Finding:**
During PR validation, Sourcery flagged a MEDIUM priority issue (add default case to `dt_print_status`). The initial instinct was to "fix now" since it was LOW effort, but upon reflection, deferral was more appropriate.

**Why it's valuable:**
- Not all MEDIUM issues should be fixed immediately
- Context matters: internal library with controlled call sites
- Expanding PR scope for edge cases can delay delivery

**How to leverage:**
- Added "MEDIUM Priority Discretion" section to `/pr-validation` command
- Decision framework: effort, scope, risk, context, future work
- Key principle: "Don't let perfect be the enemy of good"

**Template implications:**
- PR validation should include discretion guidance
- Priority alone doesn't determine action

---

### Separate Code PRs from Planning PRs

**Finding:**
Feature branches with extensive planning documentation should separate code PRs from documentation PRs to enable proper code review.

**Why it's valuable:**
- Keeps code PRs focused and reviewable
- Enables Sourcery and other tools to work within API limits
- Documentation can be merged directly to develop without PR

**How to leverage:**
- Planning docs can go to develop via docs/* branches (no PR needed)
- Code changes get separate feature branches for PRs

---

## ⏱️ Time Investment Analysis

**Breakdown:**

- Research/Decision Phase: ~2-3 hours (7 research topics, 7 ADRs)
- Transition Planning: ~30 minutes
- Phase 1 Implementation: ~2-3 hours (5 tasks)
- PR Validation/Review: ~30 minutes
- Post-PR Documentation: ~20 minutes

**What took longer:**
- Research/Decision phase: Thorough exploration of options before implementation
- XDG compliance: Required cross-referencing with proj-cli project

**What was faster:**
- TDD implementation: Clear task structure enabled quick iteration
- Detection functions: Patterns were well-established from research

**Estimation lessons:**
- Phase estimate (2-3 days) was accurate for implementation
- Research/Decision phase adds significant upfront time but pays off in clearer implementation
- TDD reduces debugging time significantly

---

## 📊 Metrics & Impact

**Code metrics:**
- Lines of code: 184 (output-utils.sh)
- Test lines: 268 (test-output-utils.bats)
- Total functions: 13
- Test coverage: 100% (26 tests for 13 functions)

**Quality metrics:**
- Sourcery issues: 3 (all MEDIUM/LOW, appropriately deferred)
- Test pass rate: 100%

**Developer experience:**
- Clear TDD workflow improved confidence
- Function prefix convention simplified integration
- Layered detection strategy provides flexibility

---

## 🎯 Actionable Improvements for Templates

### For Phase Planning

- [ ] Include utility audit in pre-phase review checklist
- [ ] Document existing utilities that might overlap
- [ ] Note PR size implications for features with extensive planning

### For TDD Workflow

- [ ] Template TDD task structure (RED/GREEN phases)
- [ ] Include test scaffolding as first task
- [ ] Document expected test coverage targets

### For PR Validation

- [x] Add MEDIUM priority discretion guidance (completed during this phase)
- [ ] Document PR size best practices
- [ ] Include guidance on separating docs from code PRs

### For Library Development

- [ ] Template function prefix convention
- [ ] Template layered detection pattern
- [ ] Template backward compatibility approach

---

**Last Updated:** 2026-01-21
