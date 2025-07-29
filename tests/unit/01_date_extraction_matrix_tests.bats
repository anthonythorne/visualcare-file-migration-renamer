#!/usr/bin/env bats

load "${BATS_TEST_DIRNAME}/../test-helper/bats-support/load.bash"
load "${BATS_TEST_DIRNAME}/../test-helper/bats-assert/load.bash"
load "${BATS_TEST_DIRNAME}/../test-helper/bats-file/load.bash"

# Auto-generated BATS tests for date extraction from filename
source "${BATS_TEST_DIRNAME}/../utils/date_utils.sh"


@test "extract_date_from_filename - report-2023-01-15.pdf" {
  run extract_date_from_filename "report-2023-01-15.pdf" "2023-01-15"
  [ "$status" -eq 0 ]
  IFS='|' read -r extracted_date raw_remainder matched <<< "$output"
  cleaned_remainder=$(python3 $BATS_TEST_DIRNAME/../../core/utils/name_matcher.py --clean-filename "$raw_remainder")
  echo "----- TEST CASE -----" >&2
  echo "Comment: ISO-Date" >&2
  echo "function: extract_date_from_filename" >&2
  echo "filename: report-2023-01-15.pdf" >&2
  echo "date to match: 2023-01-15" >&2
  echo "expected_match: true" >&2
  echo "raw remainder expected: report-.pdf" >&2
  echo "raw remainder matched: $raw_remainder" >&2
  echo "cleaned remainder expected: report.pdf" >&2
  echo "cleaned remainder matched: $cleaned_remainder" >&2
  echo "extracted_date expected: 2023-01-15" >&2
  echo "extracted_date matched: $extracted_date" >&2
  echo "expected match: $matched" >&2
  echo "---------------------" >&2
  assert_equal "$extracted_date" "2023-01-15"
  assert_equal "$raw_remainder" "report-.pdf"
  assert_equal "$cleaned_remainder" "report.pdf"
}

@test "extract_date_from_filename - client-notes_20240320.txt" {
  run extract_date_from_filename "client-notes_20240320.txt" "2024-03-20"
  [ "$status" -eq 0 ]
  IFS='|' read -r extracted_date raw_remainder matched <<< "$output"
  cleaned_remainder=$(python3 $BATS_TEST_DIRNAME/../../core/utils/name_matcher.py --clean-filename "$raw_remainder")
  echo "----- TEST CASE -----" >&2
  echo "Comment: YYYYMMDD" >&2
  echo "function: extract_date_from_filename" >&2
  echo "filename: client-notes_20240320.txt" >&2
  echo "date to match: 2024-03-20" >&2
  echo "expected_match: true" >&2
  echo "raw remainder expected: client-notes_.txt" >&2
  echo "raw remainder matched: $raw_remainder" >&2
  echo "cleaned remainder expected: client notes.txt" >&2
  echo "cleaned remainder matched: $cleaned_remainder" >&2
  echo "extracted_date expected: 2024-03-20" >&2
  echo "extracted_date matched: $extracted_date" >&2
  echo "expected match: $matched" >&2
  echo "---------------------" >&2
  assert_equal "$extracted_date" "2024-03-20"
  assert_equal "$raw_remainder" "client-notes_.txt"
  assert_equal "$cleaned_remainder" "client notes.txt"
}

