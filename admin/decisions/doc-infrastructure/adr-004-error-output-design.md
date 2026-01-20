# ADR-004: Error Output and Exit Code Design

**Status:** ✅ Accepted  
**Created:** 2026-01-20  
**Last Updated:** 2026-01-20

---

## Context

dt-doc-validate needs to report validation errors in a format that serves both human users (readable terminal output) and automated tooling (CI/CD, scripts). Exit codes enable integration with shell scripts and CI pipelines.

**Key Question:** What error output format best supports both human readability and tooling integration?

**Related Research:**
- [Error Output Research](../../research/doc-infrastructure/research-error-output.md)

**Related Requirements:**
- FR-EO1: Text output format (default)
- FR-EO2: JSON output format (`--json`)
- FR-EO4: Exit codes 0/1/2

---

## Decision

**Implement dual output modes (text and JSON) with standardized exit codes.**

### Text Output Format (Default)

```
[ERROR] Missing required section: ## 📊 Findings
  File: admin/research/my-topic/research-summary.md
  Line: (not found)
  Fix:  Add "## 📊 Findings" section after Research Goals

[WARNING] Last updated date is stale (>30 days)
  File: admin/research/my-topic/research-summary.md
  Line: 7
  Fix:  Update "**Last Updated:** YYYY-MM-DD" to current date

Summary: 3 files, 1 passed, 2 failed (1 error, 1 warning)
Result: FAILED
```

### JSON Output Format (`--json`)

```json
{
  "summary": {
    "total_files": 3,
    "passed": 1,
    "failed": 2,
    "errors": 1,
    "warnings": 1
  },
  "results": [
    {
      "file": "admin/research/my-topic/research-summary.md",
      "type": "research_summary",
      "passed": false,
      "errors": [
        {
          "code": "MISSING_SECTION",
          "message": "Missing required section: ## 📊 Findings",
          "line": null,
          "fix": "Add \"## 📊 Findings\" section after Research Goals"
        }
      ],
      "warnings": []
    }
  ]
}
```

### Exit Codes

| Code | Meaning | When |
|------|---------|------|
| `0` | Success | All files passed (warnings OK) |
| `1` | Validation Error | One or more errors found |
| `2` | System Error | Invalid args, file not found, etc. |

### Color Support

```bash
# Only use colors if terminal supports it
if [[ -t 1 ]] && command -v tput >/dev/null 2>&1; then
    RED='\033[0;31m'
    YELLOW='\033[1;33m'
    GREEN='\033[0;32m'
    NC='\033[0m'
else
    RED='' YELLOW='' GREEN='' NC=''
fi
```

---

## Consequences

### Positive

- **Human readable:** Text output is clear without any tooling
- **Machine parseable:** JSON output works with jq, scripts, CI
- **CI integration:** Exit codes enable `&& dt-doc-validate` patterns
- **Actionable fixes:** Every error includes specific fix suggestion
- **Consistent:** Follows existing dev-toolkit output patterns

### Negative

- **Two formatters:** Must maintain both text and JSON output
- **Color complexity:** TTY detection adds code
- **JSON in bash:** Requires careful escaping

### Mitigations

- Shared error data structure, separate formatters
- Color setup in shared library (`lib/core/output-utils.sh`)
- Use printf for JSON construction (avoids jq dependency)

---

## Alternatives Considered

### Alternative 1: Text Only

**Description:** Only support human-readable text output.

**Pros:**
- Simpler implementation
- No JSON escaping issues

**Cons:**
- Can't integrate with automated tools
- Hard to parse in scripts
- No structured data for CI

**Why not chosen:** Modern CLI tools need machine-readable output for automation.

---

### Alternative 2: JSON Only

**Description:** Only support JSON output, use jq for human display.

**Pros:**
- Single format
- Always parseable
- Consistent structure

**Cons:**
- Requires jq for human reading
- Verbose for simple cases
- Poor terminal UX

**Why not chosen:** Most users want readable output without additional tools.

---

### Alternative 3: Custom Format (YAML, TOML)

**Description:** Use YAML or TOML for structured output.

**Pros:**
- More readable than JSON
- Widely supported

**Cons:**
- Less universal than JSON
- Parsing varies by tool
- Bash YAML output is complex

**Why not chosen:** JSON is the standard for CLI tool output. Better ecosystem support.

---

## Decision Rationale

**Key Factors:**

1. **UX First:** Default text output prioritizes human readability
2. **Automation Ready:** JSON mode enables CI/CD integration
3. **Exit Codes:** Critical for shell script integration
4. **Consistency:** Matches existing dev-toolkit command patterns
5. **Actionable:** Fix suggestions must be specific and helpful

**Research Support:**
- Finding 1: "dev-toolkit already has consistent output patterns"
- Finding 2: "VALIDATION.md specifies comprehensive error format"
- Insight 1: "Two output modes needed: text (default) and JSON"
- Insight 2: "Exit codes are critical for CI integration"

---

## Requirements Impact

**Requirements Addressed:**
- FR-EO1: Text output format ✅
- FR-EO2: JSON output format ✅
- FR-EO3: File, message, and fix in every error ✅
- FR-EO4: Exit codes 0/1/2 ✅
- FR-EO5: Multi-file summary statistics ✅
- FR-EO6: Error code convention (`CATEGORY_SPECIFIC_ERROR`) ✅
- NFR-EO1: Human-readable text ✅
- NFR-EO2: Valid JSON parseable by jq ✅
- NFR-EO3: Color output with TTY detection ✅
- NFR-EO4: Actionable fix suggestions ✅

**Constraints Acknowledged:**
- C-EO1: ERROR causes exit 1, WARNING does not
- C-EO2: JSON mode disables colors/emoji
- C-EO3: Exit code 2 for system errors only

---

## References

- [Error Output Research](../../research/doc-infrastructure/research-error-output.md)
- [Requirements Document](../../research/doc-infrastructure/requirements.md)
- [dev-infra VALIDATION.md](~/Projects/dev-infra/scripts/doc-gen/templates/VALIDATION.md)

---

**Last Updated:** 2026-01-20
