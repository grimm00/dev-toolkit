# CI Workflow Optimization

**Purpose:** Optimize CI workflow to support efficient development with minimal external review overhead  
**Created:** 2025-01-06  
**Status:** Planning  
**Based On:** Sourcery rate limiting discovery and workflow efficiency insights

---

## 📋 Overview

This planning area addresses CI workflow optimization to support the new development workflow where:
1. **Branch Development:** Multiple pushes to feature branches (no external reviews)
2. **PR Creation:** Single PR when feature is complete (single external review)
3. **Result:** Efficient development with minimal Sourcery/Cursor Bugbot quota usage

### Current Problem

**Issue:** CI runs on ALL PRs, but we want different behavior for different branch types:
- **Feature branches:** Need full CI (lint, test, install, docs) but NO external reviews
- **Documentation branches:** Need docs check only, NO external reviews  
- **Release branches:** Need full CI + external reviews

**Solution:** Optimize CI triggers and job configurations based on branch prefixes.

---

## 🎯 Goals

### Primary Goals
- ✅ **Efficient Development:** Support branch-based development workflow
- ✅ **Minimal External Reviews:** Only review when PR is ready for merge
- ✅ **Appropriate CI Coverage:** Right level of testing for each branch type
- ✅ **Cost Optimization:** Reduce Sourcery/Cursor Bugbot quota usage

### Secondary Goals
- ✅ **Clear Branch Conventions:** Standardized branch naming
- ✅ **Automated Workflow:** Minimal manual intervention
- ✅ **Documentation:** Clear guidelines for contributors

---

## 📊 Current State Analysis

### Current CI Triggers
```yaml
on:
  push:
    branches: [ main ]  # Only run on pushes to main (releases)
  pull_request:
    branches: [ main, develop ]  # Run on all PRs
```

### Current Jobs
1. **Lint Shell Scripts** - ShellCheck on bin/, lib/, install.sh, dev-setup.sh
2. **Test Toolkit** - Unit and integration tests
3. **Test Installation** - Global and local installation testing
4. **Check Documentation** - Markdown link checking

### Current Issues
- ❌ **All PRs trigger full CI** (including docs-only PRs)
- ❌ **No branch-specific logic** (feat/ vs docs/ vs ci/ treated same)
- ❌ **External reviews on every push** (Sourcery rate limiting)
- ❌ **No workflow optimization** for different development phases

---

## 🚀 Proposed Solution

### Branch Prefix Strategy
```
feat/     - Feature development (full CI, no external reviews)
docs/     - Documentation only (docs check only, no external reviews)
ci/       - CI/CD changes (full CI, no external reviews)
fix/      - Bug fixes (full CI, no external reviews)
chore/    - Maintenance (minimal CI, no external reviews)
release/  - Release preparation (full CI + external reviews)
```

### CI Job Matrix
| Branch Type | Lint | Test | Install | Docs | External Reviews |
|-------------|------|------|---------|------|------------------|
| `feat/`     | ✅   | ✅   | ✅      | ✅   | ❌               |
| `docs/`     | ❌   | ❌   | ❌      | ✅   | ❌               |
| `ci/`       | ✅   | ✅   | ✅      | ✅   | ❌               |
| `fix/`      | ✅   | ✅   | ✅      | ✅   | ❌               |
| `chore/`    | ✅   | ❌   | ❌      | ❌   | ❌               |
| `release/`  | ✅   | ✅   | ✅      | ✅   | ✅               |

---

## 📁 Planning Documents

### Core Planning
- [Workflow Analysis](workflow-analysis.md) - Current state and requirements
- [Branch Strategy](branch-strategy.md) - Branch naming and conventions
- [CI Optimization](ci-optimization.md) - Technical implementation plan

### Implementation
- [Phase 1: Branch Detection](phase-1-branch-detection.md) - Add branch prefix detection
- [Phase 2: Conditional Jobs](phase-2-conditional-jobs.md) - Implement conditional CI jobs
- [Phase 3: External Review Control](phase-3-external-reviews.md) - Control Sourcery/Cursor Bugbot

### Documentation
- [Quick Start](quick-start.md) - How to use the new workflow
- [Best Practices](best-practices.md) - Development workflow guidelines

---

## 🎯 Success Criteria

### Phase 1: Branch Detection
- [ ] CI can detect branch prefixes (feat/, docs/, ci/, etc.)
- [ ] Conditional logic based on branch type
- [ ] Documentation of branch conventions

### Phase 2: Conditional Jobs  
- [ ] Jobs run only when appropriate for branch type
- [ ] Performance improvement (faster CI for docs-only)
- [ ] Maintained test coverage for code changes

### Phase 3: External Review Control
- [ ] Sourcery only runs on release/ branches
- [ ] Cursor Bugbot only runs on release/ branches
- [ ] Reduced external review quota usage

### Overall Success
- [ ] **Development Efficiency:** Faster iteration on feature branches
- [ ] **Cost Optimization:** 80%+ reduction in external review usage
- [ ] **Quality Maintenance:** Same or better test coverage
- [ ] **Clear Guidelines:** Contributors understand the workflow

---

## 📈 Expected Impact

### Development Speed
- **Feature Development:** 3-5x faster iteration (no external review delays)
- **Documentation:** 10x faster (docs check only)
- **Bug Fixes:** 2-3x faster (no external review delays)

### Cost Savings
- **Sourcery Quota:** 80-90% reduction in usage
- **Cursor Bugbot:** 80-90% reduction in usage
- **CI Minutes:** 30-50% reduction (conditional jobs)

### Quality
- **Test Coverage:** Maintained or improved
- **Code Quality:** Same standards, faster feedback
- **Documentation:** Faster updates, better maintenance

---

## 🚀 Next Steps

1. **Create workflow analysis document** - Detailed current state
2. **Design branch strategy** - Naming conventions and rules
3. **Plan CI optimization** - Technical implementation
4. **Implement Phase 1** - Branch detection
5. **Implement Phase 2** - Conditional jobs
6. **Implement Phase 3** - External review control
7. **Document and train** - Guidelines for contributors

---

**Last Updated:** 2025-01-06  
**Status:** Planning  
**Next:** Create workflow analysis document
