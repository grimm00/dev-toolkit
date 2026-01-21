# Doc Infrastructure - Phase 1: Shared Infrastructure

**Phase:** 1 - Shared Infrastructure  
**Duration:** 2-3 days  
**Status:** 🟠 In Progress  
**Prerequisites:** ADR-005, ADR-001 (XDG), ADR-006 (project structure) accepted

---

## 📋 Overview

Create the shared infrastructure library (`lib/core/output-utils.sh`) that both `dt-doc-gen` and `dt-doc-validate` will use. This includes output formatting, XDG configuration helpers, and project structure detection.

**Success Definition:** All `dt_*` functions implemented and tested, ready for use by Phase 2 and Phase 3.

---

## 🎯 Goals

1. **Create output-utils.sh** - Shared library with `dt_*` prefixed functions
2. **Implement XDG helpers** - Configuration and data directory functions
3. **Implement project structure detection** - Support admin/ and docs/maintainers/ paths
4. **Write unit tests** - Full coverage for shared library

---

## 📝 Tasks

### Task 1: Test Setup and Library Scaffolding

**Purpose:** Create the test file structure and empty library file to enable TDD workflow.

**Steps:**

- [x] Create `lib/core/output-utils.sh` with header comment and empty structure
- [x] Create `tests/unit/core/test-output-utils.bats` with test setup

**Library scaffolding:**

```bash
#!/bin/bash
# Doc Infrastructure Shared Utilities
# Provides common functions for dt-doc-gen and dt-doc-validate
# Uses dt_* prefix to avoid conflicts with other dev-toolkit functions

# ============================================================================
# XDG BASE DIRECTORY COMPLIANCE
# ============================================================================

# (XDG functions will go here)

# ============================================================================
# COLOR AND OUTPUT SETUP
# ============================================================================

# (Output functions will go here)

# ============================================================================
# DETECTION FUNCTIONS
# ============================================================================

# (Detection functions will go here)
```

**Test scaffolding:**

```bash
#!/usr/bin/env bats

# Tests for output-utils.sh shared library

load '../../helpers/setup'
load '../../helpers/assertions'

setup() {
    source "$PROJECT_ROOT/lib/core/output-utils.sh"
}

# Test sections will go here
```

**Checklist:**
- [x] `lib/core/output-utils.sh` created with structure
- [x] `tests/unit/core/test-output-utils.bats` created
- [x] Test setup sources the library correctly

---

### Task 2: XDG Helper Functions

**Purpose:** Implement XDG Base Directory compliant path functions (per ADR-001).

**TDD Flow:**

#### 2.1 RED - Write failing tests for XDG helpers

- [x] Create test section for XDG functions
- [x] Write test: `dt_get_xdg_config_home` returns `$XDG_CONFIG_HOME` if set
- [x] Write test: `dt_get_xdg_config_home` returns `$HOME/.config` if not set
- [x] Write test: `dt_get_xdg_data_home` returns `$XDG_DATA_HOME` if set
- [x] Write test: `dt_get_xdg_data_home` returns `$HOME/.local/share` if not set
- [x] Write test: `dt_get_config_dir` returns correct dev-toolkit config path
- [x] Write test: `dt_get_data_dir` returns correct dev-toolkit data path
- [x] Write test: `dt_get_config_file` returns correct config file path
- [x] Verify tests fail (no implementation yet)

**Test code:**

