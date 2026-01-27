# Fix Plan: PR #32 Batch LOW MEDIUM - Batch 01

**PR:** 32  
**Batch:** low-medium-01  
**Priority:** 🟢 LOW  
**Effort:** 🟡 MEDIUM  
**Status:** 🔴 Not Started  
**Created:** 2026-01-27  
**Issues:** 1 issue

---

## Issues in This Batch

| Issue | Priority | Impact | Effort | Description |
|-------|----------|--------|--------|-------------|
| PR32-#1 | 🟢 LOW | 🟡 MEDIUM | 🟡 MEDIUM | Centralize kebab-to-Title Case transformation |

---

## Overview

This batch contains 1 LOW priority issue with MEDIUM effort. The issue addresses code duplication in render.sh by extracting the kebab-to-Title Case transformation into a reusable helper function.

**Estimated Time:** 1-2 hours  
**Files Affected:** `lib/doc-gen/render.sh`

**Note:** This was originally deferred to Phase 2 since render.sh is Phase 2 scope. Can be implemented when working on render.sh enhancements.

---

## Issue Details

### Issue PR32-#1: Centralize Kebab-to-Title Case Transformation

**Location:** `lib/doc-gen/render.sh:13-19`  
**Sourcery Comment:** Comment #1  
**Priority:** 🟢 LOW | **Impact:** 🟡 MEDIUM | **Effort:** 🟡 MEDIUM

**Description:**
The kebab-to-Title Case `sed`/`awk` pipeline for `topic_name` appears in multiple setters (`dt_set_exploration_vars`, `dt_set_research_vars`, `dt_set_decision_vars`). Centralizing this in a helper (e.g. `dt_to_title_case()`) would eliminate duplication and ensure consistent behavior if the transformation changes.

**Current Code (pattern appears multiple times):**

```bash
# In dt_set_exploration_vars
topic_name=$(echo "$topic" | sed 's/-/ /g' | awk '{for(i=1;i<=NF;i++) $i=toupper(substr($i,1,1)) tolower(substr($i,2))}1')

# In dt_set_research_vars
topic_name=$(echo "$topic" | sed 's/-/ /g' | awk '{for(i=1;i<=NF;i++) $i=toupper(substr($i,1,1)) tolower(substr($i,2))}1')

# In dt_set_decision_vars
topic_name=$(echo "$topic" | sed 's/-/ /g' | awk '{for(i=1;i<=NF;i++) $i=toupper(substr($i,1,1)) tolower(substr($i,2))}1')
```

**Proposed Solution:**

1. **Create helper function:**
   ```bash
   # Convert kebab-case to Title Case
   # Usage: dt_to_title_case "my-kebab-string"
   # Output: "My Kebab String"
   dt_to_title_case() {
       local input="$1"
       echo "$input" | sed 's/-/ /g' | awk '{for(i=1;i<=NF;i++) $i=toupper(substr($i,1,1)) tolower(substr($i,2))}1'
   }
   ```

2. **Update setter functions:**
   ```bash
   # In dt_set_exploration_vars
   topic_name=$(dt_to_title_case "$topic")
   
   # In dt_set_research_vars
   topic_name=$(dt_to_title_case "$topic")
   
   # In dt_set_decision_vars
   topic_name=$(dt_to_title_case "$topic")
   ```

**Benefits:**
- Single source of truth for transformation logic
- Easier to update if transformation needs to change
- More readable code in setter functions
- Can be tested independently
- Consistent behavior guaranteed

**Alternative Considerations:**

If performance is a concern (subshell overhead), could use bash parameter expansion:
```bash
dt_to_title_case() {
    local input="$1"
    local result=""
    local word
    for word in ${input//-/ }; do
        result+="${word^} "
    done
    echo "${result% }"  # Remove trailing space
}
```
Note: This requires bash 4.0+ for `${word^}` syntax.

---

## Implementation Steps

1. **Issue PR32-#1**

   - [ ] Read `lib/doc-gen/render.sh` to identify all occurrences
   - [ ] Create `dt_to_title_case()` helper function
   - [ ] Place helper near top of file (after variable declarations)
   - [ ] Update `dt_set_exploration_vars` to use helper
   - [ ] Update `dt_set_research_vars` to use helper
   - [ ] Update `dt_set_decision_vars` to use helper
   - [ ] Check for any other occurrences of the pattern
   - [ ] Run existing tests to verify no regressions
   - [ ] Add test for `dt_to_title_case` function (if test file exists)

---

## Testing

- [ ] All existing render.sh tests pass
- [ ] `dt_to_title_case "my-topic"` returns "My Topic"
- [ ] `dt_to_title_case "multi-word-topic-name"` returns "Multi Word Topic Name"
- [ ] `dt_to_title_case "single"` returns "Single"
- [ ] No regressions in document generation
- [ ] Manual test: generate exploration/research/decision docs

---

## Files to Modify

- `lib/doc-gen/render.sh` - Add helper and update setter functions
- `tests/unit/test-render.bats` (if exists) - Add tests for helper function

---

## Definition of Done

- [ ] `dt_to_title_case()` helper function created
- [ ] All setter functions updated to use helper
- [ ] Tests passing
- [ ] Code reviewed
- [ ] Ready for PR

---

**Batch Rationale:**
This issue is in its own batch because:
- It's LOW priority but MEDIUM effort
- Originally deferred to Phase 2 (render.sh scope)
- Self-contained refactoring in single file
- Can be done independently of other fixes

---

**Last Updated:** 2026-01-27  
**Next Step:** Use `/fix-implement batch-low-medium-01` to begin work (when working on render.sh)
