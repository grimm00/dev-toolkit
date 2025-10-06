# Zshrc Consolidation Analysis

**Date:** October 6, 2025  
**Type:** Internal Opportunity  
**Origin:** Learned about executables vs aliases while building dev-toolkit  
**Question:** Can zshrc aliases be consolidated into robust executables?

---

## 🎯 Executive Summary

**Discovery:** While building dev-toolkit, realized that shell aliases can be replaced with executable scripts for better organization, robustness, and portability.

**Current State:** ~/.zshrc contains **~150+ aliases** across multiple domains:
- Git operations
- Kubernetes management
- Docker operations
- Project-specific workflows
- Development shortcuts

**Opportunity:** Consolidate related aliases into executable script collections, similar to dev-toolkit's pattern.

---

## 📊 Alias Inventory

### Category Breakdown

#### 1. **Git Aliases** (~20 aliases)
```bash
alias gc='git clone'
alias gs='git status'
alias ga='git add'
alias ga.='git add .'
alias gcm='git commit'
alias gcms='git commit -m'
alias gb="git branch"
alias gco="git checkout"
alias gcom="git checkout main"
alias gd="git diff"
alias gl="git config -l"
alias grso="git remote show origin"
alias isitgit="git rev-parse -–is-inside-work-tree"
alias adog="git log --all --decorate --oneline --graph"
alias gpl="git pull"
alias gp="git push"
alias gpu="git push -u"
alias gpush='git push origin $(git branch --show-current)'
alias gpull='git pull origin $(git branch --show-current)'
alias gst='git status'
alias gcb='git checkout -b'
alias glog='git log --oneline -10'
alias gbranch='git branch -v'
```

**Assessment:** ⚠️ **OVERLAP** - Many duplicate/similar aliases (gs/gst, gco/gco, etc.)

---

#### 2. **Kubernetes Aliases** (~80+ aliases!)
```bash
# Basic operations
alias k='kubectl'
alias kgp='k get pods'
alias kgs='k get services'
alias kgd='k get deployments'
# ... 70+ more kubectl aliases

# Context switching functions
switch-to-work-k8s()
switch-to-minikube()
k8s-context()

# Minikube
alias mk='minikube'
alias mks='minikube start'
alias mkst='minikube stop'
# ... more minikube aliases
```

**Assessment:** 🔴 **HIGH CONSOLIDATION POTENTIAL** - This is a perfect candidate for a `k8s-utils` executable collection

---

#### 3. **Docker Aliases** (~5 aliases)
```bash
alias docker-stop-all="docker stop \$(docker ps -q)"
alias docker-rm-all="docker rm \$(docker ps -aq)"
alias docker-cleanup="docker stop \$(docker ps -q) && docker rm \$(docker ps -aq) && docker system prune -f"
alias docker-reset="docker stop \$(docker ps -q) && docker rm \$(docker ps -aq) && docker network prune -f && docker volume prune -f && docker system prune -af"
```

**Assessment:** 🟡 **MEDIUM POTENTIAL** - Could be consolidated into `docker-utils`

---

#### 4. **Project-Specific Workflow Aliases** (~30+ aliases)
```bash
# Pokehub/Pokedex workflows
alias gf='cd /Users/cdwilson/Projects/pokedex && ./scripts/workflow-helper.sh'
alias gf-feature='cd /Users/cdwilson/Projects/pokedex && ./scripts/workflow-helper.sh start-feature'
alias gf-fix='cd /Users/cdwilson/Projects/pokedex && ./scripts/workflow-helper.sh start-fix'
# ... 25+ more workflow aliases

alias pokehub='cd /Users/cdwilson/Projects/pokedex'
alias pokehub-backend='cd /Users/cdwilson/Projects/pokedex && python -m backend.app'
alias pokehub-test='cd /Users/cdwilson/Projects/pokedex && npm test && cd backend && pytest'
```

**Assessment:** 🔴 **ALREADY SOLVED** - These should use the workflow-helper.sh directly, not via aliases!

---

#### 5. **Shell Configuration Aliases** (~5 aliases)
```bash
alias src='source ~/.zshrc'
alias crc='vim ~/.zshrc'
alias czp='vim ~/.zprofile'
alias diskspace='df -h'
alias h='history | grep'
```

**Assessment:** 🟢 **KEEP AS-IS** - These are appropriate as aliases (quick shell operations)

---

#### 6. **Project Directory Shortcuts** (~3 aliases)
```bash
export bop=~/Documents/book-of-practice/
alias bop=~/Documents/book-of-practice/
alias py101=~/Documents/python-101/
alias dex='cd ~/Projects/pokedex && source venv/bin/activate'
```

**Assessment:** 🟢 **KEEP AS-IS** - Quick navigation is appropriate for aliases

---

#### 7. **Custom Functions** (~2 functions)
```bash
list() { ... }  # Enhanced ls with options
switch-to-work-k8s() { ... }
switch-to-minikube() { ... }
k8s-context() { ... }
```

**Assessment:** 🟡 **COULD BE EXECUTABLES** - Functions are candidates for standalone scripts

