# Contributing to Dev Toolkit

Thank you for your interest in contributing to Dev Toolkit! This document provides guidelines and instructions for contributing.

---

## 🎯 Philosophy

Dev Toolkit is designed to be:
- **Project-Agnostic** - Works across any Git repository
- **Portable** - Minimal dependencies, maximum compatibility
- **Well-Tested** - Comprehensive test coverage
- **Well-Documented** - Clear documentation for users and developers

---

## 🚀 Getting Started

### 1. Fork and Clone

```bash
# Fork the repository on GitHub
# Then clone your fork
git clone https://github.com/YOUR_USERNAME/dev-toolkit.git
cd dev-toolkit
```

### 2. Set Up Development Environment

```bash
# Source the development setup script
source dev-setup.sh

# Verify commands work
dt-config show
dt-git-safety check
```

### 3. Create a Branch

```bash
# Create a feature branch
git checkout -b feat/your-feature-name

# Or a fix branch
git checkout -b fix/issue-description
```

---

## 📝 Development Guidelines

### Code Style

**Bash Scripts:**
- Use `#!/usr/bin/env bash` shebang
- Set strict mode: `set -euo pipefail`
- Use meaningful variable names
- Add comments for complex logic
- Prefix functions by module (e.g., `gh_`, `gf_`)

**Example:**
```bash
#!/usr/bin/env bash
set -euo pipefail

# Function: Check if command exists
# Args: $1 - command name
# Returns: 0 if exists, 1 if not
gh_command_exists() {
    local cmd=$1
    command -v "$cmd" >/dev/null 2>&1
}
```

### Project Structure

- `bin/` - Command wrappers (executables)
- `lib/` - Core library code (sourced by commands)
- `tests/` - Automated tests (bats-core)
- `docs/` - User documentation
- `admin/` - Project management and planning

### Dependencies

**Core Features (Required):**
- `bash` (4.0+)
- `git` (2.0+)
- `gh` (GitHub CLI)

**Optional Features:**
- `jq` (for performance)
- Sourcery AI (for code review)

**Development:**
- `bats-core` (for testing)
- `shellcheck` (for linting)

---

## 🧪 Testing

### Running Tests

```bash
# Run all tests (215 tests, < 15 seconds)
./scripts/test.sh

# Run specific test suites
bats tests/unit/                    # Unit tests only
bats tests/integration/             # Integration tests only
bats tests/unit/core/               # Core utilities tests
```

### Writing Tests

**Unit Tests** (`tests/unit/`):
- Test individual functions in isolation
- Use mocking for external dependencies
- Fast execution (< 1 second per test)

**Integration Tests** (`tests/integration/`):
- Test commands end-to-end
- Use temporary directories
- Clean up after tests

**Example Unit Test:**
```bash
@test "gh_command_exists: returns 0 for existing command" {
    run gh_command_exists "bash"
    [ "$status" -eq 0 ]
}
```

**Example Integration Test:**
```bash
@test "dt-config: shows help with --help flag" {
    run dt-config --help
    [ "$status" -eq 0 ]
    [[ "$output" =~ "Usage:" ]]
}
```

### Test Requirements

- ✅ All new features must include tests
- ✅ All tests must pass before merging
- ✅ Maintain or improve test coverage
- ✅ Tests should be fast (< 15s total)

---

## 📚 Documentation

### What to Document

- **User-Facing Changes** - Update README.md and relevant docs
- **New Commands** - Add to QUICK-START.md
- **Breaking Changes** - Document in CHANGELOG.md
- **Complex Logic** - Add inline comments

### Documentation Files

- `README.md` - Main project documentation
- `QUICK-START.md` - Quick reference guide
- `CHANGELOG.md` - Version history
- `docs/` - Detailed guides
- `admin/planning/` - Planning and roadmap

---

## 🔄 Pull Request Process

### Before Submitting

1. **Run Tests:**
   ```bash
   ./scripts/test.sh
   ```

2. **Run Linter:**
   ```bash
   shellcheck bin/* lib/**/*.sh
   ```

3. **Update Documentation:**
   - Update README.md if adding features
   - Update CHANGELOG.md with your changes
   - Add/update tests

4. **Commit Messages:**
   Use conventional commits format:
   ```
   feat: Add new command for batch operations
   fix: Resolve issue with branch detection
   docs: Update installation instructions
   test: Add integration tests for dt-config
   chore: Update dependencies
   ```

### Submitting a Pull Request

1. **Push to Your Fork:**
   ```bash
   git push origin feat/your-feature-name
   ```

