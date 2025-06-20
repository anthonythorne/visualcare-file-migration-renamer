#!/usr/bin/env bats

# Load test helper functions
load "${BATS_TEST_DIRNAME}/../test_helper/bats-support/load.bash"
load "${BATS_TEST_DIRNAME}/../test_helper/bats-assert/load.bash"
load "${BATS_TEST_DIRNAME}/../test_helper/bats-file/load.bash"

# Source the function to test
source "${BATS_TEST_DIRNAME}/../../core/utils/name_utils.sh"

@test "first_name-1: First Name only" {
    run extract_first_name "john-doe-report.pdf" "john"
    
    # Split the output into components
    IFS='|' read -r actual_extracted_name actual_raw_remainder actual_matched <<< "$output"
    
    # Debug output
    echo "[DEBUG] Testing: john-doe-report.pdf" >&2
    echo "[DEBUG] Expected match: true" >&2
    echo "[DEBUG] Expected extracted name: john" >&2
    echo "[DEBUG] Expected raw remainder: -doe-report.pdf" >&2
    echo "[DEBUG] Matcher function: first_name" >&2
    echo "[DEBUG] Use case: First Name only" >&2
    echo "[DEBUG] Actual output: $output" >&2
    
    # Assertions
    if [ "true" = "true" ]; then
        assert_equal "$actual_matched" "true"
        assert_equal "$actual_extracted_name" "john"
        assert_equal "$actual_raw_remainder" "-doe-report.pdf"
    else
        assert_equal "$actual_matched" "false"
        assert_equal "$actual_extracted_name" ""
        assert_equal "$actual_raw_remainder" "john-doe-report.pdf"
    fi
}

@test "last_name-2: Last Name only" {
    run extract_last_name "john-doe-report.pdf" "doe"
    
    # Split the output into components
    IFS='|' read -r actual_extracted_name actual_raw_remainder actual_matched <<< "$output"
    
    # Debug output
    echo "[DEBUG] Testing: john-doe-report.pdf" >&2
    echo "[DEBUG] Expected match: true" >&2
    echo "[DEBUG] Expected extracted name: doe" >&2
    echo "[DEBUG] Expected raw remainder: john--report.pdf" >&2
    echo "[DEBUG] Matcher function: last_name" >&2
    echo "[DEBUG] Use case: Last Name only" >&2
    echo "[DEBUG] Actual output: $output" >&2
    
    # Assertions
    if [ "true" = "true" ]; then
        assert_equal "$actual_matched" "true"
        assert_equal "$actual_extracted_name" "doe"
        assert_equal "$actual_raw_remainder" "john--report.pdf"
    else
        assert_equal "$actual_matched" "false"
        assert_equal "$actual_extracted_name" ""
        assert_equal "$actual_raw_remainder" "john-doe-report.pdf"
    fi
}

@test "initials-3: Both Initials - Hyphen separator" {
    run extract_initials "j-d-report.pdf" "jd"
    
    # Split the output into components
    IFS='|' read -r actual_extracted_name actual_raw_remainder actual_matched <<< "$output"
    
    # Debug output
    echo "[DEBUG] Testing: j-d-report.pdf" >&2
    echo "[DEBUG] Expected match: true" >&2
    echo "[DEBUG] Expected extracted name: j-d" >&2
    echo "[DEBUG] Expected raw remainder: -report.pdf" >&2
    echo "[DEBUG] Matcher function: initials" >&2
    echo "[DEBUG] Use case: Both Initials - Hyphen separator" >&2
    echo "[DEBUG] Actual output: $output" >&2
    
    # Assertions
    if [ "true" = "true" ]; then
        assert_equal "$actual_matched" "true"
        assert_equal "$actual_extracted_name" "j-d"
        assert_equal "$actual_raw_remainder" "-report.pdf"
    else
        assert_equal "$actual_matched" "false"
        assert_equal "$actual_extracted_name" ""
        assert_equal "$actual_raw_remainder" "j-d-report.pdf"
    fi
}

@test "all_matches-4: First Name - Hyphen separator" {
    run extract_name_from_filename "john-doe-report.pdf" "john doe"
    
    # Split the output into components
    IFS='|' read -r actual_extracted_name actual_raw_remainder actual_matched <<< "$output"
    
    # Debug output
    echo "[DEBUG] Testing: john-doe-report.pdf" >&2
    echo "[DEBUG] Expected match: true" >&2
    echo "[DEBUG] Expected extracted name: john,doe" >&2
    echo "[DEBUG] Expected raw remainder: --report.pdf" >&2
    echo "[DEBUG] Matcher function: all_matches" >&2
    echo "[DEBUG] Use case: First Name - Hyphen separator" >&2
    echo "[DEBUG] Actual output: $output" >&2
    
    # Assertions
    if [ "true" = "true" ]; then
        assert_equal "$actual_matched" "true"
        assert_equal "$actual_extracted_name" "john,doe"
        assert_equal "$actual_raw_remainder" "--report.pdf"
    else
        assert_equal "$actual_matched" "false"
        assert_equal "$actual_extracted_name" ""
        assert_equal "$actual_raw_remainder" "john-doe-report.pdf"
    fi
}

