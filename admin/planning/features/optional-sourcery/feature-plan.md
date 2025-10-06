# Planning Note: Optional Sourcery Integration

**Date:** October 6, 2025  
**Status:** 📋 Planning  
**Related Phase:** Post-Phase 1 Enhancement  
**Feature Branch:** `feat/optional-sourcery-integration`

---

## 🎯 Objective

Make Sourcery integration clearly optional in the dev-toolkit, ensuring users understand:
1. Core features work without Sourcery
2. Sourcery has rate limits (500k diff chars/week on free tier)
3. They can choose to use or skip Sourcery based on their needs

---

## 🤔 Problem Statement

Currently, the toolkit presents all features equally without clarifying:
- Which features require external services (Sourcery)
- What the limitations are (rate limits)
- That users can get full value from core features alone

This could lead to:
- Users feeling forced to use Sourcery
- Surprise when hitting rate limits
- Confusion about what's required vs optional

---

## 💡 Proposed Solution

### 1. Clear Feature Categorization

**Core Features (No external dependencies):**
- `dt-git-safety` - Git Flow safety checks
- `dt-config` - Configuration management
- `dt-install-hooks` - Pre-commit hooks
- `lib/core/github-utils.sh` - GitHub utilities
- `lib/git-flow/utils.sh` - Git Flow utilities

**Optional Features (Require external services):**
- `dt-sourcery-parse` - Parse Sourcery reviews (requires Sourcery GitHub App)
- `dt-setup-sourcery` - Interactive Sourcery setup (requires Sourcery GitHub App)

### 2. Rate Limit Awareness

Add upfront information about Sourcery's rate limits:
- **Free tier:** 500,000 diff characters/week
- **What counts:** Every line added/removed in PRs
- **Reset:** Weekly
- **Options:** Upgrade for unlimited, or use strategically

### 3. Documentation Updates

**README.md:**
- Clearly mark core vs optional features
- Add rate limit warning in Sourcery section
- Show core features work independently

**New Document: `docs/OPTIONAL-FEATURES.md`:**
- Explain core-first philosophy
- Detail what works without Sourcery
- Provide decision guide (when to use/skip)
- Show manual alternatives

**Update: `docs/SOURCERY-SETUP.md`:**
- Expand rate limit section
- Add usage strategies
- Explain what happens when limit is hit

### 4. Interactive Setup Improvements

**`dt-setup-sourcery` enhancements:**
- Show rate limit info upfront (before installation)
- Explain this is optional
- Provide "skip" option
- Link to docs for more info

---

## 📋 Implementation Tasks

### Phase 1: Documentation (No Code Changes)
1. [ ] Update README.md to categorize features
2. [ ] Create `docs/OPTIONAL-FEATURES.md`
3. [ ] Expand rate limit section in `docs/SOURCERY-SETUP.md`
4. [ ] Add decision guide for users

### Phase 2: Setup Script Enhancement
1. [ ] Add rate limit warning to `dt-setup-sourcery`
2. [ ] Show "optional" messaging
3. [ ] Add graceful skip option
4. [ ] Link to documentation

### Phase 3: Parser Improvements
1. [ ] Ensure `dt-sourcery-parse` handles missing Sourcery gracefully
2. [ ] Add helpful error messages when Sourcery not installed
3. [ ] Suggest alternatives when rate limit hit

### Phase 4: Testing
1. [ ] Test toolkit usage without Sourcery installed
2. [ ] Verify all core features work independently
3. [ ] Test setup script with skip option
4. [ ] Verify error messages are helpful

---

## 🎨 Design Principles

### Core-First Philosophy
The toolkit should be **immediately useful** without external services:
- Git Flow safety checks work locally
- Pre-commit hooks work locally
- Configuration management works locally
- GitHub utilities only need `gh` CLI (free, open source)

### Optional Enhancement
Sourcery **enhances** but doesn't **define** the toolkit:
- AI code reviews are a bonus
- Security scanning is helpful but not required
- Users can add it later if interested

### Transparent Limitations
Be upfront about constraints:
- Free tier has limits (500k chars/week)
- Large projects may hit limits quickly
- Upgrade available but not required
- Manual alternatives exist

---

## 📊 Success Metrics

### User Understanding
- [ ] Users know core features work without Sourcery
- [ ] Users understand rate limits before installing
- [ ] Users can make informed decision about using Sourcery

### Documentation Quality
- [ ] Clear categorization of features
- [ ] Comprehensive decision guide
- [ ] Helpful troubleshooting for rate limits

