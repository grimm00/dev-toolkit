# dt-workflow Learnings - Exploration to Planning

**Project:** dev-toolkit  
**Topic:** dt-workflow - Full Workflow (Exploration → Research → ADRs → Planning)  
**Date:** 2026-01-22  
**Status:** ✅ Complete  
**Last Updated:** 2026-01-22

---

## 📋 Overview

Captured learnings from completing the full exploration→research→decision→planning workflow for the dt-workflow unified command feature. This included spike validation, formal research, 5 ADRs, pattern library creation, and transition plan scaffolding.

**Scope:** Exploration through transition plan scaffolding (pre-implementation)

---

## ✅ What Worked Exceptionally Well

### Spike-First Approach for High-Risk Decisions

**Why it worked:**
The spike validated unified architecture and Phase 1 UX before investing in formal research. This provided confidence that the direction was sound.

**What made it successful:**
- Time-boxed (2-4 hours)
- Throwaway mindset (code may be discarded)
- Learning-focused (output is knowledge, not production code)
- Question-driven (clear success criteria)

**Template implications:**
- Add spike determination step to exploration workflow
- Document risk assessment framework for spike vs research decisions
- Create `/spike` command for future use

**Key examples:**
- Built `dt-workflow explore --interactive` in ~3 hours
- Validated context injection approach
- Discovered new questions about token scalability

**Benefits:**
- Reduced research scope by answering architectural questions early
- Provided concrete artifacts to discuss
- Built confidence in direction before heavy investment

---

### Research Revealing Universal Patterns

**Why it worked:**
Formal research on Context Gathering, I/O Specs, and Decision Propagation revealed patterns that apply across all workflows, not just dt-workflow.

**What made it successful:**
- Focused research questions
- External sources (Anthropic docs, Aider patterns, design system literature)
- Synthesis into actionable patterns

**Template implications:**
- Research should explicitly look for universal patterns
- Pattern consolidation step should be part of research workflow
- Two-tier documentation (rules + detailed docs) is effective

**Key examples:**
- L1/L2/L3 validation levels (from workflow I/O research)
- Context ordering START/MIDDLE/END (from "lost in the middle" research)
- Handoff file contracts (from workflow chaining research)

**Benefits:**
- 5 universal patterns identified
- Patterns documented in reusable format
- Future workflows can apply patterns immediately

---

### ADRs from Research (Not Guessing)

**Why it worked:**
ADRs were created only after research provided evidence, making decisions well-grounded.

**What made it successful:**
- Research-backed Y-statements
- Spike validation for architecture decisions
- Clear decision matrices with confidence levels

**Template implications:**
- ADR workflow should follow research completion
- Y-statement format works well for decisions
- Decision matrices help communicate confidence

**Key examples:**
- ADR-002 (Context Injection) backed by token analysis and "lost in the middle" research
- ADR-003 (Component Integration) backed by existing tool analysis
- ADR-005 (Pattern Documentation) backed by design system research

**Benefits:**
- High-confidence decisions (all rated "High")
- Clear rationale documented
- Easy to revisit and understand decisions later

---

### Context Ordering (START/MIDDLE/END)

**Why it worked:**
Research revealed that LLMs pay more attention to the beginning and end of context windows ("lost in the middle" problem). Ordering critical rules at START and task at END improved output quality.

**What made it successful:**
- Based on published research (Anthropic, academic papers)
- Easy to implement in spike
- Measurable improvement in outputs

**Template implications:**
- All context injection should follow START/MIDDLE/END pattern
- Critical rules always at START
- Task instructions always at END

**Key examples:**
- Cursor rules at START of dt-workflow output
- Background context (roadmap, git) in MIDDLE
- Task + instructions at END

**Benefits:**
- Better AI attention to important context
- User can see and trust context ordering
- Simple pattern to follow

---

## 🟡 What Needs Improvement

### Token Estimation Accuracy

**What the problem was:**
The spike uses character-based token estimation (~4 chars/token) which is rough. Different content types (code, prose, markdown) have different ratios.

**Why it occurred:**
Time-boxed spike focused on functionality over precision.

**Impact:**
Users may not fully trust token counts, though current output (~10K) is well within limits (~100K+).

**How to prevent:**
- Use actual tokenizer library (if available in bash)
- Or accept rough estimates with clear labeling ("~approximate")
- Or integrate with model-specific tokenizers

**Template changes needed:**
- Document that token estimates are approximate
- Consider adding tiktoken or similar if precision matters

---

### Research Topic Numbering Confusion