@test "extract_date_from_filename - 25-05-2023_summary.docx" {
  run extract_date_from_filename "25-05-2023_summary.docx" "2023-05-25"
  [ "$status" -eq 0 ]
  IFS='|' read -r extracted_date raw_remainder matched <<< "$output"
  cleaned_remainder=$(python3 $BATS_TEST_DIRNAME/../../core/utils/name_matcher.py --clean-filename "$raw_remainder")
  echo "----- TEST CASE -----" >&2
  echo "Comment: DD-MM-YYYY" >&2
  echo "function: extract_date_from_filename" >&2
  echo "filename: 25-05-2023_summary.docx" >&2
  echo "date to match: 2023-05-25" >&2
  echo "expected_match: true" >&2
  echo "raw remainder expected: _summary.docx" >&2
  echo "raw remainder matched: $raw_remainder" >&2
  echo "cleaned remainder expected: summary.docx" >&2
  echo "cleaned remainder matched: $cleaned_remainder" >&2
  echo "extracted_date expected: 2023-05-25" >&2
  echo "extracted_date matched: $extracted_date" >&2
  echo "expected match: $matched" >&2
  echo "---------------------" >&2
  assert_equal "$extracted_date" "2023-05-25"
  assert_equal "$raw_remainder" "_summary.docx"
  assert_equal "$cleaned_remainder" "summary.docx"
}

@test "extract_date_from_filename - archive 10202024.zip" {
  run extract_date_from_filename "archive 10202024.zip" "2024-10-20"
  [ "$status" -eq 0 ]
  IFS='|' read -r extracted_date raw_remainder matched <<< "$output"
  cleaned_remainder=$(python3 $BATS_TEST_DIRNAME/../../core/utils/name_matcher.py --clean-filename "$raw_remainder")
  echo "----- TEST CASE -----" >&2
  echo "Comment: MMDDYYYY-no-sep" >&2
  echo "function: extract_date_from_filename" >&2
  echo "filename: archive 10202024.zip" >&2
  echo "date to match: 2024-10-20" >&2
  echo "expected_match: true" >&2
  echo "raw remainder expected: archive .zip" >&2
  echo "raw remainder matched: $raw_remainder" >&2
  echo "cleaned remainder expected: archive.zip" >&2
  echo "cleaned remainder matched: $cleaned_remainder" >&2
  echo "extracted_date expected: 2024-10-20" >&2
  echo "extracted_date matched: $extracted_date" >&2
  echo "expected match: $matched" >&2
  echo "---------------------" >&2
  assert_equal "$extracted_date" "2024-10-20"
  assert_equal "$raw_remainder" "archive .zip"
  assert_equal "$cleaned_remainder" "archive.zip"
}

@test "extract_date_from_filename - no_date_in_this_file.txt" {
  cleaned_remainder=$(python3 $BATS_TEST_DIRNAME/../../core/utils/name_matcher.py --clean-filename "no_date_in_this_file.txt")
  echo "----- TEST CASE -----" >&2
  echo "Comment: No-Date" >&2
  echo "function: extract_date_from_filename" >&2
  echo "filename: no_date_in_this_file.txt" >&2
  echo "date to match: " >&2
  echo "expected_match: false" >&2
  echo "raw remainder expected: no_date_in_this_file.txt" >&2
  echo "raw remainder matched: no_date_in_this_file.txt" >&2
  echo "cleaned remainder expected: no date in this file.txt" >&2
  echo "cleaned remainder matched: $cleaned_remainder" >&2
  echo "extracted_date expected: " >&2
  echo "extracted_date matched: " >&2
  echo "expected match: false" >&2
  echo "---------------------" >&2
  assert_equal "$cleaned_remainder" "no date in this file.txt"
}

@test "extract_date_from_filename - 20230101_and_20240202.log" {
  run extract_date_from_filename "20230101_and_20240202.log" "2023-01-01,2024-02-02"
  [ "$status" -eq 0 ]
  IFS='|' read -r extracted_date raw_remainder matched <<< "$output"
  cleaned_remainder=$(python3 $BATS_TEST_DIRNAME/../../core/utils/name_matcher.py --clean-filename "$raw_remainder")
  echo "----- TEST CASE -----" >&2
  echo "Comment: Multiple-Dates" >&2
  echo "function: extract_date_from_filename" >&2
  echo "filename: 20230101_and_20240202.log" >&2
  echo "date to match: 2023-01-01,2024-02-02" >&2
  echo "expected_match: true" >&2
  echo "raw remainder expected: _and_.log" >&2
  echo "raw remainder matched: $raw_remainder" >&2
  echo "cleaned remainder expected: and.log" >&2
  echo "cleaned remainder matched: $cleaned_remainder" >&2
  echo "extracted_date expected: 2023-01-01,2024-02-02" >&2
  echo "extracted_date matched: $extracted_date" >&2
  echo "expected match: $matched" >&2
  echo "---------------------" >&2
  assert_equal "$extracted_date" "2023-01-01,2024-02-02"
  assert_equal "$raw_remainder" "_and_.log"
  assert_equal "$cleaned_remainder" "and.log"
}