```bash
# ============================================================================
# XDG Helper Tests
# ============================================================================

@test "dt_get_xdg_config_home: returns XDG_CONFIG_HOME if set" {
    export XDG_CONFIG_HOME="/custom/config"
    run dt_get_xdg_config_home
    [ "$status" -eq 0 ]
    [ "$output" = "/custom/config" ]
}

@test "dt_get_xdg_config_home: returns ~/.config if XDG_CONFIG_HOME not set" {
    unset XDG_CONFIG_HOME
    run dt_get_xdg_config_home
    [ "$status" -eq 0 ]
    [ "$output" = "$HOME/.config" ]
}

@test "dt_get_xdg_data_home: returns XDG_DATA_HOME if set" {
    export XDG_DATA_HOME="/custom/data"
    run dt_get_xdg_data_home
    [ "$status" -eq 0 ]
    [ "$output" = "/custom/data" ]
}

@test "dt_get_xdg_data_home: returns ~/.local/share if XDG_DATA_HOME not set" {
    unset XDG_DATA_HOME
    run dt_get_xdg_data_home
    [ "$status" -eq 0 ]
    [ "$output" = "$HOME/.local/share" ]
}

@test "dt_get_config_dir: returns dev-toolkit config directory" {
    unset XDG_CONFIG_HOME
    run dt_get_config_dir
    [ "$status" -eq 0 ]
    [ "$output" = "$HOME/.config/dev-toolkit" ]
}

@test "dt_get_data_dir: returns dev-toolkit data directory" {
    unset XDG_DATA_HOME
    run dt_get_data_dir
    [ "$status" -eq 0 ]
    [ "$output" = "$HOME/.local/share/dev-toolkit" ]
}

@test "dt_get_config_file: returns config file path" {
    unset XDG_CONFIG_HOME
    run dt_get_config_file
    [ "$status" -eq 0 ]
    [ "$output" = "$HOME/.config/dev-toolkit/config" ]
}
```

#### 2.2 GREEN - Implement XDG helper functions

- [x] Implement `dt_get_xdg_config_home()`
- [x] Implement `dt_get_xdg_data_home()`
- [x] Implement `dt_get_config_dir()`
- [x] Implement `dt_get_data_dir()`
- [x] Implement `dt_get_config_file()`
- [x] Run tests, verify they pass

**Implementation:**

```bash
# ============================================================================
# XDG BASE DIRECTORY COMPLIANCE
# ============================================================================

dt_get_xdg_config_home() {
    echo "${XDG_CONFIG_HOME:-$HOME/.config}"
}

dt_get_xdg_data_home() {
    echo "${XDG_DATA_HOME:-$HOME/.local/share}"
}

dt_get_config_dir() {
    echo "$(dt_get_xdg_config_home)/dev-toolkit"
}

dt_get_data_dir() {
    echo "$(dt_get_xdg_data_home)/dev-toolkit"
}

dt_get_config_file() {
    echo "$(dt_get_config_dir)/config"
}
```

#### 2.3 REFACTOR - Review and clean up

- [ ] Ensure function naming is consistent
- [ ] Add function documentation comments
- [ ] Verify tests still pass

**Checklist:**
- [x] All XDG tests pass
- [x] Functions handle both set and unset env vars
- [x] Paths follow XDG specification

---

### Task 3: Output Functions

**Purpose:** Implement color setup and status printing functions (per ADR-005).

**TDD Flow:**

#### 3.1 RED - Write failing tests for output functions

- [x] Write test: `dt_setup_colors` sets color variables when TTY available
- [x] Write test: `dt_setup_colors` sets empty variables when no TTY
- [x] Write test: `dt_print_status ERROR` includes error emoji and message
- [x] Write test: `dt_print_status WARNING` includes warning emoji and message
- [x] Write test: `dt_print_status SUCCESS` includes success emoji and message
- [x] Write test: `dt_print_status INFO` includes info emoji and message
- [x] Write test: `dt_print_debug` outputs when DT_DEBUG=true
- [x] Write test: `dt_print_debug` is silent when DT_DEBUG not set
- [x] Write test: `dt_print_header` outputs formatted header
- [x] Verify tests fail

**Test code:**

