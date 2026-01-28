# PR Validation Command - Improvement Notes

**Created:** 2026-01-26  
**Source:** PR #32 validation session  
**Status:** 🔴 Proposal

---

## Problem Identified

During PR #32 validation, the AI tended to skip manual testing guide creation by rationalizing:
- "Covered by Task 9 validation" 
- "25 automated tests are sufficient"
- Auto-detecting that manual testing "isn't required"

**Root cause:** The `/pr-validation` command does many things in one workflow, and under workload pressure, the AI finds ways to skip the more labor-intensive parts (especially manual testing guide creation).

**Why this matters:**
- Manual testing guides are **documentation for humans**, not just an internal checklist
- They persist in the repo for future maintainers
- They document user scenarios and edge cases
- They're different from automated tests in purpose and audience

---

## Proposed Improvements

### Option 1: Separate Flags for Workflow Parts

Add flags to `/pr-validation` to run specific parts:

```bash
/pr-validation 32 --phase 1 --only-testing    # Just manual testing scenarios
/pr-validation 32 --phase 1 --only-review     # Just Sourcery review
/pr-validation 32 --phase 1 --only-ci         # Just CI status check
/pr-validation 32 --phase 1 --full            # Everything (default)
```

**Pros:**
- Keeps unified command
- User can focus AI on specific tasks
- Reduces cognitive load per invocation

**Cons:**
- More flags to remember
- May still be skipped if user doesn't know to use them

---

### Option 2: Mandatory Checkpoints

Make manual testing guide creation a **blocking** step for `feat/*` PRs:

- If no `manual-testing.md` exists for the feature, BLOCK validation
- Require explicit `--skip-manual-testing --reason "..."` with justification
- Remove auto-detection that rationalizes skipping

**Pros:**
- Forces the work to happen
- Documents why it was skipped (if skipped)

**Cons:**
- May slow down workflow
- Needs clear criteria for when testing IS required

---

### Option 3: Separate Commands

Split into focused commands:

```bash
/pr-manual-testing 32 --phase 1   # Focus only on manual testing guide
/pr-sourcery-review 32            # Focus only on code review
/pr-ci-check 32                   # Focus only on CI status
/pr-validation 32 --phase 1       # Orchestrates all of above
```

**Pros:**
- Each command has clear, focused purpose
- Easier to ensure each part is done properly
- Can be invoked independently

**Cons:**
- More commands to learn
- User needs to know which to run

---

### Option 4: Two-Phase Validation

Split validation into preparation and execution:

```bash
/pr-validation-prep 32 --phase 1   # Creates/updates manual testing guide, runs dt-review
/pr-validation-run 32 --phase 1    # Executes tests, fills priority matrix, final checks
```

**Pros:**
- Prep phase ensures documentation exists before execution
- Execution phase is faster (documentation already done)

**Cons:**
- Two commands for one workflow

---

## Recommendation

**Option 1 (Separate Flags)** combined with **Option 2 (Mandatory Checkpoints)**:

1. Add `--only-*` flags for focused work
2. Make manual testing guide creation mandatory for `feat/*` PRs
3. Require explicit skip with justification: `--skip-manual-testing --reason "docs-only change"`

This gives flexibility while ensuring the important work happens.

---

## Implementation Notes

If implementing, update:
- `.cursor/commands/pr-validation.md`
- Add validation check for `manual-testing.md` existence
- Add flag handling for `--only-*` options
- Add skip justification requirement

---

## Related

- [PR #32 Sourcery Review](sourcery/pr32.md)
- [dt-workflow Manual Testing Guide](../planning/features/dt-workflow/manual-testing.md)

---

**Last Updated:** 2026-01-26
