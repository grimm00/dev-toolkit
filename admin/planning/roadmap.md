# Dev Toolkit Roadmap

**Status:** 🚧 Active Development  
**Current Phase:** Phase 1 - Foundation  
**Version:** 0.1.0

## Vision

Create a portable, project-agnostic development toolkit that streamlines code reviews, Git workflows, and project automation across multiple repositories.

## Core Principles

1. **Portability** - Works in any project without modification
2. **Auto-Detection** - Intelligently discovers project context
3. **Modularity** - Use individual tools or the full suite
4. **Zero Dependencies** - Core features work with minimal requirements
5. **AI-Friendly** - Designed for seamless AI assistant integration

---

## 🎯 Development Phases

### Phase 1: Foundation ✅ IN PROGRESS
**Goal:** Establish project structure and core infrastructure

#### Tasks
- [x] Create repository structure
- [x] Set up admin/ directory for coordination
- [x] Create comprehensive README
- [x] Document roadmap and phases
- [ ] Copy core utilities from Pokehub
  - [ ] `github-utils.sh` (project-agnostic version)
  - [ ] `git-flow-utils.sh`
  - [ ] `sourcery-review-parser.sh`
- [ ] Create installation script
- [ ] Add basic tests

**Success Criteria:**
- Repository structure complete
- Core utilities copied and adapted
- Installation script functional
- Documentation comprehensive

---

### Phase 2: Sourcery Automation 📋 PLANNED
**Goal:** Fully functional Sourcery review extraction and formatting

#### Tasks
- [ ] Make `sourcery-review-parser.sh` project-agnostic
- [ ] Add global command wrapper (`sourcery-review`)
- [ ] Implement output formatting options
- [ ] Add batch processing for multiple PRs
- [ ] Create priority matrix templates
- [ ] Add error handling and validation

**Success Criteria:**
- Can extract reviews from any GitHub repository
- Multiple output formats supported
- Batch operations work correctly
- Comprehensive error messages

---

### Phase 3: Git Flow Enhancement 📋 PLANNED
**Goal:** Streamlined Git workflow commands

#### Tasks
- [ ] Adapt `workflow-helper.sh` to be project-agnostic
- [ ] Create `git-flow` command wrapper
- [ ] Implement batch operations
- [ ] Add branch management utilities
- [ ] Integrate GitHub API batching (jq)
- [ ] Add interactive mode for complex operations

**Success Criteria:**
- All Git Flow commands work globally
- Batch operations are efficient
- Interactive mode is user-friendly
- GitHub API calls are optimized

---

### Phase 4: Testing & Documentation 📋 PLANNED
**Goal:** Comprehensive testing and user documentation

#### Tasks
- [ ] Create test suite for all utilities
- [ ] Add integration tests
- [ ] Write detailed usage guides
- [ ] Create video tutorials (optional)
- [ ] Add troubleshooting documentation
- [ ] Performance benchmarks

**Success Criteria:**
- 80%+ test coverage
- All features documented
- Common issues have solutions
- Performance is acceptable

---

### Phase 5: Advanced Features 🔮 FUTURE
**Goal:** Enhanced automation and intelligence

#### Ideas
- [ ] AI-powered commit message generation
- [ ] Automated changelog generation
- [ ] Code quality metrics dashboard
- [ ] Integration with other review tools (CodeRabbit, etc.)
- [ ] Custom workflow templates
- [ ] Project scaffolding utilities

---

## 📊 Current Status

### Completed (v0.1.0-alpha - October 6, 2025)
- ✅ Repository structure
- ✅ Admin directory setup
- ✅ Comprehensive documentation
- ✅ Core utilities (project-agnostic)
- ✅ Installation system (install.sh, dev-setup.sh)
- ✅ Git hooks and CI/CD
- ✅ Command wrappers (dt-* commands)
- ✅ Sourcery integration with rate limit handling

### In Progress (v0.1.1)
- 🚧 Feature Phase 1: Optional Sourcery Integration
  - Making Sourcery clearly optional
  - Adding rate limit awareness
  - Improving documentation clarity

### Next Up
- 📋 Feature Phase 2: Enhanced Git Flow operations
- 📋 Feature Phase 3: Batch PR operations
- 📋 Version Phase: v1.0 Production Ready

---

## 🎯 Milestones

### v0.1.0-alpha - Foundation ✅ RELEASED (Oct 6, 2025)
- Complete project structure
- Core utilities (project-agnostic)
- Installation system
- Git hooks and CI/CD
- Comprehensive documentation
- Sourcery integration

### v0.1.1 - Optional Features Clarity 🚧 IN PROGRESS
- Clear core vs optional categorization
- Rate limit awareness
- Enhanced documentation
- Improved user experience

### v0.2.0 - Enhanced Git Flow (Planned)
- Advanced branch operations
- Batch PR management
- GitHub API optimization
- Interactive workflows

### v0.3.0 - Testing & Quality (Planned)
- Comprehensive test suite
- Performance benchmarks
- Code quality metrics
- Integration tests

### v1.0.0 - Production Ready (Future)
- Stable API
- Complete documentation
- Full test coverage
- Performance optimized
- Production-grade error handling

---

## 📝 Notes

### Origin Story
This toolkit emerged from the Pokehub project's need for portable Sourcery automation tools. Rather than copying scripts between projects, we're building a centralized, reusable toolkit.

### Key Decisions
1. **Bash over Python** - Maximum portability, minimal dependencies
2. **Global Installation** - Tools available system-wide
3. **Auto-Detection** - No manual configuration required
4. **Modular Design** - Use what you need, ignore the rest

### Related Projects
- **Pokehub** - Original source of utilities
- **REPO-Magic** - Inspired the automation approach

---

**Last Updated:** October 6, 2025  
**Next Review:** After v0.1.1 release

## 📁 Phase Organization

Phases are now organized by focus area:
- **Foundation:** `phases/phase1-foundation.md` (completed)
- **Features:** `phases/features/phase-{n}-{name}.md`
- **Versions:** `phases/versions/phase-v{version}-{focus}.md`

See `admin/planning/phases/README.md` for details.