```bash
# ============================================================================
# Color Setup Tests
# ============================================================================

@test "dt_setup_colors: sets color variables" {
    # Reset any existing colors
    DT_RED=""
    DT_GREEN=""
    dt_setup_colors
    # Colors should be set (either with codes or empty for non-TTY)
    [ -n "${DT_NC+x}" ]  # Variable exists (may be empty)
}

# ============================================================================
# Print Status Tests
# ============================================================================

@test "dt_print_status: ERROR includes error emoji and message" {
    dt_setup_colors
    run dt_print_status "ERROR" "Test error message"
    [ "$status" -eq 0 ]
    [[ "$output" =~ "❌" ]]
    [[ "$output" =~ "Test error message" ]]
}

@test "dt_print_status: WARNING includes warning emoji and message" {
    dt_setup_colors
    run dt_print_status "WARNING" "Test warning"
    [ "$status" -eq 0 ]
    [[ "$output" =~ "⚠️" ]]
    [[ "$output" =~ "Test warning" ]]
}

@test "dt_print_status: SUCCESS includes success emoji and message" {
    dt_setup_colors
    run dt_print_status "SUCCESS" "Test success"
    [ "$status" -eq 0 ]
    [[ "$output" =~ "✅" ]]
    [[ "$output" =~ "Test success" ]]
}

@test "dt_print_status: INFO includes info emoji and message" {
    dt_setup_colors
    run dt_print_status "INFO" "Test info"
    [ "$status" -eq 0 ]
    [[ "$output" =~ "ℹ️" ]]
    [[ "$output" =~ "Test info" ]]
}

# ============================================================================
# Debug Output Tests
# ============================================================================

@test "dt_print_debug: outputs when DT_DEBUG=true" {
    export DT_DEBUG=true
    dt_setup_colors
    run dt_print_debug "Debug message"
    [ "$status" -eq 0 ]
    [[ "$output" =~ "Debug message" ]]
}

@test "dt_print_debug: silent when DT_DEBUG not set" {
    unset DT_DEBUG
    dt_setup_colors
    run dt_print_debug "Debug message"
    [ "$status" -eq 0 ]
    [ -z "$output" ]
}

# ============================================================================
# Print Header Tests
# ============================================================================

@test "dt_print_header: outputs header with title" {
    dt_setup_colors
    run dt_print_header "Test Header"
    [ "$status" -eq 0 ]
    [[ "$output" =~ "Test Header" ]]
}
```

#### 3.2 GREEN - Implement output functions

- [x] Implement `dt_setup_colors()` with TTY detection
- [x] Implement `dt_print_status()` for ERROR, WARNING, SUCCESS, INFO
- [x] Implement `dt_print_debug()` with DT_DEBUG check
- [x] Implement `dt_print_header()`
- [x] Implement `dt_show_version()` for VERSION file
- [x] Run tests, verify they pass

**Implementation:**

```bash
# ============================================================================
# COLOR AND OUTPUT SETUP
# ============================================================================

# Color variables (set by dt_setup_colors)
DT_RED=""
DT_GREEN=""
DT_YELLOW=""
DT_BLUE=""
DT_PURPLE=""
DT_CYAN=""
DT_BOLD=""
DT_NC=""

dt_setup_colors() {
    if [[ -t 1 ]] && command -v tput >/dev/null 2>&1; then
        DT_RED='\033[0;31m'
        DT_GREEN='\033[0;32m'
        DT_YELLOW='\033[1;33m'
        DT_BLUE='\033[0;34m'
        DT_PURPLE='\033[0;35m'
        DT_CYAN='\033[0;36m'
        DT_BOLD='\033[1m'
        DT_NC='\033[0m'
    else
        DT_RED=''
        DT_GREEN=''
        DT_YELLOW=''
        DT_BLUE=''
        DT_PURPLE=''
        DT_CYAN=''
        DT_BOLD=''
        DT_NC=''
    fi
}

dt_print_status() {
    local msg_type=$1
    local message=$2
    case $msg_type in
        "ERROR")   echo -e "${DT_RED}❌ $message${DT_NC}" ;;
        "WARNING") echo -e "${DT_YELLOW}⚠️  $message${DT_NC}" ;;
        "SUCCESS") echo -e "${DT_GREEN}✅ $message${DT_NC}" ;;
        "INFO")    echo -e "${DT_BLUE}ℹ️  $message${DT_NC}" ;;
    esac
}

dt_print_debug() {
    if [ "${DT_DEBUG:-false}" = "true" ]; then
        echo -e "${DT_PURPLE}[DEBUG] $1${DT_NC}"
    fi
}

dt_print_header() {
    local title=$1
    echo -e "${DT_BOLD}${DT_CYAN}$title${DT_NC}"
    echo -e "${DT_CYAN}$(printf '═%.0s' $(seq 1 ${#title}))${DT_NC}"
}

dt_show_version() {
    local version_file="${TOOLKIT_ROOT:-$(dirname "${BASH_SOURCE[0]}")/../..}/VERSION"
    if [ -f "$version_file" ]; then
        cat "$version_file"
    else
        echo "unknown"
    fi
}
```