@test "extract_date_from_filename - scan 25-Dec-2023.jpg" {
  run extract_date_from_filename "scan 25-Dec-2023.jpg" "2023-12-25"
  [ "$status" -eq 0 ]
  IFS='|' read -r extracted_date raw_remainder matched <<< "$output"
  cleaned_remainder=$(python3 $BATS_TEST_DIRNAME/../../core/utils/name_matcher.py --clean-filename "$raw_remainder")
  echo "----- TEST CASE -----" >&2
  echo "Comment: Written-Date-Dec" >&2
  echo "function: extract_date_from_filename" >&2
  echo "filename: scan 25-Dec-2023.jpg" >&2
  echo "date to match: 2023-12-25" >&2
  echo "expected_match: true" >&2
  echo "raw remainder expected: scan .jpg" >&2
  echo "raw remainder matched: $raw_remainder" >&2
  echo "cleaned remainder expected: scan.jpg" >&2
  echo "cleaned remainder matched: $cleaned_remainder" >&2
  echo "extracted_date expected: 2023-12-25" >&2
  echo "extracted_date matched: $extracted_date" >&2
  echo "expected match: $matched" >&2
  echo "---------------------" >&2
  assert_equal "$extracted_date" "2023-12-25"
  assert_equal "$raw_remainder" "scan .jpg"
  assert_equal "$cleaned_remainder" "scan.jpg"
}

@test "extract_date_from_filename - report-for-1st-jan-2024.txt" {
  run extract_date_from_filename "report-for-1st-jan-2024.txt" "2024-01-01"
  [ "$status" -eq 0 ]
  IFS='|' read -r extracted_date raw_remainder matched <<< "$output"
  cleaned_remainder=$(python3 $BATS_TEST_DIRNAME/../../core/utils/name_matcher.py --clean-filename "$raw_remainder")
  echo "----- TEST CASE -----" >&2
  echo "Comment: Ordinal-Date-1st" >&2
  echo "function: extract_date_from_filename" >&2
  echo "filename: report-for-1st-jan-2024.txt" >&2
  echo "date to match: 2024-01-01" >&2
  echo "expected_match: true" >&2
  echo "raw remainder expected: report-for-.txt" >&2
  echo "raw remainder matched: $raw_remainder" >&2
  echo "cleaned remainder expected: report for.txt" >&2
  echo "cleaned remainder matched: $cleaned_remainder" >&2
  echo "extracted_date expected: 2024-01-01" >&2
  echo "extracted_date matched: $extracted_date" >&2
  echo "expected match: $matched" >&2
  echo "---------------------" >&2
  assert_equal "$extracted_date" "2024-01-01"
  assert_equal "$raw_remainder" "report-for-.txt"
  assert_equal "$cleaned_remainder" "report for.txt"
}

@test "extract_date_from_filename - incident_report_15-May-2023_final.docx" {
  run extract_date_from_filename "incident_report_15-May-2023_final.docx" "2023-05-15"
  [ "$status" -eq 0 ]
  IFS='|' read -r extracted_date raw_remainder matched <<< "$output"
  cleaned_remainder=$(python3 $BATS_TEST_DIRNAME/../../core/utils/name_matcher.py --clean-filename "$raw_remainder")
  echo "----- TEST CASE -----" >&2
  echo "Comment: Dash-separated-date" >&2
  echo "function: extract_date_from_filename" >&2
  echo "filename: incident_report_15-May-2023_final.docx" >&2
  echo "date to match: 2023-05-15" >&2
  echo "expected_match: true" >&2
  echo "raw remainder expected: incident_report__final.docx" >&2
  echo "raw remainder matched: $raw_remainder" >&2
  echo "cleaned remainder expected: incident report final.docx" >&2
  echo "cleaned remainder matched: $cleaned_remainder" >&2
  echo "extracted_date expected: 2023-05-15" >&2
  echo "extracted_date matched: $extracted_date" >&2
  echo "expected match: $matched" >&2
  echo "---------------------" >&2
  assert_equal "$extracted_date" "2023-05-15"
  assert_equal "$raw_remainder" "incident_report__final.docx"
  assert_equal "$cleaned_remainder" "incident report final.docx"
}

