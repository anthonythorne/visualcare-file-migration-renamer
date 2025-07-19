#!/usr/bin/env bats

# Combined name and date extraction tests
# This file is auto-generated from combined_extraction_cases.csv
# It checks that both name and date extraction work together on realistic filenames.

load "${BATS_TEST_DIRNAME}/../test-helper/bats-support/load.bash"
load "${BATS_TEST_DIRNAME}/../test-helper/bats-assert/load.bash"
load "${BATS_TEST_DIRNAME}/../test-helper/bats-file/load.bash"

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
    # Name matching: should match if expected_match is true
    if [ "true" = "true" ]; then
        assert_equal "$actual_name_matched" "true"
    else
        assert_equal "$actual_name_matched" "false"
    fi
    # Date matching: should match only if there's an expected date
    if [ -n "2023-05-15" ]; then
        assert_equal "$actual_date_matched" "true"
    else
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
    # Name matching: should match if expected_match is true
    if [ "true" = "true" ]; then
        assert_equal "$actual_name_matched" "true"
    else
        assert_equal "$actual_name_matched" "false"
    fi
    # Date matching: should match only if there's an expected date
    if [ -n "2024-01-01" ]; then
        assert_equal "$actual_date_matched" "true"
    else
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
    # Name matching: should match if expected_match is true
    if [ "true" = "true" ]; then
        assert_equal "$actual_name_matched" "true"
    else
        assert_equal "$actual_name_matched" "false"
    fi
    # Date matching: should match only if there's an expected date
    if [ -n "2022-12-31" ]; then
        assert_equal "$actual_date_matched" "true"
    else
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
    # Name matching: should match if expected_match is true
    if [ "true" = "true" ]; then
        assert_equal "$actual_name_matched" "true"
    else
        assert_equal "$actual_name_matched" "false"
    fi
    # Date matching: should match only if there's an expected date
    if [ -n "2023-01-15" ]; then
        assert_equal "$actual_date_matched" "true"
    else
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
    # Name matching: should match if expected_match is true
    if [ "true" = "true" ]; then
        assert_equal "$actual_name_matched" "true"
    else
        assert_equal "$actual_name_matched" "false"
    fi
    # Date matching: should match only if there's an expected date
    if [ -n "2023-03-15" ]; then
        assert_equal "$actual_date_matched" "true"
    else
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
    # Name matching: should match if expected_match is true
    if [ "true" = "true" ]; then
        assert_equal "$actual_name_matched" "true"
    else
        assert_equal "$actual_name_matched" "false"
    fi
    # Date matching: should match only if there's an expected date
    if [ -n "2023-01-15" ]; then
        assert_equal "$actual_date_matched" "true"
    else
        assert_equal "$actual_date_matched" "false"
    fi
}

@test "combined-extraction-7: Compact date, name, and receipt" {
    run extract_name_and_date_from_filename "20230506 john doe receipt.pdf" "john doe"
    IFS='|' read -r actual_extracted_name actual_extracted_date actual_raw_remainder actual_name_matched actual_date_matched <<< "$output"

    # Debug output
    echo "[DEBUG] Testing: 20230506 john doe receipt.pdf" >&2
    echo "[DEBUG] Expected name: john,doe" >&2
    echo "[DEBUG] Expected date: 2023-05-06" >&2
    echo "[DEBUG] Expected raw remainder:    receipt.pdf" >&2
    echo "[DEBUG] Expected cleaned: receipt.pdf" >&2
    echo "[DEBUG] Actual name: $actual_extracted_name" >&2
    echo "[DEBUG] Actual date: $actual_extracted_date" >&2
    echo "[DEBUG] Actual raw remainder: $actual_raw_remainder" >&2
    echo "[DEBUG] Actual cleaned: $(clean_filename_remainder "$actual_raw_remainder")" >&2
    echo "[DEBUG] Name matched: $actual_name_matched" >&2
    echo "[DEBUG] Date matched: $actual_date_matched" >&2

    assert_equal "$actual_extracted_name" "john,doe"
    assert_equal "$actual_extracted_date" "2023-05-06"
    assert_equal "$actual_raw_remainder" "   receipt.pdf"
    assert_equal "$(clean_filename_remainder "$actual_raw_remainder")" "receipt.pdf"
    # Name matching: should match if expected_match is true
    if [ "true" = "true" ]; then
        assert_equal "$actual_name_matched" "true"
    else
        assert_equal "$actual_name_matched" "false"
    fi
    # Date matching: should match only if there's an expected date
    if [ -n "2023-05-06" ]; then
        assert_equal "$actual_date_matched" "true"
    else
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
    # Name matching: should match if expected_match is true
    if [ "true" = "true" ]; then
        assert_equal "$actual_name_matched" "true"
    else
        assert_equal "$actual_name_matched" "false"
    fi
    # Date matching: should match only if there's an expected date
    if [ -n "2023-01-15" ]; then
        assert_equal "$actual_date_matched" "true"
    else
        assert_equal "$actual_date_matched" "false"
    fi
}

@test "combined-extraction-9: Shorthand with underscore date" {
    run extract_name_and_date_from_filename "jdoe_contract_2023-08-20.pdf" "john doe"
    IFS='|' read -r actual_extracted_name actual_extracted_date actual_raw_remainder actual_name_matched actual_date_matched <<< "$output"

    # Debug output
    echo "[DEBUG] Testing: jdoe_contract_2023-08-20.pdf" >&2
    echo "[DEBUG] Expected name: jdoe" >&2
    echo "[DEBUG] Expected date: 2023-08-20" >&2
    echo "[DEBUG] Expected raw remainder: _contract_.pdf" >&2
    echo "[DEBUG] Expected cleaned: contract.pdf" >&2
    echo "[DEBUG] Actual name: $actual_extracted_name" >&2
    echo "[DEBUG] Actual date: $actual_extracted_date" >&2
    echo "[DEBUG] Actual raw remainder: $actual_raw_remainder" >&2
    echo "[DEBUG] Actual cleaned: $(clean_filename_remainder "$actual_raw_remainder")" >&2
    echo "[DEBUG] Name matched: $actual_name_matched" >&2
    echo "[DEBUG] Date matched: $actual_date_matched" >&2

    assert_equal "$actual_extracted_name" "jdoe"
    assert_equal "$actual_extracted_date" "2023-08-20"
    assert_equal "$actual_raw_remainder" "_contract_.pdf"
    assert_equal "$(clean_filename_remainder "$actual_raw_remainder")" "contract.pdf"
    # Name matching: should match if expected_match is true
    if [ "true" = "true" ]; then
        assert_equal "$actual_name_matched" "true"
    else
        assert_equal "$actual_name_matched" "false"
    fi
    # Date matching: should match only if there's an expected date
    if [ -n "2023-08-20" ]; then
        assert_equal "$actual_date_matched" "true"
    else
        assert_equal "$actual_date_matched" "false"
    fi
}

