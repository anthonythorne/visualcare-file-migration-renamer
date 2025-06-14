#!/usr/bin/env bats

# Load test helper
load '../test_helper.bash'

# Load the script under test
load '../../core/utils/name_utils.sh'

@test "generate_name_permutations creates basic permutations" {
    run generate_name_permutations "John Doe"
    assert_success "$status"
    assert_output --partial "john"
    assert_output --partial "doe"
    assert_output --partial "john-doe"
    assert_output --partial "john_doe"
}

@test "generate_name_permutations handles separators" {
    run generate_name_permutations "John Doe"
    assert_success "$status"
    assert_output --partial "john-doe"
    assert_output --partial "john_doe"
}

@test "generate_name_permutations handles non-adjacent names" {
    run generate_name_permutations "John Doe"
    assert_success "$status"
    assert_output --partial "john-*-doe"
    assert_output --partial "john_*_doe"
}

@test "filename_contains_name matches exact name" {
    run filename_contains_name "john_doe_20230101.pdf" "John Doe"
    assert_success "$status"
}

@test "filename_contains_name matches with separators" {
    run filename_contains_name "john-doe-20230101.pdf" "John Doe"
    assert_success "$status"
}

@test "filename_contains_name matches with mixed case" {
    run filename_contains_name "JoHn_DoE_20230101.pdf" "John Doe"
    assert_success "$status"
}

@test "filename_contains_name matches with non-adjacent names" {
    run filename_contains_name "john_smith_doe_20230101.pdf" "John Doe"
    assert_success "$status"
}

@test "filename_contains_name matches with dates between names" {
    run filename_contains_name "john_20230101_doe.pdf" "John Doe"
    assert_success "$status"
}

@test "filename_contains_name does not match with middle names" {
    run filename_contains_name "john-james_doe_20230101.pdf" "John Doe"
    assert_failure "$status"
}

@test "filename_contains_name does not match with additional last names" {
    run filename_contains_name "john_doe-smith_20230101.pdf" "John Doe"
    assert_failure "$status"
}

@test "extract_name_from_filename returns correct permutation" {
    run extract_name_from_filename "john_doe_20230101.pdf" "John Doe"
    assert_success "$status"
    assert_output "john_doe"
}

@test "extract_name_from_filename handles mixed case" {
    run extract_name_from_filename "JoHn_DoE_20230101.pdf" "John Doe"
    assert_success "$status"
    assert_output "JoHn_DoE"
}

@test "extract_name_from_filename handles non-adjacent names" {
    run extract_name_from_filename "john_smith_doe_20230101.pdf" "John Doe"
    assert_success "$status"
    assert_output "john_*_doe"
}

@test "extract_name_from_filename does not match with middle names" {
    run extract_name_from_filename "john-james_doe_20230101.pdf" "John Doe"
    assert_failure "$status"
}

@test "extract_name_from_filename does not match with additional last names" {
    run extract_name_from_filename "john_doe-smith_20230101.pdf" "John Doe"
    assert_failure "$status"
} 