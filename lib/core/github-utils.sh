#!/bin/bash

# GitHub Integration Utilities for Dev Toolkit
# Centralized utilities for GitHub CLI operations and project management
# Auto-detects project context from git repository

# ============================================================================
# COLOR DEFINITIONS
# ============================================================================

# Colors for output (only if terminal supports it)
if [[ -t 1 ]] && command -v tput >/dev/null 2>&1; then
    GH_RED='\033[0;31m'
    GH_GREEN='\033[0;32m'
    GH_YELLOW='\033[1;33m'
    GH_BLUE='\033[0;34m'
    GH_PURPLE='\033[0;35m'
    GH_CYAN='\033[0;36m'
    GH_BOLD='\033[1m'
    GH_NC='\033[0m' # No Color
else
    GH_RED=''
    GH_GREEN=''
    GH_YELLOW=''
    GH_BLUE=''
    GH_PURPLE=''
    GH_CYAN=''
    GH_BOLD=''
    GH_NC=''
fi

# ============================================================================
# CONFIGURATION
# ============================================================================

# Project configuration (auto-detected from git repository)
PROJECT_NAME=""
PROJECT_OWNER=""
PROJECT_REPO=""
PROJECT_DESCRIPTION=""

# Default configuration (can be overridden by environment variables)
DEFAULT_MAIN_BRANCH="main"
DEFAULT_DEVELOP_BRANCH="develop"
DEFAULT_PROTECTED_BRANCHES=("main" "develop")
DEFAULT_BRANCH_PREFIXES=("feat/" "fix/" "chore/" "hotfix/" "feature/")

# Load configuration from environment variables or use defaults
GH_MAIN_BRANCH="${GITHUB_MAIN_BRANCH:-${DEFAULT_MAIN_BRANCH}}"
GH_DEVELOP_BRANCH="${GITHUB_DEVELOP_BRANCH:-${DEFAULT_DEVELOP_BRANCH}}"

# Load protected branches from env var (comma-separated) or use defaults
if [ -n "${GITHUB_PROTECTED_BRANCHES:-}" ]; then
    IFS=',' read -ra GH_PROTECTED_BRANCHES <<< "$GITHUB_PROTECTED_BRANCHES"
else
    GH_PROTECTED_BRANCHES=("${DEFAULT_PROTECTED_BRANCHES[@]}")
fi

# Load branch prefixes from env var (comma-separated) or use defaults
if [ -n "${GITHUB_BRANCH_PREFIXES:-}" ]; then
    IFS=',' read -ra GH_BRANCH_PREFIXES <<< "$GITHUB_BRANCH_PREFIXES"
else
    GH_BRANCH_PREFIXES=("${DEFAULT_BRANCH_PREFIXES[@]}")
fi

# Configuration file paths (project-specific takes precedence)
CONFIG_FILE_PROJECT=".dev-toolkit.conf"
CONFIG_FILE_GLOBAL="${GITHUB_CONFIG_FILE:-$HOME/.dev-toolkit/config}"

# ============================================================================
# STATUS PRINTING FUNCTIONS
# ============================================================================

# Function to print colored status messages
gh_print_status() {
    local msg_type=$1
    local message=$2
    case $msg_type in
        "ERROR")   echo -e "${GH_RED}❌ $message${GH_NC}" ;;
        "WARNING") echo -e "${GH_YELLOW}⚠️  $message${GH_NC}" ;;
        "SUCCESS") echo -e "${GH_GREEN}✅ $message${GH_NC}" ;;
        "INFO")    echo -e "${GH_BLUE}ℹ️  $message${GH_NC}" ;;
        "HEADER")  echo -e "${GH_BOLD}${GH_CYAN}$message${GH_NC}" ;;
        "SECTION") echo -e "${GH_BOLD}${GH_PURPLE}$message${GH_NC}" ;;
    esac
}

