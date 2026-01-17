# Research: Error Output Format

**Research Topic:** Doc Infrastructure  
**Question:** What error output format best supports both human readability and tooling integration?  
**Status:** ✅ Complete  
**Priority:** 🟡 Medium  
**Created:** 2026-01-16  
**Completed:** 2026-01-17  
**Last Updated:** 2026-01-17

---

## 🎯 Research Question

What error output format best supports both human readability and tooling integration? VALIDATION.md specifies both text and JSON output formats. Text must be human-readable with clear fix suggestions. JSON must follow a schema for parsing. Exit codes (0/1/2) enable CI integration.

---

## 🔍 Research Goals

- [x] Goal 1: Review error output spec in VALIDATION.md
- [x] Goal 2: Prototype text formatter with color support
- [x] Goal 3: Prototype JSON formatter matching schema
- [x] Goal 4: Test readability with real validation failures
- [x] Goal 5: Ensure fix suggestions are actionable

---

## 📚 Research Methodology

**Note:** Web search is **allowed and encouraged** for research.

**Sources:**
- [x] Source 1: VALIDATION.md error output specification
- [x] Source 2: Existing dev-toolkit output patterns (dt-setup-sourcery)
- [x] Source 3: Similar validation tools (eslint, markdownlint)
- [x] Source 4: Web search: "CLI error output best practices"

---

## 📊 Findings

### Finding 1: Existing dev-toolkit Output Pattern

The `dt-setup-sourcery` command establishes a consistent output pattern:

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

**Key Elements:**
- Color-coded output (RED/YELLOW/GREEN/BLUE)
- Emoji indicators (❌/⚠️/✅/ℹ️)
- Consistent formatting
- Graceful degradation when colors not available

**Source:** `bin/dt-setup-sourcery` lines 24-33

**Relevance:** dt-doc-validate should follow this established pattern.

---

### Finding 2: VALIDATION.md Specifies Comprehensive Error Format

The specification defines a complete error output system:

**Text Format Structure:**
```
[SEVERITY] {message}
  File: {file_path}
  Line: {line_number} (or "not found" if section missing)
  Fix:  {actionable_fix_suggestion}
```

**Example:**
```
[ERROR] Missing required section: ## 📊 Findings
  File: admin/research/my-topic/research-summary.md
  Line: (not found)
  Fix:  Add "## 📊 Findings" section after Research Goals
```

**Severity Levels:**

| Severity | Symbol | Impact |
|----------|--------|--------|
| ERROR | `[ERROR]` | Causes exit code 1 |
| WARNING | `[WARNING]` | Does not affect exit code |

**Source:** VALIDATION.md lines 567-668

**Relevance:** Provides complete specification for text formatter.

---

### Finding 3: JSON Output Format for Machine Parsing

VALIDATION.md defines a JSON schema for tooling integration:

```json
{
  "file": "admin/research/my-topic/research-summary.md",
  "type": "research-summary",
  "passed": false,
  "errors": [
    {
      "code": "MISSING_SECTION",
      "rule_id": "RESEARCH_SUMMARY_REQUIRED_SECTIONS",
      "message": "Missing required section: ## 📊 Findings",
      "line": null,
      "fix": "Add \"## 📊 Findings\" section after Research Goals"
    }
  ],
  "warnings": []
}
```

**Multi-file Summary:**
```json
{
  "summary": {
    "total_files": 3,
    "passed": 1,
    "failed": 2,
    "errors": 1,
    "warnings": 1
  },
  "results": [...]
}
```

**Source:** VALIDATION.md lines 672-786

**Relevance:** Enables CI/CD integration and programmatic processing.

---

### Finding 4: Error Code Convention

All error codes follow the pattern `[CATEGORY]_[SPECIFIC_ERROR]`:

