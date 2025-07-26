#!/usr/bin/env bats

load "${BATS_TEST_DIRNAME}/../test-helper/bats-support/load.bash"
load "${BATS_TEST_DIRNAME}/../test-helper/bats-assert/load.bash"
load "${BATS_TEST_DIRNAME}/../test-helper/bats-file/load.bash"

# Auto-generated BATS tests for date extraction from path
source "${BATS_TEST_DIRNAME}/../utils/date_utils.sh"


@test "extract_date_from_path - WHS/2025-07-15/Docs/Report_2025-07-15.pdf" {
  run extract_date_from_path "WHS/2025-07-15/Docs/Report_2025-07-15.pdf" "2025-07-15"
  [ "$status" -eq 0 ]
  IFS='|' read -r extracted_date raw_remainder matched <<< "$output"
  cleaned_remainder=$(python3 $BATS_TEST_DIRNAME/../../core/utils/name_matcher.py --clean-filename "$raw_remainder")
  echo "----- TEST CASE -----" >&2
  echo "Comment: Date appears in both folder and filename" >&2
  echo "function: extract_date_from_path" >&2
  echo "full_path: WHS/2025-07-15/Docs/Report_2025-07-15.pdf" >&2
  echo "date to match: 2025-07-15" >&2
  echo "expected_match: true" >&2
  echo "raw remainder expected: WHS//Docs/Report_2025-07-15.pdf" >&2
  echo "raw remainder matched: $raw_remainder" >&2
  echo "cleaned remainder expected: WHS Docs Report 2025 07 15.pdf" >&2
  echo "cleaned remainder matched: $cleaned_remainder" >&2
  echo "extracted_date expected: 2025-07-15" >&2
  echo "extracted_date matched: $extracted_date" >&2
  echo "expected match: $matched" >&2
  echo "---------------------" >&2
  assert_equal "$extracted_date" "2025-07-15"
  assert_equal "$raw_remainder" "WHS//Docs/Report_2025-07-15.pdf"
  assert_equal "$cleaned_remainder" "WHS Docs Report 2025 07 15.pdf"
}

@test "extract_date_from_path - Medical/2024-01-01 Reports/Smith Jane/Smith Jane Report 2024-01-01.pdf" {
  run extract_date_from_path "Medical/2024-01-01 Reports/Smith Jane/Smith Jane Report 2024-01-01.pdf" "2024-01-01"
  [ "$status" -eq 0 ]
  IFS='|' read -r extracted_date raw_remainder matched <<< "$output"
  cleaned_remainder=$(python3 $BATS_TEST_DIRNAME/../../core/utils/name_matcher.py --clean-filename "$raw_remainder")
  echo "----- TEST CASE -----" >&2
  echo "Comment: Date in folder with extra text and in filename" >&2
  echo "function: extract_date_from_path" >&2
  echo "full_path: Medical/2024-01-01 Reports/Smith Jane/Smith Jane Report 2024-01-01.pdf" >&2
  echo "date to match: 2024-01-01" >&2
  echo "expected_match: true" >&2
  echo "raw remainder expected: Medical/ Reports/Smith Jane/Smith Jane Report .pdf" >&2
  echo "raw remainder matched: $raw_remainder" >&2
  echo "cleaned remainder expected: Medical Reports Smith Jane Smith Jane Report.pdf" >&2
  echo "cleaned remainder matched: $cleaned_remainder" >&2
  echo "extracted_date expected: 2024-01-01,2024-01-01" >&2
  echo "extracted_date matched: $extracted_date" >&2
  echo "expected match: $matched" >&2
  echo "---------------------" >&2
  assert_equal "$extracted_date" "2024-01-01,2024-01-01"
  assert_equal "$raw_remainder" "Medical/ Reports/Smith Jane/Smith Jane Report .pdf"
  assert_equal "$cleaned_remainder" "Medical Reports Smith Jane Smith Jane Report.pdf"
}