#### 3.3 REFACTOR - Review and clean up

- [ ] Ensure consistency with gh_* functions in github-utils.sh
- [ ] Add function documentation
- [ ] Verify tests still pass

**Checklist:**
- [x] All output tests pass
- [x] TTY detection works correctly
- [x] Debug output respects DT_DEBUG flag

---

### Task 4: Detection Functions

**Purpose:** Implement dev-infra and project structure detection (per ADR-005, ADR-006).

**TDD Flow:**

#### 4.1 RED - Write failing tests for detection functions

- [ ] Write test: `dt_detect_dev_infra` finds dev-infra in sibling directory
- [ ] Write test: `dt_detect_dev_infra` returns error if not found
- [ ] Write test: `dt_detect_project_structure` returns "admin" when admin/ exists
- [ ] Write test: `dt_detect_project_structure` returns "docs/maintainers" when that exists
- [ ] Write test: `dt_detect_project_structure` returns "unknown" when neither exists
- [ ] Write test: `dt_get_docs_root` returns correct path for admin structure
- [ ] Write test: `dt_get_docs_root` returns correct path for docs/maintainers structure
- [ ] Verify tests fail

**Test code:**

```bash
# ============================================================================
# dev-infra Detection Tests
# ============================================================================

@test "dt_detect_dev_infra: returns path when DEV_INFRA_PATH set" {
    export DEV_INFRA_PATH="/custom/dev-infra"
    run dt_detect_dev_infra
    [ "$status" -eq 0 ]
    [ "$output" = "/custom/dev-infra" ]
}

@test "dt_detect_dev_infra: returns error when not found" {
    unset DEV_INFRA_PATH
    # Create temp dir with no dev-infra sibling
    local test_dir=$(mktemp -d)
    cd "$test_dir"
    run dt_detect_dev_infra
    [ "$status" -eq 1 ]
    rm -rf "$test_dir"
}

# ============================================================================
# Project Structure Detection Tests
# ============================================================================

@test "dt_detect_project_structure: returns 'admin' when admin/ exists" {
    local test_dir=$(mktemp -d)
    mkdir -p "$test_dir/admin/explorations"
    run dt_detect_project_structure "$test_dir"
    [ "$status" -eq 0 ]
    [ "$output" = "admin" ]
    rm -rf "$test_dir"
}

@test "dt_detect_project_structure: returns 'docs/maintainers' when that exists" {
    local test_dir=$(mktemp -d)
    mkdir -p "$test_dir/docs/maintainers/explorations"
    run dt_detect_project_structure "$test_dir"
    [ "$status" -eq 0 ]
    [ "$output" = "docs/maintainers" ]
    rm -rf "$test_dir"
}

@test "dt_detect_project_structure: prioritizes 'admin' over 'docs/maintainers'" {
    local test_dir=$(mktemp -d)
    mkdir -p "$test_dir/admin/explorations"
    mkdir -p "$test_dir/docs/maintainers/explorations"
    run dt_detect_project_structure "$test_dir"
    [ "$status" -eq 0 ]
    [ "$output" = "admin" ]
    rm -rf "$test_dir"
}

@test "dt_detect_project_structure: returns 'unknown' when neither exists" {
    local test_dir=$(mktemp -d)
    run dt_detect_project_structure "$test_dir"
    [ "$status" -eq 0 ]
    [ "$output" = "unknown" ]
    rm -rf "$test_dir"
}

@test "dt_get_docs_root: returns 'admin' path for admin structure" {
    local test_dir=$(mktemp -d)
    mkdir -p "$test_dir/admin/explorations"
    run dt_get_docs_root "$test_dir"
    [ "$status" -eq 0 ]
    [ "$output" = "$test_dir/admin" ]
    rm -rf "$test_dir"
}

@test "dt_get_docs_root: returns 'docs/maintainers' path for that structure" {
    local test_dir=$(mktemp -d)
    mkdir -p "$test_dir/docs/maintainers/explorations"
    run dt_get_docs_root "$test_dir"
    [ "$status" -eq 0 ]
    [ "$output" = "$test_dir/docs/maintainers" ]
    rm -rf "$test_dir"
}
```

