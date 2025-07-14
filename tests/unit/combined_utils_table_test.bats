#!/usr/bin/env bats

# Combined name and date extraction tests
# This file is auto-generated from combined_extraction_cases.csv
# It checks that both name and date extraction work together on realistic filenames.

load "${BATS_TEST_DIRNAME}/../test_helper/bats-support/load.bash"
load "${BATS_TEST_DIRNAME}/../test_helper/bats-assert/load.bash"
load "${BATS_TEST_DIRNAME}/../test_helper/bats-file/load.bash"

source "${BATS_TEST_DIRNAME}/../../core/utils/name_utils.sh"
source "${BATS_TEST_DIRNAME}/../../core/utils/date_utils.sh"

@test "combined-extraction-1: Name and date with report" {
    run extract_name_and_date_from_filename "John_Doe_2023-05-15_Report.pdf" "john doe"
    IFS='|' read -r actual_extracted_name actual_extracted_date actual_raw_remainder actual_name_matched actual_date_matched <<< "$output"

    # Debug output
    echo "[DEBUG] Testing: John_Doe_2023-05-15_Report.pdf" >&2
    echo "[DEBUG] Expected name: John,Doe" >&2
    echo "[DEBUG] Expected date: 2023-05-15" >&2
    echo "[DEBUG] Expected raw remainder: ___Report.pdf" >&2
    echo "[DEBUG] Expected cleaned: Report.pdf" >&2
    echo "[DEBUG] Actual name: $actual_extracted_name" >&2
    echo "[DEBUG] Actual date: $actual_extracted_date" >&2
    echo "[DEBUG] Actual raw remainder: $actual_raw_remainder" >&2
    echo "[DEBUG] Actual cleaned: $(clean_filename_remainder "$actual_raw_remainder")" >&2
    echo "[DEBUG] Name matched: $actual_name_matched" >&2
    echo "[DEBUG] Date matched: $actual_date_matched" >&2

    assert_equal "$actual_extracted_name" "John,Doe"
    assert_equal "$actual_extracted_date" "2023-05-15"
    assert_equal "$actual_raw_remainder" "___Report.pdf"
    assert_equal "$(clean_filename_remainder "$actual_raw_remainder")" "Report.pdf"
    if [ "true" = "true" ]; then
        assert_equal "$actual_name_matched" "true"
        assert_equal "$actual_date_matched" "true"
    else
        assert_equal "$actual_name_matched" "false"
        assert_equal "$actual_date_matched" "false"
    fi
}

@test "combined-extraction-2: Name and compact date with invoice" {
    run extract_name_and_date_from_filename "john-doe-20240101-invoice.docx" "john doe"
    IFS='|' read -r actual_extracted_name actual_extracted_date actual_raw_remainder actual_name_matched actual_date_matched <<< "$output"

    # Debug output
    echo "[DEBUG] Testing: john-doe-20240101-invoice.docx" >&2
    echo "[DEBUG] Expected name: john,doe" >&2
    echo "[DEBUG] Expected date: 2024-01-01" >&2
    echo "[DEBUG] Expected raw remainder: ---invoice.docx" >&2
    echo "[DEBUG] Expected cleaned: invoice.docx" >&2
    echo "[DEBUG] Actual name: $actual_extracted_name" >&2
    echo "[DEBUG] Actual date: $actual_extracted_date" >&2
    echo "[DEBUG] Actual raw remainder: $actual_raw_remainder" >&2
    echo "[DEBUG] Actual cleaned: $(clean_filename_remainder "$actual_raw_remainder")" >&2
    echo "[DEBUG] Name matched: $actual_name_matched" >&2
    echo "[DEBUG] Date matched: $actual_date_matched" >&2

    assert_equal "$actual_extracted_name" "john,doe"
    assert_equal "$actual_extracted_date" "2024-01-01"
    assert_equal "$actual_raw_remainder" "---invoice.docx"
    assert_equal "$(clean_filename_remainder "$actual_raw_remainder")" "invoice.docx"
    if [ "true" = "true" ]; then
        assert_equal "$actual_name_matched" "true"
        assert_equal "$actual_date_matched" "true"
    else
        assert_equal "$actual_name_matched" "false"
        assert_equal "$actual_date_matched" "false"
    fi
}

