#!/usr/bin/env bats

# Load test helper functions
load "${BATS_TEST_DIRNAME}/../test_helper/bats-support/load.bash"
load "${BATS_TEST_DIRNAME}/../test_helper/bats-assert/load.bash"
load "${BATS_TEST_DIRNAME}/../test_helper/bats-file/load.bash"

# Source the function to test
source "${BATS_TEST_DIRNAME}/../../core/utils/name_utils.sh"

# Override the main python script call to allow specifying the function
extract_name_from_filename() {
    local filename="$1"
    local target_name="$2"
    local function_name="${3:-extract_name_from_filename}"  # Default to extract_name_from_filename
    
    # Call the python script, passing the function name as an argument
    # The python script will need to be adapted to handle this
    python3 "${BATS_TEST_DIRNAME}/../../core/utils/name_matcher.py" "$filename" "$target_name" "$function_name"
}

@test "name-extraction-1 [matcher_function=first_name]: First Name only" {
    run extract_name_from_filename "john-doe-report.pdf" "john doe" "extract_first_name_only"

    # Split the output into components
    IFS='|' read -r actual_extracted actual_raw_remainder actual_matched <<< "$(echo "$output" | tail -n1)"

    # Debug output
    echo "[DEBUG] Testing: john-doe-report.pdf" >&2
    echo "[DEBUG] Expected match: true" >&2
    echo "[DEBUG] Expected extracted: john" >&2
    echo "[DEBUG] Expected raw remainder: -doe-report.pdf" >&2
    echo "[DEBUG] Use case: First Name only" >&2
    echo "[DEBUG] Actual output: $output" >&2

    # Assertions
    if [ "true" = "true" ]; then
        assert_equal "$actual_matched" "true"
        assert_equal "$actual_extracted" "john"
        assert_equal "$actual_raw_remainder" "-doe-report.pdf"
    else
        assert_equal "$actual_matched" "false"
        assert_equal "$actual_extracted" ""
        assert_equal "$actual_raw_remainder" "john-doe-report.pdf"
    fi
}

@test "name-extraction-2 [matcher_function=first_name]: First Name only" {
    run extract_name_from_filename "John Doe 20240525 report.pdf" "john doe" "extract_first_name_only"

    # Split the output into components
    IFS='|' read -r actual_extracted actual_raw_remainder actual_matched <<< "$(echo "$output" | tail -n1)"

    # Debug output
    echo "[DEBUG] Testing: John Doe 20240525 report.pdf" >&2
    echo "[DEBUG] Expected match: true" >&2
    echo "[DEBUG] Expected extracted: John" >&2
    echo "[DEBUG] Expected raw remainder:  Doe 20240525 report.pdf" >&2
    echo "[DEBUG] Use case: First Name only" >&2
    echo "[DEBUG] Actual output: $output" >&2

    # Assertions
    if [ "true" = "true" ]; then
        assert_equal "$actual_matched" "true"
        assert_equal "$actual_extracted" "John"
        assert_equal "$actual_raw_remainder" " Doe 20240525 report.pdf"
    else
        assert_equal "$actual_matched" "false"
        assert_equal "$actual_extracted" ""
        assert_equal "$actual_raw_remainder" "John Doe 20240525 report.pdf"
    fi
}

@test "name-extraction-3 [matcher_function=last_name]: Last Name only" {
    run extract_name_from_filename "john-doe-report.pdf" "john doe" "extract_last_name_only"

    # Split the output into components
    IFS='|' read -r actual_extracted actual_raw_remainder actual_matched <<< "$(echo "$output" | tail -n1)"

    # Debug output
    echo "[DEBUG] Testing: john-doe-report.pdf" >&2
    echo "[DEBUG] Expected match: true" >&2
    echo "[DEBUG] Expected extracted: doe" >&2
    echo "[DEBUG] Expected raw remainder: john--report.pdf" >&2
    echo "[DEBUG] Use case: Last Name only" >&2
    echo "[DEBUG] Actual output: $output" >&2

    # Assertions
    if [ "true" = "true" ]; then
        assert_equal "$actual_matched" "true"
        assert_equal "$actual_extracted" "doe"
        assert_equal "$actual_raw_remainder" "john--report.pdf"
    else
        assert_equal "$actual_matched" "false"
        assert_equal "$actual_extracted" ""
        assert_equal "$actual_raw_remainder" "john-doe-report.pdf"
    fi
}

@test "name-extraction-4 [matcher_function=last_name]: Last Name only" {
    run extract_name_from_filename "John Doe 20240525 report.pdf" "john doe" "extract_last_name_only"

    # Split the output into components
    IFS='|' read -r actual_extracted actual_raw_remainder actual_matched <<< "$(echo "$output" | tail -n1)"

    # Debug output
    echo "[DEBUG] Testing: John Doe 20240525 report.pdf" >&2
    echo "[DEBUG] Expected match: true" >&2
    echo "[DEBUG] Expected extracted: Doe" >&2
    echo "[DEBUG] Expected raw remainder: John  20240525 report.pdf" >&2
    echo "[DEBUG] Use case: Last Name only" >&2
    echo "[DEBUG] Actual output: $output" >&2

    # Assertions
    if [ "true" = "true" ]; then
        assert_equal "$actual_matched" "true"
        assert_equal "$actual_extracted" "Doe"
        assert_equal "$actual_raw_remainder" "John  20240525 report.pdf"
    else
        assert_equal "$actual_matched" "false"
        assert_equal "$actual_extracted" ""
        assert_equal "$actual_raw_remainder" "John Doe 20240525 report.pdf"
    fi
}

@test "name-extraction-5 [matcher_function=initials]: Both Initials - Hyphen separator" {
    run extract_name_from_filename "j-d-report.pdf" "john doe" "extract_initials_only"

    # Split the output into components
    IFS='|' read -r actual_extracted actual_raw_remainder actual_matched <<< "$(echo "$output" | tail -n1)"

    # Debug output
    echo "[DEBUG] Testing: j-d-report.pdf" >&2
    echo "[DEBUG] Expected match: true" >&2
    echo "[DEBUG] Expected extracted: j-d" >&2
    echo "[DEBUG] Expected raw remainder: -report.pdf" >&2
    echo "[DEBUG] Use case: Both Initials - Hyphen separator" >&2
    echo "[DEBUG] Actual output: $output" >&2

    # Assertions
    if [ "true" = "true" ]; then
        assert_equal "$actual_matched" "true"
        assert_equal "$actual_extracted" "j-d"
        assert_equal "$actual_raw_remainder" "-report.pdf"
    else
        assert_equal "$actual_matched" "false"
        assert_equal "$actual_extracted" ""
        assert_equal "$actual_raw_remainder" "j-d-report.pdf"
    fi
}

@test "name-extraction-6 [matcher_function=initials]: Both Initials - Period separator" {
    run extract_name_from_filename "Home J.D report.pdf" "john doe" "extract_initials_only"

    # Split the output into components
    IFS='|' read -r actual_extracted actual_raw_remainder actual_matched <<< "$(echo "$output" | tail -n1)"

    # Debug output
    echo "[DEBUG] Testing: Home J.D report.pdf" >&2
    echo "[DEBUG] Expected match: true" >&2
    echo "[DEBUG] Expected extracted: J.D" >&2
    echo "[DEBUG] Expected raw remainder: Home  report.pdf" >&2
    echo "[DEBUG] Use case: Both Initials - Period separator" >&2
    echo "[DEBUG] Actual output: $output" >&2

    # Assertions
    if [ "true" = "true" ]; then
        assert_equal "$actual_matched" "true"
        assert_equal "$actual_extracted" "J.D"
        assert_equal "$actual_raw_remainder" "Home  report.pdf"
    else
        assert_equal "$actual_matched" "false"
        assert_equal "$actual_extracted" ""
        assert_equal "$actual_raw_remainder" "Home J.D report.pdf"
    fi
}

@test "name-extraction-7 [matcher_function=initials]: Both Initials - Space separator" {
    run extract_name_from_filename "File j d report.pdf" "john doe" "extract_initials_only"

    # Split the output into components
    IFS='|' read -r actual_extracted actual_raw_remainder actual_matched <<< "$(echo "$output" | tail -n1)"

    # Debug output
    echo "[DEBUG] Testing: File j d report.pdf" >&2
    echo "[DEBUG] Expected match: true" >&2
    echo "[DEBUG] Expected extracted: j d" >&2
    echo "[DEBUG] Expected raw remainder: File  report.pdf" >&2
    echo "[DEBUG] Use case: Both Initials - Space separator" >&2
    echo "[DEBUG] Actual output: $output" >&2

    # Assertions
    if [ "true" = "true" ]; then
        assert_equal "$actual_matched" "true"
        assert_equal "$actual_extracted" "j d"
        assert_equal "$actual_raw_remainder" "File  report.pdf"
    else
        assert_equal "$actual_matched" "false"
        assert_equal "$actual_extracted" ""
        assert_equal "$actual_raw_remainder" "File j d report.pdf"
    fi
}

@test "name-extraction-8 [matcher_function=initials]: Both Initials - Underscore separator" {
    run extract_name_from_filename "j_d_report.pdf" "john doe" "extract_initials_only"

    # Split the output into components
    IFS='|' read -r actual_extracted actual_raw_remainder actual_matched <<< "$(echo "$output" | tail -n1)"

    # Debug output
    echo "[DEBUG] Testing: j_d_report.pdf" >&2
    echo "[DEBUG] Expected match: true" >&2
    echo "[DEBUG] Expected extracted: j_d" >&2
    echo "[DEBUG] Expected raw remainder: _report.pdf" >&2
    echo "[DEBUG] Use case: Both Initials - Underscore separator" >&2
    echo "[DEBUG] Actual output: $output" >&2

    # Assertions
    if [ "true" = "true" ]; then
        assert_equal "$actual_matched" "true"
        assert_equal "$actual_extracted" "j_d"
        assert_equal "$actual_raw_remainder" "_report.pdf"
    else
        assert_equal "$actual_matched" "false"
        assert_equal "$actual_extracted" ""
        assert_equal "$actual_raw_remainder" "j_d_report.pdf"
    fi
}