@test "extract_date_from_path - 2023/Temp Person/Temp Person File.txt" {
  cleaned_remainder=$(python3 $BATS_TEST_DIRNAME/../../core/utils/name_matcher.py --clean-filename "2023/Temp Person/Temp Person File.txt")
  echo "----- TEST CASE -----" >&2
  echo "Comment: No full date match (partial year only)" >&2
  echo "function: extract_date_from_path" >&2
  echo "full_path: 2023/Temp Person/Temp Person File.txt" >&2
  echo "date to match: 2023-05-05" >&2
  echo "expected_match: false" >&2
  echo "raw remainder expected: " >&2
  echo "raw remainder matched: " >&2
  echo "cleaned remainder expected: 2023 Temp Person Temp Person File.txt" >&2
  echo "cleaned remainder matched: $cleaned_remainder" >&2
  echo "extracted_date expected: " >&2
  echo "extracted_date matched: " >&2
  echo "expected match: false" >&2
  echo "---------------------" >&2
  assert_equal "$cleaned_remainder" "2023 Temp Person Temp Person File.txt"
}

@test "extract_date_from_path - NDIS/Incidents 2022-12-31/John D/John D - Summary 2022-12-31.pdf" {
  run extract_date_from_path "NDIS/Incidents 2022-12-31/John D/John D - Summary 2022-12-31.pdf" "2022-12-31"
  [ "$status" -eq 0 ]
  IFS='|' read -r extracted_date raw_remainder matched <<< "$output"
  cleaned_remainder=$(python3 $BATS_TEST_DIRNAME/../../core/utils/name_matcher.py --clean-filename "$raw_remainder")
  echo "----- TEST CASE -----" >&2
  echo "Comment: Date in folder with extra text and in filename" >&2
  echo "function: extract_date_from_path" >&2
  echo "full_path: NDIS/Incidents 2022-12-31/John D/John D - Summary 2022-12-31.pdf" >&2
  echo "date to match: 2022-12-31" >&2
  echo "expected_match: true" >&2
  echo "raw remainder expected: NDIS/Incidents /John D/John D - Summary .pdf" >&2
  echo "raw remainder matched: $raw_remainder" >&2
  echo "cleaned remainder expected: NDIS Incidents John D John D Summary.pdf" >&2
  echo "cleaned remainder matched: $cleaned_remainder" >&2
  echo "extracted_date expected: 2022-12-31,2022-12-31" >&2
  echo "extracted_date matched: $extracted_date" >&2
  echo "expected match: $matched" >&2
  echo "---------------------" >&2
  assert_equal "$extracted_date" "2022-12-31,2022-12-31"
  assert_equal "$raw_remainder" "NDIS/Incidents /John D/John D - Summary .pdf"
  assert_equal "$cleaned_remainder" "NDIS Incidents John D John D Summary.pdf"
}

@test "extract_date_from_path - Unknown/2020/file.pdf" {
  cleaned_remainder=$(python3 $BATS_TEST_DIRNAME/../../core/utils/name_matcher.py --clean-filename "Unknown/2020/file.pdf")
  echo "----- TEST CASE -----" >&2
  echo "Comment: No match anywhere in path " >&2
  echo "function: extract_date_from_path" >&2
  echo "full_path: Unknown/2020/file.pdf" >&2
  echo "date to match: 2021-01-01" >&2
  echo "expected_match: false" >&2
  echo "raw remainder expected: " >&2
  echo "raw remainder matched: " >&2
  echo "cleaned remainder expected: Unknown 2020 file.pdf" >&2
  echo "cleaned remainder matched: $cleaned_remainder" >&2
  echo "extracted_date expected: " >&2
  echo "extracted_date matched: " >&2
  echo "expected match: false" >&2
  echo "---------------------" >&2
  assert_equal "$cleaned_remainder" "Unknown 2020 file.pdf"
}