@test "combined-extraction-10: Name with descriptive text" {
    run extract_name_and_date_from_filename "john_doe_2023-12-25_christmas_report.pdf" "john doe"
    IFS='|' read -r actual_extracted_name actual_extracted_date actual_raw_remainder actual_name_matched actual_date_matched <<< "$output"

    # Debug output
    echo "[DEBUG] Testing: john_doe_2023-12-25_christmas_report.pdf" >&2
    echo "[DEBUG] Expected name: john,doe" >&2
    echo "[DEBUG] Expected date: 2023-12-25" >&2
    echo "[DEBUG] Expected raw remainder: ___christmas_report.pdf" >&2
    echo "[DEBUG] Expected cleaned: christmas_report.pdf" >&2
    echo "[DEBUG] Actual name: $actual_extracted_name" >&2
    echo "[DEBUG] Actual date: $actual_extracted_date" >&2
    echo "[DEBUG] Actual raw remainder: $actual_raw_remainder" >&2
    echo "[DEBUG] Actual cleaned: $(clean_filename_remainder "$actual_raw_remainder")" >&2
    echo "[DEBUG] Name matched: $actual_name_matched" >&2
    echo "[DEBUG] Date matched: $actual_date_matched" >&2

    assert_equal "$actual_extracted_name" "john,doe"
    assert_equal "$actual_extracted_date" "2023-12-25"
    assert_equal "$actual_raw_remainder" "___christmas_report.pdf"
    assert_equal "$(clean_filename_remainder "$actual_raw_remainder")" "christmas_report.pdf"
    # Name matching: should match if expected_match is true
    if [ "true" = "true" ]; then
        assert_equal "$actual_name_matched" "true"
    else
        assert_equal "$actual_name_matched" "false"
    fi
    # Date matching: should match only if there's an expected date
    if [ -n "2023-12-25" ]; then
        assert_equal "$actual_date_matched" "true"
    else
        assert_equal "$actual_date_matched" "false"
    fi
}

@test "combined-extraction-11: Jane Smith contract with date" {
    run extract_name_and_date_from_filename "Jane_Smith_2023-06-20_contract.pdf" "jane smith"
    IFS='|' read -r actual_extracted_name actual_extracted_date actual_raw_remainder actual_name_matched actual_date_matched <<< "$output"

    # Debug output
    echo "[DEBUG] Testing: Jane_Smith_2023-06-20_contract.pdf" >&2
    echo "[DEBUG] Expected name: Jane,Smith" >&2
    echo "[DEBUG] Expected date: 2023-06-20" >&2
    echo "[DEBUG] Expected raw remainder: ___contract.pdf" >&2
    echo "[DEBUG] Expected cleaned: contract.pdf" >&2
    echo "[DEBUG] Actual name: $actual_extracted_name" >&2
    echo "[DEBUG] Actual date: $actual_extracted_date" >&2
    echo "[DEBUG] Actual raw remainder: $actual_raw_remainder" >&2
    echo "[DEBUG] Actual cleaned: $(clean_filename_remainder "$actual_raw_remainder")" >&2
    echo "[DEBUG] Name matched: $actual_name_matched" >&2
    echo "[DEBUG] Date matched: $actual_date_matched" >&2

    assert_equal "$actual_extracted_name" "Jane,Smith"
    assert_equal "$actual_extracted_date" "2023-06-20"
    assert_equal "$actual_raw_remainder" "___contract.pdf"
    assert_equal "$(clean_filename_remainder "$actual_raw_remainder")" "contract.pdf"
    # Name matching: should match if expected_match is true
    if [ "true" = "true" ]; then
        assert_equal "$actual_name_matched" "true"
    else
        assert_equal "$actual_name_matched" "false"
    fi
    # Date matching: should match only if there's an expected date
    if [ -n "2023-06-20" ]; then
        assert_equal "$actual_date_matched" "true"
    else
        assert_equal "$actual_date_matched" "false"
    fi
}

@test "combined-extraction-12: Jane Smith proposal no date" {
    run extract_name_and_date_from_filename "jane-smith-proposal.docx" "jane smith"
    IFS='|' read -r actual_extracted_name actual_extracted_date actual_raw_remainder actual_name_matched actual_date_matched <<< "$output"

    # Debug output
    echo "[DEBUG] Testing: jane-smith-proposal.docx" >&2
    echo "[DEBUG] Expected name: jane,smith" >&2
    echo "[DEBUG] Expected date: " >&2
    echo "[DEBUG] Expected raw remainder: --proposal.docx" >&2
    echo "[DEBUG] Expected cleaned: proposal.docx" >&2
    echo "[DEBUG] Actual name: $actual_extracted_name" >&2
    echo "[DEBUG] Actual date: $actual_extracted_date" >&2
    echo "[DEBUG] Actual raw remainder: $actual_raw_remainder" >&2
    echo "[DEBUG] Actual cleaned: $(clean_filename_remainder "$actual_raw_remainder")" >&2
    echo "[DEBUG] Name matched: $actual_name_matched" >&2
    echo "[DEBUG] Date matched: $actual_date_matched" >&2

    assert_equal "$actual_extracted_name" "jane,smith"
    assert_equal "$actual_extracted_date" ""
    assert_equal "$actual_raw_remainder" "--proposal.docx"
    assert_equal "$(clean_filename_remainder "$actual_raw_remainder")" "proposal.docx"
    # Name matching: should match if expected_match is true
    if [ "true" = "true" ]; then
        assert_equal "$actual_name_matched" "true"
    else
        assert_equal "$actual_name_matched" "false"
    fi
    # Date matching: should match only if there's an expected date
    if [ -n "" ]; then
        assert_equal "$actual_date_matched" "true"
    else
        assert_equal "$actual_date_matched" "false"
    fi
}

