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
  echo "raw remainder expected: WHS//Docs/Report_.pdf" >&2
  echo "raw remainder matched: $raw_remainder" >&2
  echo "cleaned remainder expected: WHS Docs Report.pdf" >&2
  echo "cleaned remainder matched: $cleaned_remainder" >&2
  echo "extracted_date expected: 20250715,20250715" >&2
  echo "extracted_date matched: $extracted_date" >&2
  echo "expected match: $matched" >&2
  echo "---------------------" >&2
  assert_equal "$extracted_date" "20250715,20250715"
  assert_equal "$raw_remainder" "WHS//Docs/Report_.pdf"
  assert_equal "$cleaned_remainder" "WHS Docs Report.pdf"
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
  echo "extracted_date expected: 20240101,20240101" >&2
  echo "extracted_date matched: $extracted_date" >&2
  echo "expected match: $matched" >&2
  echo "---------------------" >&2
  assert_equal "$extracted_date" "20240101,20240101"
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
  echo "extracted_date expected: 20221231,20221231" >&2
  echo "extracted_date matched: $extracted_date" >&2
  echo "expected match: $matched" >&2
  echo "---------------------" >&2
  assert_equal "$extracted_date" "20221231,20221231"
  assert_equal "$raw_remainder" "NDIS/Incidents /John D/John D - Summary .pdf"
  assert_equal "$cleaned_remainder" "NDIS Incidents John D John D Summary.pdf"
}

