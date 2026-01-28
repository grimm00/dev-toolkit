# Research: Template Fetching Strategy

**Research Topic:** Doc Infrastructure  
**Question:** How should dt-doc-gen locate and fetch templates from dev-infra?  
**Status:** ✅ Complete  
**Priority:** 🔴 High (Blocking)  
**Created:** 2026-01-16  
**Completed:** 2026-01-17  
**Last Updated:** 2026-01-17

---

## 🎯 Research Question

How should dt-doc-gen locate and fetch templates from dev-infra? The 17 templates live in dev-infra's `scripts/doc-gen/templates/` directory. dt-doc-gen needs to access these templates but shouldn't require dev-infra to be cloned in a specific location.

---

## 🔍 Research Goals

- [x] Goal 1: Document template source options (local path, bundled, GitHub fetch)
- [x] Goal 2: Evaluate trade-offs: simplicity vs flexibility vs maintenance
- [x] Goal 3: Prototype environment variable approach (`$DT_TEMPLATES_PATH`)
- [x] Goal 4: Consider version pinning strategy if fetching remotely
- [x] Goal 5: Define recommended approach for dev-toolkit implementation

---

## 📚 Research Methodology

**Note:** Web search is **allowed and encouraged** for research.

**Sources:**
- [x] Source 1: Review how similar CLI tools handle external templates (cookiecutter, yeoman, etc.)
- [x] Source 2: Analyze dev-infra template structure and dependencies
- [x] Source 3: Review dev-toolkit installation patterns (install.sh, dev-setup.sh)
- [x] Source 4: Web search: Template location strategies in CLI tools

---

## 📊 Findings

### Finding 1: Dev-Toolkit Uses Proven Path Resolution Pattern

Dev-toolkit already has a robust pattern for locating resources across different installation scenarios:

```bash
# From dt-review and dt-config:
if [ -n "${DT_ROOT:-}" ]; then
    TOOLKIT_ROOT="$DT_ROOT"
elif [ -f "$(dirname "${BASH_SOURCE[0]}")/../lib/sourcery/parser.sh" ]; then
    # Running from dev-toolkit directory
    TOOLKIT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
elif [ -f "$HOME/.dev-toolkit/bin/dt-sourcery-parse" ]; then
    TOOLKIT_ROOT="$HOME/.dev-toolkit"
else
    echo "❌ Error: Cannot locate dev-toolkit installation"
    exit 1
fi
```

**Priority order:** Environment variable → Script location → Default path → Error

**Source:** `bin/dt-review`, `bin/dt-config`

**Relevance:** This same pattern can be adapted for template location with `$DT_TEMPLATES_PATH`.

---

### Finding 2: Dev-Infra Template Structure is Well-Organized

The templates in dev-infra follow a clear hierarchical structure:

```
scripts/doc-gen/templates/
├── exploration/           # 3 templates
│   ├── exploration.md.tmpl
│   ├── README.md.tmpl
│   └── research-topics.md.tmpl
├── research/              # 4 templates
│   ├── README.md.tmpl
│   ├── requirements.md.tmpl
│   ├── research-summary.md.tmpl
│   └── research-topic.md.tmpl
├── decision/              # 3 templates
│   ├── adr.md.tmpl
│   ├── decisions-summary.md.tmpl
│   └── README.md.tmpl
├── planning/              # 4 templates
│   ├── feature-plan.md.tmpl
│   ├── phase.md.tmpl
│   ├── README.md.tmpl
│   └── status-and-next-steps.md.tmpl
├── other/                 # 3 templates
│   ├── fix-batch.md.tmpl
│   ├── handoff.md.tmpl
│   └── reflection.md.tmpl
├── validation-rules/      # 6 YAML rule files
└── FORMAT.md, VALIDATION.md, VARIABLES.md
```

**Total:** 17 templates + 6 validation rule files + 3 spec documents

**Source:** dev-infra repository analysis

**Relevance:** Template paths are predictable: `{TEMPLATES_ROOT}/{doc_type}/{template_name}.tmpl`

---

### Finding 3: Four Template Location Strategies Identified

| Strategy | Description | Pros | Cons |
|----------|-------------|------|------|
| **A. Bundled** | Copy templates into dev-toolkit | Simple distribution, no external deps | Version sync nightmare, duplication |
| **B. Environment Variable** | `$DT_TEMPLATES_PATH` points to local clone | Flexible, user controls location | Requires user setup |
| **C. GitHub API Fetch** | Download templates on-demand via `gh api` | Always current, no local clone needed | Network dependency, rate limits, slow |
| **D. Git Submodule** | dev-infra as submodule in dev-toolkit | Version controlled, single source | Complex, affects dev-toolkit repo |

**Source:** Web research on CLI tools (cookiecutter patterns) + analysis

**Relevance:** Each approach has clear trade-offs; hybrid approach may be optimal.

---

### Finding 4: Industry Standard is Layered Discovery with Fallbacks

CLI tools like cookiecutter, yeoman, and other template tools use a layered approach:

1. **Explicit path** - User specifies exact location (highest priority)
2. **Environment variable** - User configures default location
3. **Standard locations** - Check common paths (`$HOME/.config/`, `$XDG_DATA_HOME/`)
4. **Remote fetch** - Download if not found locally (optional, graceful)

**Key insight:** The best tools don't force one approach - they support multiple strategies with clear priority order.

**Source:** Web research on template location patterns, XDG Base Directory specification

**Relevance:** dt-doc-gen should follow this layered pattern for maximum flexibility.

---

### Finding 5: Version Pinning is Critical for Remote Fetching

If templates are fetched remotely, version pinning prevents breaking changes:

