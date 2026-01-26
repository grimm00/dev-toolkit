# Manual Testing Guide - dt-workflow

**Feature:** dt-workflow - Unified Workflow Orchestration  
**Phases Covered:** 1, 2, 3  
**Last Updated:** 2026-01-26  
**Status:** ✅ Active

---

## 📋 Overview

This guide provides step-by-step instructions for manually verifying the `dt-workflow` command. These tests are designed for **human testers** to validate functionality beyond what automated tests cover.

**Purpose:**
- Verify CLI help and version output is user-friendly
- Test all workflows (explore, research, decision) produce valid, usable output
- Validate workflow chaining (--from-explore, --from-research) works correctly
- Validate context injection works in different repository contexts
- Verify handoff file generation guidance is included
- Ensure error messages are helpful and actionable

**Prerequisites:**
- Access to `bin/dt-workflow` in the dev-toolkit repository
- A git repository to test in
- Terminal access

**Running the command:**

During development, run from the dev-toolkit worktree/repo:
```bash
# From dev-toolkit directory
./bin/dt-workflow [arguments]

# Or add to PATH temporarily
export PATH="$PWD/bin:$PATH"
dt-workflow [arguments]

# Or use absolute path
/path/to/dev-toolkit/bin/dt-workflow [arguments]
```

**Note:** If you have a global installation at `/usr/local/bin/dt-workflow`, it may be outdated. Use the local `./bin/dt-workflow` for testing development changes.

---

## 🧪 Phase 1: Foundation

### Scenario 1.1: Help Text Display

**Objective:** Verify help text is clear and complete

**Steps:**

1. Run the help command (from dev-toolkit directory):
   ```bash
   ./bin/dt-workflow --help
   ```

2. Verify the output includes:
   - Usage line with `<workflow> <topic> [OPTIONS]`
   - List of workflows (explore, research, decision)
   - All available options (--interactive, --validate, --output, --project)
   - Examples section

**Expected Result:** ✅ Help text is clear, complete, and matches production standards

---

### Scenario 1.2: Version Display

**Objective:** Verify version shows 0.2.0

**Steps:**

1. Run the version command:
   ```bash
   ./bin/dt-workflow --version
   ```

2. Also test short form:
   ```bash
   ./bin/dt-workflow -v
   ```

**Expected Result:** ✅ Both commands show `dt-workflow version 0.2.0`

---

### Scenario 1.3: Error Handling - Missing Workflow

**Objective:** Verify helpful error when workflow is missing

**Steps:**

1. Run without arguments:
   ```bash
   ./bin/dt-workflow
   ```

2. Verify the error includes:
   - Clear error message about missing workflow
   - 💡 Suggestion with correct usage
   - List of available workflows
   - Example command

**Expected Result:** ✅ Error message is helpful and actionable

---

### Scenario 1.4: Error Handling - Missing Topic

**Objective:** Verify helpful error when topic is missing

**Steps:**

1. Run with only workflow:
   ```bash
   ./bin/dt-workflow explore
   ```

2. Verify the error includes:
   - Clear error message about missing topic
   - 💡 Suggestion with correct usage
   - Example command

**Expected Result:** ✅ Error message is helpful and actionable

---

### Scenario 1.5: Error Handling - Unknown Workflow

**Objective:** Verify helpful error for invalid workflow

**Steps:**

1. Run with invalid workflow:
   ```bash
   ./bin/dt-workflow invalid-workflow my-topic --interactive
   ```

2. Verify the error includes:
   - Clear error message about unknown workflow
   - List of valid workflows
   - Example with valid workflow

**Expected Result:** ✅ Error message lists valid options

---

### Scenario 1.6: Explore Workflow - Basic Output

**Objective:** Verify explore workflow produces valid markdown

**Steps:**

1. From the dev-toolkit directory (which has `.cursor/rules/`):
   ```bash
   cd ~/Projects/dev-toolkit/worktrees/feat-dt-workflow  # or main dev-toolkit
   ```

