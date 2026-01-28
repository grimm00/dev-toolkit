# Research: Variable Expansion Edge Cases

**Research Topic:** Doc Infrastructure  
**Question:** What edge cases exist with envsubst, and do we need custom handling?  
**Status:** ✅ Complete  
**Priority:** 🟡 Medium  
**Created:** 2026-01-16  
**Completed:** 2026-01-17  
**Last Updated:** 2026-01-17

---

## 🎯 Research Question

What edge cases exist with envsubst, and do we need custom handling? envsubst is simple and portable, but has known edge cases: undefined variables become empty, `$` in content gets expanded, shell special characters may cause issues.

---

## 🔍 Research Goals

- [x] Goal 1: Test envsubst with undefined variables
- [x] Goal 2: Test with `$` characters in template content
- [x] Goal 3: Test with special characters in variable values
- [x] Goal 4: Check envsubst availability on macOS, Linux, CI environments
- [x] Goal 5: Document required/optional variables per template

---

## 📚 Research Methodology

**Note:** Web search is **allowed and encouraged** for research.

**Sources:**
- [x] Source 1: envsubst man page and documentation
- [x] Source 2: VARIABLES.md from dev-infra (29 variables)
- [x] Source 3: Practical testing with edge cases
- [x] Source 4: Web search: "envsubst edge cases limitations"

---

## 📊 Findings

### Finding 1: Undefined Variables Become Empty (Full Mode) or Preserved (Selective Mode)

**Testing Results:**

```bash
# Full mode (no variable list)
echo '${UNDEFINED} and ${DEFINED}' | envsubst
# Output: " and hello"  (undefined becomes empty!)

# Selective mode (explicit variable list)
echo '${UNDEFINED} and ${DEFINED}' | envsubst '${DEFINED}'
# Output: "${UNDEFINED} and hello"  (undefined preserved!)
```

**Key Insight:** Using selective mode (`envsubst '${VAR1} ${VAR2}'`) is CRITICAL for safe template expansion. It only expands listed variables and preserves all others.

**Source:** Practical testing on macOS with envsubst 0.26

**Relevance:** dt-doc-gen MUST use selective mode to avoid accidentally emptying variables that aren't set.

---

### Finding 2: Dollar Signs in Content Are Handled Correctly

**Testing Results:**

```bash
# Template content
echo 'Price is $100 and ${VAR}' | envsubst '${VAR}'
# Output: "Price is $100 and value"  ✅ $100 preserved!

# In code blocks
echo 'export MY_VAR=${OTHER_VAR}' | envsubst '${TOPIC}'
# Output: "export MY_VAR=${OTHER_VAR}"  ✅ Preserved!
```

**Key Insight:** `$VAR` (without braces) is NOT expanded by envsubst. Only `${VAR}` syntax is expanded. This means:
- `$100` in text → preserved ✅
- `$VAR` in code examples → preserved ✅
- `${VAR}` → expanded (if in variable list)

**Source:** Practical testing

**Relevance:** Template content with dollar signs (prices, shell examples) is safe.

---

### Finding 3: Special Characters in Variable Values Work Correctly

**Testing Results:**

```bash
export QUOTES='He said "hello"'
export NEWLINES=$'line1\nline2'
export BACKSLASH='path\\to\\file'
export EMOJI="🔴 Scaffolding"

# All expand correctly
echo '${QUOTES}' | envsubst '${QUOTES}'
# Output: He said "hello"  ✅

echo '${EMOJI}' | envsubst '${EMOJI}'
# Output: 🔴 Scaffolding  ✅
```

**Key Insight:** envsubst handles:
- Quotes in values ✅
- Newlines in values ✅ (but may affect markdown formatting)
- Backslashes ✅
- Unicode/emoji ✅

**Source:** Practical testing

**Relevance:** Status emojis (🔴🟠🟡🟢✅) work correctly.

---

### Finding 4: Backslash Escape Does NOT Work

**Testing Results:**

```bash
echo 'Escaped: \${VAR}' | envsubst '${VAR}'
# Output: "Escaped: \value"  ❌ Still expanded!
```

**Key Insight:** Backslash escaping does NOT prevent expansion. The only way to preserve a `${VAR}` pattern is to NOT include it in the variable list.

**Source:** Practical testing

**Relevance:** If templates need to document `${VAR}` syntax, use selective mode and don't include that variable.

---

### Finding 5: envsubst Availability Across Platforms

**Platform Analysis:**

| Platform | envsubst Available | Package |
|----------|-------------------|---------|
| **macOS** | Via Homebrew | `brew install gettext` |
| **Ubuntu/Debian** | Pre-installed | `gettext-base` |
| **Alpine Linux** | Via apk | `apk add gettext` |
| **RHEL/CentOS** | Pre-installed | `gettext` |
| **GitHub Actions** | Pre-installed | Ubuntu runners have it |
| **Docker** | Depends on base image | Alpine needs explicit install |

**macOS Note:** envsubst is NOT pre-installed on macOS. Requires `brew install gettext` and may need PATH configuration.

**Source:** Platform documentation, practical testing

**Relevance:** dt-doc-gen should check for envsubst and provide helpful error if missing.

---

### Finding 6: HTML Comments (AI Markers) Are Preserved

**Testing Results:**

```bash
echo '<!-- AI: This should be preserved -->' | envsubst '${VAR}'
# Output: "<!-- AI: This should be preserved -->"  ✅
```

**Key Insight:** HTML comments pass through envsubst unchanged, which is exactly what we need for `<!-- AI: -->` and `<!-- EXPAND: -->` markers.

**Source:** Practical testing

**Relevance:** Two-mode generation works correctly with envsubst.

---

### Finding 7: 29 Variables Categorized by Template Type