@test "all_matches-5: First Name - Underscore separator" {
    run extract_name_from_filename "john_doe_report.pdf" "john doe"
    
    # Split the output into components
    IFS='|' read -r actual_extracted_name actual_raw_remainder actual_matched <<< "$output"
    
    # Debug output
    echo "[DEBUG] Testing: john_doe_report.pdf" >&2
    echo "[DEBUG] Expected match: true" >&2
    echo "[DEBUG] Expected extracted name: john,doe" >&2
    echo "[DEBUG] Expected raw remainder: __report.pdf" >&2
    echo "[DEBUG] Matcher function: all_matches" >&2
    echo "[DEBUG] Use case: First Name - Underscore separator" >&2
    echo "[DEBUG] Actual output: $output" >&2
    
    # Assertions
    if [ "true" = "true" ]; then
        assert_equal "$actual_matched" "true"
        assert_equal "$actual_extracted_name" "john,doe"
        assert_equal "$actual_raw_remainder" "__report.pdf"
    else
        assert_equal "$actual_matched" "false"
        assert_equal "$actual_extracted_name" ""
        assert_equal "$actual_raw_remainder" "john_doe_report.pdf"
    fi
}

@test "all_matches-6: First Name - Space separator" {
    run extract_name_from_filename "john doe report.pdf" "john doe"
    
    # Split the output into components
    IFS='|' read -r actual_extracted_name actual_raw_remainder actual_matched <<< "$output"
    
    # Debug output
    echo "[DEBUG] Testing: john doe report.pdf" >&2
    echo "[DEBUG] Expected match: true" >&2
    echo "[DEBUG] Expected extracted name: john,doe" >&2
    echo "[DEBUG] Expected raw remainder:   report.pdf" >&2
    echo "[DEBUG] Matcher function: all_matches" >&2
    echo "[DEBUG] Use case: First Name - Space separator" >&2
    echo "[DEBUG] Actual output: $output" >&2
    
    # Assertions
    if [ "true" = "true" ]; then
        assert_equal "$actual_matched" "true"
        assert_equal "$actual_extracted_name" "john,doe"
        assert_equal "$actual_raw_remainder" "  report.pdf"
    else
        assert_equal "$actual_matched" "false"
        assert_equal "$actual_extracted_name" ""
        assert_equal "$actual_raw_remainder" "john doe report.pdf"
    fi
}

@test "all_matches-7: First Name - Period separator" {
    run extract_name_from_filename "john.doe.report.pdf" "john doe"
    
    # Split the output into components
    IFS='|' read -r actual_extracted_name actual_raw_remainder actual_matched <<< "$output"
    
    # Debug output
    echo "[DEBUG] Testing: john.doe.report.pdf" >&2
    echo "[DEBUG] Expected match: true" >&2
    echo "[DEBUG] Expected extracted name: john,doe" >&2
    echo "[DEBUG] Expected raw remainder: ..report.pdf" >&2
    echo "[DEBUG] Matcher function: all_matches" >&2
    echo "[DEBUG] Use case: First Name - Period separator" >&2
    echo "[DEBUG] Actual output: $output" >&2
    
    # Assertions
    if [ "true" = "true" ]; then
        assert_equal "$actual_matched" "true"
        assert_equal "$actual_extracted_name" "john,doe"
        assert_equal "$actual_raw_remainder" "..report.pdf"
    else
        assert_equal "$actual_matched" "false"
        assert_equal "$actual_extracted_name" ""
        assert_equal "$actual_raw_remainder" "john.doe.report.pdf"
    fi
}

@test "all_matches-8: Last Name - Hyphen separator" {
    run extract_name_from_filename "doe-john-report.pdf" "john doe"
    
    # Split the output into components
    IFS='|' read -r actual_extracted_name actual_raw_remainder actual_matched <<< "$output"
    
    # Debug output
    echo "[DEBUG] Testing: doe-john-report.pdf" >&2
    echo "[DEBUG] Expected match: true" >&2
    echo "[DEBUG] Expected extracted name: doe,john" >&2
    echo "[DEBUG] Expected raw remainder: --report.pdf" >&2
    echo "[DEBUG] Matcher function: all_matches" >&2
    echo "[DEBUG] Use case: Last Name - Hyphen separator" >&2
    echo "[DEBUG] Actual output: $output" >&2
    
    # Assertions
    if [ "true" = "true" ]; then
        assert_equal "$actual_matched" "true"
        assert_equal "$actual_extracted_name" "doe,john"
        assert_equal "$actual_raw_remainder" "--report.pdf"
    else
        assert_equal "$actual_matched" "false"
        assert_equal "$actual_extracted_name" ""
        assert_equal "$actual_raw_remainder" "doe-john-report.pdf"
    fi
}

