# Admin Directory

This directory contains project management, documentation, and coordination materials for the dev-toolkit project.

## Structure

### 📋 `/planning`
Project planning and organization hub.

**Subdirectories:**
- **`/features`** - Feature-based planning and tracking
  - Each feature has its own directory (e.g., `testing-suite/`, `optional-sourcery/`)
  - Contains `feature-plan.md` and phase documents (`phase-1.md`, `phase-2.md`, etc.)
  - See [features/README.md](planning/features/README.md) for workflow

- **`/releases`** - Release management and documentation
  - Each release has its own directory (e.g., `v0.2.0/`)
  - Contains `checklist.md` and `release-notes.md`
  - See [releases/README.md](planning/releases/README.md) for process
  - See [releases/history.md](planning/releases/history.md) for all releases

- **`/phases`** - Historical phase tracking (Phase 1 foundation)

- **`/notes`** - Planning discussions, insights, and decision records

- **`roadmap.md`** - High-level project roadmap and priorities

### 💬 `/chat-logs`
Conversation history with AI agents, organized by year.
- **`/2025`** - Current year's chat logs
- Significant sessions saved with descriptive filenames

### 📊 `/feedback`
External feedback and code reviews.
- **`/sourcery`** - Sourcery AI code review extracts
  - Organized by PR number (e.g., `pr06.md`, `pr08.md`)
  - Includes priority matrices and action plans

### 📄 `/docs`
*(Currently empty - reserved for future admin-specific documentation)*

### 🧪 `/testing`
*(Currently empty - reserved for test plans and strategies)*

---

## Purpose

The `admin/` directory serves as the coordination hub for:
- **AI Agent Context** - Providing agents with project history and decisions
- **Project Planning** - Tracking features, releases, and progress
- **Release Management** - Structured release process and documentation
- **Code Quality** - Tracking and addressing external feedback
- **Collaboration** - Recording discussions and decision-making processes

---

## Current State (v0.2.0)

### Completed Features
- ✅ **Testing Suite** - 215 automated tests, comprehensive documentation
- ✅ **Optional Sourcery** - Clear core vs optional feature documentation

### Active Planning
- 🎯 **v0.3.0: Workflow Helper Template** - Next feature (HIGH priority)
- 📋 **Phase 4: Test Enhancements** - Deferred (optional)
- 📋 **v0.4.0: Batch Operations** - Planned
- 📋 **v0.5.0: Enhanced Git Flow** - Planned

### Recent Releases
- **v0.2.0** (Oct 6, 2025) - Testing & Reliability
- **v0.1.1** (Oct 6, 2025) - Optional Features Clarity
- **v0.1.0-alpha** (Oct 6, 2025) - Foundation

---

## Best Practices

### Opportunity Discovery
1. Document opportunities as they're discovered in `planning/notes/opportunities/`
2. Create subdirectory per opportunity: `{internal|external}/{feature-name}/`
3. Start with `analysis.md` to understand the problem
4. Create `proposal.md` or `*-idea.md` to design solution
5. Promote to feature when approved

### Feature Development
1. Create feature directory in `planning/features/`
2. Write `feature-plan.md` with vision and phases
3. Create phase documents as you go (`phase-1.md`, etc.)
4. Track progress with checkboxes
5. Document decisions and learnings

### Release Process
1. Create release directory in `planning/releases/vX.Y.Z/`
2. Use `checklist.md` to track release steps
3. Write polished `release-notes.md`
4. Update `history.md` and `roadmap.md`
5. Document lessons learned

### Chat Logs
1. Save significant AI conversations
2. Use descriptive filenames with dates
3. Include context about what was accomplished
4. Organize by year

### Feedback Management
1. Use `dt-review` to extract Sourcery reviews
2. Add priority matrices to assess suggestions
3. Create action plans for addressing feedback
4. Track which suggestions were implemented

---

## Key Files

- **[roadmap.md](planning/roadmap.md)** - Project direction and priorities
- **[releases/history.md](planning/releases/history.md)** - All releases timeline
- **[releases/README.md](planning/releases/README.md)** - Release process guide
- **[features/README.md](planning/features/README.md)** - Feature workflow guide
- **[opportunities/README.md](planning/notes/opportunities/README.md)** - Opportunity tracking guide

---

## Workflow Integration

This structure is designed to work seamlessly with:
- **AI Coding Assistants** (Cursor/Claude) - Context and history
- **Git Flow** - Release branches and version management
- **Code Review Tools** (Sourcery AI) - Feedback tracking
- **Testing Frameworks** (bats-core) - Test planning and results

---

*Last Updated: October 6, 2025 (v0.2.0 release)*
