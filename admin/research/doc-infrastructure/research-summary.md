# Research Summary - Doc Infrastructure

**Purpose:** Summary of all research findings for dt-doc-gen and dt-doc-validate  
**Status:** 🟠 In Progress  
**Created:** 2026-01-16  
**Last Updated:** 2026-01-17

---

## 📋 Research Overview

This research supports the implementation of two new dev-toolkit commands:

- **`dt-doc-gen`** - Generate documentation from 17 templates with variable expansion
- **`dt-doc-validate`** - Validate documents against common + type-specific rules

**Research Topics:** 7 topics  
**Research Documents:** 7 documents  
**Status:** 🟠 In Progress (4/7 complete)

---

## 📊 Research Progress

| # | Topic | Priority | Status |
|---|-------|----------|--------|
| 1 | Template Fetching Strategy | 🔴 High | ✅ Complete |
| 2 | YAML Parsing in Bash | 🔴 High | ✅ Complete |
| 3 | Command Workflow Integration | 🔴 High | ✅ Complete |
| 4 | Document Type Detection | 🟡 Medium | ✅ Complete |
| 5 | Variable Expansion Edge Cases | 🟡 Medium | 🔴 Not Started |
| 6 | Error Output Format | 🟡 Medium | 🔴 Not Started |
| 7 | Shared Infrastructure Design | 🟢 Low | 🔴 Not Started |

---

## 🔍 Key Findings

### Finding 1: Layered Template Discovery is the Recommended Strategy

Research on template fetching identified a layered discovery approach as optimal, following the priority order:

1. **Explicit CLI flag** (`--template-path`) - highest priority
2. **Environment variable** (`$DT_TEMPLATES_PATH`)
3. **Config file** (global or project)
4. **Default locations** (`$HOME/Projects/dev-infra/...`, `$HOME/.dev-infra/...`)
5. **Remote fetch** (optional, with version pinning)

This aligns with dev-toolkit's existing pattern for `$DT_ROOT` and provides maximum flexibility while maintaining simplicity for typical use cases.

**Source:** [research-template-fetching.md](research-template-fetching.md)

---

### Finding 2: Templates Must NOT Be Bundled

Bundling templates in dev-toolkit would create a version synchronization nightmare and violate the single-source-of-truth principle. Templates live in dev-infra and should be accessed via path configuration.

**Source:** [research-template-fetching.md](research-template-fetching.md)

---

### Finding 3: Dev-Infra Template Structure is Predictable

The 17 templates follow a clear hierarchical structure by document type:
- `exploration/` (3 templates)
- `research/` (4 templates)
- `decision/` (3 templates)
- `planning/` (4 templates)
- `other/` (3 templates)

Template paths follow pattern: `{TEMPLATES_ROOT}/{doc_type}/{template_name}.tmpl`

**Source:** [research-template-fetching.md](research-template-fetching.md)

---

### Finding 4: Build-Time YAML Conversion is Optimal

Rather than parsing YAML at runtime in bash (complex, fragile), the recommended approach is:
1. Use yq during build/release to convert YAML to bash-native format
2. Ship pre-compiled `.bash` files with dt-doc-validate
3. Runtime uses simple `source` command - no parsing needed

This eliminates the runtime YAML parsing problem entirely.

**Source:** [research-yaml-parsing.md](research-yaml-parsing.md)

---

### Finding 5: Validation YAML Uses a Constrained Subset

Analysis of all 6 validation rule files shows they use a predictable, constrained YAML subset:
- Maximum 3-4 levels of nesting
- No anchors, aliases, or flow-style collections
- Consistent 2-space indentation
- Multi-line strings only in examples section

This makes pure bash fallback parsing feasible if needed.

**Source:** [research-yaml-parsing.md](research-yaml-parsing.md)

---

### Finding 6: Commands Already Invoke Shell Commands

Current Cursor commands already use `run_terminal_cmd` to execute shell commands (git operations). The same pattern applies for dt-doc-gen and dt-doc-validate:

```markdown
**Generate structure:**
\`\`\`bash
dt-doc-gen exploration my-topic --mode setup
\`\`\`

**Validate before commit:**
\`\`\`bash
dt-doc-validate admin/explorations/my-topic/
\`\`\`
```

**Source:** [research-command-integration.md](research-command-integration.md)

---

### Finding 7: Two-Mode Commands Map to dt-doc-gen Modes

The `/explore` and `/research` commands have setup/conduct modes that map cleanly:

| Command Mode | dt-doc-gen Mode | Output | AI Role |
|--------------|-----------------|--------|---------|
| Setup | `--mode setup` | Scaffolding (~60-80 lines) | Variable substitution only |
| Conduct | `--mode conduct` | Full document (~200-300 lines) | Fill expansion zones |

**Source:** [research-command-integration.md](research-command-integration.md)

---

## 💡 Key Insights

- [x] **Insight 1:** Environment variable approach aligns with dev-toolkit's existing patterns
- [x] **Insight 2:** Remote fetching is useful as fallback but shouldn't be primary
- [x] **Insight 3:** Local clone with config is simplest UX for regular users
- [x] **Insight 4:** Build-time conversion eliminates runtime YAML parsing complexity
- [x] **Insight 5:** Pre-compiled bash files are faster and more portable
- [x] **Insight 6:** Commands already invoke shell commands - dt-doc-gen fits existing pattern
- [x] **Insight 7:** Migration is incremental - /explore first, then /research
- [x] **Insight 8:** Path-based type detection is highly reliable (100% in testing)
- [x] **Insight 9:** README.md files require path context (content is generic)