@test "name-extraction-9 [matcher_function=initials]: Both Initials - Underscore separator" {
    run extract_name_from_filename "File j_- d_report.pdf" "john doe" "extract_initials_only"

    # Split the output into components
    IFS='|' read -r actual_extracted actual_raw_remainder actual_matched <<< "$(echo "$output" | tail -n1)"

    # Debug output
    echo "[DEBUG] Testing: File j_- d_report.pdf" >&2
    echo "[DEBUG] Expected match: true" >&2
    echo "[DEBUG] Expected extracted: j_- d" >&2
    echo "[DEBUG] Expected raw remainder: File _report.pdf" >&2
    echo "[DEBUG] Use case: Both Initials - Underscore separator" >&2
    echo "[DEBUG] Actual output: $output" >&2

    # Assertions
    if [ "true" = "true" ]; then
        assert_equal "$actual_matched" "true"
        assert_equal "$actual_extracted" "j_- d"
        assert_equal "$actual_raw_remainder" "File _report.pdf"
    else
        assert_equal "$actual_matched" "false"
        assert_equal "$actual_extracted" ""
        assert_equal "$actual_raw_remainder" "File j_- d_report.pdf"
    fi
}

@test "name-extraction-10 [matcher_function=shorthand]: First Initial + Last Name - Hyphen separator" {
    run extract_name_from_filename "j-doe-report.pdf" "john doe" "extract_shorthand"

    # Split the output into components
    IFS='|' read -r actual_extracted actual_raw_remainder actual_matched <<< "$(echo "$output" | tail -n1)"

    # Debug output
    echo "[DEBUG] Testing: j-doe-report.pdf" >&2
    echo "[DEBUG] Expected match: true" >&2
    echo "[DEBUG] Expected extracted: j-doe" >&2
    echo "[DEBUG] Expected raw remainder: -report.pdf" >&2
    echo "[DEBUG] Use case: First Initial + Last Name - Hyphen separator" >&2
    echo "[DEBUG] Actual output: $output" >&2

    # Assertions
    if [ "true" = "true" ]; then
        assert_equal "$actual_matched" "true"
        assert_equal "$actual_extracted" "j-doe"
        assert_equal "$actual_raw_remainder" "-report.pdf"
    else
        assert_equal "$actual_matched" "false"
        assert_equal "$actual_extracted" ""
        assert_equal "$actual_raw_remainder" "j-doe-report.pdf"
    fi
}

@test "name-extraction-11 [matcher_function=shorthand]: First Initial + Last Name - Underscore separator" {
    run extract_name_from_filename "j_doe_report.pdf" "john doe" "extract_shorthand"

    # Split the output into components
    IFS='|' read -r actual_extracted actual_raw_remainder actual_matched <<< "$(echo "$output" | tail -n1)"

    # Debug output
    echo "[DEBUG] Testing: j_doe_report.pdf" >&2
    echo "[DEBUG] Expected match: true" >&2
    echo "[DEBUG] Expected extracted: j_doe" >&2
    echo "[DEBUG] Expected raw remainder: _report.pdf" >&2
    echo "[DEBUG] Use case: First Initial + Last Name - Underscore separator" >&2
    echo "[DEBUG] Actual output: $output" >&2

    # Assertions
    if [ "true" = "true" ]; then
        assert_equal "$actual_matched" "true"
        assert_equal "$actual_extracted" "j_doe"
        assert_equal "$actual_raw_remainder" "_report.pdf"
    else
        assert_equal "$actual_matched" "false"
        assert_equal "$actual_extracted" ""
        assert_equal "$actual_raw_remainder" "j_doe_report.pdf"
    fi
}

@test "name-extraction-12 [matcher_function=shorthand]: First Initial + Last Name - Space separator" {
    run extract_name_from_filename "j doe report.pdf" "john doe" "extract_shorthand"

    # Split the output into components
    IFS='|' read -r actual_extracted actual_raw_remainder actual_matched <<< "$(echo "$output" | tail -n1)"

    # Debug output
    echo "[DEBUG] Testing: j doe report.pdf" >&2
    echo "[DEBUG] Expected match: true" >&2
    echo "[DEBUG] Expected extracted: j doe" >&2
    echo "[DEBUG] Expected raw remainder:  report.pdf" >&2
    echo "[DEBUG] Use case: First Initial + Last Name - Space separator" >&2
    echo "[DEBUG] Actual output: $output" >&2

    # Assertions
    if [ "true" = "true" ]; then
        assert_equal "$actual_matched" "true"
        assert_equal "$actual_extracted" "j doe"
        assert_equal "$actual_raw_remainder" " report.pdf"
    else
        assert_equal "$actual_matched" "false"
        assert_equal "$actual_extracted" ""
        assert_equal "$actual_raw_remainder" "j doe report.pdf"
    fi
}

@test "name-extraction-13 [matcher_function=shorthand]: First Initial + Last Name - Period separator" {
    run extract_name_from_filename "j.doe.report.pdf" "john doe" "extract_shorthand"

    # Split the output into components
    IFS='|' read -r actual_extracted actual_raw_remainder actual_matched <<< "$(echo "$output" | tail -n1)"

    # Debug output
    echo "[DEBUG] Testing: j.doe.report.pdf" >&2
    echo "[DEBUG] Expected match: true" >&2
    echo "[DEBUG] Expected extracted: j.doe" >&2
    echo "[DEBUG] Expected raw remainder: .report.pdf" >&2
    echo "[DEBUG] Use case: First Initial + Last Name - Period separator" >&2
    echo "[DEBUG] Actual output: $output" >&2

    # Assertions
    if [ "true" = "true" ]; then
        assert_equal "$actual_matched" "true"
        assert_equal "$actual_extracted" "j.doe"
        assert_equal "$actual_raw_remainder" ".report.pdf"
    else
        assert_equal "$actual_matched" "false"
        assert_equal "$actual_extracted" ""
        assert_equal "$actual_raw_remainder" "j.doe.report.pdf"
    fi
}

@test "name-extraction-14 [matcher_function=shorthand]: First Name + Last Initial - Hyphen separator" {
    run extract_name_from_filename "john-d-report.pdf" "john doe" "extract_shorthand"

    # Split the output into components
    IFS='|' read -r actual_extracted actual_raw_remainder actual_matched <<< "$(echo "$output" | tail -n1)"

    # Debug output
    echo "[DEBUG] Testing: john-d-report.pdf" >&2
    echo "[DEBUG] Expected match: true" >&2
    echo "[DEBUG] Expected extracted: john-d" >&2
    echo "[DEBUG] Expected raw remainder: -report.pdf" >&2
    echo "[DEBUG] Use case: First Name + Last Initial - Hyphen separator" >&2
    echo "[DEBUG] Actual output: $output" >&2

    # Assertions
    if [ "true" = "true" ]; then
        assert_equal "$actual_matched" "true"
        assert_equal "$actual_extracted" "john-d"
        assert_equal "$actual_raw_remainder" "-report.pdf"
    else
        assert_equal "$actual_matched" "false"
        assert_equal "$actual_extracted" ""
        assert_equal "$actual_raw_remainder" "john-d-report.pdf"
    fi
}

@test "name-extraction-15 [matcher_function=shorthand]: First Name + Last Initial - Underscore separator" {
    run extract_name_from_filename "john_d_report.pdf" "john doe" "extract_shorthand"

    # Split the output into components
    IFS='|' read -r actual_extracted actual_raw_remainder actual_matched <<< "$(echo "$output" | tail -n1)"

    # Debug output
    echo "[DEBUG] Testing: john_d_report.pdf" >&2
    echo "[DEBUG] Expected match: true" >&2
    echo "[DEBUG] Expected extracted: john_d" >&2
    echo "[DEBUG] Expected raw remainder: _report.pdf" >&2
    echo "[DEBUG] Use case: First Name + Last Initial - Underscore separator" >&2
    echo "[DEBUG] Actual output: $output" >&2

    # Assertions
    if [ "true" = "true" ]; then
        assert_equal "$actual_matched" "true"
        assert_equal "$actual_extracted" "john_d"
        assert_equal "$actual_raw_remainder" "_report.pdf"
    else
        assert_equal "$actual_matched" "false"
        assert_equal "$actual_extracted" ""
        assert_equal "$actual_raw_remainder" "john_d_report.pdf"
    fi
}

@test "name-extraction-16 [matcher_function=shorthand]: First Name + Last Initial - Space separator" {
    run extract_name_from_filename "john d report.pdf" "john doe" "extract_shorthand"

    # Split the output into components
    IFS='|' read -r actual_extracted actual_raw_remainder actual_matched <<< "$(echo "$output" | tail -n1)"

    # Debug output
    echo "[DEBUG] Testing: john d report.pdf" >&2
    echo "[DEBUG] Expected match: true" >&2
    echo "[DEBUG] Expected extracted: john d" >&2
    echo "[DEBUG] Expected raw remainder:  report.pdf" >&2
    echo "[DEBUG] Use case: First Name + Last Initial - Space separator" >&2
    echo "[DEBUG] Actual output: $output" >&2

    # Assertions
    if [ "true" = "true" ]; then
        assert_equal "$actual_matched" "true"
        assert_equal "$actual_extracted" "john d"
        assert_equal "$actual_raw_remainder" " report.pdf"
    else
        assert_equal "$actual_matched" "false"
        assert_equal "$actual_extracted" ""
        assert_equal "$actual_raw_remainder" "john d report.pdf"
    fi
}

@test "name-extraction-17 [matcher_function=shorthand]: First Name + Last Initial - Period separator" {
    run extract_name_from_filename "john.d.report.pdf" "john doe" "extract_shorthand"

    # Split the output into components
    IFS='|' read -r actual_extracted actual_raw_remainder actual_matched <<< "$(echo "$output" | tail -n1)"

    # Debug output
    echo "[DEBUG] Testing: john.d.report.pdf" >&2
    echo "[DEBUG] Expected match: true" >&2
    echo "[DEBUG] Expected extracted: john.d" >&2
    echo "[DEBUG] Expected raw remainder: .report.pdf" >&2
    echo "[DEBUG] Use case: First Name + Last Initial - Period separator" >&2
    echo "[DEBUG] Actual output: $output" >&2

    # Assertions
    if [ "true" = "true" ]; then
        assert_equal "$actual_matched" "true"
        assert_equal "$actual_extracted" "john.d"
        assert_equal "$actual_raw_remainder" ".report.pdf"
    else
        assert_equal "$actual_matched" "false"
        assert_equal "$actual_extracted" ""
        assert_equal "$actual_raw_remainder" "john.d.report.pdf"
    fi
}

