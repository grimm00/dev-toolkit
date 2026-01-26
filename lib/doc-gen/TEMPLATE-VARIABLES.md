# Template Variable Contract

**Purpose:** Explicit documentation of all template variables used in dt-doc-gen templates  
**Status:** ✅ Active  
**Last Updated:** 2026-01-26  
**Related:** FR-27, ADR-003

---

## Overview

This document provides a complete reference for all template variables used across different document types. Variables are set via category-specific setter functions and expanded using `envsubst` during template rendering.

**Variable Expansion:** Variables use selective expansion per ADR-003 - only variables explicitly listed in `DT_*_VARS` are expanded, preventing accidental variable substitution.

---

## Universal Variables

These variables are available in all template types and are set by `dt_set_common_vars()`.

| Variable | Description | Default | Setter Function |
|----------|-------------|---------|-----------------|
| `${DATE}` | Current date in ISO format (YYYY-MM-DD) | `$(date +%Y-%m-%d)` | `dt_set_common_vars` |
| `${STATUS}` | Document status indicator | `🔴 Not Started` | `dt_set_common_vars` |
| `${PURPOSE}` | Brief description of document purpose | `[Purpose TBD]` or auto-generated | `dt_set_common_vars` (can be overridden) |

**Usage Example:**
```bash
dt_set_common_vars
# Sets: DATE="2026-01-26", STATUS="🔴 Not Started", PURPOSE="[Purpose TBD]"
```

---

## Exploration Variables

Variables used in exploration templates (`exploration/exploration.md.tmpl`, `exploration/research-topics.md.tmpl`).

**Setter Function:** `dt_set_exploration_vars(topic_name, purpose)`

| Variable | Description | Default | Setter Function |
|----------|-------------|---------|-----------------|
| `${TOPIC_NAME}` | Kebab-case topic name (e.g., "my-topic") | Required parameter | `dt_set_exploration_vars` |
| `${TOPIC_TITLE}` | Title-case version of topic name (e.g., "My Topic") | Auto-generated from `TOPIC_NAME` | `dt_set_exploration_vars` |

**Complete Variable List:** `${DATE} ${STATUS} ${TOPIC_NAME} ${TOPIC_TITLE} ${PURPOSE}`

**Usage Example:**
```bash
dt_set_exploration_vars "my-topic" "Exploration of my topic"
# Sets: TOPIC_NAME="my-topic", TOPIC_TITLE="My Topic", PURPOSE="Exploration of my topic"
# Also sets universal vars: DATE, STATUS
```

---

## Research Variables

Variables used in research templates (`research/research-topic.md.tmpl`, `research/research-summary.md.tmpl`).

**Setter Function:** `dt_set_research_vars(topic_name, question, purpose, topic_count, doc_count)`

| Variable | Description | Default | Setter Function |
|----------|-------------|---------|-----------------|
| `${TOPIC_NAME}` | Kebab-case topic name | Required parameter | `dt_set_research_vars` |
| `${TOPIC_TITLE}` | Title-case version of topic name | Auto-generated from `TOPIC_NAME` | `dt_set_research_vars` |
| `${QUESTION}` | Full research question text | `Research Question TBD` | `dt_set_research_vars` |
| `${QUESTION_NAME}` | Human-readable question name (spaces instead of dashes) | Auto-generated from `TOPIC_NAME` | `dt_set_research_vars` |
| `${TOPIC_COUNT}` | Number of research topics | `0` | `dt_set_research_vars` |
| `${DOC_COUNT}` | Number of research documents | `0` | `dt_set_research_vars` |

**Complete Variable List:** `${DATE} ${STATUS} ${TOPIC_NAME} ${TOPIC_TITLE} ${QUESTION} ${QUESTION_NAME} ${PURPOSE} ${TOPIC_COUNT} ${DOC_COUNT}`

