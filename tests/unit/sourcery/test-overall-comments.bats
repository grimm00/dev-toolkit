#!/usr/bin/env bats

# Test Overall Comments extraction functionality in Sourcery parser

load '../test-helpers'

@test "extract_overall_comments function exists" {
    source "$TOOLKIT_ROOT/lib/sourcery/parser.sh"
    
    # Check if function is defined
    type extract_overall_comments
}

@test "extract_overall_comments finds Overall Comments section" {
    source "$TOOLKIT_ROOT/lib/sourcery/parser.sh"
    
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
    source "$TOOLKIT_ROOT/lib/sourcery/parser.sh"
    
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
    source "$TOOLKIT_ROOT/lib/sourcery/parser.sh"
    
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
    source "$TOOLKIT_ROOT/lib/sourcery/parser.sh"
    
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
    source "$TOOLKIT_ROOT/lib/sourcery/parser.sh"
    
    local test_content="## Overall Comments


This is an overall comment.

It has multiple lines.


## Individual Comments"
    
    local result=$(extract_overall_comments "$test_content")
    
    # Should clean up leading/trailing empty lines
    [ "$(echo "$result" | head -1)" = "This is an overall comment." ]
    [ "$(echo "$result" | tail -1)" = "It has multiple lines." ]
}