@test "extract_date_from_filename - medical_assessment_2023.05.15_complete.pdf" {
  run extract_date_from_filename "medical_assessment_2023.05.15_complete.pdf" "2023-05-15"
  [ "$status" -eq 0 ]
  IFS='|' read -r extracted_date raw_remainder matched <<< "$output"
  cleaned_remainder=$(python3 $BATS_TEST_DIRNAME/../../core/utils/name_matcher.py --clean-filename "$raw_remainder")
  echo "----- TEST CASE -----" >&2
  echo "Comment: Dot-separated-date" >&2
  echo "function: extract_date_from_filename" >&2
  echo "filename: medical_assessment_2023.05.15_complete.pdf" >&2
  echo "date to match: 2023-05-15" >&2
  echo "expected_match: true" >&2
  echo "raw remainder expected: medical_assessment__complete.pdf" >&2
  echo "raw remainder matched: $raw_remainder" >&2
  echo "cleaned remainder expected: medical assessment complete.pdf" >&2
  echo "cleaned remainder matched: $cleaned_remainder" >&2
  echo "extracted_date expected: 2023-05-15" >&2
  echo "extracted_date matched: $extracted_date" >&2
  echo "expected match: $matched" >&2
  echo "---------------------" >&2
  assert_equal "$extracted_date" "2023-05-15"
  assert_equal "$raw_remainder" "medical_assessment__complete.pdf"
  assert_equal "$cleaned_remainder" "medical assessment complete.pdf"
}

@test "extract_date_from_filename - support_plan_15/05/2023_reviewed.docx" {
  run extract_date_from_filename "support_plan_15/05/2023_reviewed.docx" "2023-05-15"
  [ "$status" -eq 0 ]
  IFS='|' read -r extracted_date raw_remainder matched <<< "$output"
  cleaned_remainder=$(python3 $BATS_TEST_DIRNAME/../../core/utils/name_matcher.py --clean-filename "$raw_remainder")
  echo "----- TEST CASE -----" >&2
  echo "Comment: Slash-separated-date" >&2
  echo "function: extract_date_from_filename" >&2
  echo "filename: support_plan_15/05/2023_reviewed.docx" >&2
  echo "date to match: 2023-05-15" >&2
  echo "expected_match: true" >&2
  echo "raw remainder expected: support_plan__reviewed.docx" >&2
  echo "raw remainder matched: $raw_remainder" >&2
  echo "cleaned remainder expected: support plan reviewed.docx" >&2
  echo "cleaned remainder matched: $cleaned_remainder" >&2
  echo "extracted_date expected: 2023-05-15" >&2
  echo "extracted_date matched: $extracted_date" >&2
  echo "expected match: $matched" >&2
  echo "---------------------" >&2
  assert_equal "$extracted_date" "2023-05-15"
  assert_equal "$raw_remainder" "support_plan__reviewed.docx"
  assert_equal "$cleaned_remainder" "support plan reviewed.docx"
}

