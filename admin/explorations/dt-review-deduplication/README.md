# dt-review Deduplication - Exploration Hub

**Purpose:** Explore options for deduplicating Sourcery comments across multiple review runs  
**Status:** 🔴 Exploration  
**Created:** 2026-01-09  
**Last Updated:** 2026-01-09

---

## 📋 Quick Links

- **[Exploration Document](exploration.md)** - Main exploration document
- **[Research Topics](research-topics.md)** - Research questions to investigate

---

## 🎯 Overview

When using draft PRs with the dev-infra worktree feature workflow, users trigger multiple `@sourcery-ai review` at different milestones. This results in `dt-review` capturing duplicate comments from separate review runs, cluttering the output and priority matrix.

**Origin:** Discovered during dev-infra PR #59 (Worktree Feature Workflow)

**Impact:**
- Duplicate comments in priority matrix
- Harder to assess actual unique issues
- Confusing output for users

---

## 📊 Status

**Current Phase:** Exploration  
**Next Step:** Conduct research on topics identified in research-topics.md

### Progress

- [x] Problem identified and documented
- [x] Initial exploration of GitHub API
- [ ] Research deduplication strategies
- [ ] Research draft vs ready PR behavior differences
- [ ] Decision on approach

---

## 🔗 Related

- **Dev-infra PR #59:** Worktree Feature Workflow
- **Dev-infra ADR-003:** Draft PR Review Workflow
- **Origin Document:** `/Users/cdwilson/Projects/dev-infra/worktrees/feat-worktree-feature-workflow/tmp/dev-toolkit-dt-review-deduplication.md`

---

**Last Updated:** 2026-01-09