@test "name-extraction-18 [matcher_function=all_matches]: First Name - Hyphen separator" {
    run extract_name_from_filename "john-doe-report.pdf" "john doe" "extract_name_from_filename"

    # Split the output into components
    IFS='|' read -r actual_extracted actual_raw_remainder actual_matched <<< "$(echo "$output" | tail -n1)"

    # Debug output
    echo "[DEBUG] Testing: john-doe-report.pdf" >&2
    echo "[DEBUG] Expected match: true" >&2
    echo "[DEBUG] Expected extracted: john,doe" >&2
    echo "[DEBUG] Expected raw remainder: --report.pdf" >&2
    echo "[DEBUG] Use case: First Name - Hyphen separator" >&2
    echo "[DEBUG] Actual output: $output" >&2

    # Assertions
    if [ "true" = "true" ]; then
        assert_equal "$actual_matched" "true"
        assert_equal "$actual_extracted" "john,doe"
        assert_equal "$actual_raw_remainder" "--report.pdf"
    else
        assert_equal "$actual_matched" "false"
        assert_equal "$actual_extracted" ""
        assert_equal "$actual_raw_remainder" "john-doe-report.pdf"
    fi
}

@test "name-extraction-19 [matcher_function=all_matches]: First Name - Underscore separator" {
    run extract_name_from_filename "john_doe_report.pdf" "john doe" "extract_name_from_filename"

    # Split the output into components
    IFS='|' read -r actual_extracted actual_raw_remainder actual_matched <<< "$(echo "$output" | tail -n1)"

    # Debug output
    echo "[DEBUG] Testing: john_doe_report.pdf" >&2
    echo "[DEBUG] Expected match: true" >&2
    echo "[DEBUG] Expected extracted: john,doe" >&2
    echo "[DEBUG] Expected raw remainder: __report.pdf" >&2
    echo "[DEBUG] Use case: First Name - Underscore separator" >&2
    echo "[DEBUG] Actual output: $output" >&2

    # Assertions
    if [ "true" = "true" ]; then
        assert_equal "$actual_matched" "true"
        assert_equal "$actual_extracted" "john,doe"
        assert_equal "$actual_raw_remainder" "__report.pdf"
    else
        assert_equal "$actual_matched" "false"
        assert_equal "$actual_extracted" ""
        assert_equal "$actual_raw_remainder" "john_doe_report.pdf"
    fi
}

@test "name-extraction-20 [matcher_function=all_matches]: First Name - Space separator" {
    run extract_name_from_filename "john doe report.pdf" "john doe" "extract_name_from_filename"

    # Split the output into components
    IFS='|' read -r actual_extracted actual_raw_remainder actual_matched <<< "$(echo "$output" | tail -n1)"

    # Debug output
    echo "[DEBUG] Testing: john doe report.pdf" >&2
    echo "[DEBUG] Expected match: true" >&2
    echo "[DEBUG] Expected extracted: john,doe" >&2
    echo "[DEBUG] Expected raw remainder:   report.pdf" >&2
    echo "[DEBUG] Use case: First Name - Space separator" >&2
    echo "[DEBUG] Actual output: $output" >&2

    # Assertions
    if [ "true" = "true" ]; then
        assert_equal "$actual_matched" "true"
        assert_equal "$actual_extracted" "john,doe"
        assert_equal "$actual_raw_remainder" "  report.pdf"
    else
        assert_equal "$actual_matched" "false"
        assert_equal "$actual_extracted" ""
        assert_equal "$actual_raw_remainder" "john doe report.pdf"
    fi
}

@test "name-extraction-21 [matcher_function=all_matches]: First Name - Period separator" {
    run extract_name_from_filename "john.doe.report.pdf" "john doe" "extract_name_from_filename"

    # Split the output into components
    IFS='|' read -r actual_extracted actual_raw_remainder actual_matched <<< "$(echo "$output" | tail -n1)"

    # Debug output
    echo "[DEBUG] Testing: john.doe.report.pdf" >&2
    echo "[DEBUG] Expected match: true" >&2
    echo "[DEBUG] Expected extracted: john,doe" >&2
    echo "[DEBUG] Expected raw remainder: ..report.pdf" >&2
    echo "[DEBUG] Use case: First Name - Period separator" >&2
    echo "[DEBUG] Actual output: $output" >&2

    # Assertions
    if [ "true" = "true" ]; then
        assert_equal "$actual_matched" "true"
        assert_equal "$actual_extracted" "john,doe"
        assert_equal "$actual_raw_remainder" "..report.pdf"
    else
        assert_equal "$actual_matched" "false"
        assert_equal "$actual_extracted" ""
        assert_equal "$actual_raw_remainder" "john.doe.report.pdf"
    fi
}

@test "name-extraction-22 [matcher_function=all_matches]: Last Name - Hyphen separator" {
    run extract_name_from_filename "doe-john-report.pdf" "john doe" "extract_name_from_filename"

    # Split the output into components
    IFS='|' read -r actual_extracted actual_raw_remainder actual_matched <<< "$(echo "$output" | tail -n1)"

    # Debug output
    echo "[DEBUG] Testing: doe-john-report.pdf" >&2
    echo "[DEBUG] Expected match: true" >&2
    echo "[DEBUG] Expected extracted: john,doe" >&2
    echo "[DEBUG] Expected raw remainder: --report.pdf" >&2
    echo "[DEBUG] Use case: Last Name - Hyphen separator" >&2
    echo "[DEBUG] Actual output: $output" >&2

    # Assertions
    if [ "true" = "true" ]; then
        assert_equal "$actual_matched" "true"
        assert_equal "$actual_extracted" "john,doe"
        assert_equal "$actual_raw_remainder" "--report.pdf"
    else
        assert_equal "$actual_matched" "false"
        assert_equal "$actual_extracted" ""
        assert_equal "$actual_raw_remainder" "doe-john-report.pdf"
    fi
}

@test "name-extraction-23 [matcher_function=all_matches]: Last Name - Underscore separator" {
    run extract_name_from_filename "doe_john_report.pdf" "john doe" "extract_name_from_filename"

    # Split the output into components
    IFS='|' read -r actual_extracted actual_raw_remainder actual_matched <<< "$(echo "$output" | tail -n1)"

    # Debug output
    echo "[DEBUG] Testing: doe_john_report.pdf" >&2
    echo "[DEBUG] Expected match: true" >&2
    echo "[DEBUG] Expected extracted: john,doe" >&2
    echo "[DEBUG] Expected raw remainder: __report.pdf" >&2
    echo "[DEBUG] Use case: Last Name - Underscore separator" >&2
    echo "[DEBUG] Actual output: $output" >&2

    # Assertions
    if [ "true" = "true" ]; then
        assert_equal "$actual_matched" "true"
        assert_equal "$actual_extracted" "john,doe"
        assert_equal "$actual_raw_remainder" "__report.pdf"
    else
        assert_equal "$actual_matched" "false"
        assert_equal "$actual_extracted" ""
        assert_equal "$actual_raw_remainder" "doe_john_report.pdf"
    fi
}

@test "name-extraction-24 [matcher_function=all_matches]: Last Name - Space separator" {
    run extract_name_from_filename "doe john report.pdf" "john doe" "extract_name_from_filename"

    # Split the output into components
    IFS='|' read -r actual_extracted actual_raw_remainder actual_matched <<< "$(echo "$output" | tail -n1)"

    # Debug output
    echo "[DEBUG] Testing: doe john report.pdf" >&2
    echo "[DEBUG] Expected match: true" >&2
    echo "[DEBUG] Expected extracted: john,doe" >&2
    echo "[DEBUG] Expected raw remainder:   report.pdf" >&2
    echo "[DEBUG] Use case: Last Name - Space separator" >&2
    echo "[DEBUG] Actual output: $output" >&2

    # Assertions
    if [ "true" = "true" ]; then
        assert_equal "$actual_matched" "true"
        assert_equal "$actual_extracted" "john,doe"
        assert_equal "$actual_raw_remainder" "  report.pdf"
    else
        assert_equal "$actual_matched" "false"
        assert_equal "$actual_extracted" ""
        assert_equal "$actual_raw_remainder" "doe john report.pdf"
    fi
}

@test "name-extraction-25 [matcher_function=all_matches]: Last Name - Period separator" {
    run extract_name_from_filename "doe.john.report.pdf" "john doe" "extract_name_from_filename"

    # Split the output into components
    IFS='|' read -r actual_extracted actual_raw_remainder actual_matched <<< "$(echo "$output" | tail -n1)"

    # Debug output
    echo "[DEBUG] Testing: doe.john.report.pdf" >&2
    echo "[DEBUG] Expected match: true" >&2
    echo "[DEBUG] Expected extracted: john,doe" >&2
    echo "[DEBUG] Expected raw remainder: ..report.pdf" >&2
    echo "[DEBUG] Use case: Last Name - Period separator" >&2
    echo "[DEBUG] Actual output: $output" >&2

    # Assertions
    if [ "true" = "true" ]; then
        assert_equal "$actual_matched" "true"
        assert_equal "$actual_extracted" "john,doe"
        assert_equal "$actual_raw_remainder" "..report.pdf"
    else
        assert_equal "$actual_matched" "false"
        assert_equal "$actual_extracted" ""
        assert_equal "$actual_raw_remainder" "doe.john.report.pdf"
    fi
}

@test "name-extraction-26 [matcher_function=all_matches]: Non-standard separator (asterisk)" {
    run extract_name_from_filename "john*doe-report.pdf" "john doe" "extract_name_from_filename"

    # Split the output into components
    IFS='|' read -r actual_extracted actual_raw_remainder actual_matched <<< "$(echo "$output" | tail -n1)"

    # Debug output
    echo "[DEBUG] Testing: john*doe-report.pdf" >&2
    echo "[DEBUG] Expected match: true" >&2
    echo "[DEBUG] Expected extracted: john,doe" >&2
    echo "[DEBUG] Expected raw remainder: *-report.pdf" >&2
    echo "[DEBUG] Use case: Non-standard separator (asterisk)" >&2
    echo "[DEBUG] Actual output: $output" >&2

    # Assertions
    if [ "true" = "true" ]; then
        assert_equal "$actual_matched" "true"
        assert_equal "$actual_extracted" "john,doe"
        assert_equal "$actual_raw_remainder" "*-report.pdf"
    else
        assert_equal "$actual_matched" "false"
        assert_equal "$actual_extracted" ""
        assert_equal "$actual_raw_remainder" "john*doe-report.pdf"
    fi
}