@test "all_matches-9: Last Name - Underscore separator" {
    run extract_name_from_filename "doe_john_report.pdf" "john doe"
    
    # Split the output into components
    IFS='|' read -r actual_extracted_name actual_raw_remainder actual_matched <<< "$output"
    
    # Debug output
    echo "[DEBUG] Testing: doe_john_report.pdf" >&2
    echo "[DEBUG] Expected match: true" >&2
    echo "[DEBUG] Expected extracted name: doe,john" >&2
    echo "[DEBUG] Expected raw remainder: __report.pdf" >&2
    echo "[DEBUG] Matcher function: all_matches" >&2
    echo "[DEBUG] Use case: Last Name - Underscore separator" >&2
    echo "[DEBUG] Actual output: $output" >&2
    
    # Assertions
    if [ "true" = "true" ]; then
        assert_equal "$actual_matched" "true"
        assert_equal "$actual_extracted_name" "doe,john"
        assert_equal "$actual_raw_remainder" "__report.pdf"
    else
        assert_equal "$actual_matched" "false"
        assert_equal "$actual_extracted_name" ""
        assert_equal "$actual_raw_remainder" "doe_john_report.pdf"
    fi
}

@test "all_matches-10: Last Name - Space separator" {
    run extract_name_from_filename "doe john report.pdf" "john doe"
    
    # Split the output into components
    IFS='|' read -r actual_extracted_name actual_raw_remainder actual_matched <<< "$output"
    
    # Debug output
    echo "[DEBUG] Testing: doe john report.pdf" >&2
    echo "[DEBUG] Expected match: true" >&2
    echo "[DEBUG] Expected extracted name: doe,john" >&2
    echo "[DEBUG] Expected raw remainder:   report.pdf" >&2
    echo "[DEBUG] Matcher function: all_matches" >&2
    echo "[DEBUG] Use case: Last Name - Space separator" >&2
    echo "[DEBUG] Actual output: $output" >&2
    
    # Assertions
    if [ "true" = "true" ]; then
        assert_equal "$actual_matched" "true"
        assert_equal "$actual_extracted_name" "doe,john"
        assert_equal "$actual_raw_remainder" "  report.pdf"
    else
        assert_equal "$actual_matched" "false"
        assert_equal "$actual_extracted_name" ""
        assert_equal "$actual_raw_remainder" "doe john report.pdf"
    fi
}

@test "all_matches-11: Last Name - Period separator" {
    run extract_name_from_filename "doe.john.report.pdf" "john doe"
    
    # Split the output into components
    IFS='|' read -r actual_extracted_name actual_raw_remainder actual_matched <<< "$output"
    
    # Debug output
    echo "[DEBUG] Testing: doe.john.report.pdf" >&2
    echo "[DEBUG] Expected match: true" >&2
    echo "[DEBUG] Expected extracted name: doe,john" >&2
    echo "[DEBUG] Expected raw remainder: ..report.pdf" >&2
    echo "[DEBUG] Matcher function: all_matches" >&2
    echo "[DEBUG] Use case: Last Name - Period separator" >&2
    echo "[DEBUG] Actual output: $output" >&2
    
    # Assertions
    if [ "true" = "true" ]; then
        assert_equal "$actual_matched" "true"
        assert_equal "$actual_extracted_name" "doe,john"
        assert_equal "$actual_raw_remainder" "..report.pdf"
    else
        assert_equal "$actual_matched" "false"
        assert_equal "$actual_extracted_name" ""
        assert_equal "$actual_raw_remainder" "doe.john.report.pdf"
    fi
}

@test "all_matches-12: First Initial + Last Name - Hyphen separator" {
    run extract_name_from_filename "j-doe-report.pdf" "john doe"
    
    # Split the output into components
    IFS='|' read -r actual_extracted_name actual_raw_remainder actual_matched <<< "$output"
    
    # Debug output
    echo "[DEBUG] Testing: j-doe-report.pdf" >&2
    echo "[DEBUG] Expected match: true" >&2
    echo "[DEBUG] Expected extracted name: j-doe" >&2
    echo "[DEBUG] Expected raw remainder: -report.pdf" >&2
    echo "[DEBUG] Matcher function: all_matches" >&2
    echo "[DEBUG] Use case: First Initial + Last Name - Hyphen separator" >&2
    echo "[DEBUG] Actual output: $output" >&2
    
    # Assertions
    if [ "true" = "true" ]; then
        assert_equal "$actual_matched" "true"
        assert_equal "$actual_extracted_name" "j-doe"
        assert_equal "$actual_raw_remainder" "-report.pdf"
    else
        assert_equal "$actual_matched" "false"
        assert_equal "$actual_extracted_name" ""
        assert_equal "$actual_raw_remainder" "j-doe-report.pdf"
    fi
}

