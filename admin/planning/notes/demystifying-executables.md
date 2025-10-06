# Demystifying Executables: Commands Are Just Files

**Date:** October 6, 2025  
**Context:** Phase 3 Part C - Creating dt-review command  
**Insight:** Understanding that user commands are no different from system commands

---

## The Realization

When asked to create an "alias" for `dt-sourcery-parse`, the implementation created a new executable file (`bin/dt-review`) rather than a shell alias. This sparked an important realization:

> *"In Linux (or anywhere), we can make as many user bin files as we want. I was always abstracted from system or user executables, but once you're in this tech space, a lot of this is demystified."*

---

## What Was Demystified

### Before
- System commands like `ls`, `git`, `npm`, `curl` seemed like special, built-in features
- There was a perceived barrier between "real commands" and "scripts"
- Creating custom commands felt advanced or complicated

### After
- Commands are just executable files in directories on your `PATH`
- There's no fundamental difference between system commands and user commands
- Creating a command is as simple as:
  1. Write a script
  2. Make it executable (`chmod +x`)
  3. Put it in a directory on your `PATH`

---

## Why This Matters

### 1. **Empowerment**
You can create commands for any repetitive task. The computer isn't hiding anything from you - it's all just files and directories.

### 2. **Understanding the System**
When you run `git status`, you're not invoking magic. You're executing `/usr/bin/git` (or wherever it's installed) with the argument `status`. Your shell finds it by searching directories in `$PATH`.

### 3. **Better Tool Design**
Understanding this leads to better design decisions:
- **Executables** over shell aliases (portable, discoverable, testable)
- **PATH management** over hardcoded locations
- **Standard conventions** (like `bin/` directories) that work everywhere

---

## Practical Example: dt-review

### What It Does
```bash
dt-review 6
# Extracts Sourcery review for PR #6
# Saves to admin/feedback/sourcery/pr06.md
# Automatically includes --rich-details flag
```

### How It Works
1. **File Location**: `/Users/username/.dev-toolkit/bin/dt-review`
2. **Executable**: `chmod +x` makes it runnable
3. **PATH**: `install.sh` adds `~/.dev-toolkit/bin` to `PATH`
4. **Result**: Shell finds `dt-review` just like it finds `git`

### The Code
```bash
#!/usr/bin/env bash
# It's just a bash script!

# Handle help flags
if [[ "${1:-}" == "--help" ]] || [[ "${1:-}" == "-h" ]]; then
    echo "Usage: dt-review <PR_NUMBER>"
    exit 0
fi

# Get PR number
PR_NUMBER="${1:-}"

# Format and save
PR_PADDED=$(printf "pr%02d" "$PR_NUMBER")
OUTPUT_FILE="admin/feedback/sourcery/${PR_PADDED}.md"

# Call the main parser
dt-sourcery-parse "$PR_NUMBER" --rich-details --output "$OUTPUT_FILE"
```

---

## The Pattern

This pattern repeats throughout the dev-toolkit:

| Command | What It Is | Where It Lives |
|---------|-----------|----------------|
| `dt-git-safety` | Bash script | `~/.dev-toolkit/bin/dt-git-safety` |
| `dt-config` | Bash script | `~/.dev-toolkit/bin/dt-config` |
| `dt-review` | Bash script | `~/.dev-toolkit/bin/dt-review` |
| `git` | C program | `/usr/bin/git` |
| `npm` | JavaScript | `/usr/local/bin/npm` |
| `python` | C program | `/usr/bin/python` |

**They're all the same**: executable files on the `PATH`.

---

## Why Executables > Shell Aliases

When you could use a shell alias (`alias dt-review='dt-sourcery-parse --rich-details'`), why create an executable?

### Portability
- **Alias**: Only works in the shell where it's defined (bash, zsh, etc.)
- **Executable**: Works everywhere, in any shell, in scripts, in CI/CD

### Discoverability
- **Alias**: Hidden in `.bashrc` or `.zshrc`
- **Executable**: Shows up in `command -v`, tab completion, `which`

### Flexibility
- **Alias**: Simple string substitution
- **Executable**: Can have logic, validation, help text, error handling

### Testing
- **Alias**: Hard to test
- **Executable**: Can be tested like any other command (see `tests/integration/test-dt-sourcery-parse.bats`)

### Documentation
- **Alias**: No built-in help
- **Executable**: Can provide `--help`, version info, examples

---

## The Bigger Picture

### Breaking Down Barriers

Once you understand that commands are just files, several barriers disappear:

1. **"I can't modify system commands"** → You can wrap them, extend them, replace them
2. **"Creating tools is hard"** → It's just writing a script and putting it on the PATH
3. **"I need special permissions"** → Only for system directories; `~/.local/bin` is yours

### Opening Possibilities

This realization opens up endless possibilities:

- **Workflow automation**: Turn any repetitive task into a command
- **Team tools**: Share commands across your team via a toolkit repo
- **Personal productivity**: Create commands for your specific needs
- **Learning**: Understand how the system works by creating your own versions

---

## Examples of What You Can Build

### Simple Wrappers
```bash
#!/usr/bin/env bash
# git-quick: Quick commit and push
git add .
git commit -m "${1:-Quick update}"
git push
```

### Data Processing
```bash
#!/usr/bin/env bash
# json-pretty: Pretty print JSON
cat "$1" | python -m json.tool
```

### Project Navigation
```bash
#!/usr/bin/env bash
# goto-project: Jump to project directory
cd ~/Projects/"$1" || exit 1
```

### API Interactions
```bash
#!/usr/bin/env bash
# github-stars: Get star count for a repo
gh api repos/"$1" | jq '.stargazers_count'
```

---

## Key Takeaways

1. **Commands are just executable files** - There's no magic, no special system feature
2. **PATH is just a list of directories** - The shell searches them in order
3. **You can create commands** - Put a script in `~/bin` or `~/.local/bin` and add it to PATH
4. **Executables > Aliases** - More portable, discoverable, flexible, and testable
5. **The barrier is psychological** - Once you understand this, the system opens up

---

## Related

- **Implementation**: `bin/dt-review` (created in Phase 3 Part C)
- **Testing**: `tests/integration/test-dt-sourcery-parse.bats`
- **Documentation**: `docs/TESTING.md` (Issue 8: Testing Optional Features)
- **Installation**: `install.sh` (adds `bin/` to PATH)

---

## Further Reading

- `man bash` - Section on command execution and PATH
- [Filesystem Hierarchy Standard](https://refspecs.linuxfoundation.org/FHS_3.0/fhs/index.html) - Where executables live
- [Shebang](https://en.wikipedia.org/wiki/Shebang_(Unix)) - The `#!/usr/bin/env bash` line
- [PATH environment variable](https://en.wikipedia.org/wiki/PATH_(variable))

---

**The system is less mysterious than it seems. Commands are just files. You can create them too.** 🚀
