# Dev Toolkit - Handoff Prompt for New Repository

**Date**: October 5, 2025  
**Purpose**: Handoff context when opening dev-toolkit repository in new Cursor window  
**Status**: Ready to create repository

---

## 🎯 Context Summary

We're creating a **standalone dev-toolkit repository** that extracts and consolidates development utilities from multiple projects (REPO-Magic, Pokehub, etc.) into a single, portable, project-agnostic toolkit.

---

## 📋 What We've Done So Far

### **In Pokehub (Current Session)**:
1. ✅ **Phase 1 Complete**: Ported `github-utils.sh` from REPO-Magic
2. ✅ **Phase 2 Complete**: Ported `sourcery-review-parser.sh` from REPO-Magic
3. ✅ **Planning Complete**: Created comprehensive dev-toolkit plan
4. ✅ **Decision Made**: Create standalone `dev-toolkit` repository

### **Planning Documents Created**:
- `admin/planning/notes/portable-sourcery-tools-discussion.md` - Options analysis
- `admin/planning/notes/standalone-sourcery-toolkit-plan.md` - Sourcery-only plan
- `admin/planning/notes/comprehensive-dev-toolkit-plan.md` - **Full toolkit plan** ⭐

---

## 🚀 Next Steps: Create Dev Toolkit Repository

### **Repository Details**:
- **Name**: `dev-toolkit`
- **Owner**: grimm00
- **Visibility**: Public (or private, user to decide)
- **License**: MIT
- **Description**: Portable development toolkit with Sourcery automation, Git Flow utilities, and GitHub integration

---

## 📦 What to Extract from Pokehub

### **Files to Copy**:
1. **`scripts/core/github-utils.sh`** (455 lines)
   - GitHub CLI utilities
   - Status printing functions
   - Project configuration
   - **Needs**: Make project-agnostic (auto-detect from git)

2. **`scripts/monitoring/sourcery-review-parser.sh`** (337 lines)
   - Sourcery review parser
   - Multiple output modes
   - **Needs**: Update imports to toolkit structure

3. **`scripts/core/git-flow-utils.sh`** (if exists)
   - Git Flow utilities
   - Branch management
   - **Needs**: Make project-agnostic

4. **`scripts/core/git-flow-safety.sh`** (if exists)
   - Safety checks
   - Conflict detection
   - Branch validation
   - **Needs**: Make project-agnostic

---

## 🗂️ Repository Structure to Create

```
dev-toolkit/
├── README.md                       # Main documentation
├── LICENSE                         # MIT License
├── install.sh                      # Installation script
├── VERSION                         # v0.1.0-alpha
├── CHANGELOG.md                    # Track changes
│
├── bin/                            # Executable commands
│   ├── dt-sourcery-parse          # Wrapper for parser
│   ├── dt-git-cleanup             # Branch cleanup
│   └── dt-config                  # Configuration management
│
├── lib/                            # Core libraries
│   ├── core/
│   │   ├── github-utils.sh        # From Pokehub
│   │   ├── git-utils.sh           # Extract from git-flow-utils.sh
│   │   └── config.sh              # New: Configuration management
│   │
│   ├── sourcery/
│   │   └── parser.sh              # From Pokehub (sourcery-review-parser.sh)
│   │
│   └── git-flow/
│       ├── safety.sh              # From Pokehub (git-flow-safety.sh)
│       └── workflow.sh            # From Pokehub (git-flow-utils.sh)
│
├── config/
│   ├── config.example             # Example configuration
│   └── .dev-toolkit.yml.example   # Per-project config template
│
├── docs/
│   ├── README.md                  # Documentation index
│   ├── installation.md            # Installation guide
│   └── configuration.md           # Configuration guide
│
└── examples/
    └── basic-usage.sh             # Basic examples
```

---

## 🔧 Key Adaptations Needed

### **1. Make github-utils.sh Project-Agnostic**

**Current (Hardcoded)**:
```bash
PROJECT_NAME="Pokehub"
PROJECT_OWNER="grimm00"
PROJECT_REPO="grimm00/pokedex"
```

**Future (Auto-Detect)**:
```bash
# Auto-detect from git remote
detect_project_info() {
    if command -v gh >/dev/null 2>&1; then
        PROJECT_REPO=$(gh repo view --json nameWithOwner --jq '.nameWithOwner' 2>/dev/null)
    else
        # Fallback: parse git remote
        PROJECT_REPO=$(git remote get-url origin 2>/dev/null | sed -E 's/.*[:/]([^/]+\/[^/]+)(\.git)?$/\1/')
    fi
    
    PROJECT_NAME=$(basename "$PROJECT_REPO")
    PROJECT_OWNER=$(dirname "$PROJECT_REPO")
}

# Call on initialization
detect_project_info
```

### **2. Update Import Paths**

**Current**:
```bash
source "$SCRIPT_DIR/../core/github-utils.sh"
```

**Future**:
```bash
# Detect toolkit installation
TOOLKIT_ROOT="${DT_ROOT:-$HOME/.dev-toolkit}"
source "$TOOLKIT_ROOT/lib/core/github-utils.sh"
```

### **3. Add Configuration System**

