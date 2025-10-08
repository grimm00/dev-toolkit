# Release v0.3.0 - Quick Start Guide

**Purpose:** Quick reference for the release process  
**Status:** 🟡 Ready for Use  
**Last Updated:** 2025-01-06

---

## 🚀 Quick Release Process

### 1. Pre-Release Validation

```bash
# Navigate to project
cd /Users/cdwilson/Projects/dev-toolkit

# Run complete test suite
./run-tests.sh

# Check installation process
./install.sh --no-symlinks
./install.sh --local

# Verify all commands work
dt-config --help
dt-git-safety --help
dt-sourcery-parse --help
dt-review --help
```

### 2. Main Branch Sync

```bash
# Ensure develop is up to date
git checkout develop
git pull origin develop

# Switch to main and merge
git checkout main
git merge develop --no-ff

# Push to origin
git push origin main
```

### 3. Release Tagging

```bash
# Create annotated tag
git tag -a v0.3.0 -m "Release v0.3.0: Major feature release

- Complete testing suite (215+ tests)
- CI/CD infrastructure with installation testing
- Hub-and-spoke documentation model
- Enhanced Sourcery integration with Overall Comments
- Workflow optimization with branch-aware CI"

# Push tag
git push origin v0.3.0
```

---

## 📋 Essential Commands

### Validation Commands

```bash
# Test suite
./run-tests.sh                    # All tests
./run-tests.sh --unit            # Unit tests only
./run-tests.sh --integration     # Integration tests only

# Installation testing
./install.sh                     # Global installation
./install.sh --local            # Local installation
./install.sh --no-symlinks      # No symlinks (CI mode)

# Command verification
which dt-config dt-git-safety dt-sourcery-parse dt-review
```

### Git Commands

```bash
# Branch management
git checkout develop            # Switch to develop
git checkout main              # Switch to main
git merge develop --no-ff      # Merge develop to main

# Tag management
git tag -a v0.3.0 -m "Message" # Create annotated tag
git push origin v0.3.0         # Push tag
git tag -l                     # List tags
```

---

## 🎯 Validation Checklist

### Quick Validation (5 minutes)

- [ ] **Tests Pass** - `./run-tests.sh` completes successfully
- [ ] **Installation Works** - `./install.sh` completes without errors
- [ ] **Commands Accessible** - All commands respond to `--help`
- [ ] **No Critical Issues** - No obvious problems

### Full Validation (30 minutes)

- [ ] **Complete Test Suite** - All 215+ tests pass
- [ ] **Global Installation** - `./install.sh` works
- [ ] **Local Installation** - `./install.sh --local` works
- [ ] **Command Functionality** - All commands work end-to-end
- [ ] **Documentation Links** - All documentation links work
- [ ] **CI/CD Pipeline** - All CI jobs pass

---

## 🚨 Troubleshooting

### Common Issues

**Tests Failing:**
```bash
# Check test environment
./run-tests.sh --debug

# Run specific test
./run-tests.sh -t specific-test

# Check dependencies
which bash git gh
```

**Installation Issues:**
```bash
# Check permissions
ls -la install.sh

# Check dependencies
which git gh

# Clean installation
rm -rf ~/.dev-toolkit
./install.sh
```

**Command Not Found:**
```bash
# Check PATH
echo $PATH

# Check installation
ls -la ~/.dev-toolkit/bin/

# Reinstall
./install.sh
```

### Emergency Procedures

**Rollback Release:**
```bash
# Revert main branch
git checkout main
git reset --hard HEAD~1
git push origin main --force

# Delete tag
git tag -d v0.3.0
git push origin :refs/tags/v0.3.0
```

**Fix Critical Issues:**
```bash
# Create hotfix branch
git checkout main
git checkout -b hotfix/v0.3.0-fix

# Make fixes
# ... fix issues ...

# Merge back
git checkout main
git merge hotfix/v0.3.0-fix
git push origin main
```

---

## 📊 Success Indicators

### Release Success

- ✅ **All Tests Pass** - 215+ tests passing
- ✅ **Installation Works** - Both global and local
- ✅ **Commands Functional** - All commands work
- ✅ **Documentation Complete** - All links work
- ✅ **Main Branch Updated** - Synchronized with develop
- ✅ **Tag Created** - v0.3.0 tag pushed

### User Success

- ✅ **Easy Installation** - Users can install easily
- ✅ **Clear Documentation** - Users understand how to use
- ✅ **Working Commands** - All commands function properly
- ✅ **No Issues** - No critical problems reported

---

## 🎯 Post-Release

### Immediate Actions

1. **Monitor Installation** - Watch for installation issues
2. **Check User Feedback** - Monitor for user reports
3. **Verify Functionality** - Test in different environments
4. **Update Documentation** - Fix any issues found

### Follow-up

1. **User Support** - Help users with installation
2. **Bug Reports** - Address any issues found
3. **Documentation Updates** - Improve based on feedback
4. **Next Release Planning** - Plan v0.3.1

---

## 📚 Related Documents

- [Release Plan](release-plan.md) - Detailed release strategy
- [Release Checklist](checklist.md) - Comprehensive validation
- [Release Notes](release-notes.md) - User-facing changes
- [Status & Next Steps](status-and-next-steps.md) - Current progress

---

**Last Updated:** 2025-01-06  
**Status:** 🟡 Ready for Use  
**Next:** Begin pre-release validation
