# Fix Plan: PR 34 Batch MEDIUM MEDIUM - Batch 01

**PR:** 34  
**Batch:** medium-medium-01  
**Priority:** 🟡 MEDIUM  
**Effort:** 🟡 MEDIUM  
**Status:** 🔴 Not Started  
**Created:** 2026-01-27  
**Issues:** 2 issues

---

## Issues in This Batch

| Issue | Priority | Impact | Effort | Description |
|-------|----------|--------|--------|-------------|
| PR34-#2 | 🟡 MEDIUM | 🟡 MEDIUM | 🟡 MEDIUM | Performance tests may be flaky on slower CI runners |
| PR34-Overall-1 | 🟡 MEDIUM | 🟡 MEDIUM | 🟡 MEDIUM | Timing thresholds rely on wall-clock timing |

---

## Overview

This batch contains 2 MEDIUM priority issues with MEDIUM effort. Both issues are related to performance test reliability and timing thresholds. They address concerns about test flakiness in CI environments.

**Estimated Time:** 2-3 hours  
**Files Affected:** `tests/unit/test-performance.bats`

---

## Issue Details

### Issue PR34-#2: Performance Tests May Be Flaky

**Location:** `tests/unit/test-performance.bats:51-59`  
**Sourcery Comment:** Comment #2  
**Priority:** 🟡 MEDIUM | **Impact:** 🟡 MEDIUM | **Effort:** 🟡 MEDIUM

**Description:**
This test hardcodes a 1s wall-clock limit using `date +%s%N`, which can be unreliable on slower or contended CI runners and cause flaky failures even when the code is fine. Consider either loosening the threshold (or asserting only relative ordering of durations), marking strict timing checks as optional/slow or skipping them on known-slow environments, or turning this into a coarse "not absurdly slow" check (e.g. `<5s`) while relying on separate benchmarks for precise NFR validation.

**Current Code:**

```bash
@test "context injection completes under 1 second (NFR-2)" {
    start=$(date +%s%N)
    run "$DT_WORKFLOW" explore test-topic --interactive 2>/dev/null
    end=$(date +%s%N)
    duration=$(( (end - start) / 1000000 )) # ms
    [ "$status" -eq 0 ]
    [ "$duration" -lt 1000 ]
}
```

**Proposed Solution:**
Relax threshold to reduce flakiness while still catching performance regressions:

```bash
@test "context injection completes within acceptable time (NFR-2 smoke)" {
    # Coarse-grained performance smoke test:
    # - Uses a relaxed threshold to avoid flakiness on slow/contended CI runners
    # - Precise NFR validation should be done via dedicated benchmarks/perf tests
    start=$(date +%s%N)
    run "$DT_WORKFLOW" explore test-topic --interactive 2>/dev/null
    end=$(date +%s%N)
    duration=$(( (end - start) / 1000000 )) # Convert to milliseconds
    [ "$status" -eq 0 ]
    # "Not absurdly slow" guardrail: allow up to 5 seconds wall-clock to reduce flakiness
    [ "$duration" -lt 5000 ]  # NFR-2: coarse check (<5 seconds); stricter checks live in perf suites
}
```

---

### Issue PR34-Overall-1: Timing Thresholds Reliability

**Location:** `tests/unit/test-performance.bats` (overall comment)  
**Sourcery Comment:** Overall Comment #1  
**Priority:** 🟡 MEDIUM | **Impact:** 🟡 MEDIUM | **Effort:** 🟡 MEDIUM

**Description:**
The performance tests rely on real wall-clock timing with relatively tight thresholds (<1s, <500ms, <200ms), which can be flaky on slower or contended CI runners. Consider relaxing the bounds or measuring internal timings emitted by dt-workflow instead of raw `date` deltas.

**Current Thresholds:**
- Context injection: <1s (actual: ~300ms, 3x margin)
- Validation: <500ms
- Other timing checks: <200ms

**Proposed Solution:**
Options to consider:
1. **Loosen thresholds** (preferred): Increase margins to 5x or more
2. **Skip on slow environments**: Add environment detection
3. **Internal timing**: Emit timing from dt-workflow itself
4. **Separate benchmark suite**: Move strict NFR validation to dedicated performance tests

---

## Implementation Steps

1. **Review Current Performance Tests**
   - [ ] Audit all timing-based tests in `test-performance.bats`
   - [ ] Identify actual execution times vs thresholds
   - [ ] Check CI logs for any historical flakiness

2. **Issue PR34-#2: Relax Context Injection Threshold**
   - [ ] Update test name to indicate "smoke test" vs strict NFR
   - [ ] Increase threshold from 1s to 5s
   - [ ] Add comment explaining rationale
   - [ ] Update test to use suggested Sourcery code

3. **Issue PR34-Overall-1: Review All Timing Thresholds**
   - [ ] Validation test: Review <500ms threshold
   - [ ] Other timing tests: Review thresholds
   - [ ] Add comments documenting margin rationale
   - [ ] Consider adding environment variables for threshold tuning
   - [ ] Document NFR validation strategy (smoke tests vs benchmarks)

4. **Testing**
   - [ ] Run tests locally multiple times
   - [ ] Verify tests still catch performance regressions
   - [ ] Monitor CI for any remaining flakiness

---

## Testing

- [ ] All existing tests pass
- [ ] Performance tests have reasonable margins
- [ ] Tests still fail if performance regresses significantly
- [ ] No false positives on slow CI runners
- [ ] Documentation updated with NFR validation strategy

**Test Commands:**
```bash
# Run performance tests multiple times to check for flakiness
for i in {1..10}; do
    bats tests/unit/test-performance.bats || echo "Run $i failed"
done
```

---

## Files to Modify

- `tests/unit/test-performance.bats` - Update timing thresholds and add comments

**Optional Documentation:**
- `docs/testing/performance-testing.md` - Document NFR validation strategy (if file exists)
- `README.md` - Note about performance test thresholds (if applicable)

---

## Definition of Done

- [ ] All timing tests reviewed and updated
- [ ] Thresholds loosened appropriately
- [ ] Comments added explaining rationale
- [ ] Tests passing consistently
- [ ] Ready for PR

---

**Batch Rationale:**
These two issues are batched together because they're both related to performance test reliability and timing thresholds. They address the same underlying concern about test flakiness in CI environments and can be fixed together efficiently.

**Deferred Reasoning:**
- Current thresholds have 3x+ margins (1s threshold, ~300ms actual)
- No flakiness observed in current CI runs
- Tests do validate performance requirements
- Enhancement improves robustness but not urgent
- Will monitor CI before adjusting
