# Research: Command Workflow Integration

**Research Topic:** Doc Infrastructure  
**Question:** How will Cursor commands invoke dt-doc-gen and dt-doc-validate?  
**Status:** ✅ Complete  
**Priority:** 🔴 High (Blocking)  
**Created:** 2026-01-16  
**Completed:** 2026-01-17  
**Last Updated:** 2026-01-17

---

## 🎯 Research Question

How will Cursor commands (`/explore`, `/research`, `/decision`, etc.) invoke dt-doc-gen and dt-doc-validate? Dev-infra research established that commands should invoke scripts for structure generation while AI fills content. This creates a three-layer architecture: Library → CLI → Command Integration.

---

## 🔍 Research Goals

- [x] Goal 1: Review dev-infra research-command-integration.md findings
- [x] Goal 2: Design command invocation patterns for dev-toolkit context
- [x] Goal 3: Define migration order (start with `/explore`, `/research` per R7)
- [x] Goal 4: Document how two-mode commands (setup/conduct) map to dt-doc-gen modes
- [x] Goal 5: Plan integration testing strategy

---

## 📚 Research Methodology

**Note:** Web search is **allowed and encouraged** for research.

**Sources:**
- [x] Source 1: dev-infra research-command-integration.md (prior research)
- [x] Source 2: Cursor command definitions in `.cursor/commands/`
- [x] Source 3: dev-infra requirements.md (FR-26, FR-27, C-13)
- [x] Source 4: Web search: CLI workflow integration patterns

---

## 📊 Prior Research Summary (dev-infra)

The following was established in dev-infra research:

### Integration Architecture

```
Command (orchestrator)
    │
    ├─→ dt-doc-gen (structure, 0 AI tokens)
    │
    ├─→ AI (content, targeted tokens)
    │
    └─→ dt-doc-validate (verify before commit)
```

### Key Requirements

| ID | Requirement |
|----|-------------|
| FR-26 | Commands invoke `dt-doc-gen` for structure |
| FR-27 | Commands invoke `dt-doc-validate` before commit |
| FR-28 | Three placeholder types: `${VAR}`, `<!-- AI: -->`, `<!-- EXPAND: -->` |
| FR-30 | Migration is incremental, one command at a time |
| C-13 | Commands remain orchestrators; scripts are tools |

### Command-to-DocType Mapping

| Command | Doc Types | Mode Pattern |
|---------|-----------|--------------|
| `/explore` | exploration.md, research-topics.md, README.md | Two-mode |
| `/research` | research-*.md, requirements.md | Two-mode |
| `/decision` | adr-NNN.md, decisions-summary.md | Single |
| `/transition-plan` | feature-plan.md, phase-N.md | Single |
| `/handoff` | handoff.md | Single |
| `/fix-plan` | fix-batch-N.md | Single |

---

## 📊 Findings

### Finding 1: Current Commands Use Inline Templates (154 Instances)

Analysis of `.cursor/commands/` directory confirms the duplication problem from dev-infra research:

| Statistic | Value |
|-----------|-------|
| Total commands | 23 |
| Commands with inline templates | 23 |
| Inline template occurrences | 154 |
| Average templates per command | 6-7 |

**Pattern observed:** Commands define document structure using markdown code blocks:

```markdown
**File:** `admin/explorations/[topic]/exploration.md`

\`\`\`markdown
# Exploration: [Topic]

**Status:** 🔴 Scaffolding (needs expansion)
**Created:** YYYY-MM-DD
...
\`\`\`
```

**Source:** dev-infra research-command-integration.md

**Relevance:** This is the core problem - 154 format definitions that drift over time.

---

### Finding 2: Commands Already Invoke Shell Commands

Current commands use a pattern that maps directly to dt-doc-gen invocation:

**Current pattern (git operations):**
```markdown
**Commit changes:**

\`\`\`bash
git add admin/explorations/[topic]/
git commit -m "docs(explore): create [topic] exploration"
git push origin develop
\`\`\`
```

