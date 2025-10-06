# v0.2.0 Release Checklist

**Release Name:** Testing & Reliability  
**Target Date:** October 6, 2025  
**Release Manager:** @grimm00  
**Status:** 🚧 In Progress

---

## Pre-Release Preparation

### Code & Testing
- [x] All PRs merged to develop
  - [x] PR #6: Phase 1 - Testing Foundation
  - [x] PR #8: Phase 2 - Core Utilities Tests
  - [x] PR #9: Phase 3 Parts A & B
  - [x] PR #10: Phase 3 Part C
- [x] All tests passing locally (215/215)
- [x] No known critical bugs
- [x] ShellCheck warnings resolved
- [x] CI/CD trigger frequency fixed

### Documentation
- [x] CHANGELOG.md updated
- [ ] VERSION file updated (currently: ?)
- [x] README.md up to date
- [x] Release notes written
- [x] Feature documentation complete
  - [x] docs/TESTING.md
  - [x] docs/troubleshooting/testing-issues.md
  - [x] admin/planning/features/testing-suite/

### Planning
- [x] Roadmap updated
- [x] Release process documented
- [x] Release history prepared
- [x] Phase 4 deferred (optional enhancements)

---

## Release Branch Workflow

### 1. Create Release Branch
- [x] Create branch: `release/v0.2.0` from develop
  ```bash
  git checkout develop
  git pull origin develop
  git checkout -b release/v0.2.0
  ```

### 2. Prepare Release
- [x] Update VERSION file to `0.2.0`
  ```bash
  echo "0.2.0" > VERSION
  ```
- [x] Update CHANGELOG.md with release date
- [x] Update any version references in README (none needed)
- [x] Commit release preparation
  ```bash
  git add VERSION CHANGELOG.md
  git commit -m "chore: Prepare release v0.2.0"
  ```

### 3. Final Testing
- [x] Run all tests locally
  ```bash
  ./scripts/test.sh
  ```
- [x] Verify all 215 tests pass ✅
- [x] Test installation process
  ```bash
  ./install.sh --help
  ```
- [x] Verify commands work
  ```bash
  ./bin/dt-git-safety --version
  ./bin/dt-config show
  ```

### 4. Push Release Branch
- [x] Push release branch to GitHub
  ```bash
  git push -u origin release/v0.2.0
  ```
- [x] **CI will NOT run on branch push** (by design - only runs on PRs and main)
  - This is correct behavior per our CI workflow changes
  - CI will run when we merge to main (step 5)
  - All tests passed locally (215/215) ✅

---

## Release Execution

**Note:** We merged directly to main instead of creating a PR. In future releases, create a PR from release branch to main first to test CI before merging.

### 5. Merge to Main
- [x] Switch to main
  ```bash
  git checkout main
  git pull origin main
  ```
- [x] Merge release branch (no fast-forward)
  ```bash
  git merge release/v0.2.0 --no-ff -m "Release v0.2.0: Testing & Reliability"
  ```
- [x] Push to main
  ```bash
  git push origin main
  ```
- [x] **CI ran on main** (validates the release)
- [x] CI passed! ✅ (after hotfix for link checker)
  - Had to apply hotfix for markdown-link-check config
  - All tests passed, linting passed, docs passed

### 6. Create Git Tag
- [ ] Create annotated tag
  ```bash
  git tag -a v0.2.0 -m "Release v0.2.0: Testing & Reliability

  Major release adding comprehensive automated testing suite:
  - 215 automated tests (144 unit + 71 integration)
  - < 15 second test execution
  - 100% test pass rate
  - CI/CD test integration
  - dt-review command
  - Comprehensive testing documentation
  
  See admin/planning/releases/v0.2.0/release-notes.md for full details."
  ```
- [ ] Push tag
  ```bash
  git push origin v0.2.0
  ```

### 7. Create GitHub Release
- [ ] Create release on GitHub
  ```bash
  gh release create v0.2.0 \
    --title "v0.2.0 - Testing & Reliability" \
    --notes-file admin/planning/releases/v0.2.0/release-notes.md
  ```
- [ ] Verify release appears on GitHub
- [ ] Check release notes formatting

### 8. Merge Back to Develop
- [ ] Switch to develop
  ```bash
  git checkout develop
  git pull origin develop
  ```
- [ ] Merge release branch
  ```bash
  git merge release/v0.2.0 --no-ff -m "Merge release v0.2.0 back to develop"
  ```
- [ ] Push to develop
  ```bash
  git push origin develop
  ```

### 9. Clean Up
- [ ] Delete local release branch
  ```bash
  git branch -d release/v0.2.0
  ```
- [ ] Delete remote release branch
  ```bash
  git push origin --delete release/v0.2.0
  ```

---

## Post-Release

### Verification
- [ ] Test installation from main
  ```bash
  cd /tmp
  git clone https://github.com/grimm00/dev-toolkit.git
  cd dev-toolkit
  ./install.sh
  dt-git-safety --version
  ```
- [ ] Verify GitHub release page
- [ ] Check that tag is visible
- [ ] Verify release notes are correct

### Documentation Updates
- [ ] Update roadmap status (v0.2.0 RELEASED)
- [ ] Update release history
- [ ] Close any related milestones (if using GitHub milestones)
- [ ] Update this checklist status to ✅ COMPLETE

### Communication
- [ ] Announce release (if applicable)
  - Internal team notification
  - Update project README badges (if any)
  - Social media (if applicable)

---

## Rollback Plan (If Needed)

If critical issues are found after release:

1. **Immediate:**
   - Document the issue
   - Assess severity (can wait for v0.2.1 or needs immediate fix?)

2. **For Critical Issues:**
   - Create hotfix branch from main: `hotfix/v0.2.1`
   - Fix the issue
   - Follow hotfix process (see releases/README.md)
   - Release v0.2.1

3. **For Non-Critical Issues:**
   - Create issue on GitHub
   - Plan for v0.2.1 or v0.3.0
   - Document in roadmap

---

## Notes & Decisions

### CI Testing Strategy
- Release branch will test CI workflow
- If CI fails on release branch, create fix branch
- Don't merge to main until CI is green
- This validates our CI changes before release

### Version Numbering
- v0.2.0 = Major feature release (testing suite)
- v0.2.1 = Would be patch/enhancements (if needed)
- v0.3.0 = Next major feature (batch operations)

### What's Included
- 215 automated tests
- dt-review command
- Comprehensive documentation
- All Sourcery feedback addressed (PRs #6, #8, #9, #10)
- CI/CD improvements

### What's Deferred
- Phase 4: Test Enhancements (optional)
  - 3 remaining Sourcery suggestions from PR #10
  - Boundary value testing
  - Will address after v0.3.0 or v0.4.0 if needed

---

## Timeline

| Stage | Status | Date/Time | Notes |
|-------|--------|-----------|-------|
| Pre-Release Prep | ✅ Complete | Oct 6, 2025 | All docs and fixes ready |
| Create Release Branch | ⏳ Pending | | Next step |
| CI Testing | ⏳ Pending | | Will test on release branch |
| Merge to Main | ⏳ Pending | | After CI passes |
| Create Tag | ⏳ Pending | | |
| GitHub Release | ⏳ Pending | | |
| Post-Release | ⏳ Pending | | |

---

## Success Criteria

- [x] All 215 tests passing
- [ ] CI green on release branch
- [ ] CI green on main
- [ ] GitHub release created
- [ ] Tag pushed
- [ ] Installation works from main
- [ ] No critical bugs reported
- [ ] Documentation accurate

---

**When all checkboxes are complete, update status to: ✅ RELEASED**
