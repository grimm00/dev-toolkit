# Dev Toolkit Project Structure

**Purpose:** Template for organizing development utilities and AI-assisted projects  
**Version:** v0.2.0  
**Last Updated:** October 6, 2025

---

## 📁 Complete Directory Tree

```
.
├── .cursor/                          # Cursor IDE configuration
│   └── rules/
│       └── development-rules.mdc     # AI assistant rules and guidelines
│
├── .github/                          # GitHub configuration
│   ├── markdown-link-check-config.json
│   └── workflows/
│       └── ci.yml                    # CI/CD pipeline
│
├── admin/                            # Project management hub
│   ├── chat-logs/                    # AI conversation history
│   │   └── 2025/
│   │       ├── 2025-01-06-dev-toolkit-inception.md
│   │       └── 2025-10-05-testing-suite-phase-2.md
│   │
│   ├── feedback/                     # External code reviews
│   │   └── sourcery/
│   │       ├── pr06.md
│   │       ├── pr08.md
│   │       ├── pr09.md
│   │       └── pr10.md
│   │
│   ├── planning/                     # Project planning
│   │   ├── features/                 # Feature-based planning
│   │   │   ├── optional-sourcery/
│   │   │   │   ├── feature-plan.md
│   │   │   │   └── phase-1.md
│   │   │   ├── testing-suite/
│   │   │   │   ├── feature-plan.md
│   │   │   │   ├── phase-1.md
│   │   │   │   ├── phase-2.md
│   │   │   │   ├── phase-3.md
│   │   │   │   ├── testing-approach-decisions.md
│   │   │   │   └── testing-framework-comparison.md
│   │   │   └── README.md
│   │   │
│   │   ├── releases/                 # Release management
│   │   │   ├── v0.2.0/
│   │   │   │   ├── checklist.md
│   │   │   │   └── release-notes.md
│   │   │   ├── history.md
│   │   │   └── README.md
│   │   │
│   │   ├── notes/                    # Planning insights
│   │   │   ├── opportunities/        # Feature opportunities
│   │   │   │   ├── internal/         # From dev-toolkit usage
│   │   │   │   ├── external/         # From other projects
│   │   │   │   │   └── workflow-helper/
│   │   │   │   │       ├── workflow-helper-analysis.md
│   │   │   │   │       └── workflow-helper-template-idea.md
│   │   │   │   └── README.md
│   │   │   └── demystifying-executables.md
│   │   │
│   │   ├── phases/                   # Historical phase tracking
│   │   │   └── phase1-foundation.md
│   │   │
│   │   └── roadmap.md                # High-level roadmap
│   │
│   ├── docs/                         # Admin-specific docs (empty)
│   ├── testing/                      # Test strategies (empty)
│   ├── dev-toolkit-handoff-prompt.md # Original handoff document
│   ├── project-structure.txt         # Raw tree output
│   ├── PROJECT-STRUCTURE.md          # This file
│   └── README.md                     # Admin directory guide
│
├── bin/                              # Command wrappers (executables)
│   ├── dt-config
│   ├── dt-git-safety
│   ├── dt-install-hooks
│   ├── dt-review
│   ├── dt-setup-sourcery
│   └── dt-sourcery-parse
│
├── config/                           # Configuration templates
│   └── config.example
│
├── docs/                             # User documentation
│   ├── troubleshooting/
│   │   ├── common-issues.md
│   │   ├── sourcery-parser-no-comments.md
│   │   └── testing-issues.md
│   ├── INSTALL-VS-DEV-SETUP.md
│   ├── OPTIONAL-FEATURES.md
│   ├── SIMPLE-EXPLANATION.md
│   ├── SOURCERY-SETUP.md
│   └── TESTING.md
│
├── examples/                         # Usage examples (empty)
│
├── lib/                              # Core library code
│   ├── core/
│   │   └── github-utils.sh
│   ├── git-flow/
│   │   ├── hooks/
│   │   │   └── pre-commit
│   │   ├── safety.sh
│   │   └── utils.sh
│   └── sourcery/
│       └── parser.sh
│
├── scripts/                          # Development scripts
│   └── test.sh
│
├── tests/                            # Automated tests
│   ├── fixtures/                     # Test data (empty, reserved)
│   │   ├── configs/
│   │   ├── repos/
│   │   └── responses/
│   ├── helpers/
│   │   ├── assertions.bash
│   │   ├── mocks.bash
│   │   └── setup.bash
│   ├── integration/
│   │   ├── test-dt-config.bats
│   │   ├── test-dt-git-safety.bats
│   │   ├── test-dt-install-hooks.bats
│   │   └── test-dt-sourcery-parse.bats
│   └── unit/
│       ├── core/
│       │   ├── test-github-utils-basic.bats
│       │   ├── test-github-utils-git.bats
│       │   ├── test-github-utils-output.bats
│       │   ├── test-github-utils-validation.bats
│       │   └── test-simple.bats
│       ├── git-flow/
│       │   ├── test-git-flow-safety.bats
│       │   └── test-git-flow-utils.bats
│       └── sourcery/
│
├── CHANGELOG.md                      # Version history
├── dev-setup.sh                      # Development environment setup
├── install.sh                        # Global installation script
├── LICENSE                           # Project license
├── QUICK-START.md                    # Quick reference guide
├── README.md                         # Main project documentation
└── VERSION                           # Current version number
```