**Proposed pattern (dt-doc-gen + dt-doc-validate):**
```markdown
**Generate structure:**

\`\`\`bash
dt-doc-gen exploration my-topic --mode setup
\`\`\`

**AI fills content...** (command continues with content generation)

**Validate before commit:**

\`\`\`bash
dt-doc-validate admin/explorations/my-topic/
\`\`\`

**Commit changes:**

\`\`\`bash
git add admin/explorations/[topic]/
git commit -m "docs(explore): create [topic] exploration"
\`\`\`
```

**Source:** Analysis of `/explore` command in `.cursor/commands/explore.md`

**Relevance:** The invocation pattern already exists - we're just adding dt-doc-gen and dt-doc-validate calls.

---

### Finding 3: Two-Mode Commands Map to dt-doc-gen Modes

The `/explore` and `/research` commands have two modes that map cleanly to dt-doc-gen:

| Command Mode | dt-doc-gen Mode | Output | AI Role |
|--------------|-----------------|--------|---------|
| Setup Mode | `--mode setup` | Scaffolding (~60-80 lines) | Variable substitution only |
| Conduct Mode | `--mode conduct` | Full document (~200-300 lines) | Fill `<!-- AI: -->` and `<!-- EXPAND: -->` |

**Setup Mode Flow:**
```
/explore my-topic
    ↓
dt-doc-gen exploration my-topic --mode setup
    ↓
AI substitutes ${VAR} placeholders
    ↓
Human reviews scaffolding
    ↓
/explore my-topic --conduct
```

**Conduct Mode Flow:**
```
/explore my-topic --conduct
    ↓
dt-doc-gen reads existing scaffolding
    ↓
AI expands <!-- EXPAND: --> zones with detailed analysis
    ↓
dt-doc-validate admin/explorations/my-topic/
    ↓
git commit
```

**Source:** `/explore` command definition, dev-infra FORMAT.md

**Relevance:** Two-mode templates enable the human-review checkpoint workflow.

---

### Finding 4: Integration Pattern is "Orchestrator + Tools"

The pattern from dev-infra research translates to dev-toolkit:

```
┌──────────────────────────────────────────────────────────┐
│  Cursor Command (e.g., /explore)                         │
│  - Orchestrates workflow                                  │
│  - Handles user prompts                                   │
│  - Invokes dt-doc-gen for structure                       │
│  - Generates AI content for placeholders                  │
│  - Invokes dt-doc-validate before commit                  │
│  - Commits changes                                        │
└──────────────────────────────────────────────────────────┘
                          │
          ┌───────────────┴───────────────┐
          ▼                               ▼
┌─────────────────────┐     ┌─────────────────────────────┐
│  dt-doc-gen          │     │  AI (Cursor)                 │
│  - Generate structure│     │  - Fill <!-- AI: -->         │
│  - Variable expansion│     │  - Expand <!-- EXPAND: -->   │
│  - Mode handling     │     │  - Creative analysis         │
│  - 0 AI tokens       │     │  - Targeted tokens only      │
└─────────────────────┘     └─────────────────────────────┘
          │                               │
          └───────────────┬───────────────┘
                          ▼
┌──────────────────────────────────────────────────────────┐
│  dt-doc-validate                                          │
│  - Check structure compliance                             │
│  - Verify required sections                               │
│  - Report issues with fix suggestions                     │
│  - Exit 0/1/2 for CI integration                          │
└──────────────────────────────────────────────────────────┘
```

**Key insight:** Commands remain orchestrators. Scripts are tools that commands invoke.

**Source:** dev-infra research, web search on workflow integration

**Relevance:** Clean separation of concerns - AI doesn't generate structure, scripts do.

---

### Finding 5: Migration Strategy is Incremental

The migration from inline templates to dt-doc-gen follows a three-phase approach:

**Phase 1: Tooling Ready (No Command Changes)**
- Implement `dt-doc-gen` and `dt-doc-validate` in dev-toolkit
- Templates remain in dev-infra
- Commands unchanged - still use inline templates
- Can run tools manually for testing

**Phase 2: Incremental Migration**
- Update commands one at a time
- Start with `/explore` and `/research` (two-mode, highest value)
- Replace inline templates with dt-doc-gen calls
- Keep inline template as fallback during transition

**Phase 3: Cleanup**
- Remove inline templates from commands
- Commands only reference dt-doc-gen
- Commands become orchestrators, not template holders

**Migration Order (Priority):**

| Priority | Command | Rationale |
|----------|---------|-----------|
| 1 | `/explore` | Two-mode, high frequency, complex |
| 2 | `/research` | Two-mode, high frequency, complex |
| 3 | `/decision` | Single-mode, ADR generation |
| 4 | `/transition-plan` | Single-mode, planning |
| 5 | `/handoff` | Single-mode, session context |
| 6 | `/fix-plan` | Single-mode, fix batches |

**Source:** dev-infra research-command-integration.md, R7 recommendation

**Relevance:** Incremental migration reduces risk and allows validation at each step.

---

### Finding 6: CLI Invocation Patterns for dev-toolkit

**dt-doc-gen CLI Usage in Commands:**

```bash
# Setup mode - create scaffolding
dt-doc-gen exploration my-topic --mode setup

# Conduct mode - prepare for expansion
dt-doc-gen exploration my-topic --mode conduct

# With explicit template path (if needed)
dt-doc-gen exploration my-topic --mode setup --template-path ~/dev-infra/templates/

# Output to specific location
dt-doc-gen exploration my-topic --mode setup --output admin/explorations/my-topic/
```

**dt-doc-validate CLI Usage in Commands:**

```bash
# Validate single file
dt-doc-validate admin/explorations/my-topic/exploration.md

# Validate directory (all files)
dt-doc-validate admin/explorations/my-topic/

# Validate with explicit type (override auto-detect)
dt-doc-validate admin/explorations/my-topic/exploration.md --type exploration

# JSON output for tooling
dt-doc-validate admin/explorations/my-topic/ --format json
```

**Source:** Analysis of requirements, existing command patterns

**Relevance:** Defines the exact CLI interface commands will use.

---

### Finding 7: Testing Strategy for Command Integration

**Testing Layers:**

| Layer | What | How |
|-------|------|-----|
| **Unit** | dt-doc-gen generates correct structure | bats tests with fixture comparison |
| **Unit** | dt-doc-validate detects issues correctly | bats tests with valid/invalid fixtures |
| **Integration** | Commands invoke tools correctly | Manual testing per command |
| **E2E** | Full workflow produces valid output | Run command, validate output |

**Fixture-Based Testing:**

```bash
tests/
├── fixtures/
│   ├── exploration/
│   │   ├── input/         # Test inputs
│   │   ├── expected/      # Expected outputs
│   │   └── invalid/       # Invalid docs for validation testing
│   ├── research/
│   └── decision/
├── integration/
│   ├── test-dt-doc-gen.bats
│   └── test-dt-doc-validate.bats
```

**Command Integration Testing Checklist:**

- [ ] `/explore my-topic` generates correct scaffolding
- [ ] `/explore my-topic --conduct` expands correctly
- [ ] Validation runs before commit
- [ ] Validation errors prevent commit
- [ ] Exit codes are correct (0/1/2)

**Source:** dev-toolkit testing patterns, web research

**Relevance:** Testing strategy ensures tooling works correctly before command migration.

---

## 🔍 Analysis

### Key Insights

- [x] **Insight 1:** Commands already invoke shell commands - dt-doc-gen fits existing pattern
- [x] **Insight 2:** Two-mode commands (setup/conduct) map cleanly to dt-doc-gen modes
- [x] **Insight 3:** Commands remain orchestrators; scripts are tools (clean separation)
- [x] **Insight 4:** Migration is incremental - one command at a time, with fallback
- [x] **Insight 5:** `/explore` and `/research` should be migrated first (highest value)
- [x] **Insight 6:** Testing uses fixture comparison for deterministic validation

