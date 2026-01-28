# ADR-001: Template Location and Discovery Strategy

**Status:** ✅ Accepted  
**Created:** 2026-01-20  
**Last Updated:** 2026-01-20

---

## Context

dt-doc-gen needs access to templates from dev-infra to generate documents. The templates define structure, placeholders, and AI expansion zones for 17 document types across 5 categories (exploration, research, decision, planning, other).

**Key Question:** Where should templates live, and how should dt-doc-gen locate them?

**Related Research:**
- [Template Fetching Research](../../research/doc-infrastructure/research-template-fetching.md)

**Related Requirements:**
- FR-DT-1: Explicit template path via `--template-path` CLI flag
- FR-DT-2: Environment variable template discovery (`$DT_TEMPLATES_PATH`)
- FR-DT-3: Config file template path support
- C-DT-1: No bundled templates

**Related Standards:**
- [XDG Base Directory Specification](https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html) - For config file location
- Consistency with proj-cli XDG implementation

---

## Decision

**Templates remain in dev-infra (single source of truth) and are NOT bundled with dev-toolkit.**

dt-doc-gen uses **layered discovery** to locate templates, with the following priority:

```
1. --template-path flag     (explicit override)
2. $DT_TEMPLATES_PATH env   (environment variable)
3. Config file setting      (XDG-compliant path, with legacy fallback)
4. Default local paths      ($HOME/Projects/dev-infra/..., etc.)
5. Error with setup help    (if not found)
```

### XDG Base Directory Compliance

Config files follow the [XDG Base Directory Specification](https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html) for consistency with proj-cli and modern CLI tools:

| Purpose | XDG Path | Fallback (Legacy) |
|---------|----------|-------------------|
| **Config** | `${XDG_CONFIG_HOME:-~/.config}/dev-toolkit/config` | `~/.dev-toolkit/config.conf` |
| **Data/Cache** | `${XDG_DATA_HOME:-~/.local/share}/dev-toolkit/` | N/A |

**Note:** Legacy path (`~/.dev-toolkit/config.conf`) is supported temporarily for backward compatibility but will be deprecated.

### Implementation

```bash
# XDG helper functions (in lib/core/output-utils.sh)
dt_get_config_dir() {
    echo "${XDG_CONFIG_HOME:-$HOME/.config}/dev-toolkit"
}

dt_get_data_dir() {
    echo "${XDG_DATA_HOME:-$HOME/.local/share}/dev-toolkit"
}

dt_get_config_file() {
    echo "$(dt_get_config_dir)/config"
}

dt_find_templates() {
    # 1. Explicit CLI flag (highest priority)
    if [ -n "${TEMPLATE_PATH_FLAG:-}" ]; then
        echo "$TEMPLATE_PATH_FLAG"
        return 0
    fi
    
    # 2. Environment variable
    if [ -n "${DT_TEMPLATES_PATH:-}" ] && [ -d "$DT_TEMPLATES_PATH" ]; then
        echo "$DT_TEMPLATES_PATH"
        return 0
    fi
    
    # 3. Config file (XDG-compliant path)
    local xdg_config="$(dt_get_config_file)"
    if [ -f "$xdg_config" ]; then
        local config_path
        config_path=$(grep "^DT_TEMPLATES_PATH=" "$xdg_config" | cut -d= -f2)
        if [ -n "$config_path" ] && [ -d "$config_path" ]; then
            echo "$config_path"
            return 0
        fi
    fi
    
    # 3b. Legacy config path (temporary backward compatibility)
    local legacy_config="$HOME/.dev-toolkit/config.conf"
    if [ -f "$legacy_config" ]; then
        local config_path
        config_path=$(grep "^DT_TEMPLATES_PATH=" "$legacy_config" | cut -d= -f2)
        if [ -n "$config_path" ] && [ -d "$config_path" ]; then
            dt_print_status "WARNING" "Using legacy config at $legacy_config"
            dt_print_status "INFO" "Consider migrating to $(dt_get_config_file)"
            echo "$config_path"
            return 0
        fi
    fi
    
    # 4. Default locations
    for path in \
        "$HOME/Projects/dev-infra/scripts/doc-gen/templates" \
        "$HOME/dev-infra/scripts/doc-gen/templates" \
        "../dev-infra/scripts/doc-gen/templates"; do
        if [ -d "$path" ]; then
            echo "$path"
            return 0
        fi
    done
    
    # 5. Not found - error
    return 1
}
```

---

## Consequences

### Positive

