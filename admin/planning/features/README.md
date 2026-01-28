# Features Directory

This directory tracks feature development following our standard workflow.

## Workflow

For each feature:

1. **Plan** - Create feature folder with `feature-plan.md`
2. **Phase 1** - Document plan in `phase-1.md`
3. **Implement** - Build Phase 1
4. **Track** - Update `phase-1.md` with progress
5. **Test** - Verify functionality (troubleshooting in `docs/troubleshooting/`)
6. **Complete** - Mark success, update docs
7. **Repeat** - Create `phase-2.md` for next phase

## Structure

```
features/
└── {feature-name}/
    ├── feature-plan.md    # Overall vision, problem, solution
    ├── phase-1.md         # Phase 1: plan, tasks, progress, notes
    ├── phase-2.md         # Phase 2: (created when Phase 1 complete)
    └── ...
```

## Current Features

### Doc Infrastructure
**Status:** 🔴 Not Started (Scaffolding Ready)  
**Folder:** `doc-infrastructure/`  
**Goal:** Implement dt-doc-gen and dt-doc-validate commands  
**Documents:**
- [Feature Hub](doc-infrastructure/README.md)
- [Transition Plan](doc-infrastructure/transition-plan.md)
- Phase 1-3 scaffolding ready

### Optional Sourcery Integration
**Status:** 📋 Phase 1 Planning  
**Folder:** `optional-sourcery/`  
**Goal:** Make Sourcery clearly optional with rate limit awareness

---

**Last Updated:** 2026-01-21
