# Exploration: Doc Infrastructure

**Status:** ✅ Expanded  
**Created:** 2026-01-16  
**Expanded:** 2026-01-16

---

## 🎯 What We're Exploring

Implementing two new dev-toolkit commands (`dt-doc-gen` and `dt-doc-validate`) that leverage external templates and validation rules from dev-infra. The goal is to eliminate 154 inline template instances across 23 Cursor commands that cause format drift and break automation workflows.

The dev-infra repository has completed the specification work:
- **FORMAT.md** - Three placeholder types (`${VAR}`, `<!-- AI: -->`, `<!-- EXPAND: -->`)
- **VARIABLES.md** - 29 standard variables across 7 categories
- **VALIDATION.md** - Common rules + type-specific rules for 6 document categories
- **17 template files** organized by workflow (exploration, research, decision, planning, other)
- **6 YAML validation rule files** with machine-readable rule definitions

This exploration covers both commands as a coordinated suite, though each will be implemented and tested independently.

---

## 🔍 Themes

### Theme 1: Document Generation (`dt-doc-gen`)

The generator command transforms templates into ready-to-use documents. Based on the FORMAT.md spec, the generation flow is:

```
Template (.tmpl) → envsubst (${VAR}) → Output with AI/EXPAND preserved
```

**Key capabilities:**
- **Template fetching** - Locate templates from dev-infra (local path initially, GitHub releases later)
- **Variable expansion** - Use `envsubst` for `${VAR}` placeholders (29 variables defined)
- **Mode handling** - Scaffolding mode preserves all markers; Full mode is handled by AI in workflow
- **Output routing** - Write to appropriate directory based on document type
- **AI marker preservation** - `<!-- AI: -->` and `<!-- EXPAND: -->` pass through unchanged

**Connections:**
- Connects to existing dev-toolkit patterns (`dt-review`, `dt-sourcery-parse`) for CLI conventions
- Integrates with Cursor workflow commands (`/explore`, `/research`, `/decision`)
- Depends on dev-infra maintaining stable template structure

**Implications:**
- Need clear template location strategy (local dev-infra vs bundled vs fetched)
- Variable export must happen before `envsubst` call
- Output paths need mapping from doc type → directory structure

**Concerns:**
- Template versioning - what if dev-infra templates change?
- Path detection - dev-toolkit vs template-structure projects
- Variable validation - ensuring all required vars are set

---

### Theme 2: Document Validation (`dt-doc-validate`)

The validator checks documents against template standards. Based on VALIDATION.md:

**Common Rules (all doc types):**

| Rule | Pattern | Severity |
|------|---------|----------|
| `COMMON_STATUS_HEADER` | `**Status:** [emoji]` | ERROR |
| `COMMON_CREATED_DATE` | `**Created:** YYYY-MM-DD` | ERROR |
| `COMMON_LAST_UPDATED` | `**Last Updated:** YYYY-MM-DD` | ERROR |
| `COMMON_VALID_INDICATOR` | `🔴🟠🟡🟢✅` | ERROR |
| `COMMON_STALE_DATE` | >30 days old | WARNING |

**Type-Specific Rules:**
- **Exploration** - `What We're Exploring`, `Themes`, `Key Questions`
- **Research** - `Research Question`, `Findings`, `Recommendations`
- **ADR** - `Context`, `Decision`, `Consequences`
- **Planning** - `Overview`, `Goals`, `Tasks`
- **Handoff** - `Current State`, `Next Actions`

**Connections:**
- Rule files in `validation-rules/*.yaml` provide machine-readable definitions
- Error format spec provides JSON schema for tooling integration
- Exit codes (0=pass, 1=errors, 2=system) enable CI/CD integration

**Implications:**
- Need YAML parsing in bash (complex but doable with grep/awk)
- Type detection from path OR content (auto-detect vs `--type` override)
- Error output must be actionable (file, line, fix suggestion)

**Concerns:**
- YAML parsing complexity in pure bash
- Unicode handling for emoji status indicators
- Performance target: <200ms per file

---

### Theme 3: Template & Spec Integration

The dev-infra specs provide a complete foundation:

**Template Organization (17 files):**

| Category | Templates | Variables |
|----------|-----------|-----------|
| exploration/ | 3 | `${TOPIC_NAME}`, `${TOPIC_TITLE}`, `${TOPIC_COUNT}` |
| research/ | 4 | `${QUESTION}`, `${QUESTION_NAME}` |
| decision/ | 3 | `${ADR_NUMBER}`, `${DECISION_TITLE}`, `${BATCH_NUMBER}` |
| planning/ | 4 | `${FEATURE_NAME}`, `${PHASE_NUMBER}`, `${PHASE_NAME}` |
| other/ | 3 | `${BATCH_ID}`, `${BRANCH_NAME}`, `${SCOPE}` |

**Validation Rules (6 files):**

| File | Document Types Covered |
|------|------------------------|
| exploration.yaml | exploration, exploration-hub |
| research.yaml | research-topic, research-summary, requirements, research-hub |
| decision.yaml | adr, decisions-summary, decisions-hub |
| planning.yaml | feature-plan, phase, status, planning-hub |
| handoff.yaml | handoff, reflection |
| fix.yaml | fix-batch |

**Connections:**
- Templates use consistent placeholder conventions (FORMAT.md)
- Variables follow naming convention (VARIABLES.md)
- Validation rules reference template sections

**Implications:**
- dt-doc-gen needs template path resolution per category
- dt-doc-validate needs rule file loading per type
- Both need dev-infra path configuration

