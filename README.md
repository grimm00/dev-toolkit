# Dev Toolkit

**Version**: 0.1.0-alpha  
**Status**: 🚧 Under Active Development

Portable development toolkit with Sourcery automation, Git Flow utilities, and GitHub integration.

---

## 🎯 Vision

A comprehensive, project-agnostic development toolkit that provides:
- **Sourcery Automation** - Parse and analyze code reviews
- **Git Flow Utilities** - Workflow helpers, safety checks, branch management
- **GitHub Integration** - PR management, status checks, automation
- **Project Management** - Status dashboards, tracking, reporting

---

## 📦 What's Included

### Sourcery Automation
- `dt-sourcery-parse` - Extract Sourcery reviews from GitHub PRs
- `dt-sourcery-analyze` - Analyze priorities (coming soon)

### Git Flow Utilities
- `dt-git-cleanup` - Clean up local and remote branches
- `dt-git-flow` - Git Flow workflow helper
- `dt-git-safety` - Pre-commit safety checks

### GitHub Integration
- `dt-pr-check` - Check PR status
- `dt-pr-list` - List PRs
- GitHub API utilities with batching

### Configuration
- `dt-config` - Configuration management
- `dt-update` - Update toolkit
- `dt-version` - Show version

---

## 🚀 Installation

### Quick Install
```bash
curl -sSL https://raw.githubusercontent.com/grimm00/dev-toolkit/main/install.sh | bash
```

### Manual Install
```bash
git clone https://github.com/grimm00/dev-toolkit.git ~/.dev-toolkit
cd ~/.dev-toolkit
./install.sh
```

---

## 📖 Usage

### Sourcery Automation
```bash
# Parse Sourcery review from PR
dt-sourcery-parse 27

# Save to file
dt-sourcery-parse 27 --output review.md

# Show extraction reasoning
dt-sourcery-parse 27 --think
```

### Git Flow
```bash
# Clean up branches
dt-git-cleanup --local --remote

# Run safety checks
dt-git-safety

# Git Flow workflow
dt-git-flow start feature/my-feature
```

### Configuration
```bash
# Initialize in project
dt-config init

# Show current config
dt-config show

# Update toolkit
dt-update
```

---

## ⚙️ Configuration

### Global Config
Located at `~/.dev-toolkit/config`

### Per-Project Config
Create `.dev-toolkit.yml` in project root:

```yaml
project:
  name: "MyProject"
  repo: "username/repo"

sourcery:
  output_dir: "docs/sourcery"
  show_details: true

git_flow:
  main_branch: "main"
  develop_branch: "develop"
```

---

## 🛠️ Development Status

### ✅ Completed
- [x] Repository structure
- [x] Basic documentation

### 🚧 In Progress
- [ ] Extract core utilities from source projects
- [ ] Create command wrappers
- [ ] Installation script
- [ ] Configuration system

### 📋 Planned
- [ ] Comprehensive documentation
- [ ] Test suite
- [ ] CI/CD integration
- [ ] v1.0.0 release

---

## 📚 Documentation

- [Installation Guide](docs/installation.md) (coming soon)
- [Configuration Guide](docs/configuration.md) (coming soon)
- [Usage Examples](examples/) (coming soon)

---

## 🤝 Contributing

This toolkit is extracted from multiple projects (REPO-Magic, Pokehub) and made portable. Contributions welcome!

---

## 📄 License

MIT License - see [LICENSE](LICENSE) for details

---

## 🔗 Related Projects

- [REPO-Magic](https://github.com/grimm00/REPO-Magic) - Original source of utilities
- [Pokehub](https://github.com/grimm00/pokedex) - Pokemon web application

---

**Created**: October 5, 2025  
**Author**: grimm00  
**Repository**: https://github.com/grimm00/dev-toolkit