@test "combined-extraction-13: Jane Smith presentation with date" {
    run extract_name_and_date_from_filename "2023-08-15_Jane_Smith_presentation.pptx" "jane smith"
    IFS='|' read -r actual_extracted_name actual_extracted_date actual_raw_remainder actual_name_matched actual_date_matched <<< "$output"

    # Debug output
    echo "[DEBUG] Testing: 2023-08-15_Jane_Smith_presentation.pptx" >&2
    echo "[DEBUG] Expected name: Jane,Smith" >&2
    echo "[DEBUG] Expected date: 2023-08-15" >&2
    echo "[DEBUG] Expected raw remainder: ___presentation.pptx" >&2
    echo "[DEBUG] Expected cleaned: presentation.pptx" >&2
    echo "[DEBUG] Actual name: $actual_extracted_name" >&2
    echo "[DEBUG] Actual date: $actual_extracted_date" >&2
    echo "[DEBUG] Actual raw remainder: $actual_raw_remainder" >&2
    echo "[DEBUG] Actual cleaned: $(clean_filename_remainder "$actual_raw_remainder")" >&2
    echo "[DEBUG] Name matched: $actual_name_matched" >&2
    echo "[DEBUG] Date matched: $actual_date_matched" >&2

    assert_equal "$actual_extracted_name" "Jane,Smith"
    assert_equal "$actual_extracted_date" "2023-08-15"
    assert_equal "$actual_raw_remainder" "___presentation.pptx"
    assert_equal "$(clean_filename_remainder "$actual_raw_remainder")" "presentation.pptx"
    # Name matching: should match if expected_match is true
    if [ "true" = "true" ]; then
        assert_equal "$actual_name_matched" "true"
    else
        assert_equal "$actual_name_matched" "false"
    fi
    # Date matching: should match only if there's an expected date
    if [ -n "2023-08-15" ]; then
        assert_equal "$actual_date_matched" "true"
    else
        assert_equal "$actual_date_matched" "false"
    fi
}

@test "combined-extraction-14: Jane Smith shorthand with date" {
    run extract_name_and_date_from_filename "jsmith-2023-09-10-report.pdf" "jane smith"
    IFS='|' read -r actual_extracted_name actual_extracted_date actual_raw_remainder actual_name_matched actual_date_matched <<< "$output"

    # Debug output
    echo "[DEBUG] Testing: jsmith-2023-09-10-report.pdf" >&2
    echo "[DEBUG] Expected name: jsmith" >&2
    echo "[DEBUG] Expected date: 2023-09-10" >&2
    echo "[DEBUG] Expected raw remainder: --report.pdf" >&2
    echo "[DEBUG] Expected cleaned: report.pdf" >&2
    echo "[DEBUG] Actual name: $actual_extracted_name" >&2
    echo "[DEBUG] Actual date: $actual_extracted_date" >&2
    echo "[DEBUG] Actual raw remainder: $actual_raw_remainder" >&2
    echo "[DEBUG] Actual cleaned: $(clean_filename_remainder "$actual_raw_remainder")" >&2
    echo "[DEBUG] Name matched: $actual_name_matched" >&2
    echo "[DEBUG] Date matched: $actual_date_matched" >&2

    assert_equal "$actual_extracted_name" "jsmith"
    assert_equal "$actual_extracted_date" "2023-09-10"
    assert_equal "$actual_raw_remainder" "--report.pdf"
    assert_equal "$(clean_filename_remainder "$actual_raw_remainder")" "report.pdf"
    # Name matching: should match if expected_match is true
    if [ "true" = "true" ]; then
        assert_equal "$actual_name_matched" "true"
    else
        assert_equal "$actual_name_matched" "false"
    fi
    # Date matching: should match only if there's an expected date
    if [ -n "2023-09-10" ]; then
        assert_equal "$actual_date_matched" "true"
    else
        assert_equal "$actual_date_matched" "false"
    fi
}

@test "combined-extraction-15: Jane Smith dotted format with budget" {
    run extract_name_and_date_from_filename "jane.smith.2023.11.30.budget.xlsx" "jane smith"
    IFS='|' read -r actual_extracted_name actual_extracted_date actual_raw_remainder actual_name_matched actual_date_matched <<< "$output"

    # Debug output
    echo "[DEBUG] Testing: jane.smith.2023.11.30.budget.xlsx" >&2
    echo "[DEBUG] Expected name: jane,smith" >&2
    echo "[DEBUG] Expected date: 2023-11-30" >&2
    echo "[DEBUG] Expected raw remainder: ...budget.xlsx" >&2
    echo "[DEBUG] Expected cleaned: budget.xlsx" >&2
    echo "[DEBUG] Actual name: $actual_extracted_name" >&2
    echo "[DEBUG] Actual date: $actual_extracted_date" >&2
    echo "[DEBUG] Actual raw remainder: $actual_raw_remainder" >&2
    echo "[DEBUG] Actual cleaned: $(clean_filename_remainder "$actual_raw_remainder")" >&2
    echo "[DEBUG] Name matched: $actual_name_matched" >&2
    echo "[DEBUG] Date matched: $actual_date_matched" >&2

    assert_equal "$actual_extracted_name" "jane,smith"
    assert_equal "$actual_extracted_date" "2023-11-30"
    assert_equal "$actual_raw_remainder" "...budget.xlsx"
    assert_equal "$(clean_filename_remainder "$actual_raw_remainder")" "budget.xlsx"
    # Name matching: should match if expected_match is true
    if [ "true" = "true" ]; then
        assert_equal "$actual_name_matched" "true"
    else
        assert_equal "$actual_name_matched" "false"
    fi
    # Date matching: should match only if there's an expected date
    if [ -n "2023-11-30" ]; then
        assert_equal "$actual_date_matched" "true"
    else
        assert_equal "$actual_date_matched" "false"
    fi
}