- **Single source of truth:** Templates are maintained in one place (dev-infra)
- **No version sync issues:** No need to keep bundled templates in sync
- **Flexible configuration:** Multiple ways to specify template location
- **Development friendly:** Works with local dev-infra clone
- **CI/CD compatible:** Environment variable works in pipelines
- **XDG compliant:** Config paths follow modern standards, consistent with proj-cli

### Negative

- **Setup required:** Users must have dev-infra available or configured
- **Network dependency (future):** If remote fetch is added, requires network
- **Path configuration:** Users need to configure path if not in default location

### Mitigations

- Clear error messages with setup instructions when templates not found
- Document all discovery methods in help text
- Future: Optional `--fetch` flag for remote template retrieval

---

## Alternatives Considered

### Alternative 1: Bundle Templates in dev-toolkit

**Description:** Copy templates into dev-toolkit repository and distribute with releases.

**Pros:**
- Zero setup required
- Works offline immediately
- No external dependencies

**Cons:**
- Version synchronization nightmare
- Duplicate maintenance
- Breaks single source of truth
- Templates drift between repos

**Why not chosen:** Violates C-DT-1 constraint. Template drift would cause validation failures and inconsistent document generation.

---

### Alternative 2: Always Fetch from GitHub

**Description:** Download templates from GitHub releases on every invocation.

**Pros:**
- Always latest templates
- No local storage needed
- Automatic updates

**Cons:**
- Requires network for every operation
- Slow (network latency)
- Fails offline
- Rate limiting issues

**Why not chosen:** dev-toolkit principle is offline-first. Network dependency breaks CI and development workflows.

---

### Alternative 3: Single Environment Variable Only

**Description:** Only support `$DT_TEMPLATES_PATH`, no layered discovery.

**Pros:**
- Simple implementation
- Explicit configuration
- No magic

**Cons:**
- Poor UX for common case
- Must set env var every time
- No per-project configuration

**Why not chosen:** Layered discovery provides better UX while maintaining explicitness when needed.

---

## Decision Rationale

**Key Factors:**

1. **Single Source of Truth:** Templates MUST live in dev-infra to ensure all tools validate against the same standards
2. **Offline Operation:** Core functionality MUST work without network
3. **Flexibility:** Different users have different setups (local clone, CI, etc.)
4. **Existing Patterns:** dev-toolkit already uses layered discovery for `$DT_ROOT`
5. **XDG Compliance:** Config paths should follow XDG Base Directory Specification for consistency with proj-cli and modern CLI tools

**Research Support:**
- Finding 1 from research: "Templates stay in dev-infra (single source of truth)"
- Finding 2: "NOT bundled with dev-toolkit"
- Finding 3: "Layered discovery: `--template-path` → `DEVINFRA_ROOT` → config → local paths"

---

## Requirements Impact

**Requirements Addressed:**
- FR-DT-1: `--template-path` flag ✅
- FR-DT-2: `$DT_TEMPLATES_PATH` environment variable ✅
- FR-DT-3: Config file support ✅
- FR-DT-4: Default location checking ✅
- NFR-DT-1: Offline template discovery ✅
- NFR-DT-2: Clear setup error messages ✅
- C-DT-1: No bundled templates ✅

**Requirements Deferred:**
- FR-DT-5: Optional remote fetch (future enhancement)
- FR-DT-6: Version pinning for remote fetch (future enhancement)

---

## References

- [Template Fetching Research](../../research/doc-infrastructure/research-template-fetching.md)
- [Requirements Document](../../research/doc-infrastructure/requirements.md)
- [dev-infra template specifications](~/Projects/dev-infra/scripts/doc-gen/templates/)
- [XDG Base Directory Specification](https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html)
- [proj-cli XDG implementation](~/Projects/proj-cli/src/proj/config.py)

---

## 📝 Migration Notes

### For New Users
Use the XDG-compliant config path:
```bash
mkdir -p "${XDG_CONFIG_HOME:-$HOME/.config}/dev-toolkit"
# Create config at ~/.config/dev-toolkit/config
```

### For Existing Users (Legacy Path)
If you have `~/.dev-toolkit/config.conf`, migrate to XDG:
```bash
# Create XDG config directory
mkdir -p "${XDG_CONFIG_HOME:-$HOME/.config}/dev-toolkit"

# Move config (adjust path if needed)
mv ~/.dev-toolkit/config.conf ~/.config/dev-toolkit/config

# Remove old config directory if empty (keep if it has other files)
# rmdir ~/.dev-toolkit 2>/dev/null || true
```

### Local Machine TODO (@cdwilson)
- [ ] Remove `~/.dev-toolkit/config.conf` if it exists
- [ ] Use XDG path: `~/.config/dev-toolkit/config`

---

**Last Updated:** 2026-01-20 (Updated for XDG compliance)