Create `lib/core/config.sh`:
```bash
# Load global config
load_global_config() {
    if [ -f "$HOME/.dev-toolkit/config" ]; then
        source "$HOME/.dev-toolkit/config"
    fi
}

# Load project config
load_project_config() {
    if [ -f ".dev-toolkit.yml" ]; then
        # Parse YAML config
        parse_yaml_config ".dev-toolkit.yml"
    fi
}
```

---

## 📝 Implementation Order

### **Phase 1: Repository Setup** (15 minutes)
1. Create `dev-toolkit` repository on GitHub
2. Clone locally: `git clone https://github.com/grimm00/dev-toolkit.git`
3. Create basic structure (directories)
4. Add README.md with vision and goals
5. Add LICENSE (MIT)
6. Add .gitignore
7. Initial commit

### **Phase 2: Extract Core Utilities** (30 minutes)
1. Copy `github-utils.sh` to `lib/core/`
2. Make project-agnostic (auto-detect)
3. Test in isolation
4. Commit

### **Phase 3: Extract Sourcery Parser** (20 minutes)
1. Copy `sourcery-review-parser.sh` to `lib/sourcery/parser.sh`
2. Update imports
3. Test with Pokehub PR
4. Commit

### **Phase 4: Create Command Wrappers** (30 minutes)
1. Create `bin/dt-sourcery-parse`
2. Add argument parsing
3. Add help text
4. Test
5. Commit

### **Phase 5: Installation Script** (30 minutes)
1. Create `install.sh`
2. Add dependency checking
3. Add symlink creation
4. Test on clean system
5. Commit

### **Phase 6: Documentation** (30 minutes)
1. Write comprehensive README
2. Installation guide
3. Usage examples
4. Commit and tag v0.1.0-alpha

---

## 🎯 Handoff Prompt for New Cursor Window

**Copy this when opening dev-toolkit in new window**:

```
I'm creating a standalone dev-toolkit repository that consolidates development utilities from multiple projects. 

Context:
- Extracting tools from Pokehub (grimm00/pokedex) and REPO-Magic
- Goal: Portable, project-agnostic development toolkit
- Includes: Sourcery automation, Git Flow utilities, GitHub integration

Current Status:
- Repository created (or about to be created)
- Need to extract and adapt tools from Pokehub

Source Files (in Pokehub):
1. scripts/core/github-utils.sh (455 lines) - GitHub utilities
2. scripts/monitoring/sourcery-review-parser.sh (337 lines) - Sourcery parser
3. scripts/core/git-flow-*.sh - Git Flow utilities

Key Adaptations Needed:
1. Make github-utils.sh project-agnostic (auto-detect from git)
2. Update import paths to use toolkit structure
3. Create command wrappers in bin/ (dt-sourcery-parse, etc)
4. Create installation script
5. Write documentation

Implementation Plan:
Phase 1: Repository setup (basic structure)
Phase 2: Extract core utilities (github-utils.sh)
Phase 3: Extract Sourcery parser
Phase 4: Create command wrappers
Phase 5: Installation script
Phase 6: Documentation

Full plan available in Pokehub:
/Users/cdwilson/Projects/pokedex/admin/planning/notes/comprehensive-dev-toolkit-plan.md

Let's start with Phase 1: Repository setup.
```

---

## 📂 File Locations Reference

### **In Pokehub** (Source):
- `/Users/cdwilson/Projects/pokedex/scripts/core/github-utils.sh`
- `/Users/cdwilson/Projects/pokedex/scripts/monitoring/sourcery-review-parser.sh`
- `/Users/cdwilson/Projects/pokedex/scripts/core/git-flow-utils.sh` (if exists)
- `/Users/cdwilson/Projects/pokedex/scripts/core/git-flow-safety.sh` (if exists)

### **Planning Documents**:
- `/Users/cdwilson/Projects/pokedex/admin/planning/notes/comprehensive-dev-toolkit-plan.md` ⭐

---

## ✅ Pre-Creation Checklist

Before creating repository:
- [ ] Decide on visibility (public or private)
- [ ] Decide on license (MIT recommended)
- [ ] Choose installation location (`~/.dev-toolkit` recommended)
- [ ] Decide on command prefix (`dt-` recommended)

---

## 🚀 Quick Start Commands

### **Create Repository**:
```bash
# Via GitHub CLI
gh repo create dev-toolkit --public --license mit --description "Portable development toolkit with Sourcery automation, Git Flow utilities, and GitHub integration"

# Clone locally
cd ~/Projects
git clone https://github.com/grimm00/dev-toolkit.git
cd dev-toolkit
```

### **Create Basic Structure**:
```bash
mkdir -p bin lib/core lib/sourcery lib/git-flow config docs examples tests
touch README.md LICENSE VERSION CHANGELOG.md install.sh
echo "0.1.0-alpha" > VERSION
```

---

## 💡 Tips for New Session

1. **Keep Pokehub open**: You'll need to reference and copy files
2. **Test frequently**: Test each extracted tool before moving to next
3. **Commit often**: Small, focused commits
4. **Document as you go**: Update README with each addition
5. **Version carefully**: Start with v0.1.0-alpha, increment as you add features

---

**Last Updated**: October 5, 2025  
**Status**: Ready to create repository  
**Next Action**: Create dev-toolkit repository on GitHub
