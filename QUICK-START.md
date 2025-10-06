# Dev Toolkit - Quick Start Guide

Fast reference for getting started with dev-toolkit.

---

## 🚀 Installation

### For Development/Testing
```bash
cd /path/to/dev-toolkit
source dev-setup.sh
```

### For Production Use
```bash
git clone https://github.com/yourusername/dev-toolkit.git ~/.dev-toolkit
cd ~/.dev-toolkit
./install.sh
```

---

## ⚡ Quick Commands

### Configuration
```bash
dt-config show              # View current config
dt-config create global     # Create global config
dt-config create project    # Create project config
dt-config edit global       # Edit global config
```

### Sourcery Parser
```bash
# Quick review extraction (recommended)
dt-review 42                # Extract review to admin/feedback/sourcery/pr42.md

# Full parser with options
dt-sourcery-parse           # Parse current user's open PR
dt-sourcery-parse 42        # Parse PR #42
dt-sourcery-parse 42 -o review.md    # Save to file
dt-sourcery-parse 42 --think         # Show reasoning
```

### Git Flow Safety
```bash
dt-git-safety check         # Run all checks
dt-git-safety branch        # Check current branch
dt-git-safety conflicts     # Check for conflicts
dt-git-safety prs           # Check open PRs
dt-git-safety fix           # Show auto-fix suggestions
```

---

## 🔧 Environment Variables

```bash
# Required for development
export DT_ROOT="/path/to/dev-toolkit"
export PATH="$DT_ROOT/bin:$PATH"

# Optional - enable verbose mode
export GF_VERBOSE=true
export GF_DEBUG=true
```

---

## 🆘 Troubleshooting

**Command not found?**
```bash
# Set DT_ROOT
export DT_ROOT="/Users/cdwilson/Projects/dev-toolkit"
export PATH="$DT_ROOT/bin:$PATH"
```

**Can't find config?**
```bash
dt-config create global
```

**Not in a git repo?**
```bash
cd /path/to/your/git/repo
dt-git-safety check
```

**More help:**
- See [Troubleshooting Guide](docs/troubleshooting/common-issues.md)
- Run `dt-config help`
- Run `dt-git-safety help`

---

## 📁 File Locations

- **Global Config**: `~/.dev-toolkit/config`
- **Project Config**: `.dev-toolkit.conf` (in project root)
- **Example Config**: `config/config.example`

---

## 🎯 Common Workflows

### Setting up a new project
```bash
cd /path/to/new/project
dt-config create project
dt-git-safety check
```

### Parsing Sourcery reviews
```bash
cd /path/to/project
dt-sourcery-parse 42 -o docs/reviews/pr-42.md
```

### Pre-commit safety check
```bash
dt-git-safety check
# Fix any issues
git commit -m "Your message"
```

---

**Full Documentation**: [README.md](README.md)  
**Testing Guide**: [docs/TESTING.md](docs/TESTING.md)  
**Version**: 0.2.0
