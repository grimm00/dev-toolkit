# Research Topics - /explore Command Migration

**Status:** ✅ Expanded  
**Created:** 2026-01-22  
**Expanded:** 2026-01-22

---

## 📋 Research Topics

### Topic 1: Two-Mode Template Strategy

**Question:** How should dt-doc-gen handle the Setup/Conduct mode distinction?

**Context:** The /explore command produces ~60-80 lines in Setup Mode and ~200-300 lines in Conduct Mode. This is a command-level concern, but templates may need to support both outputs.

**Priority:** 🔴 High

**Rationale:** This is the pattern-setting decision. Whatever we choose for /explore will apply to /research and other two-mode commands.

**Options to investigate:**
1. **Single template + mode parameter:** `dt-doc-gen exploration --mode setup`
2. **Separate templates:** `exploration-setup.tmpl` vs `exploration-conduct.tmpl`
3. **Template conditionals:** Single template with `{{#if mode == 'setup'}}` sections
4. **Command handles modes:** Cursor command picks which template to invoke

**Suggested Approach:**
- Review how dev-infra templates are currently structured
- Check if envsubst (Phase 2 approach) supports conditionals
- Prototype both approaches with /explore

---

### Topic 2: Variable Gap Analysis

**Question:** What variables does /explore need that dev-infra templates don't provide?

**Context:** We've never actually inspected the dev-infra exploration templates. Before migrating, we need to know what's there.

**Priority:** 🔴 High (BLOCKING)

**Rationale:** Can't migrate without knowing the gap. This research unlocks all other work.

**Items to investigate:**
- Read `scripts/doc-gen/templates/exploration/` in dev-infra
- Document template structure, variables, markers
- Compare to /explore inline templates in `.cursor/commands/explore.md`
- List missing variables that need to be added

