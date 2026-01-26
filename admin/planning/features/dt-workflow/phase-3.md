# dt-workflow - Phase 3: Cursor Integration

**Phase:** 3 - Cursor Integration  
**Duration:** 6-8 hours  
**Status:** 🟠 In Progress  
**Last Updated:** 2026-01-26
**Prerequisites:** Phase 2 complete (PR #33 merged 2026-01-26)

---

## 📋 Overview

Update Cursor commands (`/explore`, `/research`, `/decision`) to use dt-workflow as the orchestrator, per ADR-004 (Cursor commands as orchestrators).

**Success Definition:** Cursor commands invoke dt-workflow for core logic, maintaining IDE integration while preserving portability.

**ADR-004 Pattern:**

```
User: /explore my-feature
        │
        ▼
┌─────────────────────────────────────────────┐
│  Cursor Command (.cursor/commands/explore.md)│
│  - Handles Cursor-specific behavior          │
│  - May add Cursor context                    │
│  - Invokes dt-workflow                       │
└─────────────────────────────────────────────┘
        │
        ▼
┌─────────────────────────────────────────────┐
│  dt-workflow explore topic --interactive     │
│  - Gathers universal context                 │
│  - Generates structure                       │
│  - Outputs for AI                            │
└─────────────────────────────────────────────┘
```

---

## 🎯 Goals

1. **Orchestrator Pattern** - Cursor commands call dt-workflow for core logic
2. **End-to-End Chain** - Full workflow from `/explore` to `/decision`
3. **Documentation** - Updated command documentation with dt-workflow integration

---

## 📝 Tasks

### Task Group 1: Update /explore Command (1-2 hours)

#### Task 1: Add dt-workflow Integration Section

**Purpose:** Document how `/explore` uses dt-workflow for structure generation.

**Steps:**

1. **Read current explore.md structure:**
   - [x] Review `.cursor/commands/explore.md`
   - [x] Identify where dt-workflow integration fits
   - [x] Note existing workflow steps that dt-workflow replaces/enhances

2. **Add dt-workflow Integration section:**
   - [x] Add new section "## dt-workflow Integration" after Configuration
   - [x] Document the orchestrator pattern per ADR-004
   - [x] Show command invocation: `dt-workflow explore <topic> --interactive`
   - [x] Explain what dt-workflow provides (context injection, structure)

3. **Update workflow steps:**
   - [x] In Setup Mode, add step to run dt-workflow first
   - [x] Add note that dt-workflow provides injected context (rules, project identity)
   - [x] Update any manual context gathering steps to reference dt-workflow output

**Integration Section Template:**

```markdown
## dt-workflow Integration

**Per ADR-004:** This command acts as an orchestrator, calling dt-workflow for core logic.

### Command Invocation

Before conducting the exploration, run dt-workflow to gather context:

```bash
# Get exploration context and structure
dt-workflow explore <topic> --interactive
```

### What dt-workflow Provides

1. **Injected Context:**
   - Cursor rules (.cursor/rules/*.mdc)
   - Project identity (roadmap, admin structure)
   - Workflow-specific context

2. **Structure Template:**
   - Exploration template with structural examples
   - Required markers for completeness
   - Research topics placeholder

### Workflow

1. Run `dt-workflow explore <topic> --interactive`
2. Use output as starting context for exploration
3. Follow exploration steps with injected context
4. Create handoff file (research-topics.md) when complete
```

**Checklist:**
- [x] Integration section added
- [x] dt-workflow command documented
- [x] Workflow steps updated
- [x] ADR-004 referenced

---

#### Task 2: Update Setup Mode Steps

**Purpose:** Integrate dt-workflow into Setup Mode workflow.

**Steps:**

1. **Read Setup Mode section:**
   - [x] Identify current step sequence
   - [x] Find where dt-workflow invocation fits

2. **Add dt-workflow as first step:**
   - [x] Add "Step 0: Gather Context" or integrate into Step 1
   - [x] Document: `dt-workflow explore <topic> --interactive`
   - [x] Note: Output provides injected context + structure

3. **Update subsequent steps:**
   - [x] Reference dt-workflow output in structure creation
   - [x] Update any manual context gathering to use dt-workflow
   - [x] Ensure handoff file guidance is consistent

**Checklist:**
- [x] Setup Mode updated
- [x] dt-workflow invocation as first step
- [x] Steps reference dt-workflow output
- [x] Handoff file creation consistent

---

#### Task 3: Update Conduct Mode Steps

**Purpose:** Ensure Conduct Mode also uses dt-workflow context.

**Steps:**

1. **Read Conduct Mode section:**
   - [x] Identify where context is gathered
   - [x] Check if scaffolding expansion needs dt-workflow

2. **Add context refresh option:**
   - [x] Document: Can re-run dt-workflow for fresh context
   - [x] Note: Useful when project context has changed
   - [x] Keep Conduct Mode focused on expansion, not regeneration

**Checklist:**
- [x] Conduct Mode reviewed
- [x] Context refresh documented
- [x] Expansion workflow preserved

---

### Task Group 2: Update /research Command (1-2 hours)

#### Task 4: Add dt-workflow Integration Section

**Purpose:** Document how `/research` uses dt-workflow for research scaffolding.

**Steps:**

1. **Read current research.md structure:**
   - [x] Review `.cursor/commands/research.md`
   - [x] Identify where dt-workflow integration fits
   - [x] Note existing workflow steps

2. **Add dt-workflow Integration section:**
   - [x] Add section "## dt-workflow Integration" after Configuration
   - [x] Document orchestrator pattern
   - [x] Show command: `dt-workflow research <topic> --from-explore --interactive`
   - [x] Document workflow chaining via `--from-explore` flag

3. **Document context chaining:**
   - [x] Explain `--from-explore` auto-detection
   - [x] Show explicit path option: `--from-explore /path/to/exploration`
   - [x] Note: research-topics.md provides handoff context

**Integration Section Template:**

```markdown
## dt-workflow Integration

**Per ADR-004:** This command acts as an orchestrator, calling dt-workflow for core logic.

### Command Invocation

Before conducting research, run dt-workflow to gather context:

```bash
# Auto-detect exploration (looks for admin/explorations/<topic>/)
dt-workflow research <topic> --from-explore --interactive

# Or with explicit path
dt-workflow research <topic> --from-explore /path/to/exploration --interactive
```

### What dt-workflow Provides

1. **Chained Context:**
   - Exploration context (from research-topics.md)
   - Research questions to investigate
   - Previous workflow handoff

2. **Injected Context:**
   - Cursor rules (.cursor/rules/*.mdc)
   - Project identity (roadmap, admin structure)

3. **Structure Template:**
   - Research template with structural examples
   - Required markers for completeness
   - Handoff guidance for decision workflow

### Workflow

1. Ensure exploration complete (research-topics.md exists)
2. Run `dt-workflow research <topic> --from-explore --interactive`
3. Use output as starting context for research
4. Follow research steps with injected context
5. Create handoff file (research-summary.md) when complete
```

**Checklist:**
- [ ] Integration section added
- [ ] --from-explore flag documented
- [ ] Auto-detection explained
- [ ] Handoff file documented

---

#### Task 5: Update Setup Mode Steps

**Purpose:** Integrate dt-workflow into research Setup Mode.

**Steps:**

1. **Add dt-workflow as first step:**
   - [x] Document invocation before creating structure
   - [x] Show how to verify exploration exists first
   - [x] Note auto-detection behavior

2. **Update prerequisite checking:**
   - [x] Can use `dt-workflow research --validate` to check prerequisites
   - [x] Document error handling when exploration missing

**Checklist:**
- [x] Setup Mode updated
- [x] Prerequisites documented
- [x] Validation option documented

---

#### Task 6: Update Conduct Mode Steps

**Purpose:** Ensure research Conduct Mode uses dt-workflow context.

**Steps:**

1. **Review Conduct Mode workflow:**
   - [x] Identify where web search fits
   - [x] Note: dt-workflow provides structure, not research content

2. **Document context usage:**
   - [x] Conduct Mode uses structure from dt-workflow
   - [x] AI fills in research findings
   - [x] Handoff file created at end

**Checklist:**
- [x] Conduct Mode reviewed
- [x] Context usage clear
- [x] Handoff file documented

---

### Task Group 3: Update /decision Command (1-2 hours)

#### Task 7: Add dt-workflow Integration Section

**Purpose:** Document how `/decision` uses dt-workflow for ADR generation.

**Steps:**

1. **Read current decision.md structure:**
   - [x] Review `.cursor/commands/decision.md`
   - [x] Identify where dt-workflow integration fits
   - [x] Note existing ADR creation workflow

2. **Add dt-workflow Integration section:**
   - [x] Add section "## dt-workflow Integration" after Configuration
   - [x] Document orchestrator pattern
   - [x] Show command: `dt-workflow decision <topic> --from-research --interactive`
   - [x] Document workflow chaining via `--from-research` flag

3. **Document context chaining:**
   - [x] Explain `--from-research` auto-detection
   - [x] Show explicit path option
   - [x] Note: research-summary.md provides handoff context

**Integration Section Template:**

```markdown
## dt-workflow Integration

**Per ADR-004:** This command acts as an orchestrator, calling dt-workflow for core logic.

### Command Invocation

Before making decisions, run dt-workflow to gather context:

```bash
# Auto-detect research (looks for admin/research/<topic>/)
dt-workflow decision <topic> --from-research --interactive

# Or with explicit path
dt-workflow decision <topic> --from-research /path/to/research --interactive
```

### What dt-workflow Provides

1. **Chained Context:**
   - Research summary (from research-summary.md)
   - Research findings and recommendations
   - Requirements extracted from research

2. **Injected Context:**
   - Cursor rules (.cursor/rules/*.mdc)
   - Project identity (roadmap, admin structure)

3. **Structure Template:**
   - ADR template with structural examples
   - Required markers for completeness
   - Decision documentation guidance

### Workflow

1. Ensure research complete (research-summary.md exists)
2. Run `dt-workflow decision <topic> --from-research --interactive`
3. Use output as starting context for decision
4. Follow decision steps with injected context
5. Create ADR document(s) when complete
```

**Checklist:**
- [ ] Integration section added
- [ ] --from-research flag documented
- [ ] Auto-detection explained
- [ ] ADR creation documented

---

#### Task 8: Update Decision Process Steps

**Purpose:** Integrate dt-workflow into decision process.

**Steps:**

1. **Add dt-workflow as first step:**
   - [ ] Document invocation before decision process
   - [ ] Show how to verify research exists first
   - [ ] Note auto-detection behavior

2. **Update ADR creation:**
   - [ ] dt-workflow provides ADR structure
   - [ ] AI fills in decision content
   - [ ] Multiple ADRs may be created per topic

**Checklist:**
- [ ] Decision steps updated
- [ ] ADR workflow documented
- [ ] Multiple ADR handling noted

---

### Task Group 4: End-to-End Testing Documentation (1-2 hours)

#### Task 9: Create Integration Test Scenarios

**Purpose:** Document end-to-end workflow testing with dt-workflow.

**Steps:**

1. **Add scenarios to manual-testing.md:**
   - [ ] Scenario: Full chain with dt-workflow (`explore` → `research` → `decision`)
   - [ ] Scenario: Each command with dt-workflow integration
   - [ ] Scenario: Error handling (missing prerequisites)

2. **Document test steps:**
   - [ ] Test `/explore` invokes dt-workflow
   - [ ] Test `/research` chains from exploration
   - [ ] Test `/decision` chains from research
   - [ ] Verify context injection in all workflows

**Test Scenarios:**

```markdown
### Scenario 3.1: /explore with dt-workflow

**Objective:** Verify `/explore` uses dt-workflow for context

**Steps:**
1. Create test topic directory: `mkdir -p admin/explorations/test-cursor-integration`
2. Run dt-workflow explore:
   ```bash
   ./bin/dt-workflow explore test-cursor-integration --interactive | head -50
   ```
3. Verify output contains:
   - [ ] Cursor Rules section
   - [ ] Project Identity section
   - [ ] Exploration structure template

**Expected:** Output matches what `/explore` should use as starting context

---

### Scenario 3.2: /research with dt-workflow

**Objective:** Verify `/research` chains from exploration

**Prerequisites:** Exploration complete with research-topics.md

**Steps:**
1. Run dt-workflow research with --from-explore:
   ```bash
   ./bin/dt-workflow research test-cursor-integration --from-explore --interactive | head -50
   ```
2. Verify output contains:
   - [ ] Research topics from exploration
   - [ ] Research structure template
   - [ ] Handoff guidance

**Expected:** Output shows chained context from exploration

---

### Scenario 3.3: /decision with dt-workflow

**Objective:** Verify `/decision` chains from research

**Prerequisites:** Research complete with research-summary.md

**Steps:**
1. Run dt-workflow decision with --from-research:
   ```bash
   ./bin/dt-workflow decision test-cursor-integration --from-research --interactive | head -50
   ```
2. Verify output contains:
   - [ ] Research summary context
   - [ ] ADR structure template
   - [ ] Decision documentation guidance

**Expected:** Output shows chained context from research

---

### Scenario 3.4: Full Workflow Chain

**Objective:** Verify complete explore→research→decision chain

**Steps:**
1. Start exploration: `./bin/dt-workflow explore chain-test --interactive`
2. (Simulate exploration completion - create research-topics.md)
3. Start research: `./bin/dt-workflow research chain-test --from-explore --interactive`
4. (Simulate research completion - create research-summary.md)
5. Start decision: `./bin/dt-workflow decision chain-test --from-research --interactive`
6. Verify context flows through all stages

**Expected:** Each stage receives context from previous stage
```

**Checklist:**
- [ ] Test scenarios documented
- [ ] Each command tested with dt-workflow
- [ ] Full chain tested
- [ ] Error scenarios included

---

#### Task 10: Document Error Handling

**Purpose:** Document expected error behavior in Cursor commands.

**Steps:**

1. **Document prerequisite errors:**
   - [ ] `/research` without exploration: Expected error message
   - [ ] `/decision` without research: Expected error message
   - [ ] Missing handoff files: Guidance for user

2. **Add error scenarios to testing:**
   - [ ] Test missing exploration for research
   - [ ] Test missing research for decision
   - [ ] Verify helpful error messages

**Error Handling Scenarios:**

```markdown
### Scenario 3.5: Error - Missing Exploration

**Objective:** Verify helpful error when exploration missing

**Steps:**
1. Attempt research without exploration:
   ```bash
   ./bin/dt-workflow research nonexistent-topic --from-explore --validate 2>&1
   ```
2. Verify error message is helpful
3. Verify exit code is non-zero

**Expected:** Clear error indicating exploration not found

---

### Scenario 3.6: Error - Missing Research

**Objective:** Verify helpful error when research missing

**Steps:**
1. Attempt decision without research:
   ```bash
   ./bin/dt-workflow decision nonexistent-topic --from-research --validate 2>&1
   ```
2. Verify error message is helpful
3. Verify exit code is non-zero

**Expected:** Clear error indicating research not found
```

**Checklist:**
- [ ] Error scenarios documented
- [ ] Error messages are helpful
- [ ] User guidance included

---

### Task Group 5: Documentation Polish (1 hour)

#### Task 11: Add Cross-References

**Purpose:** Ensure all documents reference each other appropriately.

**Steps:**

1. **Update explore.md:**
   - [ ] Link to ADR-004
   - [ ] Link to dt-workflow help
   - [ ] Cross-reference research.md

2. **Update research.md:**
   - [ ] Link to ADR-004
   - [ ] Link to dt-workflow help
   - [ ] Cross-reference explore.md and decision.md

3. **Update decision.md:**
   - [ ] Link to ADR-004
   - [ ] Link to dt-workflow help
   - [ ] Cross-reference research.md

**Checklist:**
- [ ] ADR-004 linked from all commands
- [ ] dt-workflow documented in all commands
- [ ] Cross-references complete

---

#### Task 12: Update Related Documents

**Purpose:** Ensure related documentation is consistent.

**Steps:**

1. **Update workflow.mdc rule:**
   - [ ] Add note about dt-workflow integration
   - [ ] Reference ADR-004 pattern

2. **Update README files:**
   - [ ] `.cursor/commands/README.md` (if exists)
   - [ ] Note dt-workflow integration

**Checklist:**
- [ ] workflow.mdc updated
- [ ] README files consistent
- [ ] Integration documented

---

## ✅ Completion Criteria

- [ ] `/explore` command documents dt-workflow integration (Task 1-3)
- [ ] `/research` command documents dt-workflow integration (Task 4-6)
- [ ] `/decision` command documents dt-workflow integration (Task 7-8)
- [ ] End-to-end testing scenarios documented (Task 9-10)
- [ ] Cross-references and related docs updated (Task 11-12)
- [ ] Full workflow chain tested (`/explore` → `/research` → `/decision`)
- [ ] All commands reference ADR-004

---

## 📦 Deliverables

- Updated `.cursor/commands/explore.md` with dt-workflow integration
- Updated `.cursor/commands/research.md` with dt-workflow integration
- Updated `.cursor/commands/decision.md` with dt-workflow integration
- Updated `manual-testing.md` with Phase 3 scenarios
- Updated workflow rules with integration notes

---

## 📊 Progress Tracking

| Task | Status | Notes |
|------|--------|-------|
| Task 1: explore.md integration section | ✅ Complete | dt-workflow Integration section added |
| Task 2: explore.md Setup Mode | ✅ Complete | Checklist and output section updated |
| Task 3: explore.md Conduct Mode | ✅ Complete | Checklist updated with context refresh |
| Task 4: research.md integration section | ✅ Complete | dt-workflow section with chaining docs |
| Task 5: research.md Setup Mode | ✅ Complete | Step 0 with checklist and error handling |
| Task 6: research.md Conduct Mode | ✅ Complete | Context usage and handoff documented |
| Task 7: decision.md integration section | ✅ Complete | dt-workflow section with chaining docs |
| Task 8: decision.md process steps | 🔴 Not Started | |
| Task 9: Integration test scenarios | 🔴 Not Started | |
| Task 10: Error handling documentation | 🔴 Not Started | |
| Task 11: Cross-references | 🔴 Not Started | |
| Task 12: Related documents | 🔴 Not Started | |

---

## 🔗 Dependencies

### Prerequisites

- [x] Phase 2 complete (all workflows working) - PR #33 merged 2026-01-26

### Blocks

- Phase 4: Enhancement (requires stable integration)

---

## 🔗 Related Documents

- [Feature Hub](README.md)
- [Previous Phase: Phase 2](phase-2.md)
- [Next Phase: Phase 4](phase-4.md)
- [ADR-004: Cursor Command Role](../../decisions/dt-workflow/adr-004-cursor-command-role.md)

---

**Last Updated:** 2026-01-26  
**Status:** ✅ Expanded  
**Next:** Begin implementation with Task 1