---

## 🔍 Key Issues Identified

### 1. **Alias Duplication**
- `gs` and `gst` both = `git status`
- `gco` appears twice
- `kd` defined twice (kubectl delete AND kubectl get deployments)
- `kn` defined twice (kubectl get nodes AND kubens)

### 2. **Hardcoded Paths**
```bash
alias gf='cd /Users/cdwilson/Projects/pokedex && ./scripts/workflow-helper.sh'
alias urlx='python3 /Users/cdwilson/Projects/helpers/url_transform.py'
alias pokedex-frontend="cd /Users/cdwilson/Projects/pokedex/frontend && npm run dev"
```
**Problem:** Not portable, breaks if paths change

### 3. **Repetitive Pattern**
Almost every workflow alias follows this pattern:
```bash
alias <name>='cd /Users/cdwilson/Projects/pokedex && ./scripts/workflow-helper.sh <command>'
```
**Problem:** 30+ aliases doing the same thing with different commands

### 4. **Kubernetes Alias Explosion**
80+ kubectl aliases is excessive and hard to remember/maintain

### 5. **Missing Error Handling**
Aliases don't validate inputs or provide helpful error messages

---

## 💡 Consolidation Opportunities

### Opportunity 1: **K8s Utilities Suite** 🔴 HIGH PRIORITY
**Current:** 80+ kubectl aliases  
**Proposed:** `k8s` executable with subcommands

```bash
# Instead of:
alias kgp='kubectl get pods'
alias kdp='kubectl describe pod'
alias kdelp='kubectl delete pod'

# Use:
k8s pods              # List pods
k8s pods <name>       # Describe pod
k8s pods <name> -d    # Delete pod
k8s pods -w           # Wide output
k8s pods -y           # YAML output

# Context switching
k8s switch work       # Switch to work k8s
k8s switch local      # Switch to minikube
k8s context           # Show current context

# Common operations
k8s get <resource>
k8s describe <resource> <name>
k8s delete <resource> <name>
k8s logs <pod>
k8s exec <pod>
```

**Benefits:**
- Reduces 80+ aliases to 1 command
- Consistent interface
- Better error handling
- Help text built-in
- Tab completion possible

---

### Opportunity 2: **Git Utilities Cleanup** 🟡 MEDIUM PRIORITY
**Current:** ~20 git aliases with duplicates  
**Proposed:** Consolidate and deduplicate

```bash
# Keep essential aliases
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gpl='git pull'
alias gco='git checkout'
alias gb='git branch'
alias gd='git diff'
alias gl='git log --oneline -10'

# Remove duplicates (gst, gcm, etc.)
# Remove rarely-used (isitgit, grso, etc.)

# Or create git-utils executable
git-utils status
git-utils add <files>
git-utils commit <message>
```

**Benefits:**
- Cleaner zshrc
- No duplicates
- Consistent naming

---

### Opportunity 3: **Docker Utilities** 🟢 LOW PRIORITY
**Current:** 4 docker cleanup aliases  
**Proposed:** `docker-utils` executable

```bash
# Instead of:
alias docker-stop-all="docker stop \$(docker ps -q)"
alias docker-cleanup="..."
alias docker-reset="..."

# Use:
docker-utils stop-all
docker-utils cleanup
docker-utils reset
docker-utils prune
```

**Benefits:**
- Confirmation prompts
- Better error handling
- Dry-run mode

---

### Opportunity 4: **Project Workflow Simplification** 🔴 HIGH PRIORITY
**Current:** 30+ aliases that just call workflow-helper.sh  
**Proposed:** Remove aliases, use workflow-helper.sh directly OR create project switcher

**Option A: Use workflow-helper.sh directly**
```bash
# Instead of:
alias gf-feature='cd /Users/cdwilson/Projects/pokedex && ./scripts/workflow-helper.sh start-feature'

# Just use:
cd ~/Projects/pokedex
./scripts/workflow-helper.sh start-feature
# or
./scripts/workflow-helper.sh sf
```

**Option B: Create project context switcher**
```bash
# New executable: proj
proj pokedex          # Switch to pokedex project
proj pokedex sf feat  # Switch and run workflow-helper command

# Or even better:
proj pokedex          # Sets PROJECT_ROOT env var
wf sf feat            # Workflow helper uses PROJECT_ROOT
```

**Benefits:**
- Eliminates 30+ redundant aliases
- More portable (no hardcoded paths)
- Works with any project that has workflow-helper.sh

---

### Opportunity 5: **Custom Functions to Executables** 🟡 MEDIUM PRIORITY
**Current:** Functions in zshrc  
**Proposed:** Standalone executables

```bash
# Instead of:
list() { ... }  # 20+ line function in zshrc

# Create:
~/bin/list  # Standalone executable
```

**Benefits:**
- Cleaner zshrc
- Easier to test and maintain
- Can be versioned separately
- Reusable across shells (bash, zsh, etc.)

---

## 🎯 Proposed Structure

