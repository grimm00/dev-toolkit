# Documentation Branch Workflow

**Purpose:** Systematic approach to handling documentation changes separately from code changes  
**Status:** ✅ Active  
**Last Updated:** 2025-01-06

---

## 📋 Overview

This workflow ensures clean separation between code implementation and documentation updates. Documentation changes in `admin/` are handled in dedicated documentation branches and merged directly to `develop`, while code changes go through the standard PR process.

---

## 🎯 Workflow Types

### 1. Planning Branch (Initial Documentation)

**When:** Creating new feature/CI/release planning documentation

**Process:**
```bash
# Create planning branch from develop
git checkout develop
git pull origin develop
git checkout -b docs/planning-[feature-name]

# Create hub-and-spoke documentation structure
# - README.md (hub)
# - [type]-plan.md
# - status-and-next-steps.md
# - quick-start.md
# - phase-*.md files

# Commit and merge directly to develop
git add admin/planning/
git commit -m "Add [feature-name] planning documentation

- Create hub-and-spoke documentation structure
- Add [type]-plan.md with overview and phases
- Add status-and-next-steps.md for tracking
- Add quick-start.md for implementation guide
- Add phase-*.md files for detailed planning

Following documentation branch workflow for planning docs."

# Merge directly to develop (no PR needed)
git checkout develop
git merge docs/planning-[feature-name] --no-ff
git push origin develop
git branch -d docs/planning-[feature-name]
```

---

### 2. Implementation Branch (Code Changes)

**When:** Implementing features, CI changes, releases

**Process:**
```bash
# Create implementation branch from develop
git checkout develop
git pull origin develop
git checkout -b [type]/[feature-name]

# Implement code changes
# - .github/workflows/ci.yml
# - bin/ commands
# - lib/ libraries
# - tests/

# Create PR for code review
git push origin [type]/[feature-name]
gh pr create --title "[Feature] [Description]" --base develop

# After PR approval and merge, clean up
git checkout develop
git pull origin develop
git branch -d [type]/[feature-name]
```

---

### 3. Documentation Update Branch (Post-Implementation)

**When:** Updating documentation after implementation

**Process:**
```bash
# Create docs update branch from develop
git checkout develop
git pull origin develop
git checkout -b docs/update-[feature-name]

# Update documentation
# - Update status-and-next-steps.md
# - Mark phases as complete
# - Update success criteria
# - Add implementation results
# - Update related documents

# Commit and merge directly to develop
git add admin/planning/
git commit -m "Update [feature-name] documentation post-implementation

- Mark Phase X as complete
- Update success criteria with actual results
- Add implementation details and metrics
- Update status-and-next-steps.md
- Document lessons learned and next steps

Following documentation branch workflow for post-implementation updates."

# Merge directly to develop (no PR needed)
git checkout develop
git merge docs/update-[feature-name] --no-ff
git push origin develop
git branch -d docs/update-[feature-name]
```

### 4. Minor Document Changes (Small Updates)

**When:** Small documentation changes that don't require planning or major updates

**Examples:**
- ✅ Filling out Sourcery feedback matrices
- ✅ Updating analysis files
- ✅ Minor documentation fixes
- ✅ Status updates
- ✅ Small corrections
- ✅ Adding completion notes

**Process:**
```bash
# Create minor document change branch from develop
git checkout develop
git pull origin develop
git checkout -b docs/minor-[description]

# Make small changes
# - Update feedback matrices
# - Add analysis notes
# - Fix typos or small errors
# - Update status indicators

# Commit and merge directly to develop
git add admin/feedback/ admin/planning/
git commit -m "Minor: [description of change]

- Update [specific file] with [specific change]
- [Additional details if needed]

Following documentation branch workflow for minor updates."

# Merge directly to develop (no PR needed)
git checkout develop
git merge docs/minor-[description] --no-ff
git push origin develop
git branch -d docs/minor-[description]
```

**Key Characteristics:**
- ✅ **No PR needed** - Direct merge to develop
- ✅ **Fast process** - No external reviews
- ✅ **Clear naming** - `docs/minor-` prefix
- ✅ **Immediate merge** - No waiting for review
- ✅ **Small scope** - Single file or small set of related files

---

## 📁 Branch Naming Conventions

### Planning Branches
```
docs/planning-[feature-name]
docs/planning-dt-review
docs/planning-ci-installation-testing
docs/planning-release-v0.2.0
```

### Implementation Branches
```
feat/[feature-name]
ci/[project-name]
release/[version]
fix/[issue-description]
```

