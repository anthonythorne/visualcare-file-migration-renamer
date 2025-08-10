#!/usr/bin/env bats

load "${BATS_TEST_DIRNAME}/../test-helper/bats-support/load.bash"
load "${BATS_TEST_DIRNAME}/../test-helper/bats-assert/load.bash"
load "${BATS_TEST_DIRNAME}/../test-helper/bats-file/load.bash"

# Auto-generated BATS tests for name extraction from path
source "${BATS_TEST_DIRNAME}/../utils/name_utils.sh"


@test "extract_name_from_path - WHS - John Doe/2025/Docs John Doe/Report Notes for John Doe Incidents.pdf" {
  run extract_name_from_path "WHS - John Doe/2025/Docs John Doe/Report Notes for John Doe Incidents.pdf" "John Doe"
  [ "$status" -eq 0 ]
  IFS='|' read -r extracted_name raw_remainder cleaned_remainder matched <<< "$output"
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
  run extract_name_from_path "Medical/2024/Smith Jane/Smith Jane Report for Jane.pdf" "Smith Jane"
  [ "$status" -eq 0 ]
  IFS='|' read -r extracted_name raw_remainder cleaned_remainder matched <<< "$output"
  echo "----- TEST CASE -----" >&2
  echo "Comment: Name appears in two folders and filename" >&2
  echo "function: extract_name_from_path" >&2
  echo "full_path: Medical/2024/Smith Jane/Smith Jane Report for Jane.pdf" >&2
  echo "name to match: Smith Jane" >&2
  echo "expected_match: true" >&2
  echo "raw remainder expected: Medical/2024/ /  Report for .pdf" >&2
  echo "raw remainder matched: $raw_remainder" >&2
  echo "cleaned remainder expected: Medical 2024 Report for.pdf" >&2
  echo "cleaned remainder matched: $cleaned_remainder" >&2
  echo "extracted_name expected: Smith,Smith,Jane,Jane,Jane" >&2
  echo "extracted_name matched: $extracted_name" >&2
  echo "expected match: $matched" >&2
  echo "---------------------" >&2
  assert_equal "$extracted_name" "Smith,Smith,Jane,Jane,Jane"
  assert_equal "$raw_remainder" "Medical/2024/ /  Report for .pdf"
  assert_equal "$cleaned_remainder" "Medical 2024 Report for.pdf"
}