@test "combined-extraction-3: Date, name, and summary" {
    run extract_name_and_date_from_filename "2022-12-31_John_Doe_summary.txt" "john doe"
    IFS='|' read -r actual_extracted_name actual_extracted_date actual_raw_remainder actual_name_matched actual_date_matched <<< "$output"

    # Debug output
    echo "[DEBUG] Testing: 2022-12-31_John_Doe_summary.txt" >&2
    echo "[DEBUG] Expected name: John,Doe" >&2
    echo "[DEBUG] Expected date: 2022-12-31" >&2
    echo "[DEBUG] Expected raw remainder: ___summary.txt" >&2
    echo "[DEBUG] Expected cleaned: summary.txt" >&2
    echo "[DEBUG] Actual name: $actual_extracted_name" >&2
    echo "[DEBUG] Actual date: $actual_extracted_date" >&2
    echo "[DEBUG] Actual raw remainder: $actual_raw_remainder" >&2
    echo "[DEBUG] Actual cleaned: $(clean_filename_remainder "$actual_raw_remainder")" >&2
    echo "[DEBUG] Name matched: $actual_name_matched" >&2
    echo "[DEBUG] Date matched: $actual_date_matched" >&2

    assert_equal "$actual_extracted_name" "John,Doe"
    assert_equal "$actual_extracted_date" "2022-12-31"
    assert_equal "$actual_raw_remainder" "___summary.txt"
    assert_equal "$(clean_filename_remainder "$actual_raw_remainder")" "summary.txt"
    if [ "true" = "true" ]; then
        assert_equal "$actual_name_matched" "true"
        assert_equal "$actual_date_matched" "true"
    else
        assert_equal "$actual_name_matched" "false"
        assert_equal "$actual_date_matched" "false"
    fi
}

@test "combined-extraction-4: Shorthand name and ISO date" {
    run extract_name_and_date_from_filename "report-2023-01-15-jdoe.pdf" "john doe"
    IFS='|' read -r actual_extracted_name actual_extracted_date actual_raw_remainder actual_name_matched actual_date_matched <<< "$output"

    # Debug output
    echo "[DEBUG] Testing: report-2023-01-15-jdoe.pdf" >&2
    echo "[DEBUG] Expected name: jdoe" >&2
    echo "[DEBUG] Expected date: 2023-01-15" >&2
    echo "[DEBUG] Expected raw remainder: report--.pdf" >&2
    echo "[DEBUG] Expected cleaned: report.pdf" >&2
    echo "[DEBUG] Actual name: $actual_extracted_name" >&2
    echo "[DEBUG] Actual date: $actual_extracted_date" >&2
    echo "[DEBUG] Actual raw remainder: $actual_raw_remainder" >&2
    echo "[DEBUG] Actual cleaned: $(clean_filename_remainder "$actual_raw_remainder")" >&2
    echo "[DEBUG] Name matched: $actual_name_matched" >&2
    echo "[DEBUG] Date matched: $actual_date_matched" >&2

    assert_equal "$actual_extracted_name" "jdoe"
    assert_equal "$actual_extracted_date" "2023-01-15"
    assert_equal "$actual_raw_remainder" "report--.pdf"
    assert_equal "$(clean_filename_remainder "$actual_raw_remainder")" "report.pdf"
    if [ "true" = "true" ]; then
        assert_equal "$actual_name_matched" "true"
        assert_equal "$actual_date_matched" "true"
    else
        assert_equal "$actual_name_matched" "false"
        assert_equal "$actual_date_matched" "false"
    fi
}

@test "combined-extraction-5: Written month date and name" {
    run extract_name_and_date_from_filename "John_Doe_15th-Mar-2023_notes.docx" "john doe"
    IFS='|' read -r actual_extracted_name actual_extracted_date actual_raw_remainder actual_name_matched actual_date_matched <<< "$output"

    # Debug output
    echo "[DEBUG] Testing: John_Doe_15th-Mar-2023_notes.docx" >&2
    echo "[DEBUG] Expected name: John,Doe" >&2
    echo "[DEBUG] Expected date: 2023-03-15" >&2
    echo "[DEBUG] Expected raw remainder: ___notes.docx" >&2
    echo "[DEBUG] Expected cleaned: notes.docx" >&2
    echo "[DEBUG] Actual name: $actual_extracted_name" >&2
    echo "[DEBUG] Actual date: $actual_extracted_date" >&2
    echo "[DEBUG] Actual raw remainder: $actual_raw_remainder" >&2
    echo "[DEBUG] Actual cleaned: $(clean_filename_remainder "$actual_raw_remainder")" >&2
    echo "[DEBUG] Name matched: $actual_name_matched" >&2
    echo "[DEBUG] Date matched: $actual_date_matched" >&2

    assert_equal "$actual_extracted_name" "John,Doe"
    assert_equal "$actual_extracted_date" "2023-03-15"
    assert_equal "$actual_raw_remainder" "___notes.docx"
    assert_equal "$(clean_filename_remainder "$actual_raw_remainder")" "notes.docx"
    if [ "true" = "true" ]; then
        assert_equal "$actual_name_matched" "true"
        assert_equal "$actual_date_matched" "true"
    else
        assert_equal "$actual_name_matched" "false"
        assert_equal "$actual_date_matched" "false"
    fi
}

