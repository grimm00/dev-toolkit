# CI Optimization Implementation Plan

**Purpose:** Technical implementation plan for optimizing CI workflow based on branch types  
**Created:** 2025-01-06  
**Status:** Planning  
**Based On:** Workflow analysis and branch strategy

---

## 📋 Overview

This document provides the technical implementation plan for optimizing the CI workflow to support efficient branch-based development with minimal external review overhead.

### Goals
- ✅ **Branch-Aware CI:** Different CI behavior for different branch types
- ✅ **Conditional Jobs:** Run only relevant jobs for each branch type
- ✅ **External Review Control:** Minimize Sourcery/Cursor Bugbot usage
- ✅ **Performance Optimization:** Faster CI for appropriate branch types

---

## 🏗️ Technical Architecture

### Current CI Structure
```yaml
# Current: All jobs run on all PRs
on:
  pull_request:
    branches: [ main, develop ]

jobs:
  lint:     # Always runs
  test:     # Always runs  
  install:  # Always runs
  docs:     # Always runs
```

### Optimized CI Structure
```yaml
# Optimized: Conditional jobs based on branch type
on:
  pull_request:
    branches: [ main, develop ]

jobs:
  detect-branch-type:  # New: Branch detection
  lint:               # Conditional: Based on branch type
  test:               # Conditional: Based on branch type
  install:            # Conditional: Based on branch type
  docs:               # Conditional: Based on branch type
  external-reviews:   # New: Controlled external reviews
```

---

## 🔧 Implementation Details

### Phase 1: Branch Detection Job

#### Job Configuration
```yaml
detect-branch-type:
  runs-on: ubuntu-latest
  name: Detect Branch Type
  outputs:
    branch-type: ${{ steps.detect.outputs.type }}
    needs-lint: ${{ steps.detect.outputs.needs-lint }}
    needs-test: ${{ steps.detect.outputs.needs-test }}
    needs-install: ${{ steps.detect.outputs.needs-install }}
    needs-docs: ${{ steps.detect.outputs.needs-docs }}
    needs-external-reviews: ${{ steps.detect.outputs.needs-external-reviews }}
  
  steps:
    - name: Detect branch type and requirements
      id: detect
      run: |
        BRANCH_NAME="${{ github.head_ref }}"
        
        # Default values
        echo "type=unknown" >> $GITHUB_OUTPUT
        echo "needs-lint=false" >> $GITHUB_OUTPUT
        echo "needs-test=false" >> $GITHUB_OUTPUT
        echo "needs-install=false" >> $GITHUB_OUTPUT
        echo "needs-docs=false" >> $GITHUB_OUTPUT
        echo "needs-external-reviews=false" >> $GITHUB_OUTPUT
        
        # Feature branches
        if [[ "$BRANCH_NAME" =~ ^feat/ ]]; then
          echo "type=feature" >> $GITHUB_OUTPUT
          echo "needs-lint=true" >> $GITHUB_OUTPUT
          echo "needs-test=true" >> $GITHUB_OUTPUT
          echo "needs-install=true" >> $GITHUB_OUTPUT
          echo "needs-docs=true" >> $GITHUB_OUTPUT
          echo "needs-external-reviews=false" >> $GITHUB_OUTPUT
          
        # Documentation branches
        elif [[ "$BRANCH_NAME" =~ ^docs/ ]]; then
          echo "type=documentation" >> $GITHUB_OUTPUT
          echo "needs-lint=false" >> $GITHUB_OUTPUT
          echo "needs-test=false" >> $GITHUB_OUTPUT
          echo "needs-install=false" >> $GITHUB_OUTPUT
          echo "needs-docs=true" >> $GITHUB_OUTPUT
          echo "needs-external-reviews=false" >> $GITHUB_OUTPUT
          
        # CI/CD branches
        elif [[ "$BRANCH_NAME" =~ ^ci/ ]]; then
          echo "type=ci" >> $GITHUB_OUTPUT
          echo "needs-lint=true" >> $GITHUB_OUTPUT
          echo "needs-test=true" >> $GITHUB_OUTPUT
          echo "needs-install=true" >> $GITHUB_OUTPUT
          echo "needs-docs=true" >> $GITHUB_OUTPUT
          echo "needs-external-reviews=false" >> $GITHUB_OUTPUT
          
        # Bug fix branches
        elif [[ "$BRANCH_NAME" =~ ^fix/ ]]; then
          echo "type=fix" >> $GITHUB_OUTPUT
          echo "needs-lint=true" >> $GITHUB_OUTPUT
          echo "needs-test=true" >> $GITHUB_OUTPUT
          echo "needs-install=true" >> $GITHUB_OUTPUT
          echo "needs-docs=true" >> $GITHUB_OUTPUT
          echo "needs-external-reviews=false" >> $GITHUB_OUTPUT
          
        # Maintenance branches
        elif [[ "$BRANCH_NAME" =~ ^chore/ ]]; then
          echo "type=chore" >> $GITHUB_OUTPUT
          echo "needs-lint=true" >> $GITHUB_OUTPUT
          echo "needs-test=false" >> $GITHUB_OUTPUT
          echo "needs-install=false" >> $GITHUB_OUTPUT
          echo "needs-docs=false" >> $GITHUB_OUTPUT
          echo "needs-external-reviews=false" >> $GITHUB_OUTPUT
          
        # Release branches
        elif [[ "$BRANCH_NAME" =~ ^release/ ]]; then
          echo "type=release" >> $GITHUB_OUTPUT
          echo "needs-lint=true" >> $GITHUB_OUTPUT
          echo "needs-test=true" >> $GITHUB_OUTPUT
          echo "needs-install=true" >> $GITHUB_OUTPUT
          echo "needs-docs=true" >> $GITHUB_OUTPUT
          echo "needs-external-reviews=true" >> $GITHUB_OUTPUT
          
        # Default for unknown branches
        else
          echo "type=unknown" >> $GITHUB_OUTPUT
          echo "needs-lint=true" >> $GITHUB_OUTPUT
          echo "needs-test=true" >> $GITHUB_OUTPUT
          echo "needs-install=true" >> $GITHUB_OUTPUT
          echo "needs-docs=true" >> $GITHUB_OUTPUT
          echo "needs-external-reviews=true" >> $GITHUB_OUTPUT
        fi
        
        echo "Detected branch type: ${{ steps.detect.outputs.type }}"
        echo "Needs lint: ${{ steps.detect.outputs.needs-lint }}"
        echo "Needs test: ${{ steps.detect.outputs.needs-test }}"
        echo "Needs install: ${{ steps.detect.outputs.needs-install }}"
        echo "Needs docs: ${{ steps.detect.outputs.needs-docs }}"
        echo "Needs external reviews: ${{ steps.detect.outputs.needs-external-reviews }}"
```