### Command Migration Pattern

**Before (inline template):**
```markdown
**Create exploration scaffolding:**

Create these files:

**File:** `admin/explorations/[topic]/exploration.md`

\`\`\`markdown
# Exploration: [Topic]

**Status:** 🔴 Scaffolding
**Created:** YYYY-MM-DD
...
\`\`\`
```

**After (dt-doc-gen invocation):**
```markdown
**Generate exploration structure:**

\`\`\`bash
dt-doc-gen exploration [topic] --mode setup --output admin/explorations/[topic]/
\`\`\`

**Fill AI placeholders:**

Now fill the `<!-- AI: -->` sections with content based on the user's input...

**Validate before commit:**

\`\`\`bash
dt-doc-validate admin/explorations/[topic]/
\`\`\`
```

---

## 💡 Recommendations

- [x] **Recommendation 1:** Implement dt-doc-gen with `--mode setup|conduct` for two-mode support
- [x] **Recommendation 2:** Commands invoke dt-doc-gen via `run_terminal_cmd` (existing pattern)
- [x] **Recommendation 3:** Commands invoke dt-doc-validate before every commit
- [x] **Recommendation 4:** Start migration with `/explore` command (highest complexity/value)
- [x] **Recommendation 5:** Use fixture-based testing for both dt-doc-gen and dt-doc-validate
- [x] **Recommendation 6:** Keep inline templates as fallback during Phase 2
- [x] **Recommendation 7:** Document CLI interface clearly for command authors

### Recommended CLI Interface

```bash
# dt-doc-gen
dt-doc-gen <doc-type> <topic> [--mode setup|conduct] [--output <path>] [--template-path <path>]

# Examples:
dt-doc-gen exploration my-feature --mode setup
dt-doc-gen research auth-system --mode conduct
dt-doc-gen decision api-versioning

# dt-doc-validate
dt-doc-validate <path> [--type <type>] [--format text|json] [--strict]

# Examples:
dt-doc-validate admin/explorations/my-feature/
dt-doc-validate admin/research/auth-system/research-options.md --type research_topic
dt-doc-validate . --format json
```

---

## 📋 Requirements Discovered

### Functional Requirements

- [x] **FR-CI1:** dt-doc-gen MUST support `--mode setup|conduct` for two-mode commands
- [x] **FR-CI2:** dt-doc-gen MUST output files to specified `--output` path
- [x] **FR-CI3:** dt-doc-validate MUST accept directory path for batch validation
- [x] **FR-CI4:** dt-doc-validate MUST return exit code 0 (pass), 1 (errors), 2 (system error)
- [x] **FR-CI5:** Commands MUST invoke dt-doc-validate before commit
- [x] **FR-CI6:** Commands MUST invoke dt-doc-gen instead of inline templates (post-migration)

### Non-Functional Requirements

- [x] **NFR-CI1:** Migration MUST be incremental (one command at a time)
- [x] **NFR-CI2:** Migration MUST NOT break existing command workflows
- [x] **NFR-CI3:** dt-doc-gen output MUST match current inline template output (compatibility)
- [x] **NFR-CI4:** Command invocation time for dt-doc-gen MUST be <1 second

### Constraints

- [x] **C-CI1:** Commands remain workflow orchestrators (no change to orchestration logic)
- [x] **C-CI2:** AI generates content only for placeholders, not structure
- [x] **C-CI3:** Inline templates may remain as fallback during migration (Phase 2)

---

## 🚀 Next Steps

1. ~~Conduct research~~ ✅ Complete
2. Update requirements.md with discovered requirements
3. Implement dt-doc-gen with mode support
4. Implement dt-doc-validate with directory support
5. Create fixture-based test suite
6. Migrate `/explore` command first

---

**Last Updated:** 2026-01-17
