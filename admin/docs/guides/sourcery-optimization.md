# Sourcery Optimization Guide

**Purpose:** Strategies to minimize Sourcery diffs and get focused reviews  
**Status:** ✅ Current Best Practices  
**Last Updated:** 2025-10-07

---

## 🎯 Goal: Minimize Sourcery Diffs

**Why:** Smaller, focused diffs lead to:
- ✅ More relevant feedback
- ✅ Faster review cycles
- ✅ Lower quota usage
- ✅ Better code quality focus

---

## 📋 Pre-PR Checklist

### ✅ File Scope
- [ ] **Only code files changed** (no docs, planning, config)
- [ ] **Minimal file count** (< 5 files ideal)
- [ ] **Focused changes** (one clear purpose)
- [ ] **No unrelated changes** (separate PRs for different features)

### ✅ Change Size
- [ ] **Small diff** (< 50 lines ideal)
- [ ] **Focused logic** (one function/feature)
- [ ] **No refactoring** (separate PR for refactoring)
- [ ] **No formatting** (separate PR for formatting)

### ✅ Commit Strategy
- [ ] **Single responsibility** (one clear purpose)
- [ ] **Descriptive message** (clear what changed)
- [ ] **Clean history** (no merge commits in feature branch)
- [ ] **Atomic changes** (each commit is complete)

---

## 🚀 Optimization Strategies

### 1. **Enhanced .sourcery.yaml**

**Current configuration optimizes for:**
- ✅ **Code-only reviews** (excludes docs, planning, logs)
- ✅ **Focused scope** (only changed files)
- ✅ **Quality focus** (bash strict mode)
- ✅ **Efficiency** (skip docs-only PRs)

### 2. **PR Size Strategy**

**Ideal PR characteristics:**
- **Files changed:** 1-3 files
- **Lines changed:** 5-50 lines
- **Purpose:** Single feature/fix
- **Scope:** One component

**Examples:**
```bash
# ✅ Good: Focused PR
feat: Fix local parser integration for dt-review
- 3 files changed
- 8 lines added
- Single purpose: path detection

# ❌ Bad: Mixed PR
feat: Add new feature + fix bugs + update docs + refactor
- 15 files changed
- 200+ lines changed
- Multiple purposes
```

### 3. **File Organization**

**Keep changes in focused files:**
- ✅ **Core logic only** (`bin/`, `lib/`)
- ✅ **No documentation** (excluded by `.sourcery.yaml`)
- ✅ **No test files** (separate PRs for tests)
- ✅ **No config changes** (separate PRs for config)

### 4. **Branch Strategy**

**Feature branches for focused changes:**
- ✅ **Single feature** (`feat/feature-name`)
- ✅ **Clear purpose** (one responsibility)
- ✅ **Clean history** (no merge commits)
- ✅ **Easy to review** (focused diff)

### 5. **Commit Strategy**

**Small, focused commits:**
```bash
# ✅ Good: Focused commit
git commit -m "feat: Fix local parser integration for dt-review"

# ❌ Bad: Mixed commit
git commit -m "feat: Fix parser + update docs + add tests + refactor"
```

---

## 📊 Current PR Analysis

### ✅ **Phase 2 PR: Excellent Example**

**Files changed:** 3
- `bin/dt-review` (path detection fix)
- `bin/dt-sourcery-parse` (path detection fix)
- `admin/feedback/sourcery/pr09.md` (cleanup)

**Lines changed:** 8 additions, 310 deletions
- **Net change:** -302 lines (cleanup)
- **Actual changes:** 8 lines (minimal)
- **Purpose:** Single feature (local parser integration)

**Sourcery impact:** Minimal
- ✅ Only code files reviewed
- ✅ Tiny diff (8 lines)
- ✅ Single purpose
- ✅ No documentation changes

---

## 🎯 Best Practices

### 1. **Single Responsibility Principle**

**Each PR should have one clear purpose:**
- ✅ **Feature addition** (one feature)
- ✅ **Bug fix** (one bug)
- ✅ **Refactoring** (one component)
- ✅ **Documentation** (one section)

### 2. **Minimal Scope**

**Keep changes focused:**
- ✅ **One component** (not multiple)
- ✅ **One feature** (not multiple)
- ✅ **One fix** (not multiple)
- ✅ **One improvement** (not multiple)

### 3. **Clean History**

**Maintain clean git history:**
- ✅ **Feature branches** (not direct to main)
- ✅ **Focused commits** (one purpose each)
- ✅ **Descriptive messages** (clear what changed)
- ✅ **No merge commits** (in feature branches)

### 4. **Separation of Concerns**

**Separate different types of changes:**
- ✅ **Code changes** (separate PR)
- ✅ **Documentation** (separate PR)
- ✅ **Tests** (separate PR)
- ✅ **Configuration** (separate PR)

---

## 🚨 Anti-Patterns to Avoid

### ❌ **Mixed Purpose PRs**
```bash
# Bad: Multiple purposes
feat: Add new feature + fix bugs + update docs + refactor
```

### ❌ **Large Diffs**
```bash
# Bad: Too many changes
- 20 files changed
- 500+ lines changed
- Multiple features
```

### ❌ **Unrelated Changes**
```bash
# Bad: Unrelated changes
feat: Fix parser integration
+ Update README
+ Add new tests
+ Refactor other component
```

### ❌ **Documentation in Code PRs**
```bash
# Bad: Mixed content
feat: Fix parser integration
+ Update documentation
+ Add planning notes
+ Update changelog
```

---

## 📈 Success Metrics

### **Ideal PR Characteristics:**
- **Files changed:** 1-3 files
- **Lines changed:** 5-50 lines
- **Purpose:** Single feature/fix
- **Scope:** One component
- **Sourcery feedback:** 0-3 suggestions
- **Review time:** < 1 hour

### **Current Performance:**
- ✅ **Phase 2 PR:** 3 files, 8 lines, single purpose
- ✅ **Sourcery impact:** Minimal
- ✅ **Review focus:** Path detection logic only
- ✅ **Quality:** High (focused changes)

---

## 🎯 Summary

**To minimize Sourcery diffs:**

1. **Keep PRs small and focused** (1-3 files, 5-50 lines)
2. **Single responsibility** (one clear purpose)
3. **Separate concerns** (code vs docs vs tests)
4. **Clean history** (focused commits)
5. **Use .sourcery.yaml** (exclude non-code files)

**Result:** More relevant feedback, faster reviews, better code quality.

---

**Last Updated:** 2025-10-07  
**Status:** ✅ Current Best Practices  
**Based On:** Phase 2 PR Success
