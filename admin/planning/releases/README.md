# Release Process

**Purpose:** Document the release process for dev-toolkit  
**Created:** October 6, 2025

---

## 📋 Release Philosophy

### Semantic Versioning

We follow [Semantic Versioning](https://semver.org/): `MAJOR.MINOR.PATCH`

- **MAJOR** (1.0.0) - Breaking changes, incompatible API changes
- **MINOR** (0.2.0) - New features, backward compatible
- **PATCH** (0.2.1) - Bug fixes, backward compatible

### Release Types

**Alpha Releases** (`v0.x.0-alpha`)
- Early development
- May have incomplete features
- For testing and feedback

**Beta Releases** (`v0.x.0-beta`)
- Feature complete
- Needs testing and polish
- May have bugs

**Stable Releases** (`v0.x.0`)
- Production ready
- Fully tested
- Documented

**Production Releases** (`v1.0.0+`)
- Stable API
- Production grade
- Long-term support

---

## 🚀 Release Workflow

### Option 1: Direct Release (Simple)

**Best for:** Small releases, documentation updates, minor versions

```bash
# 1. Ensure develop is ready
git checkout develop
git pull origin develop

# 2. Run all tests
./scripts/test.sh

# 3. Update version and changelog
# Edit VERSION file
# Edit CHANGELOG.md

# 4. Commit version bump
git add VERSION CHANGELOG.md
git commit -m "chore: Bump version to v0.2.0"
git push

# 5. Merge to main
git checkout main
git pull origin main
git merge develop --no-ff -m "Release v0.2.0"
git push

# 6. Create tag
git tag -a v0.2.0 -m "Release v0.2.0: Testing & Reliability"
git push origin v0.2.0

# 7. Create GitHub release
gh release create v0.2.0 \
  --title "v0.2.0 - Testing & Reliability" \
  --notes-file admin/planning/releases/v0.2.0-notes.md

# 8. Switch back to develop
git checkout develop
```

---

### Option 2: Release Branch (Recommended for Major Releases)

**Best for:** Major releases, when you need to prepare/test the release

```bash
# 1. Create release branch from develop
git checkout develop
git pull origin develop
git checkout -b release/v0.2.0

# 2. Prepare release
# - Update VERSION file
# - Update CHANGELOG.md
# - Update README badges/versions
# - Run final tests
# - Fix any last-minute issues

# 3. Commit release preparation
git add VERSION CHANGELOG.md README.md
git commit -m "chore: Prepare release v0.2.0"

# 4. Run all tests one final time
./scripts/test.sh

# 5. Merge to main
git checkout main
git pull origin main
git merge release/v0.2.0 --no-ff -m "Release v0.2.0"
git push

# 6. Create tag
git tag -a v0.2.0 -m "Release v0.2.0: Testing & Reliability"
git push origin v0.2.0

# 7. Merge back to develop
git checkout develop
git merge release/v0.2.0 --no-ff -m "Merge release v0.2.0 back to develop"
git push

# 8. Delete release branch
git branch -d release/v0.2.0
git push origin --delete release/v0.2.0

# 9. Create GitHub release
gh release create v0.2.0 \
  --title "v0.2.0 - Testing & Reliability" \
  --notes-file admin/planning/releases/v0.2.0-notes.md
```

---

## 📝 Release Checklist Template

Copy this for each release:

### Pre-Release
- [ ] All PRs merged to develop
- [ ] All tests passing (`./scripts/test.sh`)
- [ ] CI/CD passing on develop
- [ ] Documentation updated
- [ ] CHANGELOG.md updated
- [ ] VERSION file updated
- [ ] No known critical bugs

### Release Preparation (if using release branch)
- [ ] Create release branch: `release/vX.Y.Z`
- [ ] Update version numbers
- [ ] Update CHANGELOG.md
- [ ] Update README badges/versions
- [ ] Run final test suite
- [ ] Review all changes since last release
- [ ] Create release notes

### Release Execution
- [ ] Merge to main
- [ ] Create and push git tag
- [ ] Create GitHub release
- [ ] Merge back to develop (if using release branch)
- [ ] Delete release branch (if used)

### Post-Release
- [ ] Verify release on GitHub
- [ ] Test installation from main
- [ ] Announce release (if applicable)
- [ ] Update roadmap
- [ ] Close milestone (if using milestones)

---

## 📁 Release Directory Structure

Each release gets its own directory:

```
admin/planning/releases/
├── README.md              # This file (process guide)
├── history.md             # All releases timeline
└── v0.2.0/               # Release-specific directory
    ├── checklist.md      # Release checklist (track progress)
    ├── release-notes.md  # Polished release notes
    └── decisions.md      # Any release-specific decisions (optional)
```

### Creating a New Release Directory

```bash
# Create release directory
mkdir -p admin/planning/releases/vX.Y.Z

# Copy checklist template
cp admin/planning/releases/v0.2.0/checklist.md \
   admin/planning/releases/vX.Y.Z/checklist.md

# Create release notes
touch admin/planning/releases/vX.Y.Z/release-notes.md
```

---

## 📄 Release Notes Template

Create a file: `admin/planning/releases/vX.Y.Z/release-notes.md`

```markdown
# Release vX.Y.Z - [Release Name]

**Release Date:** [Date]  
**Type:** [Alpha/Beta/Stable]

## 🎯 Overview

[Brief description of what this release accomplishes]

## ✨ New Features

- **Feature Name** - Description
- **Feature Name** - Description

## 🐛 Bug Fixes

- Fixed [issue description]
- Fixed [issue description]

## 📚 Documentation

- Added [documentation]
- Updated [documentation]

## 🔧 Improvements

- Improved [area]
- Enhanced [area]

## 📊 Statistics

- **Tests:** X tests (Y unit + Z integration)
- **Execution Time:** < X seconds
- **Pass Rate:** 100%
- **Files Changed:** X files
- **Lines Added:** +X lines

## 🙏 Acknowledgments

[Thank contributors, mention feedback sources]

## 📖 Full Changelog

See [CHANGELOG.md](../../CHANGELOG.md) for complete details.

## 🔗 Links

- [Pull Request #X](link)
- [Milestone vX.Y.Z](link)
- [Documentation](link)
```

---

## 🎯 Release Branch Strategy

### When to Use Release Branches

**Use release branches when:**
- Major version releases (v1.0.0, v2.0.0)
- Significant feature releases
- Need time to prepare/test the release
- Want to continue development on develop while preparing release
- Need to fix issues found during release preparation

**Skip release branches when:**
- Minor documentation updates
- Small patch releases
- Develop is stable and ready to release immediately
- No additional preparation needed

### Release Branch Naming

- `release/v0.2.0` - For version 0.2.0
- `release/v1.0.0` - For version 1.0.0
- Always use the `release/` prefix

### Release Branch Lifecycle

1. **Create** from develop when ready to prepare release
2. **Prepare** - Update versions, docs, fix last-minute issues
3. **Test** - Final testing, no new features
4. **Merge** to main (release)
5. **Merge** back to develop (keep changes)
6. **Delete** after successful merge

---

## 📋 Version File Management

### VERSION File

Location: `/VERSION`

```
0.2.0
```

Simple, single line with version number.

### Updating VERSION

```bash
# Update VERSION file
echo "0.2.0" > VERSION

# Commit
git add VERSION
git commit -m "chore: Bump version to v0.2.0"
```

### Reading VERSION in Scripts

```bash
# In any script
VERSION=$(cat "$PROJECT_ROOT/VERSION")
echo "Dev Toolkit v$VERSION"
```

---

## 📝 CHANGELOG.md Management

### Format

Follow [Keep a Changelog](https://keepachangelog.com/):

```markdown
# Changelog

## [Unreleased]
### Added
- New features in develop

## [0.2.0] - 2025-10-06
### Added
- 215 automated tests
- Comprehensive testing documentation

### Changed
- Updated roadmap structure

### Fixed
- dt-review help flag handling
```

### Categories

- **Added** - New features
- **Changed** - Changes to existing functionality
- **Deprecated** - Soon-to-be removed features
- **Removed** - Removed features
- **Fixed** - Bug fixes
- **Security** - Security fixes

---

## 🏷️ Git Tagging

### Creating Tags

```bash
# Annotated tag (recommended)
git tag -a v0.2.0 -m "Release v0.2.0: Testing & Reliability"

# Push tag
git push origin v0.2.0
```

### Tag Naming Convention

- `v0.2.0` - Stable release
- `v0.2.0-alpha` - Alpha release
- `v0.2.0-beta` - Beta release
- `v0.2.0-rc.1` - Release candidate

### Viewing Tags

```bash
# List all tags
git tag

# Show tag details
git show v0.2.0

# List tags with messages
git tag -n
```

---

## 🎉 GitHub Releases

### Creating Releases

**Via CLI:**
```bash
gh release create v0.2.0 \
  --title "v0.2.0 - Testing & Reliability" \
  --notes-file admin/planning/releases/v0.2.0-notes.md
```

**Via Web:**
1. Go to GitHub repository
2. Click "Releases" → "Draft a new release"
3. Choose tag: `v0.2.0`
4. Fill in release title and notes
5. Publish release

### Release Assets

For major releases, consider attaching:
- Installation script
- Documentation PDF
- Example configurations

---

## 🔄 Hotfix Process

For critical bugs in production (main):

```bash
# 1. Create hotfix branch from main
git checkout main
git checkout -b hotfix/v0.2.1

# 2. Fix the bug
# Make changes...
git add .
git commit -m "fix: Critical bug description"

# 3. Update VERSION and CHANGELOG
echo "0.2.1" > VERSION
# Update CHANGELOG.md
git add VERSION CHANGELOG.md
git commit -m "chore: Bump version to v0.2.1"

# 4. Merge to main
git checkout main
git merge hotfix/v0.2.1 --no-ff -m "Hotfix v0.2.1"
git push

# 5. Tag
git tag -a v0.2.1 -m "Hotfix v0.2.1: Fix critical bug"
git push origin v0.2.1

# 6. Merge to develop
git checkout develop
git merge hotfix/v0.2.1 --no-ff -m "Merge hotfix v0.2.1"
git push

# 7. Delete hotfix branch
git branch -d hotfix/v0.2.1

# 8. Create GitHub release
gh release create v0.2.1 \
  --title "v0.2.1 - Critical Bug Fix" \
  --notes "Fixed critical bug in [component]"
```

---

## 📊 Release History

Track releases in: `admin/planning/releases/history.md`

| Version | Date | Type | Highlights |
|---------|------|------|------------|
| v0.1.0-alpha | 2025-10-06 | Alpha | Foundation |
| v0.1.1 | 2025-10-06 | Stable | Optional Features |
| v0.2.0 | 2025-10-06 | Stable | Testing Suite |

---

## 🎯 Best Practices

### DO
- ✅ Test thoroughly before releasing
- ✅ Update all documentation
- ✅ Write clear release notes
- ✅ Use semantic versioning
- ✅ Tag releases properly
- ✅ Keep CHANGELOG.md updated
- ✅ Merge release changes back to develop

### DON'T
- ❌ Release with failing tests
- ❌ Skip version bumps
- ❌ Forget to update CHANGELOG
- ❌ Release without testing
- ❌ Force push to main
- ❌ Delete release tags
- ❌ Release on Friday (if possible)

---

## 📖 Related Documentation

- [Roadmap](../roadmap.md) - Overall project direction
- [CHANGELOG.md](../../../CHANGELOG.md) - Detailed change history
- [VERSION](../../../VERSION) - Current version number
- [Git Flow Safety](../../../docs/TESTING.md) - Testing before release

---

**This process ensures stable, well-documented releases.** 🚀
