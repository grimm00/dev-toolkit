# PR #34 Fix Tracking

**PR**: #34 - feat: dt-workflow Enhancement - Model Recommendations, Profiles, Dry Run (Phase 4)  
**Status**: ✅ Merged (2026-01-27)  
**Phase**: Phase 4

---

## 📋 Deferred Issues

**Date:** 2026-01-27  
**Review:** PR #34 (Phase 4) Sourcery feedback  
**Status:** 🟡 **DEFERRED** - All MEDIUM/LOW priority, can be handled opportunistically

**Deferred Issues:**

- **PR34-#1:** Strengthen model recommendation tests to assert specific model per workflow type (MEDIUM priority, LOW effort) - Tests currently verify feature works; more specific assertions can be added when model selection logic becomes more complex
- **PR34-#2:** Performance tests may be flaky on slower CI runners (MEDIUM priority, MEDIUM effort) - Current thresholds have 3x+ margin (1s threshold, ~300ms actual); will monitor CI for flakiness before adjusting
- **PR34-Overall-1:** Timing threshold concerns same as #2 (MEDIUM priority, MEDIUM effort) - Same mitigation: monitor CI before adjusting
- **PR34-Overall-2:** `date +%s%N` portability concerns (LOW priority, MEDIUM effort) - macOS and Linux both support nanosecond precision; low priority

**Action Plan:** These can be handled opportunistically during future phases or in a dedicated code quality improvement PR. Priority is low since:
- Tests functionally validate the features work correctly
- Performance thresholds have generous margins
- No flakiness observed in current CI runs

---

## Related Documents

- [Phase 4 Planning](../../phase-4.md)
- [Sourcery Review](../../../../feedback/sourcery/pr34.md)
- [Main Fix Tracking](../README.md)