# Function to print section headers
gh_print_section() {
    local title=$1
    echo -e "${GH_BOLD}${GH_PURPLE}$title${GH_NC}"
}

# Function to print main headers
gh_print_header() {
    local title=$1
    echo -e "${GH_BOLD}${GH_CYAN}$title${GH_NC}"
    echo -e "${GH_CYAN}$(printf '═%.0s' $(seq 1 ${#title}))${GH_NC}"
}

# ============================================================================
# DEPENDENCY CHECKING
# ============================================================================

# Required dependencies for GitHub operations
REQUIRED_DEPS=("git" "gh")
OPTIONAL_DEPS=("jq" "curl" "openssl")

# Check if a command exists
gh_command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check required dependencies
gh_check_required_dependencies() {
    local missing_deps=()
    
    for dep in "${REQUIRED_DEPS[@]}"; do
        if ! gh_command_exists "$dep"; then
            missing_deps+=("$dep")
        fi
    done
    
    if [ ${#missing_deps[@]} -gt 0 ]; then
        gh_print_status "ERROR" "Missing required dependencies: ${missing_deps[*]}"
        echo -e "${GH_YELLOW}💡 Please install the missing dependencies:${GH_NC}"
        for dep in "${missing_deps[@]}"; do
            case $dep in
                "git") echo "   - Git: https://git-scm.com/downloads" ;;
                "gh") echo "   - GitHub CLI: https://cli.github.com/" ;;
                *) echo "   - $dep" ;;
            esac
        done
        return 1
    fi
    
    return 0
}

# Check optional dependencies and warn if missing
gh_check_optional_dependencies() {
    local missing_optional=()
    
    for dep in "${OPTIONAL_DEPS[@]}"; do
        if ! gh_command_exists "$dep"; then
            missing_optional+=("$dep")
        fi
    done
    
    if [ ${#missing_optional[@]} -gt 0 ]; then
        gh_print_status "WARNING" "Optional dependencies not found: ${missing_optional[*]}"
        echo -e "${GH_YELLOW}💡 Some features may be limited. Consider installing:${GH_NC}"
        for dep in "${missing_optional[@]}"; do
            case $dep in
                "jq") echo "   - jq: https://stedolan.github.io/jq/" ;;
                "curl") echo "   - curl: Usually pre-installed on most systems" ;;
                "openssl") echo "   - openssl: For secure random generation" ;;
                *) echo "   - $dep" ;;
            esac
        done
        echo ""
    fi
}

# Comprehensive dependency check
gh_check_dependencies() {
    gh_print_section "🔍 Dependency Check"
    
    if ! gh_check_required_dependencies; then
        return 1
    fi
    
    gh_check_optional_dependencies
    
    gh_print_status "SUCCESS" "All required dependencies available"
    return 0
}

# ============================================================================
# PROJECT AUTO-DETECTION
# ============================================================================

# Auto-detect project information from git repository
gh_detect_project_info() {
    # Try to get repository info from GitHub CLI first
    if gh_command_exists "gh" && gh auth status &> /dev/null; then
        PROJECT_REPO=$(gh repo view --json nameWithOwner --jq '.nameWithOwner' 2>/dev/null || echo "")
        
        if [ -n "$PROJECT_REPO" ]; then
            PROJECT_OWNER=$(echo "$PROJECT_REPO" | cut -d'/' -f1)
            PROJECT_NAME=$(echo "$PROJECT_REPO" | cut -d'/' -f2)
            PROJECT_DESCRIPTION=$(gh repo view --json description --jq '.description' 2>/dev/null || echo "")
            return 0
        fi
    fi
    
    # Fallback: parse git remote URL
    local remote_url=$(git remote get-url origin 2>/dev/null || echo "")
    if [ -n "$remote_url" ]; then
        # Extract owner/repo from various git URL formats
        # SSH: git@github.com:owner/repo.git
        # HTTPS: https://github.com/owner/repo.git
        PROJECT_REPO=$(echo "$remote_url" | sed -E 's/.*[:/]([^/]+\/[^/]+)(\.git)?$/\1/' | sed 's/\.git$//')
        
        if [ -n "$PROJECT_REPO" ]; then
            PROJECT_OWNER=$(echo "$PROJECT_REPO" | cut -d'/' -f1)
            PROJECT_NAME=$(echo "$PROJECT_REPO" | cut -d'/' -f2)
            return 0
        fi
    fi
    
    # If all else fails, try to get just the repo name from directory
    PROJECT_NAME=$(basename "$(git rev-parse --show-toplevel 2>/dev/null || pwd)")
    return 1
}

