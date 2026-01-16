# Research Topics - Doc Infrastructure

**Status:** ✅ Expanded  
**Created:** 2026-01-16  
**Expanded:** 2026-01-16

---

## 📋 Research Topics

### Topic 1: Template Fetching Strategy

**Question:** How should dt-doc-gen locate and fetch templates from dev-infra?

**Context:** The 17 templates live in dev-infra's `scripts/doc-gen/templates/` directory. dt-doc-gen needs to access these templates but shouldn't require dev-infra to be cloned in a specific location. This is a foundational decision that affects installation, development, and CI workflows.

**Priority:** High

**Rationale:** This is blocking for dt-doc-gen implementation. Wrong choice here creates friction for users and maintenance burden.

**Suggested Approach:**
- Document template source options (local path, bundled, GitHub fetch)
- Evaluate trade-offs: simplicity vs flexibility vs maintenance
- Prototype environment variable approach (`$DT_TEMPLATES_PATH`)
- Consider version pinning strategy if fetching remotely

---

### Topic 2: YAML Parsing in Bash

**Question:** How to parse validation-rules/*.yaml files in pure bash without external dependencies?

**Context:** The 6 YAML validation rule files define required sections, patterns, and error messages for each document type. dev-toolkit's core principle is "zero dependencies" for core features, but YAML parsing in pure bash is notoriously complex.

**Priority:** High

**Rationale:** YAML parsing is the most technically challenging aspect of dt-doc-validate. Need to determine feasibility before committing to architecture.

**Suggested Approach:**
- Analyze actual YAML structure in validation-rules/*.yaml
- Prototype grep/awk parser for the specific YAML subset used
- Evaluate yq as optional dependency (graceful degradation)
- Consider build-time conversion to bash-native format

---

### Topic 3: Document Type Detection

**Question:** Should validation auto-detect document type from path/content, or require explicit `--type` flag?

**Context:** dt-doc-validate needs to know the document type to apply correct rules. VALIDATION.md describes both path-based detection (`admin/explorations/` → exploration) and content-based detection (`# ADR-001:` → adr). The CLI spec shows `--type` as an override option.

**Priority:** Medium

**Rationale:** Good auto-detection improves UX significantly. Bad auto-detection causes frustrating false positives. Need to define the detection algorithm clearly.

**Suggested Approach:**
- Map all path patterns from VALIDATION.md
- Map all content patterns (title formats, section headers)
- Define detection priority (path first, content fallback)
- Document cases where `--type` is required
- Test detection against real documents in dev-infra and dev-toolkit

---

### Topic 4: Variable Expansion Edge Cases

**Question:** What edge cases exist with envsubst, and do we need custom handling?

**Context:** envsubst is simple and portable, but has known edge cases: undefined variables become empty, `$` in content gets expanded, shell special characters may cause issues. The 29 variables in VARIABLES.md need reliable expansion.

**Priority:** Medium

**Rationale:** Edge cases in generation cause broken documents. Need to understand envsubst behavior and document mitigation strategies.

**Suggested Approach:**
- Test envsubst with undefined variables
- Test with `$` characters in template content
- Test with special characters in variable values
- Check envsubst availability on macOS, Linux, CI environments
- Document required/optional variables per template

---

### Topic 5: Error Output Format

**Question:** What error output format best supports both human readability and tooling integration?

**Context:** VALIDATION.md specifies both text and JSON output formats. Text must be human-readable with clear fix suggestions. JSON must follow a schema for parsing. Exit codes (0/1/2) enable CI integration.

**Priority:** Medium

**Rationale:** Error output is the primary user interface for dt-doc-validate. Poor error messages create frustration and reduce adoption.

**Suggested Approach:**
- Review error output spec in VALIDATION.md
- Prototype text formatter with color support
- Prototype JSON formatter matching schema
- Test readability with real validation failures
- Ensure fix suggestions are actionable

---

### Topic 6: Shared Infrastructure Design

**Question:** How should dt-doc-gen and dt-doc-validate share code while evolving independently?

**Context:** Both commands need: path detection, dev-infra location, debug output, help formatting. However, they serve different purposes and may need independent releases. Over-sharing creates coupling; under-sharing creates duplication.

**Priority:** Low

**Rationale:** Infrastructure sharing is an optimization. Can be deferred until both commands exist.

**Suggested Approach:**
- List common functionality between commands
- Evaluate existing lib/core/ utilities for reuse
- Define boundary: what's shared vs command-specific
- Document versioning strategy (monorepo-style or independent)

---

## 🎯 Research Workflow

1. Use `/research doc-infrastructure --from-explore doc-infrastructure` to start research
2. Research will create documents in `admin/research/doc-infrastructure/`
3. Focus on Topic 1 (Template Fetching) and Topic 2 (YAML Parsing) first - these are blocking
4. After research complete, use `/decision doc-infrastructure --from-research`

---

## 📊 Research Priority Matrix

| Topic | Priority | Blocking? | Estimated Effort |
|-------|----------|-----------|------------------|
| Template Fetching Strategy | High | Yes (dt-doc-gen) | 1-2 hours |
| YAML Parsing in Bash | High | Yes (dt-doc-validate) | 2-3 hours |
| Document Type Detection | Medium | No | 1 hour |
| Variable Expansion Edge Cases | Medium | No | 1 hour |
| Error Output Format | Medium | No | 1 hour |
| Shared Infrastructure Design | Low | No | 30 min |

**Total Estimated Research Time:** 6-8 hours

---

**Last Updated:** 2026-01-16
