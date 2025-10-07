# Opportunities Directory

**Purpose:** Track feature ideas and enhancement opportunities discovered through real-world usage

---

## 📁 Directory Structure

```
opportunities/
├── README.md           # This file
├── internal/           # Opportunities from dev-toolkit usage
│   └── {feature-name}/ # Subdirectory per opportunity
│       ├── analysis.md
│       └── proposal.md
└── external/           # Opportunities from other projects
    └── {feature-name}/ # Subdirectory per opportunity
        ├── analysis.md
        └── proposal.md
```

---

## 🎯 What Are Opportunities?

**Opportunities** are feature ideas that emerge from real-world usage, not from abstract planning.

### Characteristics
- ✅ **Discovered organically** - Found while using dev-toolkit in real projects
- ✅ **Proven value** - Addresses actual pain points or needs
- ✅ **Well-understood** - Context is clear because it came from usage
- ✅ **Documented thoroughly** - Analysis explains the problem and solution

### Not Opportunities
- ❌ Abstract "nice to have" features
- ❌ Features without clear use cases
- ❌ Speculative enhancements
- ❌ Features copied from other tools without context

---

## 📂 Internal vs External

### Internal Opportunities
**Source:** Dev-toolkit's own usage and development

**Examples:**
- Improvements discovered while building dev-toolkit
- Patterns noticed during testing
- Enhancements found during documentation
- Issues encountered in dev-toolkit development

**Location:** `internal/{feature-name}/`

---

### External Opportunities
**Source:** Using dev-toolkit in other projects

**Examples:**
- Patterns discovered in Pokehub integration
- Needs identified in other repositories
- Workflows that could be standardized
- Project-specific patterns that are reusable

**Location:** `external/{feature-name}/`

**Current Examples:**
- `external/workflow-helper/` - Discovered from Pokehub integration

---

## 📝 Documentation Pattern

### Each opportunity should have its own subdirectory with:

#### 1. Analysis Document (`analysis.md`)
**Purpose:** Understand the current state and problem

**Contents:**
- Current situation/problem
- Why it matters
- Detailed analysis of existing solutions
- What works / what doesn't
- Comparison with alternatives
- Verdict: Keep, modify, or create new

**Example:** `external/workflow-helper/workflow-helper-analysis.md`
- Analyzed Pokehub's workflow-helper.sh
- Determined it should stay in Pokehub (project-specific)
- Identified the reusable pattern

#### 2. Proposal/Idea Document (`proposal.md` or `*-idea.md`)
**Purpose:** Propose the solution

**Contents:**
- Concept and vision
- Proposed feature/enhancement
- Implementation approach
- Benefits and value
- Success metrics
- Examples and use cases
- Discussion points

**Example:** `external/workflow-helper/workflow-helper-template-idea.md`
- Proposed template generator
- Showed implementation approach
- Listed benefits and phases
- Provided examples

#### 3. Additional Documents (Optional)
- `research.md` - Research findings
- `examples/` - Code examples
- `prototypes/` - Proof of concepts
- `feedback.md` - User feedback

---

## 🔄 Opportunity Lifecycle

### 1. Discovery 💡
- Encounter pattern/need during real usage
- Document initial thoughts
- Create opportunity subdirectory

### 2. Analysis 🔍
- Create `analysis.md`
- Research existing solutions
- Understand the problem deeply
- Determine if it's worth pursuing

### 3. Proposal 📋
- Create proposal document
- Design the solution
- Plan implementation
- Estimate effort and value

### 4. Planning ✅
- Move to `features/{feature-name}/`
- Create feature plan
- Create phase plans
- Add to roadmap

### 5. Implementation 🚀
- Create feature branch
- Implement phases
- Test and document
- Release

### 6. Archive 📦
- Opportunity documents stay in `opportunities/`
- Serve as historical context
- Reference for similar features

---

## 🎨 Naming Conventions

### Subdirectory Names
- Use kebab-case: `workflow-helper`, `batch-operations`
- Be descriptive but concise
- Match the feature name when promoted

### Document Names
- `analysis.md` - Analysis of current state
- `proposal.md` or `{feature}-idea.md` - Proposed solution
- `research.md` - Research findings
- `feedback.md` - User feedback
- `examples.md` - Usage examples

---

## 📊 Current Opportunities

### External

#### ✅ Workflow Helper Template
**Status:** Promoted to feature (v0.3.0)  
**Location:** `external/workflow-helper/`  
**Origin:** Pokehub integration  
**Feature Plan:** `features/workflow-helper-template/`

**Documents:**
- `workflow-helper-analysis.md` (411 lines) - Analysis of Pokehub's script
- `workflow-helper-template-idea.md` (446 lines) - Template generator proposal

