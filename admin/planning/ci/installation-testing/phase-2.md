# Phase 2: Integration Testing

**Purpose:** Enhanced installation testing with local installation and integration scenarios  
**Status:** 🟡 Planned  
**Last Updated:** 2025-01-06

---

## 📋 Overview

Build upon Phase 1 to add comprehensive installation testing including local installation, integration scenarios, and edge cases. This phase ensures the installation process works correctly in all supported scenarios.

### Goals

1. **Test Local Installation** - Verify `--local` flag works correctly
2. **Test Integration Scenarios** - Verify installation → usage workflow
3. **Test Edge Cases** - Handle various installation scenarios
4. **Ensure Isolation** - Verify no conflicts between test runs

---

## 🎯 Success Criteria

- [ ] Local installation test passes
- [ ] Integration workflow test passes
- [ ] Edge case scenarios handled
- [ ] Installation isolation verified
- [ ] No interference with other CI jobs
- [ ] Comprehensive test coverage

**Progress:** 0/6 complete (0%)

---

## 📅 Implementation Tasks

### Task 1: Add Local Installation Testing

**Status:** 🟡 Planned  
**Estimated Time:** 30 minutes

**What to do:**
1. Add local installation test to CI job
2. Verify `--local` flag works correctly
3. Test local command accessibility
4. Ensure local installation doesn't affect global

**Implementation:**
```yaml
- name: Test local installation
  run: |
    ./install.sh --local
    # Verify local installation
    ls -la .dev-toolkit/bin/
    # Test local commands
    ./.dev-toolkit/bin/dt-config --help
    echo "✅ Local installation completed"
```

---

### Task 2: Test Integration Workflow

**Status:** 🟡 Planned  
**Estimated Time:** 25 minutes

**What to do:**
1. Test complete installation → usage workflow
2. Verify commands work in different contexts
3. Test installation with different PR scenarios
4. Ensure workflow is reliable

**Implementation:**
```yaml
- name: Test integration workflow
  run: |
    # Install globally
    ./install.sh
    # Test in different directory
    cd /tmp
    dt-config show
    dt-git-safety check || echo "Safety checks completed"
    echo "✅ Integration workflow completed"
```

---

### Task 3: Test Edge Cases

**Status:** 🟡 Planned  
**Estimated Time:** 20 minutes

**What to do:**
1. Test installation with existing installation
2. Test installation with different permissions
3. Test installation with missing dependencies
4. Handle various error scenarios

**Implementation:**
```yaml
- name: Test edge cases
  run: |
    # Test reinstallation
    ./install.sh
    ./install.sh  # Should handle gracefully
    
    # Test with different permissions
    chmod -x install.sh
    ./install.sh || echo "Expected failure with no execute permission"
    chmod +x install.sh
    
    echo "✅ Edge cases handled"
```

---

### Task 4: Ensure Installation Isolation

**Status:** 🟡 Planned  
**Estimated Time:** 15 minutes

**What to do:**
1. Verify installations don't interfere with each other
2. Test cleanup between test runs
3. Ensure no side effects for other CI jobs
4. Test parallel execution scenarios

**Implementation:**
```yaml
- name: Test installation isolation
  run: |
    # Test multiple installations
    ./install.sh
    ./install.sh --local
    
    # Verify both work independently
    dt-config --help
    ./.dev-toolkit/bin/dt-config --help
    
    echo "✅ Installation isolation verified"
```

---

### Task 5: Add Comprehensive Cleanup

**Status:** 🟡 Planned  
**Estimated Time:** 15 minutes

**What to do:**
1. Clean up both global and local installations
2. Remove PATH modifications
3. Ensure clean state for next test run
4. Handle cleanup errors gracefully

**Implementation:**
```yaml
- name: Comprehensive cleanup
  run: |
    # Clean global installation
    rm -rf ~/.dev-toolkit
    
    # Clean local installation
    rm -rf .dev-toolkit
    
    # Reset PATH if needed
    # (CI runners reset automatically)
    
    echo "✅ Comprehensive cleanup completed"
```

---

### Task 6: Test and Validate

**Status:** 🟡 Planned  
**Estimated Time:** 30 minutes

**What to do:**
1. Test enhanced CI job with multiple scenarios
2. Verify all test cases pass
3. Ensure no regressions
4. Test in different PR contexts

**Implementation:**
```bash
# Test enhanced CI
git add .github/workflows/ci.yml
git commit -m "Add comprehensive installation testing"
git push origin test/install-ci
# Verify all test cases pass
```

---

## 📊 Expected Results

### Enhanced CI Job
```yaml
install:
  runs-on: ubuntu-latest
  name: Test Installation
  needs: [lint, test]
  
  steps:
  - name: Checkout code
    uses: actions/checkout@v4
    
  - name: Test global installation
    run: |
      ./install.sh
      dt-config --help
      dt-git-safety --help
      dt-sourcery-parse --help
      
  - name: Test local installation
    run: |
      ./install.sh --local
      ./.dev-toolkit/bin/dt-config --help
      
  - name: Test integration workflow
    run: |
      cd /tmp
      dt-config show
      
  - name: Test edge cases
    run: |
      ./install.sh  # Reinstallation
      # Test error scenarios
      
  - name: Comprehensive cleanup
    run: |
      rm -rf ~/.dev-toolkit
      rm -rf .dev-toolkit
```

### Test Coverage
- ✅ Global installation
- ✅ Local installation
- ✅ Integration workflow
- ✅ Edge cases
- ✅ Installation isolation
- ✅ Comprehensive cleanup

---

## 🚫 Out of Scope

**Excluded from Phase 2:**
- ❌ Multi-OS testing (Ubuntu only)
- ❌ Performance testing
- ❌ Testing with different shell environments
- ❌ Testing with missing system dependencies
- ❌ Testing installation rollback

---

## 🔧 Troubleshooting

### Common Issues

**Issue:** Local installation conflicts with global
```bash
# Check installation locations
ls -la ~/.dev-toolkit/
ls -la .dev-toolkit/

# Verify PATH settings
echo $PATH
```

**Issue:** Integration workflow fails
```bash
# Test commands in different directories
cd /tmp
dt-config show

# Check command accessibility
which dt-config
```

**Issue:** Cleanup doesn't work properly
```bash
# Manual cleanup
rm -rf ~/.dev-toolkit
rm -rf .dev-toolkit

# Check for remaining files
find . -name "dt-*" -type f
```

---

## 📚 Related Documents

### Planning
- [README.md](README.md) - Hub with quick links
- [CI Plan](ci-plan.md) - Overview
- [Status & Next Steps](status-and-next-steps.md) - Current status

### Phases
- [Phase 1](phase-1.md) - Basic installation testing
- [Phase 3](phase-3.md) - Documentation & best practices

### Analysis
- [Current CI Analysis](current-ci-analysis.md) - Deep dive

### CI/CD
- [.github/workflows/ci.yml](../../../.github/workflows/ci.yml) - Current CI configuration

---

**Last Updated:** 2025-01-06
**Status:** 🟡 Planned
**Next:** Implement after Phase 1 completion
