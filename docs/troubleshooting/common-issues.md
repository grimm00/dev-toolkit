# Dev Toolkit - Troubleshooting Guide

Common issues and their solutions when using dev-toolkit.

---

## Understanding install.sh vs dev-setup.sh

### Quick Answer

| Script | When to Use | How to Run |
|--------|-------------|------------|
| **`install.sh`** | Production use, want commands everywhere | `./install.sh` (may need sudo) |
| **`dev-setup.sh`** | Development/testing, temporary setup | `source dev-setup.sh` (MUST use source!) |

### install.sh - Production Installation

**Purpose:** Install toolkit system-wide for actual use

```bash
cd /path/to/dev-toolkit
./install.sh              # or sudo ./install.sh if needed
```

**What it does:**
- Creates symlinks in `/usr/local/bin/`
- Makes commands available everywhere
- Permanent installation
- May require sudo for permissions

**After running:**
```bash
cd ~/any/directory
dt-config show           # Works from anywhere!
```

### dev-setup.sh - Development Environment

**Purpose:** Temporarily set up environment for testing

```bash
cd /path/to/dev-toolkit
source dev-setup.sh      # MUST use 'source'!
```

**What it does:**
- Sets `DT_ROOT` in current shell only
- Adds `bin/` to PATH temporarily
- No permanent changes
- Only affects current terminal session

**After running:**
```bash
dt-config show           # Works in this terminal
# Open new terminal -> won't work there
```

### Common Mistake: Running dev-setup.sh Wrong

❌ **WRONG:**
```bash
./dev-setup.sh           # Runs in sub-shell, doesn't work!
dt-config show           # Still fails!
```

✅ **CORRECT:**
```bash
source dev-setup.sh      # Runs in current shell
dt-config show           # Now works!
```

**Why?** When you use `./`, the script runs in a sub-shell that exits immediately, losing all environment variables. Using `source` runs it in your current shell, keeping the variables.

---

## Installation Issues

### Issue: "Cannot locate dev-toolkit installation"

**Symptom:**
```bash
❌ Error: Cannot locate dev-toolkit installation
💡 Set DT_ROOT environment variable or install to ~/.dev-toolkit
```

**Cause:**
The command wrappers cannot find the toolkit installation location.

**Solutions:**

#### Option 1: Set DT_ROOT Environment Variable (Recommended for Development)
If you're developing or testing the toolkit from a custom location:

```bash
# Set for current session
export DT_ROOT="/Users/cdwilson/Projects/dev-toolkit"

# Add to your shell profile for persistence
echo 'export DT_ROOT="/Users/cdwilson/Projects/dev-toolkit"' >> ~/.zshrc
source ~/.zshrc

# Now commands will work
dt-config show
```

#### Option 2: Install to Standard Location
Install the toolkit to `~/.dev-toolkit`:

```bash
cd /Users/cdwilson/Projects/dev-toolkit
./install.sh
```

This will:
- Create symlinks in `/usr/local/bin`
- Set up the standard installation location
- Make commands available globally

#### Option 3: Use Direct Paths (Testing)
For quick testing without installation:

```bash
# Run scripts directly
./bin/dt-config show
./lib/sourcery/parser.sh 42
./lib/git-flow/safety.sh check
```

#### Option 4: Add bin/ to PATH
Add the toolkit's bin directory to your PATH:

```bash
export PATH="/Users/cdwilson/Projects/dev-toolkit/bin:$PATH"
export DT_ROOT="/Users/cdwilson/Projects/dev-toolkit"
```

---

## Configuration Issues

### Issue: "Config file not found"

**Symptom:**
```bash
⚠️  No global config found
⚠️  No project config found
```

**Solution:**
Create a configuration file:

```bash
# Create global config
dt-config create global

# Or create project-local config
dt-config create project
```

---

## Git Flow Issues

### Issue: "Not in a Git repository"

**Symptom:**
```bash
❌ Error: Not in a Git repository
```