**Suggested Approach:**
- Clone/checkout dev-infra repo
- Read exploration/*.tmpl files
- Create comparison matrix: Expected vs Available
- Document gaps and proposed solutions

---

### Topic 3: Theme/Question Extraction Location

**Question:** Should AI-powered theme extraction be in dt-doc-gen or the command wrapper?

**Context:** The /explore command transforms unstructured input into themes and questions. Where does this AI work happen?

**Priority:** 🟠 Medium

**Rationale:** Important for architecture clarity, but likely answer is "command wrapper" since dt-doc-gen is a CLI tool.

**Considerations:**
- dt-doc-gen is a Bash CLI tool (no AI capabilities)
- Cursor commands have access to Claude AI
- Separation of concerns: AI extracts, dt-doc-gen formats

**Suggested Approach:**
- Map current /explore data flow (input → themes → output)
- Identify where AI work happens today
- Confirm dt-doc-gen receives pre-extracted variables

---

### Topic 4: Validation Strictness by Mode

**Question:** Should dt-doc-validate have different strictness for Setup vs Conduct output?

**Context:** Setup output has intentional placeholders. Conduct output should be complete. Should validation know the difference?

**Priority:** 🟠 Medium

**Rationale:** Affects dt-doc-validate design. May be over-engineering if not needed.

**Options:**
1. **Status-aware rules:** Check status field, adjust strictness
2. **Mode parameter:** `dt-doc-validate --mode setup` (lenient) vs `--mode conduct` (strict)
3. **Separate rule sets:** `exploration-setup.yaml` vs `exploration.yaml`
4. **Single strict rules:** Manual review for scaffolding, validation for expanded only

**Suggested Approach:**
- Determine if Setup output needs validation at all
- Check if current dev-infra rules have strictness levels
- Pick simplest approach that meets needs

---

### Topic 5: Migration Fallback Strategy

**Question:** How long should inline templates remain as fallback?

**Context:** During migration, should the old code remain as fallback? For how long?

**Priority:** 🟡 Low (Can decide later)

**Rationale:** This is a migration execution detail, not architecture. Can decide once we start.

**Options:**
1. **No fallback:** Direct cutover (higher risk, cleaner code)
2. **Until next sprint:** Fallback for /explore until /research sprint validates patterns
3. **Until all commands migrated:** Long transition, maintenance burden
4. **Feature flag:** Indefinite, user-controlled

**Suggested Approach:**
- Start with fallback for safety
- Remove when confidence is high
- Don't over-plan this; decide based on experience

---

### Topic 6: Dev-Infra Template Inspection

**Question:** What's the actual structure of dev-infra exploration templates?

**Context:** We're making assumptions about dev-infra templates without having read them.

**Priority:** 🔴 High (BLOCKING)

**Rationale:** This is foundational research. Must happen before any migration work.

**Action needed:**
- Read `scripts/doc-gen/templates/exploration/` in dev-infra
- Document: file names, variables expected, section structure
- Check for AI markers (`<!-- AI: -->`, `<!-- EXPAND: -->`)
- Compare to expected /explore output

**Suggested Approach:**
- Direct file inspection
- Create documentation of findings
- Share findings as input to decision phase

---

### Topic 7: Is This Migration Worth It? (NEW)

**Question:** Given the coordination overhead, is migrating /explore to dt-doc-gen worth the effort?

**Context:** Migration involves cross-project PRs, template changes, validation setup. What problem are we solving?

**Priority:** 🔴 High (STRATEGIC)

**Rationale:** Should validate the value proposition before committing to 6 command migrations.

**Sub-questions:**
- What problems do inline templates cause today?
- What benefits does dt-doc-gen provide for /explore specifically?
- What's the minimum viable migration?
- Could we achieve the same benefits with inline restructuring?

**Suggested Approach:**
- List current pain points with /explore (if any)
- Estimate migration effort (hours/days)
- Compare effort vs benefit
- Consider "do nothing" as a valid option

---

### Topic 8: Cross-Project Coordination Model (NEW)

**Question:** How should dev-toolkit and dev-infra coordinate on template changes?

**Context:** Migrations may require template changes in dev-infra. How do we manage this?

**Priority:** 🟠 Medium

**Rationale:** Coordination friction could kill velocity. Need clear pattern.

**Options:**
1. **PR per change:** Fine-grained, slow
2. **PR per sprint:** Batched, balanced
3. **PR per feature:** Coarse-grained, large PRs
4. **Fork/override:** dev-toolkit has own templates, no coordination

**Suggested Approach:**
- Review iteration plan's recommendation (PR per sprint)
- Consider if dev-toolkit should own templates (fork)
- Decide based on change frequency expectations

---

### Topic 9: Bulk Template Updates (NEW)

**Question:** Should we do bulk template updates in dev-infra before starting migrations?

**Context:** Example: Adding `<!-- AI: -->` markers to ALL templates could be done once, or per-migration.

**Priority:** 🟡 Low

**Rationale:** Depends on what gap analysis reveals. May not be needed.

**Scenarios:**
- If many templates need same change → bulk update first
- If changes are command-specific → per-sprint updates
- If no changes needed → skip this entirely

**Suggested Approach:**
- Wait for Topic 2 (gap analysis) results
- Decide based on actual gaps found
- Don't pre-optimize

---

## 🎯 Research Workflow

### Recommended Order

1. **Topic 6 + Topic 2:** Dev-infra template inspection + gap analysis (BLOCKING)
2. **Topic 7:** Is this migration worth it? (STRATEGIC)
3. **Topic 1:** Two-mode template strategy
4. **Topic 3:** Theme extraction location (likely quick to confirm)
5. **Topic 4:** Validation strictness (may simplify based on findings)
6. **Topics 5, 8, 9:** Migration execution details (decide during implementation)

### Next Command

```
/research explore-command-migration --from-explore
```

This will create research documents for the high-priority topics.

### Decision Criteria

After research, decide:
- **Full migration:** If benefits > costs, proceed with iteration plan
- **Simplified migration:** If some benefits, reduce scope
- **Inline restructuring:** If minimal benefit, improve inline templates instead
- **No change:** If inline templates are fine, move on

---

## 🔗 Related Documents

- [Exploration](exploration.md) - Full exploration document
- [Command Migrations Hub](../README.md)
- [Iteration Plan](../../../research/doc-infrastructure/iteration-plan.md)
- [Research](../../../research/command-migrations/explore/README.md)

---

**Last Updated:** 2026-01-22
