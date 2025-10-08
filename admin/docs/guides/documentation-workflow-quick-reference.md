# Documentation Workflow - Quick Reference

**Purpose:** Quick reference for documentation branch workflow  
**Status:** ✅ Active  
**Last Updated:** 2025-01-06

---

## 🚀 Quick Commands

### 1. Planning Phase (Initial Documentation)
```bash
git checkout develop && git pull origin develop
git checkout -b docs/planning-[feature-name]
# Create hub-and-spoke docs
git add admin/planning/ && git commit -m "Add [feature-name] planning documentation"
git checkout develop && git merge docs/planning-[feature-name] --no-ff
git push origin develop && git branch -d docs/planning-[feature-name]
```

### 2. Implementation Phase (Code Changes)
```bash
git checkout develop && git pull origin develop
git checkout -b [type]/[feature-name]
# Implement code changes
git push origin [type]/[feature-name]
gh pr create --title "[Feature] [Description]" --base develop
# After PR merge: git branch -d [type]/[feature-name]
```

### 3. Documentation Update Phase (Post-Implementation)
```bash
git checkout develop && git pull origin develop
git checkout -b docs/update-[feature-name]
# Update documentation with results
git add admin/planning/ && git commit -m "Update [feature-name] documentation post-implementation"
git checkout develop && git merge docs/update-[feature-name] --no-ff
git push origin develop && git branch -d docs/update-[feature-name]
```

---

## 📁 Branch Types

| Type | Pattern | Purpose | Merge Method |
|------|---------|---------|--------------|
| Planning | `docs/planning-[name]` | Initial documentation | Direct to develop |
| Implementation | `[type]/[name]` | Code changes | PR to develop |
| Docs Update | `docs/update-[name]` | Post-implementation docs | Direct to develop |

---

## 🎯 When to Use Each

### Planning Branch
- ✅ Creating new feature documentation
- ✅ Setting up hub-and-spoke structure
- ✅ Initial planning and analysis

### Implementation Branch
- ✅ Writing code (bin/, lib/, tests/)
- ✅ Modifying CI/CD
- ✅ Creating executables

### Documentation Update Branch
- ✅ Marking phases complete
- ✅ Updating success criteria
- ✅ Adding implementation results

---

## ❌ What NOT to Mix

### In Implementation Branches:
- ❌ Documentation updates in admin/
- ❌ Planning document changes
- ❌ Status updates

### In Documentation Branches:
- ❌ Code changes in bin/, lib/, tests/
- ❌ CI/CD changes
- ❌ Executable modifications

---

## 📊 Example: Complete Feature Lifecycle

```bash
# 1. Planning
git checkout -b docs/planning-new-feature
# Create docs, commit, merge to develop

# 2. Implementation  
git checkout -b feat/new-feature
# Write code, create PR, merge PR

# 3. Documentation Update
git checkout -b docs/update-new-feature
# Update docs with results, commit, merge to develop
```

---

**Last Updated:** 2025-01-06
**Status:** ✅ Active
