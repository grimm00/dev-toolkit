# Doc Infrastructure - Feature Hub

**Feature:** dt-doc-gen and dt-doc-validate  
**Status:** 🔴 Not Started  
**Created:** 2026-01-21  
**Last Updated:** 2026-01-21

---

## 📋 Quick Links

- **[Feature Plan](feature-plan.md)** - Feature overview and scope
- **[Transition Plan](transition-plan.md)** - Implementation transition
- **[Status & Next Steps](status-and-next-steps.md)** - Current progress

### Phase Documents

| Phase | Name | Status | Estimate |
|-------|------|--------|----------|
| [Phase 1](phase-1.md) | Shared Infrastructure | ✅ Complete | 2-3 days |
| [Phase 2](phase-2.md) | dt-doc-gen | ✅ Expanded | 3-4 days |
| [Phase 3](phase-3.md) | dt-doc-validate | 🔴 Scaffolding | 3-4 days |

### Related Documents

- **[Decisions Hub](../../../decisions/doc-infrastructure/README.md)** - 7 ADRs
- **[Research Hub](../../../research/doc-infrastructure/README.md)** - 7 research topics
- **[Requirements](../../../research/doc-infrastructure/requirements.md)** - 80 requirements
- **[Iteration Plan](../../../research/doc-infrastructure/iteration-plan.md)** - Command migration sprints

---

## 🎯 Feature Overview

Implement two new dev-toolkit commands for documentation generation and validation:

| Command | Purpose | Key Features |
|---------|---------|--------------|
| **dt-doc-gen** | Generate documentation from templates | Layered discovery, selective envsubst, two-mode |
| **dt-doc-validate** | Validate documents against rules | Auto type detection, pre-compiled rules, text/JSON output |

### Architecture

```
Cursor Commands → dt-doc-gen → Templates (dev-infra)
                ↘           ↗
            Shared Infrastructure (lib/core/output-utils.sh)
                ↗           ↘
Cursor Commands → dt-doc-validate → Rules (dev-infra)
```

---

## 📊 Progress Summary

| Metric | Value |
|--------|-------|
| **Phases** | 3 |
| **Total Estimate** | 8-11 days |
| **Requirements** | 80 (38 FR, 23 NFR, 19 C) |
| **ADRs** | 7 |

---

## 🚀 Next Steps

1. **Begin Phase 2** - Start implementation with Task 1
2. **Follow TDD** - RED → GREEN → REFACTOR for each task
3. **Create PR** - After Phase 2 complete

---

**Last Updated:** 2026-01-21
