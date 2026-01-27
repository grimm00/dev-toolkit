# Fix Plan: PR #33 Batch LOW LOW - Batch 01

**PR:** 33  
**Batch:** low-low-01  
**Priority:** 🟢 LOW  
**Effort:** 🟢 LOW  
**Status:** ✅ Complete  
**Completed:** 2026-01-27  
**PR:** #35  
**Created:** 2026-01-27  
**Issues:** 3 issues

---

## Issues in This Batch

| Issue | Priority | Impact | Effort | Description |
|-------|----------|--------|--------|-------------|
| PR33-#1 | 🟢 LOW | 🟢 LOW | 🟢 LOW | Purpose line mismatch in phase-2-template-changes.md |
| PR33-#2 | 🟢 LOW | 🟢 LOW | 🟢 LOW | Validation section heading ambiguity |
| PR33-Overall-#2 | 🟢 LOW | 🟢 LOW | 🟢 LOW | Template variable heading in ADR test |

---

## Overview

This batch contains 3 LOW priority issues with LOW effort. All issues are documentation clarity improvements that don't affect functionality.

**Estimated Time:** 30-45 minutes  
**Files Affected:** `admin/planning/features/dt-workflow/phase-2-template-changes.md`, potentially test file

---

## Issue Details

### Issue PR33-#1: Purpose Line Mismatch

**Location:** `admin/planning/features/dt-workflow/phase-2-template-changes.md:3`  
**Sourcery Comment:** Comment #1  
**Priority:** 🟢 LOW | **Impact:** 🟢 LOW | **Effort:** 🟢 LOW

**Description:**
The Purpose line says this covers Phase 2, Tasks 1-3, but the doc only defines requirements for Task 1 (Exploration) and Task 2 (Research); there's no section for the decision template (Task 3).

**Current Code:**

```markdown
**Purpose:** Document template changes needed in dev-infra for Phase 2, Tasks 1-3
```

**Proposed Solution:**

Option A - Update purpose to match actual content:
```markdown
**Purpose:** Document template changes needed in dev-infra for Phase 2, Tasks 1-2 (Exploration and Research templates)
```

Option B - Add Task 3 section (if decision template changes are needed):
```markdown
## Task 3: Decision Template Changes

[Add decision template requirements here if applicable]
```

**Recommendation:** Option A is simpler - the actual implementation correctly covers all three templates anyway.

---

### Issue PR33-#2: Validation Section Heading Ambiguity

**Location:** `admin/planning/features/dt-workflow/phase-2-template-changes.md:235-244`  
**Sourcery Comment:** Comment #2  
**Priority:** 🟢 LOW | **Impact:** 🟢 LOW | **Effort:** 🟢 LOW

**Description:**
The `## Validation` section comes immediately after the Research template section, making it unclear which template the validation applies to.

**Current Code:**

```markdown
## Research Template Requirements

[Research template content...]

---

## Validation

**Test File:** `dev-toolkit/tests/unit/test-template-enhancement.bats`

Tests validate:
- ✅ Themes table structure exists
[...]
```

**Proposed Solution:**

Add template name to validation headings:
```markdown
## Research Template Requirements

[Research template content...]

---

## Exploration Template Validation

**Test File:** `dev-toolkit/tests/unit/test-template-enhancement.bats`

Tests validate:
- ✅ Themes table structure exists
[...]

---

## Research Template Validation

[Research-specific validation if applicable]
```

---

### Issue PR33-Overall-#2: Template Variable Heading in ADR Test

**Location:** Test file (`test-template-enhancement.bats` or related)  
**Sourcery Comment:** Overall Comment #2  
**Priority:** 🟢 LOW | **Impact:** 🟢 LOW | **Effort:** 🟢 LOW

**Description:**
The test `decision template includes template variable documentation` asserts that `# Template Variables` appears in rendered ADR output, which could leak internal template-doc info into user-facing ADRs.

**Current Code:**

```bash
@test "decision template includes template variable documentation" {
    run render_template decision
    [[ "$output" =~ "# Template Variables" ]]
}
```

**Proposed Solution:**

This is more of a design consideration. Options:

1. **Keep as-is:** The test validates that the templating system can render variable documentation (a valid capability test)

2. **Change test focus:** Validate template variables via `TEMPLATE-VARIABLES.md` only:
   ```bash
   @test "template variables documentation exists" {
       [ -f "$TEMPLATE_ROOT/TEMPLATE-VARIABLES.md" ]
       run grep -q "# Template Variables" "$TEMPLATE_ROOT/TEMPLATE-VARIABLES.md"
       [ "$status" -eq 0 ]
   }
   ```

**Recommendation:** Defer this - the current test is valid for testing templating capabilities. Document the design consideration for future template refinement.

---

## Implementation Steps

1. **Issue PR33-#1 (Purpose line)**

   - [ ] Open `admin/planning/features/dt-workflow/phase-2-template-changes.md`
   - [ ] Update line 3 to match actual content (Tasks 1-2)
   - [ ] Verify no other references need updating

2. **Issue PR33-#2 (Validation headings)**

   - [ ] Add template name to Validation section headings
   - [ ] Ensure each template's validation is clearly labeled
   - [ ] Verify document structure is clear

3. **Issue PR33-Overall-#2 (Template variable heading)**

   - [ ] Review test to understand intent
   - [ ] Decide: keep as-is with comment OR modify test
   - [ ] If keeping: add comment explaining test purpose
   - [ ] If modifying: update to validate via TEMPLATE-VARIABLES.md

---

## Testing

- [ ] Documentation renders correctly (no broken links)
- [ ] Document structure is clearer after changes
- [ ] If test modified: all tests pass
- [ ] No regressions introduced

---

## Files to Modify

- `admin/planning/features/dt-workflow/phase-2-template-changes.md` - Update purpose line and validation headings
- `tests/unit/test-template-enhancement.bats` (optional) - Add comment or modify test

---

## Definition of Done

- [ ] Purpose line matches actual document content
- [ ] Validation sections clearly labeled by template
- [ ] Template variable test has clarifying comment (or modified)
- [ ] Documentation updated
- [ ] Ready for PR

---

**Batch Rationale:**
These issues are batched together because they:
- All have LOW priority and LOW effort
- Are all documentation/clarity improvements
- Don't affect functionality
- Can be completed quickly in one session

---

**Last Updated:** 2026-01-27  
**Next Step:** Use `/fix-implement batch-low-low-01` to begin work
