# Optional Features in Dev Toolkit

The dev-toolkit is designed with a **core-first** philosophy: all essential features work without external dependencies or paid services.

---

## ✅ Core Features (Always Available)

These features work immediately after installation with no setup required:

### Git Flow Safety Checks
```bash
dt-git-safety check
```
- Branch safety validation
- Merge conflict detection
- Repository health checks
- **No external services needed**

### Pre-commit Hooks
```bash
dt-install-hooks
```
- Automatic safety checks before commits
- Prevents committing sensitive files
- Warns about large files
- **Works entirely locally**

### Configuration Management
```bash
dt-config show
dt-config create global
```
- Manage toolkit settings
- Global and project-local configs
- **No external dependencies**

### GitHub Integration
- Project auto-detection from git remotes
- GitHub CLI utilities
- **Requires:** `gh` CLI (free, open source)

---

## 🔌 Optional Features

These features enhance the toolkit but are **not required** for core functionality:

### Sourcery AI Integration

**What it provides:**
- AI-powered code reviews
- Security issue detection
- Code quality suggestions
- Automated review extraction

**Requirements:**
- Sourcery GitHub App (free tier available)
- GitHub account

**Rate Limits:**
- **Free tier:** 500,000 diff characters/week
- **Resets:** Weekly
- **What counts:** Every line added or removed in PRs
- **Upgrade:** Available for unlimited reviews

**Commands:**
```bash
dt-setup-sourcery    # Interactive setup
dt-sourcery-parse 42 # Parse reviews
```

**When to use:**
- ✅ Small to medium projects (within free tier)
- ✅ Occasional code reviews
- ✅ Learning from AI suggestions
- ✅ Security scanning

**When to skip:**
- ❌ Very large projects (may hit rate limits quickly)
- ❌ Many daily PRs
- ❌ Don't want external service dependencies
- ❌ Privacy concerns about code analysis

---

## Using the Toolkit Without Optional Features

### Full Functionality Without Sourcery

You get complete Git Flow workflow support:

```bash
# Install toolkit
./install.sh

# Install hooks in your project
cd ~/Projects/my-project
dt-install-hooks

# Use safety checks
dt-git-safety check

# Configure toolkit
dt-config create project
```

### What You're Not Missing

Without Sourcery, you still have:
- ✅ Automated safety checks
- ✅ Pre-commit validation
- ✅ Branch protection
- ✅ Conflict detection
- ✅ Configuration management
- ✅ All Git Flow utilities

You're only missing:
- ❌ AI code review suggestions
- ❌ Automated security scanning
- ❌ Code quality metrics from AI

### Manual Alternatives

Instead of Sourcery, you can:
1. **Code Reviews:** Manual peer reviews
2. **Security:** Use GitHub's built-in security scanning
3. **Quality:** Use linters (ESLint, Pylint, etc.)
4. **Static Analysis:** Use language-specific tools

---

## Decision Guide

### Choose Core Only If:
- ✅ You want zero external dependencies
- ✅ Privacy is a top concern
- ✅ You have existing code review processes
- ✅ You're working on very large codebases
- ✅ You prefer manual code reviews

### Add Sourcery If:
- ✅ You want AI-assisted code reviews
- ✅ You're within free tier limits
- ✅ You want automated security scanning
- ✅ You're learning best practices
- ✅ You work on small to medium projects

---

## Installation Options

### Core Only (Minimal)
```bash
# Install toolkit
./install.sh

# Skip Sourcery setup
# Just use: dt-git-safety, dt-config, dt-install-hooks
```

### Core + Sourcery (Full)
```bash
# Install toolkit
./install.sh

# Setup Sourcery
dt-setup-sourcery
# Follow prompts to install Sourcery GitHub App
```

---

## Rate Limit Management

If you choose to use Sourcery:

### Monitor Usage
- Sourcery shows remaining quota in rate limit messages
- Plan your PRs accordingly
- Focus on important code changes

### Stay Within Free Tier
1. **Smaller PRs:** Break large changes into smaller PRs
2. **Selective Reviews:** Don't review every PR
3. **Skip Docs:** Documentation-only PRs don't need Sourcery
4. **Strategic Use:** Review complex logic, skip simple changes

### When You Hit the Limit
1. **Wait:** Limits reset weekly
2. **View on GitHub:** Sourcery comments still visible
3. **Use Core Features:** All other toolkit features still work
4. **Upgrade:** Consider Sourcery Pro for unlimited reviews

---

## Migrating Between Modes

### Adding Sourcery Later
```bash
# Already using core features
dt-git-safety check  # Works

# Add Sourcery anytime
dt-setup-sourcery    # New!
dt-sourcery-parse 42 # Now available
```

### Removing Sourcery
```bash
# Uninstall Sourcery GitHub App
# Visit: https://github.com/settings/installations

# Core features continue working
dt-git-safety check  # Still works
dt-config show       # Still works
```

---

## Summary

| Feature | Core | Optional | External Service |
|---------|------|----------|------------------|
| Git Flow Safety | ✅ | | |
| Pre-commit Hooks | ✅ | | |
| Configuration | ✅ | | |
| GitHub Utils | ✅ | | GitHub CLI |
| Sourcery Reviews | | 🔌 | Sourcery AI |

**Philosophy:** The toolkit should be **useful immediately** without requiring external services. Optional features enhance but don't define the toolkit.

---

## Questions?

- **"Do I need Sourcery?"** No! Core features work independently.
- **"Can I try Sourcery later?"** Yes! Add it anytime with `dt-setup-sourcery`.
- **"What if I hit rate limits?"** Core features still work, view reviews on GitHub.
- **"Is Sourcery worth it?"** Try the free tier and decide for yourself!

---

**Remember:** The dev-toolkit is designed to be useful with or without optional features. Choose what works for your workflow!

**Last Updated:** October 6, 2025  
**Version:** 0.1.1
