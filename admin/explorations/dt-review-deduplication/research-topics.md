# Research Topics - dt-review Deduplication

**Purpose:** List of research topics/questions to investigate  
**Status:** 🔴 Pending Research  
**Created:** 2026-01-09  
**Last Updated:** 2026-01-09

---

## 📋 Research Topics

This document lists research topics and questions that need investigation before making decisions.

---

### Research Topic 1: Deduplication Algorithms

**Question:** What's the best algorithm for deduplicating Sourcery comments across multiple review runs?

**Why:** Need to determine the right balance between accuracy (not losing unique comments) and simplicity (easy to implement and understand).

**Priority:** 🔴 High

**Status:** 🔴 Not Started

**Sub-questions:**
- What key to use for deduplication? (`file:line`, `file:line:description[:N]`, hash of full comment?)
- How to handle near-duplicates (same line, slightly different wording)?
- What happens when Sourcery provides different suggestions for same issue?
- Should we use fuzzy matching or exact matching?

**Research approach:**
- Analyze PR #59 comments to understand variation patterns
- Look at how other tools handle similar deduplication
- Test different key strategies with real data

---

### Research Topic 2: GitHub API Capabilities

**Question:** What information can we extract from the GitHub API to support deduplication and draft/ready PR detection?

**Why:** Need to understand what data is available to implement the feature correctly.

**Priority:** 🔴 High

**Status:** 🟡 Partially Explored

**Sub-questions:**
- Can we detect if a PR is a draft? (Yes: `gh pr view --json isDraft`)
- Can we get all Sourcery reviews with timestamps? (Yes: `--json reviews`)
- Can we identify which comments are from which review run?
- Is there a way to get comment-level timestamps?

**Research approach:**
- Document full GitHub API response structure
- Test with multiple PRs (draft and ready)
- Identify what data is available vs what we need

**Findings so far:**
```bash
# Get draft status
gh pr view PR --json isDraft --jq '.isDraft'

# Get all Sourcery reviews
gh pr view PR --json reviews --jq '.reviews[] | select(.author.login == "sourcery-ai")'

# Each review has: submittedAt, body, author
```

---

### Research Topic 3: Draft vs Ready PR Behavior

**Question:** Should `dt-review` behave differently for draft PRs versus ready-for-review PRs?

**Why:** Different use cases may warrant different default behaviors.

**Priority:** 🟡 Medium

**Status:** 🔴 Not Started

**Sub-questions:**
- What's the typical use case for running `dt-review` on a draft PR?
- What's the typical use case for running `dt-review` on a ready PR?
- Should deduplication be default for drafts but not for ready PRs?
- Should `--latest-only` be default for ready PRs?

**Considerations:**

| PR State | Typical Use | Suggested Behavior |
|----------|-------------|-------------------|
| Draft | Active development, multiple reviews | Deduplicate across all reviews |
| Ready | Final review before merge | Show latest review only? |

**Research approach:**
- Interview users (or document personal experience)
- Analyze common workflows
- Consider what information is most useful in each state

---

### Research Topic 4: User Experience Options

**Question:** What command-line options and output formats best serve users?

**Why:** Need to balance simplicity with flexibility.

**Priority:** 🟡 Medium

**Status:** 🔴 Not Started

**Sub-questions:**
- Should deduplication be on by default or opt-in?
- What flags should be available? (`--no-dedup`, `--latest-only`, `--all-reviews`)
- Should output show which review run a comment came from?
- How to indicate when duplicates were removed?

**Potential options:**
```bash
# Option A: Automatic deduplication (default)
dt-review 59                    # Deduplicated output
dt-review 59 --no-dedup         # All comments including duplicates

# Option B: Latest-only default
dt-review 59                    # Latest review only
dt-review 59 --all-reviews      # All reviews with deduplication

# Option C: Draft-aware
dt-review 59                    # Auto-detect: draft=dedup, ready=latest
dt-review 59 --mode draft       # Force draft mode
dt-review 59 --mode ready       # Force ready mode
```

**Research approach:**
- Compare with similar tools' CLI patterns
- Consider backward compatibility
- Test with real workflows

---

### Research Topic 5: Implementation Architecture

**Question:** Where should deduplication logic live and how should it integrate with existing code?

**Why:** Need to maintain code quality and testability.

**Priority:** 🟡 Medium

**Status:** 🔴 Not Started

**Sub-questions:**
- Should deduplication be in `lib/sourcery/parser.sh` or a new module?
- How to test deduplication logic?
- What changes needed to `dt-review` wrapper?
- How to handle the PR draft status check?

**Current architecture:**
```
dt-review (bin/)
  └── dt-sourcery-parse (bin/)
        └── parser.sh (lib/sourcery/)
              └── github-utils.sh (lib/core/)
```

**Considerations:**
- Keep changes minimal and focused
- Add tests for new functionality
- Maintain backward compatibility

---

### Research Topic 6: Edge Cases

**Question:** What edge cases need to be handled?

**Why:** Robust implementation requires handling unusual scenarios.

**Priority:** 🟢 Low

**Status:** 🔴 Not Started

**Sub-questions:**
- What if two different issues are at the same line?
- What if Sourcery changes its comment format?
- What if there are 0 reviews? 1 review? 10+ reviews?
- What if a comment spans multiple lines?
- How to handle rate-limited reviews?

**Research approach:**
- Brainstorm edge cases
- Test with varied PR data
- Document handling strategy for each

---

## 🎯 Research Workflow

1. Use `/research [topic] --from-explore dt-review-deduplication` to conduct research
2. Research will create documents in research directory
3. After research complete, use `/decision [topic] --from-research` to make decisions

---

## 📊 Research Priority Matrix

| Topic | Priority | Complexity | Dependencies |
|-------|----------|------------|--------------|
| Deduplication Algorithms | 🔴 High | Medium | None |
| GitHub API Capabilities | 🔴 High | Low | None |
| Draft vs Ready Behavior | 🟡 Medium | Low | Topic 2 |
| User Experience Options | 🟡 Medium | Medium | Topics 1, 3 |
| Implementation Architecture | 🟡 Medium | Medium | Topics 1, 4 |
| Edge Cases | 🟢 Low | Low | Topic 1 |

**Suggested order:** Topics 1 & 2 (parallel) → Topic 3 → Topics 4 & 5 (parallel) → Topic 6

---

**Last Updated:** 2026-01-09
