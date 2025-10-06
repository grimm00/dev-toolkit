
# Setting Up Sourcery AI for Dev Toolkit

Sourcery is an AI code reviewer that automatically reviews your pull requests. This guide shows you how to set it up for the dev-toolkit repository.

---

## What is Sourcery?

Sourcery is a GitHub App that:
- 🔍 Automatically reviews your PRs
- 💡 Suggests code improvements
- 🎯 Identifies potential issues
- 📊 Provides quality metrics

The `dt-sourcery-parse` command extracts these reviews into readable markdown files with priority matrices.

---

## Installation Steps

### 1. Install the Sourcery GitHub App

Visit: **https://sourcery.ai/download/**

Or install directly from GitHub Marketplace:
**https://github.com/marketplace/sourcery-ai**

### 2. Authorize Sourcery

1. Click "Install" or "Configure"
2. Select your account (grimm00)
3. Choose repository access:
   - **Option A**: Select only `dev-toolkit`
   - **Option B**: All repositories (if you want it everywhere)
4. Click "Install & Authorize"

### 3. Verify Installation

Check if Sourcery is installed:

```bash
# Using GitHub CLI
gh api /repos/grimm00/dev-toolkit/installation

# Or visit in browser
open https://github.com/grimm00/dev-toolkit/settings/installations
```

You should see "Sourcery" in the list of installed apps.

---

## Testing Sourcery

### Create a Test PR

```bash
# Create a test branch
git checkout -b test/sourcery-setup

# Make a small change
echo "# Test" >> TEST.md
git add TEST.md
git commit -m "test: Verify Sourcery integration"
git push -u origin test/sourcery-setup

# Create PR
gh pr create --title "test: Verify Sourcery integration" --body "Testing Sourcery AI code review"
```

### Wait for Sourcery Review

Sourcery typically reviews PRs within 1-2 minutes. You'll see:
- A comment from `sourcery-ai[bot]` on your PR
- Review comments on specific lines (if applicable)
- Overall code quality metrics

### Parse the Review

Once Sourcery has reviewed:

```bash
# Parse the review
dt-sourcery-parse <PR_NUMBER>

# Or save to file
dt-sourcery-parse <PR_NUMBER> -o docs/reviews/sourcery-review.md

# With detailed reasoning
dt-sourcery-parse <PR_NUMBER> --think
```

---

## Configuration (Optional)

### Create `.sourcery.yaml`

Add custom Sourcery configuration to your repository:

```yaml
# .sourcery.yaml
rules:
  - id: no-long-functions
    description: Functions should be less than 50 lines
    pattern: |
      def $FUNC(...):
        $$$BODY
    condition: len($$$BODY) > 50

python_version: "3.11"

github:
  request_review: author
  sourcery_branch: sourcery/main
```

### Common Settings

```yaml
# Enable/disable specific checks
rules:
  - id: use-fstring-for-formatting
    enabled: true
  
  - id: no-unnecessary-pass
    enabled: false

# Set review thresholds
thresholds:
  quality: 75
  complexity: 10
```

---

## Using Sourcery Reviews

### 1. View Review on GitHub

Visit your PR to see Sourcery's inline comments and overall review.

### 2. Extract with dt-sourcery-parse

```bash
# Basic extraction
dt-sourcery-parse 1

# Save to file
dt-sourcery-parse 1 -o admin/reviews/pr-1-sourcery.md

# Include reasoning
dt-sourcery-parse 1 --think

# Structured details
dt-sourcery-parse 1 --rich-details
```

### 3. Use the Priority Matrix

The parser generates a priority matrix template:

```markdown
| Comment | Priority | Impact | Effort | Notes |
|---------|----------|--------|--------|-------|
| #1      |          |        |        |       |
| #2      |          |        |        |       |
```

Fill it out to prioritize which suggestions to implement.

---

## Troubleshooting

### Sourcery Not Reviewing

**Check installation:**
```bash
gh api /repos/grimm00/dev-toolkit/installation
```

**Verify permissions:**
- Go to: https://github.com/settings/installations
- Click "Configure" next to Sourcery
- Ensure "Pull requests" permission is enabled

**Trigger manually:**
- Close and reopen the PR
- Push a new commit to the PR branch

### No Review Found

```bash
dt-sourcery-parse 1
# ⚠️  No Sourcery review found for PR #1
```

**Possible causes:**
1. Sourcery hasn't reviewed yet (wait 1-2 minutes)
2. PR has no code changes (only docs/config)
3. Sourcery is not installed
4. PR is from a fork (Sourcery may not review forks)

**Solutions:**
```bash
# Check if PR exists
gh pr view 1

# Check for Sourcery comments
gh pr view 1 --comments | grep sourcery

# Wait and try again
sleep 60 && dt-sourcery-parse 1
```

### Parse Errors

```bash
# Enable verbose mode
dt-sourcery-parse 1 --think

# Check raw review data
gh api /repos/grimm00/dev-toolkit/pulls/1/reviews
```

---

## Best Practices

### 1. Review Early and Often

Run Sourcery on every PR to catch issues early:

```bash
# After creating PR
gh pr create --title "feat: New feature" --body "Description"

# Wait for Sourcery
sleep 120

# Parse and review
dt-sourcery-parse $(gh pr list --author "@me" --json number --jq '.[0].number')
```

### 2. Use Priority Matrix

Don't implement every suggestion blindly:
- 🔴 **CRITICAL**: Security, stability issues → Implement immediately
- 🟠 **HIGH**: Bug risks → Implement before merge
- 🟡 **MEDIUM**: Code quality → Implement if time allows
- 🟢 **LOW**: Nice-to-haves → Optional

### 3. Save Reviews

Keep a record of Sourcery reviews:

```bash
mkdir -p admin/reviews
dt-sourcery-parse $PR_NUM -o admin/reviews/pr-$PR_NUM-sourcery.md
git add admin/reviews/
git commit -m "docs: Add Sourcery review for PR #$PR_NUM"
```

### 4. Learn from Patterns

Look for recurring suggestions across PRs to identify areas for improvement.

---

## Integration with Workflow

### Automated Review Parsing

Add to your workflow:

```bash
# After PR creation
gh pr create --title "..." --body "..."

# Wait for Sourcery
echo "Waiting for Sourcery review..."
sleep 120

# Parse and save
PR_NUM=$(gh pr list --author "@me" --limit 1 --json number --jq '.[0].number')
dt-sourcery-parse $PR_NUM -o admin/reviews/pr-$PR_NUM-sourcery.md

# Review the file
cat admin/reviews/pr-$PR_NUM-sourcery.md
```

### Pre-merge Checklist

Before merging:
1. ✅ Sourcery review completed
2. ✅ Critical issues addressed
3. ✅ Review saved to `admin/reviews/`
4. ✅ Priority matrix filled out

---

## Resources

- **Sourcery Website**: https://sourcery.ai/
- **Documentation**: https://docs.sourcery.ai/
- **GitHub App**: https://github.com/marketplace/sourcery-ai
- **Configuration Reference**: https://docs.sourcery.ai/Configuration/

---

## Quick Reference

```bash
# Install Sourcery
open https://sourcery.ai/download/

# Check installation
gh api /repos/grimm00/dev-toolkit/installation

# Parse review
dt-sourcery-parse <PR_NUMBER>

# Save to file
dt-sourcery-parse <PR_NUMBER> -o admin/reviews/pr-<NUM>-sourcery.md

# With reasoning
dt-sourcery-parse <PR_NUMBER> --think

# Help
dt-sourcery-parse --help
```

---

**Last Updated**: October 6, 2025  
**Version**: 0.1.0-alpha
