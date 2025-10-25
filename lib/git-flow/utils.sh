#!/bin/bash

# Git Flow Utilities - Shared functions and configurations
# Centralized utilities to avoid code duplication across Git Flow scripts
# Part of Dev Toolkit - portable, project-agnostic version

# ============================================================================
# COLOR DEFINITIONS
# ============================================================================

# Colors for output (only if terminal supports it)
if [[ -t 1 ]] && command -v tput >/dev/null 2>&1; then
    GF_RED='\033[0;31m'
    GF_GREEN='\033[0;32m'
    GF_YELLOW='\033[1;33m'
    GF_BLUE='\033[0;34m'
    GF_PURPLE='\033[0;35m'
    GF_CYAN='\033[0;36m'
    GF_BOLD='\033[1m'
    GF_NC='\033[0m' # No Color
else
    GF_RED=''
    GF_GREEN=''
    GF_YELLOW=''
    GF_BLUE=''
    GF_PURPLE=''
    GF_CYAN=''
    GF_BOLD=''
    GF_NC=''
fi

# ============================================================================
# CONFIGURATION
# ============================================================================

# Default configuration (can be overridden by environment variables or config file)
DEFAULT_MAIN_BRANCH="main"
DEFAULT_DEVELOP_BRANCH="develop"
DEFAULT_PROTECTED_BRANCHES=("main" "develop" "master")
DEFAULT_BRANCH_PREFIXES=("feat/" "fix/" "chore/" "hotfix/")

# Load configuration from environment variables or use defaults
GF_MAIN_BRANCH="${GIT_FLOW_MAIN_BRANCH:-${DEFAULT_MAIN_BRANCH}}"
GF_DEVELOP_BRANCH="${GIT_FLOW_DEVELOP_BRANCH:-${DEFAULT_DEVELOP_BRANCH}}"

# Load protected branches from env var (comma-separated) or use defaults
if [ -n "${GIT_FLOW_PROTECTED_BRANCHES:-}" ]; then
    IFS=',' read -ra GF_PROTECTED_BRANCHES <<< "$GIT_FLOW_PROTECTED_BRANCHES"
else
    GF_PROTECTED_BRANCHES=("${DEFAULT_PROTECTED_BRANCHES[@]}")
fi

# Load branch prefixes from env var (comma-separated) or use defaults
if [ -n "${GIT_FLOW_BRANCH_PREFIXES:-}" ]; then
    IFS=',' read -ra GF_BRANCH_PREFIXES <<< "$GIT_FLOW_BRANCH_PREFIXES"
else
    GF_BRANCH_PREFIXES=("${DEFAULT_BRANCH_PREFIXES[@]}")
fi

# Configuration file paths (project-specific takes precedence)
CONFIG_FILE_PROJECT=".dev-toolkit.conf"
CONFIG_FILE_GLOBAL="${GIT_FLOW_CONFIG_FILE:-$HOME/.dev-toolkit/config.conf}"

# ============================================================================
# CONFIGURATION LOADING
# ============================================================================

# Load configuration from a specific file
gf_load_config_file() {
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
                "MAIN_BRANCH") GF_MAIN_BRANCH="$value" ;;
                "DEVELOP_BRANCH") GF_DEVELOP_BRANCH="$value" ;;
                "PROTECTED_BRANCHES") IFS=',' read -ra GF_PROTECTED_BRANCHES <<< "$value" ;;
                "BRANCH_PREFIXES") IFS=',' read -ra GF_BRANCH_PREFIXES <<< "$value" ;;
            esac
        done < "$config_file"
        return 0
    fi
    return 1
}

# Load configuration from file if it exists (global then project-specific)
gf_load_config() {
    # Load global config first
    gf_load_config_file "$CONFIG_FILE_GLOBAL"
    
    # Load project-specific config (overrides global)
    gf_load_config_file "$CONFIG_FILE_PROJECT"
}

