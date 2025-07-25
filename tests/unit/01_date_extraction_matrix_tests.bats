#!/usr/bin/env bats

load "${BATS_TEST_DIRNAME}/../test-helper/bats-support/load.bash"
load "${BATS_TEST_DIRNAME}/../test-helper/bats-assert/load.bash"
load "${BATS_TEST_DIRNAME}/../test-helper/bats-file/load.bash"

# Auto-generated BATS tests for date extraction
source "${BATS_TEST_DIRNAME}/../../core/utils/date_utils.sh"


@test "extract_date_from_filename - report-2023-01-15.pdf" {
  run extract_date_from_filename "report-2023-01-15.pdf" "2023-01-15"
  [ "$status" -eq 0 ]
  IFS='|' read -r extracted_date raw_remainder matched <<< "$output"
  cleaned_remainder=$(clean_date_filename_remainder "$raw_remainder")
  echo "[DEBUG] Testing: report-2023-01-15.pdf" >&2
  echo "[DEBUG] Matcher function: extract_date_from_filename" >&2
  echo "[DEBUG] Expected extracted_date: 2023-01-15" >&2
  echo "[DEBUG] Expected raw_remainder: report-.pdf" >&2
  echo "[DEBUG] Expected cleaned_remainder: report.pdf" >&2
  echo "[DEBUG] Actual extracted_date: $extracted_date" >&2
  echo "[DEBUG] Actual raw_remainder: $raw_remainder" >&2
  echo "[DEBUG] Actual cleaned_remainder: $cleaned_remainder" >&2
  assert_equal "$extracted_date" "2023-01-15"
  assert_equal "$raw_remainder" "report-.pdf"
  assert_equal "$cleaned_remainder" "report.pdf"
}

@test "extract_date_from_filename - client-notes_20240320.txt" {
  run extract_date_from_filename "client-notes_20240320.txt" "2024-03-20"
  [ "$status" -eq 0 ]
  IFS='|' read -r extracted_date raw_remainder matched <<< "$output"
  cleaned_remainder=$(clean_date_filename_remainder "$raw_remainder")
  echo "[DEBUG] Testing: client-notes_20240320.txt" >&2
  echo "[DEBUG] Matcher function: extract_date_from_filename" >&2
  echo "[DEBUG] Expected extracted_date: 2024-03-20" >&2
  echo "[DEBUG] Expected raw_remainder: client-notes_.txt" >&2
  echo "[DEBUG] Expected cleaned_remainder: client-notes.txt" >&2
  echo "[DEBUG] Actual extracted_date: $extracted_date" >&2
  echo "[DEBUG] Actual raw_remainder: $raw_remainder" >&2
  echo "[DEBUG] Actual cleaned_remainder: $cleaned_remainder" >&2
  assert_equal "$extracted_date" "2024-03-20"
  assert_equal "$raw_remainder" "client-notes_.txt"
  assert_equal "$cleaned_remainder" "client-notes.txt"
}

@test "extract_date_from_filename - 05-25-2023_summary.docx" {
  run extract_date_from_filename "05-25-2023_summary.docx" "2023-05-25"
  [ "$status" -eq 0 ]
  IFS='|' read -r extracted_date raw_remainder matched <<< "$output"
  cleaned_remainder=$(clean_date_filename_remainder "$raw_remainder")
  echo "[DEBUG] Testing: 05-25-2023_summary.docx" >&2
  echo "[DEBUG] Matcher function: extract_date_from_filename" >&2
  echo "[DEBUG] Expected extracted_date: 2023-05-25" >&2
  echo "[DEBUG] Expected raw_remainder: _summary.docx" >&2
  echo "[DEBUG] Expected cleaned_remainder: summary.docx" >&2
  echo "[DEBUG] Actual extracted_date: $extracted_date" >&2
  echo "[DEBUG] Actual raw_remainder: $raw_remainder" >&2
  echo "[DEBUG] Actual cleaned_remainder: $cleaned_remainder" >&2
  assert_equal "$extracted_date" "2023-05-25"
  assert_equal "$raw_remainder" "_summary.docx"
  assert_equal "$cleaned_remainder" "summary.docx"
}

@test "extract_date_from_filename - archive 10202024.zip" {
  run extract_date_from_filename "archive 10202024.zip" "2024-10-20"
  [ "$status" -eq 0 ]
  IFS='|' read -r extracted_date raw_remainder matched <<< "$output"
  cleaned_remainder=$(clean_date_filename_remainder "$raw_remainder")
  echo "[DEBUG] Testing: archive 10202024.zip" >&2
  echo "[DEBUG] Matcher function: extract_date_from_filename" >&2
  echo "[DEBUG] Expected extracted_date: 2024-10-20" >&2
  echo "[DEBUG] Expected raw_remainder: archive .zip" >&2
  echo "[DEBUG] Expected cleaned_remainder: archive.zip" >&2
  echo "[DEBUG] Actual extracted_date: $extracted_date" >&2
  echo "[DEBUG] Actual raw_remainder: $raw_remainder" >&2
  echo "[DEBUG] Actual cleaned_remainder: $cleaned_remainder" >&2
  assert_equal "$extracted_date" "2024-10-20"
  assert_equal "$raw_remainder" "archive .zip"
  assert_equal "$cleaned_remainder" "archive.zip"
}

