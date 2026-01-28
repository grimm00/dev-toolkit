# CHANGELOG Draft - v0.4.0

**Draft Created:** 2026-01-27  
**Status:** 🔴 Draft - Needs Review

---

## [0.4.0] - 2026-01-27

### Added

- **dt-workflow Command** - Unified workflow orchestration for exploration, research, and decision phases
  - Context injection with START/MIDDLE/END ordering (FR-2)
  - Three workflow modes: explore, research, decision
  - Interactive mode (`--interactive`) for AI-assisted workflows
  - Validation mode (`--validate`) for pre-flight checks
  - Output customization (`--output`) for file generation
  - Project override (`--project`) for multi-project support
  - Model recommendations per workflow type (Phase 4)
  - Context profiles: default, minimal, full (`--profile`)
  - Dry run preview mode (`--dry-run`)
  - Workflow chaining (`--from-explore`, `--from-research`)
  - 93 unit tests with comprehensive coverage

- **dt-doc-gen Command** - Document generation from templates (PR #30)
  - Template rendering with variable substitution
  - Support for exploration, research, decision templates
  - Integration with doc-infrastructure library

- **dt-doc-validate Command** - Document validation (PR #31)
  - L1/L2/L3 validation levels
  - Structural and content validation
  - Template compliance checking

- **doc-infrastructure Library** - Shared infrastructure for document tools (PR #29)
  - Common utilities for template handling
  - Shared validation functions
  - Reusable rendering components

### Changed

- **Workflow Commands** - Enhanced Cursor command documentation
  - `/pr-validation` - Added development environment setup section (Step 1f)
  - `/release-prep` - Added installation verification section (Step 3a)
  - `/pr-validation` - Added threshold-based in-line fix approach

### Fixed

- **Test Reliability** - Relaxed performance test thresholds (PR #37)
  - Context injection: 1s → 5s threshold
  - Validation: 500ms → 2.5s threshold
  - Smoke test naming standardization

- **Test Specificity** - Strengthened model recommendation tests (PR #36)
  - Added specific model name assertions
  - Added rationale content verification

- **Documentation Cleanup** - Fixed documentation issues (PR #35)
  - Purpose line consistency
  - Template name headings
  - Test comments

### Documentation

- **Manual Testing Guide** - Comprehensive scenarios for Phases 1-4
- **ADRs** - 6 architecture decision records for dt-workflow
- **Pattern Library** - 5 workflow patterns documented
- **Fix Tracking** - Sourcery review feedback management

---

## PRs Included

| PR | Title | Merged |
|----|-------|--------|
| #29 | feat(doc-infrastructure): add shared infrastructure library (Phase 1) | 2026-01-21 |
| #30 | feat: dt-doc-gen Implementation (Phase 2) | 2026-01-22 |
| #31 | feat: Implement dt-doc-validate Command (Phase 3) | 2026-01-22 |
| #32 | feat: dt-workflow Phase 1 - Foundation (Production Quality) | 2026-01-26 |
| #33 | feat: Workflow Expansion + Template Enhancement (Phase 2) | 2026-01-26 |
| #34 | feat: dt-workflow Enhancement - Model Recommendations, Profiles, Dry Run (Phase 4) | 2026-01-27 |
| #35 | fix: Documentation cleanup (pr33-batch-low-low-01) | 2026-01-27 |
| #36 | fix: Strengthen model recommendation tests (pr34-batch-medium-low-01) | 2026-01-27 |
| #37 | fix: Relax performance test thresholds (pr34-batch-medium-medium-01) | 2026-01-27 |

---

## Statistics

| Metric | Value |
|--------|-------|
| PRs Merged | 9 |
| Commits | 162 |
| New Commands | 3 (dt-workflow, dt-doc-gen, dt-doc-validate) |
| New Tests | 93+ |
| ADRs Created | 6 |
| Patterns Documented | 5 |

---

## Review Checklist

- [ ] All PRs listed
- [ ] Categorization correct (Added/Changed/Fixed/Documentation)
- [ ] Descriptions accurate and user-facing
- [ ] Breaking changes noted (none in this release)
- [ ] Ready to merge into CHANGELOG.md
