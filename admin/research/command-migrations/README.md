# Command Migrations - Research Hub

**Purpose:** Research for migrating Cursor commands to dt-doc-gen/dt-doc-validate  
**Status:** 🔴 Research  
**Created:** 2026-01-22  
**Last Updated:** 2026-01-22

---

## 📋 Quick Links

### Active Research

| Sprint | Command | Status | Research |
|--------|---------|--------|----------|
| 1 | [/explore](explore/README.md) | ✅ Complete | **Migration cancelled** - validate-only approach |
| 2-6 | All others | ⬜ Cancelled | Same decision applies |

### Related Documents

- **[Explorations](../../explorations/command-migrations/README.md)** - Command migration explorations
- **[Iteration Plan](../doc-infrastructure/iteration-plan.md)** - Sprint-based migration strategy

---

## 🎯 Overview

This directory contains research for migrating Cursor commands from inline templates to using `dt-doc-gen` for document generation and `dt-doc-validate` for validation.

**Migration Pattern:**
1. `/explore` → Creates exploration structure for command migration
2. `/research` → Investigates gaps, value, strategy (this directory)
3. `/decision` → Makes architectural decisions (ADRs if needed)
4. Implementation → Modifies command to use dt-doc-gen

---

## 📊 Research Progress

| Command | Exploration | Research | Decision | Implementation |
|---------|-------------|----------|----------|----------------|
| /explore | ✅ | ✅ Complete | ✅ **Skip migration** | N/A |
| /research | ⬜ | ⬜ Cancelled | ✅ Same decision | N/A |
| /decision | ⬜ | ⬜ Cancelled | ✅ Same decision | N/A |
| /transition-plan | ⬜ | ⬜ Cancelled | ✅ Same decision | N/A |
| /task-phase | ⬜ | ⬜ Cancelled | ✅ Same decision | N/A |
| /fix-batch | ⬜ | ⬜ Cancelled | ✅ Same decision | N/A |

## 🔑 Key Decision: Skip Migration

**Research concluded that migrating Cursor commands to dt-doc-gen is NOT recommended.**

### Why?
- Cursor commands are AI instruction sets, not CLI template systems
- dt-doc-gen solves CLI problems, not AI command problems
- No pain points exist with current approach
- Main benefit (validation) achievable via dt-doc-validate on output

### Recommended Approach
Use **validate-only**: Run `dt-doc-validate` on generated documents.

### Impact
- Saves 30-50+ hours of migration work
- All 6 commands: use current approach + validate output
- dt-doc-gen remains for CLI/project template use cases

---

## 🔗 Related

- [Explorations Hub](../../explorations/command-migrations/README.md)
- [doc-infrastructure Research](../doc-infrastructure/README.md)

---

**Last Updated:** 2026-01-22
