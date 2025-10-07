# dt-review - Architecture Analysis

**Purpose:** Design decisions and rationale for dt-review architecture
**Status:** ✅ Current
**Last Updated:** 2025-10-07

---

## 🏗️ Architecture Overview

### Current Architecture (After Refactoring)

```
dt-review (Convenience Wrapper)
    ↓
dt-sourcery-parse (Wrapper Script)
    ↓
lib/sourcery/parser.sh (Core Parser)
    ↓
GitHub API + Sourcery Data
```

### Key Design Principles

1. **Single Responsibility** - Each component has one clear purpose
2. **Delegation** - Higher-level components delegate to lower-level ones
3. **Leverage Existing** - Don't duplicate functionality that already exists
4. **Simple Interface** - Keep the user interface simple and intuitive

---

## 🔄 Component Breakdown

### 1. dt-review (Convenience Wrapper)

**Purpose:** Provide a simple, convenient interface for extracting Sourcery reviews

**Responsibilities:**
- Parse command-line arguments (PR number, optional output path)
- Determine output file location (standard or custom)
- Call `dt-sourcery-parse` with appropriate flags
- Provide user feedback on success/failure

**Key Features:**
- **Standard Output Location:** `admin/feedback/sourcery/pr##.md`
- **Custom Output Support:** Optional second argument
- **Rich Details:** Automatically uses `--rich-details` flag
- **Clear Feedback:** Success/failure messages with helpful hints

**Code Structure:**
```bash
#!/usr/bin/env bash
# 1. Detect toolkit installation
# 2. Handle help flags
# 3. Parse arguments
# 4. Determine output file
# 5. Call dt-sourcery-parse
# 6. Report results
```

---

### 2. dt-sourcery-parse (Wrapper Script)

**Purpose:** Provide a command-line interface to the core parser

**Responsibilities:**
- Detect toolkit installation
- Execute the core parser with all arguments
- Handle installation and path detection

**Key Features:**
- **Installation Detection:** Works with both global and local installations
- **Argument Passing:** Passes all arguments to core parser
- **Error Handling:** Clear error messages for installation issues

**Code Structure:**
```bash
#!/usr/bin/env bash
# 1. Detect toolkit installation
# 2. Execute core parser with all arguments
```

---

### 3. lib/sourcery/parser.sh (Core Parser)

**Purpose:** Handle all the heavy lifting of Sourcery review parsing

**Responsibilities:**
- Fetch Sourcery review data from GitHub
- Parse and structure the review content
- Extract individual comments and overall comments
- Format output in markdown
- Handle all parsing logic and edge cases

**Key Features:**
- **GitHub Integration:** Fetches data from GitHub API
- **Sourcery Parsing:** Extracts and structures Sourcery reviews
- **Overall Comments:** Detects and extracts overall comments
- **Rich Formatting:** Structured markdown output
- **Error Handling:** Comprehensive error handling and validation

---

## 🎯 Design Decisions

### 1. Why a Wrapper Instead of Direct Implementation?

**Decision:** Make `dt-review` a wrapper that calls `dt-sourcery-parse`

**Rationale:**
- **Leverage Existing Functionality** - `dt-sourcery-parse` already handles all the complex parsing
- **Avoid Duplication** - Don't duplicate logic that already works well
- **Maintainability** - Changes to parsing logic only need to be made in one place
- **Consistency** - Both commands use the same underlying parser

**Alternative Considered:** Direct implementation in `dt-review`
**Rejected Because:** Would duplicate complex parsing logic and create maintenance burden

---

### 2. Why Support Custom Output Paths?

**Decision:** Allow custom output path as second argument

**Rationale:**
- **Flexibility** - Users may want to save reviews to different locations
- **Workflow Integration** - Easier to integrate with custom workflows
- **Testing** - Allows testing with temporary files
- **Personal Organization** - Users can organize reviews as they prefer

**Implementation:**
```bash
# Default behavior
dt-review 6  # Saves to admin/feedback/sourcery/pr06.md

# Custom path
dt-review 6 my-review.md  # Saves to my-review.md
```

---

### 3. Why Automatic --rich-details Flag?

**Decision:** Always use `--rich-details` flag when calling `dt-sourcery-parse`

**Rationale:**
- **Better Output** - Rich details provide more structured and useful output
- **Consistency** - All reviews extracted via `dt-review` have the same format
- **User Experience** - Users don't need to remember to add the flag
- **Future-Proofing** - If rich details become the default, this won't break

**Alternative Considered:** Let users specify the flag
**Rejected Because:** Adds complexity without significant benefit

---

### 4. Why Standard Output Location?

**Decision:** Default to `admin/feedback/sourcery/pr##.md`

**Rationale:**
- **Consistency** - All reviews in the same location
- **Organization** - Easy to find and manage reviews
- **Project Convention** - Follows established project structure
- **Automation** - Easier to write scripts that process all reviews

