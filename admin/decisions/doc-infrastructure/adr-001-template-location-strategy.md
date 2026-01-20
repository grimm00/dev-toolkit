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

---

## Decision

**Templates remain in dev-infra (single source of truth) and are NOT bundled with dev-toolkit.**

dt-doc-gen uses **layered discovery** to locate templates, with the following priority:

```
1. --template-path flag     (explicit override)
2. $DT_TEMPLATES_PATH env   (environment variable)
3. Config file setting      (persistent configuration)
4. Default local paths      ($HOME/Projects/dev-infra/..., etc.)
5. Error with setup help    (if not found)
```

### Implementation

```bash
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
    
    # 3. Config file
    if [ -f "$HOME/.dev-toolkit/config" ]; then
        local config_path
        config_path=$(grep "^DT_TEMPLATES_PATH=" "$HOME/.dev-toolkit/config" | cut -d= -f2)
        if [ -n "$config_path" ] && [ -d "$config_path" ]; then
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

---

**Last Updated:** 2026-01-20
