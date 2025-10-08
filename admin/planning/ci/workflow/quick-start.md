# CI Workflow Quick Start

**Purpose:** Quick reference guide for the optimized CI workflow  
**Created:** 2025-01-06  
**Status:** Planning  
**Based On:** Branch strategy and CI optimization plan

---

## 🚀 Quick Start Guide

### For Contributors

#### 1. Choose Your Branch Type
```bash
# Feature development
git checkout -b feat/your-feature-name

# Documentation updates
git checkout -b docs/your-doc-update

# CI/CD changes
git checkout -b ci/your-ci-change

# Bug fixes
git checkout -b fix/your-bug-fix

# Maintenance tasks
git checkout -b chore/your-maintenance-task

# Release preparation
git checkout -b release/your-release-version
```

#### 2. Develop and Iterate
```bash
# Work on your branch
git add .
git commit -m "Your commit message"
git push origin your-branch-name

# Continue iterating
git add .
git commit -m "Another commit"
git push origin your-branch-name
```

#### 3. Create PR When Ready
```bash
# Only create PR when feature is complete
gh pr create --title "Your PR Title" --body "Your PR description"
```

---

## 📊 CI Behavior by Branch Type

| Branch Type | Lint | Test | Install | Docs | External Reviews | Total Time |
|-------------|------|------|---------|------|------------------|------------|
| `feat/`     | ✅   | ✅   | ✅      | ✅   | ❌               | ~72s       |
| `docs/`     | ❌   | ❌   | ❌      | ✅   | ❌               | ~48s       |
| `ci/`       | ✅   | ✅   | ✅      | ✅   | ❌               | ~72s       |
| `fix/`      | ✅   | ✅   | ✅      | ✅   | ❌               | ~72s       |
| `chore/`    | ✅   | ❌   | ❌      | ❌   | ❌               | ~6s        |
| `release/`  | ✅   | ✅   | ✅      | ✅   | ✅               | ~72s + reviews |

---

## 🎯 Best Practices

### Development Workflow
1. **Work on branch** - Multiple commits, no external reviews
2. **Iterate freely** - Fast CI feedback, no review delays
3. **Create PR when ready** - Single external review for complete feature
4. **Address feedback** - Focused review process

### Branch Naming
- **Be descriptive** - `feat/batch-operations` not `feat/stuff`
- **Use consistent prefixes** - Follow the established conventions
- **Keep names short** - But descriptive enough to understand purpose

### Commit Messages
- **Be clear** - Describe what the commit does
- **Use conventional format** - `feat: add batch operations`
- **Keep focused** - One logical change per commit

---

## 🔧 Troubleshooting

### Common Issues

#### CI Not Running
**Problem:** CI jobs not running for your branch
**Solution:** Check branch naming - must start with recognized prefix

#### Wrong CI Behavior
**Problem:** CI running jobs that shouldn't run for your branch type
**Solution:** Check branch detection logic in CI workflow

#### External Reviews Running
**Problem:** Sourcery/Cursor Bugbot running when they shouldn't
**Solution:** Check branch type - only `release/` branches should trigger external reviews

### Getting Help
- **Check CI logs** - Look at the `detect-branch-type` job output
- **Review branch naming** - Ensure you're using correct prefixes
- **Check workflow configuration** - Verify CI workflow is up to date

---

## 📈 Benefits

### For Developers
- ✅ **Faster iteration** - No external review delays during development
- ✅ **Appropriate CI** - Only relevant jobs run for your branch type
- ✅ **Clear workflow** - Know exactly what to expect

### For Reviewers
- ✅ **Focused reviews** - PRs represent complete features
- ✅ **Efficient process** - No work-in-progress PRs
- ✅ **Quality focus** - Reviews on complete, tested code

### For the Project
- ✅ **Resource efficiency** - 30-50% reduction in CI usage
- ✅ **Cost savings** - 80-90% reduction in external review quota
- ✅ **Better quality** - Same standards, faster feedback

---

## 🚀 Migration Guide

### From Old Workflow
1. **Update branch naming** - Use new prefixes
2. **Change development approach** - Work on branch, then create PR
3. **Expect different CI behavior** - Conditional jobs based on branch type

### For Existing Branches
- **Rename branches** - Use new naming conventions
- **Update PRs** - May need to recreate with new branch names
- **Test new workflow** - Validate CI behavior

---

## 📋 Checklist

### Before Starting Work
- [ ] Choose appropriate branch type
- [ ] Use correct branch naming convention
- [ ] Understand expected CI behavior

### During Development
- [ ] Work on branch, not in PR
- [ ] Push multiple commits as needed
- [ ] Let CI run and validate changes

### When Ready for Review
- [ ] Feature is complete and tested
- [ ] All CI checks are passing
- [ ] Create PR for review

### After Review
- [ ] Address any feedback
- [ ] Push updates to branch
- [ ] Merge when approved

---

**Last Updated:** 2025-01-06  
**Status:** Planning  
**Next:** Implement CI optimization