---

## 🎯 Key Directories Explained

### `.cursor/rules/`
**Purpose:** Configuration for Cursor IDE and AI assistants  
**Key Files:**
- `development-rules.mdc` - Guidelines for AI-assisted development
- Testing requirements, code quality standards, project context

**Why:** Ensures consistent AI behavior across sessions

---

### `.github/workflows/`
**Purpose:** CI/CD automation  
**Key Files:**
- `ci.yml` - Runs tests, linting, and documentation checks
- `markdown-link-check-config.json` - Link checker configuration

**Triggers:**
- Push to `main` (validates releases)
- Pull requests to `main` or `develop`

**Why:** Automated quality gates before merging

---

### `admin/`
**Purpose:** Project management and AI coordination hub  

**Subdirectories:**

#### `admin/chat-logs/`
- AI conversation history
- Organized by year
- Descriptive filenames with dates
- **Example:** `2025-10-05-testing-suite-phase-2.md`

#### `admin/feedback/sourcery/`
- Sourcery AI code review extracts
- Organized by PR number
- Includes priority matrices and action plans
- **Generated by:** `dt-review <PR_NUMBER>`

#### `admin/planning/features/`
- Feature-based planning and tracking
- Each feature has its own directory
- Contains `feature-plan.md` and phase documents
- **Example:** `testing-suite/phase-1.md`

#### `admin/planning/releases/`
- Release management
- Each release has its own directory
- Contains `checklist.md` and `release-notes.md`
- **Example:** `v0.2.0/checklist.md`

#### `admin/planning/notes/`
- Planning insights and decisions
- Design patterns and learnings
- **Example:** `demystifying-executables.md`

#### `admin/planning/notes/opportunities/`
- Feature opportunities discovered from real-world usage
- Organized into `internal/` (from dev-toolkit) and `external/` (from other projects)
- Each opportunity has its own subdirectory with analysis and proposal docs
- **Example:** `external/workflow-helper/workflow-helper-analysis.md`
- **Lifecycle:** Discovery → Analysis → Proposal → Feature Plan → Implementation

**Why:** Provides context for AI agents, tracks decisions, manages releases, captures feature ideas organically

---

### `bin/`
**Purpose:** Command-line executables  
**Pattern:** All files are executable wrappers that call `lib/` functions

**Commands:**
- `dt-config` - Configuration management
- `dt-git-safety` - Git Flow safety checks
- `dt-install-hooks` - Install Git hooks
- `dt-review` - Extract Sourcery reviews (alias for dt-sourcery-parse)
- `dt-setup-sourcery` - Interactive Sourcery setup
- `dt-sourcery-parse` - Parse Sourcery AI reviews

**Why:** Provides user-facing CLI, keeps logic in libraries

---

### `lib/`
**Purpose:** Core library code (sourced by commands)

**Structure:**
- `core/` - Core utilities (GitHub, configuration)
- `git-flow/` - Git Flow automation
- `sourcery/` - Sourcery AI integration

**Pattern:** Functions prefixed by module (e.g., `gh_`, `gf_`)

**Why:** Reusable, testable, modular code

---

### `tests/`
**Purpose:** Automated testing with bats-core

**Structure:**
- `unit/` - Unit tests for library functions
- `integration/` - End-to-end command tests
- `helpers/` - Test utilities (setup, mocks, assertions)
- `fixtures/` - Test data (reserved, currently empty)

**Stats:** 215 tests (144 unit + 71 integration), < 15s execution

**Why:** Regression prevention, safe refactoring, quality assurance

---

### `docs/`
**Purpose:** User-facing documentation

**Structure:**
- Root level - Feature guides
- `troubleshooting/` - Problem-solving guides

**Key Files:**
- `TESTING.md` - Testing guide
- `OPTIONAL-FEATURES.md` - Core vs optional features
- `troubleshooting/testing-issues.md` - Testing troubleshooting

**Why:** Comprehensive user documentation

---

## 🔑 Key Files Explained

### Root Level

#### `VERSION`
- Single line with version number (e.g., `0.2.0`)
- Updated during release process
- Used by scripts for version display