2. Run explore workflow:
   ```bash
   ./bin/dt-workflow explore test-feature --interactive
   ```

3. Verify the output includes:
   - Header: `# dt-workflow Output: explore test-feature`
   - Mode indicator: `**Mode:** --interactive (Phase 1)`
   - Context section with START/MIDDLE/END markers
   - Cursor rules (if present in repo)
   - Git context (branch, recent commits)
   - Generated exploration structure (README.md, exploration.md, research-topics.md)
   - Next steps section
   - Token estimate at the end

**Expected Result:** ✅ Output is valid markdown with all sections present

---

### Scenario 1.7: Explore Workflow - Minimal Repository

**Objective:** Verify graceful handling of repository without .cursor/rules

**Steps:**

1. Create a minimal test repository:
   ```bash
   cd /tmp
   mkdir test-minimal-repo && cd test-minimal-repo
   git init
   git config user.email "test@example.com"
   git config user.name "Test User"
   echo "# Test" > README.md
   git add README.md && git commit -m "Initial"
   ```

2. Run explore workflow (use absolute path since we're in /tmp):
   ```bash
   ~/Projects/dev-toolkit/worktrees/feat-dt-workflow/bin/dt-workflow explore test-feature --interactive
   ```

3. Verify:
   - Command succeeds (exit code 0)
   - Output structure is valid
   - No errors about missing rules
   - Critical rules section is empty but formatted correctly

4. Clean up:
   ```bash
   cd /tmp && rm -rf test-minimal-repo
   ```

**Expected Result:** ✅ Works in minimal repository without errors

---

### Scenario 1.8: --output Flag - Save to File

**Objective:** Verify output can be saved to a file

**Steps:**

1. From the dev-toolkit directory:
   ```bash
   cd ~/Projects/dev-toolkit/worktrees/feat-dt-workflow
   ```

2. Run with --output flag:
   ```bash
   ./bin/dt-workflow explore test-feature --interactive --output /tmp/test-output.md
   ```

3. Verify:
   - Success message displayed
   - File exists at `/tmp/test-output.md`
   - File contains valid markdown output

4. View the file:
   ```bash
   head -20 /tmp/test-output.md
   ```

5. Clean up:
   ```bash
   rm /tmp/test-output.md
   ```

**Expected Result:** ✅ Output saved to file successfully

---

### Scenario 1.9: --output Flag - Invalid Path

**Objective:** Verify helpful error for invalid output path

**Steps:**

1. Run with non-existent directory:
   ```bash
   ./bin/dt-workflow explore test-feature --interactive --output /nonexistent/path/output.md
   ```

2. Verify:
   - Error message about invalid path
   - 💡 Suggestion to check the path

**Expected Result:** ✅ Clear error message with suggestion

---

### Scenario 1.10: --validate Flag - L1 Checks

**Objective:** Verify validation mode works

**Steps:**

1. Run validation for explore workflow:
   ```bash
   ./bin/dt-workflow explore test-feature --validate
   ```

2. Verify output shows:
   - "Validating inputs" message
   - L1 validation results
   - Success indicator

**Expected Result:** ✅ Validation completes without generating full output

---

### Scenario 1.11: Context Injection - Rules Included

**Objective:** Verify cursor rules are included in output

**Steps:**

1. From dev-toolkit directory (has .cursor/rules):
   ```bash
   cd ~/Projects/dev-toolkit/worktrees/feat-dt-workflow
   ```

2. Run explore workflow and check for rules:
   ```bash
   ./bin/dt-workflow explore test-feature --interactive | grep -A 5 "CRITICAL RULES"
   ```

3. Verify:
   - "CRITICAL RULES (START" section present
   - Rules from .cursor/rules/ are included
   - Rules are formatted as markdown code blocks

**Expected Result:** ✅ Cursor rules are injected into context

---

### Scenario 1.12: Token Estimate

**Objective:** Verify token estimate is displayed

**Steps:**

1. Run explore workflow:
   ```bash
   ./bin/dt-workflow explore test-feature --interactive | tail -5
   ```

2. Verify:
   - Token estimate line present: `**📊 Token Estimate:**`
   - Shows approximate token count
   - Notes it's within limits

**Expected Result:** ✅ Token estimate displayed at end of output

---

## 🧪 Phase 2: Workflow Expansion + Template Enhancement

**What Phase 2 Adds:**
- Research workflow (`dt-workflow research`)
- Decision workflow (`dt-workflow decision`)
- Workflow chaining flags (`--from-explore`, `--from-research`)
- Template-based structure generation (no heredocs)
- Handoff file generation guidance
- Context flow between workflows

**Key Testing Focus:**
- Verify research and decision workflows generate correct template structures
- Validate workflow chaining (context flows from explore→research→decision)
- Confirm handoff file guidance is present and useful
- Ensure templates render correctly (structural examples, no heredoc artifacts)
- Test both auto-detection and explicit paths for chaining

---

### Test Data Setup

Many Phase 2 scenarios require test data structures. Use the actual workflows to generate them.

**Note:** `--interactive` mode outputs to stdout only - it does NOT create directories. You must create directories first, then redirect output. A `--generate` mode that creates directories automatically is planned for a future phase.

**For Exploration Context Testing (use the real explore workflow):**
```bash
# Step 1: Create directory (required - workflow doesn't create it)
mkdir -p admin/explorations/test-topic

# Step 2: Generate exploration and redirect to file
./bin/dt-workflow explore test-topic --interactive > admin/explorations/test-topic/exploration.md
```

**For Research Context Testing (simulate completed research):**
```bash
# Step 1: Create directory (required)
mkdir -p admin/research/test-topic

# Step 2: Create a simple research-summary.md (handoff file)
echo "# Research Summary: test-topic" > admin/research/test-topic/research-summary.md
echo "" >> admin/research/test-topic/research-summary.md
echo "## Key Findings" >> admin/research/test-topic/research-summary.md
echo "- Finding 1: Test finding" >> admin/research/test-topic/research-summary.md
echo "" >> admin/research/test-topic/research-summary.md
echo "## Recommendations" >> admin/research/test-topic/research-summary.md
echo "- Recommendation 1" >> admin/research/test-topic/research-summary.md
```

**Cleanup After Testing:**
```bash
rm -rf admin/explorations/test-topic admin/research/test-topic
```

---

### Scenario 2.1: Research Workflow - Basic Usage

**Objective:** Verify research workflow generates valid structure

**Steps:**

1. Run research workflow for a test topic:
   ```bash
   ./bin/dt-workflow research test-topic --interactive
   ```

2. Verify output structure includes:
   - `## 📋 Context for AI` section
   - Research template structure with goals, findings, methodology
   - Structural examples (findings sections, insights lists)
   - Required markers (`<!-- REQUIRED: -->`)
   - No heredoc artifacts (should use templates, not embedded text)

**Expected Result:** ✅ Research structure generated with template-based content, includes required sections.

---

### Scenario 2.2: Research Workflow - Context from Exploration (Auto-detect)

**Objective:** Verify --from-explore auto-detects and loads exploration context

**Prerequisites:**
```bash
# Generate exploration using the actual explore workflow
mkdir -p admin/explorations/test-topic
./bin/dt-workflow explore test-topic --interactive > admin/explorations/test-topic/exploration.md
```

**Steps:**

1. Run research workflow with auto-detect (from dev-toolkit directory):
   ```bash
   ./bin/dt-workflow research test-topic --from-explore --interactive
   ```

2. Verify output includes:
   - Exploration context in the output
   - Exploration content from the generated exploration.md

3. Check that context appears in the output:
   ```bash
   ./bin/dt-workflow research test-topic --from-explore --interactive | grep -A 5 "Exploration"
   ```

4. Cleanup:
   ```bash
   rm -rf admin/explorations/test-topic
   ```

**Expected Result:** ✅ Exploration context automatically discovered and included in research output.

---

### Scenario 2.3: Research Workflow - Context from Exploration (Explicit Path)

**Objective:** Verify --from-explore accepts explicit paths

**Prerequisites:**
```bash
# Create custom exploration path using explore workflow
mkdir -p custom/path/test-topic
./bin/dt-workflow explore test-topic --interactive > custom/path/test-topic/exploration.md
```

**Steps:**

1. Run research workflow with explicit path (from dev-toolkit directory):
   ```bash
   ./bin/dt-workflow research test-topic --from-explore custom/path/test-topic --interactive
   ```

2. Verify output includes exploration context from custom path

3. Test error handling with invalid path:
   ```bash
   ./bin/dt-workflow research test-topic --from-explore invalid/path --interactive
   ```
   
4. Verify error message:
   - Clear error about path not found
   - Suggests checking the path or using auto-detect

5. Cleanup:
   ```bash
   rm -rf custom/
   ```

**Expected Result:** ✅ Explicit path works, invalid path shows helpful error with suggestions.

---

### Scenario 2.4: Research Workflow - Handoff File Guidance

**Objective:** Verify research workflow includes handoff file generation guidance

**Steps:**

1. Run research workflow:
   ```bash
   ./bin/dt-workflow research test-topic --interactive
   ```

2. Verify output includes:
   - `## 📋 Handoff: research-summary.md` section
   - Required sections listed (## Key Findings, ## Recommendations)
   - Link to Pattern 4 (Handoff File Contract)
   - Guidance on what to include in each section

**Expected Result:** ✅ Handoff file guidance included with clear instructions and pattern reference.

---

### Scenario 2.5: Decision Workflow - Basic Usage

**Objective:** Verify decision workflow generates valid ADR structure

**Steps:**

1. Run decision workflow for a test topic:
   ```bash
   ./bin/dt-workflow decision test-topic --interactive
   ```

2. Verify output structure includes:
   - `## 📋 Context for AI` section
   - ADR template with auto-numbered format (adr-NNN-topic.md)
   - Structural examples (alternatives table, consequences lists)
   - Required markers
   - MADR-compatible structure

**Expected Result:** ✅ Decision structure generated with ADR template, proper numbering, structural examples.

---

### Scenario 2.6: Decision Workflow - Context from Research (Auto-detect)

**Objective:** Verify --from-research auto-detects and loads research context

**Prerequisites:**
```bash
# Create research directory with a simple research-summary.md
mkdir -p admin/research/test-topic
echo "# Research Summary: test-topic" > admin/research/test-topic/research-summary.md
echo "" >> admin/research/test-topic/research-summary.md
echo "## Key Findings" >> admin/research/test-topic/research-summary.md
echo "- Finding 1: Test finding" >> admin/research/test-topic/research-summary.md
```

**Steps:**

1. Run decision workflow with auto-detect (from dev-toolkit directory):
   ```bash
   ./bin/dt-workflow decision test-topic --from-research --interactive
   ```

2. Verify output includes:
   - Research context in the output
   - Research summary content displayed

3. Check context inclusion:
   ```bash
   ./bin/dt-workflow decision test-topic --from-research --interactive | grep -A 5 "Research Summary"
   ```

4. Cleanup:
   ```bash
   rm -rf admin/research/test-topic
   ```

**Expected Result:** ✅ Research context automatically discovered and included.

---

### Scenario 2.7: Decision Workflow - Context from Research (Explicit Path)

**Objective:** Verify --from-research accepts explicit paths

**Prerequisites:**
```bash
# Create custom research path with simple file
mkdir -p custom/research/test-topic
echo "# Research Summary: test-topic (custom)" > custom/research/test-topic/research-summary.md
echo "## Key Findings" >> custom/research/test-topic/research-summary.md
echo "- Custom finding" >> custom/research/test-topic/research-summary.md
```

**Steps:**

1. Run decision workflow with explicit path (from dev-toolkit directory):
   ```bash
   ./bin/dt-workflow decision test-topic --from-research custom/research/test-topic --interactive
   ```

2. Verify output includes research context from custom path

3. Test error handling with invalid path:
   ```bash
   ./bin/dt-workflow decision test-topic --from-research invalid/path --interactive
   ```

4. Verify error message:
   - Clear error about path not found
   - Suggests checking the path or using auto-detect

5. Cleanup:
   ```bash
   rm -rf custom/
   ```

**Expected Result:** ✅ Explicit path works, invalid path shows helpful error with suggestions.

---

### Scenario 2.8: Decision Workflow - Handoff File Guidance

**Objective:** Verify decision workflow includes handoff file generation guidance

**Steps:**

1. Run decision workflow:
   ```bash
   ./bin/dt-workflow decision test-topic --interactive
   ```

2. Verify output includes:
   - `## 📋 Handoff: decisions-summary.md` section
   - Required sections listed (## Decisions table, ## Impact Summary)
   - Link to Pattern 4 (Handoff File Contract)
   - Guidance to run `/transition-plan --from-adr`

**Expected Result:** ✅ Handoff file guidance included with transition plan reference.

---

### Scenario 2.9: Full Workflow Chain Integration

**Objective:** Verify complete explore → research → decision chain works end-to-end

**Prerequisites:**
- Clean workspace (no existing chain-test structures)
- Running from dev-toolkit directory

**Steps:**

1. **Step 1: Create Exploration (using explore workflow)**
   ```bash
   mkdir -p admin/explorations/chain-test
   ./bin/dt-workflow explore chain-test --interactive > admin/explorations/chain-test/exploration.md
   head -5 admin/explorations/chain-test/exploration.md
   ```
   
   **Verify:** exploration.md created with output

2. **Step 2: Research Workflow (chained from exploration)**
   ```bash
   mkdir -p admin/research/chain-test
   ./bin/dt-workflow research chain-test --from-explore --interactive > /tmp/research-output.md
   grep -i "exploration" /tmp/research-output.md | head -3
   ```
   
   **Verify:** Exploration context appears in research output

3. **Step 3: Create Research Summary (simulating handoff file)**
   ```bash
   echo "# Research Summary: chain-test" > admin/research/chain-test/research-summary.md
   echo "## Key Findings" >> admin/research/chain-test/research-summary.md
   echo "- Workflow chaining works" >> admin/research/chain-test/research-summary.md
   ```
   
   **Verify:** research-summary.md created

4. **Step 4: Decision Workflow (chained from research)**
   ```bash
   mkdir -p admin/decisions/chain-test
   ./bin/dt-workflow decision chain-test --from-research --interactive > /tmp/decision-output.md
   grep -i "research summary" /tmp/decision-output.md | head -3
   ```
   
   **Verify:** Research context appears in decision output

5. **Cleanup:**
   ```bash
   rm -rf admin/explorations/chain-test admin/research/chain-test admin/decisions/chain-test
   rm -f /tmp/research-output.md /tmp/decision-output.md
   ```

**Expected Result:** ✅ Complete chain works, context flows through each stage.

---

### Scenario 2.10: Template Rendering Validation

**Objective:** Verify templates are rendered correctly (no heredocs in output sections)

**Prerequisites:**
- None (uses fresh test topics)

**Steps:**

1. **Check for heredoc artifacts in template output (from dev-toolkit directory):**
   
   Run each workflow and search for heredoc artifacts in the TEMPLATE sections:
   ```bash
   # Research workflow - check template section only
   ./bin/dt-workflow research test-template --interactive 2>&1 | sed -n '/^# Research:/,/^---$/p' | grep -i "heredoc\|cat <<\|EOF"
   
   # Decision workflow - check template section only
   ./bin/dt-workflow decision test-template --interactive 2>&1 | sed -n '/^# Decision:/,/^---$/p' | grep -i "heredoc\|cat <<\|EOF"
   ```
   
   **Expected:** No output (no matches found)
   
   **Note:** Heredocs in the CONTEXT section (from script standards examples) are expected and OK.

2. **Verify structural examples are present in templates:**
   
   **Exploration template:**
   ```bash
   ./bin/dt-workflow explore test-template --interactive | grep -A 3 "| Theme"
   ```
   Expected: Themes table with `| Theme | Key Finding |` structure
   
   **Research template:**
   ```bash
   ./bin/dt-workflow research test-template --interactive | grep -A 5 "## 🔍 Research Goals"
   ```
   Expected: Goals checklist with `- [x] Goal 1:` format
   
   **Decision template:**
   ```bash
   ./bin/dt-workflow decision test-template --interactive | grep -A 3 "| Alternative"
   ```
   Expected: Alternatives table with headers

3. **Verify required markers are present:**
   ```bash
   ./bin/dt-workflow research test-template --interactive | grep "REQUIRED:"
   ./bin/dt-workflow decision test-template --interactive | grep "REQUIRED:"
   ```
   Expected: Multiple required markers found (lines containing `<!-- REQUIRED: -->`)

**Expected Result:** 
- ✅ No heredoc artifacts in template output sections
- ✅ All structural examples present (tables, lists, checklists)
- ✅ Required markers and AI placeholders present
- ✅ Templates rendered correctly via render.sh (not embedded heredocs)

---

### Scenario 2.11: Error Handling - Missing Exploration

**Objective:** Verify helpful error when exploration directory not found

**Steps:**

1. Try to run research with --from-explore for non-existent topic:
   ```bash
   ./bin/dt-workflow research nonexistent-topic --from-explore --interactive
   ```

2. Verify error message:
   - Clearly states exploration not found
   - Shows paths checked (admin/explorations/nonexistent-topic)
   - Suggests creating exploration first
   - Suggests using explicit path if in different location

**Expected Result:** ✅ Clear, actionable error message with suggestions.

---

### Scenario 2.12: Error Handling - Missing Research

**Objective:** Verify helpful error when research directory not found

**Steps:**

1. Try to run decision with --from-research for non-existent topic:
   ```bash
   ./bin/dt-workflow decision nonexistent-topic --from-research --interactive
   ```

2. Verify error message:
   - Clearly states research not found
   - Shows paths checked (admin/research/nonexistent-topic)
   - Suggests creating research first
   - Suggests using explicit path if in different location

**Expected Result:** ✅ Clear, actionable error message with suggestions.

---

## 🧪 Phase 3: Cursor Integration

**What Phase 3 Adds:**
- Documentation of how Cursor commands (`/explore`, `/research`, `/decision`) integrate with `dt-workflow`
- End-to-end testing of the orchestrator pattern (ADR-004)
- Verification that context flows correctly between all stages

**Key Testing Focus:**
- Verify dt-workflow output is suitable as starting context for Cursor commands
- Validate complete workflow chain with dt-workflow at each stage
- Test error handling when prerequisites are missing

---

### Scenario 3.1: /explore with dt-workflow

**Objective:** Verify `dt-workflow explore` output is suitable for `/explore` command

**Steps:**

1. From dev-toolkit directory, run dt-workflow explore:
   ```bash
   ./bin/dt-workflow explore test-cursor-integration --interactive | head -50
   ```

2. Verify output contains:
   - [ ] Header: `# dt-workflow Output: explore test-cursor-integration`
   - [ ] Context section with Cursor rules (if present)
   - [ ] Project identity information
   - [ ] Exploration structure template
   - [ ] Handoff guidance (research-topics.md)

3. Verify output is valid starting context:
   ```bash
   ./bin/dt-workflow explore test-cursor-integration --interactive | grep -c "REQUIRED:"
   ```
   Expected: At least 1 required marker found

**Expected Result:** ✅ Output matches what `/explore` should use as starting context

---

### Scenario 3.2: /research with dt-workflow

**Objective:** Verify `dt-workflow research` chains correctly from exploration

**Prerequisites:**
```bash
# Create exploration for chaining
mkdir -p admin/explorations/test-cursor-integration
./bin/dt-workflow explore test-cursor-integration --interactive > admin/explorations/test-cursor-integration/exploration.md
```

**Steps:**

1. Run dt-workflow research with --from-explore:
   ```bash
   ./bin/dt-workflow research test-cursor-integration --from-explore --interactive | head -50
   ```

2. Verify output contains:
   - [ ] Research topics from exploration context
   - [ ] Research structure template
   - [ ] Handoff guidance (research-summary.md)
   - [ ] Reference to exploration source

3. Cleanup:
   ```bash
   rm -rf admin/explorations/test-cursor-integration
   ```

**Expected Result:** ✅ Output shows chained context from exploration

---

### Scenario 3.3: /decision with dt-workflow

**Objective:** Verify `dt-workflow decision` chains correctly from research

**Prerequisites:**
```bash
# Create research directory with summary
mkdir -p admin/research/test-cursor-integration
echo "# Research Summary: test-cursor-integration" > admin/research/test-cursor-integration/research-summary.md
echo "## Key Findings" >> admin/research/test-cursor-integration/research-summary.md
echo "- Finding 1: Test cursor integration" >> admin/research/test-cursor-integration/research-summary.md
```

**Steps:**

1. Run dt-workflow decision with --from-research:
   ```bash
   ./bin/dt-workflow decision test-cursor-integration --from-research --interactive | head -50
   ```

2. Verify output contains:
   - [ ] Research summary context included
   - [ ] ADR structure template
   - [ ] Handoff guidance (decisions-summary.md)
   - [ ] Reference to research source

3. Cleanup:
   ```bash
   rm -rf admin/research/test-cursor-integration
   ```

**Expected Result:** ✅ Output shows chained context from research

---

### Scenario 3.4: Full Workflow Chain with dt-workflow

**Objective:** Verify complete explore→research→decision chain using dt-workflow

**Prerequisites:**
- Clean workspace (no existing integration-test structures)
- Running from dev-toolkit directory

**Steps:**

1. **Step 1: Exploration Stage**
   ```bash
   mkdir -p admin/explorations/integration-test
   ./bin/dt-workflow explore integration-test --interactive > admin/explorations/integration-test/exploration.md
   echo "Integration test exploration created"
   ```
   
   **Verify:** exploration.md file created

2. **Step 2: Research Stage (chained)**
   ```bash
   ./bin/dt-workflow research integration-test --from-explore --interactive > /tmp/research-context.md
   grep -c "exploration" /tmp/research-context.md
   ```
   
   **Verify:** Exploration context appears in research output (count > 0)

3. **Step 3: Create Research Summary (simulating handoff)**
   ```bash
   mkdir -p admin/research/integration-test
   echo "# Research Summary: integration-test" > admin/research/integration-test/research-summary.md
   echo "## Key Findings" >> admin/research/integration-test/research-summary.md
   echo "- Full chain integration verified" >> admin/research/integration-test/research-summary.md
   ```
   
   **Verify:** research-summary.md created

4. **Step 4: Decision Stage (chained)**
   ```bash
   ./bin/dt-workflow decision integration-test --from-research --interactive > /tmp/decision-context.md
   grep -c "Research Summary" /tmp/decision-context.md
   ```
   
   **Verify:** Research context appears in decision output (count > 0)

5. **Cleanup:**
   ```bash
   rm -rf admin/explorations/integration-test admin/research/integration-test
   rm -f /tmp/research-context.md /tmp/decision-context.md
   ```

**Expected Result:** ✅ Context flows through all stages - each stage receives handoff from previous

---

### Scenario 3.5: Error Handling - Missing Prerequisites

**Objective:** Verify helpful errors when workflow prerequisites are missing

**Steps:**

1. **Test missing exploration:**
   ```bash
   ./bin/dt-workflow research nonexistent-topic --from-explore --interactive 2>&1 | head -10
   ```
   
   **Verify:**
   - [ ] Clear error about exploration not found
   - [ ] Suggests creating exploration first
   - [ ] Shows expected path

2. **Test missing research:**
   ```bash
   ./bin/dt-workflow decision nonexistent-topic --from-research --interactive 2>&1 | head -10
   ```
   
   **Verify:**
   - [ ] Clear error about research not found
   - [ ] Suggests creating research first
   - [ ] Shows expected path

**Expected Result:** ✅ Error messages are clear and actionable with suggestions

---

## 🧹 Cleanup

After completing manual testing:

```bash
# Remove any test files created
rm -f /tmp/test-output.md
rm -rf /tmp/test-minimal-repo

# If you created test branches, clean them up
# git branch -D test-branch (if applicable)
```

---

## ✅ Acceptance Criteria Checklist

### Phase 1: Foundation
- [ ] Scenario 1.1: Help text is clear and complete
- [ ] Scenario 1.2: Version shows 0.2.0
- [ ] Scenario 1.3: Missing workflow error is helpful
- [ ] Scenario 1.4: Missing topic error is helpful
- [ ] Scenario 1.5: Unknown workflow error lists valid options
- [ ] Scenario 1.6: Explore workflow produces valid output
- [ ] Scenario 1.7: Works in minimal repository
- [ ] Scenario 1.8: --output flag saves to file
- [ ] Scenario 1.9: Invalid path shows helpful error
- [ ] Scenario 1.10: --validate flag works
- [ ] Scenario 1.11: Cursor rules are included in context
- [ ] Scenario 1.12: Token estimate is displayed

**All Phase 1 scenarios passing:** [ ] Yes / [ ] No

### Phase 2: Workflow Expansion + Template Enhancement
- [ ] Scenario 2.1: Research workflow basic usage
- [ ] Scenario 2.2: Research with --from-explore (auto-detect)
- [ ] Scenario 2.3: Research with --from-explore (explicit path)
- [ ] Scenario 2.4: Research handoff file guidance
- [ ] Scenario 2.5: Decision workflow basic usage
- [ ] Scenario 2.6: Decision with --from-research (auto-detect)
- [ ] Scenario 2.7: Decision with --from-research (explicit path)
- [ ] Scenario 2.8: Decision handoff file guidance
- [ ] Scenario 2.9: Full workflow chain integration
- [ ] Scenario 2.10: Template rendering validation
- [ ] Scenario 2.11: Error handling - missing exploration
- [ ] Scenario 2.12: Error handling - missing research

**All Phase 2 scenarios passing:** [ ] Yes / [ ] No

### Phase 3: Cursor Integration
- [ ] Scenario 3.1: /explore with dt-workflow context
- [ ] Scenario 3.2: /research chains from exploration
- [ ] Scenario 3.3: /decision chains from research
- [ ] Scenario 3.4: Full workflow chain integration
- [ ] Scenario 3.5: Error handling - missing prerequisites

**All Phase 3 scenarios passing:** [ ] Yes / [ ] No

---

## 📝 Notes for Testers

1. **Different repositories:** Test in repos with and without `.cursor/rules/` to verify graceful handling
2. **Output length:** All workflows generate substantial output (~10-20K tokens). This is expected for AI context.
3. **--interactive flag:** Required in Phases 1-2. Future phases will add `--generate` for direct file creation.
4. **Workflow chaining:** Test both auto-detect (simpler) and explicit paths (more flexible) for --from-* flags
5. **Context inclusion:** Verify that previous workflow output is included when using --from-* flags
6. **Handoff files:** Phase 2 provides guidance on creating handoff files, but doesn't auto-generate them yet
7. **Template rendering:** No heredoc artifacts should appear in output (switched to render.sh in Phase 2)
8. **Report Issues:** If any scenario fails, document exact steps, expected vs actual results, and error messages.

---

## 🔗 Related Documents

- [Feature Plan](feature-plan.md)
- [Phase 1 Document](phase-1.md)
- [Phase 2 Document](phase-2.md)
- [Phase 3 Document](phase-3.md)
- [Status and Next Steps](status-and-next-steps.md)
- [Workflow Patterns](../../docs/patterns/workflow-patterns.md) - Pattern 4: Handoff File Contract
- [Template Variables](../../lib/doc-gen/TEMPLATE-VARIABLES.md)

---

**Last Updated:** 2026-01-26