@test "extract_name_from_path - 2023/Temp Person/Temp Person File.txt" {
  run extract_name_from_path "2023/Temp Person/Temp Person File.txt" "Temp Person"
  [ "$status" -eq 0 ]
  IFS='|' read -r extracted_name raw_remainder cleaned_remainder matched <<< "$output"
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
  run extract_name_from_path "NDIS/2022/John D/John D - Summary John D.pdf" "John Doe"
  [ "$status" -eq 0 ]
  IFS='|' read -r extracted_name raw_remainder cleaned_remainder matched <<< "$output"
  echo "----- TEST CASE -----" >&2
  echo "Comment: Name appears in folder and filename, with separator" >&2
  echo "function: extract_name_from_path" >&2
  echo "full_path: NDIS/2022/John D/John D - Summary John D.pdf" >&2
  echo "name to match: John Doe" >&2
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
  echo "Comment: No match anywhere in path" >&2
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

@test "extract_name_from_path - Client Files/2024/Support Plans/Mary Jane Wilson/Mary Jane Wilson Progress Report.pdf" {
  run extract_name_from_path "Client Files/2024/Support Plans/Mary Jane Wilson/Mary Jane Wilson Progress Report.pdf" "Mary Jane Wilson"
  [ "$status" -eq 0 ]
  IFS='|' read -r extracted_name raw_remainder cleaned_remainder matched <<< "$output"
  echo "----- TEST CASE -----" >&2
  echo "Comment: Multi-word name in deep nesting" >&2
  echo "function: extract_name_from_path" >&2
  echo "full_path: Client Files/2024/Support Plans/Mary Jane Wilson/Mary Jane Wilson Progress Report.pdf" >&2
  echo "name to match: Mary Jane Wilson" >&2
  echo "expected_match: true" >&2
  echo "raw remainder expected: Client Files/2024/Support Plans/  /   Progress Report.pdf" >&2
  echo "raw remainder matched: $raw_remainder" >&2
  echo "cleaned remainder expected: Client Files 2024 Support Plans Progress Report.pdf" >&2
  echo "cleaned remainder matched: $cleaned_remainder" >&2
  echo "extracted_name expected: Mary,Mary,Jane,Jane,Wilson,Wilson" >&2
  echo "extracted_name matched: $extracted_name" >&2
  echo "expected match: $matched" >&2
  echo "---------------------" >&2
  assert_equal "$extracted_name" "Mary,Mary,Jane,Jane,Wilson,Wilson"
  assert_equal "$raw_remainder" "Client Files/2024/Support Plans/  /   Progress Report.pdf"
  assert_equal "$cleaned_remainder" "Client Files 2024 Support Plans Progress Report.pdf"
}

@test "extract_name_from_path - Documents/Personal Care/John Michael Smith/John Michael Smith Assessment 2024.pdf" {
  run extract_name_from_path "Documents/Personal Care/John Michael Smith/John Michael Smith Assessment 2024.pdf" "John Michael Smith"
  [ "$status" -eq 0 ]
  IFS='|' read -r extracted_name raw_remainder cleaned_remainder matched <<< "$output"
  echo "----- TEST CASE -----" >&2
  echo "Comment: Three-word name with spaces" >&2
  echo "function: extract_name_from_path" >&2
  echo "full_path: Documents/Personal Care/John Michael Smith/John Michael Smith Assessment 2024.pdf" >&2
  echo "name to match: John Michael Smith" >&2
  echo "expected_match: true" >&2
  echo "raw remainder expected: Documents/Personal Care/  /   Assessment 2024.pdf" >&2
  echo "raw remainder matched: $raw_remainder" >&2
  echo "cleaned remainder expected: Documents Personal Care Assessment 2024.pdf" >&2
  echo "cleaned remainder matched: $cleaned_remainder" >&2
  echo "extracted_name expected: John,John,Michael,Michael,Smith,Smith" >&2
  echo "extracted_name matched: $extracted_name" >&2
  echo "expected match: $matched" >&2
  echo "---------------------" >&2
  assert_equal "$extracted_name" "John,John,Michael,Michael,Smith,Smith"
  assert_equal "$raw_remainder" "Documents/Personal Care/  /   Assessment 2024.pdf"
  assert_equal "$cleaned_remainder" "Documents Personal Care Assessment 2024.pdf"
}

@test "extract_name_from_path - Archive/2023/Incident Reports/Sarah Johnson/Sarah Johnson Incident Report.pdf" {
  run extract_name_from_path "Archive/2023/Incident Reports/Sarah Johnson/Sarah Johnson Incident Report.pdf" "Sarah Johnson"
  [ "$status" -eq 0 ]
  IFS='|' read -r extracted_name raw_remainder cleaned_remainder matched <<< "$output"
  echo "----- TEST CASE -----" >&2
  echo "Comment: Name with deep nesting" >&2
  echo "function: extract_name_from_path" >&2
  echo "full_path: Archive/2023/Incident Reports/Sarah Johnson/Sarah Johnson Incident Report.pdf" >&2
  echo "name to match: Sarah Johnson" >&2
  echo "expected_match: true" >&2
  echo "raw remainder expected: Archive/2023/Incident Reports/ /  Incident Report.pdf" >&2
  echo "raw remainder matched: $raw_remainder" >&2
  echo "cleaned remainder expected: Archive 2023 Incident Reports Incident Report.pdf" >&2
  echo "cleaned remainder matched: $cleaned_remainder" >&2
  echo "extracted_name expected: Sarah,Sarah,Johnson,Johnson" >&2
  echo "extracted_name matched: $extracted_name" >&2
  echo "expected match: $matched" >&2
  echo "---------------------" >&2
  assert_equal "$extracted_name" "Sarah,Sarah,Johnson,Johnson"
  assert_equal "$raw_remainder" "Archive/2023/Incident Reports/ /  Incident Report.pdf"
  assert_equal "$cleaned_remainder" "Archive 2023 Incident Reports Incident Report.pdf"
}

@test "extract_name_from_path - Photos & Videos/2024/Client Photos/Anne-Marie O'Connor/Anne-Marie O'Connor Photo Album.zip" {
  run extract_name_from_path "Photos & Videos/2024/Client Photos/Anne-Marie O'Connor/Anne-Marie O'Connor Photo Album.zip" "Anne-Marie O'Connor"
  [ "$status" -eq 0 ]
  IFS='|' read -r extracted_name raw_remainder cleaned_remainder matched <<< "$output"
  echo "----- TEST CASE -----" >&2
  echo "Comment: Name with hyphens and apostrophe" >&2
  echo "function: extract_name_from_path" >&2
  echo "full_path: Photos & Videos/2024/Client Photos/Anne-Marie O'Connor/Anne-Marie O'Connor Photo Album.zip" >&2
  echo "name to match: Anne-Marie O'Connor" >&2
  echo "expected_match: true" >&2
  echo "raw remainder expected: Photos & Videos/2024/Client Photos/ /  Photo Album.zip" >&2
  echo "raw remainder matched: $raw_remainder" >&2
  echo "cleaned remainder expected: Photos Videos 2024 Client Photos Photo Album.zip" >&2
  echo "cleaned remainder matched: $cleaned_remainder" >&2
  echo "extracted_name expected: Anne-Marie,Anne-Marie,O'Connor,O'Connor" >&2
  echo "extracted_name matched: $extracted_name" >&2
  echo "expected match: $matched" >&2
  echo "---------------------" >&2
  assert_equal "$extracted_name" "Anne-Marie,Anne-Marie,O'Connor,O'Connor"
  assert_equal "$raw_remainder" "Photos & Videos/2024/Client Photos/ /  Photo Album.zip"
  assert_equal "$cleaned_remainder" "Photos Videos 2024 Client Photos Photo Album.zip"
}

@test "extract_name_from_path - Medical Records/2024/Assessments/Elizabeth van der Berg/Elizabeth van der Berg Medical Assessment.pdf" {
  run extract_name_from_path "Medical Records/2024/Assessments/Elizabeth van der Berg/Elizabeth van der Berg Medical Assessment.pdf" "Elizabeth van der Berg"
  [ "$status" -eq 0 ]
  IFS='|' read -r extracted_name raw_remainder cleaned_remainder matched <<< "$output"
  echo "----- TEST CASE -----" >&2
  echo "Comment: Name with multiple words" >&2
  echo "function: extract_name_from_path" >&2
  echo "full_path: Medical Records/2024/Assessments/Elizabeth van der Berg/Elizabeth van der Berg Medical Assessment.pdf" >&2
  echo "name to match: Elizabeth van der Berg" >&2
  echo "expected_match: true" >&2
  echo "raw remainder expected: Medical Records/2024/Assessments/   /    Medical Assessment.pdf" >&2
  echo "raw remainder matched: $raw_remainder" >&2
  echo "cleaned remainder expected: Medical Records 2024 Assessments Medical Assessment.pdf" >&2
  echo "cleaned remainder matched: $cleaned_remainder" >&2
  echo "extracted_name expected: Elizabeth,Elizabeth,van,van,der,der,Berg,Berg" >&2
  echo "extracted_name matched: $extracted_name" >&2
  echo "expected match: $matched" >&2
  echo "---------------------" >&2
  assert_equal "$extracted_name" "Elizabeth,Elizabeth,van,van,der,der,Berg,Berg"
  assert_equal "$raw_remainder" "Medical Records/2024/Assessments/   /    Medical Assessment.pdf"
  assert_equal "$cleaned_remainder" "Medical Records 2024 Assessments Medical Assessment.pdf"
}

@test "extract_name_from_path - Support Plans/2023/Active Plans/Maria José Rodriguez/Maria José Rodriguez Support Plan.pdf" {
  run extract_name_from_path "Support Plans/2023/Active Plans/Maria José Rodriguez/Maria José Rodriguez Support Plan.pdf" "Maria José Rodriguez"
  [ "$status" -eq 0 ]
  IFS='|' read -r extracted_name raw_remainder cleaned_remainder matched <<< "$output"
  echo "----- TEST CASE -----" >&2
  echo "Comment: Name with accented characters" >&2
  echo "function: extract_name_from_path" >&2
  echo "full_path: Support Plans/2023/Active Plans/Maria José Rodriguez/Maria José Rodriguez Support Plan.pdf" >&2
  echo "name to match: Maria José Rodriguez" >&2
  echo "expected_match: true" >&2
  echo "raw remainder expected: Support Plans/2023/Active Plans/  /   Support Plan.pdf" >&2
  echo "raw remainder matched: $raw_remainder" >&2
  echo "cleaned remainder expected: Support Plans 2023 Active Plans Support Plan.pdf" >&2
  echo "cleaned remainder matched: $cleaned_remainder" >&2
  echo "extracted_name expected: Maria,Maria,José,José,Rodriguez,Rodriguez" >&2
  echo "extracted_name matched: $extracted_name" >&2
  echo "expected match: $matched" >&2
  echo "---------------------" >&2
  assert_equal "$extracted_name" "Maria,Maria,José,José,Rodriguez,Rodriguez"
  assert_equal "$raw_remainder" "Support Plans/2023/Active Plans/  /   Support Plan.pdf"
  assert_equal "$cleaned_remainder" "Support Plans 2023 Active Plans Support Plan.pdf"
}

@test "extract_name_from_path - Emergency Contacts/2024/Updated Contacts/Jean-Pierre Dubois/Jean-Pierre Dubois Contact Details.pdf" {
  run extract_name_from_path "Emergency Contacts/2024/Updated Contacts/Jean-Pierre Dubois/Jean-Pierre Dubois Contact Details.pdf" "Jean-Pierre Dubois"
  [ "$status" -eq 0 ]
  IFS='|' read -r extracted_name raw_remainder cleaned_remainder matched <<< "$output"
  echo "----- TEST CASE -----" >&2
  echo "Comment: Name with hyphen and French name" >&2
  echo "function: extract_name_from_path" >&2
  echo "full_path: Emergency Contacts/2024/Updated Contacts/Jean-Pierre Dubois/Jean-Pierre Dubois Contact Details.pdf" >&2
  echo "name to match: Jean-Pierre Dubois" >&2
  echo "expected_match: true" >&2
  echo "raw remainder expected: Emergency Contacts/2024/Updated Contacts/ /  Contact Details.pdf" >&2
  echo "raw remainder matched: $raw_remainder" >&2
  echo "cleaned remainder expected: Emergency Contacts 2024 Updated Contacts Contact Details.pdf" >&2
  echo "cleaned remainder matched: $cleaned_remainder" >&2
  echo "extracted_name expected: Jean-Pierre,Jean-Pierre,Dubois,Dubois" >&2
  echo "extracted_name matched: $extracted_name" >&2
  echo "expected match: $matched" >&2
  echo "---------------------" >&2
  assert_equal "$extracted_name" "Jean-Pierre,Jean-Pierre,Dubois,Dubois"
  assert_equal "$raw_remainder" "Emergency Contacts/2024/Updated Contacts/ /  Contact Details.pdf"
  assert_equal "$cleaned_remainder" "Emergency Contacts 2024 Updated Contacts Contact Details.pdf"
}

@test "extract_name_from_path - Receipts/2023/Expense Reports/David O'Reilly/David O'Reilly Expense Report.pdf" {
  run extract_name_from_path "Receipts/2023/Expense Reports/David O'Reilly/David O'Reilly Expense Report.pdf" "David O'Reilly"
  [ "$status" -eq 0 ]
  IFS='|' read -r extracted_name raw_remainder cleaned_remainder matched <<< "$output"
  echo "----- TEST CASE -----" >&2
  echo "Comment: Name with apostrophe" >&2
  echo "function: extract_name_from_path" >&2
  echo "full_path: Receipts/2023/Expense Reports/David O'Reilly/David O'Reilly Expense Report.pdf" >&2
  echo "name to match: David O'Reilly" >&2
  echo "expected_match: true" >&2
  echo "raw remainder expected: Receipts/2023/Expense Reports/ /  Expense Report.pdf" >&2
  echo "raw remainder matched: $raw_remainder" >&2
  echo "cleaned remainder expected: Receipts 2023 Expense Reports Expense Report.pdf" >&2
  echo "cleaned remainder matched: $cleaned_remainder" >&2
  echo "extracted_name expected: David,David,O'Reilly,O'Reilly" >&2
  echo "extracted_name matched: $extracted_name" >&2
  echo "expected match: $matched" >&2
  echo "---------------------" >&2
  assert_equal "$extracted_name" "David,David,O'Reilly,O'Reilly"
  assert_equal "$raw_remainder" "Receipts/2023/Expense Reports/ /  Expense Report.pdf"
  assert_equal "$cleaned_remainder" "Receipts 2023 Expense Reports Expense Report.pdf"
}

@test "extract_name_from_path - Mealtime Management/2024/Diary Records/Patricia Thompson-Smith/Patricia Thompson-Smith Food Diary.pdf" {
  run extract_name_from_path "Mealtime Management/2024/Diary Records/Patricia Thompson-Smith/Patricia Thompson-Smith Food Diary.pdf" "Patricia Thompson-Smith"
  [ "$status" -eq 0 ]
  IFS='|' read -r extracted_name raw_remainder cleaned_remainder matched <<< "$output"
  echo "----- TEST CASE -----" >&2
  echo "Comment: Name with double hyphen " >&2
  echo "function: extract_name_from_path" >&2
  echo "full_path: Mealtime Management/2024/Diary Records/Patricia Thompson-Smith/Patricia Thompson-Smith Food Diary.pdf" >&2
  echo "name to match: Patricia Thompson-Smith" >&2
  echo "expected_match: true" >&2
  echo "raw remainder expected: Mealtime Management/2024/Diary Records/ /  Food Diary.pdf" >&2
  echo "raw remainder matched: $raw_remainder" >&2
  echo "cleaned remainder expected: Mealtime Management 2024 Diary Records Food Diary.pdf" >&2
  echo "cleaned remainder matched: $cleaned_remainder" >&2
  echo "extracted_name expected: Patricia,Patricia,Thompson-Smith,Thompson-Smith" >&2
  echo "extracted_name matched: $extracted_name" >&2
  echo "expected match: $matched" >&2
  echo "---------------------" >&2
  assert_equal "$extracted_name" "Patricia,Patricia,Thompson-Smith,Thompson-Smith"
  assert_equal "$raw_remainder" "Mealtime Management/2024/Diary Records/ /  Food Diary.pdf"
  assert_equal "$cleaned_remainder" "Mealtime Management 2024 Diary Records Food Diary.pdf"
}

@test "extract_name_from_path - WHS/2024/Alex McDoNaLd/05.03.2024 - Alex McDoNaLd.pdf" {
  run extract_name_from_path "WHS/2024/Alex McDoNaLd/05.03.2024 - Alex McDoNaLd.pdf" "Alex McDonald"
  [ "$status" -eq 0 ]
  IFS='|' read -r extracted_name raw_remainder cleaned_remainder matched <<< "$output"
  echo "----- TEST CASE -----" >&2
  echo "Comment: Mixed-case surname in folder and filename (case-insensitive removal)" >&2
  echo "function: extract_name_from_path" >&2
  echo "full_path: WHS/2024/Alex McDoNaLd/05.03.2024 - Alex McDoNaLd.pdf" >&2
  echo "name to match: Alex McDonald" >&2
  echo "expected_match: true" >&2
  echo "raw remainder expected: WHS/2024/ /05.03.2024 -  .pdf" >&2
  echo "raw remainder matched: $raw_remainder" >&2
  echo "cleaned remainder expected: WHS 2024 05 03 2024.pdf" >&2
  echo "cleaned remainder matched: $cleaned_remainder" >&2
  echo "extracted_name expected: Alex,Alex,McDoNaLd,McDoNaLd" >&2
  echo "extracted_name matched: $extracted_name" >&2
  echo "expected match: $matched" >&2
  echo "---------------------" >&2
  assert_equal "$extracted_name" "Alex,Alex,McDoNaLd,McDoNaLd"
  assert_equal "$raw_remainder" "WHS/2024/ /05.03.2024 -  .pdf"
  assert_equal "$cleaned_remainder" "WHS 2024 05 03 2024.pdf"
}
