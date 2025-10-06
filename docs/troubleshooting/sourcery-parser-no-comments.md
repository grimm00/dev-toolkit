# Sourcery Parser Shows "0 Comments" Despite Review

**Issue:** The parser extracts no comments even though Sourcery reviewed your PR.

---

## Symptoms

```bash
$ dt-sourcery-parse 2

📋 Sourcery Review Parser
════════════════════════

📋 Extracting Sourcery Review for PR #2

Summary
Total Comments: 0

✅ Sourcery review parsing completed!
```

But when you check GitHub, you can see Sourcery left a review with feedback.

---

## Root Cause

The `dt-sourcery-parse` tool is designed to extract **inline code comments** - comments that Sourcery leaves on specific lines of code. However, Sourcery sometimes provides **overall feedback** instead, which the parser doesn't currently extract.

### What Gets Extracted (Inline Comments)

```
📝 Comment on line 42 of src/utils.sh:
This function could be simplified using a map operation

📝 Comment on line 58 of lib/parser.sh:
Consider adding type hints here for better IDE support
```

These comments:
- Are attached to specific lines
- Appear in the "Files changed" tab on GitHub
- Get extracted by the parser into a priority matrix

### What Doesn't Get Extracted (Overall Feedback)

```
Hey there - I've reviewed your changes - here's some feedback:

- Consider consolidating duplicated code across modules
- The README now has some duplication that could be refactored
- Great job on the documentation improvements!
```

This feedback:
- Appears in the "Conversation" tab on GitHub
- Is high-level, not line-specific
- Currently NOT extracted by the parser

---

## Why This Happens

### Documentation-Heavy PRs
When your PR is mostly documentation (`.md` files), Sourcery often provides:
- Overall impressions
- High-level suggestions
- General feedback

But no specific line-by-line code comments.

### Code-Heavy PRs
When your PR has significant code changes, Sourcery typically provides:
- Inline comments on specific lines
- Refactoring suggestions with line numbers
- Code quality improvements tied to specific code

The parser was originally designed for code-heavy PRs with inline comments.

---

## Workarounds

### Option 1: View on GitHub (Recommended)

```bash
# Open the PR in your browser
gh pr view 2 --web
```

Then manually read Sourcery's overall feedback in the conversation.

### Option 2: View Raw Review in Terminal

```bash
# See the full review text
gh pr view 2 --json reviews --jq '.reviews[] | select(.author.login == "sourcery-ai") | .body'
```

This shows the raw markdown, which you can read directly.

### Option 3: Copy to File Manually

```bash
# Extract and save to file
gh pr view 2 --json reviews --jq -r '.reviews[] | select(.author.login == "sourcery-ai") | .body' > review.md

# View in your editor
code review.md
```

---

## When to Expect This

You'll likely see "0 comments" when:

| PR Type | Inline Comments? | Overall Feedback? |
|---------|------------------|-------------------|
| Documentation only | ❌ Rare | ✅ Common |
| Small code changes | ❌ Sometimes | ✅ Often |
| Large refactoring | ✅ Common | ✅ Also common |
| New features | ✅ Very common | ✅ Sometimes |

**Rule of thumb:** The more code you change, the more likely you'll get inline comments that the parser can extract.

---

## Is This a Bug?

No, it's a **known limitation**. The parser was designed with a specific use case in mind:

**Original Use Case (Pokehub):**
- Code-heavy PRs with lots of Python/JavaScript
- Sourcery providing detailed inline suggestions
- Need to prioritize which suggestions to implement
- Priority matrix for decision-making

**Current Limitation:**
- Doesn't handle overall feedback
- Designed for inline comments only
- Works great for code, less useful for docs

---

## Future Enhancement

This could be improved! Potential Phase 2 features:

### Extract Overall Comments
```bash
dt-sourcery-parse 2 --include-overall
```

Output:
```markdown
## Overall Feedback
- Consider consolidating duplicated code
- Great documentation improvements

## Inline Comments
(none)
```

### Different Output Modes
```bash
# Just show what Sourcery said
dt-sourcery-parse 2 --mode summary

# Full extraction (current behavior)
dt-sourcery-parse 2 --mode full
```

### Auto-Detect and Adapt
Parser could automatically detect when there are no inline comments and show overall feedback instead.

---

## Related Issues

- **Parser designed for code reviews:** See original design in `admin/planning/features/`
- **Documentation PRs:** Consider manual review for doc-heavy changes
- **Sourcery configuration:** You can't force Sourcery to give inline comments

---

## Remember: Sourcery is Optional!

This limitation doesn't affect core toolkit features:

```bash
# These work perfectly without Sourcery
dt-git-safety check
dt-config show
dt-install-hooks
```

See [Optional Features Guide](../OPTIONAL-FEATURES.md) for more details.

---

## Quick Reference

```bash
# Check if Sourcery reviewed
gh pr view 2 --json reviews --jq '.reviews[].author.login'

# See full review
gh pr view 2 --web

# Extract raw text
gh pr view 2 --json reviews --jq -r '.reviews[] | select(.author.login == "sourcery-ai") | .body'

# Try parser anyway (might work on code PRs)
dt-sourcery-parse 2
```

---

**Last Updated:** October 6, 2025  
**Version:** 0.1.1  
**Status:** Known Limitation
