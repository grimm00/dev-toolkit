# Manual Testing Guide - dt-workflow

**Feature:** dt-workflow - Unified Workflow Orchestration  
**Phases Covered:** 1, 2  
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
- [Status and Next Steps](status-and-next-steps.md)
- [Workflow Patterns](../../docs/patterns/workflow-patterns.md) - Pattern 4: Handoff File Contract
- [Template Variables](../../lib/doc-gen/TEMPLATE-VARIABLES.md)

---

**Last Updated:** 2026-01-26
