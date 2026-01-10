# dt-review Deduplication - Exploration

**Status:** 🔴 Exploration  
**Created:** 2026-01-09  
**Last Updated:** 2026-01-09

---

## 🎯 What Are We Exploring?

Enhancing `dt-review` to handle duplicate Sourcery comments that occur when multiple `@sourcery-ai review` triggers happen on the same PR (common in draft PR workflows).

**Current behavior:** `dt-review` extracts ALL Sourcery comments from ALL review runs, resulting in duplicate entries for unfixed issues.

**Desired behavior:** `dt-review` provides clean, deduplicated output that accurately reflects unique issues.

---

## 🤔 Why Explore This?

### Context: The Draft PR Workflow

Dev-infra has adopted a "Worktree Feature Workflow" (ADR-003) that uses draft PRs with multiple review triggers:

```
1. Open draft PR after first commit
2. Phase 1 → Push → /pr --review
3. Fix issues (sometimes) → Push
4. Phase 2 → Push → /pr --review
5. Fix issues (sometimes) → Push
6. ... repeat ...
7. Mark ready for review
8. Final merge
```

### The Problem

Each `@sourcery-ai review` trigger reviews the **entire PR diff** from `develop` to `HEAD`. If an issue isn't fixed between reviews, Sourcery generates duplicate comments:

**PR #59 Example:**
- 3 Sourcery review runs
- Same "5 topics vs 6 topics" issue flagged 3 times
- `dt-review` output: 12 comments instead of 6 unique ones

### Impact

1. **Cluttered priority matrix** - Same issue appears multiple times
2. **Cognitive overhead** - Users must mentally deduplicate
3. **Wasted effort** - Assessing same issue multiple times
4. **Misleading counts** - "12 comments" sounds worse than "6 unique issues"

---

## 💡 Initial Thoughts

### Approach Options Identified

1. **Deduplicate by location + description** - Key = `file:line:description[:50]`, keep most recent
2. **Filter by review timestamp** - Only show comments from latest review run
3. **Mark review runs** - Keep all but label with `**Review Run:** 1 of 3`
4. **Draft-aware mode** - Different behavior for draft vs ready PRs

### Technical Considerations

- GitHub API returns multiple review objects with timestamps
- Each review contains its own markdown content with comments
- Comments are identified by `### Comment N` pattern in markdown
- Location extracted from `<location>...</location>` tags
- Description extracted from `<issue_to_address>` blocks

### Current Implementation

```bash
# Current flow in lib/sourcery/parser.sh
gh pr view PR --json reviews --jq '.reviews[] | select(.author.login == "sourcery-ai") | .body'
# Returns ALL reviews (may be multiple)
# Parses markdown from first non-empty result
```

**Gap:** Currently only parses the first review found, but API returns array of all reviews.

---

## 🔍 Key Questions

### Deduplication Strategy

- [ ] **Q1:** What's the best key for deduplication? (file:line, file:line:description, other?)
- [ ] **Q2:** When duplicates exist, which comment should be kept? (most recent, first, all with markers?)
- [ ] **Q3:** Should deduplication be automatic or opt-in?

### Draft vs Ready PRs

- [ ] **Q4:** Should behavior differ for draft vs ready PRs?
- [ ] **Q5:** Can we detect PR draft status from GitHub API?
- [ ] **Q6:** What's the typical use case for each state?

### User Experience

- [ ] **Q7:** Should users see which review run a comment came from?
- [ ] **Q8:** Should there be a `--latest-only` flag?
- [ ] **Q9:** Should there be a `--all-reviews` flag to show duplicates?

### Implementation

- [ ] **Q10:** Where should deduplication logic live? (parser.sh, dt-review, new module?)
- [ ] **Q11:** What changes are needed to capture all review runs?
- [ ] **Q12:** How to handle edge cases (same location, different description)?

---

## 📊 Data Gathered

### GitHub API Response Structure

```bash
gh pr view 59 --json reviews --jq '.reviews[] | select(.author.login == "sourcery-ai")'
```

Returns array with:
- `submittedAt` - ISO timestamp of review
- `body` - Full review body (markdown)
- `author.login` - "sourcery-ai"

**PR #59 had 3 reviews:**
- 2026-01-10T01:11:11Z
- 2026-01-10T01:12:57Z
- 2026-01-10T01:46:55Z

### Comment Structure in Markdown

```markdown
### Comment 1
<location>`path/to/file.md:20`</location>
**issue (typo):** Description here
<issue_to_address>
Detailed issue description
</issue_to_address>
```suggestion
suggested fix
```
```

### Duplicate Identification

Duplicates share:
- Same file path
- Same line number (or very close)
- Similar description (first ~50 chars)

---

## 🚀 Next Steps

1. Review research topics in `research-topics.md`
2. Conduct research on:
   - Deduplication strategies (algorithms, keys)
   - GitHub API for PR state detection
   - User experience patterns
3. Make decision on approach (ADR)
4. Implement chosen solution

---

## 📝 Notes

### Insight from ADR-003

The dev-infra "Fix Before Re-Review" pattern recommends fixing issues before requesting next review to naturally avoid duplicates. However:
- Not always followed in practice
- Some issues intentionally deferred
- `dt-review` should handle real-world usage

### Compatibility

Any changes should:
- Be backward compatible (existing scripts work)
- Default to improved behavior
- Allow opt-out if needed

---

**Last Updated:** 2026-01-09