@test "all_matches-13: First Initial + Last Name - Underscore separator" {
    run extract_name_from_filename "j_doe_report.pdf" "john doe"
    
    # Split the output into components
    IFS='|' read -r actual_extracted_name actual_raw_remainder actual_matched <<< "$output"
    
    # Debug output
    echo "[DEBUG] Testing: j_doe_report.pdf" >&2
    echo "[DEBUG] Expected match: true" >&2
    echo "[DEBUG] Expected extracted name: j_doe" >&2
    echo "[DEBUG] Expected raw remainder: _report.pdf" >&2
    echo "[DEBUG] Matcher function: all_matches" >&2
    echo "[DEBUG] Use case: First Initial + Last Name - Underscore separator" >&2
    echo "[DEBUG] Actual output: $output" >&2
    
    # Assertions
    if [ "true" = "true" ]; then
        assert_equal "$actual_matched" "true"
        assert_equal "$actual_extracted_name" "j_doe"
        assert_equal "$actual_raw_remainder" "_report.pdf"
    else
        assert_equal "$actual_matched" "false"
        assert_equal "$actual_extracted_name" ""
        assert_equal "$actual_raw_remainder" "j_doe_report.pdf"
    fi
}

@test "all_matches-14: First Initial + Last Name - Space separator" {
    run extract_name_from_filename "j doe report.pdf" "john doe"
    
    # Split the output into components
    IFS='|' read -r actual_extracted_name actual_raw_remainder actual_matched <<< "$output"
    
    # Debug output
    echo "[DEBUG] Testing: j doe report.pdf" >&2
    echo "[DEBUG] Expected match: true" >&2
    echo "[DEBUG] Expected extracted name: j doe" >&2
    echo "[DEBUG] Expected raw remainder:  report.pdf" >&2
    echo "[DEBUG] Matcher function: all_matches" >&2
    echo "[DEBUG] Use case: First Initial + Last Name - Space separator" >&2
    echo "[DEBUG] Actual output: $output" >&2
    
    # Assertions
    if [ "true" = "true" ]; then
        assert_equal "$actual_matched" "true"
        assert_equal "$actual_extracted_name" "j doe"
        assert_equal "$actual_raw_remainder" " report.pdf"
    else
        assert_equal "$actual_matched" "false"
        assert_equal "$actual_extracted_name" ""
        assert_equal "$actual_raw_remainder" "j doe report.pdf"
    fi
}

@test "all_matches-15: First Initial + Last Name - Period separator" {
    run extract_name_from_filename "j.doe.report.pdf" "john doe"
    
    # Split the output into components
    IFS='|' read -r actual_extracted_name actual_raw_remainder actual_matched <<< "$output"
    
    # Debug output
    echo "[DEBUG] Testing: j.doe.report.pdf" >&2
    echo "[DEBUG] Expected match: true" >&2
    echo "[DEBUG] Expected extracted name: j.doe" >&2
    echo "[DEBUG] Expected raw remainder: .report.pdf" >&2
    echo "[DEBUG] Matcher function: all_matches" >&2
    echo "[DEBUG] Use case: First Initial + Last Name - Period separator" >&2
    echo "[DEBUG] Actual output: $output" >&2
    
    # Assertions
    if [ "true" = "true" ]; then
        assert_equal "$actual_matched" "true"
        assert_equal "$actual_extracted_name" "j.doe"
        assert_equal "$actual_raw_remainder" ".report.pdf"
    else
        assert_equal "$actual_matched" "false"
        assert_equal "$actual_extracted_name" ""
        assert_equal "$actual_raw_remainder" "j.doe.report.pdf"
    fi
}

@test "all_matches-16: First Name + Last Initial - Hyphen separator" {
    run extract_name_from_filename "john-d-report.pdf" "john doe"
    
    # Split the output into components
    IFS='|' read -r actual_extracted_name actual_raw_remainder actual_matched <<< "$output"
    
    # Debug output
    echo "[DEBUG] Testing: john-d-report.pdf" >&2
    echo "[DEBUG] Expected match: true" >&2
    echo "[DEBUG] Expected extracted name: john-d" >&2
    echo "[DEBUG] Expected raw remainder: -report.pdf" >&2
    echo "[DEBUG] Matcher function: all_matches" >&2
    echo "[DEBUG] Use case: First Name + Last Initial - Hyphen separator" >&2
    echo "[DEBUG] Actual output: $output" >&2
    
    # Assertions
    if [ "true" = "true" ]; then
        assert_equal "$actual_matched" "true"
        assert_equal "$actual_extracted_name" "john-d"
        assert_equal "$actual_raw_remainder" "-report.pdf"
    else
        assert_equal "$actual_matched" "false"
        assert_equal "$actual_extracted_name" ""
        assert_equal "$actual_raw_remainder" "john-d-report.pdf"
    fi
}