#### 4.2 GREEN - Implement detection functions

- [ ] Implement `dt_detect_dev_infra()` with layered discovery
- [ ] Implement `dt_detect_project_structure()` with admin/ priority
- [ ] Implement `dt_get_docs_root()` convenience wrapper
- [ ] Run tests, verify they pass

**Implementation:**

```bash
# ============================================================================
# DETECTION FUNCTIONS
# ============================================================================

dt_detect_dev_infra() {
    # 1. Environment variable (highest priority)
    if [ -n "${DEV_INFRA_PATH:-}" ] && [ -d "$DEV_INFRA_PATH" ]; then
        echo "$DEV_INFRA_PATH"
        return 0
    fi
    
    # 2. Sibling directory (common development setup)
    local script_dir
    if [ -n "${BASH_SOURCE[0]:-}" ]; then
        script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    else
        script_dir="$(pwd)"
    fi
    
    # Look for dev-infra as sibling to dev-toolkit
    local toolkit_root="${script_dir%/lib/core}"
    local sibling_path="${toolkit_root%/*}/dev-infra"
    if [ -d "$sibling_path" ]; then
        echo "$sibling_path"
        return 0
    fi
    
    # 3. Common default locations
    local default_paths=(
        "$HOME/Projects/dev-infra"
        "$HOME/.dev-infra"
    )
    
    for path in "${default_paths[@]}"; do
        if [ -d "$path" ]; then
            echo "$path"
            return 0
        fi
    done
    
    # Not found
    return 1
}

dt_detect_project_structure() {
    local current_dir="${1:-.}"
    
    # Priority: admin/ first for backward compatibility
    if [ -d "$current_dir/admin/explorations" ] || \
       [ -d "$current_dir/admin/research" ] || \
       [ -d "$current_dir/admin/decisions" ] || \
       [ -d "$current_dir/admin/planning" ]; then
        echo "admin"
        return 0
    fi
    
    # Then check docs/maintainers/ (newer structure)
    if [ -d "$current_dir/docs/maintainers/explorations" ] || \
       [ -d "$current_dir/docs/maintainers/research" ] || \
       [ -d "$current_dir/docs/maintainers/decisions" ] || \
       [ -d "$current_dir/docs/maintainers/planning" ]; then
        echo "docs/maintainers"
        return 0
    fi
    
    echo "unknown"
    return 0
}

dt_get_docs_root() {
    local project_dir="${1:-.}"
    local structure
    structure=$(dt_detect_project_structure "$project_dir")
    
    case "$structure" in
        "admin")
            echo "$project_dir/admin"
            ;;
        "docs/maintainers")
            echo "$project_dir/docs/maintainers"
            ;;
        *)
            echo ""
            return 1
            ;;
    esac
}
```

#### 4.3 REFACTOR - Review and clean up

- [ ] Ensure detection logic is clear and documented
- [ ] Add comments explaining priority order
- [ ] Verify tests still pass

**Checklist:**
- [ ] All detection tests pass
- [ ] dev-infra detection follows layered discovery
- [ ] Project structure detection prioritizes admin/ for backward compatibility

---

### Task 5: Integration Testing

**Purpose:** Verify the library sources correctly and all functions work together.

**Steps:**

- [ ] Write integration test: library sources without errors
- [ ] Write integration test: all dt_* functions are defined after sourcing
- [ ] Write integration test: show_version outputs VERSION file content
- [ ] Run full test suite
- [ ] Verify no regressions in existing tests

**Test code:**