@test "name-extraction-27 [matcher_function=all_matches]: Non-standard separator (at sign)" {
    run extract_name_from_filename "john@doe-report.pdf" "john doe" "extract_name_from_filename"

    # Split the output into components
    IFS='|' read -r actual_extracted actual_raw_remainder actual_matched <<< "$(echo "$output" | tail -n1)"

    # Debug output
    echo "[DEBUG] Testing: john@doe-report.pdf" >&2
    echo "[DEBUG] Expected match: true" >&2
    echo "[DEBUG] Expected extracted: john,doe" >&2
    echo "[DEBUG] Expected raw remainder: @-report.pdf" >&2
    echo "[DEBUG] Use case: Non-standard separator (at sign)" >&2
    echo "[DEBUG] Actual output: $output" >&2

    # Assertions
    if [ "true" = "true" ]; then
        assert_equal "$actual_matched" "true"
        assert_equal "$actual_extracted" "john,doe"
        assert_equal "$actual_raw_remainder" "@-report.pdf"
    else
        assert_equal "$actual_matched" "false"
        assert_equal "$actual_extracted" ""
        assert_equal "$actual_raw_remainder" "john@doe-report.pdf"
    fi
}

@test "name-extraction-28 [matcher_function=all_matches]: Non-standard separator (hash)" {
    run extract_name_from_filename "john#doe-report.pdf" "john doe" "extract_name_from_filename"

    # Split the output into components
    IFS='|' read -r actual_extracted actual_raw_remainder actual_matched <<< "$(echo "$output" | tail -n1)"

    # Debug output
    echo "[DEBUG] Testing: john#doe-report.pdf" >&2
    echo "[DEBUG] Expected match: true" >&2
    echo "[DEBUG] Expected extracted: john,doe" >&2
    echo "[DEBUG] Expected raw remainder: #-report.pdf" >&2
    echo "[DEBUG] Use case: Non-standard separator (hash)" >&2
    echo "[DEBUG] Actual output: $output" >&2

    # Assertions
    if [ "true" = "true" ]; then
        assert_equal "$actual_matched" "true"
        assert_equal "$actual_extracted" "john,doe"
        assert_equal "$actual_raw_remainder" "#-report.pdf"
    else
        assert_equal "$actual_matched" "false"
        assert_equal "$actual_extracted" ""
        assert_equal "$actual_raw_remainder" "john#doe-report.pdf"
    fi
}

@test "name-extraction-29 [matcher_function=all_matches]: Name with numbers/letter substitution" {
    run extract_name_from_filename "j0hn-d03-report.pdf" "john doe" "extract_name_from_filename"

    # Split the output into components
    IFS='|' read -r actual_extracted actual_raw_remainder actual_matched <<< "$(echo "$output" | tail -n1)"

    # Debug output
    echo "[DEBUG] Testing: j0hn-d03-report.pdf" >&2
    echo "[DEBUG] Expected match: true" >&2
    echo "[DEBUG] Expected extracted: j0hn,d03" >&2
    echo "[DEBUG] Expected raw remainder: --report.pdf" >&2
    echo "[DEBUG] Use case: Name with numbers/letter substitution" >&2
    echo "[DEBUG] Actual output: $output" >&2

    # Assertions
    if [ "true" = "true" ]; then
        assert_equal "$actual_matched" "true"
        assert_equal "$actual_extracted" "j0hn,d03"
        assert_equal "$actual_raw_remainder" "--report.pdf"
    else
        assert_equal "$actual_matched" "false"
        assert_equal "$actual_extracted" ""
        assert_equal "$actual_raw_remainder" "j0hn-d03-report.pdf"
    fi
}

@test "name-extraction-30 [matcher_function=all_matches]: Name with accents" {
    run extract_name_from_filename "jôn-döe-report.pdf" "john doe" "extract_name_from_filename"

    # Split the output into components
    IFS='|' read -r actual_extracted actual_raw_remainder actual_matched <<< "$(echo "$output" | tail -n1)"

    # Debug output
    echo "[DEBUG] Testing: jôn-döe-report.pdf" >&2
    echo "[DEBUG] Expected match: true" >&2
    echo "[DEBUG] Expected extracted: döe" >&2
    echo "[DEBUG] Expected raw remainder: jôn--report.pdf" >&2
    echo "[DEBUG] Use case: Name with accents" >&2
    echo "[DEBUG] Actual output: $output" >&2

    # Assertions
    if [ "true" = "true" ]; then
        assert_equal "$actual_matched" "true"
        assert_equal "$actual_extracted" "döe"
        assert_equal "$actual_raw_remainder" "jôn--report.pdf"
    else
        assert_equal "$actual_matched" "false"
        assert_equal "$actual_extracted" ""
        assert_equal "$actual_raw_remainder" "jôn-döe-report.pdf"
    fi
}

@test "name-extraction-31 [matcher_function=all_matches]: Multiple matches (same name twice)" {
    run extract_name_from_filename "john-doe-john-doe-report.pdf" "john doe" "extract_name_from_filename"

    # Split the output into components
    IFS='|' read -r actual_extracted actual_raw_remainder actual_matched <<< "$(echo "$output" | tail -n1)"

    # Debug output
    echo "[DEBUG] Testing: john-doe-john-doe-report.pdf" >&2
    echo "[DEBUG] Expected match: true" >&2
    echo "[DEBUG] Expected extracted: john,john,doe,doe" >&2
    echo "[DEBUG] Expected raw remainder: ----report.pdf" >&2
    echo "[DEBUG] Use case: Multiple matches (same name twice)" >&2
    echo "[DEBUG] Actual output: $output" >&2

    # Assertions
    if [ "true" = "true" ]; then
        assert_equal "$actual_matched" "true"
        assert_equal "$actual_extracted" "john,john,doe,doe"
        assert_equal "$actual_raw_remainder" "----report.pdf"
    else
        assert_equal "$actual_matched" "false"
        assert_equal "$actual_extracted" ""
        assert_equal "$actual_raw_remainder" "john-doe-john-doe-report.pdf"
    fi
}

@test "name-extraction-32 [matcher_function=all_matches]: Multiple matches (full and initials)" {
    run extract_name_from_filename "john-doe-jdoe-report.pdf" "john doe" "extract_name_from_filename"

    # Split the output into components
    IFS='|' read -r actual_extracted actual_raw_remainder actual_matched <<< "$(echo "$output" | tail -n1)"

    # Debug output
    echo "[DEBUG] Testing: john-doe-jdoe-report.pdf" >&2
    echo "[DEBUG] Expected match: true" >&2
    echo "[DEBUG] Expected extracted: jdoe,john,doe" >&2
    echo "[DEBUG] Expected raw remainder: ---report.pdf" >&2
    echo "[DEBUG] Use case: Multiple matches (full and initials)" >&2
    echo "[DEBUG] Actual output: $output" >&2

    # Assertions
    if [ "true" = "true" ]; then
        assert_equal "$actual_matched" "true"
        assert_equal "$actual_extracted" "jdoe,john,doe"
        assert_equal "$actual_raw_remainder" "---report.pdf"
    else
        assert_equal "$actual_matched" "false"
        assert_equal "$actual_extracted" ""
        assert_equal "$actual_raw_remainder" "john-doe-jdoe-report.pdf"
    fi
}

@test "name-extraction-33 [matcher_function=all_matches]: Multiple matches (full and initials)" {
    run extract_name_from_filename "john-doe-jdoe-report-johnd.pdf" "john doe" "extract_name_from_filename"

    # Split the output into components
    IFS='|' read -r actual_extracted actual_raw_remainder actual_matched <<< "$(echo "$output" | tail -n1)"

    # Debug output
    echo "[DEBUG] Testing: john-doe-jdoe-report-johnd.pdf" >&2
    echo "[DEBUG] Expected match: true" >&2
    echo "[DEBUG] Expected extracted: jdoe,johnd,john,doe" >&2
    echo "[DEBUG] Expected raw remainder: ----report.pdf" >&2
    echo "[DEBUG] Use case: Multiple matches (full and initials)" >&2
    echo "[DEBUG] Actual output: $output" >&2

    # Assertions
    if [ "true" = "true" ]; then
        assert_equal "$actual_matched" "true"
        assert_equal "$actual_extracted" "jdoe,johnd,john,doe"
        assert_equal "$actual_raw_remainder" "----report.pdf"
    else
        assert_equal "$actual_matched" "false"
        assert_equal "$actual_extracted" ""
        assert_equal "$actual_raw_remainder" "john-doe-jdoe-report-johnd.pdf"
    fi
}

@test "name-extraction-34 [matcher_function=all_matches]: Multiple matches (initials and full)" {
    run extract_name_from_filename "jdoe-john-doe-report.pdf" "john doe" "extract_name_from_filename"

    # Split the output into components
    IFS='|' read -r actual_extracted actual_raw_remainder actual_matched <<< "$(echo "$output" | tail -n1)"

    # Debug output
    echo "[DEBUG] Testing: jdoe-john-doe-report.pdf" >&2
    echo "[DEBUG] Expected match: true" >&2
    echo "[DEBUG] Expected extracted: jdoe,john,doe" >&2
    echo "[DEBUG] Expected raw remainder: ---report.pdf" >&2
    echo "[DEBUG] Use case: Multiple matches (initials and full)" >&2
    echo "[DEBUG] Actual output: $output" >&2

    # Assertions
    if [ "true" = "true" ]; then
        assert_equal "$actual_matched" "true"
        assert_equal "$actual_extracted" "jdoe,john,doe"
        assert_equal "$actual_raw_remainder" "---report.pdf"
    else
        assert_equal "$actual_matched" "false"
        assert_equal "$actual_extracted" ""
        assert_equal "$actual_raw_remainder" "jdoe-john-doe-report.pdf"
    fi
}

@test "name-extraction-35 [matcher_function=all_matches]: Edge case: empty filename" {
    run extract_name_from_filename ".pdf" "john doe" "extract_name_from_filename"

    # Split the output into components
    IFS='|' read -r actual_extracted actual_raw_remainder actual_matched <<< "$(echo "$output" | tail -n1)"

    # Debug output
    echo "[DEBUG] Testing: .pdf" >&2
    echo "[DEBUG] Expected match: false" >&2
    echo "[DEBUG] Expected extracted: " >&2
    echo "[DEBUG] Expected raw remainder: .pdf" >&2
    echo "[DEBUG] Use case: Edge case: empty filename" >&2
    echo "[DEBUG] Actual output: $output" >&2

    # Assertions
    if [ "false" = "true" ]; then
        assert_equal "$actual_matched" "true"
        assert_equal "$actual_extracted" ""
        assert_equal "$actual_raw_remainder" ".pdf"
    else
        assert_equal "$actual_matched" "false"
        assert_equal "$actual_extracted" ""
        assert_equal "$actual_raw_remainder" ".pdf"
    fi
}

