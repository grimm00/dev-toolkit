# The Simplest Possible Explanation

## You Have Two Scripts. Here's When to Use Each:

### 1. `install.sh` - "I want to USE this toolkit"

```bash
./install.sh
```

**What it does:** Installs the toolkit permanently on your computer  
**When to use:** You want to actually use the tools  
**Result:** Commands work from any directory, forever

**Example:**
```bash
cd ~/Projects/dev-toolkit
./install.sh

# Now go anywhere
cd ~/Documents
dt-config show    # ✅ Works!

# Even after restarting terminal
dt-config show    # ✅ Still works!
```

---

### 2. `dev-setup.sh` - "I want to TEST changes I'm making"

```bash
source dev-setup.sh
```

**What it does:** Temporarily sets up your current terminal  
**When to use:** You're modifying the code and want to test it  
**Result:** Commands work in this terminal only, until you close it

**Example:**
```bash
cd ~/Projects/dev-toolkit
source dev-setup.sh    # ⚠️ MUST use 'source'!

# Edit some code
vim lib/core/github-utils.sh

# Test your changes
dt-config show    # ✅ Works! Tests your changes

# Open new terminal
dt-config show    # ❌ Doesn't work (different terminal)

# Close and reopen this terminal
dt-config show    # ❌ Doesn't work (need to source again)
```

---

## The ONE Thing You MUST Remember About dev-setup.sh

### ❌ WRONG:
```bash
./dev-setup.sh
```

### ✅ CORRECT:
```bash
source dev-setup.sh
```

**Why?** The word `source` makes the script run in your current terminal instead of a temporary one.

---

## Which One Should YOU Use Right Now?

Answer these questions:

**Are you changing the code?**
- YES → Use `source dev-setup.sh`
- NO → Use `./install.sh`

**Do you want commands to work in all terminals?**
- YES → Use `./install.sh`
- NO → Use `source dev-setup.sh`

**Do you want this to be permanent?**
- YES → Use `./install.sh`
- NO → Use `source dev-setup.sh`

---

## Still Confused? Try This:

### For Most People (Just Want to Use It):
```bash
cd /Users/cdwilson/Projects/dev-toolkit
./install.sh
```

### For Developers (Making Changes):
```bash
cd /Users/cdwilson/Projects/dev-toolkit
source dev-setup.sh
```

---

## That's It!

Everything else is just details. Start with one of those two commands above.

**Need more details?** See:
- [Visual Guide](INSTALL-VS-DEV-SETUP.md)
- [Troubleshooting](troubleshooting/common-issues.md)