@test "extract_date_from_path - Unknown/2020/file.pdf" {
  cleaned_remainder=$(python3 $BATS_TEST_DIRNAME/../../core/utils/name_matcher.py --clean-filename "Unknown/2020/file.pdf")
  echo "----- TEST CASE -----" >&2
  echo "Comment: No match anywhere in path" >&2
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

@test "extract_date_from_path - Support Plans/2024/15.05.2024_Active Plans/Mary Wilson/Mary Wilson Plan 15.05.2024.pdf" {
  run extract_date_from_path "Support Plans/2024/15.05.2024_Active Plans/Mary Wilson/Mary Wilson Plan 15.05.2024.pdf" "2024-05-15"
  [ "$status" -eq 0 ]
  IFS='|' read -r extracted_date raw_remainder matched <<< "$output"
  cleaned_remainder=$(python3 $BATS_TEST_DIRNAME/../../core/utils/name_matcher.py --clean-filename "$raw_remainder")
  echo "----- TEST CASE -----" >&2
  echo "Comment: Dot-separated date format" >&2
  echo "function: extract_date_from_path" >&2
  echo "full_path: Support Plans/2024/15.05.2024_Active Plans/Mary Wilson/Mary Wilson Plan 15.05.2024.pdf" >&2
  echo "date to match: 2024-05-15" >&2
  echo "expected_match: true" >&2
  echo "raw remainder expected: Support Plans/2024/_Active Plans/Mary Wilson/Mary Wilson Plan .pdf" >&2
  echo "raw remainder matched: $raw_remainder" >&2
  echo "cleaned remainder expected: Support Plans 2024 Active Plans Mary Wilson Mary Wilson Plan.pdf" >&2
  echo "cleaned remainder matched: $cleaned_remainder" >&2
  echo "extracted_date expected: 20240515,20240515" >&2
  echo "extracted_date matched: $extracted_date" >&2
  echo "expected match: $matched" >&2
  echo "---------------------" >&2
  assert_equal "$extracted_date" "20240515,20240515"
  assert_equal "$raw_remainder" "Support Plans/2024/_Active Plans/Mary Wilson/Mary Wilson Plan .pdf"
  assert_equal "$cleaned_remainder" "Support Plans 2024 Active Plans Mary Wilson Mary Wilson Plan.pdf"
}

@test "extract_date_from_path - Behavioral Support/2023/May 15 2023 Reports/Dr. Smith/Dr. Smith Analysis May 15 2023.pdf" {
  run extract_date_from_path "Behavioral Support/2023/May 15 2023 Reports/Dr. Smith/Dr. Smith Analysis May 15 2023.pdf" "2023-05-15"
  [ "$status" -eq 0 ]
  IFS='|' read -r extracted_date raw_remainder matched <<< "$output"
  cleaned_remainder=$(python3 $BATS_TEST_DIRNAME/../../core/utils/name_matcher.py --clean-filename "$raw_remainder")
  echo "----- TEST CASE -----" >&2
  echo "Comment: Month name date format" >&2
  echo "function: extract_date_from_path" >&2
  echo "full_path: Behavioral Support/2023/May 15 2023 Reports/Dr. Smith/Dr. Smith Analysis May 15 2023.pdf" >&2
  echo "date to match: 2023-05-15" >&2
  echo "expected_match: true" >&2
  echo "raw remainder expected: Behavioral Support/2023/ Reports/Dr. Smith/Dr. Smith Analysis .pdf" >&2
  echo "raw remainder matched: $raw_remainder" >&2
  echo "cleaned remainder expected: Behavioral Support 2023 Reports Dr Smith Dr Smith Analysis.pdf" >&2
  echo "cleaned remainder matched: $cleaned_remainder" >&2
  echo "extracted_date expected: 20230515,20230515" >&2
  echo "extracted_date matched: $extracted_date" >&2
  echo "expected match: $matched" >&2
  echo "---------------------" >&2
  assert_equal "$extracted_date" "20230515,20230515"
  assert_equal "$raw_remainder" "Behavioral Support/2023/ Reports/Dr. Smith/Dr. Smith Analysis .pdf"
  assert_equal "$cleaned_remainder" "Behavioral Support 2023 Reports Dr Smith Dr Smith Analysis.pdf"
}

@test "extract_date_from_path - Medical Records/2024/15th January 2024 Assessments/Patient Data/Patient Data Assessment 15th January 2024.pdf" {
  run extract_date_from_path "Medical Records/2024/15th January 2024 Assessments/Patient Data/Patient Data Assessment 15th January 2024.pdf" "2024-01-15"
  [ "$status" -eq 0 ]
  IFS='|' read -r extracted_date raw_remainder matched <<< "$output"
  cleaned_remainder=$(python3 $BATS_TEST_DIRNAME/../../core/utils/name_matcher.py --clean-filename "$raw_remainder")
  echo "----- TEST CASE -----" >&2
  echo "Comment: Ordinal date with full month" >&2
  echo "function: extract_date_from_path" >&2
  echo "full_path: Medical Records/2024/15th January 2024 Assessments/Patient Data/Patient Data Assessment 15th January 2024.pdf" >&2
  echo "date to match: 2024-01-15" >&2
  echo "expected_match: true" >&2
  echo "raw remainder expected: Medical Records/2024/ Assessments/Patient Data/Patient Data Assessment .pdf" >&2
  echo "raw remainder matched: $raw_remainder" >&2
  echo "cleaned remainder expected: Medical Records 2024 Assessments Patient Data Patient Data Assessment.pdf" >&2
  echo "cleaned remainder matched: $cleaned_remainder" >&2
  echo "extracted_date expected: 20240115,20240115" >&2
  echo "extracted_date matched: $extracted_date" >&2
  echo "expected match: $matched" >&2
  echo "---------------------" >&2
  assert_equal "$extracted_date" "20240115,20240115"
  assert_equal "$raw_remainder" "Medical Records/2024/ Assessments/Patient Data/Patient Data Assessment .pdf"
  assert_equal "$cleaned_remainder" "Medical Records 2024 Assessments Patient Data Patient Data Assessment.pdf"
}

@test "extract_date_from_path - Photos & Videos/2023/2023.12.25_Christmas Photos/Client Photos/Client Christmas Photos 2023.12.25.zip" {
  run extract_date_from_path "Photos & Videos/2023/2023.12.25_Christmas Photos/Client Photos/Client Christmas Photos 2023.12.25.zip" "2023-12-25"
  [ "$status" -eq 0 ]
  IFS='|' read -r extracted_date raw_remainder matched <<< "$output"
  cleaned_remainder=$(python3 $BATS_TEST_DIRNAME/../../core/utils/name_matcher.py --clean-filename "$raw_remainder")
  echo "----- TEST CASE -----" >&2
  echo "Comment: Dot-separated date in deep nesting" >&2
  echo "function: extract_date_from_path" >&2
  echo "full_path: Photos & Videos/2023/2023.12.25_Christmas Photos/Client Photos/Client Christmas Photos 2023.12.25.zip" >&2
  echo "date to match: 2023-12-25" >&2
  echo "expected_match: true" >&2
  echo "raw remainder expected: Photos & Videos/2023/_Christmas Photos/Client Photos/Client Christmas Photos .zip" >&2
  echo "raw remainder matched: $raw_remainder" >&2
  echo "cleaned remainder expected: Photos Videos 2023 Christmas Photos Client Photos Client Christmas Photos.zip" >&2
  echo "cleaned remainder matched: $cleaned_remainder" >&2
  echo "extracted_date expected: 20231225,20231225" >&2
  echo "extracted_date matched: $extracted_date" >&2
  echo "expected match: $matched" >&2
  echo "---------------------" >&2
  assert_equal "$extracted_date" "20231225,20231225"
  assert_equal "$raw_remainder" "Photos & Videos/2023/_Christmas Photos/Client Photos/Client Christmas Photos .zip"
  assert_equal "$cleaned_remainder" "Photos Videos 2023 Christmas Photos Client Photos Client Christmas Photos.zip"
}

@test "extract_date_from_path - Emergency Contacts/2024.05.15 Date/2024_Updated/Contact List/Contact List.pdf" {
  run extract_date_from_path "Emergency Contacts/2024.05.15 Date/2024_Updated/Contact List/Contact List.pdf" "2024-05-15"
  [ "$status" -eq 0 ]
  IFS='|' read -r extracted_date raw_remainder matched <<< "$output"
  cleaned_remainder=$(python3 $BATS_TEST_DIRNAME/../../core/utils/name_matcher.py --clean-filename "$raw_remainder")
  echo "----- TEST CASE -----" >&2
  echo "Comment: Slash-separated date format" >&2
  echo "function: extract_date_from_path" >&2
  echo "full_path: Emergency Contacts/2024.05.15 Date/2024_Updated/Contact List/Contact List.pdf" >&2
  echo "date to match: 2024-05-15" >&2
  echo "expected_match: true" >&2
  echo "raw remainder expected: Emergency Contacts/ Date/2024_Updated/Contact List/Contact List.pdf" >&2
  echo "raw remainder matched: $raw_remainder" >&2
  echo "cleaned remainder expected: Emergency Contacts Date 2024 Updated Contact List Contact List.pdf" >&2
  echo "cleaned remainder matched: $cleaned_remainder" >&2
  echo "extracted_date expected: 20240515" >&2
  echo "extracted_date matched: $extracted_date" >&2
  echo "expected match: $matched" >&2
  echo "---------------------" >&2
  assert_equal "$extracted_date" "20240515"
  assert_equal "$raw_remainder" "Emergency Contacts/ Date/2024_Updated/Contact List/Contact List.pdf"
  assert_equal "$cleaned_remainder" "Emergency Contacts Date 2024 Updated Contact List Contact List.pdf"
}

@test "extract_date_from_path - Receipts/2023/December 25, 2023_Expenses/Expense Reports/Expense Report December 25, 2023.pdf" {
  run extract_date_from_path "Receipts/2023/December 25, 2023_Expenses/Expense Reports/Expense Report December 25, 2023.pdf" "2023-12-25"
  [ "$status" -eq 0 ]
  IFS='|' read -r extracted_date raw_remainder matched <<< "$output"
  cleaned_remainder=$(python3 $BATS_TEST_DIRNAME/../../core/utils/name_matcher.py --clean-filename "$raw_remainder")
  echo "----- TEST CASE -----" >&2
  echo "Comment: Month name with comma format" >&2
  echo "function: extract_date_from_path" >&2
  echo "full_path: Receipts/2023/December 25, 2023_Expenses/Expense Reports/Expense Report December 25, 2023.pdf" >&2
  echo "date to match: 2023-12-25" >&2
  echo "expected_match: true" >&2
  echo "raw remainder expected: Receipts/2023/_Expenses/Expense Reports/Expense Report .pdf" >&2
  echo "raw remainder matched: $raw_remainder" >&2
  echo "cleaned remainder expected: Receipts 2023 Expenses Expense Reports Expense Report.pdf" >&2
  echo "cleaned remainder matched: $cleaned_remainder" >&2
  echo "extracted_date expected: 20231225,20231225" >&2
  echo "extracted_date matched: $extracted_date" >&2
  echo "expected match: $matched" >&2
  echo "---------------------" >&2
  assert_equal "$extracted_date" "20231225,20231225"
  assert_equal "$raw_remainder" "Receipts/2023/_Expenses/Expense Reports/Expense Report .pdf"
  assert_equal "$cleaned_remainder" "Receipts 2023 Expenses Expense Reports Expense Report.pdf"
}

@test "extract_date_from_path - Mealtime Management/2024/15-May-2024_Diaries/Food Records/Food Diary 15-May-2024.pdf" {
  run extract_date_from_path "Mealtime Management/2024/15-May-2024_Diaries/Food Records/Food Diary 15-May-2024.pdf" "2024-05-15"
  [ "$status" -eq 0 ]
  IFS='|' read -r extracted_date raw_remainder matched <<< "$output"
  cleaned_remainder=$(python3 $BATS_TEST_DIRNAME/../../core/utils/name_matcher.py --clean-filename "$raw_remainder")
  echo "----- TEST CASE -----" >&2
  echo "Comment: Abbreviated month format" >&2
  echo "function: extract_date_from_path" >&2
  echo "full_path: Mealtime Management/2024/15-May-2024_Diaries/Food Records/Food Diary 15-May-2024.pdf" >&2
  echo "date to match: 2024-05-15" >&2
  echo "expected_match: true" >&2
  echo "raw remainder expected: Mealtime Management/2024/_Diaries/Food Records/Food Diary .pdf" >&2
  echo "raw remainder matched: $raw_remainder" >&2
  echo "cleaned remainder expected: Mealtime Management 2024 Diaries Food Records Food Diary.pdf" >&2
  echo "cleaned remainder matched: $cleaned_remainder" >&2
  echo "extracted_date expected: 20240515,20240515" >&2
  echo "extracted_date matched: $extracted_date" >&2
  echo "expected match: $matched" >&2
  echo "---------------------" >&2
  assert_equal "$extracted_date" "20240515,20240515"
  assert_equal "$raw_remainder" "Mealtime Management/2024/_Diaries/Food Records/Food Diary .pdf"
  assert_equal "$cleaned_remainder" "Mealtime Management 2024 Diaries Food Records Food Diary.pdf"
}

@test "extract_date_from_path - Incident Reports/2023/2023.01.01_and_2023.12.31_Annual/Summary Reports/Annual Summary 2023.01.01_and_2023.12.31.pdf" {
  run extract_date_from_path "Incident Reports/2023/2023.01.01_and_2023.12.31_Annual/Summary Reports/Annual Summary 2023.01.01_and_2023.12.31.pdf" "2023-01-01,2023-12-31"
  [ "$status" -eq 0 ]
  IFS='|' read -r extracted_date raw_remainder matched <<< "$output"
  cleaned_remainder=$(python3 $BATS_TEST_DIRNAME/../../core/utils/name_matcher.py --clean-filename "$raw_remainder")
  echo "----- TEST CASE -----" >&2
  echo "Comment: Multiple dates in complex path" >&2
  echo "function: extract_date_from_path" >&2
  echo "full_path: Incident Reports/2023/2023.01.01_and_2023.12.31_Annual/Summary Reports/Annual Summary 2023.01.01_and_2023.12.31.pdf" >&2
  echo "date to match: 2023-01-01,2023-12-31" >&2
  echo "expected_match: true" >&2
  echo "raw remainder expected: Incident Reports/2023/_and__Annual/Summary Reports/Annual Summary _and_.pdf" >&2
  echo "raw remainder matched: $raw_remainder" >&2
  echo "cleaned remainder expected: Incident Reports 2023 and Annual Summary Reports Annual Summary and.pdf" >&2
  echo "cleaned remainder matched: $cleaned_remainder" >&2
  echo "extracted_date expected: 20230101,20231231,20230101,20231231" >&2
  echo "extracted_date matched: $extracted_date" >&2
  echo "expected match: $matched" >&2
  echo "---------------------" >&2
  assert_equal "$extracted_date" "20230101,20231231,20230101,20231231"
  assert_equal "$raw_remainder" "Incident Reports/2023/_and__Annual/Summary Reports/Annual Summary _and_.pdf"
  assert_equal "$cleaned_remainder" "Incident Reports 2023 and Annual Summary Reports Annual Summary and.pdf"
}

@test "extract_date_from_path - Personal Care/2024/15th May 2024_Active/Assessment Records/Assessment 15th May 2024.pdf" {
  run extract_date_from_path "Personal Care/2024/15th May 2024_Active/Assessment Records/Assessment 15th May 2024.pdf" "2024-05-15"
  [ "$status" -eq 0 ]
  IFS='|' read -r extracted_date raw_remainder matched <<< "$output"
  cleaned_remainder=$(python3 $BATS_TEST_DIRNAME/../../core/utils/name_matcher.py --clean-filename "$raw_remainder")
  echo "----- TEST CASE -----" >&2
  echo "Comment: Ordinal date format" >&2
  echo "function: extract_date_from_path" >&2
  echo "full_path: Personal Care/2024/15th May 2024_Active/Assessment Records/Assessment 15th May 2024.pdf" >&2
  echo "date to match: 2024-05-15" >&2
  echo "expected_match: true" >&2
  echo "raw remainder expected: Personal Care/2024/_Active/Assessment Records/Assessment .pdf" >&2
  echo "raw remainder matched: $raw_remainder" >&2
  echo "cleaned remainder expected: Personal Care 2024 Active Assessment Records Assessment.pdf" >&2
  echo "cleaned remainder matched: $cleaned_remainder" >&2
  echo "extracted_date expected: 20240515,20240515" >&2
  echo "extracted_date matched: $extracted_date" >&2
  echo "expected match: $matched" >&2
  echo "---------------------" >&2
  assert_equal "$extracted_date" "20240515,20240515"
  assert_equal "$raw_remainder" "Personal Care/2024/_Active/Assessment Records/Assessment .pdf"
  assert_equal "$cleaned_remainder" "Personal Care 2024 Active Assessment Records Assessment.pdf"
}

@test "extract_date_from_path - Archive/2023/Invalid_32-13-2023_Data/Test Files/Test File.txt" {
  cleaned_remainder=$(python3 $BATS_TEST_DIRNAME/../../core/utils/name_matcher.py --clean-filename "Archive/2023/Invalid_32-13-2023_Data/Test Files/Test File.txt")
  echo "----- TEST CASE -----" >&2
  echo "Comment: Invalid date format" >&2
  echo "function: extract_date_from_path" >&2
  echo "full_path: Archive/2023/Invalid_32-13-2023_Data/Test Files/Test File.txt" >&2
  echo "date to match: " >&2
  echo "expected_match: false" >&2
  echo "raw remainder expected: Archive/2023/Invalid__Data/Test Files/Test File.txt" >&2
  echo "raw remainder matched: Archive/2023/Invalid__Data/Test Files/Test File.txt" >&2
  echo "cleaned remainder expected: Archive 2023 Invalid 32 13 2023 Data Test Files Test File.txt" >&2
  echo "cleaned remainder matched: $cleaned_remainder" >&2
  echo "extracted_date expected: " >&2
  echo "extracted_date matched: " >&2
  echo "expected match: false" >&2
  echo "---------------------" >&2
  assert_equal "$cleaned_remainder" "Archive 2023 Invalid 32 13 2023 Data Test Files Test File.txt"
}

@test "extract_date_from_path - Documents/2024/No_Date_Just_Text_12345/Reports/Report.txt" {
  cleaned_remainder=$(python3 $BATS_TEST_DIRNAME/../../core/utils/name_matcher.py --clean-filename "Documents/2024/No_Date_Just_Text_12345/Reports/Report.txt")
  echo "----- TEST CASE -----" >&2
  echo "Comment: No date just numbers" >&2
  echo "function: extract_date_from_path" >&2
  echo "full_path: Documents/2024/No_Date_Just_Text_12345/Reports/Report.txt" >&2
  echo "date to match: " >&2
  echo "expected_match: false" >&2
  echo "raw remainder expected: Documents/2024/No_Date_Just_Text_12345/Reports/Report.txt" >&2
  echo "raw remainder matched: Documents/2024/No_Date_Just_Text_12345/Reports/Report.txt" >&2
  echo "cleaned remainder expected: Documents 2024 No Date Just Text 12345 Reports Report.txt" >&2
  echo "cleaned remainder matched: $cleaned_remainder" >&2
  echo "extracted_date expected: " >&2
  echo "extracted_date matched: " >&2
  echo "expected match: false" >&2
  echo "---------------------" >&2
  assert_equal "$cleaned_remainder" "Documents 2024 No Date Just Text 12345 Reports Report.txt"
}

@test "extract_date_from_path - VC - John Doe Management/Support and NDIS Plan/22.07.2025 DSOA0476 ISP - exp 14.07.2026.pdf" {
  run extract_date_from_path "VC - John Doe Management/Support and NDIS Plan/22.07.2025 DSOA0476 ISP - exp 14.07.2026.pdf" "2025-07-22"
  [ "$status" -eq 0 ]
  IFS='|' read -r extracted_date raw_remainder matched <<< "$output"
  cleaned_remainder=$(python3 $BATS_TEST_DIRNAME/../../core/utils/name_matcher.py --clean-filename "$raw_remainder")
  echo "----- TEST CASE -----" >&2
  echo "Comment: Date with exp prefix exclusion in filename " >&2
  echo "function: extract_date_from_path" >&2
  echo "full_path: VC - John Doe Management/Support and NDIS Plan/22.07.2025 DSOA0476 ISP - exp 14.07.2026.pdf" >&2
  echo "date to match: 2025-07-22" >&2
  echo "expected_match: true" >&2
  echo "raw remainder expected: VC - John Doe Management/Support and NDIS Plan/ DSOA0476 ISP - exp 2026.07.14.pdf" >&2
  echo "raw remainder matched: $raw_remainder" >&2
  echo "cleaned remainder expected: VC John Doe Management Support and NDIS Plan DSOA0476 ISP exp 2026.07.14.pdf" >&2
  echo "cleaned remainder matched: $cleaned_remainder" >&2
  echo "extracted_date expected: 20250722" >&2
  echo "extracted_date matched: $extracted_date" >&2
  echo "expected match: $matched" >&2
  echo "---------------------" >&2
  assert_equal "$extracted_date" "20250722"
  assert_equal "$raw_remainder" "VC - John Doe Management/Support and NDIS Plan/ DSOA0476 ISP - exp 2026.07.14.pdf"
  assert_equal "$cleaned_remainder" "VC John Doe Management Support and NDIS Plan DSOA0476 ISP exp 2026.07.14.pdf"
}