### Personal Utilities Collection
```
~/.local-utils/  (or ~/.shell-utils/)
├── bin/
│   ├── k8s              # Kubernetes utilities
│   ├── docker-utils     # Docker utilities
│   ├── git-utils        # Git utilities (optional)
│   ├── proj             # Project context switcher
│   └── list             # Enhanced ls
├── lib/
│   ├── k8s-utils.sh     # K8s helper functions
│   └── common.sh        # Shared utilities
└── README.md
```

### Updated ~/.zshrc
```bash
# Add utilities to PATH
export PATH="$HOME/.local-utils/bin:$PATH"

# Essential shell aliases (keep these)
alias src='source ~/.zshrc'
alias crc='vim ~/.zshrc'
alias diskspace='df -h'
alias h='history | grep'

# Essential git aliases (keep these)
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gpl='git pull'
alias gco='git checkout'
alias gb='git branch'
alias gd='git diff'
alias gl='git log --oneline -10'

# Project shortcuts (keep these)
export bop=~/Documents/book-of-practice/
alias bop=~/Documents/book-of-practice/
alias py101=~/Documents/python-101/
alias dex='cd ~/Projects/pokedex && source venv/bin/activate'

# Everything else becomes executables!
```

**Result:** ~150 aliases → ~20 aliases + robust executables

---

## 📊 Impact Analysis

### Before
```
~/.zshrc: ~450 lines
- ~150 aliases
- ~4 functions
- Hard to maintain
- Duplicates and conflicts
- No error handling
- Not portable
```

### After
```
~/.zshrc: ~150 lines
- ~20 essential aliases
- Clean and focused
- No duplicates

~/.local-utils/: Organized utilities
- k8s (replaces 80+ aliases)
- docker-utils (replaces 4 aliases)
- proj (replaces 30+ aliases)
- Robust error handling
- Help text
- Portable
- Testable
```

---

## 🚀 Implementation Priority

### Phase 1: High Priority (Immediate Impact) 🔴
1. **K8s Utilities** - Biggest win (80+ aliases → 1 command)
2. **Project Workflow Simplification** - Remove 30+ redundant aliases

### Phase 2: Medium Priority (Nice to Have) 🟡
3. **Git Utilities Cleanup** - Deduplicate and organize
4. **Functions to Executables** - Convert `list()` and k8s functions

### Phase 3: Low Priority (Optional) 🟢
5. **Docker Utilities** - Only 4 aliases, but good for consistency

---

## 💭 Key Questions

### 1. **Should this be part of dev-toolkit or separate?**
**Options:**
- **A:** Create `~/.local-utils/` as separate personal utilities
- **B:** Extend dev-toolkit with personal utilities module
- **C:** Create separate `shell-utils` repository

**Recommendation:** Start with **Option A** (separate), then consider **Option C** if it becomes generally useful

### 2. **What about Oh My Zsh plugins?**
Some of these utilities might already exist as OMZ plugins:
- `kubectl` plugin provides some k8s aliases
- `docker` plugin provides some docker aliases

**Recommendation:** Evaluate existing plugins first, create custom utilities for gaps

### 3. **How to handle project-specific workflows?**
**Options:**
- **A:** Remove aliases, use workflow-helper.sh directly
- **B:** Create `proj` context switcher
- **C:** Extend dev-toolkit with project context awareness

**Recommendation:** **Option B** - Create `proj` switcher for flexibility

---

## 📚 Related Learnings

### From Dev-Toolkit
1. **Executables > Aliases** - More robust, testable, portable
2. **Command Routing** - Use case statements for subcommands
3. **Help Text** - Essential for usability
4. **Error Handling** - Validate inputs, provide clear messages
5. **Modularity** - Separate concerns (bin/ vs lib/)

### From Workflow-Helper Pattern
1. **Project Context** - Detect project root automatically
2. **Consistent Interface** - Same commands across projects
3. **Convenience Wrappers** - Short aliases for common operations
4. **Safety Checks** - Validate before destructive operations

---

## 🎯 Success Criteria

### Measurable Goals
- [ ] Reduce zshrc from ~450 lines to ~150 lines
- [ ] Reduce aliases from ~150 to ~20
- [ ] Eliminate all duplicate aliases
- [ ] Remove all hardcoded paths
- [ ] All utilities have help text
- [ ] All utilities have error handling

### Quality Goals
- [ ] Utilities are portable (work on any machine)
- [ ] Utilities are testable (can write tests)
- [ ] Utilities are documented (README + help text)
- [ ] Utilities are maintainable (clear code structure)

---

## 📝 Next Steps

1. **Create proposal document** with detailed implementation plan
2. **Prioritize Phase 1** utilities (k8s, project workflow)
3. **Prototype `k8s` utility** to validate approach
4. **Test in parallel** with existing aliases
5. **Gradually migrate** as utilities prove useful
6. **Document patterns** for future utilities

---

**Status:** Analysis Complete  
**Recommendation:** Proceed with proposal for Phase 1 utilities  
**Estimated Effort:** 2-3 days for Phase 1 (k8s + project workflow)  
**Estimated Impact:** HIGH - Cleaner shell config, better tooling, reusable patterns
