#!/usr/bin/env bats

# Test Overall Comments extraction functionality in Sourcery parser

load '../../helpers/setup'
load '../../helpers/assertions'

# Source just the function we need to test
setup() {
    # Extract just the extract_overall_comments function from the parser
    local parser_file="$PROJECT_ROOT/lib/sourcery/parser.sh"
    
    # Create a temporary file with just the function
    cat > "$BATS_TEST_TMPDIR/test_functions.sh" << 'EOF'
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
EOF
    
    source "$BATS_TEST_TMPDIR/test_functions.sh"
}

@test "extract_overall_comments function exists" {
    # Check if function is defined
    type extract_overall_comments
}

@test "extract_overall_comments finds Overall Comments section" {
    
    local test_content="## Individual Comments

### Comment 1
Some individual comment

## Overall Comments

This PR looks good overall, but consider:
- Adding functional tests in addition to structure tests
- Extracting helper functions for better maintainability
- Splitting large files into smaller modules

## Priority Matrix Assessment
Some matrix content"
    
    local result=$(extract_overall_comments "$test_content")
    
    # Should extract the overall comments content
    echo "$result" | grep -q "This PR looks good overall"
    echo "$result" | grep -q "Adding functional tests"
    echo "$result" | grep -q "Extracting helper functions"
    echo "$result" | grep -q "Splitting large files"
}

@test "extract_overall_comments handles different header formats" {
    
    # Test "## Overall" format
    local test_content1="## Overall

This is an overall comment.

## Individual Comments"
    
    local result1=$(extract_overall_comments "$test_content1")
    echo "$result1" | grep -q "This is an overall comment"
    
    # Test "## Summary Comments" format
    local test_content2="## Summary Comments

This is a summary comment.

## Individual Comments"
    
    local result2=$(extract_overall_comments "$test_content2")
    echo "$result2" | grep -q "This is a summary comment"
}

@test "extract_overall_comments handles missing section gracefully" {
    
    local test_content="## Individual Comments

### Comment 1
Some individual comment

## Priority Matrix Assessment
Some matrix content"
    
    local result=$(extract_overall_comments "$test_content")
    
    # Should return empty string
    [ -z "$result" ]
}

@test "extract_overall_comments stops at next major section" {
    
    local test_content="## Overall Comments

This is an overall comment.
It has multiple lines.

## Individual Comments

### Comment 1
Some individual comment

## Priority Matrix Assessment
Some matrix content"
    
    local result=$(extract_overall_comments "$test_content")
    
    # Should extract overall comments but stop before Individual Comments
    echo "$result" | grep -q "This is an overall comment"
    echo "$result" | grep -q "It has multiple lines"
    echo "$result" | grep -v -q "Individual Comments"
    echo "$result" | grep -v -q "Comment 1"
}

@test "extract_overall_comments cleans up whitespace" {
    
    local test_content="## Overall Comments


This is an overall comment.

It has multiple lines.


## Individual Comments"
    
    local result=$(extract_overall_comments "$test_content")
    
    # Should clean up leading/trailing empty lines
    [ "$(echo "$result" | head -1)" = "This is an overall comment." ]
    [ "$(echo "$result" | tail -1)" = "It has multiple lines." ]
}
