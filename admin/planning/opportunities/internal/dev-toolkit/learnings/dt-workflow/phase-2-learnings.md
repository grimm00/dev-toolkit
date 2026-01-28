# dt-workflow Phase 2 Learnings

**Project:** dev-toolkit  
**Feature:** dt-workflow  
**Phase:** 2 - Workflow Expansion + Template Enhancement  
**Date:** 2026-01-26  
**PR:** #33  
**Status:** ✅ Complete  
**Last Updated:** 2026-01-26

---

## 📋 Overview

Phase 2 implemented research and decision workflows with enhanced templates per ADR-006. Key accomplishments:
- 15 TDD tasks across 5 task groups
- 48 tests passing (full workflow chain validated)
- Cross-project template enhancement (dev-infra PR #64)
- Complete explore→research→decision workflow chain

---

## ✅ What Worked Exceptionally Well

### TDD Checkbox Methodology

**Why it worked:**
The RED/GREEN/REFACTOR checkbox pattern in phase documents provided clear progress tracking and ensured nothing was skipped.

**What made it successful:**
- Explicit checkboxes for each TDD phase
- Visual progress through the document
- Prevented "green without red" shortcuts
- Forced consideration of refactoring step

**Template implications:**
- Phase documents should always include TDD checkboxes when implementing code
- Format: `- [ ] **RED:** ...`, `- [ ] **GREEN:** ...`, `- [ ] **REFACTOR:** ...`

**Key example:**
```markdown
1. **RED - Write failing test:**
   - [x] Create test that validates template output
   - [x] Verify test fails (current templates lack structural examples)

2. **GREEN - Implement minimum code:**
   - [x] Update template with structural examples
   - [x] Verify test passes
```

### render.sh Template System

**Why it worked:**
Using render.sh for template rendering instead of heredocs in the main script provided:
- Separation of concerns (templates vs logic)
- Easier template maintenance
- Cross-project template sharing
- Consistent variable expansion

**What made it successful:**
- Clear template variable contract (`lib/doc-gen/TEMPLATE-VARIABLES.md`)
- Selective variable expansion (only expand DT_* variables, preserve others)
- Template validation in tests

**Template implications:**
- Document all template variables in a central location
- Use `envsubst` with variable list for selective expansion
- Templates should be external files, not heredocs

### Cross-Project Coordination Pattern

**Why it worked:**
Phase 2 required changes in both dev-toolkit and dev-infra. The pattern of:
1. Creating dev-toolkit tests first (RED)
2. Updating dev-infra templates (GREEN)
3. Validating in dev-toolkit (REFACTOR)

**What made it successful:**
- Tests defined the contract
- Templates could be developed independently
- Changes were validated automatically

**Key example:**
- dev-toolkit: `test-template-enhancement.bats` defined expectations
- dev-infra: Templates enhanced to meet expectations
- Coordination via GitHub issues (#11 in dev-toolkit → work in dev-infra)

### Workflow Chaining via Handoff Files

**Why it worked:**
Pattern 4 (Handoff File Contract) provided standardized data exchange:
- `research-topics.md` from explore → research
- `research-summary.md` from research → decision

**What made it successful:**
- Clear file naming convention
- Standardized content sections
- Auto-detection via `--from-explore` and `--from-research` flags
- Graceful fallback to manual path specification

**Benefits:**
- Workflows chain naturally
- Context flows through pipeline
- Easy to test each stage independently
- Clear contract between workflows

---

## 🟡 What Needs Improvement

### Manual Testing Documentation Iteration

**What the problem was:**
The manual testing guide required multiple iterations:
1. Initial version only added checklist, not full scenarios
2. Used heredocs for test data setup (caused terminal issues)
3. grep patterns with `<!-- REQUIRED:` caused problems when copied

**Why it occurred:**
- Rushed to add Phase 2 content without verifying executability
- Assumed heredocs would work smoothly in terminal
- HTML-like patterns interact poorly with terminal interpretation

**Impact:**
- User got stuck in `heredoc>` prompt
- Had to debug grep command issues
- Multiple commits to fix issues

**How to prevent:**
- Test manual testing scenarios yourself before committing
- Use simple `echo` commands instead of heredocs
- Avoid special characters in grep patterns when possible
- When using HTML/XML patterns, simplify to avoid terminal issues

**Template changes needed:**
- Manual testing guides should prefer single-line setup commands
- Document gotchas with heredocs in terminal environments

### Template Path Portability

**What the problem was:**
Tests hardcode dev-infra template paths under `$HOME/.../dev-infra`, making them environment-specific.

**Why it occurred:**
- Focused on getting tests working in development environment
- Didn't consider CI/CD or other developers' setups

**Impact:**
- Tests may fail in CI/CD
- Other developers need specific directory structure
- Medium priority issue identified in Sourcery review

**How to prevent:**
- Use environment variable for template root
- Allow configuration injection
- Document required setup in test README

**Template changes needed (deferred):**
- Allow `DT_TEMPLATE_ROOT` environment variable
- Fall back to default if not set

### Directory Creation Clarification

**What the problem was:**
Users expected `dt-workflow explore topic --interactive` to create the exploration directory, but `--interactive` mode only outputs to stdout.

**Why it occurred:**
- Phase 1 scope was deliberately limited to stdout-only
- `--generate` mode (which would create directories) planned for later phase
- Not clearly documented in manual testing guide

**Impact:**
- User confusion during manual testing
- Extra step required: `mkdir -p` before redirect

**How to prevent:**
- Clearly document mode limitations upfront
- Add notes to manual testing about what each mode does/doesn't do
- Consider adding `--generate` mode earlier in roadmap

---

## 💡 Unexpected Discoveries

### Workflow Validation Can Catch Chaining Issues Early

**Finding:**
The `--validate` flag proved useful for checking prerequisites before running full workflow.

**Why it's valuable:**
- Quick feedback on missing dependencies
- No wasted time on partial output
- Clear error messages guide user

**How to leverage:**
- Recommend `--validate` before `--interactive` in docs
- Use in CI/CD to verify workflow setup

### grep Patterns Need Terminal-Safe Escaping

**Finding:**
Patterns like `<!-- REQUIRED:` in grep commands caused issues when copy-pasted from documentation into terminal.

**Why it's valuable:**
- Many technical docs include HTML/XML patterns
- Terminal interpretation can mangle special characters
- Simpler patterns (`REQUIRED:`) work reliably

**How to leverage:**
- In manual testing guides, prefer simple grep patterns
- Document terminal-safe alternatives
- Consider adding `--color=always` for visibility

### Cross-Project TDD Works Well with GitHub Issues

**Finding:**
Creating a GitHub issue in the source project (dev-toolkit) that links to work in another project (dev-infra) provides good traceability.

**Why it's valuable:**
- Clear audit trail
- Enables draft PRs as contracts
- Works with existing GitHub workflow

**How to leverage:**
- Document this pattern for future cross-project features
- Consider formalizing as a workflow pattern

---

## ⏱️ Time Investment Analysis

**Actual Duration:** ~14 hours (within 14-18 hour estimate)

**Breakdown:**

| Activity | Time | Notes |
|----------|------|-------|
| Template Enhancement (Tasks 1-2) | 3 hours | Cross-project coordination |
| Research Workflow (Tasks 3-7) | 4 hours | Including render.sh integration |
| Decision Workflow (Tasks 8-12) | 4 hours | Similar pattern to research |
| Integration Testing (Tasks 13-15) | 2 hours | Full chain validation |
| Manual Testing & Fixes | 1 hour | Iteration on guide |

**What took longer:**
- Cross-project coordination (creating dev-infra issue, waiting for PR)
- Manual testing guide iteration (multiple fixes)

**What was faster:**
- Decision workflow (pattern established by research workflow)
- Integration tests (reusable test patterns)

**Estimation lessons:**
- Cross-project work adds 20-30% overhead
- Second workflow implementation is ~50% faster than first
- Budget extra time for manual testing guide validation

---

## 📊 Metrics & Impact

**Code metrics:**
- Lines of code: ~800 new lines in render.sh, templates.sh
- Test coverage: 48 tests passing
- Files modified: 15+ files across both projects

**Quality metrics:**
- Sourcery issues: 4 deferred (1 MEDIUM, 3 LOW)
- No CRITICAL/HIGH issues
- All deferred issues are improvements, not bugs

**Developer experience improvements:**
- Single command for each workflow stage
- Consistent context injection across workflows
- Clear handoff file contract
- Template variable documentation

---

## 🎯 Recommendations for Future Phases

### For Phase 3 (Cursor Integration)

1. **Test Cursor command updates manually** - Verify the dt-workflow Integration sections work in practice
2. **Document any IDE-specific behaviors** - Cursor may have behaviors not present in CLI testing
3. **Keep cross-references current** - ADR-004 link should work from all commands

### For Future Features

1. **Start with cross-project planning** - Identify dependencies early
2. **Write tests that define contracts** - Tests should specify what templates must provide
3. **Budget for manual testing iteration** - Guides need to be validated by execution
4. **Consider terminal safety** - Special characters in patterns can cause issues

---

## 🔗 Related Documents

- [Phase 2 Document](../../../features/dt-workflow/phase-2.md)
- [ADR-006: Template Enhancement](../../../decisions/dt-workflow/adr-006-template-enhancement.md)
- [PR #33](https://github.com/grimm00/dev-toolkit/pull/33)
- [Sourcery Review](../../../feedback/sourcery/pr33.md)

---

**Last Updated:** 2026-01-26