**Solution:**
Make sure you're running the command from within a git repository:

```bash
cd /path/to/your/git/repo
dt-git-safety check
```

---

### Issue: "Cannot determine repository information"

**Symptom:**
```bash
⚠️  Cannot determine repository information from GitHub
   Project Name: unknown
💡 Make sure you have a git remote configured
```

**Cause:**
The toolkit cannot detect your repository information from git remotes.

**Solutions:**

1. **Check if you have a remote configured:**
   ```bash
   git remote -v
   ```

2. **Add a remote if missing:**
   ```bash
   git remote add origin https://github.com/username/repo.git
   ```

3. **Verify GitHub CLI authentication:**
   ```bash
   gh auth status
   ```

4. **Re-authenticate if needed:**
   ```bash
   gh auth login
   ```

---

## Sourcery Parser Issues

### Issue: "No Sourcery review found"

**Symptom:**
```bash
⚠️  No Sourcery review found for PR #42
```

**Possible Causes:**
1. The PR doesn't have a Sourcery review yet
2. Sourcery bot hasn't been triggered
3. Wrong PR number

**Solutions:**

1. **Verify PR exists:**
   ```bash
   gh pr view 42
   ```

2. **Check if Sourcery has reviewed:**
   - Visit the PR on GitHub
   - Look for a review from `sourcery-ai`

3. **Try your current open PR:**
   ```bash
   dt-sourcery-parse  # Uses current user's open PR
   ```

---

## Permission Issues

### Issue: "Permission denied" when creating symlinks

**Symptom:**
```bash
ℹ️  Creating command symlinks...
rm: /usr/local/bin/dt-config: Permission denied
```

**Cause:**
The installer needs sudo permissions to create symlinks in `/usr/local/bin/`.

**Solution:**

**Option 1: Run with sudo (Recommended)**
```bash
sudo ./install.sh
# Enter your password when prompted
```

**Option 2: Create symlinks manually**
```bash
sudo ln -sf /Users/cdwilson/Projects/dev-toolkit/bin/dt-config /usr/local/bin/dt-config
sudo ln -sf /Users/cdwilson/Projects/dev-toolkit/bin/dt-git-safety /usr/local/bin/dt-git-safety
sudo ln -sf /Users/cdwilson/Projects/dev-toolkit/bin/dt-sourcery-parse /usr/local/bin/dt-sourcery-parse
```

**Option 3: Install without symlinks (Development mode)**
```bash
./install.sh --no-symlinks
# Then use: source dev-setup.sh
```

**Option 4: Use a directory you own**
If you don't have sudo access, you can create symlinks in a directory you own:

```bash
# Create a personal bin directory
mkdir -p ~/bin

# Add to PATH (add to ~/.zshrc for persistence)
export PATH="$HOME/bin:$PATH"

# Create symlinks there (no sudo needed)
ln -sf /Users/cdwilson/Projects/dev-toolkit/bin/dt-config ~/bin/dt-config
ln -sf /Users/cdwilson/Projects/dev-toolkit/bin/dt-git-safety ~/bin/dt-git-safety
ln -sf /Users/cdwilson/Projects/dev-toolkit/bin/dt-sourcery-parse ~/bin/dt-sourcery-parse

# Test
dt-config show
```

---

## Dependency Issues

### Issue: "Missing required dependencies"

**Symptom:**
```bash
❌ Missing required dependencies: gh
```

**Solution:**
Install the missing dependencies:

```bash
# macOS
brew install gh git

# Linux (Debian/Ubuntu)
sudo apt-get install gh git

# Verify installation
gh --version
git --version
```

---

### Issue: "jq not found" warnings

**Symptom:**
```bash
⚠️  Optional dependencies not found: jq
💡 Some features may be limited
```

**Impact:**
- GitHub API batch operations will be slower
- PR checks may use individual API calls

**Solution:**
Install jq for better performance:

```bash
# macOS
brew install jq

# Linux (Debian/Ubuntu)
sudo apt-get install jq

# Verify installation
jq --version
```

