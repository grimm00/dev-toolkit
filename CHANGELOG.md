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

## [Unreleased]

### Planned
- Additional Git Flow workflow commands
- Priority matrix helper tools
- Enhanced GitHub API batch operations
- Automated testing suite
- Extended documentation and guides
