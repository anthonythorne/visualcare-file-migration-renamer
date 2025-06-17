#!/usr/bin/env bats

# Load test helper functions
load "${BATS_TEST_DIRNAME}/../test_helper/bats-support/load.bash"
load "${BATS_TEST_DIRNAME}/../test_helper/bats-assert/load.bash"
load "${BATS_TEST_DIRNAME}/../test_helper/bats-file/load.bash"

# Source the function to test
source "${BATS_TEST_DIRNAME}/../../core/utils/name_utils.sh"

@test "name extraction: First Name - Hyphen separator" {
    run extract_name_from_filename "john-doe-report.pdf" "john doe"
    
    # Split the output into components
    IFS='|' read -r actual_extracted_name actual_raw_remainder actual_matched <<< "$output"
    
    # Debug output
    echo "[DEBUG] Testing: john-doe-report.pdf" >&2
    echo "[DEBUG] Expected match: true" >&2
    echo "[DEBUG] Expected extracted name: john,doe" >&2
    echo "[DEBUG] Expected raw remainder: --report.pdf" >&2
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

@test "name extraction: First Name - Underscore separator" {
    run extract_name_from_filename "john_doe_report.pdf" "john doe"
    
    # Split the output into components
    IFS='|' read -r actual_extracted_name actual_raw_remainder actual_matched <<< "$output"
    
    # Debug output
    echo "[DEBUG] Testing: john_doe_report.pdf" >&2
    echo "[DEBUG] Expected match: true" >&2
    echo "[DEBUG] Expected extracted name: john,doe" >&2
    echo "[DEBUG] Expected raw remainder: __report.pdf" >&2
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

@test "name extraction: First Name - Space separator" {
    run extract_name_from_filename "john doe report.pdf" "john doe"
    
    # Split the output into components
    IFS='|' read -r actual_extracted_name actual_raw_remainder actual_matched <<< "$output"
    
    # Debug output
    echo "[DEBUG] Testing: john doe report.pdf" >&2
    echo "[DEBUG] Expected match: true" >&2
    echo "[DEBUG] Expected extracted name: john,doe" >&2
    echo "[DEBUG] Expected raw remainder:   report.pdf" >&2
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

@test "name extraction: First Name - Period separator" {
    run extract_name_from_filename "john.doe.report.pdf" "john doe"
    
    # Split the output into components
    IFS='|' read -r actual_extracted_name actual_raw_remainder actual_matched <<< "$output"
    
    # Debug output
    echo "[DEBUG] Testing: john.doe.report.pdf" >&2
    echo "[DEBUG] Expected match: true" >&2
    echo "[DEBUG] Expected extracted name: john,doe" >&2
    echo "[DEBUG] Expected raw remainder: ..report.pdf" >&2
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

@test "name extraction: Last Name - Hyphen separator" {
    run extract_name_from_filename "doe-john-report.pdf" "john doe"
    
    # Split the output into components
    IFS='|' read -r actual_extracted_name actual_raw_remainder actual_matched <<< "$output"
    
    # Debug output
    echo "[DEBUG] Testing: doe-john-report.pdf" >&2
    echo "[DEBUG] Expected match: true" >&2
    echo "[DEBUG] Expected extracted name: doe,john" >&2
    echo "[DEBUG] Expected raw remainder: --report.pdf" >&2
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

@test "name extraction: Last Name - Underscore separator" {
    run extract_name_from_filename "doe_john_report.pdf" "john doe"
    
    # Split the output into components
    IFS='|' read -r actual_extracted_name actual_raw_remainder actual_matched <<< "$output"
    
    # Debug output
    echo "[DEBUG] Testing: doe_john_report.pdf" >&2
    echo "[DEBUG] Expected match: true" >&2
    echo "[DEBUG] Expected extracted name: doe,john" >&2
    echo "[DEBUG] Expected raw remainder: __report.pdf" >&2
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

@test "name extraction: Last Name - Space separator" {
    run extract_name_from_filename "doe john report.pdf" "john doe"
    
    # Split the output into components
    IFS='|' read -r actual_extracted_name actual_raw_remainder actual_matched <<< "$output"
    
    # Debug output
    echo "[DEBUG] Testing: doe john report.pdf" >&2
    echo "[DEBUG] Expected match: true" >&2
    echo "[DEBUG] Expected extracted name: doe,john" >&2
    echo "[DEBUG] Expected raw remainder:   report.pdf" >&2
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

@test "name extraction: Last Name - Period separator" {
    run extract_name_from_filename "doe.john.report.pdf" "john doe"
    
    # Split the output into components
    IFS='|' read -r actual_extracted_name actual_raw_remainder actual_matched <<< "$output"
    
    # Debug output
    echo "[DEBUG] Testing: doe.john.report.pdf" >&2
    echo "[DEBUG] Expected match: true" >&2
    echo "[DEBUG] Expected extracted name: doe,john" >&2
    echo "[DEBUG] Expected raw remainder: ..report.pdf" >&2
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

@test "name extraction: First Initial + Last Name - Hyphen separator" {
    run extract_name_from_filename "j-doe-report.pdf" "john doe"
    
    # Split the output into components
    IFS='|' read -r actual_extracted_name actual_raw_remainder actual_matched <<< "$output"
    
    # Debug output
    echo "[DEBUG] Testing: j-doe-report.pdf" >&2
    echo "[DEBUG] Expected match: true" >&2
    echo "[DEBUG] Expected extracted name: j-doe" >&2
    echo "[DEBUG] Expected raw remainder: -report.pdf" >&2
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

@test "name extraction: First Initial + Last Name - Underscore separator" {
    run extract_name_from_filename "j_doe_report.pdf" "john doe"
    
    # Split the output into components
    IFS='|' read -r actual_extracted_name actual_raw_remainder actual_matched <<< "$output"
    
    # Debug output
    echo "[DEBUG] Testing: j_doe_report.pdf" >&2
    echo "[DEBUG] Expected match: true" >&2
    echo "[DEBUG] Expected extracted name: j_doe" >&2
    echo "[DEBUG] Expected raw remainder: _report.pdf" >&2
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

@test "name extraction: First Initial + Last Name - Space separator" {
    run extract_name_from_filename "j doe report.pdf" "john doe"
    
    # Split the output into components
    IFS='|' read -r actual_extracted_name actual_raw_remainder actual_matched <<< "$output"
    
    # Debug output
    echo "[DEBUG] Testing: j doe report.pdf" >&2
    echo "[DEBUG] Expected match: true" >&2
    echo "[DEBUG] Expected extracted name: j doe" >&2
    echo "[DEBUG] Expected raw remainder:  report.pdf" >&2
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

@test "name extraction: First Initial + Last Name - Period separator" {
    run extract_name_from_filename "j.doe.report.pdf" "john doe"
    
    # Split the output into components
    IFS='|' read -r actual_extracted_name actual_raw_remainder actual_matched <<< "$output"
    
    # Debug output
    echo "[DEBUG] Testing: j.doe.report.pdf" >&2
    echo "[DEBUG] Expected match: true" >&2
    echo "[DEBUG] Expected extracted name: j.doe" >&2
    echo "[DEBUG] Expected raw remainder: .report.pdf" >&2
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

@test "name extraction: First Name + Last Initial - Hyphen separator" {
    run extract_name_from_filename "john-d-report.pdf" "john doe"
    
    # Split the output into components
    IFS='|' read -r actual_extracted_name actual_raw_remainder actual_matched <<< "$output"
    
    # Debug output
    echo "[DEBUG] Testing: john-d-report.pdf" >&2
    echo "[DEBUG] Expected match: true" >&2
    echo "[DEBUG] Expected extracted name: john-d" >&2
    echo "[DEBUG] Expected raw remainder: -report.pdf" >&2
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

@test "name extraction: First Name + Last Initial - Underscore separator" {
    run extract_name_from_filename "john_d_report.pdf" "john doe"
    
    # Split the output into components
    IFS='|' read -r actual_extracted_name actual_raw_remainder actual_matched <<< "$output"
    
    # Debug output
    echo "[DEBUG] Testing: john_d_report.pdf" >&2
    echo "[DEBUG] Expected match: true" >&2
    echo "[DEBUG] Expected extracted name: john_d" >&2
    echo "[DEBUG] Expected raw remainder: _report.pdf" >&2
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

@test "name extraction: First Name + Last Initial - Space separator" {
    run extract_name_from_filename "john d report.pdf" "john doe"
    
    # Split the output into components
    IFS='|' read -r actual_extracted_name actual_raw_remainder actual_matched <<< "$output"
    
    # Debug output
    echo "[DEBUG] Testing: john d report.pdf" >&2
    echo "[DEBUG] Expected match: true" >&2
    echo "[DEBUG] Expected extracted name: john d" >&2
    echo "[DEBUG] Expected raw remainder:  report.pdf" >&2
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

@test "name extraction: First Name + Last Initial - Period separator" {
    run extract_name_from_filename "john.d.report.pdf" "john doe"
    
    # Split the output into components
    IFS='|' read -r actual_extracted_name actual_raw_remainder actual_matched <<< "$output"
    
    # Debug output
    echo "[DEBUG] Testing: john.d.report.pdf" >&2
    echo "[DEBUG] Expected match: true" >&2
    echo "[DEBUG] Expected extracted name: john.d" >&2
    echo "[DEBUG] Expected raw remainder: .report.pdf" >&2
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

@test "name extraction: Both Initials - Hyphen separator" {
    run extract_name_from_filename "j-d-report.pdf" "john doe"
    
    # Split the output into components
    IFS='|' read -r actual_extracted_name actual_raw_remainder actual_matched <<< "$output"
    
    # Debug output
    echo "[DEBUG] Testing: j-d-report.pdf" >&2
    echo "[DEBUG] Expected match: true" >&2
    echo "[DEBUG] Expected extracted name: j-d" >&2
    echo "[DEBUG] Expected raw remainder: -report.pdf" >&2
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

@test "name extraction: Both Initials - Underscore separator" {
    run extract_name_from_filename "j_d_report.pdf" "john doe"
    
    # Split the output into components
    IFS='|' read -r actual_extracted_name actual_raw_remainder actual_matched <<< "$output"
    
    # Debug output
    echo "[DEBUG] Testing: j_d_report.pdf" >&2
    echo "[DEBUG] Expected match: true" >&2
    echo "[DEBUG] Expected extracted name: j_d" >&2
    echo "[DEBUG] Expected raw remainder: _report.pdf" >&2
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

@test "name extraction: Both Initials - Space separator" {
    run extract_name_from_filename "j d report.pdf" "john doe"
    
    # Split the output into components
    IFS='|' read -r actual_extracted_name actual_raw_remainder actual_matched <<< "$output"
    
    # Debug output
    echo "[DEBUG] Testing: j d report.pdf" >&2
    echo "[DEBUG] Expected match: true" >&2
    echo "[DEBUG] Expected extracted name: j d" >&2
    echo "[DEBUG] Expected raw remainder:  report.pdf" >&2
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

@test "name extraction: Both Initials - Period separator " {
    run extract_name_from_filename "j.d.report.pdf" "john doe"
    
    # Split the output into components
    IFS='|' read -r actual_extracted_name actual_raw_remainder actual_matched <<< "$output"
    
    # Debug output
    echo "[DEBUG] Testing: j.d.report.pdf" >&2
    echo "[DEBUG] Expected match: true" >&2
    echo "[DEBUG] Expected extracted name: j.d" >&2
    echo "[DEBUG] Expected raw remainder: .report.pdf" >&2
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

@test "clean filename: First Name - Hyphen separator" {
    run clean_filename_remainder "--report.pdf"
    
    # Debug output
    echo "[DEBUG] Testing remainder: --report.pdf" >&2
    echo "[DEBUG] Expected cleaned: report.pdf" >&2
    echo "[DEBUG] Use case: First Name - Hyphen separator" >&2
    echo "[DEBUG] Actual output: $output" >&2
    
    # Assertions
    assert_equal "$output" "report.pdf"
}

@test "clean filename: First Name - Underscore separator" {
    run clean_filename_remainder "__report.pdf"
    
    # Debug output
    echo "[DEBUG] Testing remainder: __report.pdf" >&2
    echo "[DEBUG] Expected cleaned: report.pdf" >&2
    echo "[DEBUG] Use case: First Name - Underscore separator" >&2
    echo "[DEBUG] Actual output: $output" >&2
    
    # Assertions
    assert_equal "$output" "report.pdf"
}

@test "clean filename: First Name - Space separator" {
    run clean_filename_remainder "  report.pdf"
    
    # Debug output
    echo "[DEBUG] Testing remainder:   report.pdf" >&2
    echo "[DEBUG] Expected cleaned: report.pdf" >&2
    echo "[DEBUG] Use case: First Name - Space separator" >&2
    echo "[DEBUG] Actual output: $output" >&2
    
    # Assertions
    assert_equal "$output" "report.pdf"
}

@test "clean filename: First Name - Period separator" {
    run clean_filename_remainder "..report.pdf"
    
    # Debug output
    echo "[DEBUG] Testing remainder: ..report.pdf" >&2
    echo "[DEBUG] Expected cleaned: report.pdf" >&2
    echo "[DEBUG] Use case: First Name - Period separator" >&2
    echo "[DEBUG] Actual output: $output" >&2
    
    # Assertions
    assert_equal "$output" "report.pdf"
}

@test "clean filename: Last Name - Hyphen separator" {
    run clean_filename_remainder "--report.pdf"
    
    # Debug output
    echo "[DEBUG] Testing remainder: --report.pdf" >&2
    echo "[DEBUG] Expected cleaned: report.pdf" >&2
    echo "[DEBUG] Use case: Last Name - Hyphen separator" >&2
    echo "[DEBUG] Actual output: $output" >&2
    
    # Assertions
    assert_equal "$output" "report.pdf"
}

@test "clean filename: Last Name - Underscore separator" {
    run clean_filename_remainder "__report.pdf"
    
    # Debug output
    echo "[DEBUG] Testing remainder: __report.pdf" >&2
    echo "[DEBUG] Expected cleaned: report.pdf" >&2
    echo "[DEBUG] Use case: Last Name - Underscore separator" >&2
    echo "[DEBUG] Actual output: $output" >&2
    
    # Assertions
    assert_equal "$output" "report.pdf"
}

@test "clean filename: Last Name - Space separator" {
    run clean_filename_remainder "  report.pdf"
    
    # Debug output
    echo "[DEBUG] Testing remainder:   report.pdf" >&2
    echo "[DEBUG] Expected cleaned: report.pdf" >&2
    echo "[DEBUG] Use case: Last Name - Space separator" >&2
    echo "[DEBUG] Actual output: $output" >&2
    
    # Assertions
    assert_equal "$output" "report.pdf"
}

@test "clean filename: Last Name - Period separator" {
    run clean_filename_remainder "..report.pdf"
    
    # Debug output
    echo "[DEBUG] Testing remainder: ..report.pdf" >&2
    echo "[DEBUG] Expected cleaned: report.pdf" >&2
    echo "[DEBUG] Use case: Last Name - Period separator" >&2
    echo "[DEBUG] Actual output: $output" >&2
    
    # Assertions
    assert_equal "$output" "report.pdf"
}

@test "clean filename: First Initial + Last Name - Hyphen separator" {
    run clean_filename_remainder "-report.pdf"
    
    # Debug output
    echo "[DEBUG] Testing remainder: -report.pdf" >&2
    echo "[DEBUG] Expected cleaned: report.pdf" >&2
    echo "[DEBUG] Use case: First Initial + Last Name - Hyphen separator" >&2
    echo "[DEBUG] Actual output: $output" >&2
    
    # Assertions
    assert_equal "$output" "report.pdf"
}

@test "clean filename: First Initial + Last Name - Underscore separator" {
    run clean_filename_remainder "_report.pdf"
    
    # Debug output
    echo "[DEBUG] Testing remainder: _report.pdf" >&2
    echo "[DEBUG] Expected cleaned: report.pdf" >&2
    echo "[DEBUG] Use case: First Initial + Last Name - Underscore separator" >&2
    echo "[DEBUG] Actual output: $output" >&2
    
    # Assertions
    assert_equal "$output" "report.pdf"
}

@test "clean filename: First Initial + Last Name - Space separator" {
    run clean_filename_remainder " report.pdf"
    
    # Debug output
    echo "[DEBUG] Testing remainder:  report.pdf" >&2
    echo "[DEBUG] Expected cleaned: report.pdf" >&2
    echo "[DEBUG] Use case: First Initial + Last Name - Space separator" >&2
    echo "[DEBUG] Actual output: $output" >&2
    
    # Assertions
    assert_equal "$output" "report.pdf"
}

@test "clean filename: First Initial + Last Name - Period separator" {
    run clean_filename_remainder ".report.pdf"
    
    # Debug output
    echo "[DEBUG] Testing remainder: .report.pdf" >&2
    echo "[DEBUG] Expected cleaned: report.pdf" >&2
    echo "[DEBUG] Use case: First Initial + Last Name - Period separator" >&2
    echo "[DEBUG] Actual output: $output" >&2
    
    # Assertions
    assert_equal "$output" "report.pdf"
}

@test "clean filename: First Name + Last Initial - Hyphen separator" {
    run clean_filename_remainder "-report.pdf"
    
    # Debug output
    echo "[DEBUG] Testing remainder: -report.pdf" >&2
    echo "[DEBUG] Expected cleaned: report.pdf" >&2
    echo "[DEBUG] Use case: First Name + Last Initial - Hyphen separator" >&2
    echo "[DEBUG] Actual output: $output" >&2
    
    # Assertions
    assert_equal "$output" "report.pdf"
}

@test "clean filename: First Name + Last Initial - Underscore separator" {
    run clean_filename_remainder "_report.pdf"
    
    # Debug output
    echo "[DEBUG] Testing remainder: _report.pdf" >&2
    echo "[DEBUG] Expected cleaned: report.pdf" >&2
    echo "[DEBUG] Use case: First Name + Last Initial - Underscore separator" >&2
    echo "[DEBUG] Actual output: $output" >&2
    
    # Assertions
    assert_equal "$output" "report.pdf"
}

@test "clean filename: First Name + Last Initial - Space separator" {
    run clean_filename_remainder " report.pdf"
    
    # Debug output
    echo "[DEBUG] Testing remainder:  report.pdf" >&2
    echo "[DEBUG] Expected cleaned: report.pdf" >&2
    echo "[DEBUG] Use case: First Name + Last Initial - Space separator" >&2
    echo "[DEBUG] Actual output: $output" >&2
    
    # Assertions
    assert_equal "$output" "report.pdf"
}

@test "clean filename: First Name + Last Initial - Period separator" {
    run clean_filename_remainder ".report.pdf"
    
    # Debug output
    echo "[DEBUG] Testing remainder: .report.pdf" >&2
    echo "[DEBUG] Expected cleaned: report.pdf" >&2
    echo "[DEBUG] Use case: First Name + Last Initial - Period separator" >&2
    echo "[DEBUG] Actual output: $output" >&2
    
    # Assertions
    assert_equal "$output" "report.pdf"
}

@test "clean filename: Both Initials - Hyphen separator" {
    run clean_filename_remainder "-report.pdf"
    
    # Debug output
    echo "[DEBUG] Testing remainder: -report.pdf" >&2
    echo "[DEBUG] Expected cleaned: report.pdf" >&2
    echo "[DEBUG] Use case: Both Initials - Hyphen separator" >&2
    echo "[DEBUG] Actual output: $output" >&2
    
    # Assertions
    assert_equal "$output" "report.pdf"
}

@test "clean filename: Both Initials - Underscore separator" {
    run clean_filename_remainder "_report.pdf"
    
    # Debug output
    echo "[DEBUG] Testing remainder: _report.pdf" >&2
    echo "[DEBUG] Expected cleaned: report.pdf" >&2
    echo "[DEBUG] Use case: Both Initials - Underscore separator" >&2
    echo "[DEBUG] Actual output: $output" >&2
    
    # Assertions
    assert_equal "$output" "report.pdf"
}

@test "clean filename: Both Initials - Space separator" {
    run clean_filename_remainder " report.pdf"
    
    # Debug output
    echo "[DEBUG] Testing remainder:  report.pdf" >&2
    echo "[DEBUG] Expected cleaned: report.pdf" >&2
    echo "[DEBUG] Use case: Both Initials - Space separator" >&2
    echo "[DEBUG] Actual output: $output" >&2
    
    # Assertions
    assert_equal "$output" "report.pdf"
}

@test "clean filename: Both Initials - Period separator " {
    run clean_filename_remainder ".report.pdf"
    
    # Debug output
    echo "[DEBUG] Testing remainder: .report.pdf" >&2
    echo "[DEBUG] Expected cleaned: report.pdf" >&2
    echo "[DEBUG] Use case: Both Initials - Period separator " >&2
    echo "[DEBUG] Actual output: $output" >&2
    
    # Assertions
    assert_equal "$output" "report.pdf"
}