@test "combined-extraction-16: Jane Smith compact date with notes" {
    run extract_name_and_date_from_filename "20231201_jane_smith_meeting_notes.txt" "jane smith"
    IFS='|' read -r actual_extracted_name actual_extracted_date actual_raw_remainder actual_name_matched actual_date_matched <<< "$output"

    # Debug output
    echo "[DEBUG] Testing: 20231201_jane_smith_meeting_notes.txt" >&2
    echo "[DEBUG] Expected name: jane,smith" >&2
    echo "[DEBUG] Expected date: 2023-12-01" >&2
    echo "[DEBUG] Expected raw remainder: ___meeting_notes.txt" >&2
    echo "[DEBUG] Expected cleaned: meeting_notes.txt" >&2
    echo "[DEBUG] Actual name: $actual_extracted_name" >&2
    echo "[DEBUG] Actual date: $actual_extracted_date" >&2
    echo "[DEBUG] Actual raw remainder: $actual_raw_remainder" >&2
    echo "[DEBUG] Actual cleaned: $(clean_filename_remainder "$actual_raw_remainder")" >&2
    echo "[DEBUG] Name matched: $actual_name_matched" >&2
    echo "[DEBUG] Date matched: $actual_date_matched" >&2

    assert_equal "$actual_extracted_name" "jane,smith"
    assert_equal "$actual_extracted_date" "2023-12-01"
    assert_equal "$actual_raw_remainder" "___meeting_notes.txt"
    assert_equal "$(clean_filename_remainder "$actual_raw_remainder")" "meeting_notes.txt"
    # Name matching: should match if expected_match is true
    if [ "true" = "true" ]; then
        assert_equal "$actual_name_matched" "true"
    else
        assert_equal "$actual_name_matched" "false"
    fi
    # Date matching: should match only if there's an expected date
    if [ -n "2023-12-01" ]; then
        assert_equal "$actual_date_matched" "true"
    else
        assert_equal "$actual_date_matched" "false"
    fi
}

@test "combined-extraction-17: Jane Smith shorthand with final report" {
    run extract_name_and_date_from_filename "jsmith_final_report_2024-01-15.pdf" "jane smith"
    IFS='|' read -r actual_extracted_name actual_extracted_date actual_raw_remainder actual_name_matched actual_date_matched <<< "$output"

    # Debug output
    echo "[DEBUG] Testing: jsmith_final_report_2024-01-15.pdf" >&2
    echo "[DEBUG] Expected name: jsmith" >&2
    echo "[DEBUG] Expected date: 2024-01-15" >&2
    echo "[DEBUG] Expected raw remainder: _final_report_.pdf" >&2
    echo "[DEBUG] Expected cleaned: final_report.pdf" >&2
    echo "[DEBUG] Actual name: $actual_extracted_name" >&2
    echo "[DEBUG] Actual date: $actual_extracted_date" >&2
    echo "[DEBUG] Actual raw remainder: $actual_raw_remainder" >&2
    echo "[DEBUG] Actual cleaned: $(clean_filename_remainder "$actual_raw_remainder")" >&2
    echo "[DEBUG] Name matched: $actual_name_matched" >&2
    echo "[DEBUG] Date matched: $actual_date_matched" >&2

    assert_equal "$actual_extracted_name" "jsmith"
    assert_equal "$actual_extracted_date" "2024-01-15"
    assert_equal "$actual_raw_remainder" "_final_report_.pdf"
    assert_equal "$(clean_filename_remainder "$actual_raw_remainder")" "final_report.pdf"
    # Name matching: should match if expected_match is true
    if [ "true" = "true" ]; then
        assert_equal "$actual_name_matched" "true"
    else
        assert_equal "$actual_name_matched" "false"
    fi
    # Date matching: should match only if there's an expected date
    if [ -n "2024-01-15" ]; then
        assert_equal "$actual_date_matched" "true"
    else
        assert_equal "$actual_date_matched" "false"
    fi
}

@test "combined-extraction-18: Jane Smith with themed filename" {
    run extract_name_and_date_from_filename "jane-smith-2023-10-31-halloween-special.pdf" "jane smith"
    IFS='|' read -r actual_extracted_name actual_extracted_date actual_raw_remainder actual_name_matched actual_date_matched <<< "$output"

    # Debug output
    echo "[DEBUG] Testing: jane-smith-2023-10-31-halloween-special.pdf" >&2
    echo "[DEBUG] Expected name: jane,smith" >&2
    echo "[DEBUG] Expected date: 2023-10-31" >&2
    echo "[DEBUG] Expected raw remainder: ---halloween-special.pdf" >&2
    echo "[DEBUG] Expected cleaned: halloween-special.pdf" >&2
    echo "[DEBUG] Actual name: $actual_extracted_name" >&2
    echo "[DEBUG] Actual date: $actual_extracted_date" >&2
    echo "[DEBUG] Actual raw remainder: $actual_raw_remainder" >&2
    echo "[DEBUG] Actual cleaned: $(clean_filename_remainder "$actual_raw_remainder")" >&2
    echo "[DEBUG] Name matched: $actual_name_matched" >&2
    echo "[DEBUG] Date matched: $actual_date_matched" >&2

    assert_equal "$actual_extracted_name" "jane,smith"
    assert_equal "$actual_extracted_date" "2023-10-31"
    assert_equal "$actual_raw_remainder" "---halloween-special.pdf"
    assert_equal "$(clean_filename_remainder "$actual_raw_remainder")" "halloween-special.pdf"
    # Name matching: should match if expected_match is true
    if [ "true" = "true" ]; then
        assert_equal "$actual_name_matched" "true"
    else
        assert_equal "$actual_name_matched" "false"
    fi
    # Date matching: should match only if there's an expected date
    if [ -n "2023-10-31" ]; then
        assert_equal "$actual_date_matched" "true"
    else
        assert_equal "$actual_date_matched" "false"
    fi
}

