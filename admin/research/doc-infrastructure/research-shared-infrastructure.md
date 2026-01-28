# Research: Shared Infrastructure Design

**Research Topic:** Doc Infrastructure  
**Question:** How should dt-doc-gen and dt-doc-validate share code while evolving independently?  
**Status:** ✅ Complete  
**Priority:** 🟢 Low  
**Created:** 2026-01-16  
**Completed:** 2026-01-17  
**Last Updated:** 2026-01-17

---

## 🎯 Research Question

How should dt-doc-gen and dt-doc-validate share code while evolving independently? Both commands need: path detection, dev-infra location, debug output, help formatting. However, they serve different purposes and may need independent releases.

---

## 🔍 Research Goals

- [x] Goal 1: List common functionality between commands
- [x] Goal 2: Evaluate existing lib/core/ utilities for reuse
- [x] Goal 3: Define boundary: what's shared vs command-specific
- [x] Goal 4: Document versioning strategy (monorepo-style or independent)

---

## 📚 Research Methodology

**Note:** Web search is **allowed and encouraged** for research.

**Sources:**
- [x] Source 1: Existing lib/core/ utilities in dev-toolkit
- [x] Source 2: dt-review and dt-sourcery-parse patterns
- [x] Source 3: dev-toolkit release and versioning approach
- [x] Source 4: Web search: "CLI shared library design patterns"

---

## 📊 Findings

### Finding 1: Existing Shared Library Pattern in dev-toolkit

Dev-toolkit already has a well-established shared library pattern:

**Directory Structure:**
```
lib/
├── core/
│   └── github-utils.sh     # GitHub integration (530 lines)
├── git-flow/
│   ├── hooks/
│   │   └── pre-commit
│   ├── safety.sh
│   └── utils.sh            # Git Flow utilities (577 lines)
└── sourcery/
    └── parser.sh           # Sourcery parser
```

**Key Pattern Elements:**

1. **Namespaced Function Prefixes:**
   - `gh_*` for GitHub utilities (e.g., `gh_print_status`, `gh_detect_project_info`)
   - `gf_*` for Git Flow utilities (e.g., `gf_print_status`, `gf_get_current_branch`)

2. **Color Detection:**
   ```bash
   if [[ -t 1 ]] && command -v tput >/dev/null 2>&1; then
       GH_RED='\033[0;31m'
       ...
   else
       GH_RED=''  # Graceful degradation
   fi
   ```

3. **Export Functions and Variables:**
   ```bash
   export -f gh_print_status gh_print_section gh_print_header
   export GH_RED GH_GREEN GH_YELLOW ...
   ```

**Source:** `lib/core/github-utils.sh`, `lib/git-flow/utils.sh`

**Relevance:** Provides proven pattern to follow for doc-infrastructure library.

---

### Finding 2: TOOLKIT_ROOT Detection Pattern

Commands use a consistent multi-fallback pattern to locate libraries:

```bash
# Detect toolkit installation location
if [ -n "${DT_ROOT:-}" ]; then
    TOOLKIT_ROOT="$DT_ROOT"
elif [ -f "$(dirname "${BASH_SOURCE[0]}")/../lib/sourcery/parser.sh" ]; then
    # Running from dev-toolkit directory - use local development version
    TOOLKIT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
elif [ -f "$HOME/.dev-toolkit/lib/sourcery/parser.sh" ]; then
    TOOLKIT_ROOT="$HOME/.dev-toolkit"
else
    echo "❌ Error: Cannot locate dev-toolkit installation"
    exit 1
fi

# Source utilities
source "$TOOLKIT_ROOT/lib/core/github-utils.sh"
source "$TOOLKIT_ROOT/lib/git-flow/utils.sh"
```

**Detection Priority:**
1. `DT_ROOT` environment variable (explicit override)
2. Relative to script (development mode)
3. `~/.dev-toolkit` (installed mode)

**Source:** `bin/dt-config`, `bin/dt-review`, `bin/dt-git-safety`

**Relevance:** New doc commands should use same detection pattern.

---

### Finding 3: Common Functionality Needed by Both Commands

**Analysis of shared needs:**

| Functionality | dt-doc-gen | dt-doc-validate | Shared? |
|---------------|------------|-----------------|---------|
| Color output | ✅ | ✅ | ✅ Yes |
| TTY detection | ✅ | ✅ | ✅ Yes |
| Debug mode | ✅ | ✅ | ✅ Yes |
| Help formatting | ✅ | ✅ | ✅ Yes |
| Version display | ✅ | ✅ | ✅ Yes |
| dev-infra location | ✅ | ✅ | ✅ Yes |
| Template fetching | ✅ | ❌ | ❌ No |
| Variable expansion | ✅ | ❌ | ❌ No |
| Validation rules | ❌ | ✅ | ❌ No |
| Error formatting | ❌ | ✅ | ❌ No |
| JSON output | ❌ | ✅ | ❌ No |
| Path/content detection | ❌ | ✅ | ❌ No |

