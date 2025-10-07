# dt-review - Phase 2: Local Parser Integration

**Status:** 🔧 In Progress
**Created:** 2025-10-07
**Last Updated:** 2025-10-07
**Duration:** 1-2 hours
**Priority:** High

---

## 📋 Overview

Fix the parser path detection in `dt-review` to use the local development version of `dt-sourcery-parse` when running from the dev-toolkit directory. This will enable Overall Comments functionality through the `dt-review` wrapper.

### Problem Statement

**Current Issue:** `dt-review` uses globally installed `dt-sourcery-parse` instead of local development version
- **Result**: Overall Comments functionality not available through `dt-review`
- **Evidence**: 
  - Local parser: "Total Individual Comments: 4 + Overall Comments" ✅
  - dt-review: "Total Comments: 4" ❌

---

## 🎯 Goals

1. **Fix Parser Path Detection** - Update TOOLKIT_ROOT detection logic
2. **Enable Overall Comments** - Make Overall Comments available through dt-review
3. **Maintain Backward Compatibility** - Ensure global installation still works
4. **Test Both Contexts** - Verify local and global usage scenarios

---

## 📅 Tasks

### Task 1: Analyze Current Path Detection Logic

**Status:** ⏳ Pending
**Estimated Time:** 15 minutes

**Description:**
- Review current TOOLKIT_ROOT detection in `dt-review`
- Identify why it's not detecting local development installation
- Document the current behavior and issues

**Deliverables:**
- Analysis of current path detection logic
- Identification of specific issues

---

### Task 2: Design Improved Path Detection

**Status:** ⏳ Pending
**Estimated Time:** 30 minutes

**Description:**
- Design enhanced path detection logic
- Add local development directory detection
- Ensure proper fallback to global installation
- Plan for edge cases (symlinks, custom paths, etc.)

**Deliverables:**
- Enhanced path detection algorithm
- Fallback strategy documentation
- Edge case handling plan

---

### Task 3: Implement Path Detection Fix

**Status:** ⏳ Pending
**Estimated Time:** 45 minutes

**Description:**
- Update TOOLKIT_ROOT detection logic in `dt-review`
- Add local development directory detection
- Implement proper fallback mechanism
- Add debug output for troubleshooting

**Deliverables:**
- Updated `dt-review` with improved path detection
- Debug output for path detection
- Fallback mechanism implementation

---

### Task 4: Test Local Development Context

**Status:** ⏳ Pending
**Estimated Time:** 30 minutes

**Description:**
- Test `dt-review` from dev-toolkit directory
- Verify it uses local development parser
- Confirm Overall Comments functionality works
- Test with PR #9 (known to have Overall Comments)

**Deliverables:**
- Test results for local development context
- Verification of Overall Comments functionality
- Test output examples

---

### Task 5: Test Global Installation Context

**Status:** ⏳ Pending
**Estimated Time:** 30 minutes

**Description:**
- Test `dt-review` from outside dev-toolkit directory
- Verify it uses global installation parser
- Confirm backward compatibility maintained
- Test error handling for missing installations

**Deliverables:**
- Test results for global installation context
- Backward compatibility verification
- Error handling test results

---

### Task 6: Update Documentation

**Status:** ⏳ Pending
**Estimated Time:** 30 minutes

**Description:**
- Update quick-start guide with troubleshooting info
- Update architecture analysis with new path detection logic
- Update status and next steps document
- Add examples of local vs global usage

**Deliverables:**
- Updated documentation
- Troubleshooting guide
- Usage examples

---

## 🎯 Success Criteria

- [ ] **Local Parser Detection** - dt-review detects and uses local development parser when in dev-toolkit
- [ ] **Overall Comments Working** - Overall Comments functionality available through dt-review
- [ ] **Global Fallback** - Global installation still works when not in dev-toolkit
- [ ] **Backward Compatibility** - Existing usage patterns continue to work
- [ ] **Error Handling** - Clear error messages for missing installations
- [ ] **Documentation Updated** - All docs reflect new behavior

**Progress:** 0/6 complete (0%)

---

## 🔧 Technical Implementation

### Current Path Detection Logic

