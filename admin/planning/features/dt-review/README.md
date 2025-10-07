# dt-review Feature

**Status:** 🔧 In Progress - Refactoring
**Created:** 2025-10-07
**Last Updated:** 2025-10-07
**Priority:** Medium

---

## 📋 Quick Links

### Core Documents
- **[Feature Plan](feature-plan.md)** - High-level overview and goals
- **[Status & Next Steps](status-and-next-steps.md)** - Current status and options
- **[Quick Start](quick-start.md)** - How to use dt-review

### Analysis Documents
- **[Architecture Analysis](architecture-analysis.md)** - Design decisions and rationale

---

## 🎯 Overview

`dt-review` is a convenience wrapper for `dt-sourcery-parse` that provides a streamlined interface for extracting Sourcery reviews with standard output locations and rich formatting.

### Goals

1. **Simplify Sourcery Review Extraction** - One command to extract and save reviews
2. **Standardize Output Location** - Consistent `admin/feedback/sourcery/pr##.md` format
3. **Leverage Existing Parser** - Use `dt-sourcery-parse` for all heavy lifting
4. **Support Custom Paths** - Allow custom output locations when needed

---

## 📊 Current Status

### ✅ Completed

| Phase | Description | Status |
|-------|-------------|--------|
| Initial Implementation | Basic wrapper functionality | ✅ Complete |
| Refactoring | Clean architecture leveraging parser | ✅ Complete |

### 🔧 In Progress

| Phase | Description | Status |
|-------|-------------|--------|
| Documentation | Feature documentation using hub-and-spoke pattern | 🟠 In Progress |

### ⏳ Planned

| Phase | Description | Estimated |
|-------|-------------|-----------|
| Testing | Integration tests for dt-review | 1-2 hours |
| Enhancement | Overall Comments detection (proper implementation) | 2-3 hours |

**Metrics:**
- Current implementation: 89 lines (clean, focused)
- Supports both default and custom output paths
- Leverages existing `dt-sourcery-parse` functionality

---

## 🚀 Quick Start

### Basic Usage

```bash
# Extract review to standard location
dt-review 6
# Saves to admin/feedback/sourcery/pr06.md

# Extract review to custom location
dt-review 6 my-review.md
# Saves to my-review.md

# Get help
dt-review --help
```

### What It Does

1. **Calls `dt-sourcery-parse`** with `--rich-details` flag
2. **Saves to standard location** by default (`admin/feedback/sourcery/pr##.md`)
3. **Supports custom paths** as second argument
4. **Provides clear feedback** on success/failure

---

## 🎊 Key Achievements

1. **Clean Architecture** - Simple wrapper that leverages existing parser
2. **Flexible Output** - Supports both standard and custom output paths
3. **Proper Error Handling** - Clear error messages and exit codes
4. **Help Documentation** - Comprehensive usage examples

---

## 📚 Related Documents

### Planning
- [Feature Plan](feature-plan.md) - Overview and goals
- [Status & Next Steps](status-and-next-steps.md) - Current status

### Analysis
- [Architecture Analysis](architecture-analysis.md) - Design decisions

### Implementation
- [dt-sourcery-parse](../sourcery-overall-comments/) - Core parser functionality

---

**Last Updated:** 2025-10-07
**Status:** 🔧 In Progress - Refactoring
**Next:** Complete feature documentation and testing
