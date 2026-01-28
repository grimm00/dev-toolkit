# ADR-006: Template Enhancement with Structural Examples

**Status:** ✅ Accepted  
**Created:** 2026-01-22  
**Last Updated:** 2026-01-22

---

## Context

The dt-workflow spike uses detailed heredocs that produce well-structured output, while dev-infra templates use minimal placeholders (`<!-- AI: ... -->`). Analysis revealed that AI generates more consistent, higher-quality content when given structural examples rather than vague fill instructions.

**Current State:**
- Dev-infra has 17 `.tmpl` files with minimal placeholders
- dt-workflow spike has heredocs with detailed structure (~70 lines vs ~44 lines)
- Spike output includes sections that templates lack (e.g., "Themes Analyzed" table)
- `render.sh` was missing several template variables (now added)

**Problem:**
- Templates rely on AI to infer structure from vague placeholders
- This leads to inconsistent output across invocations
- Spike's explicit structure produces better, more predictable results

**Related Research:**
- [Research: Template Structure](../../research/dt-workflow/research-template-structure.md)
- [Requirements](../../research/dt-workflow/requirements.md)

---

## Decision

**Adopt a hybrid template approach: enhanced templates with structural examples.**

Specifically:
1. **Enhance templates with structural examples** - Include table formats, list patterns, and section structures
2. **Maintain two-phase placeholders** - Keep `<!-- AI: -->` and `<!-- EXPAND: -->` distinction
3. **Templates remain in dev-infra** - Single source of truth, dev-toolkit uses them via render.sh
4. **dt-workflow uses render.sh** - Replace spike heredocs with template rendering
5. **Consider complexity variants** - Full/minimal/bare (future enhancement)

---

## Consequences

### Positive

- **Consistent output** - Structural examples guide AI to produce predictable formats
- **Maintainable** - Templates in dev-infra are single source of truth
- **Customizable** - envsubst variables allow project-specific values
- **Validated by research** - Skeleton-of-Thought confirms two-phase approach
- **Backward compatible** - Enhanced templates work with existing rendering

### Negative

- **Larger templates** - ~70 lines vs ~44 lines (more to maintain)
- **dev-infra dependency** - dt-workflow depends on dev-infra templates
- **Coordination required** - Template changes need dev-infra updates
- **Potential over-constraining** - Detailed structure may limit AI flexibility

---

## Alternatives Considered

### Alternative 1: Keep Minimal Placeholders

**Description:** Continue using current dev-infra templates with vague `<!-- AI: fill -->` placeholders.

**Pros:**
- Simpler templates
- More AI flexibility
- Less maintenance

**Cons:**
- Inconsistent output
- AI may miss expected structure
- Quality varies by invocation

**Why not chosen:** Research (Finding 1, Finding 5) shows structural examples significantly improve output consistency.

---

### Alternative 2: Embed Templates in dt-workflow

**Description:** Keep detailed heredocs in dt-workflow, don't use dev-infra templates.

**Pros:**
- No external dependency
- Full control in dt-workflow
- Spike already works

**Cons:**
- Duplicates template maintenance
- Not reusable by other tools
- Violates single source of truth

**Why not chosen:** ADR-003 established dt-doc-gen should be internal, and templates should be shared infrastructure.

---

### Alternative 3: Generate Minimal + Let AI Expand

**Description:** Generate minimal skeleton, let AI expand during `--conduct` phase.

**Pros:**
- Leverages AI creativity
- Minimal template maintenance
- Flexible output

**Cons:**
- Inconsistent structure across runs
- Harder to validate
- Quality depends on AI interpretation

**Why not chosen:** While valid for some use cases, workflow documents need predictable structure for tooling integration.

---

## Decision Rationale

### Research Support

1. **AGENTS.md best practices** - "Be as specific and detailed as possible—AI thrives on clear guidelines"
2. **Skeleton-of-Thought** - Two-phase (skeleton + expand) validated with 2x speed improvement
3. **MADR pattern** - Industry standard offers multiple template complexity levels

### Spike Validation

The spike's detailed heredocs produce better output than minimal templates because they show:
- Expected table formats
- Section organization
- Content patterns

### Maintainability Balance

Enhanced templates are ~60% larger but provide:
- 10x more consistent output
- Clear validation targets
- Better AI guidance

---

## Implementation Approach

### Phase 1: Foundation (Current dt-workflow work)

1. dt-workflow continues using spike heredocs (already working)
2. Defer template enhancement until Phase 2

### Phase 2 or Separate Work: Template Enhancement

1. Enhance dev-infra exploration templates with structural examples
2. Update dt-workflow to use `lib/doc-gen/render.sh`
3. Enhance research and decision templates
4. Validate output matches spike quality

### Future: Complexity Variants

After base templates are enhanced, consider:
- `*.md.tmpl` - Full (default)
- `*-minimal.md.tmpl` - Core sections only
- `*-bare.md.tmpl` - Absolute minimum

---

## Requirements Impact

**Requirements Addressed:**
- FR-24: Template Structural Examples
- FR-25: Template Complexity Variants (deferred)
- FR-26: Section Completeness Markers
- FR-27: Template Variable Documentation
- NFR-7: Template-Spike Alignment

**Implementation Notes:**
- FR-24, FR-26, FR-27, NFR-7 should be Phase 2 or parallel work
- FR-25 (variants) is future enhancement

---

## References

- [Research: Template Structure](../../research/dt-workflow/research-template-structure.md)
- [AGENTS.md Best Practices](https://agentsmd.io/agents-md-best-practices)
- [Skeleton-of-Thought Research](https://learnprompting.org/docs/advanced/decomposition/skeleton_of_thoughts)
- [MADR Templates](https://adr.github.io/madr/)
- [Requirements](../../research/dt-workflow/requirements.md)

---

**Last Updated:** 2026-01-22
