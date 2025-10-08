#!/bin/bash

# Sourcery Review Parser for Dev Toolkit
# Extracts and formats Sourcery reviews for manual priority matrix assessment
# Portable, project-agnostic version that works across any repository

# Detect toolkit installation location
if [ -n "${DT_ROOT:-}" ]; then
    TOOLKIT_ROOT="$DT_ROOT"
elif [ -f "$HOME/.dev-toolkit/lib/core/github-utils.sh" ]; then
    TOOLKIT_ROOT="$HOME/.dev-toolkit"
elif [ -f "$(dirname "${BASH_SOURCE[0]}")/../core/github-utils.sh" ]; then
    # Running from within toolkit directory
    TOOLKIT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
else
    echo "❌ Error: Cannot locate dev-toolkit installation"
    echo "💡 Set DT_ROOT environment variable or install to ~/.dev-toolkit"
    exit 1
fi

# Source shared utilities
if [ -f "$TOOLKIT_ROOT/lib/core/github-utils.sh" ]; then
    source "$TOOLKIT_ROOT/lib/core/github-utils.sh"
else
    echo "❌ Error: github-utils.sh not found at $TOOLKIT_ROOT/lib/core/github-utils.sh"
    echo "💡 Please ensure dev-toolkit is properly installed"
    exit 1
fi

# Initialize GitHub utilities (auto-detects project info)
if ! gh_init_github_utils; then
    exit 1
fi

gh_print_header "📋 Sourcery Review Parser"
echo ""

# ============================================================================
# CONFIGURATION
# ============================================================================

OUTPUT_FILE=""
SHOW_DETAILS=true
THINK_MODE=false
RICH_DETAILS=false

# ============================================================================
# FIXED PARSING FUNCTIONS
# ============================================================================

