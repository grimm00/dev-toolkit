# Branch Strategy & Conventions

**Purpose:** Define standardized branch naming and workflow conventions  
**Created:** 2025-01-06  
**Status:** Planning  
**Based On:** Development workflow optimization and CI efficiency goals

---

## 📋 Overview

This document defines the branch naming conventions and workflow strategies that will enable efficient CI optimization and development practices.

### Goals
- ✅ **Clear Conventions:** Standardized branch naming for all contributors
- ✅ **CI Optimization:** Enable conditional CI based on branch type
- ✅ **Workflow Efficiency:** Support branch-based development → single PR workflow
- ✅ **External Review Control:** Minimize Sourcery/Cursor Bugbot usage

---

## 🌳 Branch Naming Conventions

### Primary Branch Types

#### `feat/` - Feature Development
**Purpose:** New features, enhancements, major functionality additions  
**Examples:**
- `feat/batch-operations`
- `feat/enhanced-git-flow`
- `feat/sourcery-integration`

**CI Behavior:**
- ✅ **Lint:** Yes (code changes)
- ✅ **Test:** Yes (functionality changes)
- ✅ **Install:** Yes (installation testing)
- ✅ **Docs:** Yes (may need documentation)
- ❌ **External Reviews:** No (development phase)

#### `docs/` - Documentation Only
**Purpose:** Documentation updates, guides, README changes  
**Examples:**
- `docs/update-installation-guide`
- `docs/add-troubleshooting-section`
- `docs/improve-api-documentation`

**CI Behavior:**
- ❌ **Lint:** No (no code changes)
- ❌ **Test:** No (no functionality changes)
- ❌ **Install:** No (no installation changes)
- ✅ **Docs:** Yes (documentation changes)
- ❌ **External Reviews:** No (documentation phase)

#### `ci/` - CI/CD Changes
**Purpose:** CI workflow changes, GitHub Actions, deployment scripts  
**Examples:**
- `ci/optimize-workflow-triggers`
- `ci/add-installation-testing`
- `ci/improve-documentation-checks`

**CI Behavior:**
- ✅ **Lint:** Yes (CI scripts are code)
- ✅ **Test:** Yes (CI changes affect testing)
- ✅ **Install:** Yes (CI changes affect installation)
- ✅ **Docs:** Yes (CI changes may need documentation)
- ❌ **External Reviews:** No (infrastructure phase)

#### `fix/` - Bug Fixes
**Purpose:** Bug fixes, error corrections, issue resolutions  
**Examples:**
- `fix/sourcery-parser-error`
- `fix/installation-path-issue`
- `fix/documentation-link-broken`

**CI Behavior:**
- ✅ **Lint:** Yes (code changes)
- ✅ **Test:** Yes (bug fixes need testing)
- ✅ **Install:** Yes (installation may be affected)
- ✅ **Docs:** Yes (fixes may need documentation)
- ❌ **External Reviews:** No (fix phase)

#### `chore/` - Maintenance Tasks
**Purpose:** Maintenance, cleanup, refactoring, dependency updates  
**Examples:**
- `chore/update-dependencies`
- `chore/cleanup-unused-files`
- `chore/refactor-test-structure`

**CI Behavior:**
- ✅ **Lint:** Yes (code changes)
- ❌ **Test:** No (no functionality changes)
- ❌ **Install:** No (no installation changes)
- ❌ **Docs:** No (no documentation changes)
- ❌ **External Reviews:** No (maintenance phase)

#### `release/` - Release Preparation
**Purpose:** Release preparation, version bumps, release notes  
**Examples:**
- `release/v0.3.0`
- `release/prepare-major-update`
- `release/finalize-feature-set`

**CI Behavior:**
- ✅ **Lint:** Yes (release changes)
- ✅ **Test:** Yes (release validation)
- ✅ **Install:** Yes (release testing)
- ✅ **Docs:** Yes (release documentation)
- ✅ **External Reviews:** Yes (release quality)

---

## 🔄 Development Workflow

### Phase 1: Branch Development
```bash
# 1. Create feature branch
git checkout -b feat/new-feature

# 2. Develop and iterate
git add .
git commit -m "Add initial implementation"
git push origin feat/new-feature

# 3. Continue development
git add .
git commit -m "Add tests and documentation"
git push origin feat/new-feature

# 4. Finalize feature
git add .
git commit -m "Complete feature implementation"
git push origin feat/new-feature
```

**Benefits:**
- ✅ **No external reviews** during development
- ✅ **Fast iteration** without review delays
- ✅ **CI runs** for validation and testing
- ✅ **No quota usage** for external tools

### Phase 2: PR Creation
```bash
# 5. Create PR when feature is complete
gh pr create --title "Feature: New Feature" --body "Complete implementation of new feature"
```