### Code Quality
- [ ] Graceful handling when Sourcery not installed
- [ ] Helpful error messages
- [ ] No breaking changes to existing functionality

---

## 🔄 Backwards Compatibility

### No Breaking Changes
- All existing commands continue to work
- Existing installations unaffected
- Documentation additions only enhance understanding

### Migration Path
- Current users: No action needed
- New users: Better informed decisions
- Future users: Can add/remove Sourcery anytime

---

## 🤝 User Personas

### Persona 1: Privacy-Conscious Developer
**Needs:** Full control, no external services  
**Solution:** Use core features only (git-safety, hooks, config)  
**Value:** Complete Git Flow automation without external dependencies

### Persona 2: Solo Developer on Free Tier
**Needs:** AI reviews within budget  
**Solution:** Use Sourcery strategically, stay within 500k chars/week  
**Value:** Smart code reviews + full Git Flow automation

### Persona 3: Team with Large Codebase
**Needs:** Unlimited reviews or skip AI entirely  
**Solution:** Either upgrade Sourcery or use core features + manual reviews  
**Value:** Flexible approach based on team needs

### Persona 4: Learning Developer
**Needs:** Try everything, learn from AI  
**Solution:** Install Sourcery, learn from reviews, monitor usage  
**Value:** Educational AI feedback + workflow automation

---

## 📝 Open Questions

1. **Should we add usage tracking?**
   - Pro: Help users stay within limits
   - Con: Adds complexity, privacy concerns
   - **Decision:** No, let Sourcery handle this

2. **Should we support other review tools?**
   - Options: CodeRabbit, Codacy, etc.
   - **Decision:** Future enhancement (Phase 5)

3. **Should we warn before running dt-sourcery-parse?**
   - Pro: Reminds about rate limits
   - Con: Annoying for power users
   - **Decision:** Only warn if recently hit limit (check last error)

4. **Should we create a "lite" installation option?**
   - Pro: Explicitly skip Sourcery during install
   - Con: Adds complexity
   - **Decision:** No, just document that Sourcery is optional

---

## 🎯 Acceptance Criteria

### Documentation
- [ ] README clearly shows core vs optional features
- [ ] `OPTIONAL-FEATURES.md` provides comprehensive guide
- [ ] Rate limits explained in multiple places
- [ ] Decision guide helps users choose

### User Experience
- [ ] `dt-setup-sourcery` shows rate limit info upfront
- [ ] Users can skip Sourcery installation
- [ ] Error messages are helpful and actionable
- [ ] Core features work without Sourcery

### Code Quality
- [ ] No breaking changes
- [ ] Graceful error handling
- [ ] Clear separation of concerns
- [ ] Well-tested

---

## 🚀 Rollout Plan

### Step 1: Documentation (Low Risk)
- Update README
- Create OPTIONAL-FEATURES.md
- Expand SOURCERY-SETUP.md
- **Risk:** None, pure documentation

### Step 2: Setup Script (Medium Risk)
- Add rate limit warning
- Add skip option
- Improve messaging
- **Risk:** Could confuse existing users, but improvements are clear

### Step 3: Parser Enhancement (Low Risk)
- Better error messages
- Graceful handling
- **Risk:** Minimal, only improves UX

### Step 4: Testing & Release (Low Risk)
- Test without Sourcery
- Verify core features
- Create PR
- **Risk:** None, all changes are additive

---

## 📚 Related Documents

- `admin/planning/roadmap.md` - Overall project roadmap
- `admin/planning/phases/phase1-foundation.md` - Completed foundation
- `docs/SOURCERY-SETUP.md` - Existing Sourcery documentation
- `docs/troubleshooting/common-issues.md` - Troubleshooting guide

---

## 💬 Discussion Notes

### User Feedback (October 6, 2025)
> "Let's address the ability to optionally use sourcery or forgo it altogether, making any modifications to the script therein. When using the sourcery script, there should be something that talks about the rate limit"

**Key Points:**
1. Make Sourcery clearly optional
2. Add rate limit information
3. Ensure core features work independently

### Design Philosophy
- **Core-first:** Toolkit should be useful without external services
- **Transparent:** Be upfront about limitations and requirements
- **Flexible:** Let users choose their own workflow

---

## ✅ Next Steps

1. **Review this planning document** with user
2. **Get approval** on approach
3. **Update roadmap** if needed
4. **Begin implementation** following the rollout plan

---

**Status:** 📋 Awaiting approval  
**Owner:** AI Assistant (Claude)  
**Reviewer:** User (cdwilson)  
**Last Updated:** October 6, 2025