# ============================================================================
# GITHUB AUTHENTICATION AND REPOSITORY VALIDATION
# ============================================================================

# Check GitHub CLI authentication
gh_check_authentication() {
    gh_print_section "🔐 GitHub Authentication Check"
    
    if ! gh auth status &> /dev/null; then
        gh_print_status "ERROR" "Not authenticated with GitHub"
        echo -e "${GH_YELLOW}💡 Please authenticate with GitHub:${GH_NC}"
        echo "   gh auth login"
        echo ""
        echo "For more information: https://cli.github.com/manual/gh_auth_login"
        return 1
    fi
    
    local auth_info=$(gh auth status --show-token 2>/dev/null | head -1)
    gh_print_status "SUCCESS" "Authenticated with GitHub"
    echo -e "${GH_BLUE}   $auth_info${GH_NC}"
    return 0
}

# Validate repository context
gh_validate_repository() {
    gh_print_section "📁 Repository Validation"
    
    # Check if we're in a Git repository
    if ! git rev-parse --git-dir >/dev/null 2>&1; then
        gh_print_status "ERROR" "Not in a Git repository"
        return 1
    fi
    
    # Auto-detect project information
    if ! gh_detect_project_info; then
        gh_print_status "WARNING" "Could not fully detect project information"
        echo -e "${GH_YELLOW}💡 Some features may be limited${GH_NC}"
    fi
    
    if [ -z "$PROJECT_REPO" ]; then
        gh_print_status "WARNING" "Cannot determine repository information from GitHub"
        echo -e "${GH_YELLOW}   Project Name: ${PROJECT_NAME:-unknown}${GH_NC}"
        echo -e "${GH_YELLOW}💡 Make sure you have a git remote configured${GH_NC}"
        return 1
    fi
    
    gh_print_status "SUCCESS" "Repository validated: $PROJECT_REPO"
    return 0
}

# ============================================================================
# GITHUB API OPERATIONS
# ============================================================================

# Execute GitHub API command with error handling
gh_api_safe() {
    local cmd="$1"
    local operation="$2"
    local exit_on_error="${3:-true}"
    
    gh_print_status "INFO" "Executing: $operation..."
    
    if eval "$cmd" >/dev/null 2>&1; then
        gh_print_status "SUCCESS" "$operation completed successfully"
        return 0
    else
        local exit_code=$?
        gh_print_status "ERROR" "$operation failed (exit code: $exit_code)"
        
        # Provide specific error guidance based on operation type
        case "$cmd" in
            *"permissions"*)
                echo -e "${GH_YELLOW}💡 Possible causes:${GH_NC}"
                echo "   - Insufficient repository permissions"
                echo "   - Repository not found or inaccessible"
                echo "   - GitHub API rate limiting"
                ;;
            *"secrets"*)
                echo -e "${GH_YELLOW}💡 Possible causes:${GH_NC}"
                echo "   - Repository secrets permissions"
                echo "   - Invalid secret name or value"
                echo "   - GitHub API authentication issues"
                ;;
            *"environments"*)
                echo -e "${GH_YELLOW}💡 Possible causes:${GH_NC}"
                echo "   - Environment already exists"
                echo "   - Invalid environment configuration"
                echo "   - Repository settings restrictions"
                ;;
        esac
        
        if [ "$exit_on_error" = "true" ]; then
            gh_print_status "ERROR" "Aborting due to GitHub API operation failure"
            exit $exit_code
        fi
        
        return $exit_code
    fi
}

