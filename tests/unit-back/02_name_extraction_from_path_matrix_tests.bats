#!/usr/bin/env bats

load "${BATS_TEST_DIRNAME}/../test-helper/bats-support/load.bash"
load "${BATS_TEST_DIRNAME}/../test-helper/bats-assert/load.bash"
load "${BATS_TEST_DIRNAME}/../test-helper/bats-file/load.bash"

# Auto-generated BATS tests for name extraction from path
source "${BATS_TEST_DIRNAME}/../../core/utils/name_utils.sh"


@test "extract_name_from_path - WHS - John Doe/2025/Docs John Doe/Report Notes for John Doe Incidents.pdf" {
  run extract_name_from_path "WHS - John Doe/2025/Docs John Doe/Report Notes for John Doe Incidents.pdf" "John Doe"
  [ "$status" -eq 0 ]
  IFS='|' read -r extracted_name raw_remainder matched <<< "$output"
  cleaned_remainder=$(clean_filename_remainder "$raw_remainder")
  echo "----- TEST CASE -----" >&2
  echo "Comment: Name appears multiple times in folders and filename" >&2
  echo "function: extract_name_from_path" >&2
  echo "full_path: WHS - John Doe/2025/Docs John Doe/Report Notes for John Doe Incidents.pdf" >&2
  echo "name to match: John Doe" >&2
  echo "expected_match: true" >&2
  echo "raw remainder expected: WHS -  /2025/Docs  /Report Notes for   Incidents.pdf" >&2
  echo "raw remainder matched: $raw_remainder" >&2
  echo "cleaned remainder expected: WHS 2025 Docs Report Notes for Incidents.pdf" >&2
  echo "cleaned remainder matched: $cleaned_remainder" >&2
  echo "extracted_name expected: John,John,John,Doe,Doe,Doe" >&2
  echo "extracted_name matched: $extracted_name" >&2
  echo "expected match: $matched" >&2
  echo "---------------------" >&2
  assert_equal "$extracted_name" "John,John,John,Doe,Doe,Doe"
  assert_equal "$raw_remainder" "WHS -  /2025/Docs  /Report Notes for   Incidents.pdf"
  assert_equal "$cleaned_remainder" "WHS 2025 Docs Report Notes for Incidents.pdf"
}

@test "extract_name_from_path - Medical/2024/Smith Jane/Smith Jane Report for Jane.pdf" {
  run extract_name_from_path "Medical/2024/Smith Jane/Smith Jane Report for Jane.pdf" "Jane Smith"
  [ "$status" -eq 0 ]
  IFS='|' read -r extracted_name raw_remainder matched <<< "$output"
  cleaned_remainder=$(clean_filename_remainder "$raw_remainder")
  echo "----- TEST CASE -----" >&2
  echo "Comment: Name appears in two folders and filename" >&2
  echo "function: extract_name_from_path" >&2
  echo "full_path: Medical/2024/Smith Jane/Smith Jane Report for Jane.pdf" >&2
  echo "name to match: Jane Smith" >&2
  echo "expected_match: true" >&2
  echo "raw remainder expected: Medical/2024/ /  Report for .pdf" >&2
  echo "raw remainder matched: $raw_remainder" >&2
  echo "cleaned remainder expected: Medical 2024 Report for.pdf" >&2
  echo "cleaned remainder matched: $cleaned_remainder" >&2
  echo "extracted_name expected: Jane,Jane,Jane,Smith,Smith" >&2
  echo "extracted_name matched: $extracted_name" >&2
  echo "expected match: $matched" >&2
  echo "---------------------" >&2
  assert_equal "$extracted_name" "Jane,Jane,Jane,Smith,Smith"
  assert_equal "$raw_remainder" "Medical/2024/ /  Report for .pdf"
  assert_equal "$cleaned_remainder" "Medical 2024 Report for.pdf"
}

@test "extract_name_from_path - 2023/Temp Person/Temp Person File.txt" {
  run extract_name_from_path "2023/Temp Person/Temp Person File.txt" "Temp Person"
  [ "$status" -eq 0 ]
  IFS='|' read -r extracted_name raw_remainder matched <<< "$output"
  cleaned_remainder=$(clean_filename_remainder "$raw_remainder")
  echo "----- TEST CASE -----" >&2
  echo "Comment: Name appears in folder and filename" >&2
  echo "function: extract_name_from_path" >&2
  echo "full_path: 2023/Temp Person/Temp Person File.txt" >&2
  echo "name to match: Temp Person" >&2
  echo "expected_match: true" >&2
  echo "raw remainder expected: 2023/ /  File.txt" >&2
  echo "raw remainder matched: $raw_remainder" >&2
  echo "cleaned remainder expected: 2023 File.txt" >&2
  echo "cleaned remainder matched: $cleaned_remainder" >&2
  echo "extracted_name expected: Temp,Temp,Person,Person" >&2
  echo "extracted_name matched: $extracted_name" >&2
  echo "expected match: $matched" >&2
  echo "---------------------" >&2
  assert_equal "$extracted_name" "Temp,Temp,Person,Person"
  assert_equal "$raw_remainder" "2023/ /  File.txt"
  assert_equal "$cleaned_remainder" "2023 File.txt"
}

@test "extract_name_from_path - NDIS/2022/John D/John D - Summary John D.pdf" {
  run extract_name_from_path "NDIS/2022/John D/John D - Summary John D.pdf" "John D"
  [ "$status" -eq 0 ]
  IFS='|' read -r extracted_name raw_remainder matched <<< "$output"
  cleaned_remainder=$(clean_filename_remainder "$raw_remainder")
  echo "----- TEST CASE -----" >&2
  echo "Comment: Name appears in folder and filename, with separator" >&2
  echo "function: extract_name_from_path" >&2
  echo "full_path: NDIS/2022/John D/John D - Summary John D.pdf" >&2
  echo "name to match: John D" >&2
  echo "expected_match: true" >&2
  echo "raw remainder expected: NDIS/2022// - Summary .pdf" >&2
  echo "raw remainder matched: $raw_remainder" >&2
  echo "cleaned remainder expected: NDIS 2022 Summary.pdf" >&2
  echo "cleaned remainder matched: $cleaned_remainder" >&2
  echo "extracted_name expected: John D,John D,John D" >&2
  echo "extracted_name matched: $extracted_name" >&2
  echo "expected match: $matched" >&2
  echo "---------------------" >&2
  assert_equal "$extracted_name" "John D,John D,John D"
  assert_equal "$raw_remainder" "NDIS/2022// - Summary .pdf"
  assert_equal "$cleaned_remainder" "NDIS 2022 Summary.pdf"
}

@test "extract_name_from_path - Unknown/2020/file.pdf" {
  cleaned_remainder=$(clean_filename_remainder "Unknown/2020/file.pdf")
  echo "----- TEST CASE -----" >&2
  echo "Comment: No match anywhere in path " >&2
  echo "function: extract_name_from_path" >&2
  echo "full_path: Unknown/2020/file.pdf" >&2
  echo "name to match: John Doe" >&2
  echo "expected_match: false" >&2
  echo "raw remainder expected: " >&2
  echo "raw remainder matched: " >&2
  echo "cleaned remainder expected: Unknown 2020 file.pdf" >&2
  echo "cleaned remainder matched: $cleaned_remainder" >&2
  echo "extracted_name expected: " >&2
  echo "extracted_name matched: " >&2
  echo "expected match: false" >&2
  echo "---------------------" >&2
  assert_equal "$cleaned_remainder" "Unknown 2020 file.pdf"
}