@test "combined-extraction-19: Jane Smith initial format with holiday" {
    run extract_name_and_date_from_filename "j.smith.2023.07.04.independence_day.pptx" "jane smith"
    IFS='|' read -r actual_extracted_name actual_extracted_date actual_raw_remainder actual_name_matched actual_date_matched <<< "$output"

    # Debug output
    echo "[DEBUG] Testing: j.smith.2023.07.04.independence_day.pptx" >&2
    echo "[DEBUG] Expected name: j.smith" >&2
    echo "[DEBUG] Expected date: 2023-07-04" >&2
    echo "[DEBUG] Expected raw remainder: ..independence_day.pptx" >&2
    echo "[DEBUG] Expected cleaned: independence_day.pptx" >&2
    echo "[DEBUG] Actual name: $actual_extracted_name" >&2
    echo "[DEBUG] Actual date: $actual_extracted_date" >&2
    echo "[DEBUG] Actual raw remainder: $actual_raw_remainder" >&2
    echo "[DEBUG] Actual cleaned: $(clean_filename_remainder "$actual_raw_remainder")" >&2
    echo "[DEBUG] Name matched: $actual_name_matched" >&2
    echo "[DEBUG] Date matched: $actual_date_matched" >&2

    assert_equal "$actual_extracted_name" "j.smith"
    assert_equal "$actual_extracted_date" "2023-07-04"
    assert_equal "$actual_raw_remainder" "..independence_day.pptx"
    assert_equal "$(clean_filename_remainder "$actual_raw_remainder")" "independence_day.pptx"
    # Name matching: should match if expected_match is true
    if [ "true" = "true" ]; then
        assert_equal "$actual_name_matched" "true"
    else
        assert_equal "$actual_name_matched" "false"
    fi
    # Date matching: should match only if there's an expected date
    if [ -n "2023-07-04" ]; then
        assert_equal "$actual_date_matched" "true"
    else
        assert_equal "$actual_date_matched" "false"
    fi
}

@test "combined-extraction-20: Jane Smith shorthand with quarterly review" {
    run extract_name_and_date_from_filename "jsmith_quarterly_review_2023-12-31.pdf" "jane smith"
    IFS='|' read -r actual_extracted_name actual_extracted_date actual_raw_remainder actual_name_matched actual_date_matched <<< "$output"

    # Debug output
    echo "[DEBUG] Testing: jsmith_quarterly_review_2023-12-31.pdf" >&2
    echo "[DEBUG] Expected name: jsmith" >&2
    echo "[DEBUG] Expected date: 2023-12-31" >&2
    echo "[DEBUG] Expected raw remainder: _quarterly_review_.pdf" >&2
    echo "[DEBUG] Expected cleaned: quarterly_review.pdf" >&2
    echo "[DEBUG] Actual name: $actual_extracted_name" >&2
    echo "[DEBUG] Actual date: $actual_extracted_date" >&2
    echo "[DEBUG] Actual raw remainder: $actual_raw_remainder" >&2
    echo "[DEBUG] Actual cleaned: $(clean_filename_remainder "$actual_raw_remainder")" >&2
    echo "[DEBUG] Name matched: $actual_name_matched" >&2
    echo "[DEBUG] Date matched: $actual_date_matched" >&2

    assert_equal "$actual_extracted_name" "jsmith"
    assert_equal "$actual_extracted_date" "2023-12-31"
    assert_equal "$actual_raw_remainder" "_quarterly_review_.pdf"
    assert_equal "$(clean_filename_remainder "$actual_raw_remainder")" "quarterly_review.pdf"
    # Name matching: should match if expected_match is true
    if [ "true" = "true" ]; then
        assert_equal "$actual_name_matched" "true"
    else
        assert_equal "$actual_name_matched" "false"
    fi
    # Date matching: should match only if there's an expected date
    if [ -n "2023-12-31" ]; then
        assert_equal "$actual_date_matched" "true"
    else
        assert_equal "$actual_date_matched" "false"
    fi
}

@test "combined-extraction-21: Bob Johnson invoice with date" {
    run extract_name_and_date_from_filename "Bob_Johnson_2023-07-12_invoice.pdf" "bob johnson"
    IFS='|' read -r actual_extracted_name actual_extracted_date actual_raw_remainder actual_name_matched actual_date_matched <<< "$output"

    # Debug output
    echo "[DEBUG] Testing: Bob_Johnson_2023-07-12_invoice.pdf" >&2
    echo "[DEBUG] Expected name: Bob,Johnson" >&2
    echo "[DEBUG] Expected date: 2023-07-12" >&2
    echo "[DEBUG] Expected raw remainder: ___invoice.pdf" >&2
    echo "[DEBUG] Expected cleaned: invoice.pdf" >&2
    echo "[DEBUG] Actual name: $actual_extracted_name" >&2
    echo "[DEBUG] Actual date: $actual_extracted_date" >&2
    echo "[DEBUG] Actual raw remainder: $actual_raw_remainder" >&2
    echo "[DEBUG] Actual cleaned: $(clean_filename_remainder "$actual_raw_remainder")" >&2
    echo "[DEBUG] Name matched: $actual_name_matched" >&2
    echo "[DEBUG] Date matched: $actual_date_matched" >&2

    assert_equal "$actual_extracted_name" "Bob,Johnson"
    assert_equal "$actual_extracted_date" "2023-07-12"
    assert_equal "$actual_raw_remainder" "___invoice.pdf"
    assert_equal "$(clean_filename_remainder "$actual_raw_remainder")" "invoice.pdf"
    # Name matching: should match if expected_match is true
    if [ "true" = "true" ]; then
        assert_equal "$actual_name_matched" "true"
    else
        assert_equal "$actual_name_matched" "false"
    fi
    # Date matching: should match only if there's an expected date
    if [ -n "2023-07-12" ]; then
        assert_equal "$actual_date_matched" "true"
    else
        assert_equal "$actual_date_matched" "false"
    fi
}