```bash
# Options for version pinning:
DT_TEMPLATES_VERSION="v1.0.0"     # Git tag
DT_TEMPLATES_VERSION="main"       # Branch (risky for production)
DT_TEMPLATES_VERSION="abc1234"    # Commit SHA (most reliable)
```

GitHub CLI supports fetching specific versions:
```bash
gh api repos/owner/repo/contents/path?ref=$VERSION
```

**Source:** GitHub API documentation, web research

**Relevance:** If we implement remote fetching, version pinning should be mandatory.

---

## 🔍 Analysis

### Key Insights

- [x] **Insight 1:** Bundling templates is rejected - it creates a version sync problem and violates DRY
- [x] **Insight 2:** Environment variable approach aligns with dev-toolkit's existing patterns
- [x] **Insight 3:** Remote fetching is useful as a fallback but shouldn't be primary
- [x] **Insight 4:** Local clone with config is the simplest user experience for regular users
- [x] **Insight 5:** A hybrid layered approach provides the best balance

### Recommended Strategy: Layered Discovery

```bash
# Priority order for finding templates:

# 1. Explicit command-line argument (highest priority)
dt-doc-gen --template-path /path/to/templates exploration README

# 2. Environment variable
export DT_TEMPLATES_PATH="$HOME/Projects/dev-infra/scripts/doc-gen/templates"
dt-doc-gen exploration README

# 3. Configuration file
# ~/.dev-toolkit/config.conf or .dev-toolkit.conf
# DT_TEMPLATES_PATH=/path/to/templates

# 4. Default location (if dev-infra commonly cloned)
$HOME/Projects/dev-infra/scripts/doc-gen/templates
$HOME/.dev-infra/scripts/doc-gen/templates

# 5. Remote fetch as last resort (with version pinning)
# Requires: DT_TEMPLATES_REPO and DT_TEMPLATES_VERSION
```

### Trade-off Analysis

| Factor | Environment Var | Remote Fetch | Bundled |
|--------|-----------------|--------------|---------|
| **Setup complexity** | Low (one export) | None | None |
| **Version sync** | User controlled | Automatic | Manual |
| **Network dependency** | None | Required | None |
| **Offline support** | ✅ Yes | ❌ No | ✅ Yes |
| **Dev-infra updates** | Immediate | Automatic | Delayed |
| **CI/CD friendly** | ✅ Yes | ✅ Yes | ✅ Yes |

**Recommendation:** Environment variable as primary, with remote fetch as optional fallback.

---

## 💡 Recommendations

- [x] **Recommendation 1:** Implement layered discovery with environment variable as primary method
- [x] **Recommendation 2:** Use `$DT_TEMPLATES_PATH` as the standard environment variable name
- [x] **Recommendation 3:** Support `--template-path` CLI flag for explicit override
- [x] **Recommendation 4:** Add config file support for persistent configuration
- [x] **Recommendation 5:** Implement optional remote fetch with `--fetch` flag and version pinning
- [x] **Recommendation 6:** Provide clear error messages with setup instructions when templates not found

### Example Implementation Sketch

```bash
#!/usr/bin/env bash
# dt-doc-gen template discovery

get_templates_root() {
    local explicit_path="${1:-}"
    
    # 1. Explicit path (CLI argument)
    if [ -n "$explicit_path" ] && [ -d "$explicit_path" ]; then
        echo "$explicit_path"
        return 0
    fi
    
    # 2. Environment variable
    if [ -n "${DT_TEMPLATES_PATH:-}" ] && [ -d "$DT_TEMPLATES_PATH" ]; then
        echo "$DT_TEMPLATES_PATH"
        return 0
    fi
    
    # 3. Config file (global or project)
    local config_path
    config_path=$(get_config_value "DT_TEMPLATES_PATH")
    if [ -n "$config_path" ] && [ -d "$config_path" ]; then
        echo "$config_path"
        return 0
    fi
    
    # 4. Common default locations
    local defaults=(
        "$HOME/Projects/dev-infra/scripts/doc-gen/templates"
        "$HOME/.dev-infra/scripts/doc-gen/templates"
    )
    for loc in "${defaults[@]}"; do
        if [ -d "$loc" ]; then
            echo "$loc"
            return 0
        fi
    done
    
    # 5. Not found - return error
    return 1
}
```

---

## 📋 Requirements Discovered

### Functional Requirements

- [x] **FR-TF1:** dt-doc-gen MUST support explicit template path via `--template-path` CLI flag
- [x] **FR-TF2:** dt-doc-gen MUST check `$DT_TEMPLATES_PATH` environment variable
- [x] **FR-TF3:** dt-doc-gen MUST check config file for `DT_TEMPLATES_PATH` setting
- [x] **FR-TF4:** dt-doc-gen SHOULD check common default locations
- [x] **FR-TF5:** dt-doc-gen MAY support remote fetch with `--fetch` flag (optional)
- [x] **FR-TF6:** Remote fetch MUST require version pinning (`$DT_TEMPLATES_VERSION`)

### Non-Functional Requirements

- [x] **NFR-TF1:** Template discovery MUST work offline (network not required for local paths)
- [x] **NFR-TF2:** Error messages MUST include clear setup instructions
- [x] **NFR-TF3:** Discovery order MUST be documented and predictable

### Constraints

- [x] **C-TF1:** Templates are NOT bundled with dev-toolkit (single source of truth in dev-infra)
- [x] **C-TF2:** Bash-only implementation (no external dependencies for core functionality)

---

## 🚀 Next Steps

1. ~~Conduct research~~ ✅ Complete
2. Update requirements.md with discovered requirements
3. Implement template discovery function in `lib/doc-gen/templates.sh`
4. Add `dt-setup-templates` helper command for easy configuration

---

**Last Updated:** 2026-01-17
