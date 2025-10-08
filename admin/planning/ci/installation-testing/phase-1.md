# Phase 1: Installation Test Job

**Purpose:** Detailed implementation plan for adding installation testing to CI/CD  
**Status:** 🟡 Planned  
**Last Updated:** 2025-01-06

---

## 📋 Overview

Add a new CI job to test the actual installation process of `install.sh`. This phase focuses on basic installation testing to ensure the installer works correctly in CI environments.

### Goals

1. **Test Global Installation** - Verify `./install.sh` works correctly
2. **Verify Command Accessibility** - Ensure installed commands are accessible
3. **Test Command Functionality** - Verify commands respond to help flags
4. **Integrate with CI** - Add to existing CI workflow

---

## 🎯 Success Criteria

- [ ] Installation test job added to CI workflow
- [ ] Global installation test passes
- [ ] Commands accessible via `which`
- [ ] Commands respond to `--help`
- [ ] CI execution time < 2 minutes
- [ ] No interference with existing jobs

**Progress:** 0/6 complete (0%)

---

## 📅 Implementation Tasks

### Task 1: Create Installation Test Job

**Status:** 🟡 Planned  
**Estimated Time:** 30 minutes

**What to do:**
1. Add new `install` job to `.github/workflows/ci.yml`
2. Position after `test` job, before `docs` job
3. Set up job dependencies: `needs: [lint, test]`
4. Configure Ubuntu runner

**Implementation:**
```yaml
install:
  runs-on: ubuntu-latest
  name: Test Installation
  needs: [lint, test]
  
  steps:
  - name: Checkout code
    uses: actions/checkout@v4
```

---

### Task 2: Test Global Installation

**Status:** 🟡 Planned  
**Estimated Time:** 20 minutes

**What to do:**
1. Run `./install.sh` in CI environment
2. Verify installation completes without errors
3. Test that commands are accessible globally

**Implementation:**
```yaml
- name: Test global installation
  run: |
    ./install.sh
    echo "✅ Global installation completed"
```

---

### Task 3: Verify Command Accessibility

**Status:** 🟡 Planned  
**Estimated Time:** 15 minutes

**What to do:**
1. Test that installed commands are in PATH
2. Verify `which` can find the commands
3. Test command help functionality

**Implementation:**
```yaml
- name: Verify command accessibility
  run: |
    which dt-config
    which dt-git-safety
    which dt-sourcery-parse
    echo "✅ All commands accessible"
```

---

### Task 4: Test Command Functionality

**Status:** 🟡 Planned  
**Estimated Time:** 15 minutes

**What to do:**
1. Test that commands respond to help flags
2. Verify basic command functionality
3. Ensure no errors in command execution

**Implementation:**
```yaml
- name: Test command functionality
  run: |
    dt-config --help
    dt-git-safety --help
    dt-sourcery-parse --help
    echo "✅ All commands functional"
```

---

### Task 5: Add Cleanup

**Status:** 🟡 Planned  
**Estimated Time:** 10 minutes

**What to do:**
1. Clean up global installation after testing
2. Ensure no side effects for other CI jobs
3. Remove installed files and PATH modifications

**Implementation:**
```yaml
- name: Cleanup
  run: |
    rm -rf ~/.dev-toolkit
    echo "✅ Cleanup completed"
```

---

### Task 6: Test and Validate

**Status:** 🟡 Planned  
**Estimated Time:** 30 minutes

**What to do:**
1. Create test PR to validate CI changes
2. Verify installation job passes
3. Ensure no regressions in other jobs
4. Test multiple PR scenarios

**Implementation:**
```bash
# Create test branch
git checkout -b test/install-ci
git add .github/workflows/ci.yml
git commit -m "Add installation testing to CI"
git push origin test/install-ci
# Create PR and verify CI passes
```

---

## 📊 Expected Results

### CI Job Structure
```bash
# .github/workflows/ci.yml
jobs:
  lint:     # Shell script linting
  test:     # Syntax and command testing
  install:  # Installation testing (NEW)
  docs:     # Documentation validation
```

### Installation Test Output
```bash
✅ Global installation completed
✅ All commands accessible
✅ All commands functional
✅ Cleanup completed
```

### Performance Impact
- **Additional CI Time:** ~1-2 minutes
- **Total CI Time:** ~4-6 minutes (was ~3-5 minutes)
- **Success Rate:** High (reliable installation testing)

---

## 🚫 Out of Scope

**Excluded from Phase 1:**
- ❌ Local installation testing (`--local` flag)
- ❌ Installation rollback testing
- ❌ Multi-OS testing (Ubuntu only)
- ❌ Performance testing of installation
- ❌ Testing with missing dependencies

---

## 🔧 Troubleshooting

### Common Issues

**Issue:** Installation fails in CI
```bash
# Check install.sh syntax
bash -n install.sh

# Test installation manually
./install.sh
```

**Issue:** Commands not accessible after installation
```bash
# Check PATH
echo $PATH

# Check installation location
ls -la ~/.dev-toolkit/bin/
```

**Issue:** CI job takes too long
```bash
# Optimize installation process
# Consider parallel execution
# Review cleanup steps
```

---

## 📚 Related Documents

### Planning
- [README.md](README.md) - Hub with quick links
- [CI Plan](ci-plan.md) - Overview
- [Status & Next Steps](status-and-next-steps.md) - Current status

### Analysis
- [Current CI Analysis](current-ci-analysis.md) - Deep dive

### CI/CD
- [.github/workflows/ci.yml](../../../.github/workflows/ci.yml) - Current CI configuration

---

**Last Updated:** 2025-01-06
**Status:** 🟡 Planned
**Next:** Implement installation test job
