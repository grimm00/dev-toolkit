# ADR-006: Document Type Detection Strategy

**Status:** ✅ Accepted  
**Created:** 2026-01-20  
**Last Updated:** 2026-01-20

---

## Context

dt-doc-validate must determine the document type to apply the correct validation rules. There are 17 document subtypes across 5 categories. Documents can be identified by their file path (e.g., `admin/explorations/*/exploration.md`) or by content patterns (e.g., `# ADR-001:` heading).

**Key Question:** Should dt-doc-validate auto-detect document type from path/content, or require explicit `--type` flag?

**Related Research:**
- [Type Detection Research](../../research/doc-infrastructure/research-type-detection.md)

**Related Requirements:**
- FR-TD1: `--type` flag for explicit override
- FR-TD2: Path-based type detection
- FR-TD3: Content-based fallback detection

**Backward Compatibility:**
- Some projects use `admin/` directory (legacy/dev-infra style)
- Newer projects may use `docs/maintainers/` directory
- Detection must support both with `admin/` taking priority

---

## Decision

**Implement auto-detection with explicit override. Priority: `--type` flag → path-based → content-based → error.**

### Detection Priority

```
1. --type flag (explicit)    → Highest priority, always wins
2. Path-based detection      → Primary auto-detect method
3. Content-based detection   → Fallback for non-standard locations
4. TYPE_DETECTION_FAILED     → Clear error with available types
```

### Path Pattern Mapping (17 subtypes)

| Path Pattern | Document Type |
|--------------|---------------|
| `*/explorations/*/exploration.md` | exploration |
| `*/explorations/*/research-topics.md` | research_topics |
| `*/explorations/*/README.md` | exploration_hub |
| `*/research/*/research-summary.md` | research_summary |
| `*/research/*/requirements.md` | requirements |
| `*/research/*/README.md` | research_hub |
| `*/research/*/research-*.md` | research_topic |
| `*/decisions/*/adr-*.md` | adr |
| `*/decisions/*/decisions-summary.md` | decisions_summary |
| `*/decisions/*/README.md` | decisions_hub |
| `*/planning/features/*/feature-plan.md` | feature_plan |
| `*/planning/features/*/phase-*.md` | phase |
| `*/planning/features/*/status-and-next-steps.md` | status_and_next_steps |
| `*/planning/features/*/README.md` | planning_hub |
| `*/planning/fix/fix-batch-*.md` | fix_batch |
| `*/handoff*.md` | handoff |
| `*/reflection*.md` | reflection |

### Project Structure Detection (Backward Compatibility)

Projects may use different directory structures for planning/documentation:

| Structure | Root Directory | Example Path |
|-----------|---------------|--------------|
| **Legacy (admin)** | `admin/` | `admin/decisions/my-topic/adr-001.md` |
| **Modern (docs)** | `docs/maintainers/` | `docs/maintainers/decisions/my-topic/adr-001.md` |

**Detection Priority:** Check `admin/` first for backward compatibility with existing projects.

```bash
dt_detect_project_structure() {
    # Check for admin directory (legacy/dev-infra style) FIRST
    if [ -d "admin/explorations" ] || [ -d "admin/research" ] || [ -d "admin/decisions" ] || [ -d "admin/planning" ]; then
        echo "admin"
        return 0
    fi
    
    # Check for docs/maintainers directory (modern style)
    if [ -d "docs/maintainers/explorations" ] || [ -d "docs/maintainers/research" ] || [ -d "docs/maintainers/decisions" ]; then
        echo "docs/maintainers"
        return 0
    fi
    
    # Default to admin (will be created if needed)
    echo "admin"
    return 0
}

dt_get_docs_root() {
    local structure
    structure=$(dt_detect_project_structure)
    echo "$structure"
}
```

**Usage in path resolution:**
```bash
# Instead of hardcoded paths, use detected structure
DOCS_ROOT=$(dt_get_docs_root)
EXPLORATIONS_DIR="$DOCS_ROOT/explorations"
RESEARCH_DIR="$DOCS_ROOT/research"
DECISIONS_DIR="$DOCS_ROOT/decisions"
PLANNING_DIR="$DOCS_ROOT/planning"
```

### Implementation