2. **Create Pull Request:**
   - Go to GitHub and create a PR from your fork
   - Use a clear, descriptive title
   - Describe what changed and why
   - Reference any related issues

3. **PR Description Template:**
   ```markdown
   ## What Changed
   Brief description of the changes

   ## Why
   Explanation of why this change is needed

   ## Testing
   - [ ] All tests pass
   - [ ] Added new tests for new features
   - [ ] Tested manually in multiple projects

   ## Documentation
   - [ ] Updated README.md
   - [ ] Updated CHANGELOG.md
   - [ ] Added inline comments
   ```

4. **CI/CD:**
   - GitHub Actions will run automatically
   - All checks must pass before merging
   - Fix any failing tests or linting issues

---

## 🎨 Feature Development Workflow

### Planning a Feature

1. **Create Feature Plan:**
   ```bash
   mkdir -p admin/planning/features/your-feature
   touch admin/planning/features/your-feature/feature-plan.md
   ```

2. **Document the Feature:**
   - Problem statement
   - Proposed solution
   - Implementation phases
   - Success criteria

3. **Break into Phases:**
   - Create `phase-1.md`, `phase-2.md`, etc.
   - Track progress with checkboxes
   - Document decisions and learnings

### Implementing a Feature

1. **Create Feature Branch:**
   ```bash
   git checkout develop
   git pull origin develop
   git checkout -b feat/your-feature
   ```

2. **Implement in Phases:**
   - Complete one phase at a time
   - Write tests as you go
   - Update documentation
   - Commit frequently

3. **Create Pull Request:**
   - One PR per phase (for large features)
   - Or one PR for entire feature (for small features)

---

## 🐛 Bug Fixes

### Reporting Bugs

**Include:**
- Clear description of the issue
- Steps to reproduce
- Expected vs actual behavior
- Environment (OS, bash version, etc.)
- Error messages or logs

### Fixing Bugs

1. **Create Fix Branch:**
   ```bash
   git checkout -b fix/issue-description
   ```

2. **Write a Failing Test:**
   - Reproduce the bug in a test
   - Verify the test fails

3. **Fix the Bug:**
   - Make minimal changes
   - Ensure the test now passes

4. **Submit Pull Request:**
   - Reference the issue number
   - Explain the fix

---

## 🔍 Code Review

### What We Look For

- ✅ **Correctness** - Does it work as intended?
- ✅ **Tests** - Are there tests? Do they pass?
- ✅ **Documentation** - Is it documented?
- ✅ **Style** - Follows project conventions?
- ✅ **Portability** - Works across environments?
- ✅ **Performance** - Efficient implementation?

### Review Process

1. **Automated Checks:**
   - CI/CD runs tests and linting
   - Must pass before review

2. **Manual Review:**
   - Code quality and style
   - Test coverage
   - Documentation completeness

3. **Feedback:**
   - Address review comments
   - Push updates to your branch
   - Re-request review

---

## 🏷️ Release Process

Releases are managed by maintainers. See [admin/planning/releases/README.md](admin/planning/releases/README.md) for the detailed release process.

**Version Numbering:**
- `MAJOR.MINOR.PATCH` (Semantic Versioning)
- `MAJOR` - Breaking changes
- `MINOR` - New features (backward compatible)
- `PATCH` - Bug fixes (backward compatible)

---

## 💡 Tips for Contributors

### Best Practices

1. **Keep PRs Focused** - One feature or fix per PR
2. **Write Tests First** - TDD approach when possible
3. **Document as You Go** - Don't leave docs for later
4. **Ask Questions** - Open an issue for discussion
5. **Be Patient** - Reviews take time

### Getting Help

- **Questions?** Open an issue with the `question` label
- **Stuck?** Ask in the PR comments
- **Ideas?** Open an issue with the `enhancement` label

### Learning Resources

- [Bash Best Practices](https://google.github.io/styleguide/shellguide.html)
- [bats-core Documentation](https://bats-core.readthedocs.io/)
- [Conventional Commits](https://www.conventionalcommits.org/)
- [Semantic Versioning](https://semver.org/)

---

## 🎉 Recognition

Contributors will be:
- Listed in release notes
- Credited in CHANGELOG.md
- Thanked in the community

---

## 📄 License

By contributing, you agree that your contributions will be licensed under the MIT License.

---

## 🙏 Thank You!

Every contribution, no matter how small, helps make Dev Toolkit better for everyone. Thank you for taking the time to contribute!

---

**Questions?** Open an issue or start a discussion on GitHub.

**Last Updated:** October 6, 2025