@test "name-extraction-36 [matcher_function=all_matches]: Case: all uppercase" {
    run extract_name_from_filename "JOHN-DOE-report.pdf" "john doe" "extract_name_from_filename"

    # Split the output into components
    IFS='|' read -r actual_extracted actual_raw_remainder actual_matched <<< "$(echo "$output" | tail -n1)"

    # Debug output
    echo "[DEBUG] Testing: JOHN-DOE-report.pdf" >&2
    echo "[DEBUG] Expected match: true" >&2
    echo "[DEBUG] Expected extracted: JOHN,DOE" >&2
    echo "[DEBUG] Expected raw remainder: --report.pdf" >&2
    echo "[DEBUG] Use case: Case: all uppercase" >&2
    echo "[DEBUG] Actual output: $output" >&2

    # Assertions
    if [ "true" = "true" ]; then
        assert_equal "$actual_matched" "true"
        assert_equal "$actual_extracted" "JOHN,DOE"
        assert_equal "$actual_raw_remainder" "--report.pdf"
    else
        assert_equal "$actual_matched" "false"
        assert_equal "$actual_extracted" ""
        assert_equal "$actual_raw_remainder" "JOHN-DOE-report.pdf"
    fi
}

@test "name-extraction-37 [matcher_function=all_matches]: Case: proper case" {
    run extract_name_from_filename "John-Doe-report.pdf" "john doe" "extract_name_from_filename"

    # Split the output into components
    IFS='|' read -r actual_extracted actual_raw_remainder actual_matched <<< "$(echo "$output" | tail -n1)"

    # Debug output
    echo "[DEBUG] Testing: John-Doe-report.pdf" >&2
    echo "[DEBUG] Expected match: true" >&2
    echo "[DEBUG] Expected extracted: John,Doe" >&2
    echo "[DEBUG] Expected raw remainder: --report.pdf" >&2
    echo "[DEBUG] Use case: Case: proper case" >&2
    echo "[DEBUG] Actual output: $output" >&2

    # Assertions
    if [ "true" = "true" ]; then
        assert_equal "$actual_matched" "true"
        assert_equal "$actual_extracted" "John,Doe"
        assert_equal "$actual_raw_remainder" "--report.pdf"
    else
        assert_equal "$actual_matched" "false"
        assert_equal "$actual_extracted" ""
        assert_equal "$actual_raw_remainder" "John-Doe-report.pdf"
    fi
}

@test "name-extraction-38 [matcher_function=all_matches]: Case: mixed case" {
    run extract_name_from_filename "john-DOE-report.pdf" "john doe" "extract_name_from_filename"

    # Split the output into components
    IFS='|' read -r actual_extracted actual_raw_remainder actual_matched <<< "$(echo "$output" | tail -n1)"

    # Debug output
    echo "[DEBUG] Testing: john-DOE-report.pdf" >&2
    echo "[DEBUG] Expected match: true" >&2
    echo "[DEBUG] Expected extracted: john,DOE" >&2
    echo "[DEBUG] Expected raw remainder: --report.pdf" >&2
    echo "[DEBUG] Use case: Case: mixed case" >&2
    echo "[DEBUG] Actual output: $output" >&2

    # Assertions
    if [ "true" = "true" ]; then
        assert_equal "$actual_matched" "true"
        assert_equal "$actual_extracted" "john,DOE"
        assert_equal "$actual_raw_remainder" "--report.pdf"
    else
        assert_equal "$actual_matched" "false"
        assert_equal "$actual_extracted" ""
        assert_equal "$actual_raw_remainder" "john-DOE-report.pdf"
    fi
}

@test "name-extraction-39 [matcher_function=all_matches]: Complex version and date" {
    run extract_name_from_filename "john-doe-report-v1.0-2023.01.01.pdf" "john doe" "extract_name_from_filename"

    # Split the output into components
    IFS='|' read -r actual_extracted actual_raw_remainder actual_matched <<< "$(echo "$output" | tail -n1)"

    # Debug output
    echo "[DEBUG] Testing: john-doe-report-v1.0-2023.01.01.pdf" >&2
    echo "[DEBUG] Expected match: true" >&2
    echo "[DEBUG] Expected extracted: john,doe" >&2
    echo "[DEBUG] Expected raw remainder: --report-v1.0-2023.01.01.pdf" >&2
    echo "[DEBUG] Use case: Complex version and date" >&2
    echo "[DEBUG] Actual output: $output" >&2

    # Assertions
    if [ "true" = "true" ]; then
        assert_equal "$actual_matched" "true"
        assert_equal "$actual_extracted" "john,doe"
        assert_equal "$actual_raw_remainder" "--report-v1.0-2023.01.01.pdf"
    else
        assert_equal "$actual_matched" "false"
        assert_equal "$actual_extracted" ""
        assert_equal "$actual_raw_remainder" "john-doe-report-v1.0-2023.01.01.pdf"
    fi
}

@test "name-extraction-40 [matcher_function=all_matches]: Multiple matches: numbers and accents" {
    run extract_name_from_filename "j0hn-d03-jôn-döe-report.pdf" "john doe" "extract_name_from_filename"

    # Split the output into components
    IFS='|' read -r actual_extracted actual_raw_remainder actual_matched <<< "$(echo "$output" | tail -n1)"

    # Debug output
    echo "[DEBUG] Testing: j0hn-d03-jôn-döe-report.pdf" >&2
    echo "[DEBUG] Expected match: true" >&2
    echo "[DEBUG] Expected extracted: j0hn,d03,döe" >&2
    echo "[DEBUG] Expected raw remainder: --jôn--report.pdf" >&2
    echo "[DEBUG] Use case: Multiple matches: numbers and accents" >&2
    echo "[DEBUG] Actual output: $output" >&2

    # Assertions
    if [ "true" = "true" ]; then
        assert_equal "$actual_matched" "true"
        assert_equal "$actual_extracted" "j0hn,d03,döe"
        assert_equal "$actual_raw_remainder" "--jôn--report.pdf"
    else
        assert_equal "$actual_matched" "false"
        assert_equal "$actual_extracted" ""
        assert_equal "$actual_raw_remainder" "j0hn-d03-jôn-döe-report.pdf"
    fi
}

@test "name-extraction-41 [matcher_function=all_matches]: Edge case: only separators" {
    run extract_name_from_filename "---.pdf" "john doe" "extract_name_from_filename"

    # Split the output into components
    IFS='|' read -r actual_extracted actual_raw_remainder actual_matched <<< "$(echo "$output" | tail -n1)"

    # Debug output
    echo "[DEBUG] Testing: ---.pdf" >&2
    echo "[DEBUG] Expected match: false" >&2
    echo "[DEBUG] Expected extracted: " >&2
    echo "[DEBUG] Expected raw remainder: ---.pdf" >&2
    echo "[DEBUG] Use case: Edge case: only separators" >&2
    echo "[DEBUG] Actual output: $output" >&2

    # Assertions
    if [ "false" = "true" ]; then
        assert_equal "$actual_matched" "true"
        assert_equal "$actual_extracted" ""
        assert_equal "$actual_raw_remainder" "---.pdf"
    else
        assert_equal "$actual_matched" "false"
        assert_equal "$actual_extracted" ""
        assert_equal "$actual_raw_remainder" "---.pdf"
    fi
}

@test "name-extraction-42 [matcher_function=all_matches]: Edge case: only numbers" {
    run extract_name_from_filename "123456.pdf" "john doe" "extract_name_from_filename"

    # Split the output into components
    IFS='|' read -r actual_extracted actual_raw_remainder actual_matched <<< "$(echo "$output" | tail -n1)"

    # Debug output
    echo "[DEBUG] Testing: 123456.pdf" >&2
    echo "[DEBUG] Expected match: false" >&2
    echo "[DEBUG] Expected extracted: " >&2
    echo "[DEBUG] Expected raw remainder: 123456.pdf" >&2
    echo "[DEBUG] Use case: Edge case: only numbers" >&2
    echo "[DEBUG] Actual output: $output" >&2

    # Assertions
    if [ "false" = "true" ]; then
        assert_equal "$actual_matched" "true"
        assert_equal "$actual_extracted" ""
        assert_equal "$actual_raw_remainder" "123456.pdf"
    else
        assert_equal "$actual_matched" "false"
        assert_equal "$actual_extracted" ""
        assert_equal "$actual_raw_remainder" "123456.pdf"
    fi
}

@test "name-extraction-43 [matcher_function=all_matches]: Edge case: only special characters" {
    run extract_name_from_filename "!@#$%^&*().pdf" "john doe" "extract_name_from_filename"

    # Split the output into components
    IFS='|' read -r actual_extracted actual_raw_remainder actual_matched <<< "$(echo "$output" | tail -n1)"

    # Debug output
    echo "[DEBUG] Testing: !@#$%^&*().pdf" >&2
    echo "[DEBUG] Expected match: false" >&2
    echo "[DEBUG] Expected extracted: " >&2
    echo "[DEBUG] Expected raw remainder: !@#$%^&*().pdf" >&2
    echo "[DEBUG] Use case: Edge case: only special characters" >&2
    echo "[DEBUG] Actual output: $output" >&2

    # Assertions
    if [ "false" = "true" ]; then
        assert_equal "$actual_matched" "true"
        assert_equal "$actual_extracted" ""
        assert_equal "$actual_raw_remainder" "!@#$%^&*().pdf"
    else
        assert_equal "$actual_matched" "false"
        assert_equal "$actual_extracted" ""
        assert_equal "$actual_raw_remainder" "!@#$%^&*().pdf"
    fi
}

@test "name-extraction-44 [matcher_function=all_matches]: Multiple consecutive spaces" {
    run extract_name_from_filename "john   doe   report.pdf" "john doe" "extract_name_from_filename"

    # Split the output into components
    IFS='|' read -r actual_extracted actual_raw_remainder actual_matched <<< "$(echo "$output" | tail -n1)"

    # Debug output
    echo "[DEBUG] Testing: john   doe   report.pdf" >&2
    echo "[DEBUG] Expected match: true" >&2
    echo "[DEBUG] Expected extracted: john,doe" >&2
    echo "[DEBUG] Expected raw remainder:       report.pdf" >&2
    echo "[DEBUG] Use case: Multiple consecutive spaces" >&2
    echo "[DEBUG] Actual output: $output" >&2

    # Assertions
    if [ "true" = "true" ]; then
        assert_equal "$actual_matched" "true"
        assert_equal "$actual_extracted" "john,doe"
        assert_equal "$actual_raw_remainder" "      report.pdf"
    else
        assert_equal "$actual_matched" "false"
        assert_equal "$actual_extracted" ""
        assert_equal "$actual_raw_remainder" "john   doe   report.pdf"
    fi
}

