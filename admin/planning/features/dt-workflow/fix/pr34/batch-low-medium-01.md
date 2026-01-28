# Fix Plan: PR 34 Batch LOW MEDIUM - Batch 01

**PR:** 34  
**Batch:** low-medium-01  
**Priority:** 🟢 LOW  
**Effort:** 🟡 MEDIUM  
**Status:** 🔴 Not Started  
**Created:** 2026-01-27  
**Issues:** 1 issue

---

## Issues in This Batch

| Issue | Priority | Impact | Effort | Description |
|-------|----------|--------|--------|-------------|
| PR34-Overall-2 | 🟢 LOW | 🟢 LOW | 🟡 MEDIUM | `date +%s%N` portability concerns |

---

## Overview

This batch contains 1 LOW priority issue with MEDIUM effort. This issue addresses potential portability concerns with nanosecond-precision timing across different Unix-like systems.

**Estimated Time:** 1-2 hours  
**Files Affected:** `tests/unit/test-performance.bats`

---

## Issue Details

### Issue PR34-Overall-2: `date +%s%N` Portability

**Location:** `tests/unit/test-performance.bats` (overall comment)  
**Sourcery Comment:** Overall Comment #2  
**Priority:** 🟢 LOW | **Impact:** 🟢 LOW | **Effort:** 🟡 MEDIUM

**Description:**
The use of `date +%s%N` for timing in the Bats tests may not be portable across all environments (e.g., BSD/macOS `date`). Consider using a more portable timing approach (such as `TIMEFORMAT` with `time`, or a small helper script) to avoid platform-specific failures.

**Current Approach:**
```bash
start=$(date +%s%N)
run "$DT_WORKFLOW" explore test-topic --interactive 2>/dev/null
end=$(date +%s%N)
duration=$(( (end - start) / 1000000 )) # Convert to milliseconds
```

**Portability Status:**
- **GNU date** (Linux): Supports `+%s%N` (nanoseconds)
- **BSD date** (macOS): **Also supports `+%s%N`** since macOS 10.13+
- **Other BSD variants**: May not support nanoseconds

**Proposed Solutions:**

**Option 1: Use TIMEFORMAT with time (most portable)**
```bash
@test "context injection completes within acceptable time (NFR-2)" {
    # Use bash's TIMEFORMAT for portable timing
    TIMEFORMAT='%3R'  # Real time in seconds with 3 decimal places
    duration=$(time ( "$DT_WORKFLOW" explore test-topic --interactive 2>/dev/null ) 2>&1)
    # Convert to milliseconds for comparison
    duration_ms=$(awk "BEGIN {print int($duration * 1000)}")
    [ "$duration_ms" -lt 5000 ]
}
```

**Option 2: Fallback to seconds-only (simplest)**
```bash
@test "context injection completes within acceptable time (NFR-2)" {
    # Fallback to seconds-only timing for maximum portability
    start=$(date +%s)
    run "$DT_WORKFLOW" explore test-topic --interactive 2>/dev/null
    end=$(date +%s)
    duration=$(( end - start ))
    [ "$status" -eq 0 ]
    [ "$duration" -lt 5 ]  # Less than 5 seconds
}
```

**Option 3: Helper script with fallback logic**
```bash
# Create tests/helpers/portable-time.sh
get_time_ms() {
    if date +%s%N >/dev/null 2>&1; then
        # GNU/modern BSD date with nanoseconds
        date +%s%N | sed 's/......$//'  # Convert ns to ms
    else
        # Fallback to seconds * 1000
        echo $(($(date +%s) * 1000))
    fi
}
```

---

## Implementation Steps

1. **Research Current Usage**
   - [ ] Verify macOS `date +%s%N` support (confirmed: works on macOS 10.13+)
   - [ ] Check if project needs to support older macOS versions
   - [ ] Check if project needs to support other BSD variants
   - [ ] Review project's CI environments

2. **Decide on Approach**
   - [ ] If macOS 10.13+ is minimum → Keep current approach, document requirement
   - [ ] If broader compatibility needed → Implement Option 1 (TIMEFORMAT) or Option 3 (helper)
   - [ ] If simplicity preferred → Use Option 2 (seconds-only)

3. **Implementation**
   - [ ] Choose solution based on project requirements
   - [ ] Update test-performance.bats
   - [ ] Add comments documenting portability considerations
   - [ ] Test on available platforms (Linux, macOS)

4. **Documentation**
   - [ ] Document timing approach in test file comments
   - [ ] Add note to README about minimum macOS version (if applicable)
   - [ ] Document in CONTRIBUTING.md if relevant

---

## Testing

- [ ] All tests pass on Linux
- [ ] All tests pass on macOS
- [ ] Tests pass on project's CI environments
- [ ] No regressions in timing accuracy
- [ ] Documentation updated

**Test Commands:**
```bash
# Run on Linux
bats tests/unit/test-performance.bats

# Run on macOS
bats tests/unit/test-performance.bats

# Check date support
date +%s%N  # Should output nanoseconds
```

---

## Files to Modify

- `tests/unit/test-performance.bats` - Update timing approach if needed
- `tests/helpers/portable-time.sh` - Create if using Option 3
- `README.md` or `CONTRIBUTING.md` - Document platform requirements

---

## Definition of Done

- [ ] Portability assessment complete
- [ ] Solution implemented (or current approach documented as acceptable)
- [ ] Tests passing on all target platforms
- [ ] Platform requirements documented
- [ ] Ready for PR

---

**Batch Rationale:**
This issue is batched separately because it's a portability concern with LOW priority. macOS and Linux both support `date +%s%N`, so the issue is only relevant for other BSD variants. Can be implemented opportunistically if broader platform support is needed.

**Deferred Reasoning:**
- macOS (primary dev environment) supports `date +%s%N` since 10.13+
- Linux (CI environment) fully supports nanosecond precision
- No platform-specific failures observed
- Only relevant if supporting older macOS or other BSD variants
- Enhancement improves portability but not urgent