---

## 📋 Requirements Summary

**See:** [requirements.md](requirements.md) for complete requirements document

### Requirements from Template Fetching Research

**Functional:**
- FR-DT-1: Explicit template path via `--template-path` CLI flag
- FR-DT-2: Environment variable template discovery (`$DT_TEMPLATES_PATH`)
- FR-DT-3: Config file template path support
- FR-DT-4: Default location checking
- FR-DT-5: Optional remote fetch with `--fetch` flag
- FR-DT-6: Version pinning for remote fetch

**Non-Functional:**
- NFR-DT-1: Offline template discovery
- NFR-DT-2: Clear setup error messages
- NFR-DT-3: Documented discovery order

**Constraints:**
- C-DT-1: No bundled templates
- C-DT-2: Bash-only core functionality

### Requirements from YAML Parsing Research

**Functional:**
- FR-YP1: Pre-compiled bash validation rules
- FR-YP2: Build-time YAML to bash conversion
- FR-YP3: yq for conversion script
- FR-YP4: Optional direct YAML parsing with yq
- FR-YP5: Clear error if no rules available
- FR-YP6: Support path patterns, required sections, error messages

**Non-Functional:**
- NFR-YP1: Rule loading <100ms
- NFR-YP2: Offline operation without yq
- NFR-YP3: Documented YAML subset

**Constraints:**
- C-YP1: YAML must conform to supported subset
- C-YP2: Pre-compiled rules must regenerate on YAML changes
- C-YP3: yq is dev dependency only (not runtime)

### Requirements from Command Integration Research

**Functional:**
- FR-CI1: `--mode setup|conduct` for two-mode support
- FR-CI2: `--output` path control
- FR-CI3: Directory validation support
- FR-CI4: Exit codes 0/1/2
- FR-CI5: Pre-commit validation
- FR-CI6: Script invocation (post-migration)

**Non-Functional:**
- NFR-CI1: Incremental migration
- NFR-CI2: Backward compatibility
- NFR-CI3: Output compatibility with inline templates
- NFR-CI4: <1 second invocation time

**Constraints:**
- C-CI1: Commands remain orchestrators
- C-CI2: AI generates content only (not structure)
- C-CI3: Inline templates as fallback during migration

### Requirements from Type Detection Research

**Functional:**
- FR-TD1: `--type` flag for explicit override
- FR-TD2: Path-based type detection
- FR-TD3: Content-based fallback detection
- FR-TD4: TYPE_DETECTION_FAILED error with available types
- FR-TD5: Detect all 17 document subtypes

**Non-Functional:**
- NFR-TD1: Detection <50ms per file
- NFR-TD2: Documented detection order
- NFR-TD3: Helpful error messages with type list

**Constraints:**
- C-TD1: README.md requires path context
- C-TD2: Path patterns ordered most-to-least specific

**Prior Requirements (from dev-infra):**
- FR-16: Tooling in dev-toolkit (`bin/dt-doc-gen`, `bin/dt-doc-validate`)
- FR-26: Commands invoke `dt-doc-gen` for structure
- FR-27: Commands invoke `dt-doc-validate` before commit
- C-7: Scripts generate structure, AI fills content
- C-13: Commands remain orchestrators

---

## 🎯 Recommendations

- [x] **Recommendation 1:** Implement layered discovery with environment variable as primary method
- [x] **Recommendation 2:** Use `$DT_TEMPLATES_PATH` as the standard environment variable name
- [x] **Recommendation 3:** Support `--template-path` CLI flag for explicit override
- [x] **Recommendation 4:** Add config file support for persistent configuration
- [x] **Recommendation 5:** Implement optional remote fetch with `--fetch` flag and version pinning
- [x] **Recommendation 6:** Provide clear error messages with setup instructions
- [x] **Recommendation 7:** Implement build-time YAML → bash conversion script
- [x] **Recommendation 8:** Ship pre-compiled `.bash` rule files with dt-doc-validate
- [x] **Recommendation 9:** Use yq for conversion (not runtime)
- [x] **Recommendation 10:** Document supported YAML subset
- [x] **Recommendation 11:** Implement dt-doc-gen with `--mode setup|conduct` support
- [x] **Recommendation 12:** Commands invoke dt-doc-validate before every commit
- [x] **Recommendation 13:** Start migration with `/explore` command (highest complexity/value)
- [x] **Recommendation 14:** Use fixture-based testing for both commands
- [x] **Recommendation 15:** Implement path-based detection as primary method
- [x] **Recommendation 16:** Implement content-based detection as fallback
- [x] **Recommendation 17:** Provide clear error with available types when detection fails

---

## 🚀 Next Steps

1. ✅ ~~Research Topic 1: Template Fetching Strategy~~ Complete
2. ✅ ~~Research Topic 2: YAML Parsing in Bash~~ Complete
3. ✅ ~~Research Topic 3: Command Workflow Integration~~ Complete
4. ✅ ~~Research Topic 4: Document Type Detection~~ Complete
5. Optional: Continue with remaining topics (5-7)
6. Ready for: `/decision doc-infrastructure --from-research`

---

**Last Updated:** 2026-01-17