@test "name-extraction-45 [matcher_function=all_matches]: Mixed consecutive separators" {
    run extract_name_from_filename "john--doe__report.pdf" "john doe" "extract_name_from_filename"

    # Split the output into components
    IFS='|' read -r actual_extracted actual_raw_remainder actual_matched <<< "$(echo "$output" | tail -n1)"

    # Debug output
    echo "[DEBUG] Testing: john--doe__report.pdf" >&2
    echo "[DEBUG] Expected match: true" >&2
    echo "[DEBUG] Expected extracted: john,doe" >&2
    echo "[DEBUG] Expected raw remainder: --__report.pdf" >&2
    echo "[DEBUG] Use case: Mixed consecutive separators" >&2
    echo "[DEBUG] Actual output: $output" >&2

    # Assertions
    if [ "true" = "true" ]; then
        assert_equal "$actual_matched" "true"
        assert_equal "$actual_extracted" "john,doe"
        assert_equal "$actual_raw_remainder" "--__report.pdf"
    else
        assert_equal "$actual_matched" "false"
        assert_equal "$actual_extracted" ""
        assert_equal "$actual_raw_remainder" "john--doe__report.pdf"
    fi
}

@test "name-extraction-46 [matcher_function=all_matches]: Mixed separators with spaces and punctuation" {
    run extract_name_from_filename "john . doe - report.pdf" "john doe" "extract_name_from_filename"

    # Split the output into components
    IFS='|' read -r actual_extracted actual_raw_remainder actual_matched <<< "$(echo "$output" | tail -n1)"

    # Debug output
    echo "[DEBUG] Testing: john . doe - report.pdf" >&2
    echo "[DEBUG] Expected match: true" >&2
    echo "[DEBUG] Expected extracted: john,doe" >&2
    echo "[DEBUG] Expected raw remainder:  .  - report.pdf" >&2
    echo "[DEBUG] Use case: Mixed separators with spaces and punctuation" >&2
    echo "[DEBUG] Actual output: $output" >&2

    # Assertions
    if [ "true" = "true" ]; then
        assert_equal "$actual_matched" "true"
        assert_equal "$actual_extracted" "john,doe"
        assert_equal "$actual_raw_remainder" " .  - report.pdf"
    else
        assert_equal "$actual_matched" "false"
        assert_equal "$actual_extracted" ""
        assert_equal "$actual_raw_remainder" "john . doe - report.pdf"
    fi
}

@test "name-extraction-47 [matcher_function=all_matches]: Leading space" {
    run extract_name_from_filename " john doe report.pdf" "john doe" "extract_name_from_filename"

    # Split the output into components
    IFS='|' read -r actual_extracted actual_raw_remainder actual_matched <<< "$(echo "$output" | tail -n1)"

    # Debug output
    echo "[DEBUG] Testing:  john doe report.pdf" >&2
    echo "[DEBUG] Expected match: true" >&2
    echo "[DEBUG] Expected extracted: john,doe" >&2
    echo "[DEBUG] Expected raw remainder:    report.pdf" >&2
    echo "[DEBUG] Use case: Leading space" >&2
    echo "[DEBUG] Actual output: $output" >&2

    # Assertions
    if [ "true" = "true" ]; then
        assert_equal "$actual_matched" "true"
        assert_equal "$actual_extracted" "john,doe"
        assert_equal "$actual_raw_remainder" "   report.pdf"
    else
        assert_equal "$actual_matched" "false"
        assert_equal "$actual_extracted" ""
        assert_equal "$actual_raw_remainder" " john doe report.pdf"
    fi
}

@test "name-extraction-48 [matcher_function=all_matches]: Trailing space before extension" {
    run extract_name_from_filename "john doe report .pdf" "john doe" "extract_name_from_filename"

    # Split the output into components
    IFS='|' read -r actual_extracted actual_raw_remainder actual_matched <<< "$(echo "$output" | tail -n1)"

    # Debug output
    echo "[DEBUG] Testing: john doe report .pdf" >&2
    echo "[DEBUG] Expected match: true" >&2
    echo "[DEBUG] Expected extracted: john,doe" >&2
    echo "[DEBUG] Expected raw remainder:   report .pdf" >&2
    echo "[DEBUG] Use case: Trailing space before extension" >&2
    echo "[DEBUG] Actual output: $output" >&2

    # Assertions
    if [ "true" = "true" ]; then
        assert_equal "$actual_matched" "true"
        assert_equal "$actual_extracted" "john,doe"
        assert_equal "$actual_raw_remainder" "  report .pdf"
    else
        assert_equal "$actual_matched" "false"
        assert_equal "$actual_extracted" ""
        assert_equal "$actual_raw_remainder" "john doe report .pdf"
    fi
}

@test "name-extraction-49 [matcher_function=all_matches]: Mixed separators (hyphen, underscore, space)" {
    run extract_name_from_filename "john-doe_report report.pdf" "john doe" "extract_name_from_filename"

    # Split the output into components
    IFS='|' read -r actual_extracted actual_raw_remainder actual_matched <<< "$(echo "$output" | tail -n1)"

    # Debug output
    echo "[DEBUG] Testing: john-doe_report report.pdf" >&2
    echo "[DEBUG] Expected match: true" >&2
    echo "[DEBUG] Expected extracted: john,doe" >&2
    echo "[DEBUG] Expected raw remainder: -_report report.pdf" >&2
    echo "[DEBUG] Use case: Mixed separators (hyphen, underscore, space)" >&2
    echo "[DEBUG] Actual output: $output" >&2

    # Assertions
    if [ "true" = "true" ]; then
        assert_equal "$actual_matched" "true"
        assert_equal "$actual_extracted" "john,doe"
        assert_equal "$actual_raw_remainder" "-_report report.pdf"
    else
        assert_equal "$actual_matched" "false"
        assert_equal "$actual_extracted" ""
        assert_equal "$actual_raw_remainder" "john-doe_report report.pdf"
    fi
}

# --- Filename Cleaning Tests --- #

@test "name-clean_filename-1 [matcher_function=first_name]: First Name only" {
    run clean_filename_remainder "-doe-report.pdf"

    # Debug output
    echo "[DEBUG] Testing remainder: -doe-report.pdf" >&2
    echo "[DEBUG] Expected cleaned: doe-report.pdf" >&2
    echo "[DEBUG] Use case: First Name only" >&2
    echo "[DEBUG] Actual output: $output" >&2

    # Assertions
    assert_equal "$output" "doe-report.pdf"
}

@test "name-clean_filename-2 [matcher_function=first_name]: First Name only" {
    run clean_filename_remainder " Doe 20240525 report.pdf"

    # Debug output
    echo "[DEBUG] Testing remainder:  Doe 20240525 report.pdf" >&2
    echo "[DEBUG] Expected cleaned: Doe 20240525 report.pdf" >&2
    echo "[DEBUG] Use case: First Name only" >&2
    echo "[DEBUG] Actual output: $output" >&2

    # Assertions
    assert_equal "$output" "Doe 20240525 report.pdf"
}

@test "name-clean_filename-3 [matcher_function=last_name]: Last Name only" {
    run clean_filename_remainder "john--report.pdf"

    # Debug output
    echo "[DEBUG] Testing remainder: john--report.pdf" >&2
    echo "[DEBUG] Expected cleaned: john-report.pdf" >&2
    echo "[DEBUG] Use case: Last Name only" >&2
    echo "[DEBUG] Actual output: $output" >&2

    # Assertions
    assert_equal "$output" "john-report.pdf"
}

@test "name-clean_filename-4 [matcher_function=last_name]: Last Name only" {
    run clean_filename_remainder "John  20240525 report.pdf"

    # Debug output
    echo "[DEBUG] Testing remainder: John  20240525 report.pdf" >&2
    echo "[DEBUG] Expected cleaned: John 20240525 report.pdf" >&2
    echo "[DEBUG] Use case: Last Name only" >&2
    echo "[DEBUG] Actual output: $output" >&2

    # Assertions
    assert_equal "$output" "John 20240525 report.pdf"
}

@test "name-clean_filename-5 [matcher_function=initials]: Both Initials - Hyphen separator" {
    run clean_filename_remainder "-report.pdf"

    # Debug output
    echo "[DEBUG] Testing remainder: -report.pdf" >&2
    echo "[DEBUG] Expected cleaned: report.pdf" >&2
    echo "[DEBUG] Use case: Both Initials - Hyphen separator" >&2
    echo "[DEBUG] Actual output: $output" >&2

    # Assertions
    assert_equal "$output" "report.pdf"
}

@test "name-clean_filename-6 [matcher_function=initials]: Both Initials - Period separator" {
    run clean_filename_remainder "Home  report.pdf"

    # Debug output
    echo "[DEBUG] Testing remainder: Home  report.pdf" >&2
    echo "[DEBUG] Expected cleaned: Home report.pdf" >&2
    echo "[DEBUG] Use case: Both Initials - Period separator" >&2
    echo "[DEBUG] Actual output: $output" >&2

    # Assertions
    assert_equal "$output" "Home report.pdf"
}

@test "name-clean_filename-7 [matcher_function=initials]: Both Initials - Space separator" {
    run clean_filename_remainder "File  report.pdf"

    # Debug output
    echo "[DEBUG] Testing remainder: File  report.pdf" >&2
    echo "[DEBUG] Expected cleaned: File report.pdf" >&2
    echo "[DEBUG] Use case: Both Initials - Space separator" >&2
    echo "[DEBUG] Actual output: $output" >&2

    # Assertions
    assert_equal "$output" "File report.pdf"
}

@test "name-clean_filename-8 [matcher_function=initials]: Both Initials - Underscore separator" {
    run clean_filename_remainder "_report.pdf"

    # Debug output
    echo "[DEBUG] Testing remainder: _report.pdf" >&2
    echo "[DEBUG] Expected cleaned: report.pdf" >&2
    echo "[DEBUG] Use case: Both Initials - Underscore separator" >&2
    echo "[DEBUG] Actual output: $output" >&2

    # Assertions
    assert_equal "$output" "report.pdf"
}