@test "all_matches-17: First Name + Last Initial - Underscore separator" {
    run extract_name_from_filename "john_d_report.pdf" "john doe"
    
    # Split the output into components
    IFS='|' read -r actual_extracted_name actual_raw_remainder actual_matched <<< "$output"
    
    # Debug output
    echo "[DEBUG] Testing: john_d_report.pdf" >&2
    echo "[DEBUG] Expected match: true" >&2
    echo "[DEBUG] Expected extracted name: john_d" >&2
    echo "[DEBUG] Expected raw remainder: _report.pdf" >&2
    echo "[DEBUG] Matcher function: all_matches" >&2
    echo "[DEBUG] Use case: First Name + Last Initial - Underscore separator" >&2
    echo "[DEBUG] Actual output: $output" >&2
    
    # Assertions
    if [ "true" = "true" ]; then
        assert_equal "$actual_matched" "true"
        assert_equal "$actual_extracted_name" "john_d"
        assert_equal "$actual_raw_remainder" "_report.pdf"
    else
        assert_equal "$actual_matched" "false"
        assert_equal "$actual_extracted_name" ""
        assert_equal "$actual_raw_remainder" "john_d_report.pdf"
    fi
}

@test "all_matches-18: First Name + Last Initial - Space separator" {
    run extract_name_from_filename "john d report.pdf" "john doe"
    
    # Split the output into components
    IFS='|' read -r actual_extracted_name actual_raw_remainder actual_matched <<< "$output"
    
    # Debug output
    echo "[DEBUG] Testing: john d report.pdf" >&2
    echo "[DEBUG] Expected match: true" >&2
    echo "[DEBUG] Expected extracted name: john d" >&2
    echo "[DEBUG] Expected raw remainder:  report.pdf" >&2
    echo "[DEBUG] Matcher function: all_matches" >&2
    echo "[DEBUG] Use case: First Name + Last Initial - Space separator" >&2
    echo "[DEBUG] Actual output: $output" >&2
    
    # Assertions
    if [ "true" = "true" ]; then
        assert_equal "$actual_matched" "true"
        assert_equal "$actual_extracted_name" "john d"
        assert_equal "$actual_raw_remainder" " report.pdf"
    else
        assert_equal "$actual_matched" "false"
        assert_equal "$actual_extracted_name" ""
        assert_equal "$actual_raw_remainder" "john d report.pdf"
    fi
}

@test "all_matches-19: First Name + Last Initial - Period separator" {
    run extract_name_from_filename "john.d.report.pdf" "john doe"
    
    # Split the output into components
    IFS='|' read -r actual_extracted_name actual_raw_remainder actual_matched <<< "$output"
    
    # Debug output
    echo "[DEBUG] Testing: john.d.report.pdf" >&2
    echo "[DEBUG] Expected match: true" >&2
    echo "[DEBUG] Expected extracted name: john.d" >&2
    echo "[DEBUG] Expected raw remainder: .report.pdf" >&2
    echo "[DEBUG] Matcher function: all_matches" >&2
    echo "[DEBUG] Use case: First Name + Last Initial - Period separator" >&2
    echo "[DEBUG] Actual output: $output" >&2
    
    # Assertions
    if [ "true" = "true" ]; then
        assert_equal "$actual_matched" "true"
        assert_equal "$actual_extracted_name" "john.d"
        assert_equal "$actual_raw_remainder" ".report.pdf"
    else
        assert_equal "$actual_matched" "false"
        assert_equal "$actual_extracted_name" ""
        assert_equal "$actual_raw_remainder" "john.d.report.pdf"
    fi
}

@test "all_matches-20: Both Initials - Hyphen separator" {
    run extract_name_from_filename "j-d-report.pdf" "john doe"
    
    # Split the output into components
    IFS='|' read -r actual_extracted_name actual_raw_remainder actual_matched <<< "$output"
    
    # Debug output
    echo "[DEBUG] Testing: j-d-report.pdf" >&2
    echo "[DEBUG] Expected match: true" >&2
    echo "[DEBUG] Expected extracted name: j-d" >&2
    echo "[DEBUG] Expected raw remainder: -report.pdf" >&2
    echo "[DEBUG] Matcher function: all_matches" >&2
    echo "[DEBUG] Use case: Both Initials - Hyphen separator" >&2
    echo "[DEBUG] Actual output: $output" >&2
    
    # Assertions
    if [ "true" = "true" ]; then
        assert_equal "$actual_matched" "true"
        assert_equal "$actual_extracted_name" "j-d"
        assert_equal "$actual_raw_remainder" "-report.pdf"
    else
        assert_equal "$actual_matched" "false"
        assert_equal "$actual_extracted_name" ""
        assert_equal "$actual_raw_remainder" "j-d-report.pdf"
    fi
}

