# Sourcery AI Optimization Guide

**Purpose:** Comprehensive guide for optimizing Sourcery AI usage to avoid diff limits and rate limiting  
**Created:** 2025-01-06  
**Status:** Active

---

## 🚨 Critical Issues

### Diff Limit Problem
- **Issue:** Sourcery AI has a diff limit that blocks reviews when too many files are changed
- **Impact:** Prevents code reviews, blocks development workflow
- **Cost:** Expensive rate limiting even with Pro subscription

### Rate Limiting
- **Issue:** Sourcery reviews too many files, hitting API limits
- **Impact:** Expensive, unsustainable development costs
- **Solution:** Ultra-restrictive configuration

---

## 🎯 Optimization Strategy

### 1. Ultra-Restrictive File Scope
**Only review these files:**
- `bin/*.sh` - Command executables only
- `lib/core/*.sh` - Core libraries only  
- `install.sh` - Installation script

**Exclude everything else:**
- All documentation (`admin/`, `docs/`, `*.md`)
- All planning files (`admin/planning/`)
- All test files (`tests/`)
- All configuration files (`.github/workflows/`, `config/`)
- All feedback and logs (`admin/feedback/`, `admin/chat-logs/`)

### 2. Size Limits
- **Minimum:** 15 lines changed (skip tiny changes)
- **Maximum:** 100 lines changed (skip massive changes)
- **Significant changes only:** Skip formatting-only changes

### 3. Severity Threshold
- **Only review:** High severity issues
- **Skip:** Style suggestions, minor improvements
- **Focus:** Security, performance, critical bugs

---

## 📋 Configuration Details

### Current `.sourcery.yaml`
```yaml
# ULTRA-RESTRICTIVE: Only review critical code files
path_patterns:
  - "bin/*.sh"                       # Command executables only
  - "lib/core/*.sh"                  # Core libraries only
  - "install.sh"                     # Installation script

ignore_patterns:
  - "**"                             # Exclude everything by default
  - "!bin/*.sh"                      # Except command executables
  - "!lib/core/*.sh"                 # Except core libraries
  - "!install.sh"                    # Except installation script

github:
  min_lines_changed: 15              # Skip small changes
  max_lines_changed: 100             # Skip large changes
  significant_changes_only: true     # Skip formatting
  ignore_whitespace: true            # Skip whitespace changes

review:
  severity_threshold: "high"         # Only critical issues
  skip_test_files: true              # Skip test files
  skip_config_files: true            # Skip config files
```

---

## 🔧 Troubleshooting

### If Sourcery Still Reviews Too Many Files

1. **Check file paths** - Ensure only essential files are included
2. **Verify ignore patterns** - Make sure `**` excludes everything by default
3. **Test with small PR** - Create a test PR with minimal changes
4. **Monitor diff size** - Keep PRs under 100 lines changed

### If Rate Limiting Continues

1. **Increase size limits** - Raise `min_lines_changed` to 20-25
2. **Reduce file scope** - Only include `bin/*.sh` and `install.sh`
3. **Disable auto-reviews** - Set `request_review: false`
4. **Manual reviews only** - Use Sourcery only when explicitly requested

### If Diff Limits Still Hit

1. **Split PRs** - Break large changes into smaller PRs
2. **Use feature flags** - Implement changes incrementally
3. **Separate concerns** - Keep code and documentation in separate PRs
4. **Temporary disable** - Disable Sourcery for large refactoring PRs

---

## 📊 Expected Results

### Before Optimization
- ❌ Reviews 50+ files per PR
- ❌ Hits diff limits frequently
- ❌ Rate limiting issues
- ❌ Expensive, unsustainable

### After Optimization
- ✅ Reviews 1-3 files per PR
- ✅ No diff limit issues
- ✅ No rate limiting
- ✅ Cost-effective, sustainable

---

## 🚀 Implementation Steps

1. **Update `.sourcery.yaml`** - Apply ultra-restrictive configuration
2. **Test with small PR** - Verify configuration works
3. **Monitor results** - Check diff size and review scope
4. **Adjust if needed** - Fine-tune based on results
5. **Document changes** - Update team on new workflow

---

## 📚 Related Documents

- [Documentation Branch Workflow](documentation-branch-workflow.md)
- [Hub-and-Spoke Documentation Best Practices](hub-and-spoke-documentation-best-practices.md)
- [CI Installation Testing Status](../planning/ci/installation-testing/status-and-next-steps.md)

---

**Last Updated:** 2025-01-06  
**Status:** Active  
**Priority:** Critical