# ============================================================================
# STATUS PRINTING FUNCTIONS
# ============================================================================

# Function to print colored status messages
gf_print_status() {
    local msg_type=$1
    local message=$2
    case $msg_type in
        "ERROR")   echo -e "${GF_RED}❌ $message${GF_NC}" ;;
        "WARNING") echo -e "${GF_YELLOW}⚠️  $message${GF_NC}" ;;
        "SUCCESS") echo -e "${GF_GREEN}✅ $message${GF_NC}" ;;
        "INFO")    echo -e "${GF_BLUE}ℹ️  $message${GF_NC}" ;;
        "HEADER")  echo -e "${GF_BOLD}${GF_CYAN}$message${GF_NC}" ;;
        "SECTION") echo -e "${GF_BOLD}${GF_CYAN}$message${GF_NC}" ;;
    esac
}

# Function to print section headers
gf_print_section() {
    local title=$1
    echo -e "${GF_BOLD}${GF_CYAN}$title${GF_NC}"
}

# Function to print main headers
gf_print_header() {
    local title=$1
    echo -e "${GF_BOLD}${GF_CYAN}$title${GF_NC}"
    echo -e "${GF_CYAN}$(printf '═%.0s' $(seq 1 ${#title}))${GF_NC}"
}

# ============================================================================
# DEPENDENCY CHECKING
# ============================================================================

# Required dependencies for Git Flow operations
REQUIRED_DEPS=("git")
OPTIONAL_DEPS=("gh" "jq" "curl")

# Check if a command exists
gf_command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check required dependencies
gf_check_required_dependencies() {
    local missing_deps=()
    
    for dep in "${REQUIRED_DEPS[@]}"; do
        if ! gf_command_exists "$dep"; then
            missing_deps+=("$dep")
        fi
    done
    
    if [ ${#missing_deps[@]} -gt 0 ]; then
        gf_print_status "ERROR" "Missing required dependencies: ${missing_deps[*]}"
        echo -e "${GF_YELLOW}💡 Please install the missing dependencies:${GF_NC}"
        for dep in "${missing_deps[@]}"; do
            case $dep in
                "git") echo "   - Git: https://git-scm.com/downloads" ;;
                *) echo "   - $dep" ;;
            esac
        done
        return 1
    fi
    
    return 0
}

# Check optional dependencies and warn if missing
gf_check_optional_dependencies() {
    local missing_optional=()
    
    for dep in "${OPTIONAL_DEPS[@]}"; do
        if ! gf_command_exists "$dep"; then
            missing_optional+=("$dep")
        fi
    done
    
    if [ ${#missing_optional[@]} -gt 0 ]; then
        gf_print_status "WARNING" "Optional dependencies not found: ${missing_optional[*]}"
        echo -e "${GF_YELLOW}💡 Some features may be limited. Consider installing:${GF_NC}"
        for dep in "${missing_optional[@]}"; do
            case $dep in
                "gh") echo "   - GitHub CLI: https://cli.github.com/" ;;
                "jq") echo "   - jq: https://stedolan.github.io/jq/" ;;
                "curl") echo "   - curl: Usually pre-installed on most systems" ;;
                *) echo "   - $dep" ;;
            esac
        done
        echo ""
    fi
}

# Comprehensive dependency check
gf_check_dependencies() {
    gf_print_section "🔍 Dependency Check"
    
    if ! gf_check_required_dependencies; then
        return 1
    fi
    
    gf_check_optional_dependencies
    
    gf_print_status "SUCCESS" "All required dependencies available"
    return 0
}

