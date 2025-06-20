#!/usr/bin/env bats

# Load test helper functions
load "${BATS_TEST_DIRNAME}/../test_helper/bats-support/load.bash"
load "${BATS_TEST_DIRNAME}/../test_helper/bats-assert/load.bash"
load "${BATS_TEST_DIRNAME}/../test_helper/bats-file/load.bash"

# Source the function to test
source "${BATS_TEST_DIRNAME}/../../core/utils/date_utils.sh"

@test "date-extraction-1: ISO-Date" {
    run extract_date_from_filename "report-2023-01-15.pdf"

    # Split the output into components
    IFS='|' read -r actual_extracted actual_raw_remainder actual_matched <<< "$output"

    # Debug output
    echo "[DEBUG] Testing: report-2023-01-15.pdf" >&2
    echo "[DEBUG] Expected match: true" >&2
    echo "[DEBUG] Expected extracted: 2023-01-15" >&2
    echo "[DEBUG] Expected raw remainder: report-.pdf" >&2
    echo "[DEBUG] Use case: ISO-Date" >&2
    echo "[DEBUG] Actual output: $output" >&2

    # Assertions
    if [ "true" = "true" ]; then
        assert_equal "$actual_matched" "true"
        assert_equal "$actual_extracted" "2023-01-15"
        assert_equal "$actual_raw_remainder" "report-.pdf"
    else
        assert_equal "$actual_matched" "false"
        assert_equal "$actual_extracted" ""
        assert_equal "$actual_raw_remainder" "report-2023-01-15.pdf"
    fi
}

@test "date-extraction-2: YYYYMMDD" {
    run extract_date_from_filename "client-notes_20240320.txt"

    # Split the output into components
    IFS='|' read -r actual_extracted actual_raw_remainder actual_matched <<< "$output"

    # Debug output
    echo "[DEBUG] Testing: client-notes_20240320.txt" >&2
    echo "[DEBUG] Expected match: true" >&2
    echo "[DEBUG] Expected extracted: 2024-03-20" >&2
    echo "[DEBUG] Expected raw remainder: client-notes_.txt" >&2
    echo "[DEBUG] Use case: YYYYMMDD" >&2
    echo "[DEBUG] Actual output: $output" >&2

    # Assertions
    if [ "true" = "true" ]; then
        assert_equal "$actual_matched" "true"
        assert_equal "$actual_extracted" "2024-03-20"
        assert_equal "$actual_raw_remainder" "client-notes_.txt"
    else
        assert_equal "$actual_matched" "false"
        assert_equal "$actual_extracted" ""
        assert_equal "$actual_raw_remainder" "client-notes_20240320.txt"
    fi
}

@test "date-extraction-3: MM-DD-YYYY" {
    run extract_date_from_filename "05-25-2023_summary.docx"

    # Split the output into components
    IFS='|' read -r actual_extracted actual_raw_remainder actual_matched <<< "$output"

    # Debug output
    echo "[DEBUG] Testing: 05-25-2023_summary.docx" >&2
    echo "[DEBUG] Expected match: true" >&2
    echo "[DEBUG] Expected extracted: 2023-05-25" >&2
    echo "[DEBUG] Expected raw remainder: _summary.docx" >&2
    echo "[DEBUG] Use case: MM-DD-YYYY" >&2
    echo "[DEBUG] Actual output: $output" >&2

    # Assertions
    if [ "true" = "true" ]; then
        assert_equal "$actual_matched" "true"
        assert_equal "$actual_extracted" "2023-05-25"
        assert_equal "$actual_raw_remainder" "_summary.docx"
    else
        assert_equal "$actual_matched" "false"
        assert_equal "$actual_extracted" ""
        assert_equal "$actual_raw_remainder" "05-25-2023_summary.docx"
    fi
}

@test "date-extraction-4: MMDDYYYY-no-sep" {
    run extract_date_from_filename "archive 10202024.zip"

    # Split the output into components
    IFS='|' read -r actual_extracted actual_raw_remainder actual_matched <<< "$output"

    # Debug output
    echo "[DEBUG] Testing: archive 10202024.zip" >&2
    echo "[DEBUG] Expected match: true" >&2
    echo "[DEBUG] Expected extracted: 2024-10-20" >&2
    echo "[DEBUG] Expected raw remainder: archive .zip" >&2
    echo "[DEBUG] Use case: MMDDYYYY-no-sep" >&2
    echo "[DEBUG] Actual output: $output" >&2

    # Assertions
    if [ "true" = "true" ]; then
        assert_equal "$actual_matched" "true"
        assert_equal "$actual_extracted" "2024-10-20"
        assert_equal "$actual_raw_remainder" "archive .zip"
    else
        assert_equal "$actual_matched" "false"
        assert_equal "$actual_extracted" ""
        assert_equal "$actual_raw_remainder" "archive 10202024.zip"
    fi
}