| Error Code | Severity | Trigger |
|------------|----------|---------|
| `MISSING_STATUS_HEADER` | ERROR | No `**Status:**` line found |
| `INVALID_STATUS_INDICATOR` | ERROR | Status emoji not in allowed set |
| `MISSING_CREATED_DATE` | ERROR | No `**Created:**` line found |
| `INVALID_CREATED_DATE` | ERROR | Date not YYYY-MM-DD format |
| `MISSING_SECTION` | ERROR | Required section not found |
| `STALE_LAST_UPDATED` | WARNING | Date >30 days old |
| `TYPE_DETECTION_FAILED` | ERROR | Could not determine document type |
| `FILE_NOT_FOUND` | ERROR | Specified file does not exist |

**Source:** VALIDATION.md lines 586-616

**Relevance:** Consistent error codes enable automation and filtering.

---

### Finding 5: Exit Code Strategy

Standard exit codes for validation tools:

| Exit Code | Meaning | When |
|-----------|---------|------|
| `0` | Success | All files passed (warnings OK) |
| `1` | Validation Error | One or more errors |
| `2` | System Error | Invalid args, file not found |

**Key Logic:**
- Errors → exit 1 (validation failed)
- Warnings only → exit 0 (passed with notes)
- System issues → exit 2 (cannot complete)

**Source:** VALIDATION.md lines 790-801

**Relevance:** Enables CI integration (`&& dt-doc-validate` in scripts).

---

### Finding 6: Fix Suggestions Must Be Actionable

**Guidelines from VALIDATION.md:**

| Guideline | Good Example | Bad Example |
|-----------|--------------|-------------|
| Specific location | `Add "## 📊 Findings" section after Research Goals` | `Add missing section` |
| Exact text | `Change "**Status:** Started" to "**Status:** 🟠 In Progress"` | `Fix status` |
| Format example | `Use format "**Created:** YYYY-MM-DD" (e.g., 2026-01-16)` | `Fix date format` |
| Context aware | `Add "## Context" section after metadata block` | `Add Context section` |

**Source:** VALIDATION.md lines 805-833

**Relevance:** Actionable fixes significantly improve user experience.

---

### Finding 7: Color Support Detection

For terminal color support, check if output is a TTY:

```bash
# Only use colors if terminal supports it
if [[ -t 1 ]] && command -v tput >/dev/null 2>&1; then
    RED='\033[0;31m'
    YELLOW='\033[1;33m'
    GREEN='\033[0;32m'
    BLUE='\033[0;34m'
    NC='\033[0m'  # No Color
else
    RED='' YELLOW='' GREEN='' BLUE='' NC=''
fi
```

**Source:** Common Bash pattern, dev-toolkit conventions

**Relevance:** Colors should gracefully degrade in non-TTY contexts (CI, pipes).

---

## 🔍 Analysis

### Key Insights

- [x] **Insight 1:** Two output modes needed: text (default) and JSON (--json)
- [x] **Insight 2:** Exit codes are critical for CI integration (0/1/2)
- [x] **Insight 3:** Fix suggestions must be actionable and specific
- [x] **Insight 4:** Color support should detect TTY and degrade gracefully
- [x] **Insight 5:** Error codes follow consistent naming convention
- [x] **Insight 6:** Multi-file validation needs summary statistics

### Output Format Comparison

| Aspect | Text Output | JSON Output |
|--------|-------------|-------------|
| Primary Use | Human reading | Machine parsing |
| Colors | Yes (TTY) | No |
| Emojis | Yes | No (symbols in messages) |
| Summary | Bottom of output | `summary` object |
| File info | Inline | Structured |
| Flag | Default | `--json` |

### Implementation Architecture

```bash
# Core formatter functions
format_error_text() {
    local code="$1"
    local message="$2"
    local file="$3"
    local line="$4"
    local fix="$5"
    
    echo -e "${RED}[ERROR]${NC} $message"
    echo "  File: $file"
    echo "  Line: ${line:-not found}"
    echo "  Fix:  $fix"
}

format_error_json() {
    # Build JSON object
    jq -n \
        --arg code "$code" \
        --arg message "$message" \
        --arg file "$file" \
        --argjson line "${line:-null}" \
        --arg fix "$fix" \
        '{code: $code, message: $message, line: $line, fix: $fix}'
}
```