**Format Details:**
- **Directory:** `admin/feedback/sourcery/`
- **Filename:** `pr` + zero-padded PR number + `.md`
- **Examples:** `pr01.md`, `pr06.md`, `pr12.md`

---

## 🔧 Implementation Details

### Argument Parsing

```bash
# Handle help flags first
if [[ "${1:-}" == "--help" ]] || [[ "${1:-}" == "-h" ]]; then
    # Show help and exit
fi

# Get PR number (required)
PR_NUMBER="${1:-}"

# Get output path (optional)
if [ -n "${2:-}" ]; then
    OUTPUT_FILE="$2"
else
    # Use standard location
    PR_PADDED=$(printf "pr%02d" "$PR_NUMBER")
    OUTPUT_FILE="admin/feedback/sourcery/${PR_PADDED}.md"
fi
```

### Error Handling

```bash
# Check for required arguments
if [ -z "$PR_NUMBER" ]; then
    echo "Usage: dt-review <PR_NUMBER> [OUTPUT_PATH]"
    exit 1
fi

# Check parser execution
if "$TOOLKIT_ROOT/bin/dt-sourcery-parse" "$PR_NUMBER" --rich-details --output "$OUTPUT_FILE"; then
    echo "✅ Review saved to: $OUTPUT_FILE"
else
    echo "❌ Failed to extract review"
    exit 1
fi
```

### Installation Detection

```bash
# Detect DT_ROOT
if [ -n "${DT_ROOT:-}" ]; then
    TOOLKIT_ROOT="$DT_ROOT"
elif [ -f "$HOME/.dev-toolkit/bin/dt-sourcery-parse" ]; then
    TOOLKIT_ROOT="$HOME/.dev-toolkit"
else
    echo "❌ Error: Cannot locate dev-toolkit installation"
    exit 1
fi
```

---

## 🚫 What We Avoided

### 1. Duplicate Parsing Logic

**What We Avoided:** Implementing Sourcery parsing directly in `dt-review`

**Why:** Would duplicate complex logic that already exists and works well in `dt-sourcery-parse`

### 2. Complex Overall Comments Detection

**What We Avoided:** Adding Overall Comments detection logic to `dt-review`

**Why:** This should be handled by the parser, not the wrapper. The wrapper should focus on convenience.

### 3. Multiple Output Formats

**What We Avoided:** Supporting different output formats (JSON, XML, etc.)

**Why:** Adds complexity without clear benefit. Markdown is the standard format for reviews.

### 4. Batch Processing

**What We Avoided:** Processing multiple PRs at once

**Why:** Adds complexity and error handling. Single PR processing is simpler and more reliable.

---

## 🔮 Future Considerations

### 1. Overall Comments Detection

**Current State:** Not implemented in `dt-review`

**Future Option:** Add detection that analyzes parser output
```bash
# After calling dt-sourcery-parse
if grep -q "## Overall Comments" "$OUTPUT_FILE"; then
    echo "🎉 Overall Comments detected!"
fi
```

**Considerations:**
- Must analyze actual parser output, not raw Sourcery data
- Should be simple and reliable
- Should not duplicate parser functionality

### 2. Enhanced Feedback

**Current State:** Basic success/failure messages

**Future Option:** More detailed feedback
```bash
# Show review summary
echo "📊 Review contains X individual comments"
if [ -n "$OVERALL_COMMENTS" ]; then
    echo "🎉 Overall Comments: $OVERALL_COMMENTS"
fi
```

### 3. Integration with Other Tools

**Current State:** Standalone command

**Future Option:** Better integration
```bash
# Auto-open in editor
dt-review 6 --open

# Auto-process with other tools
dt-review 6 --process
```

---

## 📊 Architecture Benefits

### 1. Maintainability

- **Single Source of Truth** - Parsing logic in one place
- **Clear Separation** - Each component has distinct responsibilities
- **Easy Updates** - Changes to parsing don't affect wrapper

### 2. Testability

- **Isolated Components** - Each component can be tested independently
- **Clear Interfaces** - Well-defined inputs and outputs
- **Mockable Dependencies** - Easy to mock `dt-sourcery-parse` for testing

### 3. Usability

- **Simple Interface** - Easy to use and remember
- **Flexible Output** - Supports both standard and custom locations
- **Clear Feedback** - Users know what happened and what to do next

### 4. Extensibility

- **Easy to Enhance** - New features can be added to appropriate components
- **Backward Compatible** - Changes don't break existing usage
- **Modular Design** - Components can be used independently

---

## 🎯 Summary

The `dt-review` architecture follows the principle of **delegation over duplication**. By making it a simple wrapper that leverages the existing `dt-sourcery-parse` functionality, we achieve:

- **Simplicity** - Clean, focused code
- **Reliability** - Leverages proven parsing logic
- **Maintainability** - Single source of truth for parsing
- **Flexibility** - Supports both standard and custom use cases

This architecture serves as a good example of how to build convenience tools that enhance existing functionality without duplicating it.

---

**Last Updated:** 2025-10-07
**Status:** ✅ Current
**Next:** Complete integration tests to validate architecture
