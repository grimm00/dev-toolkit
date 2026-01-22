# Research Topics - /explore Command Migration

**Status:** 🔴 Scaffolding (needs expansion)  
**Created:** 2026-01-22

---

## 📋 Topics Identified

### Topic 1: Two-Mode Template Strategy

**Question:** How should dt-doc-gen handle the Setup/Conduct mode distinction?

**Priority:** 🔴 High

**Options to investigate:**
- Single template with mode parameter and conditionals
- Separate templates per mode (`exploration-setup.tmpl`, `exploration-conduct.tmpl`)
- Template inheritance (base template + mode-specific extensions)

---

### Topic 2: Variable Gap Analysis

**Question:** What variables does /explore need that dev-infra templates don't provide?

**Priority:** 🔴 High

**Items to investigate:**
- Current inline template variables
- Dev-infra template variables (exploration/*.tmpl)
- Missing variables that need to be added

---

### Topic 3: Theme/Question Extraction Location

**Question:** Should AI-powered theme extraction be in dt-doc-gen or the command wrapper?

**Priority:** 🟠 Medium

**Considerations:**
- dt-doc-gen is a CLI tool (no AI)
- Cursor command has AI context
- Separation of concerns: generation vs intelligence

---

### Topic 4: Validation Strictness by Mode

**Question:** Should dt-doc-validate have different strictness for Setup vs Conduct output?

**Priority:** 🟠 Medium

**Considerations:**
- Setup output has placeholders (intentionally incomplete)
- Conduct output should be fully expanded
- Status field indicates expected completeness

---

### Topic 5: Migration Fallback Strategy

**Question:** How long should inline templates remain as fallback?

**Priority:** 🟡 Low

**Options:**
- Until next sprint validates patterns
- Until all commands migrated
- Indefinitely (feature flag)

---

### Topic 6: Dev-Infra Template Inspection

**Question:** What's the actual structure of dev-infra exploration templates?

**Priority:** 🔴 High

**Action needed:**
- Read `scripts/doc-gen/templates/exploration/` in dev-infra
- Document template structure
- Compare to expected /explore output

---

## 🚀 Next Steps

Run `/explore explore-command-migration --conduct` to expand these topics with context and rationale.

---

**Last Updated:** 2026-01-22