# ============================================================================
# UTILITY FUNCTIONS
# ============================================================================

# Get current Git branch
gh_get_current_branch() {
    git branch --show-current 2>/dev/null || echo ""
}

# Check if current directory is a Git repository
gh_is_git_repo() {
    git rev-parse --git-dir >/dev/null 2>&1
}

# Get project root directory
gh_get_project_root() {
    git rev-parse --show-toplevel 2>/dev/null || pwd
}

# Check if branch exists
gh_branch_exists() {
    local branch=$1
    git show-ref --verify --quiet "refs/heads/$branch"
}

# Check if remote branch exists
gh_remote_branch_exists() {
    local branch=$1
    git show-ref --verify --quiet "refs/remotes/origin/$branch"
}

# Check if branch is protected
gh_is_protected_branch() {
    local branch=$1
    for protected in "${GH_PROTECTED_BRANCHES[@]}"; do
        if [ "$branch" = "$protected" ]; then
            return 0
        fi
    done
    return 1
}

# Check if branch follows naming convention
gh_is_valid_branch_name() {
    local branch=$1
    for prefix in "${GH_BRANCH_PREFIXES[@]}"; do
        if [[ "$branch" =~ ^$prefix ]]; then
            return 0
        fi
    done
    return 1
}

# Generate secure random value
gh_generate_secret() {
    local length=${1:-32}
    if gh_command_exists "openssl"; then
        openssl rand -base64 "$length"
    else
        # Fallback to /dev/urandom
        head -c "$length" /dev/urandom | base64 | tr -d '\n'
    fi
}

# ============================================================================
# CONFIGURATION MANAGEMENT
# ============================================================================

# Load configuration from a specific file
gh_load_config_file() {
    local config_file="$1"
    
    if [ -f "$config_file" ]; then
        # Source the config file safely
        while IFS='=' read -r key value; do
            # Skip comments and empty lines
            [[ $key =~ ^[[:space:]]*# ]] && continue
            [[ -z $key ]] && continue
            
            # Remove quotes from value
            value=$(echo "$value" | sed 's/^["'\'']//' | sed 's/["'\'']$//')
            
            case $key in
                "MAIN_BRANCH") GH_MAIN_BRANCH="$value" ;;
                "DEVELOP_BRANCH") GH_DEVELOP_BRANCH="$value" ;;
                "PROTECTED_BRANCHES") IFS=',' read -ra GH_PROTECTED_BRANCHES <<< "$value" ;;
                "BRANCH_PREFIXES") IFS=',' read -ra GH_BRANCH_PREFIXES <<< "$value" ;;
            esac
        done < "$config_file"
        return 0
    fi
    return 1
}

# Load configuration from file if it exists (global then project-specific)
gh_load_config() {
    # Load global config first
    gh_load_config_file "$CONFIG_FILE_GLOBAL"
    
    # Load project-specific config (overrides global)
    gh_load_config_file "$CONFIG_FILE_PROJECT"
}

# Create default configuration file
gh_create_default_config() {
    local config_type="${1:-global}"  # global or project
    local config_file
    
    if [ "$config_type" = "project" ]; then
        config_file="$CONFIG_FILE_PROJECT"
    else
        config_file="$CONFIG_FILE_GLOBAL"
        # Ensure directory exists for global config
        mkdir -p "$(dirname "$config_file")"
    fi
    
    cat > "$config_file" << EOF
# Dev Toolkit - GitHub Integration Configuration
# Customize your GitHub integration settings here

# Main branches
MAIN_BRANCH=main
DEVELOP_BRANCH=develop

# Protected branches (comma-separated)
PROTECTED_BRANCHES=main,develop

# Valid branch prefixes (comma-separated)
BRANCH_PREFIXES=feat/,fix/,chore/,hotfix/,feature/

# You can also set these as environment variables:
# export GITHUB_MAIN_BRANCH=main
# export GITHUB_DEVELOP_BRANCH=develop
# export GITHUB_PROTECTED_BRANCHES=main,develop
# export GITHUB_BRANCH_PREFIXES=feat/,fix/,chore/,hotfix/,feature/
EOF
    
    gh_print_status "SUCCESS" "Created default configuration: $config_file"
}

