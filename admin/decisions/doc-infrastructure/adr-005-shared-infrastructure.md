# ADR-005: Shared Infrastructure Pattern

**Status:** ✅ Accepted  
**Created:** 2026-01-20  
**Last Updated:** 2026-01-20

---

## Context

dt-doc-gen and dt-doc-validate share common functionality: color output, TTY detection, debug mode, help formatting, version display, and dev-infra location detection. Both commands should follow consistent patterns while maintaining independent, focused codebases.

**Key Question:** How should dt-doc-gen and dt-doc-validate share code while evolving independently?

**Related Research:**
- [Shared Infrastructure Research](../../research/doc-infrastructure/research-shared-infrastructure.md)

**Related Requirements:**
- FR-SI1: Color output with TTY detection
- FR-SI2: Debug output controlled by DT_DEBUG
- FR-SI4: Use `dt_*` prefix for functions
- C-SI2: Monorepo versioning

---

## Decision

**Create a new shared library `lib/core/output-utils.sh` with `dt_*` prefixed functions, following existing dev-toolkit patterns.**

### Library Structure

```
lib/
├── core/
│   ├── github-utils.sh       # Existing (gh_* prefix)
│   └── output-utils.sh       # NEW (dt_* prefix)
├── doc-gen/
│   └── render.sh             # dt-doc-gen specific
├── doc-validate/
│   └── rules.sh              # dt-doc-validate specific
├── git-flow/
│   └── utils.sh              # Existing (gf_* prefix)
└── sourcery/
    └── parser.sh             # Existing
```

### Shared Functions

```bash
# lib/core/output-utils.sh

# XDG Base Directory helpers (consistent with proj-cli)
dt_get_config_dir()   # ${XDG_CONFIG_HOME:-~/.config}/dev-toolkit
dt_get_data_dir()     # ${XDG_DATA_HOME:-~/.local/share}/dev-toolkit
dt_get_config_file()  # Config file path

# Color setup with TTY detection
dt_setup_colors()

# Status messages (ERROR, WARNING, SUCCESS, INFO)
dt_print_status()

# Section headers
dt_print_header()

# Debug output (when DT_DEBUG=true)
dt_print_debug()

# Version display
dt_show_version()

# dev-infra location detection
dt_detect_dev_infra()

# Project structure detection (admin vs docs/maintainers)
dt_detect_project_structure()  # Returns "admin" or "docs/maintainers"
dt_get_docs_root()             # Convenience wrapper
```

### Usage Pattern

```bash
#!/bin/bash
# bin/dt-doc-gen

# Detect toolkit location (existing pattern)
if [ -n "${DT_ROOT:-}" ]; then
    TOOLKIT_ROOT="$DT_ROOT"
elif [ -f "$(dirname "${BASH_SOURCE[0]}")/../lib/core/output-utils.sh" ]; then
    TOOLKIT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
else
    TOOLKIT_ROOT="$HOME/.dev-toolkit"
fi

# Source shared utilities
source "$TOOLKIT_ROOT/lib/core/output-utils.sh"

# Use shared functions
dt_print_header "Document Generation"
dt_print_status "INFO" "Processing template..."
```

### Boundary Definition

| Layer | Contents | Changes Often? |
|-------|----------|----------------|
| **Shared** (`lib/core/output-utils.sh`) | XDG paths, Color, TTY, debug, version, dev-infra detection | Rarely |
| **dt-doc-gen** (`lib/doc-gen/`) | Template fetching, variable expansion, rendering | Per sprint |
| **dt-doc-validate** (`lib/doc-validate/`) | Validation rules, error formatting, type detection | Per sprint |

---

## Consequences

### Positive

- **Consistency:** Both commands have identical output styling
- **DRY:** No duplicated color/TTY detection code
- **Established pattern:** Follows existing `gh_*` and `gf_*` conventions
- **Maintainability:** Bug fixes apply to both commands
- **Clear boundaries:** Shared vs. command-specific is explicit

### Negative

- **Coupling:** Shared library changes affect both commands
- **Additional file:** One more library to source
- **Coordination:** Breaking changes need care

### Mitigations

- Shared library is stable (rarely changes)
- Clear `dt_*` prefix prevents conflicts
- Monorepo versioning keeps everything in sync

---

## Alternatives Considered

### Alternative 1: Inline Everything

**Description:** Each command defines its own color/output functions.

**Pros:**
- No dependencies between commands
- Each command is self-contained

**Cons:**
- Code duplication (already exists in dev-toolkit)
- Inconsistent output styles
- Bug fixes needed in multiple places

**Why not chosen:** Research found 3 existing duplicated `print_status` implementations. More duplication makes this worse.

---

### Alternative 2: Extend github-utils.sh

**Description:** Add doc-infrastructure functions to existing `lib/core/github-utils.sh`.

**Pros:**
- No new files
- Reuse existing library

**Cons:**
- Mixes unrelated functionality
- `gh_*` prefix doesn't fit
- github-utils.sh is already 530 lines

**Why not chosen:** Violates single responsibility. doc-infrastructure functions are not GitHub-related.

---

### Alternative 3: Independent Versioning

**Description:** Version shared library separately from toolkit.

**Pros:**
- Library can evolve independently
- Explicit dependency management

**Cons:**
- Version coordination complexity
- Overkill for internal library
- dev-toolkit already uses monorepo versioning

**Why not chosen:** Monorepo versioning is simpler and matches existing dev-toolkit approach.

---

## Decision Rationale

**Key Factors:**

1. **Existing Patterns:** dev-toolkit already has `lib/core/` and prefix conventions
2. **DRY Principle:** Avoid duplicating color/TTY code a fourth time
3. **Simplicity:** Monorepo versioning avoids version coordination
4. **Maintainability:** Single source for common functionality

**Research Support:**
- Finding 1: "dev-toolkit already has well-established shared library pattern"
- Finding 2: "TOOLKIT_ROOT detection pattern should be reused exactly"
- Finding 6: "Current code duplication to avoid" (3 print_status implementations)
- Insight 1: "Use namespaced prefixes (`dt_*`)"

---

## Requirements Impact

**Requirements Addressed:**
- FR-SI1: Color output with TTY detection ✅
- FR-SI2: Debug output controlled by DT_DEBUG ✅
- FR-SI3: dev-infra location detection function ✅
- FR-SI4: `dt_*` prefix for functions ✅
- NFR-SI1: Source-able library ✅
- NFR-SI2: Export functions ✅
- NFR-SI3: Graceful color degradation ✅

**Constraints Acknowledged:**
- C-SI1: Follow existing TOOLKIT_ROOT detection pattern
- C-SI2: Monorepo versioning (no independent version)
- C-SI3: Command-specific code stays in separate directories

---

## References

- [Shared Infrastructure Research](../../research/doc-infrastructure/research-shared-infrastructure.md)
- [Requirements Document](../../research/doc-infrastructure/requirements.md)
- [Existing lib/core/github-utils.sh](../../lib/core/github-utils.sh)

---

**Last Updated:** 2026-01-20
