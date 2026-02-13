# Spike Workflow - Portable Pattern

**Purpose:** Drop-in spike workflow pattern for any project  
**Version:** 1.0  
**Source:** dt-workflow exploration learnings

---

## 🧪 What is a Spike?

A **spike** is a time-boxed experiment to answer a specific technical question or reduce risk. Unlike research (which investigates options), a spike **builds something minimal** to validate assumptions.

**Key characteristics:**
- **Time-boxed:** 2-4 hours maximum
- **Throwaway mindset:** Code may be discarded
- **Learning-focused:** Output is knowledge, not production code
- **Question-driven:** Clear success criteria before starting

---

## When to Spike vs Research

| Situation | Use Spike | Use Research |
|-----------|-----------|--------------|
| Architectural decision with high commitment | ✅ | |
| User-facing UX that needs to be "felt" | ✅ | |
| Technical uncertainty ("can it even work?") | ✅ | |
| Comparing known options | | ✅ |
| Investigating best practices | | ✅ |
| Low-risk, well-understood path | | ✅ |

---

## Spike Determination Framework

During exploration, assess each topic:

| Risk Level | Determination | Rationale |
|------------|---------------|-----------|
| 🔴 HIGH | **Spike first** | Hard to pivot once committed |
| 🟠 MEDIUM-HIGH | **Consider spike** | Benefits from hands-on validation |
| 🟡 MEDIUM | Research only | Depends on other decisions |
| 🟢 LOW | Research only | Clear path, low risk |

---

## Spike Workflow

### Step 1: Identify Candidates

During exploration, flag topics that need spikes:

```markdown
## 🧪 Spike Determination

| Topic | Risk Level | Spike? | Rationale |
|-------|------------|--------|-----------|
| [Topic 1] | 🔴 HIGH | Yes | [Why it needs validation] |
| [Topic 2] | 🟢 LOW | No | [Why research is sufficient] |
```

### Step 2: Define Success Criteria

Before starting, write down:

```markdown
## Spike: [Topic Name]

**Time box:** 2 hours

**Questions to answer:**
1. Can [specific thing] work?
2. Does [approach] feel right?
3. What's the [performance/complexity/UX]?

**Success looks like:**
- [ ] Built minimal [thing] that demonstrates [capability]
- [ ] Answered questions above with evidence
- [ ] Documented what surprised us
```

### Step 3: Execute (Time-Boxed)

1. **Set a timer** (2-4 hours)
2. **Build the minimum** to answer your questions
3. **Don't polish** - throwaway mindset
4. **Stop when timer ends** - even if incomplete

### Step 4: Document Learnings

```markdown
## Spike Learnings: [Topic Name]

**Date:** YYYY-MM-DD
**Duration:** X hours

### What Was Validated
| Question | Result | Confidence |
|----------|--------|------------|
| [Q1] | ✅/⚠️/❌ [Result] | High/Medium/Low |

### What We Learned
1. [Key learning 1]
2. [Key learning 2]

### Surprises / New Questions
- [Unexpected finding that changes our thinking]
- [New question revealed by implementation]

### Go/No-Go
**Recommendation:** [Proceed / Pivot / Need more investigation]

**Rationale:** [Why this recommendation]
```

---

## Integration with Explore → Research → Decision

```
┌──────────────┐
│   /explore   │ ← Identifies spike candidates
└──────┬───────┘
       │
       ▼
┌──────────────┐     ┌──────────────┐
│ Spike first? │────▶│    /spike    │ ← Time-boxed experiment
│  (if HIGH    │     │  (2-4 hrs)   │
│   risk)      │     └──────┬───────┘
└──────┬───────┘            │
       │                    │ Learnings inform
       ▼                    ▼
┌──────────────┐     ┌──────────────┐
│  /research   │◀────│   Continue   │
│ (if needed)  │     │  or pivot?   │
└──────┬───────┘     └──────────────┘
       │
       ▼
┌──────────────┐
│  /decision   │ ← Decisions backed by spike have HIGH confidence
└──────────────┘
```

**Note:** Spikes and research are iterative. A spike may reveal new questions requiring research, and research may identify areas that benefit from a spike.

---

## Why Spikes Matter

### For Senior Developers
- **Reduces commitment risk** on architectural decisions
- **Validates UX** before building full feature
- **Surfaces unknown unknowns** early

### For Junior Developers
Spikes are especially valuable as time-boxed "can it work?" sessions:
- **Removes pressure** to build something perfect
- **Makes failure safe** ("I couldn't figure it out" is valid)
- **Prevents rabbit holes** (timer enforces stopping)
- **Structured permission** to experiment

### For Teams
- **Aligns understanding** before major investment
- **Creates evidence** for decision-making
- **Builds shared vocabulary** around technical options

---

## Cursor Rules Integration

To add this to a project's Cursor rules, add to your `workflow.mdc`:

```markdown
## 🧪 Spike Workflow

### What is a Spike?

A **spike** is a time-boxed experiment to answer a specific technical question or reduce risk. Unlike research (which investigates options), a spike **builds something minimal** to validate assumptions.

**Key characteristics:**
- **Time-boxed:** 2-4 hours maximum
- **Throwaway mindset:** Code may be discarded
- **Learning-focused:** Output is knowledge, not production code
- **Question-driven:** Clear success criteria before starting

### Spike Determination Framework

During exploration, assess each topic:

| Risk Level | Determination | Rationale |
|------------|---------------|-----------|
| 🔴 HIGH | **Spike first** | Hard to pivot once committed |
| 🟠 MEDIUM-HIGH | **Consider spike** | Benefits from hands-on validation |
| 🟡 MEDIUM | Research only | Depends on other decisions |
| 🟢 LOW | Research only | Clear path, low risk |

### When to Spike vs Research

| Situation | Use Spike | Use Research |
|-----------|-----------|--------------|
| Architectural decision with high commitment | ✅ | |
| User-facing UX that needs to be "felt" | ✅ | |
| Technical uncertainty ("can it even work?") | ✅ | |
| Comparing known options | | ✅ |
| Investigating best practices | | ✅ |
| Low-risk, well-understood path | | ✅ |
```

---

**Last Updated:** 2026-02-13