# Check if jq is installed (for GitHub API batching)
# Usage: gf_check_jq [error|warning]
# Returns: 0 if jq is available, 1 if not
gf_check_jq() {
    local msg_type="${1:-error}"  # error or warning
    
    if ! gf_command_exists "jq"; then
        if [ "$msg_type" = "error" ]; then
            gf_print_status "ERROR" "jq is required for GitHub API operations"
            echo ""
            echo -e "${GF_CYAN}Install jq:${GF_NC}"
            echo "  macOS:   brew install jq"
            echo "  Linux:   apt-get install jq"
            echo "  Windows: choco install jq"
            echo ""
            echo "More info: https://stedolan.github.io/jq/"
            return 1
        elif [ "$msg_type" = "warning" ]; then
            gf_print_status "WARNING" "jq not found, using slower individual API calls"
            return 1
        fi
    fi
    return 0
}

# ============================================================================
# GIT ERROR HANDLING
# ============================================================================
#
# Verbose/Debug Mode:
#   Set GF_VERBOSE=true or GF_DEBUG=true to enable detailed output
#   
#   Examples:
#     export GF_VERBOSE=true
#     ./scripts/workflow-helper.sh push
#     
#     GF_DEBUG=true ./lib/git-flow/safety.sh check
#
# In verbose mode:
#   - Shows actual Git commands being executed
#   - Displays real-time command output
#   - Provides detailed error information
#

# Execute git command with error handling
gf_git_safe() {
    local cmd="$1"
    local operation="$2"
    local exit_on_error="${3:-true}"
    local verbose="${GF_VERBOSE:-${GF_DEBUG:-false}}"
    
    gf_print_status "INFO" "Executing: $operation..."
    
    # Show command being executed in verbose mode
    if [ "$verbose" = "true" ]; then
        echo -e "${GF_CYAN}🔍 Command: $cmd${GF_NC}" >&2
    fi
    
    local output_file
    local error_output=""
    
    local exit_code=0
    
    if [ "$verbose" = "true" ]; then
        # In verbose mode, show output in real-time
        if ! eval "$cmd" 2>&1; then
            exit_code=$?
        fi
    else
        # In quiet mode, capture output for error reporting
        output_file=$(mktemp)
        if ! eval "$cmd" >"$output_file" 2>&1; then
            exit_code=$?
            error_output=$(cat "$output_file" 2>/dev/null || echo "No error output available")
        fi
        rm -f "$output_file"
    fi
    
    if [ $exit_code -eq 0 ]; then
        gf_print_status "SUCCESS" "$operation completed successfully"
        return 0
    fi
    
    # Handle error case
    gf_print_status "ERROR" "$operation failed (exit code: $exit_code)"
    
    # Show captured error output in quiet mode
    if [ "$verbose" != "true" ] && [ -n "$error_output" ]; then
        echo -e "${GF_YELLOW}📋 Error Output:${GF_NC}" >&2
        echo "$error_output" | sed 's/^/   /' >&2
        echo "" >&2
    fi
    
    # Provide specific error guidance based on command type
    case "$cmd" in
        *"fetch"*|*"pull"*)
            echo -e "${GF_YELLOW}💡 Possible causes:${GF_NC}"
            echo "   - Network connectivity issues"
            echo "   - Authentication failure (check SSH keys or tokens)"
            echo "   - Remote repository unavailable"
            echo "   - Firewall or proxy blocking Git operations"
            ;;
        *"push"*)
            echo -e "${GF_YELLOW}💡 Possible causes:${GF_NC}"
            echo "   - Authentication failure (check push permissions)"
            echo "   - Branch protection rules preventing push"
            echo "   - Network connectivity issues"
            echo "   - Repository quota exceeded"
            ;;
        *"checkout"*|*"merge"*|*"rebase"*)
            echo -e "${GF_YELLOW}💡 Possible causes:${GF_NC}"
            echo "   - Uncommitted changes blocking operation"
            echo "   - Merge conflicts need resolution"
            echo "   - Branch does not exist"
            echo "   - Working directory not clean"
            ;;
    esac
    
    if [ "$exit_on_error" = "true" ]; then
        gf_print_status "ERROR" "Aborting due to Git operation failure"
        exit $exit_code
    fi
    
    return $exit_code
}

