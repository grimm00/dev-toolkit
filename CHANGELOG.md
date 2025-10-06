# Changelog

All notable changes to the Dev Toolkit project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.1.0-alpha] - 2025-10-06

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
- Automated testing suite
- Parser improvements to extract overall comments
