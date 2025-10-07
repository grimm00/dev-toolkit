# Changelog

All notable changes to the Dev Toolkit project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.2.1] - 2025-10-07

### Added
- **Overall Comments Support** - `dt-sourcery-parse` now captures high-level Sourcery feedback
- **Enhanced dt-review** - Automatic Overall Comments detection with smart preview
- **Comprehensive Testing** - 6 new unit tests for Overall Comments functionality
- **Real Data Validation** - Tested with actual Sourcery reviews

### Enhanced
- **dt-sourcery-parse** - Now extracts both individual comments and Overall Comments sections
- **dt-review** - Smart detection and preview of Overall Comments when present
- **Installer** - Updated to include dt-review command in available commands list
- **Documentation** - Comprehensive feature planning and implementation docs

### Fixed
- **CI Documentation Check** - Updated markdown link checker config to handle planning docs
- **Link Checker** - Added ignore patterns for relative markdown links in planning directories

### Technical Details
- **New Function**: `extract_overall_comments()` - Detects and extracts Overall Comments sections
- **Enhanced Output**: Summary now shows "Total Individual Comments: X + Overall Comments"
- **Backward Compatibility**: All existing functionality preserved
- **Test Coverage**: 6/6 unit tests passing for Overall Comments functionality

### Impact
- **Complete Review Analysis** - Users now get both individual and high-level feedback
- **Better Decision Making** - Overall Comments provide strategic insights
- **Enhanced Workflow** - dt-review automatically highlights valuable feedback
- **Improved User Experience** - Smart detection with contextual messages

## [0.2.0] - 2025-10-06

### Added
- **Core Libraries**
  - `lib/core/github-utils.sh` - GitHub CLI utilities with project auto-detection
  - `lib/git-flow/utils.sh` - Git Flow workflow utilities
  - `lib/git-flow/safety.sh` - Automated Git Flow safety checks
  - `lib/sourcery/parser.sh` - Sourcery AI review parser

- **Command Wrappers**
  - `dt-sourcery-parse` - Parse Sourcery reviews from GitHub PRs
  - `dt-git-safety` - Run Git Flow safety checks
  - `dt-config` - Configuration management tool

- **Configuration**
  - Support for both global (`~/.dev-toolkit/config`) and project-local (`.dev-toolkit.conf`) configuration
  - Example configuration file in `config/config.example`
  - Environment variable overrides for all settings

- **Installation**
  - `install.sh` - Automated installation script with global/local options
  - Symlink creation for easy command access
  - Dependency checking and validation

### Features
- **Project-Agnostic Design**: Auto-detects project information from git remotes
- **Portable**: Works across any git repository without modification
- **Modular**: Use individual tools or the full suite
- **Zero Core Dependencies**: Core features work with just bash and git
- **AI-Friendly**: Designed for seamless AI assistant integration

### Documentation
- Comprehensive README with usage examples
- Inline documentation in all scripts
- Configuration examples and templates

### Origin
- Extracted and adapted from Pokehub (grimm00/pokedex) and REPO-Magic projects
- Made fully portable and project-agnostic
- Enhanced with improved error handling and user feedback

---

## [0.1.1] - 2025-10-06

### Added
- **Documentation**
  - `docs/OPTIONAL-FEATURES.md` - Comprehensive guide explaining core vs optional features (247 lines)
  - `docs/troubleshooting/sourcery-parser-no-comments.md` - Focused troubleshooting guide for parser limitations (223 lines)
  - Enhanced `docs/SOURCERY-SETUP.md` with prominent rate limit warnings

- **Admin Structure**
  - `admin/planning/features/` - New feature tracking structure
  - `admin/planning/features/optional-sourcery/feature-plan.md` - Complete feature planning document (302 lines)
  - `admin/planning/features/optional-sourcery/phase-1.md` - Phase tracking with implementation notes (147 lines)
  - `admin/planning/features/README.md` - Feature workflow documentation

### Changed
- **README.md** - Added ✅ Core vs 🔌 Optional categorization throughout
  - Clear visual indicators for features requiring external services
  - Reorganized documentation section with categories (User Guides, Troubleshooting, Project Documentation)
  - Core features section showing what works immediately without setup