@test "combined-extraction-22: Bob Johnson dotted format" {
    run extract_name_and_date_from_filename "bob.johnson.2023.10.05.receipt.pdf" "bob johnson"
    IFS='|' read -r actual_extracted_name actual_extracted_date actual_raw_remainder actual_name_matched actual_date_matched <<< "$output"

    # Debug output
    echo "[DEBUG] Testing: bob.johnson.2023.10.05.receipt.pdf" >&2
    echo "[DEBUG] Expected name: bob,johnson" >&2
    echo "[DEBUG] Expected date: 2023-10-05" >&2
    echo "[DEBUG] Expected raw remainder: ...receipt.pdf" >&2
    echo "[DEBUG] Expected cleaned: receipt.pdf" >&2
    echo "[DEBUG] Actual name: $actual_extracted_name" >&2
    echo "[DEBUG] Actual date: $actual_extracted_date" >&2
    echo "[DEBUG] Actual raw remainder: $actual_raw_remainder" >&2
    echo "[DEBUG] Actual cleaned: $(clean_filename_remainder "$actual_raw_remainder")" >&2
    echo "[DEBUG] Name matched: $actual_name_matched" >&2
    echo "[DEBUG] Date matched: $actual_date_matched" >&2

    assert_equal "$actual_extracted_name" "bob,johnson"
    assert_equal "$actual_extracted_date" "2023-10-05"
    assert_equal "$actual_raw_remainder" "...receipt.pdf"
    assert_equal "$(clean_filename_remainder "$actual_raw_remainder")" "receipt.pdf"
    # Name matching: should match if expected_match is true
    if [ "true" = "true" ]; then
        assert_equal "$actual_name_matched" "true"
    else
        assert_equal "$actual_name_matched" "false"
    fi
    # Date matching: should match only if there's an expected date
    if [ -n "2023-10-05" ]; then
        assert_equal "$actual_date_matched" "true"
    else
        assert_equal "$actual_date_matched" "false"
    fi
}

@test "combined-extraction-23: Bob Johnson compact date format" {
    run extract_name_and_date_from_filename "20231120_bob_johnson_summary.txt" "bob johnson"
    IFS='|' read -r actual_extracted_name actual_extracted_date actual_raw_remainder actual_name_matched actual_date_matched <<< "$output"

    # Debug output
    echo "[DEBUG] Testing: 20231120_bob_johnson_summary.txt" >&2
    echo "[DEBUG] Expected name: bob,johnson" >&2
    echo "[DEBUG] Expected date: 2023-11-20" >&2
    echo "[DEBUG] Expected raw remainder: ___summary.txt" >&2
    echo "[DEBUG] Expected cleaned: summary.txt" >&2
    echo "[DEBUG] Actual name: $actual_extracted_name" >&2
    echo "[DEBUG] Actual date: $actual_extracted_date" >&2
    echo "[DEBUG] Actual raw remainder: $actual_raw_remainder" >&2
    echo "[DEBUG] Actual cleaned: $(clean_filename_remainder "$actual_raw_remainder")" >&2
    echo "[DEBUG] Name matched: $actual_name_matched" >&2
    echo "[DEBUG] Date matched: $actual_date_matched" >&2

    assert_equal "$actual_extracted_name" "bob,johnson"
    assert_equal "$actual_extracted_date" "2023-11-20"
    assert_equal "$actual_raw_remainder" "___summary.txt"
    assert_equal "$(clean_filename_remainder "$actual_raw_remainder")" "summary.txt"
    # Name matching: should match if expected_match is true
    if [ "true" = "true" ]; then
        assert_equal "$actual_name_matched" "true"
    else
        assert_equal "$actual_name_matched" "false"
    fi
    # Date matching: should match only if there's an expected date
    if [ -n "2023-11-20" ]; then
        assert_equal "$actual_date_matched" "true"
    else
        assert_equal "$actual_date_matched" "false"
    fi
}

@test "combined-extraction-24: Bob Johnson shorthand no date" {
    run extract_name_and_date_from_filename "bjohnson-contract.docx" "bob johnson"
    IFS='|' read -r actual_extracted_name actual_extracted_date actual_raw_remainder actual_name_matched actual_date_matched <<< "$output"

    # Debug output
    echo "[DEBUG] Testing: bjohnson-contract.docx" >&2
    echo "[DEBUG] Expected name: bjohnson" >&2
    echo "[DEBUG] Expected date: " >&2
    echo "[DEBUG] Expected raw remainder: -contract.docx" >&2
    echo "[DEBUG] Expected cleaned: contract.docx" >&2
    echo "[DEBUG] Actual name: $actual_extracted_name" >&2
    echo "[DEBUG] Actual date: $actual_extracted_date" >&2
    echo "[DEBUG] Actual raw remainder: $actual_raw_remainder" >&2
    echo "[DEBUG] Actual cleaned: $(clean_filename_remainder "$actual_raw_remainder")" >&2
    echo "[DEBUG] Name matched: $actual_name_matched" >&2
    echo "[DEBUG] Date matched: $actual_date_matched" >&2

    assert_equal "$actual_extracted_name" "bjohnson"
    assert_equal "$actual_extracted_date" ""
    assert_equal "$actual_raw_remainder" "-contract.docx"
    assert_equal "$(clean_filename_remainder "$actual_raw_remainder")" "contract.docx"
    # Name matching: should match if expected_match is true
    if [ "true" = "true" ]; then
        assert_equal "$actual_name_matched" "true"
    else
        assert_equal "$actual_name_matched" "false"
    fi
    # Date matching: should match only if there's an expected date
    if [ -n "" ]; then
        assert_equal "$actual_date_matched" "true"
    else
        assert_equal "$actual_date_matched" "false"
    fi
}