@test "all_matches-21: Both Initials - Underscore separator" {
    run extract_name_from_filename "j_d_report.pdf" "john doe"
    
    # Split the output into components
    IFS='|' read -r actual_extracted_name actual_raw_remainder actual_matched <<< "$output"
    
    # Debug output
    echo "[DEBUG] Testing: j_d_report.pdf" >&2
    echo "[DEBUG] Expected match: true" >&2
    echo "[DEBUG] Expected extracted name: j_d" >&2
    echo "[DEBUG] Expected raw remainder: _report.pdf" >&2
    echo "[DEBUG] Matcher function: all_matches" >&2
    echo "[DEBUG] Use case: Both Initials - Underscore separator" >&2
    echo "[DEBUG] Actual output: $output" >&2
    
    # Assertions
    if [ "true" = "true" ]; then
        assert_equal "$actual_matched" "true"
        assert_equal "$actual_extracted_name" "j_d"
        assert_equal "$actual_raw_remainder" "_report.pdf"
    else
        assert_equal "$actual_matched" "false"
        assert_equal "$actual_extracted_name" ""
        assert_equal "$actual_raw_remainder" "j_d_report.pdf"
    fi
}

@test "all_matches-22: Both Initials - Space separator" {
    run extract_name_from_filename "j d report.pdf" "john doe"
    
    # Split the output into components
    IFS='|' read -r actual_extracted_name actual_raw_remainder actual_matched <<< "$output"
    
    # Debug output
    echo "[DEBUG] Testing: j d report.pdf" >&2
    echo "[DEBUG] Expected match: true" >&2
    echo "[DEBUG] Expected extracted name: j d" >&2
    echo "[DEBUG] Expected raw remainder:  report.pdf" >&2
    echo "[DEBUG] Matcher function: all_matches" >&2
    echo "[DEBUG] Use case: Both Initials - Space separator" >&2
    echo "[DEBUG] Actual output: $output" >&2
    
    # Assertions
    if [ "true" = "true" ]; then
        assert_equal "$actual_matched" "true"
        assert_equal "$actual_extracted_name" "j d"
        assert_equal "$actual_raw_remainder" " report.pdf"
    else
        assert_equal "$actual_matched" "false"
        assert_equal "$actual_extracted_name" ""
        assert_equal "$actual_raw_remainder" "j d report.pdf"
    fi
}

@test "all_matches-23: Both Initials - Period separator " {
    run extract_name_from_filename "j.d.report.pdf" "john doe"
    
    # Split the output into components
    IFS='|' read -r actual_extracted_name actual_raw_remainder actual_matched <<< "$output"
    
    # Debug output
    echo "[DEBUG] Testing: j.d.report.pdf" >&2
    echo "[DEBUG] Expected match: true" >&2
    echo "[DEBUG] Expected extracted name: j.d" >&2
    echo "[DEBUG] Expected raw remainder: .report.pdf" >&2
    echo "[DEBUG] Matcher function: all_matches" >&2
    echo "[DEBUG] Use case: Both Initials - Period separator " >&2
    echo "[DEBUG] Actual output: $output" >&2
    
    # Assertions
    if [ "true" = "true" ]; then
        assert_equal "$actual_matched" "true"
        assert_equal "$actual_extracted_name" "j.d"
        assert_equal "$actual_raw_remainder" ".report.pdf"
    else
        assert_equal "$actual_matched" "false"
        assert_equal "$actual_extracted_name" ""
        assert_equal "$actual_raw_remainder" "j.d.report.pdf"
    fi
}

@test "clean_filename-1: First Name only" {
    run clean_filename_remainder "-doe-report.pdf"
    
    # Debug output
    echo "[DEBUG] Testing remainder: -doe-report.pdf" >&2
    echo "[DEBUG] Expected cleaned: doe-report.pdf" >&2
    echo "[DEBUG] Use case: First Name only" >&2
    echo "[DEBUG] Actual output: $output" >&2
    
    # Assertions
    assert_equal "$output" "doe-report.pdf"
}

@test "clean_filename-2: Last Name only" {
    run clean_filename_remainder "john--report.pdf"
    
    # Debug output
    echo "[DEBUG] Testing remainder: john--report.pdf" >&2
    echo "[DEBUG] Expected cleaned: john-report.pdf" >&2
    echo "[DEBUG] Use case: Last Name only" >&2
    echo "[DEBUG] Actual output: $output" >&2
    
    # Assertions
    assert_equal "$output" "john-report.pdf"
}

@test "clean_filename-3: Both Initials - Hyphen separator" {
    run clean_filename_remainder "-report.pdf"
    
    # Debug output
    echo "[DEBUG] Testing remainder: -report.pdf" >&2
    echo "[DEBUG] Expected cleaned: report.pdf" >&2
    echo "[DEBUG] Use case: Both Initials - Hyphen separator" >&2
    echo "[DEBUG] Actual output: $output" >&2
    
    # Assertions
    assert_equal "$output" "report.pdf"
}