---

## 💡 Recommendations

- [x] **Recommendation 1:** Implement dual output modes (text default, `--json` for machine)
- [x] **Recommendation 2:** Use consistent error code naming (`CATEGORY_SPECIFIC_ERROR`)
- [x] **Recommendation 3:** Detect TTY for color support, gracefully degrade
- [x] **Recommendation 4:** Include file, line, and actionable fix in every error
- [x] **Recommendation 5:** Use emoji indicators matching existing dt-* commands
- [x] **Recommendation 6:** Provide multi-file summary statistics
- [x] **Recommendation 7:** Exit codes: 0=success, 1=validation error, 2=system error

### Prototype Text Formatter

```bash
#!/usr/bin/env bash

# Color detection
setup_colors() {
    if [[ -t 1 ]] && command -v tput >/dev/null 2>&1; then
        RED='\033[0;31m'
        YELLOW='\033[1;33m'
        GREEN='\033[0;32m'
        NC='\033[0m'
    else
        RED='' YELLOW='' GREEN='' NC=''
    fi
}

print_error() {
    local message="$1"
    local file="$2"
    local line="$3"
    local fix="$4"
    
    echo -e "${RED}[ERROR]${NC} $message"
    echo "  File: $file"
    echo "  Line: ${line:-(not found)}"
    echo "  Fix:  $fix"
    echo ""
}

print_warning() {
    local message="$1"
    local file="$2"
    local line="$3"
    local fix="$4"
    
    echo -e "${YELLOW}[WARNING]${NC} $message"
    echo "  File: $file"
    echo "  Line: ${line:-(not found)}"
    echo "  Fix:  $fix"
    echo ""
}

print_summary() {
    local total="$1"
    local passed="$2"
    local errors="$3"
    local warnings="$4"
    
    echo "Summary: $total files, $passed passed, $errors errors, $warnings warnings"
    if [ "$errors" -gt 0 ]; then
        echo -e "Result: ${RED}FAILED${NC}"
    else
        echo -e "Result: ${GREEN}PASSED${NC}"
    fi
}
```

---

## 📋 Requirements Discovered

### Functional Requirements

- [x] **FR-EO1:** dt-doc-validate MUST support text output format (default)
- [x] **FR-EO2:** dt-doc-validate MUST support JSON output format (`--json`)
- [x] **FR-EO3:** Every error MUST include file, message, and fix suggestion
- [x] **FR-EO4:** dt-doc-validate MUST return exit code 0/1/2
- [x] **FR-EO5:** Multi-file validation MUST provide summary statistics
- [x] **FR-EO6:** Error codes MUST follow `CATEGORY_SPECIFIC_ERROR` convention

### Non-Functional Requirements

- [x] **NFR-EO1:** Text output MUST be human-readable without tooling
- [x] **NFR-EO2:** JSON output MUST be valid JSON parseable by jq
- [x] **NFR-EO3:** Color output MUST detect TTY and degrade gracefully
- [x] **NFR-EO4:** Fix suggestions MUST be specific and actionable

### Constraints

- [x] **C-EO1:** ERROR severity causes exit 1; WARNING does not
- [x] **C-EO2:** JSON output disables colors and emoji symbols
- [x] **C-EO3:** Exit code 2 reserved for system errors (not validation)

---

## 🚀 Next Steps

1. ~~Conduct research~~ ✅ Complete
2. Update requirements.md with discovered requirements
3. Implement text formatter with color support
4. Implement JSON formatter matching schema
5. Add summary statistics for multi-file validation
6. Test exit codes in CI context

---

**Last Updated:** 2026-01-17