@test "date-extraction-5: No-Date" {
    run extract_date_from_filename "no_date_in_this_file.txt"

    # Split the output into components
    IFS='|' read -r actual_extracted actual_raw_remainder actual_matched <<< "$output"

    # Debug output
    echo "[DEBUG] Testing: no_date_in_this_file.txt" >&2
    echo "[DEBUG] Expected match: false" >&2
    echo "[DEBUG] Expected extracted: " >&2
    echo "[DEBUG] Expected raw remainder: no_date_in_this_file.txt" >&2
    echo "[DEBUG] Use case: No-Date" >&2
    echo "[DEBUG] Actual output: $output" >&2

    # Assertions
    if [ "false" = "true" ]; then
        assert_equal "$actual_matched" "true"
        assert_equal "$actual_extracted" ""
        assert_equal "$actual_raw_remainder" "no_date_in_this_file.txt"
    else
        assert_equal "$actual_matched" "false"
        assert_equal "$actual_extracted" ""
        assert_equal "$actual_raw_remainder" "no_date_in_this_file.txt"
    fi
}

@test "date-extraction-6: Multiple-Dates" {
    run extract_date_from_filename "20230101_and_20240202.log"

    # Split the output into components
    IFS='|' read -r actual_extracted actual_raw_remainder actual_matched <<< "$output"

    # Debug output
    echo "[DEBUG] Testing: 20230101_and_20240202.log" >&2
    echo "[DEBUG] Expected match: true" >&2
    echo "[DEBUG] Expected extracted: 2023-01-01,2024-02-02" >&2
    echo "[DEBUG] Expected raw remainder: _and_.log" >&2
    echo "[DEBUG] Use case: Multiple-Dates" >&2
    echo "[DEBUG] Actual output: $output" >&2

    # Assertions
    if [ "true" = "true" ]; then
        assert_equal "$actual_matched" "true"
        assert_equal "$actual_extracted" "2023-01-01,2024-02-02"
        assert_equal "$actual_raw_remainder" "_and_.log"
    else
        assert_equal "$actual_matched" "false"
        assert_equal "$actual_extracted" ""
        assert_equal "$actual_raw_remainder" "20230101_and_20240202.log"
    fi
}

@test "date-extraction-7: Written-Date-Dec" {
    run extract_date_from_filename "scan 25-Dec-2023.jpg"

    # Split the output into components
    IFS='|' read -r actual_extracted actual_raw_remainder actual_matched <<< "$output"

    # Debug output
    echo "[DEBUG] Testing: scan 25-Dec-2023.jpg" >&2
    echo "[DEBUG] Expected match: true" >&2
    echo "[DEBUG] Expected extracted: 2023-12-25" >&2
    echo "[DEBUG] Expected raw remainder: scan .jpg" >&2
    echo "[DEBUG] Use case: Written-Date-Dec" >&2
    echo "[DEBUG] Actual output: $output" >&2

    # Assertions
    if [ "true" = "true" ]; then
        assert_equal "$actual_matched" "true"
        assert_equal "$actual_extracted" "2023-12-25"
        assert_equal "$actual_raw_remainder" "scan .jpg"
    else
        assert_equal "$actual_matched" "false"
        assert_equal "$actual_extracted" ""
        assert_equal "$actual_raw_remainder" "scan 25-Dec-2023.jpg"
    fi
}

@test "date-extraction-8: Ordinal-Date-1st " {
    run extract_date_from_filename "report-for-1st-jan-2024.txt"

    # Split the output into components
    IFS='|' read -r actual_extracted actual_raw_remainder actual_matched <<< "$output"

    # Debug output
    echo "[DEBUG] Testing: report-for-1st-jan-2024.txt" >&2
    echo "[DEBUG] Expected match: true" >&2
    echo "[DEBUG] Expected extracted: 2024-01-01" >&2
    echo "[DEBUG] Expected raw remainder: report-for-.txt" >&2
    echo "[DEBUG] Use case: Ordinal-Date-1st " >&2
    echo "[DEBUG] Actual output: $output" >&2

    # Assertions
    if [ "true" = "true" ]; then
        assert_equal "$actual_matched" "true"
        assert_equal "$actual_extracted" "2024-01-01"
        assert_equal "$actual_raw_remainder" "report-for-.txt"
    else
        assert_equal "$actual_matched" "false"
        assert_equal "$actual_extracted" ""
        assert_equal "$actual_raw_remainder" "report-for-1st-jan-2024.txt"
    fi
}