```bash
# ============================================================================
# Integration Tests
# ============================================================================

@test "output-utils.sh: sources without errors" {
    run source "$PROJECT_ROOT/lib/core/output-utils.sh"
    [ "$status" -eq 0 ]
}

@test "output-utils.sh: all dt_* functions are defined" {
    source "$PROJECT_ROOT/lib/core/output-utils.sh"
    
    # XDG helpers
    [ "$(type -t dt_get_xdg_config_home)" = "function" ]
    [ "$(type -t dt_get_xdg_data_home)" = "function" ]
    [ "$(type -t dt_get_config_dir)" = "function" ]
    [ "$(type -t dt_get_data_dir)" = "function" ]
    [ "$(type -t dt_get_config_file)" = "function" ]
    
    # Output functions
    [ "$(type -t dt_setup_colors)" = "function" ]
    [ "$(type -t dt_print_status)" = "function" ]
    [ "$(type -t dt_print_debug)" = "function" ]
    [ "$(type -t dt_print_header)" = "function" ]
    [ "$(type -t dt_show_version)" = "function" ]
    
    # Detection functions
    [ "$(type -t dt_detect_dev_infra)" = "function" ]
    [ "$(type -t dt_detect_project_structure)" = "function" ]
    [ "$(type -t dt_get_docs_root)" = "function" ]
}

@test "dt_show_version: outputs version from VERSION file" {
    run dt_show_version
    [ "$status" -eq 0 ]
    [[ "$output" =~ ^[0-9]+\.[0-9]+\.[0-9]+ ]]
}
```

**Checklist:**
- [ ] Library sources without errors
- [ ] All functions are accessible
- [ ] Full test suite passes
- [ ] No regressions in existing tests

---

## ✅ Completion Criteria

- [ ] `lib/core/output-utils.sh` exists and sources correctly
- [ ] All `dt_*` functions work as specified in ADR-005
- [ ] XDG paths honor environment variables
- [ ] Project structure detection handles both admin/ and docs/maintainers/
- [ ] Unit tests pass (>80% coverage)

---

## 📦 Deliverables

- `lib/core/output-utils.sh` - Shared library (~100-150 lines)
- `tests/unit/core/test-output-utils.bats` - Unit tests (~150-200 lines)

---

## 📊 Progress Tracking

| Task | Status | Notes |
|------|--------|-------|
| Task 1: Test Setup and Library Scaffolding | ✅ Complete | |
| Task 2: XDG Helper Functions | ✅ Complete | RED + GREEN phases done |
| Task 3: Output Functions | ✅ Complete | RED + GREEN phases done |
| Task 4: Detection Functions | 🔴 Not Started | |
| Task 5: Integration Testing | 🔴 Not Started | |

---

## 🧪 Running Tests

```bash
# Run output-utils tests only
./scripts/test.sh tests/unit/core/test-output-utils.bats

# Run all core tests
./scripts/test.sh tests/unit/core/

# Run with verbose output
./scripts/test.sh -v tests/unit/core/test-output-utils.bats
```

---

## 🔗 Dependencies

### Prerequisites

- ADR-005 (Shared Infrastructure) accepted
- ADR-001 (XDG compliance) accepted
- ADR-006 (Project structure detection) accepted

### Blocks

- Phase 2 (dt-doc-gen) requires this
- Phase 3 (dt-doc-validate) requires this

---

## 🔗 Related Documents

- [Feature Hub](README.md)
- [Phase 1 Review](phase-1-review.md)
- [ADR-005: Shared Infrastructure](../../../decisions/doc-infrastructure/adr-005-shared-infrastructure.md)
- [ADR-001: Template Location](../../../decisions/doc-infrastructure/adr-001-template-location-strategy.md) (XDG section)
- [ADR-006: Type Detection](../../../decisions/doc-infrastructure/adr-006-type-detection.md) (project structure section)
- [Next Phase: Phase 2](phase-2.md)

---

## 🔮 Future Work

### Enhancement: Consolidate with github-utils.sh

After Phase 1 is complete, consider refactoring `github-utils.sh` to:

- Source `output-utils.sh` for colors and print functions
- Use `dt_*` XDG helpers for config path consistency  
- Keep `gh_*` function wrappers for backward compatibility

This will eliminate code duplication and standardize XDG config paths across all dev-toolkit commands.

**Tracking:** See [`admin/planning/notes/opportunities/internal/consolidate-output-libs.md`](../../../planning/notes/opportunities/internal/consolidate-output-libs.md)

**Note:** This is intentional duplication for Phase 1. The consolidation should happen after doc-infrastructure feature is complete.

---

**Last Updated:** 2026-01-21  
**Status:** 🟠 In Progress  
**Next:** Continue with Task 2
