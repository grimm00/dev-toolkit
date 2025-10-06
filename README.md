# Dev Toolkit

A portable, project-agnostic development toolkit for managing code reviews, Git workflows, and project automation across multiple repositories.

## 🎯 Purpose

This toolkit consolidates reusable development utilities that work across any project:

### ✅ Core Features (No External Services Required)
- **Git Flow Utilities** - Streamlined branching, merging, and cleanup workflows
- **GitHub Integration** - Batch API operations and PR management (requires `gh` CLI)
- **Pre-commit Hooks** - Automated safety checks before commits
- **Configuration Management** - Global and project-local settings

### 🔌 Optional Features (External Services)
- **Sourcery Automation** - Extract and format AI code reviews programmatically
  - Requires: Sourcery GitHub App (free tier: 500k diff chars/week)
  - **You can use all core features without Sourcery!**

## 📦 What's Inside

### Core Libraries (`lib/core/`)
- `github-utils.sh` - GitHub CLI utilities with project auto-detection

### Git Flow (`lib/git-flow/`)
- `utils.sh` - Git workflow utilities and helpers
- `safety.sh` - Automated safety checks for Git Flow compliance

### Sourcery Tools (`lib/sourcery/`)
- `parser.sh` - Extract and format Sourcery AI reviews from PRs

### Command Wrappers (`bin/`)
- `dt-sourcery-parse` - Parse Sourcery reviews
- `dt-setup-sourcery` - Interactive Sourcery setup
- `dt-git-safety` - Run Git Flow safety checks
- `dt-config` - Configuration management
- `dt-install-hooks` - Install pre-commit hooks

## 🚀 Installation

### Quick Install (Global)
```bash
git clone https://github.com/yourusername/dev-toolkit.git ~/.dev-toolkit
cd ~/.dev-toolkit
./install.sh
```

This installs commands globally:

**✅ Core Commands (Work immediately):**
- `dt-git-safety` - Git Flow safety checks
- `dt-config` - Configuration management
- `dt-install-hooks` - Install pre-commit hooks

**🔌 Optional Commands (Require Sourcery):**
- `dt-sourcery-parse` - Parse Sourcery reviews
- `dt-setup-sourcery` - Interactive Sourcery setup

### Per-Project Install
```bash
# In your project root
git clone https://github.com/yourusername/dev-toolkit.git .dev-toolkit
cd .dev-toolkit
./install.sh --local
```

## 📖 Usage

### Core Features (Available Immediately)

These features work right after installation with no additional setup:

**Git Flow Safety Checks:**
```bash
# Run all safety checks
dt-git-safety check

# Check current branch safety
dt-git-safety branch

# Check for merge conflicts
dt-git-safety conflicts
```

**Configuration Management:**
```bash
# Show current configuration
dt-config show

# Create global configuration
dt-config create global
```

**Git Hooks:**
```bash
# Install pre-commit hooks
dt-install-hooks
```

---

### Optional: Sourcery AI Integration

> **⚠️ Rate Limits:** Sourcery free tier provides 500,000 diff characters/week.  
> **💡 Tip:** All core features work without Sourcery! Only add this if you want AI code reviews.

**Setup Sourcery (Interactive):**
```bash
# Interactive setup wizard
dt-setup-sourcery

# Options:
# 1) Install Sourcery GitHub App
# 2) Check if Sourcery is installed
# 3) View configuration docs
# 4) Test Sourcery on current PR
```

**Parse Sourcery Reviews:**
```bash
# Parse a specific PR
dt-sourcery-parse 42

# Parse current user's open PR
dt-sourcery-parse

# Output to file
dt-sourcery-parse 42 -o docs/reviews/pr-42-review.md

# Show extraction reasoning
dt-sourcery-parse 42 --think

# Structured details output
dt-sourcery-parse 42 --rich-details
```

**More Git Flow Options:**
```bash
# Check open pull requests
dt-git-safety prs

# Show auto-fix suggestions
dt-git-safety fix
```

**More Configuration Options:**
```bash
# Create project-local configuration
dt-config create project

# Edit configuration
dt-config edit global
```

## 🛠️ Requirements

### Required
- **bash** 4.0+ (macOS: `brew install bash`)
- **git** 2.0+
- **gh** (GitHub CLI) - `brew install gh`

### Optional (for enhanced features)
- **jq** - JSON parsing for batch operations (`brew install jq`)

## 🏗️ Project Structure

```
dev-toolkit/
├── bin/                    # Command wrappers
│   ├── dt-sourcery-parse  # Sourcery review parser
│   ├── dt-git-safety      # Git Flow safety checks
│   └── dt-config          # Configuration management
├── lib/
│   ├── core/              # Core utilities
│   │   └── github-utils.sh
│   ├── git-flow/          # Git Flow utilities
│   │   ├── utils.sh
│   │   └── safety.sh
│   └── sourcery/          # Sourcery tools
│       └── parser.sh
├── config/
│   └── config.example     # Example configuration
├── admin/
│   ├── docs/              # Documentation
│   ├── planning/          # Roadmap and phases
│   ├── chat-logs/         # AI conversation history
│   └── testing/           # Test plans and results
├── install.sh             # Installation script
├── VERSION                # Version file
├── CHANGELOG.md           # Change history
└── README.md              # This file
```

## 🎨 Design Philosophy

1. **Project-Agnostic** - Auto-detects project context, no hardcoded paths
2. **Portable** - Works across any repository with minimal setup
3. **Modular** - Use individual tools or the full suite
4. **AI-Friendly** - Designed to work seamlessly with AI coding assistants
5. **Zero Dependencies** - Core features work with just bash and git

## 📚 Documentation

- **[Optional Features Guide](docs/OPTIONAL-FEATURES.md)** - Core vs Optional features explained
- **[Troubleshooting Guide](docs/troubleshooting/common-issues.md)** - Common issues and solutions
- **[Sourcery Setup Guide](docs/SOURCERY-SETUP.md)** - Setting up Sourcery AI code reviews
- **[Admin README](admin/README.md)** - Project coordination and structure
- **[Planning Roadmap](admin/planning/roadmap.md)** - Development phases

## 🔧 Development

If you're developing or testing the toolkit locally:

```bash
# Clone the repository
git clone https://github.com/yourusername/dev-toolkit.git
cd dev-toolkit

# Set up development environment
source dev-setup.sh

# Or manually set environment
export DT_ROOT="$(pwd)"
export PATH="$DT_ROOT/bin:$PATH"

# Test commands
dt-config show
dt-git-safety check
```

For persistent setup, add to your `~/.zshrc`:
```bash
export DT_ROOT="/Users/cdwilson/Projects/dev-toolkit"
export PATH="$DT_ROOT/bin:$PATH"
```

## 🤝 Contributing

This toolkit is designed for personal use across multiple projects but contributions are welcome:

1. Keep tools project-agnostic
2. Maintain zero external dependencies for core features
3. Document all functions and usage
4. Test across different project types

## 📝 License

MIT License - Use freely across your projects

## 🔗 Origin

Born from the [Pokehub](https://github.com/grimm00/pokedex) project's need for portable Sourcery automation and Git workflow tools.

---

**Version:** 0.1.0-alpha  
**Status:** 🚧 Active Development  
**Last Updated:** October 6, 2025