@test "combined-extraction-25: Bob Johnson with project plan" {
    run extract_name_and_date_from_filename "bob-johnson-2023-09-15-project-plan.pdf" "bob johnson"
    IFS='|' read -r actual_extracted_name actual_extracted_date actual_raw_remainder actual_name_matched actual_date_matched <<< "$output"

    # Debug output
    echo "[DEBUG] Testing: bob-johnson-2023-09-15-project-plan.pdf" >&2
    echo "[DEBUG] Expected name: bob,johnson" >&2
    echo "[DEBUG] Expected date: 2023-09-15" >&2
    echo "[DEBUG] Expected raw remainder: ---project-plan.pdf" >&2
    echo "[DEBUG] Expected cleaned: project-plan.pdf" >&2
    echo "[DEBUG] Actual name: $actual_extracted_name" >&2
    echo "[DEBUG] Actual date: $actual_extracted_date" >&2
    echo "[DEBUG] Actual raw remainder: $actual_raw_remainder" >&2
    echo "[DEBUG] Actual cleaned: $(clean_filename_remainder "$actual_raw_remainder")" >&2
    echo "[DEBUG] Name matched: $actual_name_matched" >&2
    echo "[DEBUG] Date matched: $actual_date_matched" >&2

    assert_equal "$actual_extracted_name" "bob,johnson"
    assert_equal "$actual_extracted_date" "2023-09-15"
    assert_equal "$actual_raw_remainder" "---project-plan.pdf"
    assert_equal "$(clean_filename_remainder "$actual_raw_remainder")" "project-plan.pdf"
    # Name matching: should match if expected_match is true
    if [ "true" = "true" ]; then
        assert_equal "$actual_name_matched" "true"
    else
        assert_equal "$actual_name_matched" "false"
    fi
    # Date matching: should match only if there's an expected date
    if [ -n "2023-09-15" ]; then
        assert_equal "$actual_date_matched" "true"
    else
        assert_equal "$actual_date_matched" "false"
    fi
}

@test "combined-extraction-26: Bob Johnson financial report" {
    run extract_name_and_date_from_filename "2023-06-30_Bob_Johnson_financial_report.xlsx" "bob johnson"
    IFS='|' read -r actual_extracted_name actual_extracted_date actual_raw_remainder actual_name_matched actual_date_matched <<< "$output"

    # Debug output
    echo "[DEBUG] Testing: 2023-06-30_Bob_Johnson_financial_report.xlsx" >&2
    echo "[DEBUG] Expected name: Bob,Johnson" >&2
    echo "[DEBUG] Expected date: 2023-06-30" >&2
    echo "[DEBUG] Expected raw remainder: ___financial_report.xlsx" >&2
    echo "[DEBUG] Expected cleaned: financial_report.xlsx" >&2
    echo "[DEBUG] Actual name: $actual_extracted_name" >&2
    echo "[DEBUG] Actual date: $actual_extracted_date" >&2
    echo "[DEBUG] Actual raw remainder: $actual_raw_remainder" >&2
    echo "[DEBUG] Actual cleaned: $(clean_filename_remainder "$actual_raw_remainder")" >&2
    echo "[DEBUG] Name matched: $actual_name_matched" >&2
    echo "[DEBUG] Date matched: $actual_date_matched" >&2

    assert_equal "$actual_extracted_name" "Bob,Johnson"
    assert_equal "$actual_extracted_date" "2023-06-30"
    assert_equal "$actual_raw_remainder" "___financial_report.xlsx"
    assert_equal "$(clean_filename_remainder "$actual_raw_remainder")" "financial_report.xlsx"
    # Name matching: should match if expected_match is true
    if [ "true" = "true" ]; then
        assert_equal "$actual_name_matched" "true"
    else
        assert_equal "$actual_name_matched" "false"
    fi
    # Date matching: should match only if there's an expected date
    if [ -n "2023-06-30" ]; then
        assert_equal "$actual_date_matched" "true"
    else
        assert_equal "$actual_date_matched" "false"
    fi
}

@test "combined-extraction-27: Bob Johnson shorthand with client meeting" {
    run extract_name_and_date_from_filename "bjohnson_2023-08-14_client_meeting.pptx" "bob johnson"
    IFS='|' read -r actual_extracted_name actual_extracted_date actual_raw_remainder actual_name_matched actual_date_matched <<< "$output"

    # Debug output
    echo "[DEBUG] Testing: bjohnson_2023-08-14_client_meeting.pptx" >&2
    echo "[DEBUG] Expected name: bjohnson" >&2
    echo "[DEBUG] Expected date: 2023-08-14" >&2
    echo "[DEBUG] Expected raw remainder: __client_meeting.pptx" >&2
    echo "[DEBUG] Expected cleaned: client_meeting.pptx" >&2
    echo "[DEBUG] Actual name: $actual_extracted_name" >&2
    echo "[DEBUG] Actual date: $actual_extracted_date" >&2
    echo "[DEBUG] Actual raw remainder: $actual_raw_remainder" >&2
    echo "[DEBUG] Actual cleaned: $(clean_filename_remainder "$actual_raw_remainder")" >&2
    echo "[DEBUG] Name matched: $actual_name_matched" >&2
    echo "[DEBUG] Date matched: $actual_date_matched" >&2

    assert_equal "$actual_extracted_name" "bjohnson"
    assert_equal "$actual_extracted_date" "2023-08-14"
    assert_equal "$actual_raw_remainder" "__client_meeting.pptx"
    assert_equal "$(clean_filename_remainder "$actual_raw_remainder")" "client_meeting.pptx"
    # Name matching: should match if expected_match is true
    if [ "true" = "true" ]; then
        assert_equal "$actual_name_matched" "true"
    else
        assert_equal "$actual_name_matched" "false"
    fi
    # Date matching: should match only if there's an expected date
    if [ -n "2023-08-14" ]; then
        assert_equal "$actual_date_matched" "true"
    else
        assert_equal "$actual_date_matched" "false"
    fi
}