@test "extract_date_from_filename - no_date_in_this_file.txt" {
  run extract_date_from_filename "no_date_in_this_file.txt" ""
  [ "$status" -eq 0 ]
  IFS='|' read -r extracted_date raw_remainder matched <<< "$output"
  cleaned_remainder=$(clean_date_filename_remainder "$raw_remainder")
  echo "[DEBUG] Testing: no_date_in_this_file.txt" >&2
  echo "[DEBUG] Matcher function: extract_date_from_filename" >&2
  echo "[DEBUG] Expected extracted_date: " >&2
  echo "[DEBUG] Expected raw_remainder: no_date_in_this_file.txt" >&2
  echo "[DEBUG] Expected cleaned_remainder: no_date_in_this_file.txt" >&2
  echo "[DEBUG] Actual extracted_date: $extracted_date" >&2
  echo "[DEBUG] Actual raw_remainder: $raw_remainder" >&2
  echo "[DEBUG] Actual cleaned_remainder: $cleaned_remainder" >&2
  assert_equal "$extracted_date" ""
  assert_equal "$raw_remainder" "no_date_in_this_file.txt"
  assert_equal "$cleaned_remainder" "no_date_in_this_file.txt"
}

@test "extract_date_from_filename - 20230101_and_20240202.log" {
  run extract_date_from_filename "20230101_and_20240202.log" "2023-01-01,2024-02-02"
  [ "$status" -eq 0 ]
  IFS='|' read -r extracted_date raw_remainder matched <<< "$output"
  cleaned_remainder=$(clean_date_filename_remainder "$raw_remainder")
  echo "[DEBUG] Testing: 20230101_and_20240202.log" >&2
  echo "[DEBUG] Matcher function: extract_date_from_filename" >&2
  echo "[DEBUG] Expected extracted_date: 2023-01-01,2024-02-02" >&2
  echo "[DEBUG] Expected raw_remainder: _and_.log" >&2
  echo "[DEBUG] Expected cleaned_remainder: and.log" >&2
  echo "[DEBUG] Actual extracted_date: $extracted_date" >&2
  echo "[DEBUG] Actual raw_remainder: $raw_remainder" >&2
  echo "[DEBUG] Actual cleaned_remainder: $cleaned_remainder" >&2
  assert_equal "$extracted_date" "2023-01-01,2024-02-02"
  assert_equal "$raw_remainder" "_and_.log"
  assert_equal "$cleaned_remainder" "and.log"
}

@test "extract_date_from_filename - scan 25-Dec-2023.jpg" {
  run extract_date_from_filename "scan 25-Dec-2023.jpg" "2023-12-25"
  [ "$status" -eq 0 ]
  IFS='|' read -r extracted_date raw_remainder matched <<< "$output"
  cleaned_remainder=$(clean_date_filename_remainder "$raw_remainder")
  echo "[DEBUG] Testing: scan 25-Dec-2023.jpg" >&2
  echo "[DEBUG] Matcher function: extract_date_from_filename" >&2
  echo "[DEBUG] Expected extracted_date: 2023-12-25" >&2
  echo "[DEBUG] Expected raw_remainder: scan .jpg" >&2
  echo "[DEBUG] Expected cleaned_remainder: scan.jpg" >&2
  echo "[DEBUG] Actual extracted_date: $extracted_date" >&2
  echo "[DEBUG] Actual raw_remainder: $raw_remainder" >&2
  echo "[DEBUG] Actual cleaned_remainder: $cleaned_remainder" >&2
  assert_equal "$extracted_date" "2023-12-25"
  assert_equal "$raw_remainder" "scan .jpg"
  assert_equal "$cleaned_remainder" "scan.jpg"
}

@test "extract_date_from_filename - report-for-1st-jan-2024.txt" {
  run extract_date_from_filename "report-for-1st-jan-2024.txt" "2024-01-01"
  [ "$status" -eq 0 ]
  IFS='|' read -r extracted_date raw_remainder matched <<< "$output"
  cleaned_remainder=$(clean_date_filename_remainder "$raw_remainder")
  echo "[DEBUG] Testing: report-for-1st-jan-2024.txt" >&2
  echo "[DEBUG] Matcher function: extract_date_from_filename" >&2
  echo "[DEBUG] Expected extracted_date: 2024-01-01" >&2
  echo "[DEBUG] Expected raw_remainder: report-for-.txt" >&2
  echo "[DEBUG] Expected cleaned_remainder: report-for.txt" >&2
  echo "[DEBUG] Actual extracted_date: $extracted_date" >&2
  echo "[DEBUG] Actual raw_remainder: $raw_remainder" >&2
  echo "[DEBUG] Actual cleaned_remainder: $cleaned_remainder" >&2
  assert_equal "$extracted_date" "2024-01-01"
  assert_equal "$raw_remainder" "report-for-.txt"
  assert_equal "$cleaned_remainder" "report-for.txt"
}
