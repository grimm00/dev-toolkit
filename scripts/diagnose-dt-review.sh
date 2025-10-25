#!/usr/bin/env bash

# Dev Toolkit - dt-review Diagnostic Script
# Helps troubleshoot dt-review issues on different systems

set -euo pipefail

echo "🔍 Dev Toolkit - dt-review Diagnostic Script"
echo "=============================================="
echo ""

# Check if we're in a git repository
echo "📁 Git Repository Check:"
if git rev-parse --git-dir > /dev/null 2>&1; then
    echo "✅ In a git repository"
    echo "   Repository root: $(git rev-parse --show-toplevel)"
    echo "   Current branch: $(git branch --show-current)"
    
    # Check for remote
    if git remote get-url origin > /dev/null 2>&1; then
        echo "   Remote origin: $(git remote get-url origin)"
    else
        echo "   ⚠️  No remote origin configured"
    fi
else
    echo "❌ Not in a git repository"
    echo "   dt-review requires being in a git repository"
fi
echo ""

# Check required dependencies
echo "🔧 Dependency Check:"
REQUIRED_DEPS=("git" "gh")
MISSING_DEPS=()

for dep in "${REQUIRED_DEPS[@]}"; do
    if command -v "$dep" >/dev/null 2>&1; then
        echo "✅ $dep: $(which $dep)"
        if [ "$dep" = "gh" ]; then
            echo "   Version: $(gh --version | head -1)"
        fi
    else
        echo "❌ $dep: Not found"
        MISSING_DEPS+=("$dep")
    fi
done

if [ ${#MISSING_DEPS[@]} -gt 0 ]; then
    echo ""
    echo "❌ Missing required dependencies: ${MISSING_DEPS[*]}"
    echo ""
    echo "Install instructions:"
    for dep in "${MISSING_DEPS[@]}"; do
        case "$dep" in
            "git")
                echo "   git: sudo apt install git (Ubuntu/Debian) or sudo yum install git (RHEL/CentOS)"
                ;;
            "gh")
                echo "   gh: Visit https://cli.github.com/ or use package manager"
                echo "      Ubuntu/Debian: curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg"
                echo "      Then: echo 'deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main' | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null"
                echo "      Then: sudo apt update && sudo apt install gh"
                ;;
        esac
    done
fi
echo ""

# Check GitHub CLI authentication
echo "🔐 GitHub Authentication Check:"
if command -v gh >/dev/null 2>&1; then
    if gh auth status >/dev/null 2>&1; then
        echo "✅ GitHub CLI is authenticated"
        echo "   Account: $(gh api user --jq .login 2>/dev/null || echo 'Unable to fetch')"
    else
        echo "❌ GitHub CLI is not authenticated"
        echo "   Run: gh auth login"
    fi
else
    echo "⚠️  GitHub CLI not available - cannot check authentication"
fi
echo ""

# Check dev-toolkit installation
echo "📦 Dev Toolkit Installation Check:"
if [ -n "${DT_ROOT:-}" ]; then
    echo "✅ DT_ROOT environment variable set: $DT_ROOT"
    TOOLKIT_ROOT="$DT_ROOT"
elif [ -f "$HOME/.dev-toolkit/bin/dt-review" ]; then
    echo "✅ Global installation found: $HOME/.dev-toolkit"
    TOOLKIT_ROOT="$HOME/.dev-toolkit"
elif [ -f "./bin/dt-review" ]; then
    echo "✅ Local development installation found: $(pwd)"
    TOOLKIT_ROOT="$(pwd)"
else
    echo "❌ Dev Toolkit installation not found"
    echo "   Expected locations:"
    echo "   - $HOME/.dev-toolkit/bin/dt-review (global)"
    echo "   - ./bin/dt-review (local development)"
    echo "   - Set DT_ROOT environment variable"
    exit 1
fi

# Check dt-review executable
echo "   dt-review: $TOOLKIT_ROOT/bin/dt-review"
if [ -f "$TOOLKIT_ROOT/bin/dt-review" ]; then
    if [ -x "$TOOLKIT_ROOT/bin/dt-review" ]; then
        echo "✅ dt-review is executable"
    else
        echo "❌ dt-review is not executable"
        echo "   Fix: chmod +x $TOOLKIT_ROOT/bin/dt-review"
    fi
else
    echo "❌ dt-review script not found"
fi

# Check dt-sourcery-parse executable
echo "   dt-sourcery-parse: $TOOLKIT_ROOT/bin/dt-sourcery-parse"
if [ -f "$TOOLKIT_ROOT/bin/dt-sourcery-parse" ]; then
    if [ -x "$TOOLKIT_ROOT/bin/dt-sourcery-parse" ]; then
        echo "✅ dt-sourcery-parse is executable"
    else
        echo "❌ dt-sourcery-parse is not executable"
        echo "   Fix: chmod +x $TOOLKIT_ROOT/bin/dt-sourcery-parse"
    fi
else
    echo "❌ dt-sourcery-parse script not found"
fi

# Check sourcery parser
echo "   sourcery parser: $TOOLKIT_ROOT/lib/sourcery/parser.sh"
if [ -f "$TOOLKIT_ROOT/lib/sourcery/parser.sh" ]; then
    if [ -x "$TOOLKIT_ROOT/lib/sourcery/parser.sh" ]; then
        echo "✅ sourcery parser is executable"
    else
        echo "❌ sourcery parser is not executable"
        echo "   Fix: chmod +x $TOOLKIT_ROOT/lib/sourcery/parser.sh"
    fi
else
    echo "❌ sourcery parser not found"
fi
echo ""

# Test basic functionality
echo "🧪 Basic Functionality Test:"
if [ -f "$TOOLKIT_ROOT/bin/dt-review" ] && [ -x "$TOOLKIT_ROOT/bin/dt-review" ]; then
    echo "Testing dt-review help..."
    if "$TOOLKIT_ROOT/bin/dt-review" --help >/dev/null 2>&1; then
        echo "✅ dt-review help works"
    else
        echo "❌ dt-review help failed"
        echo "   This indicates a script execution issue"
    fi
else
    echo "⚠️  Cannot test dt-review - script not found or not executable"
fi
echo ""

# Summary and recommendations
echo "📋 Summary and Recommendations:"
echo "================================"

if [ ${#MISSING_DEPS[@]} -gt 0 ]; then
    echo "❌ CRITICAL: Install missing dependencies first"
    echo ""
fi

if ! git rev-parse --git-dir > /dev/null 2>&1; then
    echo "❌ CRITICAL: Run this script from within a git repository"
    echo ""
fi

if command -v gh >/dev/null 2>&1 && ! gh auth status >/dev/null 2>&1; then
    echo "❌ CRITICAL: Authenticate with GitHub CLI: gh auth login"
    echo ""
fi

echo "💡 Common Solutions:"
echo "1. Ensure you're in a git repository with a GitHub remote"
echo "2. Install missing dependencies (git, gh CLI)"
echo "3. Authenticate GitHub CLI: gh auth login"
echo "4. Make scripts executable: chmod +x $TOOLKIT_ROOT/bin/*"
echo "5. Test with: $TOOLKIT_ROOT/bin/dt-review --help"
echo ""
echo "⚠️  Sourcery Rate Limiting:"
echo "   If dt-review fails with 'rate limit reached', this is normal:"
echo "   • Free tier: 500,000 diff characters per week"
echo "   • Resets weekly on Sundays"
echo "   • Upgrade available at: https://sourcery.ai/pricing"
echo "   • You can still view Sourcery comments on GitHub PR page"
echo ""
echo "🔗 For more help, see: docs/troubleshooting/common-issues.md"
