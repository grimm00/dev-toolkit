# dt-review - Feature Plan

**Status:** 🔧 In Progress
**Created:** 2025-10-07
**Last Updated:** 2025-10-07
**Priority:** Medium

---

## 📋 Overview

`dt-review` is a convenience wrapper for `dt-sourcery-parse` that simplifies the process of extracting Sourcery reviews and saving them to standard locations. It provides a streamlined interface while leveraging the existing parser's robust functionality.

### Context

During the development of the Sourcery Overall Comments feature, we discovered that `dt-review` had evolved into a complex script that duplicated logic instead of leveraging the existing `dt-sourcery-parse` functionality. This led to flawed implementations and maintenance issues.

### Goals

1. **Simplify Review Extraction** - One command to extract and save Sourcery reviews
2. **Standardize Output** - Consistent `admin/feedback/sourcery/pr##.md` format
3. **Leverage Existing Parser** - Use `dt-sourcery-parse` for all heavy lifting
4. **Support Flexibility** - Allow custom output paths when needed
5. **Maintain Clean Architecture** - Simple wrapper, not duplicate logic

---

## 🎯 Success Criteria

- [x] ✅ **Clean Architecture** - Simple wrapper that calls `dt-sourcery-parse`
- [x] ✅ **Standard Output Location** - Default `admin/feedback/sourcery/pr##.md` format
- [x] ✅ **Custom Path Support** - Accept custom output path as second argument
- [x] ✅ **Rich Details** - Automatically use `--rich-details` flag
- [x] ✅ **Help Documentation** - Clear usage examples and help text
- [ ] **Integration Tests** - Test both default and custom output paths
- [ ] **Error Handling Tests** - Test invalid PR numbers and error cases
- [ ] **Overall Comments Detection** - Proper implementation (future enhancement)

**Progress:** 5/8 complete (63%)

---

## 🚫 Out of Scope

**Excluded from this feature:**
- ❌ **Overall Comments Detection** - This should be handled by `dt-sourcery-parse`, not `dt-review`
- ❌ **Complex Parsing Logic** - All parsing is delegated to the existing parser
- ❌ **Multiple Output Formats** - Only markdown output supported
- ❌ **Batch Processing** - Single PR at a time only

---

## 📅 Implementation Phases

### Phase 1: Refactoring ✅

**Status:** ✅ Complete (2025-10-07)
**Duration:** 1 hour
**PR:** TBD

**Tasks:**
- [x] ✅ **Revert Flawed Detection** - Remove overly simplistic Overall Comments detection
- [x] ✅ **Clean Architecture** - Make dt-review a simple wrapper
- [x] ✅ **Support Custom Paths** - Add optional second argument for output path
- [x] ✅ **Update Help Text** - Document new usage patterns
- [x] ✅ **Test Basic Functionality** - Verify wrapper works correctly

**Result:** Clean, focused wrapper that leverages existing parser functionality

---

### Phase 2: Testing & Documentation 🟠

**Status:** 🟠 In Progress (2025-10-07)
**Duration:** 2-3 hours
**PR:** TBD

**Tasks:**
- [x] ✅ **Feature Documentation** - Create hub-and-spoke documentation structure
- [ ] **Integration Tests** - Test default and custom output paths
- [ ] **Error Handling Tests** - Test invalid inputs and error cases
- [ ] **Help Text Tests** - Verify help output is correct
- [ ] **Documentation Review** - Ensure all docs are complete and accurate

**Result:** Comprehensive testing and documentation

---

### Phase 3: Future Enhancements ⏳

**Status:** ⏳ Planned
**Duration:** 2-3 hours
**PR:** TBD

**Tasks:**
- [ ] **Overall Comments Detection** - Proper implementation that analyzes parser output
- [ ] **Enhanced Feedback** - Better success/failure messages
- [ ] **Performance Optimization** - If needed based on testing

**Result:** Enhanced functionality while maintaining clean architecture

---

## 🎉 Success Metrics

### Architecture - ACTUAL RESULTS

**After Phase 1:** ✅ Complete
- ✅ Simple wrapper (89 lines vs previous complex implementation)
- ✅ Leverages existing parser functionality
- ✅ Supports both default and custom output paths
- ✅ Clear separation of concerns

---

## 🎊 Key Achievements

1. **Clean Architecture** - Eliminated duplicate logic and flawed detection
2. **Flexible Output** - Supports both standard and custom output paths
3. **Proper Delegation** - All heavy lifting done by `dt-sourcery-parse`
4. **Clear Interface** - Simple, intuitive command-line interface

---

## 🚀 Next Steps

### Immediate (This Session)
1. **Complete Documentation** - Finish hub-and-spoke documentation structure
2. **Create Integration Tests** - Test both default and custom output paths
3. **Test Error Handling** - Verify proper error messages and exit codes

### Future Enhancements
1. **Overall Comments Detection** - Proper implementation that analyzes parser output
2. **Enhanced User Experience** - Better feedback and success messages
3. **Performance Optimization** - If needed based on testing

---

## 📚 Related Documents

### Core Implementation
- [dt-sourcery-parse](../sourcery-overall-comments/) - Core parser functionality
- [bin/dt-review](../../../../bin/dt-review) - Implementation file

### Documentation
- [Status & Next Steps](status-and-next-steps.md) - Current status
- [Quick Start](quick-start.md) - Usage guide
- [Architecture Analysis](architecture-analysis.md) - Design decisions

---

**Last Updated:** 2025-10-07
**Status:** 🔧 In Progress - Refactoring Complete, Testing & Documentation In Progress
**Next:** Complete integration tests and documentation