@test "combined-extraction-6: Name, ISO date, and extra text" {
    run extract_name_and_date_from_filename "john-doe-2023-01-15-report-final.pdf" "john doe"
    IFS='|' read -r actual_extracted_name actual_extracted_date actual_raw_remainder actual_name_matched actual_date_matched <<< "$output"

    # Debug output
    echo "[DEBUG] Testing: john-doe-2023-01-15-report-final.pdf" >&2
    echo "[DEBUG] Expected name: john,doe" >&2
    echo "[DEBUG] Expected date: 2023-01-15" >&2
    echo "[DEBUG] Expected raw remainder: ---report-final.pdf" >&2
    echo "[DEBUG] Expected cleaned: report-final.pdf" >&2
    echo "[DEBUG] Actual name: $actual_extracted_name" >&2
    echo "[DEBUG] Actual date: $actual_extracted_date" >&2
    echo "[DEBUG] Actual raw remainder: $actual_raw_remainder" >&2
    echo "[DEBUG] Actual cleaned: $(clean_filename_remainder "$actual_raw_remainder")" >&2
    echo "[DEBUG] Name matched: $actual_name_matched" >&2
    echo "[DEBUG] Date matched: $actual_date_matched" >&2

    assert_equal "$actual_extracted_name" "john,doe"
    assert_equal "$actual_extracted_date" "2023-01-15"
    assert_equal "$actual_raw_remainder" "---report-final.pdf"
    assert_equal "$(clean_filename_remainder "$actual_raw_remainder")" "report-final.pdf"
    if [ "true" = "true" ]; then
        assert_equal "$actual_name_matched" "true"
        assert_equal "$actual_date_matched" "true"
    else
        assert_equal "$actual_name_matched" "false"
        assert_equal "$actual_date_matched" "false"
    fi
}

@test "combined-extraction-7: Compact date, name, and receipt" {
    run extract_name_and_date_from_filename "20230506_john_doe_receipt.pdf" "john doe"
    IFS='|' read -r actual_extracted_name actual_extracted_date actual_raw_remainder actual_name_matched actual_date_matched <<< "$output"

    # Debug output
    echo "[DEBUG] Testing: 20230506_john_doe_receipt.pdf" >&2
    echo "[DEBUG] Expected name: john,doe" >&2
    echo "[DEBUG] Expected date: 2023-05-06" >&2
    echo "[DEBUG] Expected raw remainder: ___receipt.pdf" >&2
    echo "[DEBUG] Expected cleaned: receipt.pdf" >&2
    echo "[DEBUG] Actual name: $actual_extracted_name" >&2
    echo "[DEBUG] Actual date: $actual_extracted_date" >&2
    echo "[DEBUG] Actual raw remainder: $actual_raw_remainder" >&2
    echo "[DEBUG] Actual cleaned: $(clean_filename_remainder "$actual_raw_remainder")" >&2
    echo "[DEBUG] Name matched: $actual_name_matched" >&2
    echo "[DEBUG] Date matched: $actual_date_matched" >&2

    assert_equal "$actual_extracted_name" "john,doe"
    assert_equal "$actual_extracted_date" "2023-05-06"
    assert_equal "$actual_raw_remainder" "___receipt.pdf"
    assert_equal "$(clean_filename_remainder "$actual_raw_remainder")" "receipt.pdf"
    if [ "true" = "true" ]; then
        assert_equal "$actual_name_matched" "true"
        assert_equal "$actual_date_matched" "true"
    else
        assert_equal "$actual_name_matched" "false"
        assert_equal "$actual_date_matched" "false"
    fi
}

@test "combined-extraction-8: Name and dotted ISO date" {
    run extract_name_and_date_from_filename "john.doe.2023.01.15.invoice.pdf" "john doe"
    IFS='|' read -r actual_extracted_name actual_extracted_date actual_raw_remainder actual_name_matched actual_date_matched <<< "$output"

    # Debug output
    echo "[DEBUG] Testing: john.doe.2023.01.15.invoice.pdf" >&2
    echo "[DEBUG] Expected name: john,doe" >&2
    echo "[DEBUG] Expected date: 2023-01-15" >&2
    echo "[DEBUG] Expected raw remainder: ...invoice.pdf" >&2
    echo "[DEBUG] Expected cleaned: invoice.pdf" >&2
    echo "[DEBUG] Actual name: $actual_extracted_name" >&2
    echo "[DEBUG] Actual date: $actual_extracted_date" >&2
    echo "[DEBUG] Actual raw remainder: $actual_raw_remainder" >&2
    echo "[DEBUG] Actual cleaned: $(clean_filename_remainder "$actual_raw_remainder")" >&2
    echo "[DEBUG] Name matched: $actual_name_matched" >&2
    echo "[DEBUG] Date matched: $actual_date_matched" >&2

    assert_equal "$actual_extracted_name" "john,doe"
    assert_equal "$actual_extracted_date" "2023-01-15"
    assert_equal "$actual_raw_remainder" "...invoice.pdf"
    assert_equal "$(clean_filename_remainder "$actual_raw_remainder")" "invoice.pdf"
    if [ "true" = "true" ]; then
        assert_equal "$actual_name_matched" "true"
        assert_equal "$actual_date_matched" "true"
    else
        assert_equal "$actual_name_matched" "false"
        assert_equal "$actual_date_matched" "false"
    fi
}