**Outcome:** Promoted to high-priority feature for v0.3.0

---

### Internal
**Status:** No opportunities yet

**Future Examples:**
- Test framework improvements
- CI/CD optimizations
- Documentation patterns
- Build system enhancements

---

## 🎯 Best Practices

### When Creating an Opportunity

1. **Create subdirectory immediately**
   ```bash
   mkdir -p admin/planning/notes/opportunities/external/feature-name
   ```

2. **Start with analysis**
   - Document current state
   - Understand the problem
   - Research alternatives

3. **Then create proposal**
   - Design solution
   - Plan implementation
   - Show examples

4. **Keep documents focused**
   - One opportunity per subdirectory
   - Clear, descriptive names
   - Comprehensive but not overwhelming

5. **Link documents together**
   - Analysis references proposal
   - Proposal references analysis
   - Both link to feature plan when promoted

### When Promoting to Feature

1. **Create feature plan** in `features/{feature-name}/`
2. **Update roadmap** with priority and timeline
3. **Keep opportunity docs** as historical context
4. **Link feature plan** back to opportunity documents

### Subdirectory Organization

**Good:**
```
opportunities/
├── external/
│   ├── workflow-helper/
│   │   ├── workflow-helper-analysis.md
│   │   └── workflow-helper-template-idea.md
│   └── batch-operations/
│       ├── analysis.md
│       └── proposal.md
└── internal/
    └── test-improvements/
        ├── analysis.md
        └── proposal.md
```

**Avoid:**
```
opportunities/
├── external/
│   ├── workflow-helper-analysis.md  ❌ No subdirectory
│   └── workflow-helper-idea.md      ❌ Files mixed together
```

---

## 🔗 Related Documentation

### Feature Development
- [Features Directory](../../features/README.md) - Where opportunities become features
- [Roadmap](../../roadmap.md) - Priority and timeline

### Process
- [Admin README](../../../README.md) - Overall admin structure
- [Planning Structure](../../README.md) - Planning organization

### Examples
- [Workflow Helper Feature](../../features/workflow-helper-template/) - Promoted opportunity
- [Testing Suite Feature](../../features/testing-suite/) - Completed feature

---

## 💡 Why This Matters

### Benefits of Opportunity Tracking

1. **Captures Context**
   - Documents why feature is needed
   - Preserves the "aha moment"
   - Shows real-world usage

2. **Better Decisions**
   - Thorough analysis before commitment
   - Clear value proposition
   - Realistic effort estimates

3. **Historical Record**
   - Shows how features were discovered
   - Explains design decisions
   - Helps with similar features

4. **AI Agent Coordination**
   - Clear structure for AI to understand
   - Comprehensive context for implementation
   - Consistent pattern across opportunities

---

## 📈 Success Metrics

### Quality Indicators
- ✅ Opportunities come from real usage
- ✅ Analysis is thorough and objective
- ✅ Proposals are detailed and actionable
- ✅ High promotion rate (opportunity → feature)

### Process Indicators
- ✅ Opportunities documented within 1 day of discovery
- ✅ Analysis completed before proposal
- ✅ Subdirectories keep documents organized
- ✅ Links maintained between related documents

---

## 🎓 Learning from Workflow Helper

### What Worked Well

1. **Discovered organically** - Found while integrating dev-toolkit into Pokehub
2. **Analyzed thoroughly** - 411-line analysis of existing solution
3. **Proposed clearly** - 446-line detailed proposal
4. **Organized well** - Subdirectory keeps related docs together
5. **Promoted quickly** - Clear value led to high priority

### Pattern to Repeat

```
Real Usage → Discovery → Analysis → Proposal → Feature Plan → Implementation
     ↓           ↓           ↓           ↓            ↓              ↓
  Pokehub    Pattern    Keep vs    Template    Phase Plans    v0.3.0
             Noticed    Create      Design
```

---

## 🚀 Getting Started

### Found an Opportunity?

1. **Create subdirectory:**
   ```bash
   mkdir -p admin/planning/notes/opportunities/{internal|external}/feature-name
   ```

2. **Start analysis:**
   ```bash
   # Create analysis.md
   # Document current state
   # Research alternatives
   ```

3. **Create proposal:**
   ```bash
   # Create proposal.md
   # Design solution
   # Show examples
   ```

4. **Discuss and decide:**
   - Review with team/community
   - Determine priority
   - Estimate effort

5. **Promote if approved:**
   - Create feature plan
   - Update roadmap
   - Begin implementation

---

**Created:** October 6, 2025  
**Last Updated:** October 6, 2025  
**Status:** Active - tracking opportunities from real usage  
**Current Count:** 1 external opportunity (workflow-helper, promoted to feature)
