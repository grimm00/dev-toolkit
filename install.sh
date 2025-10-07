#!/usr/bin/env bash

# Dev Toolkit Installation Script
# Installs dev-toolkit globally or locally

set -euo pipefail

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

# Print functions
print_status() {
    local msg_type=$1
    local message=$2
    case $msg_type in
        "ERROR")   echo -e "${RED}❌ $message${NC}" ;;
        "WARNING") echo -e "${YELLOW}⚠️  $message${NC}" ;;
        "SUCCESS") echo -e "${GREEN}✅ $message${NC}" ;;
        "INFO")    echo -e "${BLUE}ℹ️  $message${NC}" ;;
        "HEADER")  echo -e "${BOLD}${CYAN}$message${NC}" ;;
    esac
}

print_header() {
    local title=$1
    echo -e "${BOLD}${CYAN}$title${NC}"
    echo -e "${CYAN}$(printf '═%.0s' $(seq 1 ${#title}))${NC}"
}

# Installation type
INSTALL_TYPE="global"  # global or local
BIN_DIR=""
CREATE_SYMLINKS=true

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --local)
            INSTALL_TYPE="local"
            shift
            ;;
        --no-symlinks)
            CREATE_SYMLINKS=false
            shift
            ;;
        --help|-h)
            echo "Dev Toolkit Installation Script"
            echo ""
            echo "Usage: $0 [OPTIONS]"
            echo ""
            echo "Options:"
            echo "  --local         Install locally (don't create symlinks)"
            echo "  --no-symlinks   Skip creating symlinks in /usr/local/bin"
            echo "  --help          Show this help message"
            echo ""
            echo "Examples:"
            echo "  $0                    # Global install with symlinks"
            echo "  $0 --local            # Local install, no symlinks"
            echo "  $0 --no-symlinks      # Global install without symlinks"
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            echo "Use --help for usage information"
            exit 1
            ;;
    esac
done

print_header "🚀 Dev Toolkit Installation"
echo ""

# Detect toolkit location
TOOLKIT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
print_status "INFO" "Installing from: $TOOLKIT_ROOT"
echo ""

# Check dependencies
print_status "INFO" "Checking dependencies..."

MISSING_DEPS=()
if ! command -v git >/dev/null 2>&1; then
    MISSING_DEPS+=("git")
fi
if ! command -v gh >/dev/null 2>&1; then
    MISSING_DEPS+=("gh")
fi

if [ ${#MISSING_DEPS[@]} -gt 0 ]; then
    print_status "ERROR" "Missing required dependencies: ${MISSING_DEPS[*]}"
    echo ""
    echo -e "${YELLOW}💡 Please install the missing dependencies:${NC}"
    for dep in "${MISSING_DEPS[@]}"; do
        case $dep in
            "git") echo "   - Git: https://git-scm.com/downloads" ;;
            "gh") echo "   - GitHub CLI: https://cli.github.com/" ;;
        esac
    done
    exit 1
fi

print_status "SUCCESS" "All required dependencies available"
echo ""

# Check optional dependencies
OPTIONAL_MISSING=()
if ! command -v jq >/dev/null 2>&1; then
    OPTIONAL_MISSING+=("jq")
fi

if [ ${#OPTIONAL_MISSING[@]} -gt 0 ]; then
    print_status "WARNING" "Optional dependencies not found: ${OPTIONAL_MISSING[*]}"
    echo -e "${YELLOW}💡 Some features may be limited. Consider installing:${NC}"
    echo "   - jq: brew install jq (for enhanced GitHub API operations)"
    echo ""
fi

# Installation
if [ "$INSTALL_TYPE" = "global" ]; then
    print_status "INFO" "Installing globally..."
    
    # Create config directory
    CONFIG_DIR="$HOME/.dev-toolkit"
    if [ ! -d "$CONFIG_DIR" ]; then
        mkdir -p "$CONFIG_DIR"
        print_status "SUCCESS" "Created config directory: $CONFIG_DIR"
    fi
    
    # Copy or link toolkit files
    if [ "$TOOLKIT_ROOT" != "$CONFIG_DIR" ]; then
        print_status "INFO" "Toolkit will be accessed from: $TOOLKIT_ROOT"
        print_status "INFO" "Config will be stored in: $CONFIG_DIR"
    fi
    
    # Create symlinks if requested
    if [ "$CREATE_SYMLINKS" = true ]; then
        print_status "INFO" "Creating command symlinks..."
        
        BIN_DIR="/usr/local/bin"
        if [ ! -d "$BIN_DIR" ]; then
            print_status "WARNING" "$BIN_DIR does not exist"
            print_status "INFO" "Creating $BIN_DIR (may require sudo)"
            sudo mkdir -p "$BIN_DIR"
        fi
        
        # Create symlinks for each command
        for cmd in "$TOOLKIT_ROOT"/bin/*; do
            cmd_name=$(basename "$cmd")
            target="$BIN_DIR/$cmd_name"
            
            if [ -L "$target" ]; then
                rm "$target"
            fi
            
            if ln -s "$cmd" "$target" 2>/dev/null; then
                print_status "SUCCESS" "Created symlink: $cmd_name"
            else
                print_status "WARNING" "Failed to create symlink for $cmd_name (may need sudo)"
                print_status "INFO" "Trying with sudo..."
                if sudo ln -s "$cmd" "$target"; then
                    print_status "SUCCESS" "Created symlink: $cmd_name (with sudo)"
                else
                    print_status "ERROR" "Failed to create symlink for $cmd_name"
                fi
            fi
        done
    fi
    
    echo ""
    print_status "SUCCESS" "Global installation complete!"
    echo ""
    echo -e "${CYAN}Available commands:${NC}"
    echo "  dt-sourcery-parse  - Parse Sourcery AI reviews from PRs"
    echo "  dt-review          - Quick Sourcery review extractor with Overall Comments detection"
    echo "  dt-git-safety      - Run Git Flow safety checks"
    echo "  dt-config          - Manage dev-toolkit configuration"
    echo ""
    echo -e "${YELLOW}Next steps:${NC}"
    echo "  1. Run 'dt-config create global' to create global config"
    echo "  2. Run 'dt-config show' to view current configuration"
    echo "  3. Try 'dt-git-safety check' in a git repository"
    
else
    print_status "INFO" "Installing locally..."
    print_status "INFO" "Toolkit available at: $TOOLKIT_ROOT"
    echo ""
    print_status "SUCCESS" "Local installation complete!"
    echo ""
    echo -e "${CYAN}To use the toolkit:${NC}"
    echo "  1. Set DT_ROOT environment variable:"
    echo "     export DT_ROOT=\"$TOOLKIT_ROOT\""
    echo ""
    echo "  2. Add bin directory to PATH:"
    echo "     export PATH=\"\$DT_ROOT/bin:\$PATH\""
    echo ""
    echo "  3. Or use commands directly:"
    echo "     $TOOLKIT_ROOT/bin/dt-sourcery-parse"
    echo "     $TOOLKIT_ROOT/bin/dt-review"
    echo "     $TOOLKIT_ROOT/bin/dt-git-safety"
    echo "     $TOOLKIT_ROOT/bin/dt-config"
fi

echo ""
print_status "INFO" "Installation log saved"
print_status "INFO" "For help, run: dt-config help"
echo ""
print_header "✨ Installation Complete!"
