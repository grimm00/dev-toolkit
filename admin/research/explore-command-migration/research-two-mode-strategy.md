# Research: Two-Mode Template Strategy

**Research Topic:** /explore Command Migration  
**Question:** How should dt-doc-gen handle the Setup/Conduct mode distinction?  
**Status:** 🔴 Research  
**Priority:** 🔴 High  
**Created:** 2026-01-22  
**Last Updated:** 2026-01-22

---

## 🎯 Research Question

The /explore command produces ~60-80 lines in Setup Mode and ~200-300 lines in Conduct Mode. How should dt-doc-gen handle this distinction?

**Why High Priority:** This is the pattern-setting decision. Whatever we choose for /explore will apply to /research and other two-mode commands.

---

## 🔍 Research Goals

- [ ] Goal 1: Understand current dt-doc-gen capabilities (Phase 2 implementation)
- [ ] Goal 2: Evaluate options for mode support
- [ ] Goal 3: Consider implications for other two-mode commands (/research, etc.)
- [ ] Goal 4: Recommend simplest approach that meets needs

---

## 📚 Research Methodology

**Sources:**

- [ ] dt-doc-gen Phase 2 implementation (`bin/dt-doc-gen`)
- [ ] envsubst capabilities and limitations
- [ ] Web search: Template mode switching patterns
- [ ] Other projects with similar patterns

---

## 📊 Findings

### Finding 1: dt-doc-gen Current Capabilities

<!-- PLACEHOLDER: Document Phase 2 capabilities -->

**Template fetching:**
- [ ] How templates are located
- [ ] Template naming conventions

**Variable expansion:**
- [ ] envsubst behavior
- [ ] Supported variable types

**Limitations:**
- [ ] No conditionals (envsubst is simple substitution)
- [ ] No array iteration

**Source:** [dt-doc-gen implementation]

**Relevance:** Defines what's possible without changes

---

### Finding 2: Option Analysis

<!-- PLACEHOLDER: Analyze each option -->

**Option 1: Single template + mode parameter**
```bash
dt-doc-gen exploration --mode setup
dt-doc-gen exploration --mode conduct
```

- Pros: [List]
- Cons: [List]
- Feasibility: [Assessment]

---

**Option 2: Separate templates**
```
exploration-setup.tmpl
exploration-conduct.tmpl
```

- Pros: [List]
- Cons: [List]
- Feasibility: [Assessment]

---

**Option 3: Template conditionals**
```
{{#if mode == 'setup'}}
<!-- Setup content -->
{{/if}}
```

- Pros: [List]
- Cons: [List]
- Feasibility: [Assessment - likely not feasible with envsubst]

---

**Option 4: Command handles modes**
- Cursor command picks which template to invoke
- dt-doc-gen unaware of modes

- Pros: [List]
- Cons: [List]
- Feasibility: [Assessment]

**Source:** [Analysis, web search]

**Relevance:** Options for implementation

---

### Finding 3: Implications for Other Commands

<!-- PLACEHOLDER: Consider /research, etc. -->

**Commands with two modes:**
- /explore (Setup/Conduct)
- /research (Setup/Conduct)
- Others?

**Pattern consistency:**
- [ ] Should all use same approach
- [ ] Pattern locked in by /explore decision

**Source:** [Iteration plan, command documentation]

**Relevance:** Ensures pattern works for all cases

---

## 🔍 Analysis

<!-- PLACEHOLDER: Analysis after findings collected -->

**Key Insights:**
- [ ] Insight 1: [Description]
- [ ] Insight 2: [Description]

**Trade-off Summary:**

| Option | Complexity | Flexibility | Consistency |
|--------|------------|-------------|-------------|
| Mode parameter | ? | ? | ? |
| Separate templates | ? | ? | ? |
| Conditionals | ? | ? | ? |
| Command handles | ? | ? | ? |

---

## 💡 Recommendations

**Recommended approach:** [TBD]

**Rationale:** [TBD]

**Pattern for future commands:** [TBD]

---

## 📋 Requirements Discovered

- [ ] REQ-1: [Description]
- [ ] REQ-2: [Description]

---

## 🚀 Next Steps

1. Depends on gap analysis findings
2. Prototype recommended approach
3. Document pattern for future commands

---

**Last Updated:** 2026-01-22