- **bin/dt-setup-sourcery** - Added upfront rate limit information
  - Shows "Sourcery is Optional" messaging
  - Displays rate limit info (500k diff chars/week) before installation
  - Provides graceful exit option (Ctrl+C)
  - Links to documentation for more details

- **lib/sourcery/parser.sh** - Improved error messages
  - Reminds users that Sourcery is optional when errors occur
  - Shows core features that work without Sourcery
  - Links to OPTIONAL-FEATURES.md guide

- **admin/planning/roadmap.md** - Updated to reflect v0.1.0-alpha completion and v0.1.1 progress

### Improved
- **Documentation Structure** - Moved from monolithic to focused docs
  - `common-issues.md` now links to focused troubleshooting guides
  - Easier to find specific issues
  - Better searchability and maintainability

### Philosophy
- Emphasized core-first design: toolkit should be useful immediately without external services
- Made it clear that Sourcery is optional and all core features work independently
- Transparent about rate limits and limitations

---

## [Unreleased]

### Planned
- Additional Git Flow workflow commands
- Priority matrix helper tools
- Enhanced GitHub API batch operations
- Parser improvements to extract overall comments

---

## [0.2.0] - 2025-10-06

### Added
- **Testing Suite** (215 tests, < 15 second execution)
  - `bats-core` testing framework integration
  - 144 unit tests covering all core utilities
  - 71 integration tests for all commands
  - Test helpers for mocking, assertions, and setup
  - CI/CD test integration in GitHub Actions

- **New Command**
  - `dt-review` - Convenient wrapper for `dt-sourcery-parse` with automatic formatting and output to `admin/feedback/sourcery/pr<NUMBER>.md`

- **Test Coverage**
  - `tests/unit/core/test-github-utils-*.bats` - 94 tests for github-utils.sh
  - `tests/unit/git-flow/test-git-flow-*.bats` - 45 tests for git-flow utilities
  - `tests/integration/test-dt-*.bats` - 71 tests for all commands
  - `tests/helpers/` - Reusable test helpers (setup, mocks, assertions)

- **Documentation** (2,800+ lines)
  - `docs/TESTING.md` (897 lines) - Comprehensive testing guide
  - `docs/troubleshooting/testing-issues.md` (717 lines) - Testing troubleshooting
  - `admin/planning/notes/demystifying-executables.md` (217 lines) - Key design insights
  - `admin/planning/features/testing-suite/` - Complete phase planning (5 documents, 2,700+ lines)
  - `admin/planning/releases/` - Release process documentation (3 documents, 1,450+ lines)

### Fixed
- **dt-review** - Help flag handling (`--help` was failing with "invalid number" error)
- **dt-setup-sourcery** - ShellCheck warnings (SC2034: unused variables)
- **Test Infrastructure** - Temporary directory cleanup and test isolation issues

### Changed
- **CI/CD Workflow** - Only triggers on PRs and main pushes (not develop pushes)
  - Reduces unnecessary CI runs
  - Maintains quality gates where they matter
  - Standard Git Flow pattern

### Improved
- **Code Quality** - Addressed 17 Sourcery AI suggestions across 4 PRs
  - PR #6: 3 suggestions (setup issues)
  - PR #8: 10 suggestions (edge cases) - All addressed
  - PR #9: 4 suggestions (edge cases) - All addressed
  - PR #10: 3 suggestions (optional enhancements) - Deferred to v0.2.1

- **Testing Patterns** - Established reusable patterns for future development
  - Dynamic test creation over static fixtures
  - Function mocking with `export -f`
  - Interface testing for optional features
  - Comprehensive edge case coverage

### Impact
- **High Confidence** - 215 tests provide safety net for changes
- **Regression Prevention** - Automated detection of breaking changes
- **Safe Refactoring** - Can confidently improve code
- **Clear Patterns** - Established testing approach for future features

### Statistics
- **Tests:** 215 (100% passing)
- **Execution Time:** < 15 seconds
- **Unit Tests:** 144
- **Integration Tests:** 71
- **Test Files:** 11
- **Documentation:** 2,800+ lines
- **PRs Merged:** 4 (#6, #8, #9, #10)