### Phase 2: Conditional Job Execution

#### Lint Job
```yaml
lint:
  runs-on: ubuntu-latest
  name: Lint Shell Scripts
  needs: [detect-branch-type]
  if: needs.detect-branch-type.outputs.needs-lint == 'true'
  
  steps:
    - name: Checkout code
      uses: actions/checkout@v4
      
    - name: Run ShellCheck
      uses: ludeeus/action-shellcheck@master
      with:
        scandir: './bin'
        additional_files: './lib ./install.sh ./dev-setup.sh'
        severity: warning
```

#### Test Job
```yaml
test:
  runs-on: ubuntu-latest
  name: Test Toolkit
  needs: [detect-branch-type]
  if: needs.detect-branch-type.outputs.needs-test == 'true'
  
  steps:
    - name: Checkout code
      uses: actions/checkout@v4
      
    - name: Set up environment
      run: |
        export DT_ROOT="${GITHUB_WORKSPACE}"
        export PATH="${DT_ROOT}/bin:$PATH"
        echo "DT_ROOT=${DT_ROOT}" >> $GITHUB_ENV
        echo "${DT_ROOT}/bin" >> $GITHUB_PATH
        
    # ... rest of test steps
```

#### Install Job
```yaml
install:
  runs-on: ubuntu-latest
  name: Test Installation
  needs: [detect-branch-type, lint, test]
  if: needs.detect-branch-type.outputs.needs-install == 'true'
  
  steps:
    - name: Checkout code
      uses: actions/checkout@v4
      
    # ... rest of install steps
```

#### Docs Job
```yaml
docs:
  runs-on: ubuntu-latest
  name: Check Documentation
  needs: [detect-branch-type]
  if: needs.detect-branch-type.outputs.needs-docs == 'true'
  
  steps:
    - name: Checkout code
      uses: actions/checkout@v4
      
    - name: Check for broken links
      uses: gaurav-nelson/github-action-markdown-link-check@v1
      with:
        use-quiet-mode: 'yes'
        config-file: .github/markdown-link-check-config.json
```

### Phase 3: External Review Control

#### Sourcery Configuration
```yaml
# .sourcery.yaml - Update to only run on release branches
github:
  # Only review release branches
  sourcery_branch: main
  
  # Skip reviews for non-release branches
  skip_docs_only: true
  skip_non_release: true
  
  # Branch-specific settings
  branch_patterns:
    - "release/*"  # Only review release branches
    - "main"       # Review main branch
```

#### Cursor Bugbot Configuration
```yaml
# .cursor-bugbot.yaml - New configuration file
triggers:
  branches:
    - "release/*"  # Only run on release branches
    - "main"       # Run on main branch
  
  skip_branches:
    - "feat/*"     # Skip feature branches
    - "docs/*"     # Skip documentation branches
    - "ci/*"       # Skip CI branches
    - "fix/*"      # Skip fix branches
    - "chore/*"    # Skip chore branches
```

---

## 📊 Performance Impact

### Current vs Optimized CI Times
| Branch Type | Current Time | Optimized Time | Improvement |
|-------------|--------------|----------------|-------------|
| `feat/`     | 72s         | 72s           | 0%          |
| `docs/`     | 72s         | 48s           | 33%         |
| `ci/`       | 72s         | 72s           | 0%          |
| `fix/`      | 72s         | 72s           | 0%          |
| `chore/`    | 72s         | 6s            | 92%         |
| `release/`  | 72s         | 72s           | 0%          |