# Extract Overall Comments section from Sourcery review content
extract_overall_comments() {
    local content="$1"
    local overall_section=""
    local in_overall=false
    
    while IFS= read -r line; do
        # Check for start of Overall Comments section
        if [[ "$line" =~ ^##\ (Overall\ Comments|Overall|Summary\ Comments) ]]; then
            in_overall=true
            continue
        fi
        
        # Check for end of Overall Comments section (next major section)
        if [ "$in_overall" = true ] && [[ "$line" =~ ^##\ [^O] ]] && [[ ! "$line" =~ ^##\ (Overall|Summary) ]]; then
            break
        fi
        
        # Collect content while in Overall Comments section
        if [ "$in_overall" = true ]; then
            if [ -n "$overall_section" ]; then
                overall_section="$overall_section"$'\n'"$line"
            else
                overall_section="$line"
            fi
        fi
    done <<< "$content"
    
    # Clean up the overall section (remove leading/trailing empty lines)
    overall_section=$(echo "$overall_section" | sed '/^$/N;/^\n$/d' | sed '1{/^$/d;}' | sed '$ {/^$/d;}')
    
    echo "$overall_section"
}

# Sanitize a text block: remove control chars and escape HTML for safe embedding
sanitize_block() {
    local in="$1"
    # Remove ASCII control characters except tab/newline, then HTML-escape via python
    local cleaned
    cleaned=$(printf "%s" "$in" | tr -d '\000-\010\013\014\016-\037\177')
    if command -v python3 >/dev/null 2>&1; then
        printf "%s" "$cleaned" | python3 -c 'import sys,html; sys.stdout.write(html.escape(sys.stdin.read()))'
    else
        # Fallback: sed with careful placeholder strategy
        cleaned=$(printf "%s" "$cleaned" | sed -e 's/&/[AMP]/g' -e 's/</[LT]/g' -e 's/>/[GT]/g')
        cleaned=$(printf "%s" "$cleaned" | sed -e 's/\[AMP\]/\&amp;/g' -e 's/\[LT\]/\&lt;/g' -e 's/\[GT\]/\&gt;/g')
        printf "%s" "$cleaned"
    fi
}

extract_sourcery_review() {
    local pr_number="$1"
    
    gh_print_section "📋 Extracting Sourcery Review for PR #$pr_number"
    
    # Get the review data
    local review_data=$(gh pr view "$pr_number" --json reviews --jq '.reviews[] | select(.author.login == "sourcery-ai") | .body' 2>/dev/null)
    
    if [ -z "$review_data" ] || [ "$review_data" = "null" ]; then
        gh_print_status "WARNING" "No Sourcery review found for PR #$pr_number"
        echo ""
        echo -e "${GH_YELLOW}💡 Possible reasons:${GH_NC}"
        echo "   - Sourcery hasn't reviewed yet (wait 1-2 minutes)"
        echo "   - Sourcery is not installed on this repository"
        echo "   - PR has no code changes to review"
        echo ""
        echo -e "${GH_CYAN}${GH_BOLD}💡 Remember: Sourcery is optional!${GH_NC}"
        echo -e "   All core toolkit features work without it:"
        echo -e "   ${GH_GREEN}✅${GH_NC} dt-git-safety, dt-config, dt-install-hooks"
        echo ""
        echo -e "${GH_BLUE}ℹ️  To install Sourcery: ${GH_BOLD}dt-setup-sourcery${GH_NC}"
        echo -e "${GH_BLUE}ℹ️  Learn more: ${GH_BOLD}docs/OPTIONAL-FEATURES.md${GH_NC}"
        return 1
    fi
    
    # Check for rate limit message
    if echo "$review_data" | grep -q "rate limit"; then
        gh_print_status "WARNING" "Sourcery rate limit reached"
        echo ""
        echo -e "${GH_YELLOW}📊 Rate Limit Information:${GH_NC}"
        echo ""
        # Extract and display the rate limit message
        echo "$review_data" | head -10
        echo ""
        echo -e "${GH_CYAN}ℹ️  About Sourcery Rate Limits:${GH_NC}"
        echo "   • Free tier: 500,000 diff characters per week"
        echo "   • Resets weekly"
        echo "   • Upgrade available for unlimited reviews"
        echo ""
        echo -e "${GH_CYAN}💡 What you can still do:${GH_NC}"
        echo "   • View Sourcery comments on GitHub PR page"
        echo "   • See security issues and suggestions inline"
        echo "   • Wait for weekly reset"
        echo "   • Upgrade at: https://sourcery.ai/pricing"
        echo ""
        return 1
    fi
    
    # Check for security issues (different format)
    if echo "$review_data" | grep -q "security issues"; then
        gh_print_status "INFO" "Sourcery found security issues"
        echo ""
        echo -e "${GH_YELLOW}🔒 Security Review Available:${GH_NC}"
        echo ""
        echo "$review_data"
        echo ""
        echo -e "${GH_CYAN}💡 View detailed security issues:${GH_NC}"
        echo "   gh pr view $pr_number --web"
        echo ""
        echo -e "${GH_YELLOW}Note: Security reviews may not include the full markdown format${GH_NC}"
        return 0
    fi
    
    # Extract the markdown code block content
    local markdown_content=$(echo "$review_data" | sed -n '/~~~markdown/,/~~~/p' | sed '1d;$d')
    
    if [ -z "$markdown_content" ]; then
        gh_print_status "WARNING" "No markdown content found in Sourcery review"
        echo ""
        echo -e "${GH_YELLOW}💡 Sourcery may have reviewed in a different format${GH_NC}"
        echo ""
        echo "Review content preview:"
        echo "$review_data" | head -20
        echo ""
        echo -e "${GH_CYAN}View full review:${GH_NC}"
        echo "   gh pr view $pr_number --web"
        return 1
    fi
    
    # Create clean output
    create_clean_output "$markdown_content" "$pr_number"
}

create_clean_output() {
    local content="$1"
    local pr_number="$2"
    
    local output=""
    
    # Header
    output+="# Sourcery Review Analysis\n"
    output+="**PR**: #$pr_number\n"
    output+="**Repository**: $PROJECT_REPO\n"
    output+="**Generated**: $(date)\n\n"
    output+="---\n\n"
    
    # Extract comment count
    local comment_count=$(echo "$content" | grep -c "^### Comment [0-9]")
    local has_overall_comments=""
    if echo "$content" | grep -q "## Overall Comments\|## Overall\|## Summary Comments"; then
        has_overall_comments=" + Overall Comments"
    fi
    
    output+="## Summary\n\n"
    output+="Total Individual Comments: $comment_count$has_overall_comments\n\n"

    if [ "$THINK_MODE" = true ]; then
        output+="### Parsing Notes (Think Mode)\n"
        output+="- We search for individual comments using the header pattern '### Comment N'\n"
        output+="- We also search for Overall Comments sections using patterns '## Overall Comments', '## Overall', or '## Summary Comments'\n"
        output+="- Location is taken from the first '<location>...</location>' tag, then HTML tags and backticks are stripped, and whitespace is trimmed\n"
        output+="- Type is the first bold '**...**' phrase; trailing colons are removed to normalize values like 'suggestion:' -> 'suggestion'\n"
        output+="- Description is the first non-empty, non-bold line between '<issue_to_address>' and the next code fence, with markdown tokens removed\n\n"
    fi
    
    # Check for Overall Comments section first
    local overall_comments=""
    if echo "$content" | grep -q "## Overall Comments\|## Overall\|## Summary Comments"; then
        overall_comments=$(extract_overall_comments "$content")
    fi
    
    # Individual Comments section
    output+="## Individual Comments\n\n"
    
    # Split content by comment headers and process each
    local current_comment=""
    local comment_num=""
    local in_comment=false
    
    while IFS= read -r line; do
        if [[ "$line" =~ ^###\ Comment\ ([0-9]+) ]]; then
            # Process previous comment if exists
            if [ -n "$current_comment" ] && [ -n "$comment_num" ]; then
                output+=$(format_single_comment_fixed "$comment_num" "$current_comment")
            fi
            
            # Start new comment
            comment_num="${BASH_REMATCH[1]}"
            current_comment="$line"
            in_comment=true
        elif [ "$in_comment" = true ]; then
            current_comment="$current_comment"$'\n'"$line"
        fi
    done <<< "$content"
    
    # Process the last comment
    if [ -n "$current_comment" ] && [ -n "$comment_num" ]; then
        output+=$(format_single_comment_fixed "$comment_num" "$current_comment")
    fi
    
    # Add Overall Comments section if found
    if [ -n "$overall_comments" ]; then
        output+="## Overall Comments\n\n"
        output+="$overall_comments\n\n"
    fi

    # Priority Matrix Template
    output+="## Priority Matrix Assessment\n\n"
    output+="Use this template to assess each comment:\n\n"
    output+="| Comment | Priority | Impact | Effort | Notes |\n"
    output+="|---------|----------|--------|--------|-------|\n"
    
    # Add clean rows for each comment
    for i in $(seq 1 $comment_count); do
        output+="| #$i | | | | |\n"
    done
    
    output+="\n### Priority Levels\n"
    output+="- 🔴 **CRITICAL**: Security, stability, or core functionality issues\n"
    output+="- 🟠 **HIGH**: Bug risks or significant maintainability issues\n"
    output+="- 🟡 **MEDIUM**: Code quality and maintainability improvements\n"
    output+="- 🟢 **LOW**: Nice-to-have improvements\n\n"
    
    output+="### Impact Levels\n"
    output+="- 🔴 **CRITICAL**: Affects core functionality\n"
    output+="- 🟠 **HIGH**: User-facing or significant changes\n"
    output+="- 🟡 **MEDIUM**: Developer experience improvements\n"
    output+="- 🟢 **LOW**: Minor improvements\n\n"
    
    output+="### Effort Levels\n"
    output+="- 🟢 **LOW**: Simple, quick changes\n"
    output+="- 🟡 **MEDIUM**: Moderate complexity\n"
    output+="- 🟠 **HIGH**: Complex refactoring\n"
    output+="- 🔴 **VERY_HIGH**: Major rewrites\n\n"
    
    # Output the result
    if [ -n "$OUTPUT_FILE" ]; then
        echo -e "$output" > "$OUTPUT_FILE"
        gh_print_status "SUCCESS" "Review analysis saved to $OUTPUT_FILE"
    else
        echo -e "$output"
    fi
}

format_single_comment_fixed() {
    local comment_num="$1"
    local content="$2"
    
    local output=""
    
    output+="### Comment #$comment_num\n\n"
    
    # Extract location (FIXED - remove all backticks and extra spaces)
    local location=$(echo "$content" | grep -o '<location>.*</location>' | sed 's/<[^>]*>//g' | sed 's/`//g' | sed 's/^ *//;s/ *$//' | head -1)
    if [ -n "$location" ]; then
        output+="**Location**: \`$location\`\n\n"
    fi
    
    # Extract issue type (FIXED - remove trailing colons)
    local issue_type=$(echo "$content" | grep -o '\*\*[^*]*\*\*' | head -1 | sed 's/\*\*//g' | sed 's/:$//')
    if [ -n "$issue_type" ]; then
        output+="**Type**: $issue_type\n\n"
    fi
    
    # Extract description (FIXED - get clean description without markdown)
    local description=$(echo "$content" | sed -n '/<issue_to_address>/,/```/p' | grep -v '<issue_to_address>' | grep -v '^$' | grep -v '^\*\*' | head -1 | sed 's/^ *//;s/ *$//')
    if [ -n "$description" ]; then
        output+="**Description**: $description\n\n"
    fi

    if [ "$THINK_MODE" = true ]; then
        output+="<details>\n<summary>Reasoning (why these values)</summary>\n\n"
        output+="- Location extracted from first <location> tag; tags/backticks stripped; trimmed.\n"
        output+="- Type derived from first bold token; trailing colon removed for normalization.\n"
        output+="- Description chosen as first substantive line within <issue_to_address> block, excluding markdown and empty lines.\n\n"
        output+="</details>\n\n"
    fi
    
    # Add collapsible full content (optional)
    if [ "$SHOW_DETAILS" = true ]; then
        if [ "$RICH_DETAILS" = true ]; then
            # Extract structured sections
            local code_ctx_raw=$(echo "$content" | sed -n '/<code_context>/,/<\/code_context>/p' | sed '1d;$d')
            local issue_text_raw=$(echo "$content" | sed -n '/<issue_to_address>/,/```/p' | sed '1d' | sed '/^```/q' | sed '/^$/d' | sed -n '1p')
            local suggestion_raw=$(echo "$content" | sed -n '/```suggestion/,/```/p' | sed '1d;$d')

            local code_ctx=$(sanitize_block "$code_ctx_raw")
            local issue_text=$(sanitize_block "$issue_text_raw")
            local suggestion=$(sanitize_block "$suggestion_raw")

            output+="<details>\n<summary>Details</summary>\n\n"
            if [ -n "$code_ctx" ]; then
                output+="<b>Code Context</b>\n\n<pre><code>\n$code_ctx\n</code></pre>\n\n"
            fi
            if [ -n "$issue_text" ]; then
                output+="<b>Issue</b>\n\n$issue_text\n\n"
            fi
            if [ -n "$suggestion" ]; then
                output+="<b>Suggestion</b>\n\n<pre><code>\n$suggestion\n</code></pre>\n\n"
            fi
            # Fallback: if nothing extracted, include sanitized raw
            if [ -z "$code_ctx$issue_text$suggestion" ]; then
                local raw_sanitized=$(sanitize_block "$content")
                output+="<pre><code>\n$raw_sanitized\n</code></pre>\n\n"
            fi
            output+="</details>\n\n"
        else
            # Raw details but sanitized and HTML-escaped to avoid markdown collisions
            local raw_sanitized=$(sanitize_block "$content")
            output+="<details>\n<summary>Full Comment Content</summary>\n\n<pre><code>\n$raw_sanitized\n</code></pre>\n\n</details>\n\n"
        fi
    fi
    output+="---\n\n"
    
    echo "$output"
}

# ============================================================================
# MAIN EXECUTION
# ============================================================================

PR_NUMBER=""

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --output|-o)
            OUTPUT_FILE="$2"
            shift 2
            ;;
        --think|--explain|--verbose)
            THINK_MODE=true
            shift 1
            ;;
        --no-details)
            SHOW_DETAILS=false
            shift 1
            ;;
        --rich-details)
            SHOW_DETAILS=true
            RICH_DETAILS=true
            shift 1
            ;;
        --help|-h)
            echo "Usage: $0 [PR_NUMBER] [OPTIONS]"
            echo ""
            echo "Commands:"
            echo "  PR_NUMBER    - Analyze specific PR (default: current user's open PR)"
            echo ""
            echo "Options:"
            echo "  --output FILE      - Save output to file"
            echo "  --think            - Include reasoning about how fields were extracted"
            echo "  --no-details       - Omit verbose \"Full Comment Content\" sections"
            echo "  --rich-details     - Structure details into Code Context and Suggestion blocks"
            echo "  --help             - Show this help message"
            echo ""
            echo "Examples:"
            echo "  $0                    # Parse current user's open PR"
            echo "  $0 123               # Parse PR #123"
            echo "  $0 123 --output review.md         # Save to file"
            echo "  $0 123 --think                    # Show extraction reasoning"
            echo "  $0 123 --no-details               # Compact output"
            echo "  $0 123 --rich-details             # Structured details output"
            exit 0
            ;;
        *)
            if [[ "$1" =~ ^[0-9]+$ ]]; then
                PR_NUMBER="$1"
            else
                echo "❌ Error: Invalid argument '$1'"
                echo "Use --help for usage information"
                exit 1
            fi
            shift
            ;;
    esac
done

# Get PR number if not provided
if [ -z "$PR_NUMBER" ]; then
    PR_NUMBER=$(gh pr list --author "@me" --state open --json number --jq '.[0].number' 2>/dev/null)
    if [ -z "$PR_NUMBER" ] || [ "$PR_NUMBER" = "null" ]; then
        gh_print_status "ERROR" "No open PR found for current user"
        echo "Usage: $0 [PR_NUMBER] [OPTIONS]"
        echo "Use --help for more information"
        exit 1
    fi
fi

# Validate PR number
if ! [[ "$PR_NUMBER" =~ ^[0-9]+$ ]]; then
    gh_print_status "ERROR" "Invalid PR number: $PR_NUMBER"
    exit 1
fi

# Check if PR exists
if ! gh pr view "$PR_NUMBER" >/dev/null 2>&1; then
    gh_print_status "ERROR" "PR #$PR_NUMBER not found"
    exit 1
fi

# Extract and format the Sourcery review
if extract_sourcery_review "$PR_NUMBER"; then
    gh_print_status "SUCCESS" "Sourcery review parsing completed!"
else
    gh_print_status "ERROR" "Failed to parse Sourcery review"
    exit 1
fi