---

## Path Issues

### Issue: Commands not found after installation

**Symptom:**
```bash
command not found: dt-config
```

**Solutions:**

1. **Verify symlinks were created:**
   ```bash
   ls -la /usr/local/bin/dt-*
   ```

2. **Check if /usr/local/bin is in PATH:**
   ```bash
   echo $PATH | grep /usr/local/bin
   ```

3. **Add to PATH if missing:**
   ```bash
   echo 'export PATH="/usr/local/bin:$PATH"' >> ~/.zshrc
   source ~/.zshrc
   ```

4. **Reinstall with proper permissions:**
   ```bash
   ./install.sh
   ```

---

## Development/Testing Issues

### Issue: Testing changes without reinstalling

**Problem:**
You're making changes to the toolkit and want to test without running install.sh each time.

**Solution:**
Use DT_ROOT and direct execution:

```bash
# Set DT_ROOT to your development directory
export DT_ROOT="/Users/cdwilson/Projects/dev-toolkit"

# Test commands directly
./bin/dt-config show
./lib/git-flow/safety.sh check

# Or add to PATH temporarily
export PATH="$DT_ROOT/bin:$PATH"
dt-config show
```

---

## GitHub Authentication Issues

### Issue: "Not authenticated with GitHub"

**Symptom:**
```bash
❌ Not authenticated with GitHub
💡 Please authenticate with GitHub:
   gh auth login
```

**Solution:**

1. **Authenticate with GitHub CLI:**
   ```bash
   gh auth login
   ```

2. **Follow the prompts:**
   - Choose GitHub.com
   - Choose HTTPS or SSH
   - Authenticate via web browser or token

3. **Verify authentication:**
   ```bash
   gh auth status
   ```

---

## Debugging Tips

### Enable Verbose Mode

For detailed debugging information:

```bash
# Git Flow operations
export GF_VERBOSE=true
dt-git-safety check

# Or use GF_DEBUG
export GF_DEBUG=true
./lib/git-flow/safety.sh check
```

### Check Script Syntax

Verify bash syntax without running:

```bash
bash -n ./lib/core/github-utils.sh
bash -n ./lib/git-flow/utils.sh
bash -n ./lib/sourcery/parser.sh
```

### Manual Testing

Test individual components:

```bash
# Source utilities directly
source ./lib/core/github-utils.sh
gh_show_config

# Test auto-detection
source ./lib/core/github-utils.sh
gh_detect_project_info
echo "Project: $PROJECT_NAME"
echo "Repo: $PROJECT_REPO"
```

---

## Getting Help

If you encounter an issue not covered here:

1. **Check the logs:**
   - Installation logs are displayed during install
   - Script output shows detailed error messages

2. **Verify your environment:**
   ```bash
   # Check shell
   echo $SHELL
   
   # Check PATH
   echo $PATH
   
   # Check toolkit location
   echo $DT_ROOT
   ```

3. **Run with verbose mode:**
   ```bash
   GF_VERBOSE=true dt-git-safety check
   ```

4. **Check GitHub issues:**
   - Look for similar issues in the repository
   - Create a new issue with details

---

## Quick Reference: Environment Variables

| Variable | Purpose | Example |
|----------|---------|---------|
| `DT_ROOT` | Toolkit installation location | `/Users/cdwilson/Projects/dev-toolkit` |
| `GF_VERBOSE` | Enable verbose Git Flow output | `true` or `false` |
| `GF_DEBUG` | Enable debug mode | `true` or `false` |
| `GITHUB_MAIN_BRANCH` | Override main branch name | `main` or `master` |
| `GITHUB_DEVELOP_BRANCH` | Override develop branch name | `develop` |
| `GIT_FLOW_MAIN_BRANCH` | Git Flow main branch | `main` |
| `GIT_FLOW_DEVELOP_BRANCH` | Git Flow develop branch | `develop` |

---

**Last Updated:** October 6, 2025  
**Version:** 0.1.0-alpha