@test "name-clean_filename-9 [matcher_function=initials]: Both Initials - Underscore separator" {
    run clean_filename_remainder "File _report.pdf"

    # Debug output
    echo "[DEBUG] Testing remainder: File _report.pdf" >&2
    echo "[DEBUG] Expected cleaned: File report.pdf" >&2
    echo "[DEBUG] Use case: Both Initials - Underscore separator" >&2
    echo "[DEBUG] Actual output: $output" >&2

    # Assertions
    assert_equal "$output" "File report.pdf"
}

@test "name-clean_filename-10 [matcher_function=shorthand]: First Initial + Last Name - Hyphen separator" {
    run clean_filename_remainder "-report.pdf"

    # Debug output
    echo "[DEBUG] Testing remainder: -report.pdf" >&2
    echo "[DEBUG] Expected cleaned: report.pdf" >&2
    echo "[DEBUG] Use case: First Initial + Last Name - Hyphen separator" >&2
    echo "[DEBUG] Actual output: $output" >&2

    # Assertions
    assert_equal "$output" "report.pdf"
}

@test "name-clean_filename-11 [matcher_function=shorthand]: First Initial + Last Name - Underscore separator" {
    run clean_filename_remainder "_report.pdf"

    # Debug output
    echo "[DEBUG] Testing remainder: _report.pdf" >&2
    echo "[DEBUG] Expected cleaned: report.pdf" >&2
    echo "[DEBUG] Use case: First Initial + Last Name - Underscore separator" >&2
    echo "[DEBUG] Actual output: $output" >&2

    # Assertions
    assert_equal "$output" "report.pdf"
}

@test "name-clean_filename-12 [matcher_function=shorthand]: First Initial + Last Name - Space separator" {
    run clean_filename_remainder " report.pdf"

    # Debug output
    echo "[DEBUG] Testing remainder:  report.pdf" >&2
    echo "[DEBUG] Expected cleaned: report.pdf" >&2
    echo "[DEBUG] Use case: First Initial + Last Name - Space separator" >&2
    echo "[DEBUG] Actual output: $output" >&2

    # Assertions
    assert_equal "$output" "report.pdf"
}

@test "name-clean_filename-13 [matcher_function=shorthand]: First Initial + Last Name - Period separator" {
    run clean_filename_remainder ".report.pdf"

    # Debug output
    echo "[DEBUG] Testing remainder: .report.pdf" >&2
    echo "[DEBUG] Expected cleaned: report.pdf" >&2
    echo "[DEBUG] Use case: First Initial + Last Name - Period separator" >&2
    echo "[DEBUG] Actual output: $output" >&2

    # Assertions
    assert_equal "$output" "report.pdf"
}

@test "name-clean_filename-14 [matcher_function=shorthand]: First Name + Last Initial - Hyphen separator" {
    run clean_filename_remainder "-report.pdf"

    # Debug output
    echo "[DEBUG] Testing remainder: -report.pdf" >&2
    echo "[DEBUG] Expected cleaned: report.pdf" >&2
    echo "[DEBUG] Use case: First Name + Last Initial - Hyphen separator" >&2
    echo "[DEBUG] Actual output: $output" >&2

    # Assertions
    assert_equal "$output" "report.pdf"
}

@test "name-clean_filename-15 [matcher_function=shorthand]: First Name + Last Initial - Underscore separator" {
    run clean_filename_remainder "_report.pdf"

    # Debug output
    echo "[DEBUG] Testing remainder: _report.pdf" >&2
    echo "[DEBUG] Expected cleaned: report.pdf" >&2
    echo "[DEBUG] Use case: First Name + Last Initial - Underscore separator" >&2
    echo "[DEBUG] Actual output: $output" >&2

    # Assertions
    assert_equal "$output" "report.pdf"
}

@test "name-clean_filename-16 [matcher_function=shorthand]: First Name + Last Initial - Space separator" {
    run clean_filename_remainder " report.pdf"

    # Debug output
    echo "[DEBUG] Testing remainder:  report.pdf" >&2
    echo "[DEBUG] Expected cleaned: report.pdf" >&2
    echo "[DEBUG] Use case: First Name + Last Initial - Space separator" >&2
    echo "[DEBUG] Actual output: $output" >&2

    # Assertions
    assert_equal "$output" "report.pdf"
}

@test "name-clean_filename-17 [matcher_function=shorthand]: First Name + Last Initial - Period separator" {
    run clean_filename_remainder ".report.pdf"

    # Debug output
    echo "[DEBUG] Testing remainder: .report.pdf" >&2
    echo "[DEBUG] Expected cleaned: report.pdf" >&2
    echo "[DEBUG] Use case: First Name + Last Initial - Period separator" >&2
    echo "[DEBUG] Actual output: $output" >&2

    # Assertions
    assert_equal "$output" "report.pdf"
}

@test "name-clean_filename-18 [matcher_function=all_matches]: First Name - Hyphen separator" {
    run clean_filename_remainder "--report.pdf"

    # Debug output
    echo "[DEBUG] Testing remainder: --report.pdf" >&2
    echo "[DEBUG] Expected cleaned: report.pdf" >&2
    echo "[DEBUG] Use case: First Name - Hyphen separator" >&2
    echo "[DEBUG] Actual output: $output" >&2

    # Assertions
    assert_equal "$output" "report.pdf"
}

@test "name-clean_filename-19 [matcher_function=all_matches]: First Name - Underscore separator" {
    run clean_filename_remainder "__report.pdf"

    # Debug output
    echo "[DEBUG] Testing remainder: __report.pdf" >&2
    echo "[DEBUG] Expected cleaned: report.pdf" >&2
    echo "[DEBUG] Use case: First Name - Underscore separator" >&2
    echo "[DEBUG] Actual output: $output" >&2

    # Assertions
    assert_equal "$output" "report.pdf"
}

@test "name-clean_filename-20 [matcher_function=all_matches]: First Name - Space separator" {
    run clean_filename_remainder "  report.pdf"

    # Debug output
    echo "[DEBUG] Testing remainder:   report.pdf" >&2
    echo "[DEBUG] Expected cleaned: report.pdf" >&2
    echo "[DEBUG] Use case: First Name - Space separator" >&2
    echo "[DEBUG] Actual output: $output" >&2

    # Assertions
    assert_equal "$output" "report.pdf"
}

@test "name-clean_filename-21 [matcher_function=all_matches]: First Name - Period separator" {
    run clean_filename_remainder "..report.pdf"

    # Debug output
    echo "[DEBUG] Testing remainder: ..report.pdf" >&2
    echo "[DEBUG] Expected cleaned: report.pdf" >&2
    echo "[DEBUG] Use case: First Name - Period separator" >&2
    echo "[DEBUG] Actual output: $output" >&2

    # Assertions
    assert_equal "$output" "report.pdf"
}

@test "name-clean_filename-22 [matcher_function=all_matches]: Last Name - Hyphen separator" {
    run clean_filename_remainder "--report.pdf"

    # Debug output
    echo "[DEBUG] Testing remainder: --report.pdf" >&2
    echo "[DEBUG] Expected cleaned: report.pdf" >&2
    echo "[DEBUG] Use case: Last Name - Hyphen separator" >&2
    echo "[DEBUG] Actual output: $output" >&2

    # Assertions
    assert_equal "$output" "report.pdf"
}

@test "name-clean_filename-23 [matcher_function=all_matches]: Last Name - Underscore separator" {
    run clean_filename_remainder "__report.pdf"

    # Debug output
    echo "[DEBUG] Testing remainder: __report.pdf" >&2
    echo "[DEBUG] Expected cleaned: report.pdf" >&2
    echo "[DEBUG] Use case: Last Name - Underscore separator" >&2
    echo "[DEBUG] Actual output: $output" >&2

    # Assertions
    assert_equal "$output" "report.pdf"
}

@test "name-clean_filename-24 [matcher_function=all_matches]: Last Name - Space separator" {
    run clean_filename_remainder "  report.pdf"

    # Debug output
    echo "[DEBUG] Testing remainder:   report.pdf" >&2
    echo "[DEBUG] Expected cleaned: report.pdf" >&2
    echo "[DEBUG] Use case: Last Name - Space separator" >&2
    echo "[DEBUG] Actual output: $output" >&2

    # Assertions
    assert_equal "$output" "report.pdf"
}

@test "name-clean_filename-25 [matcher_function=all_matches]: Last Name - Period separator" {
    run clean_filename_remainder "..report.pdf"

    # Debug output
    echo "[DEBUG] Testing remainder: ..report.pdf" >&2
    echo "[DEBUG] Expected cleaned: report.pdf" >&2
    echo "[DEBUG] Use case: Last Name - Period separator" >&2
    echo "[DEBUG] Actual output: $output" >&2

    # Assertions
    assert_equal "$output" "report.pdf"
}

@test "name-clean_filename-26 [matcher_function=all_matches]: Non-standard separator (asterisk)" {
    run clean_filename_remainder "*-report.pdf"

    # Debug output
    echo "[DEBUG] Testing remainder: *-report.pdf" >&2
    echo "[DEBUG] Expected cleaned: *-report.pdf" >&2
    echo "[DEBUG] Use case: Non-standard separator (asterisk)" >&2
    echo "[DEBUG] Actual output: $output" >&2

    # Assertions
    assert_equal "$output" "*-report.pdf"
}

@test "name-clean_filename-27 [matcher_function=all_matches]: Non-standard separator (at sign)" {
    run clean_filename_remainder "@-report.pdf"

    # Debug output
    echo "[DEBUG] Testing remainder: @-report.pdf" >&2
    echo "[DEBUG] Expected cleaned: @-report.pdf" >&2
    echo "[DEBUG] Use case: Non-standard separator (at sign)" >&2
    echo "[DEBUG] Actual output: $output" >&2

    # Assertions
    assert_equal "$output" "@-report.pdf"
}

@test "name-clean_filename-28 [matcher_function=all_matches]: Non-standard separator (hash)" {
    run clean_filename_remainder "#-report.pdf"

    # Debug output
    echo "[DEBUG] Testing remainder: #-report.pdf" >&2
    echo "[DEBUG] Expected cleaned: #-report.pdf" >&2
    echo "[DEBUG] Use case: Non-standard separator (hash)" >&2
    echo "[DEBUG] Actual output: $output" >&2

    # Assertions
    assert_equal "$output" "#-report.pdf"
}

@test "name-clean_filename-29 [matcher_function=all_matches]: Name with numbers/letter substitution" {
    run clean_filename_remainder "--report.pdf"

    # Debug output
    echo "[DEBUG] Testing remainder: --report.pdf" >&2
    echo "[DEBUG] Expected cleaned: report.pdf" >&2
    echo "[DEBUG] Use case: Name with numbers/letter substitution" >&2
    echo "[DEBUG] Actual output: $output" >&2

    # Assertions
    assert_equal "$output" "report.pdf"
}