**Usage Example:**
```bash
dt_set_research_vars "my-topic" "What is the best approach?" "Research for my topic" 3 5
# Sets: TOPIC_NAME="my-topic", TOPIC_TITLE="My Topic", QUESTION="What is the best approach?"
#       QUESTION_NAME="my topic", TOPIC_COUNT=3, DOC_COUNT=5
# Also sets universal vars: DATE, STATUS, PURPOSE
```

---

## Decision Variables

Variables used in decision templates (`decision/adr.md.tmpl`, `decision/decisions-summary.md.tmpl`).

**Setter Function:** `dt_set_decision_vars(topic_name, adr_number, decision_title, purpose, decision_count, batch_number)`

| Variable | Description | Default | Setter Function |
|----------|-------------|---------|-----------------|
| `${TOPIC_NAME}` | Kebab-case topic name | Required parameter | `dt_set_decision_vars` |
| `${TOPIC_TITLE}` | Title-case version of topic name | Auto-generated from `TOPIC_NAME` | `dt_set_decision_vars` |
| `${ADR_NUMBER}` | ADR number (e.g., "006") | Required parameter | `dt_set_decision_vars` |
| `${DECISION_TITLE}` | Title of the decision | Required parameter | `dt_set_decision_vars` |
| `${DECISION_COUNT}` | Number of decisions | `0` | `dt_set_decision_vars` |
| `${BATCH_NUMBER}` | Decision batch number | `1` | `dt_set_decision_vars` |

**Complete Variable List:** `${DATE} ${STATUS} ${TOPIC_NAME} ${TOPIC_TITLE} ${ADR_NUMBER} ${DECISION_TITLE} ${PURPOSE} ${DECISION_COUNT} ${BATCH_NUMBER}`

**Usage Example:**
```bash
dt_set_decision_vars "my-topic" "006" "Use Template System" "Decisions for my topic" 5 1
# Sets: TOPIC_NAME="my-topic", TOPIC_TITLE="My Topic", ADR_NUMBER="006"
#       DECISION_TITLE="Use Template System", DECISION_COUNT=5, BATCH_NUMBER=1
# Also sets universal vars: DATE, STATUS, PURPOSE
```

---

## Planning Variables

Variables used in planning templates (`planning/feature-plan.md.tmpl`, `planning/phase.md.tmpl`).

**Setter Function:** `dt_set_planning_vars(feature_name, phase_number, phase_name, purpose)`

| Variable | Description | Default | Setter Function |
|----------|-------------|---------|-----------------|
| `${FEATURE_NAME}` | Feature name (kebab-case) | Required parameter | `dt_set_planning_vars` |
| `${PHASE_NUMBER}` | Phase number (e.g., "1", "2") | `1` | `dt_set_planning_vars` |
| `${PHASE_NAME}` | Phase name/description | Required parameter | `dt_set_planning_vars` |

**Complete Variable List:** `${DATE} ${STATUS} ${FEATURE_NAME} ${PHASE_NUMBER} ${PHASE_NAME} ${PURPOSE}`

**Usage Example:**
```bash
dt_set_planning_vars "my-feature" "2" "Implementation Phase" "Planning for my feature"
# Sets: FEATURE_NAME="my-feature", PHASE_NUMBER="2", PHASE_NAME="Implementation Phase"
# Also sets universal vars: DATE, STATUS, PURPOSE
```

---

## Other Variables

Variables used in other document types (`other/handoff.md.tmpl`, `other/reflection.md.tmpl`).

**Setter Function:** Uses `dt_set_common_vars()` plus manual `TOPIC_NAME` export if needed.

| Variable | Description | Default | Setter Function |
|----------|-------------|---------|-----------------|
| `${TOPIC_NAME}` | Kebab-case topic name | Manual export if needed | Manual or category-specific setter |

**Complete Variable List:** `${DATE} ${STATUS} ${TOPIC_NAME} ${PURPOSE}`

---

## Variable Expansion Mechanism

Variables are expanded using `envsubst` with selective variable lists per ADR-003:

```bash
# Get variables for document type
vars=$(dt_get_template_vars "exploration")

# Selective expansion - only listed variables
envsubst "$vars" < "$template" > "$output"
```

**Security Note:** Selective expansion prevents accidental substitution of environment variables not explicitly listed, improving security and predictability.

---

## Setter Function Reference

### `dt_set_common_vars()`
Sets universal variables: `DATE`, `STATUS`, `PURPOSE`

### `dt_set_exploration_vars(topic_name, purpose)`
Sets exploration-specific variables. Calls `dt_set_common_vars()` internally.

**Parameters:**
- `topic_name` (required) - Kebab-case topic name
- `purpose` (optional) - Document purpose, defaults to "Exploration of $topic_name"

### `dt_set_research_vars(topic_name, question, purpose, topic_count, doc_count)`
Sets research-specific variables. Calls `dt_set_common_vars()` internally.

**Parameters:**
- `topic_name` (required) - Kebab-case topic name
- `question` (optional) - Research question, defaults to "Research Question TBD"
- `purpose` (optional) - Document purpose, defaults to "Research for $topic_name"
- `topic_count` (optional) - Number of topics, defaults to `0`
- `doc_count` (optional) - Number of documents, defaults to `0`

### `dt_set_decision_vars(topic_name, adr_number, decision_title, purpose, decision_count, batch_number)`
Sets decision-specific variables. Calls `dt_set_common_vars()` internally.

**Parameters:**
- `topic_name` (required) - Kebab-case topic name
- `adr_number` (required) - ADR number (e.g., "006")
- `decision_title` (required) - Title of the decision
- `purpose` (optional) - Document purpose, defaults to "Decisions for $topic_name"
- `decision_count` (optional) - Number of decisions, defaults to `0`
- `batch_number` (optional) - Batch number, defaults to `1`

### `dt_set_planning_vars(feature_name, phase_number, phase_name, purpose)`
Sets planning-specific variables. Calls `dt_set_common_vars()` internally.

**Parameters:**
- `feature_name` (required) - Feature name (kebab-case)
- `phase_number` (optional) - Phase number, defaults to `1`
- `phase_name` (required) - Phase name/description
- `purpose` (optional) - Document purpose, auto-generated if not provided

---

## Usage Examples

### Example 1: Exploration Document

```bash
# Set variables
dt_set_exploration_vars "api-design" "Exploring API design patterns"

# Render template
template_path="$TEMPLATES_DIR/exploration/exploration.md.tmpl"
dt_render_template "$template_path" "$output_file" "exploration"
```

**Result:** Template rendered with `TOPIC_NAME="api-design"`, `TOPIC_TITLE="Api Design"`, etc.

### Example 2: Research Document

```bash
# Set variables
dt_set_research_vars "api-design" "What patterns should we use?" "Research for API design" 3 5

# Render template
template_path="$TEMPLATES_DIR/research/research-topic.md.tmpl"
dt_render_template "$template_path" "$output_file" "research_topic"
```

**Result:** Template rendered with all research variables set.

### Example 3: Decision Document (ADR)

```bash
# Set variables
dt_set_decision_vars "api-design" "006" "Use REST API Pattern" "Decisions for API design" 5 1

# Render template
template_path="$TEMPLATES_DIR/decision/adr.md.tmpl"
dt_render_template "$template_path" "$output_file" "adr"
```

**Result:** Template rendered with `ADR_NUMBER="006"`, `DECISION_TITLE="Use REST API Pattern"`, etc.

---

## Validation

To verify all variables are documented:

```bash
# Run validation tests
bats tests/unit/test-template-variables-doc.bats
```

Tests verify:
- Documentation file exists
- All variable categories are documented
- All variables from `render.sh` are documented
- Setter functions are referenced
- Variable descriptions are present

---

## Related

- **ADR-003:** Selective Variable Expansion
- **FR-27:** Template Variable Documentation
- **render.sh:** Implementation of variable setters and expansion
- **templates.sh:** Template discovery and path resolution

---

**Last Updated:** 2026-01-26