# Safe git fetch with comprehensive error handling
gf_git_fetch() {
    local remote="${1:-origin}"
    local branch="${2:-}"
    local fetch_cmd="git fetch --prune $remote"
    
    if [ -n "$branch" ]; then
        fetch_cmd="$fetch_cmd $branch"
    fi
    
    gf_git_safe "$fetch_cmd" "Fetching from $remote" true
}

# Safe git pull with error handling
gf_git_pull() {
    local remote="${1:-origin}"
    local branch="${2:-$(gf_get_current_branch)}"
    
    gf_git_safe "git pull $remote $branch" "Pulling $branch from $remote" true
}

# Safe git push with error handling
gf_git_push() {
    local remote="${1:-origin}"
    local branch="${2:-$(gf_get_current_branch)}"
    local force="${3:-false}"
    
    local push_cmd="git push $remote $branch"
    if [ "$force" = "true" ]; then
        push_cmd="$push_cmd --force-with-lease"
    fi
    
    gf_git_safe "$push_cmd" "Pushing $branch to $remote" true
}

# Safe git checkout with error handling
gf_git_checkout() {
    local target="$1"
    local create_new="${2:-false}"
    
    local checkout_cmd="git checkout"
    if [ "$create_new" = "true" ]; then
        checkout_cmd="$checkout_cmd -b"
    fi
    checkout_cmd="$checkout_cmd $target"
    
    gf_git_safe "$checkout_cmd" "Checking out $target" true
}

# Safe git merge with error handling
gf_git_merge() {
    local branch="$1"
    local no_ff="${2:-false}"
    
    local merge_cmd="git merge"
    if [ "$no_ff" = "true" ]; then
        merge_cmd="$merge_cmd --no-ff"
    fi
    merge_cmd="$merge_cmd $branch"
    
    gf_git_safe "$merge_cmd" "Merging $branch" true
}

# Check network connectivity to Git remote
gf_check_git_connectivity() {
    local remote="${1:-origin}"
    
    gf_print_status "INFO" "Checking connectivity to $remote..."
    
    if git ls-remote --heads "$remote" >/dev/null 2>&1; then
        gf_print_status "SUCCESS" "Git remote $remote is accessible"
        return 0
    else
        gf_print_status "ERROR" "Cannot connect to Git remote $remote"
        echo -e "${GF_YELLOW}💡 Troubleshooting steps:${GF_NC}"
        echo "   1. Check network connection: ping github.com"
        echo "   2. Verify SSH key: ssh -T git@github.com"
        echo "   3. Check repository URL: git remote -v"
        echo "   4. Try HTTPS instead of SSH or vice versa"
        return 1
    fi
}

# ============================================================================
# UTILITY FUNCTIONS
# ============================================================================

# Get current Git branch
gf_get_current_branch() {
    git branch --show-current 2>/dev/null || echo ""
}

# Check if current directory is a Git repository
gf_is_git_repo() {
    git rev-parse --git-dir >/dev/null 2>&1
}

# Get project root directory
gf_get_project_root() {
    git rev-parse --show-toplevel 2>/dev/null || pwd
}

# Check if branch exists
gf_branch_exists() {
    local branch=$1
    git show-ref --verify --quiet "refs/heads/$branch"
}

# Check if remote branch exists
gf_remote_branch_exists() {
    local branch=$1
    git show-ref --verify --quiet "refs/remotes/origin/$branch"
}

# Check if branch is protected
gf_is_protected_branch() {
    local branch=$1
    for protected in "${GF_PROTECTED_BRANCHES[@]}"; do
        if [ "$branch" = "$protected" ]; then
            return 0
        fi
    done
    return 1
}

# Check if branch follows naming convention
gf_is_valid_branch_name() {
    local branch=$1
    for prefix in "${GF_BRANCH_PREFIXES[@]}"; do
        if [[ "$branch" =~ ^$prefix ]]; then
            return 0
        fi
    done
    return 1
}

# ============================================================================
# CONFIGURATION MANAGEMENT
# ============================================================================

