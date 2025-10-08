# CI/CD Installation Testing - Quick Start

**Purpose:** How to implement installation testing in CI/CD  
**Status:** 🟡 Planned  
**Last Updated:** 2025-01-06

---

## 🚀 Quick Implementation

### Current CI Jobs
```bash
# .github/workflows/ci.yml
jobs:
  lint:     # Shell script linting
  test:     # Syntax and command testing  
  docs:     # Documentation validation
```

### Target CI Jobs
```bash
# .github/workflows/ci.yml
jobs:
  lint:     # Shell script linting
  test:     # Syntax and command testing
  install:  # Installation testing (NEW)
  docs:     # Documentation validation
```

---

## 📋 Implementation Steps

### 1. Add Installation Test Job

**Location:** `.github/workflows/ci.yml`

**Add after `test` job:**
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
      dt-config --version
      dt-git-safety --help
      dt-sourcery-parse --help
      
  - name: Verify command accessibility
    run: |
      which dt-config
      which dt-git-safety
      which dt-sourcery-parse
      
  - name: Cleanup
    run: |
      # Clean up global installation
      rm -rf ~/.dev-toolkit
      # Remove from PATH if needed
```

---

### 2. Test the Implementation

**Local Testing:**
```bash
# Test installation locally
./install.sh
dt-config --version

# Test local installation
./install.sh --local
# Verify local installation works

# Clean up
rm -rf ~/.dev-toolkit
```

**CI Testing:**
```bash
# Create PR to test CI
git checkout -b test/install-ci
git add .github/workflows/ci.yml
git commit -m "Add installation testing to CI"
git push origin test/install-ci
# Create PR and verify CI passes
```

---

### 3. Verify Results

**Expected CI Output:**
```bash
✅ Lint job passes
✅ Test job passes  
✅ Install job passes (NEW)
✅ Docs job passes
```

**Installation Test Results:**
```bash
✅ Global installation successful
✅ Commands accessible via which
✅ Commands respond to --help
✅ No installation conflicts
```

---

## 🔧 Troubleshooting

### Common Issues

**Issue:** Installation test fails
```bash
# Check install.sh syntax
bash -n install.sh

# Test installation manually
./install.sh
dt-config --version
```

**Issue:** Commands not accessible
```bash
# Check PATH
echo $PATH

# Check installation location
ls -la ~/.dev-toolkit/bin/
```

**Issue:** CI job conflicts
```bash
# Check job dependencies
needs: [lint, test]

# Verify isolation
# Each job runs in clean environment
```

---

## 📊 Success Metrics

### Installation Test Job

**✅ Success Criteria:**
- Installation completes without errors
- Commands are accessible globally
- Commands respond to `--help`
- CI execution time < 2 minutes
- No interference with other jobs

**❌ Failure Indicators:**
- Installation fails with errors
- Commands not found after installation
- CI job takes > 3 minutes
- Conflicts with other CI jobs

---

## 🎯 Next Steps

### Phase 1 Complete
- [ ] Installation test job added
- [ ] Global installation tested
- [ ] Commands verified accessible
- [ ] CI triggers updated

### Phase 2 (Future)
- [ ] Local installation testing
- [ ] Integration testing
- [ ] Enhanced cleanup

### Phase 3 (Future)
- [ ] Documentation updates
- [ ] Best practices guide
- [ ] Troubleshooting guide

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
**Next:** Implement Phase 1 installation test job
