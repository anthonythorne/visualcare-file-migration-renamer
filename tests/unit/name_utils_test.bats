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
    
    # Check that basic permutations exist
    assert_output --partial "john"
    assert_output --partial "doe"
    assert_output --partial "John"
    assert_output --partial "Doe"
    assert_output --partial "jdoe"
    assert_output --partial "jDoe"
}

@test "generate_name_permutations handles separators" {
    run generate_name_permutations "John Doe"
    
    # Check various separator combinations
    assert_output --partial "john-doe"
    assert_output --partial "john_doe"
    assert_output --partial "john.doe"
    assert_output --partial "john--doe"
    assert_output --partial "john__doe"
}

@test "generate_name_permutations handles non-adjacent names" {
    run generate_name_permutations "John Doe"
    
    # Check patterns for non-adjacent names
    assert_output --partial "john-*-doe"
    assert_output --partial "j-*-doe"
}

@test "filename_contains_name matches exact name" {
    run filename_contains_name "john_doe_document.pdf" "John Doe"
    [ "$status" -eq 0 ]
}

@test "filename_contains_name matches with separators" {
    run filename_contains_name "john-doe-document.pdf" "John Doe"
    [ "$status" -eq 0 ]
}

@test "filename_contains_name matches with mixed case" {
    run filename_contains_name "JoHn_DoE_document.pdf" "John Doe"
    [ "$status" -eq 0 ]
}

@test "filename_contains_name matches with non-adjacent names" {
    run filename_contains_name "john-123-doe-document.pdf" "John Doe"
    [ "$status" -eq 0 ]
}

@test "filename_contains_name matches with dates between names" {
    run filename_contains_name "john-23-06-2023-doe-document.pdf" "John Doe"
    [ "$status" -eq 0 ]
}

@test "filename_contains_name handles multiple word names" {
    run filename_contains_name "mary-jane-doe-document.pdf" "Mary Jane Doe"
    [ "$status" -eq 0 ]
}

@test "filename_contains_name handles multiple word last names" {
    run filename_contains_name "j-van-der-bilt-document.pdf" "John Van Der Bilt"
    [ "$status" -eq 0 ]
}

@test "extract_name_from_filename returns correct permutation" {
    run extract_name_from_filename "john-doe-document.pdf" "John Doe"
    [ "$status" -eq 0 ]
    [ "$output" = "john-doe" ]
}

@test "extract_name_from_filename handles mixed case" {
    run extract_name_from_filename "JoHn_DoE_document.pdf" "John Doe"
    [ "$status" -eq 0 ]
    [ "$output" = "JoHn_DoE" ]
}

@test "extract_name_from_filename handles non-adjacent names" {
    run extract_name_from_filename "john-123-doe-document.pdf" "John Doe"
    [ "$status" -eq 0 ]
    [ "$output" = "john-*-doe" ]
} 