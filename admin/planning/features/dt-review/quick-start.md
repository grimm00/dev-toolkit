# dt-review - Quick Start Guide

**Purpose:** How to use dt-review for Sourcery review extraction
**Status:** ✅ Current
**Last Updated:** 2025-10-07

---

## 🚀 Quick Start

### Basic Usage

```bash
# Extract review to standard location
dt-review 6
# Saves to admin/feedback/sourcery/pr06.md

# Extract review to custom location
dt-review 6 my-review.md
# Saves to my-review.md

# Get help
dt-review --help
```

---

## 📋 What dt-review Does

`dt-review` is a convenience wrapper for `dt-sourcery-parse` that:

1. **Calls the Parser** - Uses `dt-sourcery-parse` with `--rich-details` flag
2. **Saves to Standard Location** - Default: `admin/feedback/sourcery/pr##.md`
3. **Supports Custom Paths** - Optional second argument for custom output
4. **Provides Feedback** - Clear success/failure messages

---

## 🎯 Usage Examples

### Standard Usage (Recommended)

```bash
# Extract PR #6 review
dt-review 6

# Output:
# 📋 Extracting Sourcery review for PR #6...
# 
# ✅ Review saved to: admin/feedback/sourcery/pr06.md
# 
# 💡 View the review:
#    cat admin/feedback/sourcery/pr06.md
#    code admin/feedback/sourcery/pr06.md
```

### Custom Output Path

```bash
# Extract PR #12 to custom location
dt-review 12 my-special-review.md

# Output:
# 📋 Extracting Sourcery review for PR #12...
# 
# ✅ Review saved to: my-special-review.md
# 
# 💡 View the review:
#    cat my-special-review.md
#    code my-special-review.md
```

### Get Help

```bash
dt-review --help

# Shows comprehensive usage information
```

---

## 🔧 How It Works

### Architecture

```
dt-review → dt-sourcery-parse → lib/sourcery/parser.sh
    ↓              ↓                    ↓
Convenience    Wrapper            Core Parser
Function       Script             (Heavy Lifting)
```

### Process Flow

1. **Parse Arguments** - PR number and optional output path
2. **Determine Output** - Standard location or custom path
3. **Call Parser** - `dt-sourcery-parse PR_NUMBER --rich-details --output FILE`
4. **Report Results** - Success/failure with helpful messages

---

## 📁 Output Locations

### Standard Location (Default)

```bash
dt-review 6
# Saves to: admin/feedback/sourcery/pr06.md
```

**Format:** `admin/feedback/sourcery/pr##.md`
- **Directory:** `admin/feedback/sourcery/`
- **Filename:** `pr` + zero-padded PR number + `.md`
- **Examples:** `pr01.md`, `pr06.md`, `pr12.md`

### Custom Location

```bash
dt-review 6 custom-review.md
# Saves to: custom-review.md
```

**Format:** Any valid file path
- **Relative paths:** `my-review.md`, `reviews/pr6.md`
- **Absolute paths:** `/tmp/review.md`, `~/Documents/review.md`

---

## 🛠️ Troubleshooting

### Common Issues

#### 1. "Cannot locate dev-toolkit installation"

**Symptom:**
```
❌ Error: Cannot locate dev-toolkit installation
💡 Set DT_ROOT environment variable or install to ~/.dev-toolkit
```

**Solution:**
```bash
# Set DT_ROOT environment variable
export DT_ROOT=/path/to/dev-toolkit

# Or install to default location
# (Follow installation instructions)
```

#### 2. "Failed to extract review"

**Symptom:**
```
❌ Failed to extract review
```

**Causes:**
- Invalid PR number
- PR doesn't exist
- No Sourcery review available
- GitHub API issues

**Solution:**
```bash
# Check if PR exists
gh pr view 6

# Check if Sourcery review exists
# (Look for Sourcery comments in the PR)

# Try with dt-sourcery-parse directly for debugging
dt-sourcery-parse 6 --help
```

#### 3. Permission Denied

**Symptom:**
```
Permission denied: admin/feedback/sourcery/pr06.md
```

**Solution:**
```bash
# Create directory if it doesn't exist
mkdir -p admin/feedback/sourcery

# Check permissions
ls -la admin/feedback/sourcery/
```

---

## 🔍 Advanced Usage

### Using with Other Tools

```bash
# Extract and immediately view
dt-review 6 && cat admin/feedback/sourcery/pr06.md

# Extract and open in editor
dt-review 6 && code admin/feedback/sourcery/pr06.md

# Extract to temporary file
dt-review 6 /tmp/review.md && less /tmp/review.md
```

### Integration with Workflows

```bash
#!/bin/bash
# Example workflow script

PR_NUMBER="$1"
REVIEW_FILE="admin/feedback/sourcery/pr$(printf "%02d" "$PR_NUMBER").md"

# Extract review
if dt-review "$PR_NUMBER"; then
    echo "✅ Review extracted successfully"
    
    # Process review
    if grep -q "## Overall Comments" "$REVIEW_FILE"; then
        echo "🎉 Overall Comments found!"
    fi
    
    # Open in editor
    code "$REVIEW_FILE"
else
    echo "❌ Failed to extract review"
    exit 1
fi
```

---

## 📚 Related Commands

### dt-sourcery-parse (Core Parser)

```bash
# Direct usage with more options
dt-sourcery-parse 6 --rich-details --output custom.md
dt-sourcery-parse 6 --think
dt-sourcery-parse 6 --no-details
```

### GitHub CLI

```bash
# View PR details
gh pr view 6

# List PRs
gh pr list

# Check Sourcery comments
gh pr view 6 --comments
```

---

## 🎯 Best Practices

### 1. Use Standard Locations

**Recommended:**
```bash
dt-review 6  # Saves to admin/feedback/sourcery/pr06.md
```

**Why:** Consistent organization, easy to find, follows project conventions

### 2. Check Results

**Always verify:**
```bash
dt-review 6 && ls -la admin/feedback/sourcery/pr06.md
```

### 3. Use Custom Paths When Needed

**For special cases:**
```bash
dt-review 6 /tmp/quick-review.md  # Temporary file
dt-review 6 ~/Documents/review.md  # Personal storage
```

### 4. Integrate with Workflows

**For automation:**
```bash
# Extract and process
dt-review "$PR_NUMBER" && process-review.sh "$PR_NUMBER"
```

---

## 📖 Further Reading

- **[Feature Plan](feature-plan.md)** - Overview and goals
- **[Status & Next Steps](status-and-next-steps.md)** - Current status
- **[Architecture Analysis](architecture-analysis.md)** - Design decisions
- **[dt-sourcery-parse Documentation](../sourcery-overall-comments/)** - Core parser

---

**Last Updated:** 2025-10-07
**Status:** ✅ Current
**Next:** Complete integration tests