# Create default configuration file
gf_create_default_config() {
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
# Dev Toolkit - Git Flow Configuration
# Customize your Git Flow settings here

# Main branches
MAIN_BRANCH=main
DEVELOP_BRANCH=develop

# Protected branches (comma-separated)
PROTECTED_BRANCHES=main,develop,master

# Valid branch prefixes (comma-separated)
BRANCH_PREFIXES=feat/,fix/,chore/,hotfix/

# You can also set these as environment variables:
# export GIT_FLOW_MAIN_BRANCH=main
# export GIT_FLOW_DEVELOP_BRANCH=develop
# export GIT_FLOW_PROTECTED_BRANCHES=main,develop
# export GIT_FLOW_BRANCH_PREFIXES=feat/,fix/,chore/,hotfix/
EOF
    
    gf_print_status "SUCCESS" "Created default configuration: $config_file"
}

# Show current configuration
gf_show_config() {
    gf_print_header "🔧 Git Flow Configuration"
    echo ""
    echo -e "${GF_CYAN}Main Branch:${GF_NC} $GF_MAIN_BRANCH"
    echo -e "${GF_CYAN}Develop Branch:${GF_NC} $GF_DEVELOP_BRANCH"
    echo -e "${GF_CYAN}Protected Branches:${GF_NC} ${GF_PROTECTED_BRANCHES[*]}"
    echo -e "${GF_CYAN}Branch Prefixes:${GF_NC} ${GF_BRANCH_PREFIXES[*]}"
    echo ""
    echo -e "${GF_YELLOW}Configuration Sources (in priority order):${GF_NC}"
    echo "  1. Environment variables (highest priority)"
    echo "  2. Project config: $CONFIG_FILE_PROJECT"
    echo "  3. Global config: $CONFIG_FILE_GLOBAL"
    echo "  4. Built-in defaults (lowest priority)"
    echo ""
    
    if [ -f "$CONFIG_FILE_PROJECT" ]; then
        echo -e "${GF_GREEN}✅ Project config exists${GF_NC}"
    else
        echo -e "${GF_YELLOW}⚠️  No project config found${GF_NC}"
    fi
    
    if [ -f "$CONFIG_FILE_GLOBAL" ]; then
        echo -e "${GF_GREEN}✅ Global config exists${GF_NC}"
    else
        echo -e "${GF_YELLOW}⚠️  No global config found${GF_NC}"
        echo -e "${GF_YELLOW}💡 Run with 'global' argument to create global config${GF_NC}"
    fi
}

# ============================================================================
# INITIALIZATION
# ============================================================================

# Initialize Git Flow utilities
gf_init_git_flow_utils() {
    # Load configuration
    gf_load_config
    
    # Verify we're in a Git repository
    if ! gf_is_git_repo; then
        gf_print_status "ERROR" "Not in a Git repository"
        return 1
    fi
    
    return 0
}

# Export functions and variables for use by other scripts
export -f gf_print_status gf_print_section gf_print_header
export -f gf_command_exists gf_check_dependencies gf_check_jq
export -f gf_load_config gf_load_config_file
export -f gf_get_current_branch gf_is_git_repo gf_get_project_root
export -f gf_branch_exists gf_remote_branch_exists
export -f gf_is_protected_branch gf_is_valid_branch_name
export -f gf_show_config gf_create_default_config
export -f gf_git_safe gf_git_fetch gf_git_pull gf_git_push
export -f gf_git_checkout gf_git_merge gf_check_git_connectivity
export -f gf_init_git_flow_utils

export GF_RED GF_GREEN GF_YELLOW GF_BLUE GF_PURPLE GF_CYAN GF_BOLD GF_NC
export GF_MAIN_BRANCH GF_DEVELOP_BRANCH GF_PROTECTED_BRANCHES GF_BRANCH_PREFIXES
export CONFIG_FILE_PROJECT CONFIG_FILE_GLOBAL