### Documentation Update Branches
```
docs/update-[feature-name]
docs/update-dt-review-phase-2
docs/update-ci-installation-testing-phase-1
docs/update-release-v0.2.0
```

### Minor Document Change Branches
```
docs/minor-[description]
docs/minor-feedback-matrix-update
docs/minor-analysis-completion
docs/minor-status-update
docs/minor-typo-fix
```

---

## 🎯 When to Use Each Workflow

### Use Planning Branch When:
- ✅ Creating new feature documentation
- ✅ Setting up hub-and-spoke structure
- ✅ Initial planning and analysis
- ✅ Creating phase documentation

### Use Implementation Branch When:
- ✅ Writing code (bin/, lib/, tests/)
- ✅ Modifying CI/CD (.github/workflows/)
- ✅ Creating executables
- ✅ Adding functionality

### Use Documentation Update Branch When:
- ✅ Marking phases as complete
- ✅ Updating success criteria
- ✅ Adding implementation results
- ✅ Documenting lessons learned
- ✅ Updating status and next steps

### Use Minor Document Change Branch When:
- ✅ Filling out Sourcery feedback matrices
- ✅ Updating analysis files
- ✅ Minor documentation fixes
- ✅ Status updates
- ✅ Small corrections
- ✅ Adding completion notes

---

## 📊 Workflow Examples

### Example 1: New Feature

```bash
# 1. Planning Phase
git checkout -b docs/planning-new-feature
# Create all planning docs
git commit -m "Add new-feature planning documentation"
git checkout develop && git merge docs/planning-new-feature --no-ff

# 2. Implementation Phase
git checkout -b feat/new-feature
# Implement code
gh pr create --title "Implement new-feature"
# After PR merge, clean up

# 3. Documentation Update Phase
git checkout -b docs/update-new-feature
# Update docs with results
git commit -m "Update new-feature documentation post-implementation"
git checkout develop && git merge docs/update-new-feature --no-ff
```

### Example 2: CI/CD Changes

```bash
# 1. Planning Phase
git checkout -b docs/planning-ci-optimization
# Create CI planning docs
git commit -m "Add CI optimization planning documentation"
git checkout develop && git merge docs/planning-ci-optimization --no-ff

# 2. Implementation Phase
git checkout -b ci/optimization
# Modify .github/workflows/ci.yml
gh pr create --title "Optimize CI/CD pipeline"
# After PR merge, clean up

# 3. Documentation Update Phase
git checkout -b docs/update-ci-optimization
# Update CI docs with results
git commit -m "Update CI optimization documentation post-implementation"
git checkout develop && git merge docs/update-ci-optimization --no-ff
```

---

## 🚫 What NOT to Mix

### ❌ Don't Mix in Implementation Branches:
- Documentation updates in `admin/`
- Planning document changes
- Status updates
- Phase completion markers

### ❌ Don't Mix in Documentation Branches:
- Code changes in `bin/`, `lib/`, `tests/`
- CI/CD changes in `.github/workflows/`
- Executable modifications
- Functional changes

---

## ✅ Benefits

### Clean Separation
- Code changes go through PR review
- Documentation changes merge directly
- Clear distinction between implementation and docs

### Better Review Process
- PRs focus on code quality
- Documentation updates don't clutter code reviews
- Easier to track what changed and why

### Faster Documentation Updates
- No need to wait for PR approval for docs
- Can update docs immediately after implementation
- Maintains documentation currency

### Clear History
- Git history shows clear separation
- Easy to see when docs were updated
- Implementation and documentation tracked separately

---

## 🎯 Current Project Application

### For PR #17 (CI Installation Testing):

**Current State:**
- ✅ Implementation complete in `feat/cicd-installation-testing`
- ✅ Documentation updates mixed in implementation branch

**Recommended Next Steps:**
1. **Merge PR #17** (code changes)
2. **Create `docs/update-ci-installation-testing`** branch
3. **Move documentation updates** to docs branch
4. **Merge docs branch** directly to develop

**Future Projects:**
- Use this workflow from the start
- Keep implementation and documentation separate
- Follow the three-phase approach

---

## 📚 Related Documents

### Workflows
- [Git Flow Best Practices](git-flow-best-practices.md)
- [Hub-and-Spoke Documentation](hub-and-spoke-documentation-best-practices.md)

### Planning
- [Feature Planning](../planning/features/)
- [CI/CD Planning](../planning/ci/)
- [Release Planning](../planning/releases/)

---

**Last Updated:** 2025-01-06
**Status:** ✅ Active
**Next:** Apply to current PR #17 and future projects
