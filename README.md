# Dev Toolkit

A portable, project-agnostic development toolkit for managing code reviews, Git workflows, and project automation across multiple repositories.

## 🎯 Purpose

This toolkit consolidates reusable development utilities that work across any project:

- **Sourcery Automation** - Extract and format AI code reviews programmatically
- **Git Flow Utilities** - Streamlined branching, merging, and cleanup workflows
- **GitHub Integration** - Batch API operations and PR management
- **Project Management** - Priority matrices and planning templates

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
- `dt-sourcery-parse` - Parse Sourcery reviews
- `dt-git-safety` - Git Flow safety checks
- `dt-config` - Configuration management
- `dt-install-hooks` - Install git hooks

### Per-Project Install
```bash
# In your project root
git clone https://github.com/yourusername/dev-toolkit.git .dev-toolkit
cd .dev-toolkit
./install.sh --local
```

## 📖 Usage

### Sourcery Review Parser
Extract Sourcery AI reviews from GitHub PRs:

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

### Git Flow Safety Checks
Run automated Git Flow workflow compliance checks:

```bash
# Run all safety checks
dt-git-safety check

# Check current branch safety
dt-git-safety branch

# Check for merge conflicts
dt-git-safety conflicts

# Check open pull requests
dt-git-safety prs

# Show auto-fix suggestions
dt-git-safety fix
```

### Configuration Management
Manage dev-toolkit configuration:

```bash
# Show current configuration
dt-config show

# Create global configuration
dt-config create global

# Create project-local configuration
dt-config create project

# Edit configuration
dt-config edit global
```

### Git Hooks
Install pre-commit hooks for automatic safety checks:

```bash
# Install hooks in current repository
dt-install-hooks

# Hooks will automatically run before each commit
# - Check branch safety
# - Detect merge conflicts
# - Prevent committing sensitive files
# - Warn about large files
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

- **[Troubleshooting Guide](docs/troubleshooting/common-issues.md)** - Common issues and solutions
- **[Sourcery Setup Guide](docs/SOURCERY-SETUP.md)** - Setting up Sourcery AI code reviews
- **[Admin README](admin/README.md)** - Project coordination and structure
- **[Planning Roadmap](admin/planning/roadmap.md)** - Development phases
- **[Installation Guide](admin/docs/installation-guide.md)** - Detailed setup (coming soon)

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