# --- Filename Cleaning Tests --- #

@test "date-clean_filename-1: ISO-Date" {
    run clean_date_filename_remainder "report-.pdf"

    # Debug output
    echo "[DEBUG] Testing remainder: report-.pdf" >&2
    echo "[DEBUG] Expected cleaned: report.pdf" >&2
    echo "[DEBUG] Use case: ISO-Date" >&2
    echo "[DEBUG] Actual output: $output" >&2

    # Assertions
    assert_equal "$output" "report.pdf"
}

@test "date-clean_filename-2: YYYYMMDD" {
    run clean_date_filename_remainder "client-notes_.txt"

    # Debug output
    echo "[DEBUG] Testing remainder: client-notes_.txt" >&2
    echo "[DEBUG] Expected cleaned: client-notes.txt" >&2
    echo "[DEBUG] Use case: YYYYMMDD" >&2
    echo "[DEBUG] Actual output: $output" >&2

    # Assertions
    assert_equal "$output" "client-notes.txt"
}

@test "date-clean_filename-3: MM-DD-YYYY" {
    run clean_date_filename_remainder "_summary.docx"

    # Debug output
    echo "[DEBUG] Testing remainder: _summary.docx" >&2
    echo "[DEBUG] Expected cleaned: summary.docx" >&2
    echo "[DEBUG] Use case: MM-DD-YYYY" >&2
    echo "[DEBUG] Actual output: $output" >&2

    # Assertions
    assert_equal "$output" "summary.docx"
}

@test "date-clean_filename-4: MMDDYYYY-no-sep" {
    run clean_date_filename_remainder "archive .zip"

    # Debug output
    echo "[DEBUG] Testing remainder: archive .zip" >&2
    echo "[DEBUG] Expected cleaned: archive.zip" >&2
    echo "[DEBUG] Use case: MMDDYYYY-no-sep" >&2
    echo "[DEBUG] Actual output: $output" >&2

    # Assertions
    assert_equal "$output" "archive.zip"
}

@test "date-clean_filename-5: No-Date" {
    run clean_date_filename_remainder "no_date_in_this_file.txt"

    # Debug output
    echo "[DEBUG] Testing remainder: no_date_in_this_file.txt" >&2
    echo "[DEBUG] Expected cleaned: no_date_in_this_file.txt" >&2
    echo "[DEBUG] Use case: No-Date" >&2
    echo "[DEBUG] Actual output: $output" >&2

    # Assertions
    assert_equal "$output" "no_date_in_this_file.txt"
}

@test "date-clean_filename-6: Multiple-Dates" {
    run clean_date_filename_remainder "_and_.log"

    # Debug output
    echo "[DEBUG] Testing remainder: _and_.log" >&2
    echo "[DEBUG] Expected cleaned: and.log" >&2
    echo "[DEBUG] Use case: Multiple-Dates" >&2
    echo "[DEBUG] Actual output: $output" >&2

    # Assertions
    assert_equal "$output" "and.log"
}

@test "date-clean_filename-7: Written-Date-Dec" {
    run clean_date_filename_remainder "scan .jpg"

    # Debug output
    echo "[DEBUG] Testing remainder: scan .jpg" >&2
    echo "[DEBUG] Expected cleaned: scan.jpg" >&2
    echo "[DEBUG] Use case: Written-Date-Dec" >&2
    echo "[DEBUG] Actual output: $output" >&2

    # Assertions
    assert_equal "$output" "scan.jpg"
}

@test "date-clean_filename-8: Ordinal-Date-1st " {
    run clean_date_filename_remainder "report-for-.txt"

    # Debug output
    echo "[DEBUG] Testing remainder: report-for-.txt" >&2
    echo "[DEBUG] Expected cleaned: report-for.txt" >&2
    echo "[DEBUG] Use case: Ordinal-Date-1st " >&2
    echo "[DEBUG] Actual output: $output" >&2

    # Assertions
    assert_equal "$output" "report-for.txt"
}