**Shared Core (6 items):**
- Color output with TTY detection
- Debug/verbose mode
- Help formatting
- Version display
- dev-infra location detection
- Common error messages

**Command-Specific:**
- dt-doc-gen: Template fetching, variable expansion, mode handling
- dt-doc-validate: Validation rules, error formatting, JSON output, type detection

**Source:** Requirements analysis from Topics 1-6

**Relevance:** Defines boundary for shared vs. command-specific code.

---

### Finding 4: dev-infra Research Recommends Shared Library

The dev-infra research explicitly recommends a shared library architecture:

```
scripts/doc-gen/
├── lib/
│   ├── common.sh         # Shared utilities
│   ├── render.sh         # Template rendering
│   └── validate.sh       # Validation functions
├── templates/
│   └── [template files]
├── gen-doc.sh            # Unified entry point
└── validate-doc.sh       # Validation CLI
```

**Key Quote:**
> "Validation logic must be in shared library (`lib/validate.sh`) for reuse"
> — Constraint C-10 from dev-infra requirements

**Source:** `dev-infra/admin/research/template-doc-infrastructure/research-validation-approach.md`

**Relevance:** Confirms shared library is the right architectural choice.

---

### Finding 5: Versioning Strategy - Monorepo Style

Dev-toolkit uses a **monorepo-style versioning** approach:

- Single `VERSION` file at project root
- All commands released together
- GitHub releases include full toolkit
- Commands share same version number

**Current Version Pattern:**
- v0.2.0 released with all commands
- No independent command versioning
- Changelog tracks all changes together

**Implications for doc-infrastructure:**
- dt-doc-gen and dt-doc-validate share toolkit version
- Shared library versioned with toolkit
- No need for separate library versioning

**Source:** `VERSION` file, `CHANGELOG.md`, GitHub releases

**Relevance:** Simplifies versioning - no need for independent library version.

---

### Finding 6: Existing Duplication to Avoid

Analysis shows current code duplication in dev-toolkit:

**Duplicated print_status functions:**
- `lib/core/github-utils.sh` → `gh_print_status()`
- `lib/git-flow/utils.sh` → `gf_print_status()`
- `bin/dt-setup-sourcery` → `print_status()` (inline)

All three implementations are nearly identical:
```bash
print_status() {
    local msg_type=$1
    local message=$2
    case $msg_type in
        "ERROR")   echo -e "${RED}❌ $message${NC}" ;;
        "WARNING") echo -e "${YELLOW}⚠️  $message${NC}" ;;
        "SUCCESS") echo -e "${GREEN}✅ $message${NC}" ;;
        "INFO")    echo -e "${BLUE}ℹ️  $message${NC}" ;;
    esac
}
```

**Source:** Grep analysis across bin/ and lib/ directories

**Relevance:** Opportunity to consolidate into single shared library.

---

## 🔍 Analysis

### Key Insights

- [x] **Insight 1:** Established pattern exists - use namespaced prefixes (`dt_*`)
- [x] **Insight 2:** TOOLKIT_ROOT detection pattern should be reused exactly
- [x] **Insight 3:** Color/TTY detection duplicated - should consolidate
- [x] **Insight 4:** Monorepo versioning simplifies - no independent library versions needed
- [x] **Insight 5:** 6 shared functions identified for new library
- [x] **Insight 6:** Command-specific code should NOT be in shared library

### Proposed Architecture

```
lib/
├── core/
│   ├── github-utils.sh       # Existing
│   └── output-utils.sh       # NEW: Shared output utilities
├── doc-gen/
│   └── render.sh             # dt-doc-gen specific
├── doc-validate/
│   └── rules.sh              # dt-doc-validate specific
├── git-flow/
│   └── utils.sh              # Existing
└── sourcery/
    └── parser.sh             # Existing
```

### New Shared Library: `lib/core/output-utils.sh`

**Contents:**
```bash
# Shared output utilities for dev-toolkit
# Provides: dt_* prefixed functions

# Color setup with TTY detection
dt_setup_colors()

# Status messages
dt_print_status()    # ERROR, WARNING, SUCCESS, INFO
dt_print_header()    # Section headers
dt_print_debug()     # Debug output (when DT_DEBUG=true)

# Version/help
dt_show_version()    # Display version from VERSION file
dt_show_help_header() # Consistent help formatting

# dev-infra detection
dt_detect_dev_infra() # Find dev-infra location
```

### Boundary Definition

| Layer | Contents | Changes Independently? |
|-------|----------|------------------------|
| Shared (`lib/core/output-utils.sh`) | Color, TTY, debug, version | Rarely |
| dt-doc-gen (`lib/doc-gen/`) | Template fetching, variable expansion | Frequently |
| dt-doc-validate (`lib/doc-validate/`) | Validation rules, error formatting | Frequently |

---

## 💡 Recommendations

