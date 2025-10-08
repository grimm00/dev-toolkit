# dt-review - Feature Plan

**Status:** 🔧 In Progress
**Created:** 2025-10-07
**Last Updated:** 2025-10-07
**Priority:** Medium

---

## 📋 Overview

`dt-review` is a convenience wrapper for `dt-sourcery-parse` that simplifies the process of extracting Sourcery reviews and saving them to standard locations. It provides a streamlined interface while leveraging the existing parser's robust functionality.

### Context

During the development of the Sourcery Overall Comments feature, we discovered that `dt-review` had evolved into a complex script that duplicated logic instead of leveraging the existing `dt-sourcery-parse` functionality. We refactored it to be a clean wrapper, but there's still an issue with parser path detection.

### Goals

1. **Simplify Review Extraction** - One command to extract and save Sourcery reviews
2. **Standardize Output** - Consistent `admin/feedback/sourcery/pr##.md` format
3. **Leverage Existing Parser** - Use `dt-sourcery-parse` for all heavy lifting
4. **Support Flexibility** - Allow custom output paths when needed
5. **Maintain Clean Architecture** - Simple wrapper, not duplicate logic
6. **Use Local Development Version** - Properly detect and use local parser when in dev-toolkit

---

## 🎯 Success Criteria

- [x] ✅ **Clean Architecture** - Simple wrapper that calls `dt-sourcery-parse`
- [x] ✅ **Standard Output Location** - Default `admin/feedback/sourcery/pr##.md` format
- [x] ✅ **Custom Path Support** - Accept custom output path as second argument
- [x] ✅ **Rich Details** - Automatically use `--rich-details` flag
- [x] ✅ **Help Documentation** - Clear usage examples and help text
- [x] ✅ **Local Parser Integration** - Use local development parser when in dev-toolkit
- [ ] **Integration Tests** - Test both default and custom output paths
- [ ] **Error Handling Tests** - Test invalid PR numbers and error cases

**Progress:** 6/8 complete (75%)

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
**PR:** N/A (restored from previous work)

**Tasks:**
- [x] ✅ **Revert Flawed Detection** - Remove overly simplistic Overall Comments detection
- [x] ✅ **Clean Architecture** - Make dt-review a simple wrapper
- [x] ✅ **Support Custom Paths** - Add optional second argument for output path
- [x] ✅ **Update Help Text** - Document new usage patterns
- [x] ✅ **Test Basic Functionality** - Verify wrapper works correctly

**Result:** Clean, focused wrapper that leverages existing parser functionality

---

### Phase 2: Local Parser Integration ✅

**Status:** ✅ Complete (2025-10-07)
**Duration:** 2 hours
**PR:** #15

**Tasks:**
- [x] ✅ **Fix Parser Path Detection** - Use local development parser when in dev-toolkit
- [x] ✅ **Test Local vs Global** - Ensure correct parser is used in different contexts
- [x] ✅ **Update Path Logic** - Improve TOOLKIT_ROOT detection
- [x] ✅ **Verify Overall Comments** - Ensure Overall Comments work through dt-review

**Result:** dt-review uses local development parser when appropriate

---

### Phase 3: Testing & Documentation ⏳

**Status:** ⏳ Planned
**Duration:** 2-3 hours
**PR:** TBD

**Tasks:**
- [ ] **Integration Tests** - Test default and custom output paths
- [ ] **Error Handling Tests** - Test invalid inputs and error cases
- [ ] **Context Tests** - Test local vs global parser usage
- [ ] **Edge Case Tests** - Test various PR scenarios
- [ ] **Documentation Review** - Ensure all docs are complete and accurate

**Result:** Comprehensive testing and documentation for production readiness

---

## 🎉 Success Metrics

### Architecture - ACTUAL RESULTS

**After Phase 1:** ✅ Complete
- ✅ Simple wrapper (89 lines vs previous complex implementation)
- ✅ Leverages existing parser functionality
- ✅ Supports both default and custom output paths
- ✅ Clear separation of concerns

**After Phase 2:** ✅ Complete
- ✅ Uses local development parser when in dev-toolkit
- ✅ Overall Comments functionality available through dt-review
- ✅ Proper path detection and fallback logic

---

## 🎊 Key Achievements

1. **Clean Architecture** - Eliminated duplicate logic and flawed detection
2. **Flexible Output** - Supports both standard and custom output paths
3. **Proper Delegation** - All heavy lifting delegated to `dt-sourcery-parse`
4. **Clear Interface** - Simple, intuitive command-line interface
5. **Restored Functionality** - Brought back improved version from previous work

---

## 🚀 Next Steps

### Immediate (This Session)
1. **Fix Local Parser Integration** - Update path detection logic
2. **Test Overall Comments** - Verify dt-review works with local parser
3. **Update Documentation** - Reflect current status and next steps

### Future Enhancements
1. **Integration Tests** - Comprehensive test coverage
2. **Error Handling** - Better error messages and edge cases
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
**Status:** ✅ Phase 2 Complete - Local Parser Integration
**Next:** Phase 3 - Testing & Documentation
