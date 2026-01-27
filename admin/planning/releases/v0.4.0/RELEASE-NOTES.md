# Release Notes - v0.4.0

**Version:** v0.4.0  
**Release Date:** 2026-01-27  
**Status:** 🔴 Draft - Needs Review

---

## 🎉 Highlights

This release introduces **dt-workflow**, a unified command for orchestrating exploration, research, and decision workflows. It also includes document infrastructure improvements with `dt-doc-gen` and `dt-doc-validate` commands.

**Key Features:**
- 🔧 **dt-workflow** - Unified workflow orchestration with context injection
- 📄 **dt-doc-gen** - Template-based document generation
- ✅ **dt-doc-validate** - Document validation with L1/L2/L3 levels
- 🎯 **Model Recommendations** - AI model suggestions per workflow type
- 📊 **Context Profiles** - Configurable context injection levels

---

## ✨ New Features

### dt-workflow Command

The flagship feature of v0.4.0 - a unified command for managing exploration→research→decision workflows.

**Capabilities:**
- Three workflow modes: `explore`, `research`, `decision`
- Context injection with START/MIDDLE/END ordering
- Interactive mode for AI-assisted workflows
- Validation mode for pre-flight checks
- Workflow chaining for seamless transitions

**Example:**

```bash
# Start an exploration
dt-workflow explore authentication --interactive

# Chain to research
dt-workflow research authentication --from-explore

# Make a decision
dt-workflow decision authentication --from-research

# Preview without creating files
dt-workflow explore new-feature --dry-run
```

### Model Recommendations

Intelligent AI model suggestions based on workflow type:

```bash
dt-workflow explore topic
# Recommends: claude-3-5-sonnet (creative exploration)

dt-workflow research topic  
# Recommends: claude-3-opus (deep analysis)

dt-workflow decision topic
# Recommends: claude-3-5-sonnet (balanced judgment)
```

### Context Profiles

Configurable context injection levels:

```bash
# Full context (all files, all sections)
dt-workflow explore topic --profile full

# Default context (balanced)
dt-workflow explore topic --profile default

# Minimal context (essential only)
dt-workflow explore topic --profile minimal
```

### Document Infrastructure

New commands for document management:

```bash
# Generate documents from templates
dt-doc-gen exploration my-topic

# Validate document structure
dt-doc-validate admin/explorations/my-topic/
```

---

## 🔧 Improvements

- **Workflow Commands** - Enhanced `/pr-validation` with development environment setup
- **Installation Handling** - Added installation verification to `/release-prep`
- **In-line Fixes** - New threshold-based approach for quick fixes during PR validation
- **Test Reliability** - Relaxed performance test thresholds for CI stability

---

## 🐛 Bug Fixes

- Relaxed performance test thresholds to reduce CI flakiness (PR #37)
- Strengthened model recommendation tests with specific assertions (PR #36)
- Fixed documentation inconsistencies (PR #35)

---

## 📚 Documentation

- **Manual Testing Guide** - Comprehensive scenarios for all 4 phases
- **6 ADRs** - Architecture decisions for dt-workflow
- **5 Patterns** - Workflow patterns in pattern library
- **Fix Tracking** - Structured Sourcery feedback management

---

## ⚠️ Breaking Changes

None in this release.

---

## 🔄 Migration Guide

No migration required. New commands are additive.

**To use the new commands:**

```bash
# Update your installation
cd /path/to/dev-toolkit
git pull
./install.sh

# Verify new commands
dt-workflow --version
dt-doc-gen --help
dt-doc-validate --help
```

---

## 📊 Statistics

| Metric | Value |
|--------|-------|
| PRs Merged | 9 |
| Commits | 162 |
| New Commands | 3 |
| Tests Added | 93+ |
| ADRs Created | 6 |

---

## 🙏 Acknowledgments

Thanks to all contributors and the AI assistants that helped develop and test this release!

---

## 📋 Deferred Issues

The following non-critical issues are tracked for future improvement:

| Category | Count | Priority |
|----------|-------|----------|
| Code quality improvements | 2 | MEDIUM |
| Minor enhancements | 7 | LOW |

See [Fix Tracking](../../features/dt-workflow/fix/README.md) for details.

---

**Full Changelog:** [v0.3.0...v0.4.0](https://github.com/grimm00/dev-toolkit/compare/v0.3.0...v0.4.0)