@test "combined-extraction-28: Bob Johnson with bonus document" {
    run extract_name_and_date_from_filename "bob.johnson.2023.12.25.christmas.bonus.pdf" "bob johnson"
    IFS='|' read -r actual_extracted_name actual_extracted_date actual_raw_remainder actual_name_matched actual_date_matched <<< "$output"

    # Debug output
    echo "[DEBUG] Testing: bob.johnson.2023.12.25.christmas.bonus.pdf" >&2
    echo "[DEBUG] Expected name: bob,johnson" >&2
    echo "[DEBUG] Expected date: 2023-12-25" >&2
    echo "[DEBUG] Expected raw remainder: ...christmas.bonus.pdf" >&2
    echo "[DEBUG] Expected cleaned: christmas.bonus.pdf" >&2
    echo "[DEBUG] Actual name: $actual_extracted_name" >&2
    echo "[DEBUG] Actual date: $actual_extracted_date" >&2
    echo "[DEBUG] Actual raw remainder: $actual_raw_remainder" >&2
    echo "[DEBUG] Actual cleaned: $(clean_filename_remainder "$actual_raw_remainder")" >&2
    echo "[DEBUG] Name matched: $actual_name_matched" >&2
    echo "[DEBUG] Date matched: $actual_date_matched" >&2

    assert_equal "$actual_extracted_name" "bob,johnson"
    assert_equal "$actual_extracted_date" "2023-12-25"
    assert_equal "$actual_raw_remainder" "...christmas.bonus.pdf"
    assert_equal "$(clean_filename_remainder "$actual_raw_remainder")" "christmas.bonus.pdf"
    # Name matching: should match if expected_match is true
    if [ "true" = "true" ]; then
        assert_equal "$actual_name_matched" "true"
    else
        assert_equal "$actual_name_matched" "false"
    fi
    # Date matching: should match only if there's an expected date
    if [ -n "2023-12-25" ]; then
        assert_equal "$actual_date_matched" "true"
    else
        assert_equal "$actual_date_matched" "false"
    fi
}

@test "combined-extraction-29: Bob Johnson new year document" {
    run extract_name_and_date_from_filename "20240101_bob_johnson_new_year_resolution.txt" "bob johnson"
    IFS='|' read -r actual_extracted_name actual_extracted_date actual_raw_remainder actual_name_matched actual_date_matched <<< "$output"

    # Debug output
    echo "[DEBUG] Testing: 20240101_bob_johnson_new_year_resolution.txt" >&2
    echo "[DEBUG] Expected name: bob,johnson" >&2
    echo "[DEBUG] Expected date: 2024-01-01" >&2
    echo "[DEBUG] Expected raw remainder: ___new_year_resolution.txt" >&2
    echo "[DEBUG] Expected cleaned: new_year_resolution.txt" >&2
    echo "[DEBUG] Actual name: $actual_extracted_name" >&2
    echo "[DEBUG] Actual date: $actual_extracted_date" >&2
    echo "[DEBUG] Actual raw remainder: $actual_raw_remainder" >&2
    echo "[DEBUG] Actual cleaned: $(clean_filename_remainder "$actual_raw_remainder")" >&2
    echo "[DEBUG] Name matched: $actual_name_matched" >&2
    echo "[DEBUG] Date matched: $actual_date_matched" >&2

    assert_equal "$actual_extracted_name" "bob,johnson"
    assert_equal "$actual_extracted_date" "2024-01-01"
    assert_equal "$actual_raw_remainder" "___new_year_resolution.txt"
    assert_equal "$(clean_filename_remainder "$actual_raw_remainder")" "new_year_resolution.txt"
    # Name matching: should match if expected_match is true
    if [ "true" = "true" ]; then
        assert_equal "$actual_name_matched" "true"
    else
        assert_equal "$actual_name_matched" "false"
    fi
    # Date matching: should match only if there's an expected date
    if [ -n "2024-01-01" ]; then
        assert_equal "$actual_date_matched" "true"
    else
        assert_equal "$actual_date_matched" "false"
    fi
}

@test "combined-extraction-30: Bob Johnson initial format with holiday" {
    run extract_name_and_date_from_filename "b.johnson_2023-11-23_thanksgiving_menu.docx" "bob johnson"
    IFS='|' read -r actual_extracted_name actual_extracted_date actual_raw_remainder actual_name_matched actual_date_matched <<< "$output"

    # Debug output
    echo "[DEBUG] Testing: b.johnson_2023-11-23_thanksgiving_menu.docx" >&2
    echo "[DEBUG] Expected name: b.johnson" >&2
    echo "[DEBUG] Expected date: 2023-11-23" >&2
    echo "[DEBUG] Expected raw remainder: __thanksgiving_menu.docx" >&2
    echo "[DEBUG] Expected cleaned: thanksgiving_menu.docx" >&2
    echo "[DEBUG] Actual name: $actual_extracted_name" >&2
    echo "[DEBUG] Actual date: $actual_extracted_date" >&2
    echo "[DEBUG] Actual raw remainder: $actual_raw_remainder" >&2
    echo "[DEBUG] Actual cleaned: $(clean_filename_remainder "$actual_raw_remainder")" >&2
    echo "[DEBUG] Name matched: $actual_name_matched" >&2
    echo "[DEBUG] Date matched: $actual_date_matched" >&2

    assert_equal "$actual_extracted_name" "b.johnson"
    assert_equal "$actual_extracted_date" "2023-11-23"
    assert_equal "$actual_raw_remainder" "__thanksgiving_menu.docx"
    assert_equal "$(clean_filename_remainder "$actual_raw_remainder")" "thanksgiving_menu.docx"
    # Name matching: should match if expected_match is true
    if [ "true" = "true" ]; then
        assert_equal "$actual_name_matched" "true"
    else
        assert_equal "$actual_name_matched" "false"
    fi
    # Date matching: should match only if there's an expected date
    if [ -n "2023-11-23" ]; then
        assert_equal "$actual_date_matched" "true"
    else
        assert_equal "$actual_date_matched" "false"
    fi
}

