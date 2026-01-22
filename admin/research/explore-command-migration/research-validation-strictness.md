# Research: Validation Strictness by Mode

**Research Topic:** /explore Command Migration  
**Question:** Should dt-doc-validate have different strictness for Setup vs Conduct output?  
**Status:** 🔴 Research  
**Priority:** 🟠 Medium  
**Created:** 2026-01-22  
**Last Updated:** 2026-01-22

---

## 🎯 Research Question

Setup Mode output has intentional placeholders (`<!-- PLACEHOLDER: -->`). Conduct Mode output should be complete. Should validation know the difference?

**Why Medium Priority:** Affects dt-doc-validate design. May be over-engineering if not needed.

---

## 🔍 Research Goals

- [ ] Goal 1: Determine if Setup output needs validation at all
- [ ] Goal 2: Check if current dev-infra rules have strictness levels
- [ ] Goal 3: Evaluate options for mode-aware validation
- [ ] Goal 4: Pick simplest approach that meets needs

---

## 📚 Research Methodology

**Sources:**

- [ ] dt-doc-validate Phase 3 implementation
- [ ] Dev-infra validation rules structure
- [ ] Web search: Schema validation with strictness levels

---

## 📊 Findings

### Finding 1: Setup Mode Validation Needs

<!-- PLACEHOLDER: Assess if Setup needs validation -->

**What could go wrong in Setup Mode:**
- [ ] Missing required files
- [ ] Invalid status indicator
- [ ] Broken links

**What's intentionally incomplete:**
- [ ] Placeholder markers
- [ ] Unfilled sections
- [ ] Minimal content

**Conclusion:** Does Setup Mode even need validation?

**Source:** [/explore output analysis]

**Relevance:** May eliminate need for mode-aware validation

---

### Finding 2: Current Validation Capabilities

<!-- PLACEHOLDER: Document Phase 3 capabilities -->

**dt-doc-validate features:**
- [ ] Required sections
- [ ] Status indicators
- [ ] Link validation
- [ ] Custom rules per type

**Rule configuration:**
- [ ] How rules are defined
- [ ] How strictness could be added

**Source:** [dt-doc-validate implementation]

**Relevance:** Defines what's possible

---

### Finding 3: Option Analysis

<!-- PLACEHOLDER: Evaluate options -->

**Option 1: Status-aware rules**
- Check status field (`🔴 Scaffolding` vs `✅ Expanded`)
- Adjust validation based on status
- Single rule set

- Pros: [List]
- Cons: [List]

---

**Option 2: Mode parameter**
```bash
dt-doc-validate --mode setup  # lenient
dt-doc-validate --mode conduct  # strict
```

- Pros: [List]
- Cons: [List]

---

**Option 3: Separate rule sets**
```
exploration-setup.yaml
exploration.yaml
```

- Pros: [List]
- Cons: [List]

---

**Option 4: Single strict rules, manual review for scaffolding**
- Only validate Conduct Mode output
- Setup Mode: no validation (or minimal)

- Pros: [List]
- Cons: [List]

**Source:** [Analysis]

**Relevance:** Defines implementation approach

---

## 🔍 Analysis

<!-- PLACEHOLDER: Analysis after findings collected -->

**Simplicity assessment:**

| Option | Implementation Effort | Maintenance | User Experience |
|--------|----------------------|-------------|-----------------|
| Status-aware | ? | ? | ? |
| Mode parameter | ? | ? | ? |
| Separate rules | ? | ? | ? |
| Strict only | ? | ? | ? |

**Key Insights:**
- [ ] Insight 1: [Description]
- [ ] Insight 2: [Description]

---

## 💡 Recommendations

**Recommended approach:** [TBD - likely Option 4 (simplest)]

**Rationale:** [TBD]

---

## 📋 Requirements Discovered

- [ ] REQ-1: [Description]
- [ ] REQ-2: [Description]

---

## 🚀 Next Steps

1. Confirm if Setup validation is needed
2. Pick simplest approach
3. Document validation expectations for each mode

---

**Last Updated:** 2026-01-22
