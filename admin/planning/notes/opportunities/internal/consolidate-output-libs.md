# Enhancement Opportunity: Consolidate Output Libraries

**Type:** Internal Refactoring  
**Status:** 📋 Identified  
**Created:** 2026-01-21  
**Priority:** 🟡 Medium  
**Effort:** 1-2 days  
**Depends On:** doc-infrastructure Phase 1 complete

---

## 📋 Summary

Refactor `github-utils.sh` to use the new `output-utils.sh` shared library for colors, printing, and XDG-compliant configuration paths.

---

## 🎯 Problem

Currently, dev-toolkit has duplicated output functionality:

| Functionality | github-utils.sh | output-utils.sh |
|---------------|-----------------|-----------------|
| Color Setup | Inline (lines 11-30) | `dt_setup_colors()` |
| Print Status | `gh_print_status()` | `dt_print_status()` |
| Print Header | `gh_print_header()` | `dt_print_header()` |
| Config Path | `~/.dev-toolkit/config.conf` | XDG paths |

This creates:
- Code duplication
- Inconsistent config paths
- Maintenance burden

---

## 💡 Proposed Solution

### Phase 1: Add XDG Compatibility to github-utils.sh

```bash
# At top of github-utils.sh
source "${TOOLKIT_ROOT}/lib/core/output-utils.sh"

# Initialize colors via shared function
dt_setup_colors

# Map GH_* colors to DT_* for backward compatibility
GH_RED="$DT_RED"
GH_GREEN="$DT_GREEN"
# ... etc
```

### Phase 2: Update Config Path Handling

```bash
# Use XDG paths with legacy fallback
CONFIG_FILE_GLOBAL="$(dt_get_config_file)"
LEGACY_CONFIG_FILE="$HOME/.dev-toolkit/config.conf"

gh_load_config() {
    # Try XDG path first
    if [ -f "$CONFIG_FILE_GLOBAL" ]; then
        gh_load_config_file "$CONFIG_FILE_GLOBAL"
    elif [ -f "$LEGACY_CONFIG_FILE" ]; then
        dt_print_status "WARNING" "Using deprecated config: $LEGACY_CONFIG_FILE"
        dt_print_status "INFO" "Migrate to: $CONFIG_FILE_GLOBAL"
        gh_load_config_file "$LEGACY_CONFIG_FILE"
    fi
}
```

### Phase 3: Simplify Print Functions

```bash
# Keep gh_* wrappers for backward compatibility
gh_print_status() {
    dt_print_status "$@"
}

gh_print_header() {
    dt_print_header "$@"
}
```

---

## 📊 Impact

**Files Affected:**
- `lib/core/github-utils.sh` - Main changes
- `lib/git-flow/safety.sh` - May need updates
- `lib/git-flow/utils.sh` - May need updates
- `bin/dt-*` commands - Verify still work

**Backward Compatibility:**
- All existing `gh_*` functions continue to work
- Config migration with deprecation warning
- No breaking changes to external API

---

## ✅ Success Criteria

- [ ] github-utils.sh sources output-utils.sh
- [ ] All dt-* commands work correctly
- [ ] XDG config paths used by default
- [ ] Legacy config paths produce deprecation warning
- [ ] Tests pass for both libraries
- [ ] No duplicate color/print code

---

## 🔗 Related

- **Source:** Phase 1 Review (`phase-1-review.md`)
- **Blocking Feature:** doc-infrastructure (must complete first)
- **ADR:** ADR-005 (Shared Infrastructure)

---

## 📅 Timeline

**When to implement:**
- After doc-infrastructure feature complete
- Before next major release
- Could be done as quick cleanup sprint

---

**Last Updated:** 2026-01-21