**From VARIABLES.md analysis:**

| Category | Variables | Required For |
|----------|-----------|--------------|
| **Universal** | `${DATE}`, `${STATUS}`, `${PURPOSE}` | All templates |
| **Exploration** | `${TOPIC_NAME}`, `${TOPIC_TITLE}`, `${TOPIC_COUNT}` | Exploration templates |
| **Research** | `${QUESTION}`, `${QUESTION_NAME}` | Research templates |
| **Decision** | `${ADR_NUMBER}`, `${DECISION_TITLE}`, `${BATCH_NUMBER}` | ADR templates |
| **Planning** | `${FEATURE_NAME}`, `${PHASE_NUMBER}`, `${PHASE_NAME}` | Planning templates |
| **Fix/Handoff** | `${BATCH_ID}`, `${BRANCH_NAME}`, `${WORKTREE_NAME}` | Fix/handoff templates |
| **Metrics** | `${TOPIC_COUNT}`, `${DECISION_COUNT}`, `${DOC_COUNT}` | Hub templates |

**Source:** VARIABLES.md analysis

**Relevance:** dt-doc-gen needs to know which variables are required for each template type.

---

## 🔍 Analysis

### Key Insights

- [x] **Insight 1:** Selective mode (`envsubst '${VAR1} ${VAR2}'`) is MANDATORY for safe expansion
- [x] **Insight 2:** `$VAR` (no braces) is NOT expanded - only `${VAR}` syntax
- [x] **Insight 3:** Backslash escaping does NOT work - use selective mode instead
- [x] **Insight 4:** Unicode/emoji work correctly (important for status indicators)
- [x] **Insight 5:** HTML comments pass through unchanged (AI markers preserved)
- [x] **Insight 6:** envsubst not pre-installed on macOS - need dependency check

### Edge Case Summary

| Edge Case | Behavior | Mitigation |
|-----------|----------|------------|
| Undefined variable (full mode) | Becomes empty string | Use selective mode |
| Undefined variable (selective) | Preserved as `${VAR}` | ✅ Safe |
| `$100` in text | Preserved | ✅ Safe |
| `${VAR}` in code block | Expanded if in list | Don't include in list |
| Quotes in value | Works correctly | ✅ Safe |
| Newlines in value | Works (may affect formatting) | Avoid multi-line values |
| Emoji in value | Works correctly | ✅ Safe |
| `\${VAR}` escape | Does NOT work | Use selective mode |

### Recommended Implementation Pattern

```bash
render_template() {
    local template="$1"
    local output="$2"
    local variables="$3"  # e.g., '${DATE} ${TOPIC_TITLE} ${STATUS}'
    
    # Export required variables
    export DATE=$(date +%Y-%m-%d)
    export TOPIC_TITLE="$topic_title"
    export STATUS="🔴 Scaffolding"
    
    # Use SELECTIVE mode - only expand listed variables
    envsubst "$variables" < "$template" > "$output"
}
```

---

## 💡 Recommendations

- [x] **Recommendation 1:** ALWAYS use selective mode (`envsubst '${VAR1} ${VAR2}'`)
- [x] **Recommendation 2:** Define required variables per template type in code
- [x] **Recommendation 3:** Check for envsubst availability at startup with helpful error
- [x] **Recommendation 4:** Avoid multi-line variable values (use AI markers instead)
- [x] **Recommendation 5:** Document that `$VAR` (no braces) is safe in templates
- [x] **Recommendation 6:** Provide fallback or installation instructions for macOS

### Variable List Per Template Type

```bash
# Exploration templates
EXPLORATION_VARS='${DATE} ${STATUS} ${TOPIC_NAME} ${TOPIC_TITLE} ${TOPIC_COUNT}'

# Research templates
RESEARCH_VARS='${DATE} ${STATUS} ${TOPIC_NAME} ${TOPIC_TITLE} ${QUESTION} ${QUESTION_NAME}'

# Decision templates
DECISION_VARS='${DATE} ${STATUS} ${TOPIC_NAME} ${ADR_NUMBER} ${DECISION_TITLE} ${BATCH_NUMBER}'

# Planning templates
PLANNING_VARS='${DATE} ${STATUS} ${FEATURE_NAME} ${PHASE_NUMBER} ${PHASE_NAME} ${ESTIMATED_TIME}'
```

---

## 📋 Requirements Discovered

### Functional Requirements

- [x] **FR-VE1:** dt-doc-gen MUST use selective envsubst mode (explicit variable list)
- [x] **FR-VE2:** dt-doc-gen MUST define required variables per template type
- [x] **FR-VE3:** dt-doc-gen MUST check for envsubst availability at startup
- [x] **FR-VE4:** dt-doc-gen MUST provide helpful error if envsubst is missing
- [x] **FR-VE5:** dt-doc-gen MUST export all required variables before expansion

### Non-Functional Requirements

- [x] **NFR-VE1:** Variable expansion MUST preserve `$VAR` syntax (no braces)
- [x] **NFR-VE2:** Variable expansion MUST preserve HTML comments (AI markers)
- [x] **NFR-VE3:** Variable expansion MUST handle Unicode/emoji correctly

### Constraints

- [x] **C-VE1:** envsubst requires gettext package (not pre-installed on macOS)
- [x] **C-VE2:** Backslash escaping does NOT work - must use selective mode
- [x] **C-VE3:** Multi-line variable values may affect markdown formatting

---

## 🚀 Next Steps

1. ~~Conduct research~~ ✅ Complete
2. Update requirements.md with discovered requirements
3. Implement selective envsubst in dt-doc-gen
4. Add envsubst availability check with helpful error
5. Define variable lists per template type

---

**Last Updated:** 2026-01-17
