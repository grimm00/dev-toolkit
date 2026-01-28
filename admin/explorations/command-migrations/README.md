# Command Migrations - Exploration Hub

**Purpose:** Explore migration of Cursor commands to use dt-doc-gen/dt-doc-validate  
**Status:** ✅ Complete (Migration NOT Recommended)  
**Created:** 2026-01-22  
**Last Updated:** 2026-01-22

---

## 📋 Quick Links

### Command Explorations

| Sprint | Command | Status | Notes |
|--------|---------|--------|-------|
| 1 | [/explore](explore/README.md) | ✅ **Complete** | Migration NOT recommended |
| 2-6 | All others | ⬜ Cancelled | Same decision applies |

### Related Documents

- **[Research Hub](../../research/command-migrations/README.md)** - Research for command migrations
- **[Iteration Plan](../../research/doc-infrastructure/iteration-plan.md)** - Overall migration strategy
- **[dt-doc-gen](../../planning/features/doc-infrastructure/phase-2.md)** - Phase 2 implementation
- **[dt-doc-validate](../../planning/features/doc-infrastructure/phase-3.md)** - Phase 3 implementation

---

## 🔑 Key Decision: Skip Migration

**Research concluded that migrating Cursor commands to dt-doc-gen is NOT recommended.**

### Why?

- **Cursor commands are AI instruction sets, not CLI template systems**
- dt-doc-gen solves CLI problems, not AI command problems
- No pain points exist with current approach
- Main benefit (validation) achievable via dt-doc-validate on output
- **Saves 30-50+ hours** of migration work across 6 commands

### Recommended Approach

Use **validate-only**: Run `dt-doc-validate` on AI-generated documents.

```bash
# Example: Validate exploration documents after /explore generates them
dt-doc-validate --type exploration admin/explorations/[topic]/
```

---

## 📊 Sprint Progress

| Sprint | Exploration | Research | Decision | Result |
|--------|-------------|----------|----------|--------|
| 1: /explore | ✅ | ✅ | ✅ **Skip** | Migration NOT recommended |
| 2-6: Others | ⬜ | ⬜ | ✅ Same | Cancelled |

**Legend:** ✅ Complete | ⬜ Cancelled

---

## 🎯 Overview

This exploration investigated migrating Cursor commands from inline templates to using `dt-doc-gen` and `dt-doc-validate`.

### Key Findings

1. **Architectural mismatch:** Cursor commands are AI-executed instruction sets. dt-doc-gen is a CLI tool using envsubst. These solve different problems.

2. **No pain points:** Current inline templates work well with no identified issues.

3. **Validation achievable without migration:** Use dt-doc-validate on generated output.

4. **Effort vs benefit:** 30-50+ hours of migration work for marginal improvement.

### Original Migration Flow (Cancelled)

```
┌─────────────────────────────────────────────────────────────────┐
│  PER-COMMAND MIGRATION WORKFLOW (CANCELLED)                     │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  1. /explore [command]-migration                                 │
│  2. /research (if questions arise)                               │
│  3. /decision (if significant choices)                           │
│  4. /transition-plan                                             │
│  5. /task-phase                                                  │
│                                                                  │
│  OUTCOME: Research showed migration is NOT recommended           │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

---

## 🚀 Conclusion

1. ✅ Exploration complete for /explore command
2. ✅ Research complete - migration NOT recommended
3. ✅ Decision: Use validate-only approach
4. ✅ Remaining commands: Same decision applies
5. **Initiative closed** - no further migration work needed

---

**Last Updated:** 2026-01-22