**What the problem was:**
Initially, research topics were not explicitly numbered in the README table, making `--topic-num` confusing.

**Why it occurred:**
Topic numbering was implicit in document order, not explicit in the table.

**Impact:**
User confusion about which topic to research.

**How to prevent:**
- Always include explicit `#` column in research topic tables
- Match numbers between table and document filenames

**Template changes needed:**
- Research hub template should include explicit numbering column
- Validate numbering consistency in research scaffolding

---

### Remaining Research Topics Deferred

**What the problem was:**
Research topics 4-6 (Component Decisions, Cursor Command Role, Model Selection) were marked "Analysis Ready" but addressed during decision phase rather than formal research.

**Why it occurred:**
These topics were lower risk and could be decided based on existing analysis, not new research.

**Impact:**
Research documents exist but are not fully filled out.

**How to prevent:**
- During research scaffolding, mark topics that may be "analysis only"
- Allow decision phase to close out low-risk topics without full research

**Template changes needed:**
- Add "Analysis Ready" status for topics that don't need deep research
- Decision phase can consume "Analysis Ready" topics directly

---

## 💡 Unexpected Discoveries

### Spike Reveals Better Research Questions

**Finding:**
The spike didn't just validate architecture—it revealed new, deeper questions about context scalability that weren't in the original exploration.

**Why it's valuable:**
Spikes can improve research quality by grounding questions in reality.

**How to leverage:**
- Run spike before finalizing research topics
- Update research topics based on spike learnings
- Expect spike to generate new questions, not just answers

---

### Two-Tier Pattern Documentation

**Finding:**
Design system research revealed that effective pattern documentation needs both:
- Tier 1: AI-discoverable, concise (Cursor rules)
- Tier 2: Detailed with rationale (docs/patterns/)
- Tier 3: ADRs for architectural decisions

**Why it's valuable:**
Solves the tension between AI needing quick reference and humans needing detailed explanation.

**How to leverage:**
- Create pattern library in `docs/patterns/`
- Add summaries to Cursor rules
- Use ADRs for significant decisions

---

### L1/L2/L3 Validation Pattern

**Finding:**
Three-level validation (Existence → Structure → Content) with different failure modes (hard fail → warn → inform) balances strictness with usability.

**Why it's valuable:**
Prevents frustrating hard failures on recoverable issues while catching critical problems.

**How to leverage:**
- Apply L1/L2/L3 pattern to all workflow inputs
- L1: Hard fail with actionable suggestion
- L2: Warn but proceed
- L3: Inform, allow continue

---

## ⏱️ Time Investment Analysis

**Breakdown:**

- Exploration (prior session): ~2 hours
- Spike implementation: ~3 hours
- Research (Topics 1-3): ~2 hours
- ADR creation (5 ADRs): ~1 hour
- Pattern library: ~30 minutes
- Transition plan scaffolding: ~30 minutes

**Total:** ~9 hours (exploration through planning)

**What took longer:**
- Research: Investigating external sources took time but yielded high-value patterns
- Spike enhancements: Adding research findings to spike was worth it

**What was faster:**
- ADR creation: Research made decisions clear, ADRs wrote quickly
- Pattern library: Patterns were already identified, just needed formatting
- Transition plan: Scaffolding from ADRs was straightforward

**Estimation lessons:**
- Spike-first can reduce overall time by focusing research
- Well-researched decisions write faster than guessed decisions
- Pattern identification pays dividends across features

---

## 📊 Metrics & Impact

**Documents created:**

- 1 spike implementation (bin/dt-workflow)
- 3 research documents (complete)
- 3 research documents (scaffolded, not deep researched)
- 5 ADRs
- 1 pattern library (5 patterns)
- 8 planning documents (feature hub, plan, transition, 4 phases, status)

**Quality metrics:**
- All ADRs rated "High" confidence
- 5 universal patterns identified
- Token usage validated (~10K, well under 50K limit)

**Developer experience improvements:**
- Explicit context injection builds user trust
- L1/L2/L3 validation provides helpful feedback
- Pattern library provides reusable guidance

---

## 🎯 Key Takeaways for Future Work

1. **Spike early for high-risk decisions** - Don't over-research before validating basics
2. **Research reveals patterns** - Look for universal applicability, not just feature-specific answers
3. **ADRs from evidence** - Decisions grounded in research are higher confidence
4. **Two-tier documentation** - AI needs quick reference, humans need rationale
5. **L1/L2/L3 validation** - Balance strictness with usability

---

**Last Updated:** 2026-01-22