#### `CHANGELOG.md`
- Follows [Keep a Changelog](https://keepachangelog.com/) format
- Categories: Added, Changed, Fixed, Improved
- Updated during release preparation

#### `README.md`
- Main project documentation
- Installation instructions
- Command reference
- Links to detailed docs

#### `install.sh`
- Global installation script
- Creates symlinks to `~/.dev-toolkit/bin/`
- Adds to PATH
- Checks dependencies

#### `dev-setup.sh`
- Development environment setup
- Sets `DT_ROOT` environment variable
- Adds `bin/` to PATH for current session
- **Must be sourced:** `source dev-setup.sh`

---

## 📊 Statistics (v0.2.0)

- **Total Files:** 60
- **Total Directories:** 42
- **Commands:** 6
- **Library Modules:** 4
- **Tests:** 215 (144 unit + 71 integration)
- **Documentation:** 2,800+ lines
- **Planning Documents:** 15+ files

---

## 🎨 Design Patterns

### Opportunity Discovery (New in v0.2.0)
1. Discover pattern/need during real-world usage
2. Create subdirectory: `admin/planning/notes/opportunities/{internal|external}/<feature-name>/`
3. Write `analysis.md` to understand current state and problem
4. Write `proposal.md` or `*-idea.md` to design solution
5. Promote to feature when approved (move to `features/`)
6. Keep opportunity docs as historical context

**Key Principle:** Subdirectory per opportunity prevents file overflow

### Feature Development
1. Create `admin/planning/features/<feature-name>/`
2. Write `feature-plan.md` with vision and phases
3. Create phase documents as you go
4. Track progress with checkboxes
5. Document decisions and learnings

### Release Management
1. Create `admin/planning/releases/vX.Y.Z/`
2. Use `checklist.md` to track steps
3. Write polished `release-notes.md`
4. Update `history.md` and `roadmap.md`
5. Document lessons learned

### Testing Strategy
1. Unit tests in `tests/unit/<module>/`
2. Integration tests in `tests/integration/`
3. Test helpers in `tests/helpers/`
4. Dynamic test creation (no static fixtures)
5. Function mocking with `export -f`

### Documentation Structure
1. User guides in `docs/`
2. Troubleshooting in `docs/troubleshooting/`
3. Planning in `admin/planning/`
4. Code reviews in `admin/feedback/`

---

## 🔄 Git Flow

### Branches
- `main` - Production releases only
- `develop` - Ongoing development
- `feat/*` - Feature branches
- `fix/*` - Bug fixes
- `release/*` - Release preparation
- `hotfix/*` - Emergency fixes

### Workflow
1. Feature development on `feat/*` branches
2. PR to `develop`
3. CI runs on PR
4. Merge to `develop`
5. Release branch from `develop`
6. Merge release to `main`
7. Tag release
8. Merge back to `develop`

---

## 🛠️ Technology Stack

- **Language:** Bash (maximum portability)
- **Testing:** bats-core (Bash Automated Testing System)
- **CI/CD:** GitHub Actions
- **Code Review:** Sourcery AI (optional)
- **Version Control:** Git with Git Flow
- **Documentation:** Markdown
- **IDE:** Cursor with AI rules

---

## 📦 Dependencies

### Required
- `bash` (4.0+)
- `git` (2.0+)
- `gh` (GitHub CLI)

### Optional
- `jq` (for performance)
- Sourcery AI (for code review)

### Development
- `bats-core` (for testing)
- `shellcheck` (for linting)

---

## 🎯 Adapting This Structure

### For New Projects

1. **Copy Structure:**
   ```bash
   mkdir -p {admin/{chat-logs,feedback,planning/{features,releases,notes/{opportunities/{internal,external}},phases},docs,testing},bin,config,docs/troubleshooting,examples,lib/{core,git-flow,sourcery},scripts,tests/{fixtures,helpers,integration,unit}}
   ```

2. **Copy Key Files:**
   - `.cursor/rules/development-rules.mdc`
   - `.github/workflows/ci.yml`
   - `admin/README.md`
   - `admin/planning/features/README.md`
   - `admin/planning/releases/README.md`
   - `admin/planning/notes/opportunities/README.md`
   - `scripts/test.sh`
   - `tests/helpers/*.bash`

3. **Customize:**
   - Update `README.md` with project details
   - Modify `.cursor/rules/` for project-specific guidelines
   - Adapt `install.sh` for project needs
   - Update `CHANGELOG.md` with project name

4. **Initialize:**
   - Create `VERSION` file
   - Write initial `CHANGELOG.md` entry
   - Create `admin/planning/roadmap.md`
   - Set up first feature in `admin/planning/features/`

---

## 💡 Key Learnings

1. **Admin Structure is Essential** - Provides context for AI agents and tracks decisions
2. **Opportunity Tracking** - Subdirectories per opportunity prevent file overflow and keep related docs together
3. **Real-World Discovery** - Best features emerge from actual usage (e.g., workflow-helper from Pokehub)
4. **Feature-Based Planning** - Easier to manage than phase-based alone
5. **Release Directories** - Each release gets its own workspace
6. **Comprehensive Testing** - 215 tests provide confidence for changes
7. **Documentation First** - Good docs prevent confusion and rework
8. **CI/CD Integration** - Automated quality gates catch issues early
9. **Lessons Learned** - Document what worked and what didn't

---

## 📚 Related Documentation

- [Admin README](README.md) - Admin directory guide
- [Feature Workflow](planning/features/README.md) - Feature development process
- [Release Process](planning/releases/README.md) - Release management guide
- [Roadmap](planning/roadmap.md) - Project direction and priorities
- [Testing Guide](../docs/TESTING.md) - How to write and run tests

---

**This structure is battle-tested through v0.2.0 release with 215 automated tests! 🎉**

*Last Updated: October 6, 2025*