```bash
detect_document_type() {
    local file_path=$1
    local explicit_type=${2:-}
    
    # 1. Explicit type override (highest priority)
    if [ -n "$explicit_type" ]; then
        echo "$explicit_type"
        return 0
    fi
    
    # 2. Path-based detection (ordered most to least specific)
    case "$file_path" in
        */explorations/*/exploration.md)     echo "exploration" ;;
        */explorations/*/research-topics.md) echo "research_topics" ;;
        */explorations/*/README.md)          echo "exploration_hub" ;;
        */research/*/research-summary.md)    echo "research_summary" ;;
        */research/*/requirements.md)        echo "requirements" ;;
        */research/*/README.md)              echo "research_hub" ;;
        */research/*/research-*.md)          echo "research_topic" ;;
        */decisions/*/adr-*.md)              echo "adr" ;;
        */decisions/*/decisions-summary.md)  echo "decisions_summary" ;;
        */decisions/*/README.md)             echo "decisions_hub" ;;
        */planning/features/*/feature-plan.md) echo "feature_plan" ;;
        */planning/features/*/phase-*.md)    echo "phase" ;;
        */planning/features/*/status-and-next-steps.md) echo "status_and_next_steps" ;;
        */planning/features/*/README.md)     echo "planning_hub" ;;
        */planning/fix/fix-batch-*.md)       echo "fix_batch" ;;
        */handoff*.md)                       echo "handoff" ;;
        */reflection*.md)                    echo "reflection" ;;
        *)
            # 3. Content-based fallback
            detect_from_content "$file_path"
            ;;
    esac
}

detect_from_content() {
    local file=$1
    
    # Check distinctive patterns
    if grep -q "^# ADR-[0-9]" "$file"; then
        echo "adr"
    elif grep -q "^## 🎯 What We're Exploring" "$file"; then
        echo "exploration"
    elif grep -q "^## 🎯 Research Question" "$file"; then
        echo "research_topic"
    elif grep -q "^## ✅ Functional Requirements" "$file"; then
        echo "requirements"
    else
        # 4. Detection failed
        return 1
    fi
}
```

### Error Handling

```
[ERROR] TYPE_DETECTION_FAILED
  File: docs/my-document.md
  Message: Could not determine document type from path or content
  Fix: Use --type <type> to specify document type explicitly
  
  Available types:
    exploration, research_topics, exploration_hub, research_topic,
    research_summary, requirements, research_hub, adr, decisions_summary,
    decisions_hub, feature_plan, phase, status_and_next_steps,
    planning_hub, fix_batch, handoff, reflection
```

---

## Consequences

### Positive

- **Zero friction:** Standard locations detected automatically
- **Explicit override:** `--type` works for any edge case
- **Reliable:** Path-based detection is 100% reliable in testing
- **Helpful errors:** Lists all available types when detection fails
- **Flexible:** Supports non-standard locations via content detection
- **Backward compatible:** Supports both `admin/` and `docs/maintainers/` structures

### Negative

- **README.md limitation:** Cannot detect hub type from content alone
- **Pattern maintenance:** Path patterns must stay in sync with dev-infra
- **Order sensitivity:** Case patterns must be ordered correctly

### Mitigations

- Document that README.md files require path context
- CI validation ensures pattern coverage
- Patterns ordered from most specific to least specific

---

## Alternatives Considered

### Alternative 1: Always Require `--type`

**Description:** No auto-detection; always require explicit type.

**Pros:**
- Simple implementation
- No detection errors possible
- Always explicit

**Cons:**
- Poor UX for common cases
- Tedious for batch validation
- Most files have obvious types from path

**Why not chosen:** Adds friction for the majority of use cases where path detection works perfectly.

---

### Alternative 2: Content-Only Detection

**Description:** Only detect from file content, ignore path.

**Pros:**
- Works for files in any location
- No path pattern maintenance

**Cons:**
- README.md files all look the same
- Less reliable (~60% in testing)
- Slower (must read file content)

**Why not chosen:** Research showed path-based detection is 100% reliable for standard locations. Content-only fails for hub files.

---

### Alternative 3: Extension-Based Detection

**Description:** Use file extensions (e.g., `.exploration.md`).

**Pros:**
- Very fast detection
- Unambiguous

**Cons:**
- Requires changing all file names
- Non-standard convention
- Breaks existing documents

**Why not chosen:** Would require renaming all existing documents. Path detection works without changes.

---

## Decision Rationale

**Key Factors:**

1. **UX Priority:** Auto-detection for common cases, explicit for edge cases
2. **Reliability:** Path detection is 100% reliable for standard locations
3. **README.md Constraint:** Hub files require path context (content is generic)
4. **Flexibility:** Must support non-standard locations

**Research Support:**
- Finding 1: "17 document subtypes with clear path patterns"
- Finding 3: "README.md files REQUIRE path context"
- Insight 1: "Path-based detection is highly reliable (100% success in testing)"
- Recommendation 1: "Implement path-based detection as primary method"

---

## Requirements Impact

**Requirements Addressed:**
- FR-TD1: `--type` flag for explicit override ✅
- FR-TD2: Path-based type detection ✅
- FR-TD3: Content-based fallback detection ✅
- FR-TD4: TYPE_DETECTION_FAILED error with available types ✅
- FR-TD5: Detect all 17 document subtypes ✅
- NFR-TD1: Detection <50ms per file ✅
- NFR-TD2: Documented detection order ✅
- NFR-TD3: Error messages list available types ✅

**Constraints Acknowledged:**
- C-TD1: README.md requires path context
- C-TD2: Path patterns ordered most to least specific

---

## References

- [Type Detection Research](../../research/doc-infrastructure/research-type-detection.md)
- [Requirements Document](../../research/doc-infrastructure/requirements.md)
- [dev-infra validation-rules/*.yaml](~/Projects/dev-infra/scripts/doc-gen/templates/validation-rules/)

---

**Last Updated:** 2026-01-20