@test "extract_date_from_filename - behavioral_notes_May-15-2023_urgent.txt" {
  run extract_date_from_filename "behavioral_notes_May-15-2023_urgent.txt" "2023-05-15"
  [ "$status" -eq 0 ]
  IFS='|' read -r extracted_date raw_remainder matched <<< "$output"
  cleaned_remainder=$(python3 $BATS_TEST_DIRNAME/../../core/utils/name_matcher.py --clean-filename "$raw_remainder")
  echo "----- TEST CASE -----" >&2
  echo "Comment: Month-name-format" >&2
  echo "function: extract_date_from_filename" >&2
  echo "filename: behavioral_notes_May-15-2023_urgent.txt" >&2
  echo "date to match: 2023-05-15" >&2
  echo "expected_match: true" >&2
  echo "raw remainder expected: behavioral_notes__urgent.txt" >&2
  echo "raw remainder matched: $raw_remainder" >&2
  echo "cleaned remainder expected: behavioral notes urgent.txt" >&2
  echo "cleaned remainder matched: $cleaned_remainder" >&2
  echo "extracted_date expected: 2023-05-15" >&2
  echo "extracted_date matched: $extracted_date" >&2
  echo "expected match: $matched" >&2
  echo "---------------------" >&2
  assert_equal "$extracted_date" "2023-05-15"
  assert_equal "$raw_remainder" "behavioral_notes__urgent.txt"
  assert_equal "$cleaned_remainder" "behavioral notes urgent.txt"
}

@test "extract_date_from_filename - progress_report_2023-12-25_and_2024-01-01.pdf" {
  run extract_date_from_filename "progress_report_2023-12-25_and_2024-01-01.pdf" "2023-12-25,2024-01-01"
  [ "$status" -eq 0 ]
  IFS='|' read -r extracted_date raw_remainder matched <<< "$output"
  cleaned_remainder=$(python3 $BATS_TEST_DIRNAME/../../core/utils/name_matcher.py --clean-filename "$raw_remainder")
  echo "----- TEST CASE -----" >&2
  echo "Comment: Multiple-dates-with-text" >&2
  echo "function: extract_date_from_filename" >&2
  echo "filename: progress_report_2023-12-25_and_2024-01-01.pdf" >&2
  echo "date to match: 2023-12-25,2024-01-01" >&2
  echo "expected_match: true" >&2
  echo "raw remainder expected: progress_report__and_.pdf" >&2
  echo "raw remainder matched: $raw_remainder" >&2
  echo "cleaned remainder expected: progress report and.pdf" >&2
  echo "cleaned remainder matched: $cleaned_remainder" >&2
  echo "extracted_date expected: 2023-12-25,2024-01-01" >&2
  echo "extracted_date matched: $extracted_date" >&2
  echo "expected match: $matched" >&2
  echo "---------------------" >&2
  assert_equal "$extracted_date" "2023-12-25,2024-01-01"
  assert_equal "$raw_remainder" "progress_report__and_.pdf"
  assert_equal "$cleaned_remainder" "progress report and.pdf"
}

@test "extract_date_from_filename - client_photo_album_2024.01.15_updated.zip" {
  run extract_date_from_filename "client_photo_album_2024.01.15_updated.zip" "2024-01-15"
  [ "$status" -eq 0 ]
  IFS='|' read -r extracted_date raw_remainder matched <<< "$output"
  cleaned_remainder=$(python3 $BATS_TEST_DIRNAME/../../core/utils/name_matcher.py --clean-filename "$raw_remainder")
  echo "----- TEST CASE -----" >&2
  echo "Comment: Complex-filename-with-dots" >&2
  echo "function: extract_date_from_filename" >&2
  echo "filename: client_photo_album_2024.01.15_updated.zip" >&2
  echo "date to match: 2024-01-15" >&2
  echo "expected_match: true" >&2
  echo "raw remainder expected: client_photo_album__updated.zip" >&2
  echo "raw remainder matched: $raw_remainder" >&2
  echo "cleaned remainder expected: client photo album updated.zip" >&2
  echo "cleaned remainder matched: $cleaned_remainder" >&2
  echo "extracted_date expected: 2024-01-15" >&2
  echo "extracted_date matched: $extracted_date" >&2
  echo "expected match: $matched" >&2
  echo "---------------------" >&2
  assert_equal "$extracted_date" "2024-01-15"
  assert_equal "$raw_remainder" "client_photo_album__updated.zip"
  assert_equal "$cleaned_remainder" "client photo album updated.zip"
}