```bash
# Current logic in dt-review
if [ -n "${DT_ROOT:-}" ]; then
    TOOLKIT_ROOT="$DT_ROOT"
elif [ -f "$HOME/.dev-toolkit/bin/dt-sourcery-parse" ]; then
    TOOLKIT_ROOT="$HOME/.dev-toolkit"
else
    echo "❌ Error: Cannot locate dev-toolkit installation"
    exit 1
fi
```

### Proposed Enhanced Logic

```bash
# Enhanced logic needed
if [ -n "${DT_ROOT:-}" ]; then
    TOOLKIT_ROOT="$DT_ROOT"
elif [ -f "$(dirname "${BASH_SOURCE[0]}")/../lib/sourcery/parser.sh" ]; then
    # Running from dev-toolkit directory
    TOOLKIT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
elif [ -f "$HOME/.dev-toolkit/bin/dt-sourcery-parse" ]; then
    TOOLKIT_ROOT="$HOME/.dev-toolkit"
else
    echo "❌ Error: Cannot locate dev-toolkit installation"
    exit 1
fi
```

### Key Changes

1. **Add Local Detection** - Check for local development installation first
2. **Use BASH_SOURCE** - Get script location for relative path detection
3. **Maintain Fallback** - Keep global installation as fallback
4. **Add Debug Output** - Optional debug information for troubleshooting

---

## 🧪 Testing Strategy

### Test Case 1: Local Development Context

**Setup:**
```bash
cd /Users/cdwilson/Projects/dev-toolkit
dt-review 9
```

**Expected Results:**
- Uses local development parser
- Shows "Total Individual Comments: 4 + Overall Comments"
- Overall Comments section appears in output

### Test Case 2: Global Installation Context

**Setup:**
```bash
cd /tmp
dt-review 9
```

**Expected Results:**
- Uses global installation parser
- Works with existing functionality
- No regression in behavior

### Test Case 3: Custom DT_ROOT

**Setup:**
```bash
export DT_ROOT=/custom/path
dt-review 9
```

**Expected Results:**
- Uses custom DT_ROOT path
- Respects environment variable
- Works as expected

### Test Case 4: Missing Installation

**Setup:**
```bash
# Remove global installation temporarily
mv ~/.dev-toolkit ~/.dev-toolkit.backup
cd /tmp
dt-review 9
```

**Expected Results:**
- Clear error message
- Helpful troubleshooting guidance
- Graceful failure

---

## 🚨 Risk Assessment

### Low Risk
- **Backward Compatibility** - Global installation fallback maintained
- **Error Handling** - Existing error handling preserved

### Medium Risk
- **Path Detection Logic** - New logic might have edge cases
- **Symlink Handling** - Need to test with symlinked installations

### Mitigation Strategies
- **Comprehensive Testing** - Test all scenarios thoroughly
- **Debug Output** - Add optional debug information
- **Fallback Mechanism** - Maintain existing fallback logic
- **Documentation** - Clear troubleshooting guide

---

## 📊 Expected Outcomes

### Immediate Benefits
- **Overall Comments Available** - Through dt-review wrapper
- **Development Workflow** - Proper local development support
- **Consistent Behavior** - Same functionality regardless of context

### Long-term Benefits
- **Better Development Experience** - Developers can use local features
- **Easier Testing** - Test new features through dt-review
- **Improved Workflow** - Seamless local vs global usage

---

## 🎯 Definition of Done

- [ ] **Code Changes** - Path detection logic updated and tested
- [ ] **Functionality Verified** - Overall Comments work through dt-review
- [ ] **Backward Compatibility** - Global installation still works
- [ ] **Documentation Updated** - All docs reflect new behavior
- [ ] **Testing Complete** - All test cases pass
- [ ] **No Regressions** - Existing functionality unchanged

---

## 📚 Related Documents

- **[Feature Plan](feature-plan.md)** - Overall feature overview
- **[Status & Next Steps](status-and-next-steps.md)** - Current status
- **[Architecture Analysis](architecture-analysis.md)** - Design decisions
- **[Quick Start](quick-start.md)** - Usage guide

---

**Last Updated:** 2025-10-07
**Status:** 🔧 In Progress - Ready to Start
**Next:** Begin Task 1 - Analyze Current Path Detection Logic
