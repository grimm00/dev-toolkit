# install.sh vs dev-setup.sh - Visual Guide

## The Simple Answer

```
┌─────────────────────────────────────────────────────────────┐
│  Want to USE the toolkit?        → Run: ./install.sh       │
│  Want to DEVELOP the toolkit?    → Run: source dev-setup.sh│
└─────────────────────────────────────────────────────────────┘
```

---

## Detailed Comparison

### install.sh - For Using the Toolkit

```
┌──────────────────────────────────────────────────────────────┐
│                     ./install.sh                             │
├──────────────────────────────────────────────────────────────┤
│                                                              │
│  1. Creates symlinks in /usr/local/bin/                     │
│     /usr/local/bin/dt-config → ~/.dev-toolkit/bin/dt-config│
│     /usr/local/bin/dt-git-safety → ...                      │
│     /usr/local/bin/dt-sourcery-parse → ...                  │
│                                                              │
│  2. Commands work from ANYWHERE:                             │
│     $ cd ~/Projects/my-app                                   │
│     $ dt-config show          ✅ Works!                      │
│     $ cd ~/Documents                                         │
│     $ dt-git-safety check     ✅ Works!                      │
│                                                              │
│  3. Permanent - survives terminal restarts                   │
│                                                              │
│  4. May need sudo for permissions                            │
│                                                              │
└──────────────────────────────────────────────────────────────┘
```

### dev-setup.sh - For Developing the Toolkit

```
┌──────────────────────────────────────────────────────────────┐
│                  source dev-setup.sh                         │
├──────────────────────────────────────────────────────────────┤
│                                                              │
│  1. Sets environment variables in CURRENT SHELL ONLY:        │
│     DT_ROOT=/Users/you/Projects/dev-toolkit                  │
│     PATH=/Users/you/Projects/dev-toolkit/bin:$PATH           │
│                                                              │
│  2. Commands work in THIS TERMINAL ONLY:                     │
│     Terminal 1:                    Terminal 2:               │
│     $ source dev-setup.sh          $ dt-config show          │
│     $ dt-config show               ❌ Doesn't work!          │
│     ✅ Works!                                                │
│                                                              │
│  3. Temporary - gone when terminal closes                    │
│                                                              │
│  4. No sudo needed, no files created                         │
│                                                              │
└──────────────────────────────────────────────────────────────┘
```

---

## The Critical Mistake: `./` vs `source`

### ❌ WRONG: Using `./dev-setup.sh`

```
Your Shell (zsh/bash)
│
├─ You run: ./dev-setup.sh
│
└─> Creates NEW sub-shell
    │
    ├─ Sets DT_ROOT in sub-shell
    ├─ Sets PATH in sub-shell
    │
    └─> Sub-shell EXITS
        (All variables are LOST!)

Back in your shell:
$ dt-config show
❌ Error: Cannot locate dev-toolkit installation
```

**What happened?** The variables were set in a temporary sub-shell that immediately exited.

### ✅ CORRECT: Using `source dev-setup.sh`

```
Your Shell (zsh/bash)
│
├─ You run: source dev-setup.sh
│
├─ Sets DT_ROOT in YOUR CURRENT SHELL
├─ Sets PATH in YOUR CURRENT SHELL
│
└─ Variables STAY in your shell

Still in your shell:
$ dt-config show
✅ Works! (Variables are still set)
```

**What happened?** The variables were set directly in your current shell session.

---

## Real-World Usage Examples

### Scenario 1: You Want to Use the Toolkit Daily

```bash
# One-time setup
cd ~/Projects
git clone https://github.com/yourusername/dev-toolkit.git
cd dev-toolkit
./install.sh                    # May need: sudo ./install.sh

# Now use anywhere
cd ~/Projects/my-app
dt-sourcery-parse 42
dt-git-safety check

cd ~/Projects/another-app
dt-config show                  # Still works!
```

### Scenario 2: You're Developing the Toolkit

```bash
# Every time you open a new terminal
cd ~/Projects/dev-toolkit
source dev-setup.sh             # MUST use 'source'!

# Make changes
vim lib/core/github-utils.sh

# Test immediately
dt-config show                  # Tests your changes

# Make more changes
vim lib/git-flow/safety.sh

# Test again
dt-git-safety check             # Tests new changes

# When done, commit
git add .
git commit -m "Your changes"
```

### Scenario 3: You're Doing Both

```bash
# Install for daily use
./install.sh

# But also developing
source dev-setup.sh             # Overrides installed version

# Now commands use your development version
dt-config show                  # Uses code from current directory

# Open new terminal
dt-config show                  # Uses installed version
```

---

## Quick Decision Tree

```
Do you want to modify the toolkit code?
│
├─ YES → Use: source dev-setup.sh
│         (Test your changes immediately)
│
└─ NO  → Use: ./install.sh
          (Install for regular use)
```

---

## Common Questions

### Q: Why can't dev-setup.sh just work with `./`?

**A:** Because environment variables set in a sub-shell don't transfer to the parent shell. This is how Unix/Linux shells work by design.

### Q: Can I make dev-setup.sh permanent?

**A:** Yes! Add these lines to your `~/.zshrc` or `~/.bashrc`:

```bash
export DT_ROOT="/Users/cdwilson/Projects/dev-toolkit"
export PATH="$DT_ROOT/bin:$PATH"
```

Then every new terminal will have these variables set.

### Q: I ran install.sh but commands still don't work?

**A:** Check if `/usr/local/bin` is in your PATH:

```bash
echo $PATH | grep /usr/local/bin
```

If not, add to `~/.zshrc`:

```bash
export PATH="/usr/local/bin:$PATH"
```

### Q: Which one should I use?

**A:** 
- **Developing?** → `source dev-setup.sh`
- **Using?** → `./install.sh`
- **Both?** → Install first, then source when developing

---

## Summary

| Aspect | install.sh | dev-setup.sh |
|--------|-----------|--------------|
| **Run with** | `./install.sh` | `source dev-setup.sh` |
| **Purpose** | Production use | Development/testing |
| **Scope** | System-wide | Current terminal only |
| **Duration** | Permanent | Until terminal closes |
| **Requires sudo** | Maybe | No |
| **Creates files** | Yes (symlinks) | No |
| **Best for** | Daily use | Making changes |

---

**Still confused?** See [Troubleshooting Guide](troubleshooting/common-issues.md)