- [x] **Recommendation 1:** Create new `lib/core/output-utils.sh` for shared functions
- [x] **Recommendation 2:** Use `dt_*` prefix for doc-infrastructure functions
- [x] **Recommendation 3:** Reuse existing TOOLKIT_ROOT detection pattern exactly
- [x] **Recommendation 4:** Keep command-specific code in separate lib directories
- [x] **Recommendation 5:** Use monorepo versioning (all commands share toolkit version)
- [x] **Recommendation 6:** Consider future consolidation of gh_/gf_ functions into dt_

### Prototype Shared Library

```bash
#!/bin/bash

# Dev Toolkit - Shared Output Utilities
# lib/core/output-utils.sh
# Provides common output functions for all dt-* commands

# ============================================================================
# COLOR DEFINITIONS (with TTY detection)
# ============================================================================

dt_setup_colors() {
    if [[ -t 1 ]] && command -v tput >/dev/null 2>&1; then
        DT_RED='\033[0;31m'
        DT_GREEN='\033[0;32m'
        DT_YELLOW='\033[1;33m'
        DT_BLUE='\033[0;34m'
        DT_CYAN='\033[0;36m'
        DT_BOLD='\033[1m'
        DT_NC='\033[0m'
    else
        DT_RED='' DT_GREEN='' DT_YELLOW='' DT_BLUE=''
        DT_CYAN='' DT_BOLD='' DT_NC=''
    fi
}

# Auto-setup on source
dt_setup_colors

# ============================================================================
# STATUS OUTPUT
# ============================================================================

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

dt_print_header() {
    local title=$1
    echo -e "${DT_BOLD}${DT_CYAN}$title${DT_NC}"
    echo -e "${DT_CYAN}$(printf '═%.0s' $(seq 1 ${#title}))${DT_NC}"
}

dt_print_debug() {
    if [ "${DT_DEBUG:-false}" = "true" ]; then
        echo -e "${DT_CYAN}[DEBUG] $*${DT_NC}" >&2
    fi
}

# ============================================================================
# DEV-INFRA DETECTION
# ============================================================================

dt_detect_dev_infra() {
    # Priority order from Topic 1 research
    
    # 1. Explicit flag (caller provides)
    if [ -n "${DT_DEVINFRA_PATH:-}" ]; then
        echo "$DT_DEVINFRA_PATH"
        return 0
    fi
    
    # 2. Environment variable
    if [ -n "${DEVINFRA_ROOT:-}" ] && [ -d "$DEVINFRA_ROOT" ]; then
        echo "$DEVINFRA_ROOT"
        return 0
    fi
    
    # 3. Config file (dt-config)
    if [ -f "$HOME/.dev-toolkit/config.conf" ]; then
        local config_path
        config_path=$(grep "^DEVINFRA_PATH=" "$HOME/.dev-toolkit/config.conf" | cut -d= -f2)
        if [ -n "$config_path" ] && [ -d "$config_path" ]; then
            echo "$config_path"
            return 0
        fi
    fi
    
    # 4. Common local paths
    for path in "$HOME/Projects/dev-infra" "$HOME/dev-infra" "../dev-infra"; do
        if [ -d "$path/scripts/doc-gen/templates" ]; then
            echo "$path"
            return 0
        fi
    done
    
    return 1
}

# ============================================================================
# EXPORTS
# ============================================================================

export -f dt_setup_colors dt_print_status dt_print_header dt_print_debug
export -f dt_detect_dev_infra
export DT_RED DT_GREEN DT_YELLOW DT_BLUE DT_CYAN DT_BOLD DT_NC
```

---

## 📋 Requirements Discovered

### Functional Requirements

- [x] **FR-SI1:** Shared library MUST provide color output with TTY detection
- [x] **FR-SI2:** Shared library MUST provide debug output controlled by DT_DEBUG
- [x] **FR-SI3:** Shared library MUST provide dev-infra location detection
- [x] **FR-SI4:** Commands MUST use `dt_*` prefix for doc-infrastructure functions

### Non-Functional Requirements

- [x] **NFR-SI1:** Shared library MUST be source-able (not executable)
- [x] **NFR-SI2:** Shared library MUST export functions for use by commands
- [x] **NFR-SI3:** Shared library MUST gracefully degrade without colors in non-TTY

### Constraints

- [x] **C-SI1:** Follow existing TOOLKIT_ROOT detection pattern
- [x] **C-SI2:** Use monorepo versioning (no independent library version)
- [x] **C-SI3:** Command-specific code stays in command-specific lib directories

---

## 🚀 Next Steps

1. ~~Conduct research~~ ✅ Complete
2. Update requirements.md with discovered requirements
3. Create `lib/core/output-utils.sh` during implementation
4. Use shared library in dt-doc-gen and dt-doc-validate
5. Consider future consolidation of gh_/gf_ functions (optional)

---

**Last Updated:** 2026-01-17