@test "clean_filename-4: First Name - Hyphen separator" {
    run clean_filename_remainder "--report.pdf"
    
    # Debug output
    echo "[DEBUG] Testing remainder: --report.pdf" >&2
    echo "[DEBUG] Expected cleaned: report.pdf" >&2
    echo "[DEBUG] Use case: First Name - Hyphen separator" >&2
    echo "[DEBUG] Actual output: $output" >&2
    
    # Assertions
    assert_equal "$output" "report.pdf"
}

@test "clean_filename-5: First Name - Underscore separator" {
    run clean_filename_remainder "__report.pdf"
    
    # Debug output
    echo "[DEBUG] Testing remainder: __report.pdf" >&2
    echo "[DEBUG] Expected cleaned: report.pdf" >&2
    echo "[DEBUG] Use case: First Name - Underscore separator" >&2
    echo "[DEBUG] Actual output: $output" >&2
    
    # Assertions
    assert_equal "$output" "report.pdf"
}

@test "clean_filename-6: First Name - Space separator" {
    run clean_filename_remainder "  report.pdf"
    
    # Debug output
    echo "[DEBUG] Testing remainder:   report.pdf" >&2
    echo "[DEBUG] Expected cleaned: report.pdf" >&2
    echo "[DEBUG] Use case: First Name - Space separator" >&2
    echo "[DEBUG] Actual output: $output" >&2
    
    # Assertions
    assert_equal "$output" "report.pdf"
}

@test "clean_filename-7: First Name - Period separator" {
    run clean_filename_remainder "..report.pdf"
    
    # Debug output
    echo "[DEBUG] Testing remainder: ..report.pdf" >&2
    echo "[DEBUG] Expected cleaned: report.pdf" >&2
    echo "[DEBUG] Use case: First Name - Period separator" >&2
    echo "[DEBUG] Actual output: $output" >&2
    
    # Assertions
    assert_equal "$output" "report.pdf"
}

@test "clean_filename-8: Last Name - Hyphen separator" {
    run clean_filename_remainder "--report.pdf"
    
    # Debug output
    echo "[DEBUG] Testing remainder: --report.pdf" >&2
    echo "[DEBUG] Expected cleaned: report.pdf" >&2
    echo "[DEBUG] Use case: Last Name - Hyphen separator" >&2
    echo "[DEBUG] Actual output: $output" >&2
    
    # Assertions
    assert_equal "$output" "report.pdf"
}

@test "clean_filename-9: Last Name - Underscore separator" {
    run clean_filename_remainder "__report.pdf"
    
    # Debug output
    echo "[DEBUG] Testing remainder: __report.pdf" >&2
    echo "[DEBUG] Expected cleaned: report.pdf" >&2
    echo "[DEBUG] Use case: Last Name - Underscore separator" >&2
    echo "[DEBUG] Actual output: $output" >&2
    
    # Assertions
    assert_equal "$output" "report.pdf"
}

@test "clean_filename-10: Last Name - Space separator" {
    run clean_filename_remainder "  report.pdf"
    
    # Debug output
    echo "[DEBUG] Testing remainder:   report.pdf" >&2
    echo "[DEBUG] Expected cleaned: report.pdf" >&2
    echo "[DEBUG] Use case: Last Name - Space separator" >&2
    echo "[DEBUG] Actual output: $output" >&2
    
    # Assertions
    assert_equal "$output" "report.pdf"
}

@test "clean_filename-11: Last Name - Period separator" {
    run clean_filename_remainder "..report.pdf"
    
    # Debug output
    echo "[DEBUG] Testing remainder: ..report.pdf" >&2
    echo "[DEBUG] Expected cleaned: report.pdf" >&2
    echo "[DEBUG] Use case: Last Name - Period separator" >&2
    echo "[DEBUG] Actual output: $output" >&2
    
    # Assertions
    assert_equal "$output" "report.pdf"
}

@test "clean_filename-12: First Initial + Last Name - Hyphen separator" {
    run clean_filename_remainder "-report.pdf"
    
    # Debug output
    echo "[DEBUG] Testing remainder: -report.pdf" >&2
    echo "[DEBUG] Expected cleaned: report.pdf" >&2
    echo "[DEBUG] Use case: First Initial + Last Name - Hyphen separator" >&2
    echo "[DEBUG] Actual output: $output" >&2
    
    # Assertions
    assert_equal "$output" "report.pdf"
}

@test "clean_filename-13: First Initial + Last Name - Underscore separator" {
    run clean_filename_remainder "_report.pdf"
    
    # Debug output
    echo "[DEBUG] Testing remainder: _report.pdf" >&2
    echo "[DEBUG] Expected cleaned: report.pdf" >&2
    echo "[DEBUG] Use case: First Initial + Last Name - Underscore separator" >&2
    echo "[DEBUG] Actual output: $output" >&2
    
    # Assertions
    assert_equal "$output" "report.pdf"
}