# Show current configuration
gh_show_config() {
    gh_print_header "🔧 GitHub Integration Configuration"
    echo ""
    
    # Auto-detect project info if not already set
    if [ -z "$PROJECT_REPO" ]; then
        gh_detect_project_info
    fi
    
    echo -e "${GH_CYAN}Project:${GH_NC} ${PROJECT_NAME:-not detected}"
    echo -e "${GH_CYAN}Repository:${GH_NC} ${PROJECT_REPO:-not detected}"
    echo -e "${GH_CYAN}Main Branch:${GH_NC} $GH_MAIN_BRANCH"
    echo -e "${GH_CYAN}Develop Branch:${GH_NC} $GH_DEVELOP_BRANCH"
    echo -e "${GH_CYAN}Protected Branches:${GH_NC} ${GH_PROTECTED_BRANCHES[*]}"
    echo -e "${GH_CYAN}Branch Prefixes:${GH_NC} ${GH_BRANCH_PREFIXES[*]}"
    echo ""
    echo -e "${GH_YELLOW}Configuration Sources (in priority order):${GH_NC}"
    echo "  1. Environment variables (highest priority)"
    echo "  2. Project config: $CONFIG_FILE_PROJECT"
    echo "  3. Global config: $CONFIG_FILE_GLOBAL"
    echo "  4. Built-in defaults (lowest priority)"
    echo ""
    
    if [ -f "$CONFIG_FILE_PROJECT" ]; then
        echo -e "${GH_GREEN}✅ Project config exists${GH_NC}"
    else
        echo -e "${GH_YELLOW}⚠️  No project config found${GH_NC}"
    fi
    
    if [ -f "$CONFIG_FILE_GLOBAL" ]; then
        echo -e "${GH_GREEN}✅ Global config exists${GH_NC}"
    else
        echo -e "${GH_YELLOW}⚠️  No global config found${GH_NC}"
        echo -e "${GH_YELLOW}💡 Run with 'global' argument to create global config${GH_NC}"
    fi
}

# ============================================================================
# INITIALIZATION
# ============================================================================

# Initialize GitHub utilities
gh_init_github_utils() {
    # Load configuration
    gh_load_config
    
    # Verify we're in a Git repository
    if ! gh_is_git_repo; then
        gh_print_status "ERROR" "Not in a Git repository"
        return 1
    fi
    
    # Auto-detect project information
    gh_detect_project_info
    
    return 0
}

# Export functions and variables for use by other scripts
export -f gh_print_status gh_print_section gh_print_header
export -f gh_command_exists gh_check_dependencies
export -f gh_check_authentication gh_validate_repository
export -f gh_detect_project_info gh_load_config gh_load_config_file
export -f gh_get_current_branch gh_is_git_repo gh_get_project_root
export -f gh_branch_exists gh_remote_branch_exists
export -f gh_is_protected_branch gh_is_valid_branch_name
export -f gh_generate_secret gh_show_config gh_create_default_config
export -f gh_api_safe gh_init_github_utils

export GH_RED GH_GREEN GH_YELLOW GH_BLUE GH_PURPLE GH_CYAN GH_BOLD GH_NC
export GH_MAIN_BRANCH GH_DEVELOP_BRANCH GH_PROTECTED_BRANCHES GH_BRANCH_PREFIXES
export PROJECT_NAME PROJECT_OWNER PROJECT_REPO PROJECT_DESCRIPTION
export CONFIG_FILE_PROJECT CONFIG_FILE_GLOBAL