**Benefits:**
- ✅ **Single external review** for complete feature
- ✅ **PR is ready** for review, not work-in-progress
- ✅ **Efficient review process** for reviewers
- ✅ **Minimal quota usage** for external tools

### Phase 3: Review and Merge
```bash
# 6. Address any feedback
git add .
git commit -m "Address review feedback"
git push origin feat/new-feature

# 7. Merge when approved
gh pr merge --squash
```

**Benefits:**
- ✅ **Focused feedback** on complete feature
- ✅ **Efficient review process** for reviewers
- ✅ **Clean commit history** with squash merge

---

## 🎯 CI Optimization Strategy

### Branch Detection Logic
```yaml
# Example CI implementation
- name: Detect branch type
  id: branch-type
  run: |
    BRANCH_NAME="${{ github.head_ref }}"
    if [[ "$BRANCH_NAME" =~ ^feat/ ]]; then
      echo "type=feature" >> $GITHUB_OUTPUT
      echo "needs-lint=true" >> $GITHUB_OUTPUT
      echo "needs-test=true" >> $GITHUB_OUTPUT
      echo "needs-install=true" >> $GITHUB_OUTPUT
      echo "needs-docs=true" >> $GITHUB_OUTPUT
      echo "needs-external-reviews=false" >> $GITHUB_OUTPUT
    elif [[ "$BRANCH_NAME" =~ ^docs/ ]]; then
      echo "type=documentation" >> $GITHUB_OUTPUT
      echo "needs-lint=false" >> $GITHUB_OUTPUT
      echo "needs-test=false" >> $GITHUB_OUTPUT
      echo "needs-install=false" >> $GITHUB_OUTPUT
      echo "needs-docs=true" >> $GITHUB_OUTPUT
      echo "needs-external-reviews=false" >> $GITHUB_OUTPUT
    # ... etc for other branch types
```

### Conditional Job Execution
```yaml
# Example job configuration
lint:
  if: steps.branch-type.outputs.needs-lint == 'true'
  # ... job steps

test:
  if: steps.branch-type.outputs.needs-test == 'true'
  # ... job steps

install:
  if: steps.branch-type.outputs.needs-install == 'true'
  # ... job steps

docs:
  if: steps.branch-type.outputs.needs-docs == 'true'
  # ... job steps
```

---

## 📊 Expected Impact

### Development Efficiency
| Branch Type | Current CI Time | Optimized CI Time | Improvement |
|-------------|----------------|-------------------|-------------|
| `feat/`     | 72s           | 72s              | 0%          |
| `docs/`     | 72s           | 48s              | 33%         |
| `ci/`       | 72s           | 72s              | 0%          |
| `fix/`      | 72s           | 72s              | 0%          |
| `chore/`    | 72s           | 6s               | 92%         |

### External Review Usage
| Branch Type | Current Reviews | Optimized Reviews | Reduction |
|-------------|----------------|-------------------|-----------|
| `feat/`     | Multiple       | 1                 | 80-90%    |
| `docs/`     | Multiple       | 0                 | 100%      |
| `ci/`       | Multiple       | 0                 | 100%      |
| `fix/`      | Multiple       | 0                 | 100%      |
| `chore/`    | Multiple       | 0                 | 100%      |
| `release/`  | Multiple       | 1                 | 80-90%    |

### Overall Benefits
- **Development Speed:** 20-30% faster iteration
- **Resource Usage:** 30-50% reduction in CI minutes
- **External Reviews:** 80-90% reduction in quota usage
- **Quality:** Maintained or improved test coverage

---

## 📋 Implementation Checklist

### Phase 1: Branch Detection
- [ ] Add branch prefix detection to CI workflow
- [ ] Create conditional job framework
- [ ] Test with different branch types
- [ ] Document branch conventions

### Phase 2: Conditional Jobs
- [ ] Implement conditional job execution
- [ ] Optimize job dependencies
- [ ] Validate performance improvements
- [ ] Test all branch types

### Phase 3: External Review Control
- [ ] Configure Sourcery for release/ branches only
- [ ] Configure Cursor Bugbot for release/ branches only
- [ ] Validate quota usage reduction
- [ ] Test external review behavior

### Phase 4: Documentation and Training
- [ ] Update contributor guidelines
- [ ] Create workflow documentation
- [ ] Train team on new conventions
- [ ] Monitor and optimize

---

## 🚀 Next Steps

1. **Create CI optimization plan** - Technical implementation details
2. **Implement Phase 1** - Branch detection
3. **Test and validate** - Ensure no regression
4. **Implement Phase 2** - Conditional jobs
5. **Implement Phase 3** - External review control
6. **Document and train** - Guidelines for contributors

---

**Last Updated:** 2025-01-06  
**Status:** Planning  
**Next:** Create CI optimization plan