@test "extract_date_from_filename - emergency_contact_15-January-2024_backup.doc" {
  run extract_date_from_filename "emergency_contact_15-January-2024_backup.doc" "2024-01-15"
  [ "$status" -eq 0 ]
  IFS='|' read -r extracted_date raw_remainder matched <<< "$output"
  cleaned_remainder=$(python3 $BATS_TEST_DIRNAME/../../core/utils/name_matcher.py --clean-filename "$raw_remainder")
  echo "----- TEST CASE -----" >&2
  echo "Comment: Full-month-format" >&2
  echo "function: extract_date_from_filename" >&2
  echo "filename: emergency_contact_15-January-2024_backup.doc" >&2
  echo "date to match: 2024-01-15" >&2
  echo "expected_match: true" >&2
  echo "raw remainder expected: emergency_contact__backup.doc" >&2
  echo "raw remainder matched: $raw_remainder" >&2
  echo "cleaned remainder expected: emergency contact backup.doc" >&2
  echo "cleaned remainder matched: $cleaned_remainder" >&2
  echo "extracted_date expected: 2024-01-15" >&2
  echo "extracted_date matched: $extracted_date" >&2
  echo "expected match: $matched" >&2
  echo "---------------------" >&2
  assert_equal "$extracted_date" "2024-01-15"
  assert_equal "$raw_remainder" "emergency_contact__backup.doc"
  assert_equal "$cleaned_remainder" "emergency contact backup.doc"
}

@test "extract_date_from_filename - invalid_date_32-13-2023_test.txt" {
  cleaned_remainder=$(python3 $BATS_TEST_DIRNAME/../../core/utils/name_matcher.py --clean-filename "invalid_date_32-13-2023_test.txt")
  echo "----- TEST CASE -----" >&2
  echo "Comment: Invalid-date-format" >&2
  echo "function: extract_date_from_filename" >&2
  echo "filename: invalid_date_32-13-2023_test.txt" >&2
  echo "date to match: " >&2
  echo "expected_match: false" >&2
  echo "raw remainder expected: invalid_date_32-13-2023_test.txt" >&2
  echo "raw remainder matched: invalid_date_32-13-2023_test.txt" >&2
  echo "cleaned remainder expected: invalid date 32 13 2023 test.txt" >&2
  echo "cleaned remainder matched: $cleaned_remainder" >&2
  echo "extracted_date expected: " >&2
  echo "extracted_date matched: " >&2
  echo "expected match: false" >&2
  echo "---------------------" >&2
  assert_equal "$cleaned_remainder" "invalid date 32 13 2023 test.txt"
}

@test "extract_date_from_filename - no_date_just_text_and_numbers_12345.txt" {
  cleaned_remainder=$(python3 $BATS_TEST_DIRNAME/../../core/utils/name_matcher.py --clean-filename "no_date_just_text_and_numbers_12345.txt")
  echo "----- TEST CASE -----" >&2
  echo "Comment: No-date-just-numbers " >&2
  echo "function: extract_date_from_filename" >&2
  echo "filename: no_date_just_text_and_numbers_12345.txt" >&2
  echo "date to match: " >&2
  echo "expected_match: false" >&2
  echo "raw remainder expected: no_date_just_text_and_numbers_12345.txt" >&2
  echo "raw remainder matched: no_date_just_text_and_numbers_12345.txt" >&2
  echo "cleaned remainder expected: no date just text and numbers 12345.txt" >&2
  echo "cleaned remainder matched: $cleaned_remainder" >&2
  echo "extracted_date expected: " >&2
  echo "extracted_date matched: " >&2
  echo "expected match: false" >&2
  echo "---------------------" >&2
  assert_equal "$cleaned_remainder" "no date just text and numbers 12345.txt"
}
