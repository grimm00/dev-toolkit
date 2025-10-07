# Enhancement: Capture Sourcery "Overall Comments"

**Date:** 2025-10-07  
**Reporter:** Pokehub project  
**Priority:** 🟡 MEDIUM

---

## Issue

`dt-review` currently captures individual code comments from Sourcery reviews, but **does not capture the "Overall Comments" section** that Sourcery provides at the top of reviews.

---

## Example

**Sourcery Review Structure:**
```markdown
## Overall Comments
- Consider adding tests that actually execute docker-startup.sh...
- The original plan included environment variable validation...
- You might extract common grep assertions...

## Comment 1
[Individual comment details]

## Comment 2
[Individual comment details]
```

**Current `dt-review` Output:**
- ✅ Captures: Comment 1, Comment 2, etc.
- ❌ Missing: Overall Comments section

---

## Impact

**User Feedback:**
> "I also notice the 'overall comments' aren't ever brought down from the reviews, which would be helpful."

**Why It Matters:**
- Overall comments often contain high-level strategic feedback
- They provide context for individual comments
- They may suggest architectural improvements
- They're valuable for planning follow-up work

---

## Proposed Solution

### Option 1: Add Overall Comments Section
Update `dt-review` parser to:
1. Detect "Overall Comments" section
2. Extract bullet points
3. Add to output before individual comments

**Output Format:**
```markdown
## 🎯 Sourcery Review

**Overall Comments:** 3 high-level suggestions

### Overall Comment 1: [Summary]
**Sourcery Feedback:**
> [Full comment text]

**Priority:** [TBD]
**Analysis:** [TBD]
**Recommendation:** [TBD]

---

### Comment 1: [Individual comment]
[Existing format]
```

### Option 2: Separate Overall Comments Section
Keep overall comments separate from individual comments:

```markdown
## 📋 Overall Comments

1. [Comment 1]
2. [Comment 2]
3. [Comment 3]

---

## 🎯 Individual Comments

### Comment 1: [Title]
[Existing format]
```

---

## Implementation Notes

### Parser Changes
- Look for `## Overall Comments` heading
- Extract bullet points until next `##` heading
- Store in separate array
- Format in output template

### Template Changes
- Add overall comments section
- Decide on numbering/priority scheme
- Maintain existing individual comment format

---

## Priority

**Priority:** 🟡 MEDIUM

**Rationale:**
- Not blocking current functionality
- Overall comments are valuable but not critical
- Can be added incrementally
- Manual workaround: Copy/paste overall comments

---

## Related

- **Project:** dev-toolkit
- **Component:** `lib/sourcery/review-parser.sh`
- **Reported by:** Pokehub project (PR #39 review)
- **Date:** 2025-10-07

---

**Status:** 📋 Enhancement Requested  
**Next:** Add to dev-toolkit backlog