### External Review Usage
| Branch Type | Current Reviews | Optimized Reviews | Reduction |
|-------------|----------------|-------------------|-----------|
| `feat/`     | Multiple       | 0                 | 100%      |
| `docs/`     | Multiple       | 0                 | 100%      |
| `ci/`       | Multiple       | 0                 | 100%      |
| `fix/`      | Multiple       | 0                 | 100%      |
| `chore/`    | Multiple       | 0                 | 100%      |
| `release/`  | Multiple       | 1                 | 80-90%    |

---

## 🚀 Implementation Phases

### Phase 1: Branch Detection (Week 1)
**Goal:** Add branch detection capability to CI workflow

**Tasks:**
- [ ] Add `detect-branch-type` job to CI workflow
- [ ] Implement branch prefix detection logic
- [ ] Add job outputs for conditional execution
- [ ] Test with different branch types
- [ ] Validate detection accuracy

**Success Criteria:**
- ✅ Branch type detection works for all branch prefixes
- ✅ Job outputs are correctly set
- ✅ No regression in existing CI behavior

### Phase 2: Conditional Jobs (Week 2)
**Goal:** Implement conditional job execution based on branch type

**Tasks:**
- [ ] Add conditional logic to existing jobs
- [ ] Update job dependencies
- [ ] Test conditional execution
- [ ] Validate performance improvements
- [ ] Ensure no job failures

**Success Criteria:**
- ✅ Jobs run only when appropriate for branch type
- ✅ Performance improvements achieved
- ✅ No regression in test coverage

### Phase 3: External Review Control (Week 3)
**Goal:** Control external reviews to minimize quota usage

**Tasks:**
- [ ] Update Sourcery configuration
- [ ] Configure Cursor Bugbot
- [ ] Test external review behavior
- [ ] Validate quota usage reduction
- [ ] Monitor review quality

**Success Criteria:**
- ✅ External reviews only run on release/ branches
- ✅ Quota usage reduced by 80-90%
- ✅ Review quality maintained

### Phase 4: Optimization and Monitoring (Week 4)
**Goal:** Optimize performance and monitor results

**Tasks:**
- [ ] Fine-tune conditional logic
- [ ] Add monitoring and metrics
- [ ] Document new workflow
- [ ] Train contributors
- [ ] Monitor and optimize

**Success Criteria:**
- ✅ Optimal CI performance achieved
- ✅ Contributors understand new workflow
- ✅ Monitoring shows expected improvements

---

## 📋 Testing Strategy

### Test Cases
1. **Feature Branch (`feat/test-feature`)**
   - Should run: lint, test, install, docs
   - Should not run: external reviews
   - Expected time: ~72s

2. **Documentation Branch (`docs/update-readme`)**
   - Should run: docs only
   - Should not run: lint, test, install, external reviews
   - Expected time: ~48s

3. **CI Branch (`ci/optimize-workflow`)**
   - Should run: lint, test, install, docs
   - Should not run: external reviews
   - Expected time: ~72s

4. **Fix Branch (`fix/bug-fix`)**
   - Should run: lint, test, install, docs
   - Should not run: external reviews
   - Expected time: ~72s

5. **Chore Branch (`chore/cleanup`)**
   - Should run: lint only
   - Should not run: test, install, docs, external reviews
   - Expected time: ~6s

6. **Release Branch (`release/v0.3.0`)**
   - Should run: lint, test, install, docs, external reviews
   - Expected time: ~72s + external review time

### Validation Steps
1. **Create test branches** for each type
2. **Create PRs** and observe CI behavior
3. **Validate job execution** matches expectations
4. **Measure performance** improvements
5. **Test external review** behavior
6. **Validate no regression** in existing functionality

---

## 🎯 Success Metrics

### Performance Metrics
- **CI Time Reduction:** 20-30% overall
- **Resource Usage:** 30-50% reduction in CI minutes
- **External Reviews:** 80-90% reduction in quota usage

### Quality Metrics
- **Test Coverage:** Maintained or improved
- **Code Quality:** Same standards, faster feedback
- **Documentation:** Faster updates, better maintenance

### Developer Experience
- **Development Speed:** 20-30% faster iteration
- **Review Efficiency:** Focused feedback on complete features
- **Workflow Clarity:** Clear guidelines for contributors

---

## 🚀 Next Steps

1. **Create Phase 1 implementation** - Branch detection job
2. **Test branch detection** - Validate with different branch types
3. **Implement Phase 2** - Conditional job execution
4. **Test conditional jobs** - Ensure proper behavior
5. **Implement Phase 3** - External review control
6. **Test external reviews** - Validate quota usage reduction
7. **Document and train** - Guidelines for contributors

---

**Last Updated:** 2025-01-06  
**Status:** Planning  
**Next:** Implement Phase 1 - Branch detection
