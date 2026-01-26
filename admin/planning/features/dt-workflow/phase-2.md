# dt-workflow - Phase 2: Workflow Expansion + Template Enhancement

**Phase:** 2 - Workflow Expansion + Template Enhancement  
**Duration:** 14-18 hours  
**Status:** 🟠 In Progress  
**Last Updated:** 2026-01-26
**Prerequisites:** Phase 1 complete (PR #32 merged 2026-01-26)

---

## 📋 Overview

Implement the research and decision workflows with enhanced templates. This phase combines workflow expansion with template enhancement (ADR-006) to ensure all workflows use consistent, AI-optimized templates with structural examples.

**Success Definition:** All three workflows (explore, research, decision) working end-to-end with enhanced templates and proper chaining via handoff files.

---

## 🎯 Goals

1. **Template Enhancement** - Enhance dev-infra templates with structural examples (ADR-006)
2. **Template Integration** - Replace spike heredocs with render.sh template rendering
3. **Research Workflow** - Structure generation and context gathering for research
4. **Decision Workflow** - Structure generation and context gathering for decisions
5. **Handoff Files** - Standardized output files per FR-10, Pattern 4
6. **--from-* Flags** - Auto-detection per FR-11

---

## 📝 Tasks

### Task Group 1: Template Enhancement (ADR-006)

These tasks enhance dev-infra templates. Note: Changes are in the **dev-infra** project, not dev-toolkit.

---

#### Task 1: Enhance Exploration Templates

**Purpose:** Add structural examples to exploration templates per ADR-006 and FR-24

**TDD Flow:**

1. **RED - Write test for template output structure:**
   - [x] Create test in dev-toolkit that validates exploration template output
   - [x] Test expects structural examples (tables, lists) not just placeholders
   - [x] Test validates `<!-- REQUIRED: -->` markers exist
   - [x] Verify test fails (current templates lack structural examples)

   **Test approach (in dev-infra):**
   ```bash
   @test "exploration template includes themes table structure" {
       dt_set_exploration_vars "test-topic" "Test exploration"
       dt_render_template "$TEMPLATE_DIR/exploration/exploration.md.tmpl" "$output" "exploration"
       
       # Structural example should exist
       grep -q "| Theme | Key Finding |" "$output"
       grep -q "|-------|-------------|" "$output"
       grep -q "<!-- AI: Fill theme rows" "$output"
   }
   ```

2. **GREEN - Enhance exploration templates:**
   - [x] Update `exploration/exploration.md.tmpl` with structural examples (dev-infra commit 82d1a6f)
   - [x] Add themes table structure (header + separator + AI placeholder)
   - [x] Add recommendations numbered list structure
   - [x] Add `<!-- REQUIRED: At least 2 themes -->` markers per FR-26
   - [x] Verify test passes (all 4 tests passing)

   **Template enhancement example:**
   ```markdown
   ## 📊 Exploration Summary
   
   ### Themes Analyzed
   <!-- REQUIRED: At least 2 themes -->
   
   | Theme | Key Finding |
   |-------|-------------|
   <!-- AI: Fill theme rows based on analysis. Each row: | Theme Name | One-sentence finding | -->
   
   ### Initial Recommendations
   
   1. <!-- AI: First recommendation based on themes -->
   2. <!-- AI: Second recommendation -->
   ```

3. **REFACTOR - Clean up and document:**
   - [ ] Ensure consistent formatting across exploration templates (dev-infra task)
   - [ ] Add template variable usage comments at top (dev-infra task)
   - [x] Verify alignment with spike heredoc output (NFR-7) - ✅ Verified: Themes Analyzed table and Initial Recommendations list match spike structure

**Checklist:**
- [x] Test written and failing (RED phase complete)
- [x] Template enhanced with structural examples (GREEN phase complete - dev-infra)
- [x] `<!-- REQUIRED: -->` markers added
- [x] Test passing (all 4 tests passing)
- [x] Template output aligns with spike heredocs (verified)

---

#### Task 2: Enhance Research Templates

**Purpose:** Add structural examples to research templates per ADR-006

**TDD Flow:**

1. **RED - Write test for research template structure:**
   - [x] Test validates research template has structural examples
   - [x] Test expects findings table, recommendations list
   - [x] Test validates two-phase placeholders (`<!-- AI: -->`, `<!-- EXPAND: -->`)
   - [x] Verify test fails

2. **GREEN - Enhance research templates:**
   - [x] Update `research/research-topic.md.tmpl` with structural examples (dev-infra PR #64)
   - [x] Add findings section structure (Title, Source, Relevance format)
   - [x] Add methodology section structure (already existed)
   - [x] Add key insights numbered list
   - [x] Add `<!-- REQUIRED: -->` markers
   - [x] Verify test passes (all 6 tests passing)

   **Template enhancement:**
   ```markdown
   ## 🔍 Research Goals
   <!-- REQUIRED: At least 3 goals -->
   
   - [x] Goal 1: <!-- AI: First goal statement -->
   - [ ] Goal 2: <!-- AI: Second goal statement -->
   - [ ] Goal 3: <!-- AI: Third goal statement -->
   
   ## 📊 Findings
   
   ### Finding 1: [Title]
   <!-- EXPAND: Add detailed explanation with sources -->
   
   **Source:** [Link or reference]
   **Relevance:** <!-- AI: How this relates to the research question -->
   ```

3. **REFACTOR:**
   - [x] Ensure consistent section ordering across research templates (verified: logical flow maintained)
   - [x] Add clear guidance comments for AI (AI/EXPAND comments present and clear)
   - [x] Verify template variable usage documented (completed in dev-infra PR #64)

**Checklist:**
- [x] Test written and failing (RED phase complete)
- [x] Research templates enhanced (GREEN phase complete - dev-infra PR #64)
- [x] Two-phase placeholders maintained
- [x] Test passing (all 6 tests passing)

---

#### Task 3: Enhance Decision Templates

**Purpose:** Add structural examples to decision templates per ADR-006

**TDD Flow:**

1. **RED - Write test for decision template structure:**
   - [x] Test validates ADR template has structural examples
   - [x] Test expects alternatives table, consequences lists
   - [x] Verify test fails (tests written, but templates already enhanced so tests pass)

2. **GREEN - Enhance decision templates:**
   - [x] Update `decision/adr.md.tmpl` with structural examples (dev-infra PR #64)
   - [x] Add alternatives considered table
   - [x] Add consequences (positive/negative) list structures
   - [x] Add decision rationale section structure
   - [x] Add `<!-- REQUIRED: -->` markers
   - [x] Verify test passes (all 5 tests passing)

   **Template enhancement:**
   ```markdown
   ## Alternatives Considered
   <!-- REQUIRED: At least 2 alternatives -->
   
   | Alternative | Pros | Cons | Why Not Chosen |
   |-------------|------|------|----------------|
   <!-- AI: Fill alternatives table. One row per option. -->
   
   ## Consequences
   
   ### Positive
   <!-- REQUIRED: At least 2 positive consequences -->
   
   - <!-- AI: First positive consequence -->
   - <!-- AI: Second positive consequence -->
   
   ### Negative
   
   - <!-- AI: First negative consequence (trade-off accepted) -->
   ```

3. **REFACTOR:**
   - [x] Align with MADR format where applicable (verified: Context, Decision, Consequences, Alternatives, Rationale sections present)
   - [x] Ensure consistent ADR numbering support (${ADR_NUMBER} variable used, supports sequential numbering)
   - [x] Document template variables (completed in dev-infra PR #64)

**Checklist:**
- [x] Test written and passing (RED phase complete - templates already enhanced)
- [x] Decision templates enhanced (GREEN phase complete - dev-infra PR #64)
- [x] MADR alignment maintained (REFACTOR phase complete)
- [x] Test passing (all 5 tests passing)

---

#### Task 4: Document Template Variable Contract

**Purpose:** Create explicit documentation of all template variables per FR-27

**TDD Flow:**

1. **RED - Write test for variable documentation:**
   - [x] Test checks that `lib/doc-gen/TEMPLATE-VARIABLES.md` exists
   - [x] Test validates all variables in render.sh are documented
   - [x] Verify test fails (documentation doesn't exist - tests written, now passing)

2. **GREEN - Create variable documentation:**
   - [x] Create `lib/doc-gen/TEMPLATE-VARIABLES.md`
   - [x] Document all variables per category (exploration, research, decision, planning)
   - [x] Include description, default value, and example for each
   - [x] Document setter function usage
   - [x] Verify test passes (all 9 tests passing)

   **Documentation structure:**
   ```markdown
   # Template Variable Contract
   
   ## Universal Variables
   
   | Variable | Description | Default | Setter |
   |----------|-------------|---------|--------|
   | `${DATE}` | Current date (YYYY-MM-DD) | Today | `dt_set_common_vars` |
   | `${STATUS}` | Document status | `🔴 Not Started` | `dt_set_common_vars` |
   | `${PURPOSE}` | Brief description | Auto-generated | Per-category setter |
   
   ## Exploration Variables
   
   | Variable | Description | Default | Setter |
   |----------|-------------|---------|--------|
   | `${TOPIC_NAME}` | Kebab-case topic | Required | `dt_set_exploration_vars` |
   | `${TOPIC_TITLE}` | Title-case topic | Auto from name | `dt_set_exploration_vars` |
   ```

3. **REFACTOR:**
   - [x] Add usage examples (included in documentation)
   - [x] Cross-reference from render.sh comments (added comment referencing TEMPLATE-VARIABLES.md)
   - [x] Add validation guidance (validation section included)

**Checklist:**
- [x] Documentation file created
- [x] All variables documented
- [x] Setter functions referenced
- [x] Test passing (all 9 tests passing)

---

### Task Group 2: Template Integration

These tasks integrate enhanced templates into dt-workflow.

---

#### Task 5: Replace Explore Heredocs with render.sh

**Purpose:** Update dt-workflow explore workflow to use render.sh instead of heredocs per NFR-7

**TDD Flow:**

1. **RED - Write test for template-based output:**
   - [x] Test that dt-workflow explore uses render.sh
   - [x] Test validates output structure matches expected template output
   - [x] Test verifies template variables are correctly substituted
   - [x] Verify test fails (tests written, now passing after refactor)

   **Test:**
   ```bash
   @test "dt-workflow explore uses render.sh for structure generation" {
       run "$DT_WORKFLOW" explore test-topic --interactive --output "$TEST_OUTPUT"
       [ "$status" -eq 0 ]
       
       # Check for template-rendered content (not heredoc markers)
       grep -q "# TASK" "$TEST_OUTPUT"
       grep -q "## Exploration Structure" "$TEST_OUTPUT"
       
       # Verify topic variable substitution
       grep -q "test-topic" "$TEST_OUTPUT"
   }
   ```

2. **GREEN - Refactor explore to use render.sh:**
   - [x] Source `lib/doc-gen/render.sh` in dt-workflow
   - [x] Replace `generate_exploration_structure()` heredoc with template rendering
   - [x] Call `dt_set_exploration_vars()` before rendering
   - [x] Call `dt_render_template()` for structure generation
   - [x] Verify test passes (all 3 tests passing)

   **Implementation:**
   ```bash
   generate_explore_structure() {
       local topic="$1"
       local output_file="$2"
       
       # Set template variables
       dt_set_exploration_vars "$topic" "Exploration of $topic"
       
       # Render template
       local template_path="$DEV_INFRA_TEMPLATES/exploration/exploration.md.tmpl"
       dt_render_template "$template_path" "$output_file" "exploration"
   }
   ```

3. **REFACTOR:**
   - [x] Remove unused heredoc code (moved to fallback function, only used when templates unavailable)
   - [x] Ensure graceful fallback if templates unavailable (fallback function with clear warnings)
   - [x] Add debug logging for template path resolution (debug logs added for template paths and rendering)

**Checklist:**
- [x] Test written and passing (RED phase complete)
- [x] Heredocs replaced with render.sh calls (GREEN phase complete)
- [x] Template variables correctly set
- [x] Test passing (all 3 tests passing)
- [x] Old heredoc code removed (moved to fallback function, only used when templates unavailable)

---

#### Task 6: Validate Template-Spike Alignment

**Purpose:** Ensure template output is structurally equivalent to spike heredocs per NFR-7

**TDD Flow:**

1. **RED - Write comparison test:**
   - [x] Generate output using spike heredocs (baseline - referenced from research docs)
   - [x] Generate output using templates (current implementation)
   - [x] Test validates structural equivalence (4 tests written)
   - [x] Verify test fails if structure differs (tests passing confirms alignment)

2. **GREEN - Align template output:**
   - [x] Compare template output to spike heredoc output (templates already enhanced in Tasks 1-3)
   - [x] Adjust templates to match expected structure (completed in Tasks 1-3)
   - [x] Ensure all sections from spike are present (Themes Analyzed, Initial Recommendations verified)
   - [x] Verify test passes (all 4 spike alignment tests passing)

3. **REFACTOR:**
   - [x] Document any intentional differences (templates match spike structure - no differences)
   - [x] Remove spike heredocs after validation (heredoc function removed, templates required)
   - [x] Update any dependent code (error handling updated to require templates)

**Checklist:**
- [x] Comparison test written (4 tests validating spike structure alignment)
- [x] Template output matches spike structure (all tests passing)
- [x] Spike heredocs removed (heredoc function removed, templates now required)
- [x] Test passing (all 7 template/spike tests passing)

---

### Task Group 3: Research Workflow Implementation

---

#### Task 7: Research Structure Generation

**Purpose:** Implement research workflow structure generation via templates

**TDD Flow:**

1. **RED - Write test for research structure:**
   - [x] Test `dt-workflow research topic --interactive` produces structure
   - [x] Test validates research document sections exist
   - [x] Test verifies template rendering is used
   - [x] Verify test fails (tests written, now passing after implementation)

   **Test:**
   ```bash
   @test "dt-workflow research generates structure via template" {
       run "$DT_WORKFLOW" research test-topic --interactive --output "$TEST_OUTPUT"
       [ "$status" -eq 0 ]
       
       # Research structure sections
       grep -q "## 🎯 Research Question" "$TEST_OUTPUT"
       grep -q "## 🔍 Research Goals" "$TEST_OUTPUT"
       grep -q "## 📊 Findings" "$TEST_OUTPUT"
       grep -q "## 💡 Recommendations" "$TEST_OUTPUT"
   }
   ```

2. **GREEN - Implement research structure generation:**
   - [x] Add `research` case to workflow dispatcher
   - [x] Create `generate_research_structure()` function
   - [x] Use `dt_set_research_vars()` for template variables
   - [x] Use `dt_render_template()` for research template
   - [x] Verify test passes (all 3 tests passing)

   **Implementation:**
   ```bash
   generate_research_structure() {
       local topic="$1"
       local question="${2:-}"
       local output_file="$3"
       
       # Set template variables
       dt_set_research_vars "$topic" "$question" "Research for $topic"
       
       # Render template
       local template_path="$DEV_INFRA_TEMPLATES/research/research.md.tmpl"
       dt_render_template "$template_path" "$output_file" "research"
   }
   ```

3. **REFACTOR:**
   - [x] Add validation for research-specific inputs (L1 validation checks exploration directory exists)
   - [x] Ensure consistent error messages (matches exploration error handling pattern)
   - [x] Add debug logging (debug logs for template paths and rendering)

**Checklist:**
- [x] Test written and passing (RED phase complete)
- [x] Research structure generation implemented (GREEN phase complete)
- [x] Template rendering used
- [x] Test passing (all 3 tests passing)

---

#### Task 8: Research Context Gathering

**Purpose:** Gather exploration context and existing research for research workflow

**TDD Flow:**

1. **RED - Write test for research context:**
   - [x] Test validates exploration context is gathered when available
   - [x] Test validates existing research documents are discovered
   - [x] Test verifies context appears in output
   - [x] Verify test fails (tests written, now passing after implementation)

   **Test:**
   ```bash
   @test "dt-workflow research includes exploration context" {
       # Setup: create exploration
       mkdir -p "$TEST_PROJECT/admin/explorations/test-topic"
       echo "# Exploration" > "$TEST_PROJECT/admin/explorations/test-topic/exploration.md"
       
       run "$DT_WORKFLOW" research test-topic --interactive --output "$TEST_OUTPUT"
       [ "$status" -eq 0 ]
       
       # Context section should include exploration
       grep -q "## Workflow-Specific Context" "$TEST_OUTPUT"
       grep -q "exploration.md" "$TEST_OUTPUT"
   }
   ```

2. **GREEN - Implement research context gathering:**
   - [x] Create `gather_research_context()` function
   - [x] Discover exploration directory for topic
   - [x] Include exploration.md content if exists (limited to first 100 lines)
   - [x] Include research-topics.md if exists (handoff from explore)
   - [x] Discover existing research documents (with summary for 5+ files)
   - [x] Verify test passes (all 3 tests passing)

   **Implementation:**
   ```bash
   gather_research_context() {
       local topic="$1"
       local project_dir="${2:-.}"
       
       echo "## Workflow-Specific Context (Research)"
       echo ""
       
       # Check for exploration (upstream)
       local exp_dir="$project_dir/admin/explorations/$topic"
       if [ -d "$exp_dir" ]; then
           echo "### Related Exploration"
           echo ""
           if [ -f "$exp_dir/exploration.md" ]; then
               echo '```markdown'
               head -100 "$exp_dir/exploration.md"
               echo '```'
           fi
           
           # Include handoff file
           if [ -f "$exp_dir/research-topics.md" ]; then
               echo "### Research Topics (from exploration)"
               echo ""
               cat "$exp_dir/research-topics.md"
           fi
       fi
       
       # Check for existing research
       local research_dir="$project_dir/admin/research/$topic"
       if [ -d "$research_dir" ]; then
           echo "### Existing Research"
           echo ""
           ls -1 "$research_dir"/*.md 2>/dev/null | while read -r f; do
               echo "- \`$(basename "$f")\`"
           done
       fi
   }
   ```

3. **REFACTOR:**
   - [x] Handle missing directories gracefully (debug messages, no errors)
   - [x] Limit context size to avoid token bloat (head -100 for exploration.md)
   - [x] Add summary counts for large document sets (shows first 5, then "... and N more")

**Checklist:**
- [x] Test written and passing (RED phase complete)
- [x] Context gathering implemented (GREEN phase complete)
- [x] Exploration context included when available (exploration.md + research-topics.md)
- [x] Test passing (all 3 tests passing)

---

#### Task 9: Research Handoff File Generation

**Purpose:** Generate standardized handoff file for research→decision transition per Pattern 4

**TDD Flow:**

1. **RED - Write test for handoff file:**
   - [ ] Test validates `research-summary.md` is generated
   - [ ] Test validates required sections exist (## Key Findings, ## Recommendations)
   - [ ] Test validates Next Steps section points to decision workflow
   - [ ] Verify test fails

   **Test:**
   ```bash
   @test "dt-workflow research generates handoff file" {
       run "$DT_WORKFLOW" research test-topic --interactive --output "$TEST_OUTPUT"
       [ "$status" -eq 0 ]
       
       # Handoff guidance should be in output
       grep -q "research-summary.md" "$TEST_OUTPUT"
       grep -q "## 🚀 Next Steps" "$TEST_OUTPUT"
       grep -q "/decision" "$TEST_OUTPUT"
   }
   ```

2. **GREEN - Implement handoff file guidance:**
   - [ ] Add handoff section to research structure template
   - [ ] Include required sections per Pattern 4
   - [ ] Add Next Steps pointing to `/decision --from-research`
   - [ ] Verify test passes

   **Handoff structure:**
   ```markdown
   ## 📋 Handoff: research-summary.md
   
   <!-- AI: After completing research, create research-summary.md with: -->
   
   ### Required Sections
   - `## 🔍 Key Findings` - Numbered findings with sources
   - `## 💡 Recommendations` - Actionable recommendations
   - `## 📊 Requirements Discovered` - Any new requirements (FR-*, NFR-*)
   
   ## 🚀 Next Steps
   
   1. Complete research and fill sections above
   2. Create `research-summary.md` with key findings
   3. Run `/decision topic --from-research` to make decisions
   ```

3. **REFACTOR:**
   - [ ] Ensure consistent handoff format across workflows
   - [ ] Add validation for handoff sections
   - [ ] Cross-reference Pattern 4 documentation

**Checklist:**
- [ ] Test written and failing
- [ ] Handoff guidance implemented
- [ ] Required sections documented
- [ ] Next Steps points to decision
- [ ] Test passing

---

### Task Group 4: Decision Workflow Implementation

---

#### Task 10: Decision Structure Generation

**Purpose:** Implement decision workflow structure generation via templates

**TDD Flow:**

1. **RED - Write test for decision structure:**
   - [ ] Test `dt-workflow decision topic --interactive` produces structure
   - [ ] Test validates ADR document sections exist
   - [ ] Test verifies template rendering is used
   - [ ] Verify test fails

   **Test:**
   ```bash
   @test "dt-workflow decision generates ADR structure via template" {
       run "$DT_WORKFLOW" decision test-topic --interactive --output "$TEST_OUTPUT"
       [ "$status" -eq 0 ]
       
       # ADR structure sections
       grep -q "## Context" "$TEST_OUTPUT"
       grep -q "## Decision" "$TEST_OUTPUT"
       grep -q "## Consequences" "$TEST_OUTPUT"
       grep -q "## Alternatives Considered" "$TEST_OUTPUT"
   }
   ```

2. **GREEN - Implement decision structure generation:**
   - [ ] Add `decision` case to workflow dispatcher
   - [ ] Create `generate_decision_structure()` function
   - [ ] Use `dt_set_decision_vars()` for template variables
   - [ ] Use `dt_render_template()` for ADR template
   - [ ] Verify test passes

3. **REFACTOR:**
   - [ ] Support ADR numbering (auto-increment or manual)
   - [ ] Add validation for decision-specific inputs
   - [ ] Ensure MADR format compliance

**Checklist:**
- [ ] Test written and failing
- [ ] Decision structure generation implemented
- [ ] ADR format followed
- [ ] Test passing

---

#### Task 11: Decision Context Gathering

**Purpose:** Gather research context and requirements for decision workflow

**TDD Flow:**

1. **RED - Write test for decision context:**
   - [ ] Test validates research context is gathered when available
   - [ ] Test validates requirements.md is included if exists
   - [ ] Test verifies context appears in output
   - [ ] Verify test fails

   **Test:**
   ```bash
   @test "dt-workflow decision includes research context" {
       # Setup: create research
       mkdir -p "$TEST_PROJECT/admin/research/test-topic"
       echo "# Research Summary" > "$TEST_PROJECT/admin/research/test-topic/research-summary.md"
       
       run "$DT_WORKFLOW" decision test-topic --interactive --output "$TEST_OUTPUT"
       [ "$status" -eq 0 ]
       
       grep -q "## Workflow-Specific Context" "$TEST_OUTPUT"
       grep -q "research-summary.md" "$TEST_OUTPUT"
   }
   ```

2. **GREEN - Implement decision context gathering:**
   - [ ] Create `gather_decision_context()` function
   - [ ] Discover research directory for topic
   - [ ] Include research-summary.md content (handoff from research)
   - [ ] Include requirements.md if exists
   - [ ] Discover existing ADRs
   - [ ] Verify test passes

   **Implementation:**
   ```bash
   gather_decision_context() {
       local topic="$1"
       local project_dir="${2:-.}"
       
       echo "## Workflow-Specific Context (Decision)"
       echo ""
       
       # Check for research (upstream)
       local research_dir="$project_dir/admin/research/$topic"
       if [ -d "$research_dir" ]; then
           echo "### Research Summary"
           echo ""
           if [ -f "$research_dir/research-summary.md" ]; then
               echo '```markdown'
               cat "$research_dir/research-summary.md"
               echo '```'
           fi
           
           # Include requirements if exists
           if [ -f "$research_dir/requirements.md" ]; then
               echo "### Requirements"
               echo ""
               cat "$research_dir/requirements.md"
           fi
       fi
       
       # Check for existing decisions
       local decisions_dir="$project_dir/admin/decisions/$topic"
       if [ -d "$decisions_dir" ]; then
           echo "### Existing ADRs"
           echo ""
           ls -1 "$decisions_dir"/adr-*.md 2>/dev/null | while read -r f; do
               echo "- \`$(basename "$f")\`"
           done
       fi
   }
   ```

3. **REFACTOR:**
   - [ ] Handle missing directories gracefully
   - [ ] Extract key findings from research-summary.md
   - [ ] List requirements by category (FR, NFR)

**Checklist:**
- [ ] Test written and failing
- [ ] Context gathering implemented
- [ ] Research context included when available
- [ ] Requirements included when available
- [ ] Test passing

---

#### Task 12: Decision Handoff File Generation

**Purpose:** Generate standardized handoff file for decision→transition-plan per Pattern 4

**TDD Flow:**

1. **RED - Write test for handoff file:**
   - [ ] Test validates `decisions-summary.md` guidance is generated
   - [ ] Test validates required sections exist (## Decisions table)
   - [ ] Test validates Next Steps section points to transition-plan
   - [ ] Verify test fails

2. **GREEN - Implement handoff file guidance:**
   - [ ] Add handoff section to decision structure template
   - [ ] Include required sections per Pattern 4
   - [ ] Add Next Steps pointing to `/transition-plan --from-decision`
   - [ ] Verify test passes

   **Handoff structure:**
   ```markdown
   ## 📋 Handoff: decisions-summary.md
   
   <!-- AI: After making decisions, update decisions-summary.md with: -->
   
   ### Required Sections
   - `## Decisions` table with ADR numbers and status
   - `## Impact Summary` - Key consequences
   
   ## 🚀 Next Steps
   
   1. Complete ADR with all sections
   2. Update `decisions-summary.md` with new ADR
   3. Run `/transition-plan --from-adr topic` to create implementation plan
   ```

3. **REFACTOR:**
   - [ ] Ensure consistent handoff format
   - [ ] Add ADR numbering guidance
   - [ ] Cross-reference Pattern 4

**Checklist:**
- [ ] Test written and failing
- [ ] Handoff guidance implemented
- [ ] Required sections documented
- [ ] Next Steps points to transition-plan
- [ ] Test passing

---

### Task Group 5: Workflow Chaining

---

#### Task 13: --from-explore Flag Implementation

**Purpose:** Implement --from-explore flag with auto-detection per FR-11

**TDD Flow:**

1. **RED - Write test for --from-explore:**
   - [ ] Test `dt-workflow research topic --from-explore topic` chains correctly
   - [ ] Test validates exploration context is automatically loaded
   - [ ] Test auto-detection: `--from-explore` without path finds exploration
   - [ ] Verify test fails

   **Test:**
   ```bash
   @test "--from-explore auto-detects exploration directory" {
       # Setup: create exploration
       mkdir -p "$TEST_PROJECT/admin/explorations/test-topic"
       echo "# Exploration" > "$TEST_PROJECT/admin/explorations/test-topic/exploration.md"
       
       run "$DT_WORKFLOW" research test-topic --from-explore --interactive --output "$TEST_OUTPUT"
       [ "$status" -eq 0 ]
       
       # Should have loaded exploration context
       grep -q "Related Exploration" "$TEST_OUTPUT"
   }
   
   @test "--from-explore with explicit path uses that path" {
       mkdir -p "$TEST_PROJECT/custom/explorations/my-topic"
       echo "# Custom" > "$TEST_PROJECT/custom/explorations/my-topic/exploration.md"
       
       run "$DT_WORKFLOW" research test-topic --from-explore "$TEST_PROJECT/custom/explorations/my-topic" --interactive --output "$TEST_OUTPUT"
       [ "$status" -eq 0 ]
       
       grep -q "Custom" "$TEST_OUTPUT"
   }
   ```

2. **GREEN - Implement --from-explore:**
   - [ ] Add `--from-explore` flag parsing
   - [ ] Implement auto-detection: check `admin/explorations/$topic/`
   - [ ] Allow explicit path override
   - [ ] Validate exploration exists (L1 validation)
   - [ ] Load exploration context when flag present
   - [ ] Verify test passes

   **Implementation:**
   ```bash
   parse_from_explore() {
       local topic="$1"
       local explicit_path="${2:-}"
       local project_dir="${3:-.}"
       
       if [ -n "$explicit_path" ]; then
           # Explicit path provided
           if [ ! -d "$explicit_path" ]; then
               dt_print_status "ERROR" "Exploration not found: $explicit_path"
               exit 1
           fi
           echo "$explicit_path"
       else
           # Auto-detect
           local auto_path="$project_dir/admin/explorations/$topic"
           if [ ! -d "$auto_path" ]; then
               dt_print_status "ERROR" "Exploration not found: $auto_path"
               echo ""
               echo "💡 Suggestion: Run '/explore $topic' first"
               exit 1
           fi
           echo "$auto_path"
       fi
   }
   ```

3. **REFACTOR:**
   - [ ] Add helpful error messages for missing explorations
   - [ ] Support alternative exploration locations
   - [ ] Add debug logging for auto-detection

**Checklist:**
- [ ] Test written and failing
- [ ] --from-explore flag implemented
- [ ] Auto-detection working
- [ ] Explicit path override working
- [ ] Test passing

---

#### Task 14: --from-research Flag Implementation

**Purpose:** Implement --from-research flag with auto-detection per FR-11

**TDD Flow:**

1. **RED - Write test for --from-research:**
   - [ ] Test `dt-workflow decision topic --from-research topic` chains correctly
   - [ ] Test validates research context is automatically loaded
   - [ ] Test auto-detection: `--from-research` without path finds research
   - [ ] Verify test fails

   **Test:**
   ```bash
   @test "--from-research auto-detects research directory" {
       # Setup: create research
       mkdir -p "$TEST_PROJECT/admin/research/test-topic"
       echo "# Research Summary" > "$TEST_PROJECT/admin/research/test-topic/research-summary.md"
       
       run "$DT_WORKFLOW" decision test-topic --from-research --interactive --output "$TEST_OUTPUT"
       [ "$status" -eq 0 ]
       
       # Should have loaded research context
       grep -q "Research Summary" "$TEST_OUTPUT"
   }
   ```

2. **GREEN - Implement --from-research:**
   - [ ] Add `--from-research` flag parsing
   - [ ] Implement auto-detection: check `admin/research/$topic/`
   - [ ] Allow explicit path override
   - [ ] Validate research exists (L1 validation)
   - [ ] Load research context when flag present
   - [ ] Verify test passes

3. **REFACTOR:**
   - [ ] Add helpful error messages for missing research
   - [ ] Support alternative research locations
   - [ ] Add debug logging

**Checklist:**
- [ ] Test written and failing
- [ ] --from-research flag implemented
- [ ] Auto-detection working
- [ ] Test passing

---

#### Task 15: Full Workflow Chain Integration Test

**Purpose:** Validate complete explore→research→decision chain works end-to-end

**TDD Flow:**

1. **RED - Write integration test for full chain:**
   - [ ] Test creates exploration, then research, then decision
   - [ ] Test validates handoff files are generated at each stage
   - [ ] Test validates context flows correctly between stages
   - [ ] Verify test fails (not all workflows implemented)

   **Test:**
   ```bash
   @test "full workflow chain: explore → research → decision" {
       # Stage 1: Explore
       run "$DT_WORKFLOW" explore test-topic --interactive --output "$TEST_PROJECT/explore-output.md"
       [ "$status" -eq 0 ]
       grep -q "## 📋 Research Topics" "$TEST_PROJECT/explore-output.md"
       
       # Simulate exploration completion (create handoff file)
       mkdir -p "$TEST_PROJECT/admin/explorations/test-topic"
       cp "$TEST_PROJECT/explore-output.md" "$TEST_PROJECT/admin/explorations/test-topic/exploration.md"
       echo "## 📋 Research Topics" > "$TEST_PROJECT/admin/explorations/test-topic/research-topics.md"
       
       # Stage 2: Research (from explore)
       run "$DT_WORKFLOW" research test-topic --from-explore --interactive --output "$TEST_PROJECT/research-output.md"
       [ "$status" -eq 0 ]
       grep -q "Related Exploration" "$TEST_PROJECT/research-output.md"
       
       # Simulate research completion (create handoff file)
       mkdir -p "$TEST_PROJECT/admin/research/test-topic"
       cp "$TEST_PROJECT/research-output.md" "$TEST_PROJECT/admin/research/test-topic/research-summary.md"
       
       # Stage 3: Decision (from research)
       run "$DT_WORKFLOW" decision test-topic --from-research --interactive --output "$TEST_PROJECT/decision-output.md"
       [ "$status" -eq 0 ]
       grep -q "Research Summary" "$TEST_PROJECT/decision-output.md"
   }
   ```

2. **GREEN - Ensure all components work together:**
   - [ ] All workflows produce expected output
   - [ ] Handoff files are correctly referenced
   - [ ] Context flows between stages
   - [ ] Verify test passes

3. **REFACTOR:**
   - [ ] Add error handling for partial chains
   - [ ] Document chain workflow in help text
   - [ ] Add examples to documentation

**Checklist:**
- [ ] Integration test written
- [ ] Full chain working
- [ ] Context flows correctly
- [ ] Test passing

---

## 📊 Progress Tracking

| Task | Status | Notes |
|------|--------|-------|
| Task 1: Enhance Exploration Templates | 🔴 Not Started | |
| Task 2: Enhance Research Templates | 🔴 Not Started | |
| Task 3: Enhance Decision Templates | 🔴 Not Started | |
| Task 4: Document Variable Contract | 🔴 Not Started | |
| Task 5: Replace Explore Heredocs | 🔴 Not Started | |
| Task 6: Validate Template-Spike Alignment | 🔴 Not Started | |
| Task 7: Research Structure Generation | 🔴 Not Started | |
| Task 8: Research Context Gathering | 🔴 Not Started | |
| Task 9: Research Handoff File | 🔴 Not Started | |
| Task 10: Decision Structure Generation | 🔴 Not Started | |
| Task 11: Decision Context Gathering | 🔴 Not Started | |
| Task 12: Decision Handoff File | 🔴 Not Started | |
| Task 13: --from-explore Flag | 🔴 Not Started | |
| Task 14: --from-research Flag | 🔴 Not Started | |
| Task 15: Full Chain Integration Test | 🔴 Not Started | |

---

## ✅ Completion Criteria

### Template Enhancement (ADR-006)
- [ ] Dev-infra exploration templates enhanced with structural examples
- [ ] Dev-infra research templates enhanced with structural examples
- [ ] Dev-infra decision templates enhanced with structural examples
- [ ] Template variable contract documented (FR-27)
- [ ] dt-workflow uses render.sh instead of heredocs (NFR-7)

### Workflow Implementation
- [ ] `dt-workflow research topic --interactive` works
- [ ] `dt-workflow decision topic --interactive` works
- [ ] `dt-workflow research --from-explore topic --interactive` chains correctly
- [ ] `dt-workflow decision --from-research topic --interactive` chains correctly
- [ ] Handoff files generated with required sections
- [ ] All tests passing

---

## 📦 Deliverables

### Template Enhancement
- Enhanced dev-infra templates (exploration/, research/, decision/)
- Template variable documentation (`lib/doc-gen/TEMPLATE-VARIABLES.md`)
- PR to dev-infra with template changes

### Workflow Implementation
- Research workflow implementation via render.sh
- Decision workflow implementation via render.sh
- Handoff file generation
- --from-explore and --from-research flags
- Updated tests covering all workflows

---

## 🔗 Dependencies

### Prerequisites

- [x] Phase 1 complete (foundation) - PR #32 merged 2026-01-26

### External Dependencies

- dev-infra project (template source)
- render.sh library (already in dev-toolkit)

### Blocks

- Phase 3: Cursor Integration (requires all workflows working)

---

## 🔗 Related Documents

- [Feature Hub](README.md)
- [Previous Phase: Phase 1](phase-1.md) - ✅ Complete
- [Next Phase: Phase 3](phase-3.md)
- [ADR-006: Template Enhancement](../../decisions/dt-workflow/adr-006-template-enhancement.md)
- [Research: Template Structure](../../research/dt-workflow/research-template-structure.md)
- [Research: Workflow I/O Specs](../../research/dt-workflow/research-workflow-io-specs.md)
- [Pattern 4: Handoff File Contract](../../../../docs/patterns/workflow-patterns.md)
- [Requirements](../../research/dt-workflow/requirements.md)

---

**Last Updated:** 2026-01-26  
**Status:** ✅ Expanded  
**Next:** Begin implementation with Task 1