@test "clean_filename-14: First Initial + Last Name - Space separator" {
    run clean_filename_remainder " report.pdf"
    
    # Debug output
    echo "[DEBUG] Testing remainder:  report.pdf" >&2
    echo "[DEBUG] Expected cleaned: report.pdf" >&2
    echo "[DEBUG] Use case: First Initial + Last Name - Space separator" >&2
    echo "[DEBUG] Actual output: $output" >&2
    
    # Assertions
    assert_equal "$output" "report.pdf"
}

@test "clean_filename-15: First Initial + Last Name - Period separator" {
    run clean_filename_remainder ".report.pdf"
    
    # Debug output
    echo "[DEBUG] Testing remainder: .report.pdf" >&2
    echo "[DEBUG] Expected cleaned: report.pdf" >&2
    echo "[DEBUG] Use case: First Initial + Last Name - Period separator" >&2
    echo "[DEBUG] Actual output: $output" >&2
    
    # Assertions
    assert_equal "$output" "report.pdf"
}

@test "clean_filename-16: First Name + Last Initial - Hyphen separator" {
    run clean_filename_remainder "-report.pdf"
    
    # Debug output
    echo "[DEBUG] Testing remainder: -report.pdf" >&2
    echo "[DEBUG] Expected cleaned: report.pdf" >&2
    echo "[DEBUG] Use case: First Name + Last Initial - Hyphen separator" >&2
    echo "[DEBUG] Actual output: $output" >&2
    
    # Assertions
    assert_equal "$output" "report.pdf"
}

@test "clean_filename-17: First Name + Last Initial - Underscore separator" {
    run clean_filename_remainder "_report.pdf"
    
    # Debug output
    echo "[DEBUG] Testing remainder: _report.pdf" >&2
    echo "[DEBUG] Expected cleaned: report.pdf" >&2
    echo "[DEBUG] Use case: First Name + Last Initial - Underscore separator" >&2
    echo "[DEBUG] Actual output: $output" >&2
    
    # Assertions
    assert_equal "$output" "report.pdf"
}

@test "clean_filename-18: First Name + Last Initial - Space separator" {
    run clean_filename_remainder " report.pdf"
    
    # Debug output
    echo "[DEBUG] Testing remainder:  report.pdf" >&2
    echo "[DEBUG] Expected cleaned: report.pdf" >&2
    echo "[DEBUG] Use case: First Name + Last Initial - Space separator" >&2
    echo "[DEBUG] Actual output: $output" >&2
    
    # Assertions
    assert_equal "$output" "report.pdf"
}

@test "clean_filename-19: First Name + Last Initial - Period separator" {
    run clean_filename_remainder ".report.pdf"
    
    # Debug output
    echo "[DEBUG] Testing remainder: .report.pdf" >&2
    echo "[DEBUG] Expected cleaned: report.pdf" >&2
    echo "[DEBUG] Use case: First Name + Last Initial - Period separator" >&2
    echo "[DEBUG] Actual output: $output" >&2
    
    # Assertions
    assert_equal "$output" "report.pdf"
}

@test "clean_filename-20: Both Initials - Hyphen separator" {
    run clean_filename_remainder "-report.pdf"
    
    # Debug output
    echo "[DEBUG] Testing remainder: -report.pdf" >&2
    echo "[DEBUG] Expected cleaned: report.pdf" >&2
    echo "[DEBUG] Use case: Both Initials - Hyphen separator" >&2
    echo "[DEBUG] Actual output: $output" >&2
    
    # Assertions
    assert_equal "$output" "report.pdf"
}

@test "clean_filename-21: Both Initials - Underscore separator" {
    run clean_filename_remainder "_report.pdf"
    
    # Debug output
    echo "[DEBUG] Testing remainder: _report.pdf" >&2
    echo "[DEBUG] Expected cleaned: report.pdf" >&2
    echo "[DEBUG] Use case: Both Initials - Underscore separator" >&2
    echo "[DEBUG] Actual output: $output" >&2
    
    # Assertions
    assert_equal "$output" "report.pdf"
}

@test "clean_filename-22: Both Initials - Space separator" {
    run clean_filename_remainder " report.pdf"
    
    # Debug output
    echo "[DEBUG] Testing remainder:  report.pdf" >&2
    echo "[DEBUG] Expected cleaned: report.pdf" >&2
    echo "[DEBUG] Use case: Both Initials - Space separator" >&2
    echo "[DEBUG] Actual output: $output" >&2
    
    # Assertions
    assert_equal "$output" "report.pdf"
}

@test "clean_filename-23: Both Initials - Period separator " {
    run clean_filename_remainder ".report.pdf"
    
    # Debug output
    echo "[DEBUG] Testing remainder: .report.pdf" >&2
    echo "[DEBUG] Expected cleaned: report.pdf" >&2
    echo "[DEBUG] Use case: Both Initials - Period separator " >&2
    echo "[DEBUG] Actual output: $output" >&2
    
    # Assertions
    assert_equal "$output" "report.pdf"
}