**Concerns:**
- Keeping dev-toolkit in sync with dev-infra spec changes
- Handling missing templates gracefully
- Rule file format evolution

---

### Theme 4: Dev-Toolkit Architecture Patterns

Building on established patterns for consistency:

**Existing Command Patterns:**

```bash
# Standard structure
bin/dt-command           # CLI entry point
lib/module/              # Library functions
  ├── core-functions.sh  # Main logic
  └── helpers.sh         # Utility functions
```

**Standard Flag Conventions:**

| Flag | Purpose |
|------|---------|
| `--help` | Show usage |
| `--version` | Show version |
| `--debug` | Enable debug output |
| `--json` | JSON output (for dt-doc-validate) |
| `--quiet` | Exit code only (for dt-doc-validate) |
| `--type` | Override auto-detection (for dt-doc-validate) |

**Proposed Architecture:**

```
bin/
├── dt-doc-gen            # Generation CLI
└── dt-doc-validate       # Validation CLI

lib/
├── doc-gen/
│   ├── templates.sh      # Template fetching/caching
│   ├── render.sh         # envsubst-based rendering
│   └── paths.sh          # Output path resolution
└── doc-validate/
    ├── rules.sh          # Rule loading from YAML
    ├── common.sh         # Common validation checks
    └── types.sh          # Type-specific validation
```

**Connections:**
- Reuse patterns from `lib/core/github-utils.sh`
- Follow error handling conventions from existing commands
- Integrate with test framework (bats-core)

**Implications:**
- Each command gets full test coverage (unit + integration)
- Libraries can be sourced independently for reuse
- Debug mode should show rendering/validation steps

**Concerns:**
- Library sourcing path resolution across installations
- Testing templates that depend on external dev-infra
- Mock strategies for template fetching in tests

---

## ❓ Key Questions

### Question 1: How should template fetching work?

**Context:** dt-doc-gen needs access to templates from dev-infra. The templates are authoritative in dev-infra, but dt-doc-gen runs in dev-toolkit (and projects using it).

**Sub-questions:**
- Local dev-infra path (development) vs bundled (production)?
- Environment variable for path override (`$DT_TEMPLATES_PATH`)?
- Should we ever fetch from GitHub releases?
- How to handle missing templates gracefully?

**Research Approach:** Review how similar tools (cookiecutter, yeoman) handle template sources. Document trade-offs of each approach.

---

### Question 2: Can we use native bash envsubst, or need a wrapper?

**Context:** envsubst is the standard tool for variable expansion, but has edge cases.

**Sub-questions:**
- What happens with undefined variables?
- How to handle `$` in template content that shouldn't be expanded?
- Is envsubst available on all target platforms?
- Do we need a fallback implementation?

**Research Approach:** Test envsubst behavior with edge cases. Check availability on macOS, Linux, CI environments.

---

### Question 3: How to parse YAML validation rules in pure bash?

**Context:** Validation rules are defined in YAML files, but dev-toolkit avoids external dependencies.

**Sub-questions:**
- Can we parse simple YAML structure with grep/awk?
- Should we convert YAML to a bash-parseable format at build time?
- Is `yq` acceptable as an optional dependency?
- What's the minimum YAML subset we need to parse?

**Research Approach:** Analyze the YAML rule file structure. Prototype parsing with grep/awk. Evaluate yq as optional enhancement.

---

### Question 4: Should commands auto-detect document type or require explicit `--type`?

**Context:** dt-doc-validate can detect document type from path (e.g., `admin/explorations/` → exploration) or content (e.g., `# ADR-001:` → adr).

**Sub-questions:**
- What's the detection priority (path vs content)?
- How to handle ambiguous cases?
- Should `--type` be required or optional override?
- Performance impact of content-based detection?

**Research Approach:** Map all path patterns and content markers. Define detection algorithm. Test with real documents.

---

### Question 5: How to handle commands evolving independently while sharing infrastructure?

**Context:** dt-doc-gen and dt-doc-validate are part of the same feature but may need independent development and releases.

**Sub-questions:**
- Should they share library code?
- Independent or coordinated versioning?
- How to test interactions between them?
- Release as suite or individual commands?

**Research Approach:** Review dev-toolkit release patterns. Define dependency boundaries. Document integration testing strategy.

---

## 💡 Initial Thoughts

Based on the dev-infra specs, the implementation path is clearer than initially expected. The FORMAT.md provides an unambiguous rendering flow: `envsubst` handles script variables, and AI/EXPAND markers pass through unchanged. This means dt-doc-gen is primarily a template router + envsubst wrapper.

The validation rules in VALIDATION.md are well-structured with consistent patterns. Each rule has: ID, severity, regex pattern, example, error message, and fix suggestion. This maps directly to dt-doc-validate output format.

**Opportunities:**
- **Fast implementation** - Specs are complete, reducing design decisions
- **Testable in isolation** - Each command can be tested independently
- **Integration with CI** - JSON output enables pipeline validation
- **Progressive enhancement** - Start with local templates, add fetching later

**Concerns:**
- **YAML parsing** - Most complex technical challenge for pure bash
- **Template sync** - Keeping dt-doc-validate rules in sync with template changes
- **Path flexibility** - Supporting multiple project structures (dev-infra, template-structure)

---

## 🚀 Next Steps

1. Review research topics in `research-topics.md`
2. Use `/research doc-infrastructure --from-explore doc-infrastructure` to conduct research
3. After research, use `/decision doc-infrastructure --from-research` to make decisions

---

**Last Updated:** 2026-01-16