@test "name-clean_filename-30 [matcher_function=all_matches]: Name with accents" {
    run clean_filename_remainder "jôn--report.pdf"

    # Debug output
    echo "[DEBUG] Testing remainder: jôn--report.pdf" >&2
    echo "[DEBUG] Expected cleaned: jôn-report.pdf" >&2
    echo "[DEBUG] Use case: Name with accents" >&2
    echo "[DEBUG] Actual output: $output" >&2

    # Assertions
    assert_equal "$output" "jôn-report.pdf"
}

@test "name-clean_filename-31 [matcher_function=all_matches]: Multiple matches (same name twice)" {
    run clean_filename_remainder "----report.pdf"

    # Debug output
    echo "[DEBUG] Testing remainder: ----report.pdf" >&2
    echo "[DEBUG] Expected cleaned: report.pdf" >&2
    echo "[DEBUG] Use case: Multiple matches (same name twice)" >&2
    echo "[DEBUG] Actual output: $output" >&2

    # Assertions
    assert_equal "$output" "report.pdf"
}

@test "name-clean_filename-32 [matcher_function=all_matches]: Multiple matches (full and initials)" {
    run clean_filename_remainder "---report.pdf"

    # Debug output
    echo "[DEBUG] Testing remainder: ---report.pdf" >&2
    echo "[DEBUG] Expected cleaned: report.pdf" >&2
    echo "[DEBUG] Use case: Multiple matches (full and initials)" >&2
    echo "[DEBUG] Actual output: $output" >&2

    # Assertions
    assert_equal "$output" "report.pdf"
}

@test "name-clean_filename-33 [matcher_function=all_matches]: Multiple matches (full and initials)" {
    run clean_filename_remainder "----report.pdf"

    # Debug output
    echo "[DEBUG] Testing remainder: ----report.pdf" >&2
    echo "[DEBUG] Expected cleaned: report.pdf" >&2
    echo "[DEBUG] Use case: Multiple matches (full and initials)" >&2
    echo "[DEBUG] Actual output: $output" >&2

    # Assertions
    assert_equal "$output" "report.pdf"
}

@test "name-clean_filename-34 [matcher_function=all_matches]: Multiple matches (initials and full)" {
    run clean_filename_remainder "---report.pdf"

    # Debug output
    echo "[DEBUG] Testing remainder: ---report.pdf" >&2
    echo "[DEBUG] Expected cleaned: report.pdf" >&2
    echo "[DEBUG] Use case: Multiple matches (initials and full)" >&2
    echo "[DEBUG] Actual output: $output" >&2

    # Assertions
    assert_equal "$output" "report.pdf"
}

@test "name-clean_filename-35 [matcher_function=all_matches]: Edge case: empty filename" {
    run clean_filename_remainder ".pdf"

    # Debug output
    echo "[DEBUG] Testing remainder: .pdf" >&2
    echo "[DEBUG] Expected cleaned: .pdf" >&2
    echo "[DEBUG] Use case: Edge case: empty filename" >&2
    echo "[DEBUG] Actual output: $output" >&2

    # Assertions
    assert_equal "$output" ".pdf"
}

@test "name-clean_filename-36 [matcher_function=all_matches]: Case: all uppercase" {
    run clean_filename_remainder "--report.pdf"

    # Debug output
    echo "[DEBUG] Testing remainder: --report.pdf" >&2
    echo "[DEBUG] Expected cleaned: report.pdf" >&2
    echo "[DEBUG] Use case: Case: all uppercase" >&2
    echo "[DEBUG] Actual output: $output" >&2

    # Assertions
    assert_equal "$output" "report.pdf"
}

@test "name-clean_filename-37 [matcher_function=all_matches]: Case: proper case" {
    run clean_filename_remainder "--report.pdf"

    # Debug output
    echo "[DEBUG] Testing remainder: --report.pdf" >&2
    echo "[DEBUG] Expected cleaned: report.pdf" >&2
    echo "[DEBUG] Use case: Case: proper case" >&2
    echo "[DEBUG] Actual output: $output" >&2

    # Assertions
    assert_equal "$output" "report.pdf"
}

@test "name-clean_filename-38 [matcher_function=all_matches]: Case: mixed case" {
    run clean_filename_remainder "--report.pdf"

    # Debug output
    echo "[DEBUG] Testing remainder: --report.pdf" >&2
    echo "[DEBUG] Expected cleaned: report.pdf" >&2
    echo "[DEBUG] Use case: Case: mixed case" >&2
    echo "[DEBUG] Actual output: $output" >&2

    # Assertions
    assert_equal "$output" "report.pdf"
}

@test "name-clean_filename-39 [matcher_function=all_matches]: Complex version and date" {
    run clean_filename_remainder "--report-v1.0-2023.01.01.pdf"

    # Debug output
    echo "[DEBUG] Testing remainder: --report-v1.0-2023.01.01.pdf" >&2
    echo "[DEBUG] Expected cleaned: report-v1.0-2023.01.01.pdf" >&2
    echo "[DEBUG] Use case: Complex version and date" >&2
    echo "[DEBUG] Actual output: $output" >&2

    # Assertions
    assert_equal "$output" "report-v1.0-2023.01.01.pdf"
}

@test "name-clean_filename-40 [matcher_function=all_matches]: Multiple matches: numbers and accents" {
    run clean_filename_remainder "--jôn--report.pdf"

    # Debug output
    echo "[DEBUG] Testing remainder: --jôn--report.pdf" >&2
    echo "[DEBUG] Expected cleaned: jôn-report.pdf" >&2
    echo "[DEBUG] Use case: Multiple matches: numbers and accents" >&2
    echo "[DEBUG] Actual output: $output" >&2

    # Assertions
    assert_equal "$output" "jôn-report.pdf"
}

@test "name-clean_filename-41 [matcher_function=all_matches]: Edge case: only separators" {
    run clean_filename_remainder "---.pdf"

    # Debug output
    echo "[DEBUG] Testing remainder: ---.pdf" >&2
    echo "[DEBUG] Expected cleaned: .pdf" >&2
    echo "[DEBUG] Use case: Edge case: only separators" >&2
    echo "[DEBUG] Actual output: $output" >&2

    # Assertions
    assert_equal "$output" ".pdf"
}

@test "name-clean_filename-42 [matcher_function=all_matches]: Edge case: only numbers" {
    run clean_filename_remainder "123456.pdf"

    # Debug output
    echo "[DEBUG] Testing remainder: 123456.pdf" >&2
    echo "[DEBUG] Expected cleaned: 123456.pdf" >&2
    echo "[DEBUG] Use case: Edge case: only numbers" >&2
    echo "[DEBUG] Actual output: $output" >&2

    # Assertions
    assert_equal "$output" "123456.pdf"
}

@test "name-clean_filename-43 [matcher_function=all_matches]: Edge case: only special characters" {
    run clean_filename_remainder "!@#$%^&*().pdf"

    # Debug output
    echo "[DEBUG] Testing remainder: !@#$%^&*().pdf" >&2
    echo "[DEBUG] Expected cleaned: !@#$%^&*().pdf" >&2
    echo "[DEBUG] Use case: Edge case: only special characters" >&2
    echo "[DEBUG] Actual output: $output" >&2

    # Assertions
    assert_equal "$output" "!@#$%^&*().pdf"
}

@test "name-clean_filename-44 [matcher_function=all_matches]: Multiple consecutive spaces" {
    run clean_filename_remainder "      report.pdf"

    # Debug output
    echo "[DEBUG] Testing remainder:       report.pdf" >&2
    echo "[DEBUG] Expected cleaned: report.pdf" >&2
    echo "[DEBUG] Use case: Multiple consecutive spaces" >&2
    echo "[DEBUG] Actual output: $output" >&2

    # Assertions
    assert_equal "$output" "report.pdf"
}

@test "name-clean_filename-45 [matcher_function=all_matches]: Mixed consecutive separators" {
    run clean_filename_remainder "--__report.pdf"

    # Debug output
    echo "[DEBUG] Testing remainder: --__report.pdf" >&2
    echo "[DEBUG] Expected cleaned: report.pdf" >&2
    echo "[DEBUG] Use case: Mixed consecutive separators" >&2
    echo "[DEBUG] Actual output: $output" >&2

    # Assertions
    assert_equal "$output" "report.pdf"
}

@test "name-clean_filename-46 [matcher_function=all_matches]: Mixed separators with spaces and punctuation" {
    run clean_filename_remainder " .  - report.pdf"

    # Debug output
    echo "[DEBUG] Testing remainder:  .  - report.pdf" >&2
    echo "[DEBUG] Expected cleaned: report.pdf" >&2
    echo "[DEBUG] Use case: Mixed separators with spaces and punctuation" >&2
    echo "[DEBUG] Actual output: $output" >&2

    # Assertions
    assert_equal "$output" "report.pdf"
}

@test "name-clean_filename-47 [matcher_function=all_matches]: Leading space" {
    run clean_filename_remainder "   report.pdf"

    # Debug output
    echo "[DEBUG] Testing remainder:    report.pdf" >&2
    echo "[DEBUG] Expected cleaned: report.pdf" >&2
    echo "[DEBUG] Use case: Leading space" >&2
    echo "[DEBUG] Actual output: $output" >&2

    # Assertions
    assert_equal "$output" "report.pdf"
}

@test "name-clean_filename-48 [matcher_function=all_matches]: Trailing space before extension" {
    run clean_filename_remainder "  report .pdf"

    # Debug output
    echo "[DEBUG] Testing remainder:   report .pdf" >&2
    echo "[DEBUG] Expected cleaned: report.pdf" >&2
    echo "[DEBUG] Use case: Trailing space before extension" >&2
    echo "[DEBUG] Actual output: $output" >&2

    # Assertions
    assert_equal "$output" "report.pdf"
}

@test "name-clean_filename-49 [matcher_function=all_matches]: Mixed separators (hyphen, underscore, space)" {
    run clean_filename_remainder "-_report report.pdf"

    # Debug output
    echo "[DEBUG] Testing remainder: -_report report.pdf" >&2
    echo "[DEBUG] Expected cleaned: report report.pdf" >&2
    echo "[DEBUG] Use case: Mixed separators (hyphen, underscore, space)" >&2
    echo "[DEBUG] Actual output: $output" >&2

    # Assertions
    assert_equal "$output" "report report.pdf"
}

