#!/usr/bin/env bash

# Dev Toolkit - Development Setup Script
# Sets up environment for local development and testing
#
# IMPORTANT: Must be sourced, not executed!
# Usage: source dev-setup.sh

# Detect script directory (works in both bash and zsh)
if [ -n "${BASH_SOURCE[0]:-}" ]; then
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
elif [ -n "${ZSH_VERSION:-}" ]; then
    SCRIPT_DIR="$(cd "$(dirname "${(%):-%x}")" && pwd)"
else
    SCRIPT_DIR="$(pwd)"
fi

echo ""
echo "🔧 Dev Toolkit - Development Setup"
echo "=================================="
echo ""

# Check if being sourced (only in interactive shells)
if [ -n "${BASH_VERSION:-}" ]; then
    # Bash: check if BASH_SOURCE[0] equals $0
    if [ "${BASH_SOURCE[0]}" = "${0}" ] 2>/dev/null; then
        echo "⚠️  WARNING: This script should be SOURCED, not executed!"
        echo ""
        echo "❌ Don't run: ./dev-setup.sh"
        echo "✅ Instead run: source dev-setup.sh"
        echo ""
        echo "Why? Environment variables need to be set in your current shell,"
        echo "not in a sub-shell that exits immediately."
        echo ""
        return 1 2>/dev/null || exit 1
    fi
fi

echo "Setting up development environment..."
echo ""

# Set DT_ROOT
export DT_ROOT="$SCRIPT_DIR"
echo "✅ DT_ROOT set to: $DT_ROOT"

# Add bin to PATH
export PATH="$SCRIPT_DIR/bin:$PATH"
echo "✅ Added bin/ to PATH"

echo ""
echo "🎉 Development environment ready!"
echo ""
echo "Available commands:"
echo "  dt-config show"
echo "  dt-git-safety check"
echo "  dt-sourcery-parse"
echo ""
echo "To make this persistent, add to your ~/.zshrc:"
echo "  export DT_ROOT=\"$SCRIPT_DIR\""
echo "  export PATH=\"\$DT_ROOT/bin:\$PATH\""
echo ""
echo "Or run: source dev-setup.sh"
