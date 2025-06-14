#!/usr/bin/env bats

# Load test helper functions
load 'test_helper'

# Load the script to test
load '../core/utils/name_utils.sh'

setup() {
    # Setup runs before each test
    export TEST_TEMP_DIR=$(mktemp -d)
}

teardown() {
    # Cleanup runs after each test
    rm -rf "$TEST_TEMP_DIR"
}

@test "generate_name_permutations creates basic permutations" {
    run generate_name_permutations "John Doe"
    
    # Verify basic name permutations
    assert_output --partial "john"      # Lowercase first name
    assert_output --partial "doe"       # Lowercase last name
    assert_output --partial "John"      # Proper case first name
    assert_output --partial "Doe"       # Proper case last name
    assert_output --partial "jdoe"      # Initial + last name
    assert_output --partial "jDoe"      # Initial + proper case last name
}

@test "generate_name_permutations handles separators" {
    run generate_name_permutations "John Doe"
    
    # Verify different separator combinations
    assert_output --partial "john-doe"  # Hyphen separator
    assert_output --partial "john_doe"  # Underscore separator
    assert_output --partial "john.doe"  # Dot separator
    assert_output --partial "john--doe" # Double hyphen
    assert_output --partial "john__doe" # Double underscore
}

@test "generate_name_permutations handles non-adjacent names" {
    run generate_name_permutations "John Doe"
    
    # Verify patterns for non-adjacent names
    assert_output --partial "john-*-doe" # Full name with wildcard
    assert_output --partial "j-*-doe"    # Initial with wildcard
}

@test "filename_contains_name matches exact name" {
    run filename_contains_name "john_doe_document.pdf" "John Doe"
    [ "$status" -eq 0 ]  # Should match exact name pattern
}

@test "filename_contains_name matches with separators" {
    run filename_contains_name "john-doe-document.pdf" "John Doe"
    [ "$status" -eq 0 ]  # Should match with hyphen separator
}

@test "filename_contains_name matches with mixed case" {
    run filename_contains_name "JoHn_DoE_document.pdf" "John Doe"
    [ "$status" -eq 0 ]  # Should match regardless of case
}

@test "filename_contains_name matches with non-adjacent names" {
    run filename_contains_name "john-123-doe-document.pdf" "John Doe"
    [ "$status" -eq 0 ]  # Should match with content between names
}

@test "filename_contains_name matches with dates between names" {
    run filename_contains_name "john-23-06-2023-doe-document.pdf" "John Doe"
    [ "$status" -eq 0 ]  # Should match with date between names
}

@test "filename_contains_name handles multiple word names" {
    run filename_contains_name "mary-jane-doe-document.pdf" "Mary Jane Doe"
    [ "$status" -eq 0 ]  # Should match multiple word first name
}

@test "filename_contains_name handles multiple word last names" {
    run filename_contains_name "j-van-der-bilt-document.pdf" "John Van Der Bilt"
    [ "$status" -eq 0 ]  # Should match multiple word last name
}

@test "extract_name_from_filename returns correct permutation" {
    run extract_name_from_filename "john-doe-document.pdf" "John Doe"
    [ "$status" -eq 0 ]                # Should succeed
    [ "$output" = "john-doe" ]         # Should return exact match
}

@test "extract_name_from_filename handles mixed case" {
    run extract_name_from_filename "JoHn_DoE_document.pdf" "John Doe"
    [ "$status" -eq 0 ]                # Should succeed
    [ "$output" = "JoHn_DoE" ]         # Should preserve case
}

@test "extract_name_from_filename handles non-adjacent names" {
    run extract_name_from_filename "john-123-doe-document.pdf" "John Doe"
    [ "$status" -eq 0 ]                # Should succeed
    [ "$output" = "john-*-doe" ]       # Should use wildcard for content
} 