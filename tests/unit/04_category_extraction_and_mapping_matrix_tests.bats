#!/usr/bin/env bats

load "${BATS_TEST_DIRNAME}/../test-helper/bats-support/load.bash"
load "${BATS_TEST_DIRNAME}/../test-helper/bats-assert/load.bash"
load "${BATS_TEST_DIRNAME}/../test-helper/bats-file/load.bash"

# Auto-generated BATS tests for category extraction and mapping from path
source "${BATS_TEST_DIRNAME}/../utils/category_utils.sh"


@test "extract_category_from_path - John Doe/WHS/file.pdf" {
  run extract_category_from_path "John Doe/WHS/file.pdf"
  [ "$status" -eq 0 ]
  IFS='|' read -r extracted_category raw_category cleaned_category raw_remainder cleaned_remainder error_status <<< "$output"
  cleaned_remainder=$(python3 $BATS_TEST_DIRNAME/../../core/utils/name_matcher.py --clean-filename "$raw_remainder")
  echo "----- TEST CASE -----" >&2
  echo "Comment: Mapped category (WHS)" >&2
  echo "function: extract_category_from_path" >&2
  echo "input_path: John Doe/WHS/file.pdf" >&2
  echo "input_category: WHS" >&2
  echo "expected_match: true" >&2
  echo "expected_category_name: WHS" >&2
  echo "expected_category_id: 1" >&2
  echo "raw_category expected: WHS" >&2
  echo "raw_category matched: $raw_category" >&2
  echo "cleaned_category expected: WHS" >&2
  echo "cleaned_category matched: $cleaned_category" >&2
  echo "raw_remainder expected: file.pdf" >&2
  echo "raw_remainder matched: $raw_remainder" >&2
  echo "cleaned_remainder expected: file.pdf" >&2
  echo "cleaned_remainder matched: $cleaned_remainder" >&2
  echo "error_status expected: " >&2
  echo "error_status matched: $error_status" >&2
  echo "extracted_category expected: WHS" >&2
  echo "extracted_category matched: $extracted_category" >&2
  echo "expected match: true" >&2
  echo "---------------------" >&2
  assert_equal "$extracted_category" "WHS"
  assert_equal "$raw_category" "WHS"
  assert_equal "$cleaned_category" "WHS"
  assert_equal "$raw_remainder" "file.pdf"
  assert_equal "$cleaned_remainder" "file.pdf"
  assert_equal "$error_status" ""
}

@test "extract_category_from_path - John Doe/Medical/2023/file.pdf" {
  run extract_category_from_path "John Doe/Medical/2023/file.pdf"
  [ "$status" -eq 0 ]
  IFS='|' read -r extracted_category raw_category cleaned_category raw_remainder cleaned_remainder error_status <<< "$output"
  cleaned_remainder=$(python3 $BATS_TEST_DIRNAME/../../core/utils/name_matcher.py --clean-filename "$raw_remainder")
  echo "----- TEST CASE -----" >&2
  echo "Comment: Multi-level mapped category" >&2
  echo "function: extract_category_from_path" >&2
  echo "input_path: John Doe/Medical/2023/file.pdf" >&2
  echo "input_category: Medical" >&2
  echo "expected_match: true" >&2
  echo "expected_category_name: Medical" >&2
  echo "expected_category_id: 2" >&2
  echo "raw_category expected: Medical" >&2
  echo "raw_category matched: $raw_category" >&2
  echo "cleaned_category expected: Medical" >&2
  echo "cleaned_category matched: $cleaned_category" >&2
  echo "raw_remainder expected: 2023/file.pdf" >&2
  echo "raw_remainder matched: $raw_remainder" >&2
  echo "cleaned_remainder expected: 2023 file.pdf" >&2
  echo "cleaned_remainder matched: $cleaned_remainder" >&2
  echo "error_status expected: " >&2
  echo "error_status matched: $error_status" >&2
  echo "extracted_category expected: Medical" >&2
  echo "extracted_category matched: $extracted_category" >&2
  echo "expected match: true" >&2
  echo "---------------------" >&2
  assert_equal "$extracted_category" "Medical"
  assert_equal "$raw_category" "Medical"
  assert_equal "$cleaned_category" "Medical"
  assert_equal "$raw_remainder" "2023/file.pdf"
  assert_equal "$cleaned_remainder" "2023 file.pdf"
  assert_equal "$error_status" ""
}

@test "extract_category_from_path - John Doe/UnknownCategory/file.pdf" {
  run extract_category_from_path "John Doe/UnknownCategory/file.pdf"
  [ "$status" -eq 0 ]
  IFS='|' read -r extracted_category raw_category cleaned_category raw_remainder cleaned_remainder error_status <<< "$output"
  echo "----- TEST CASE -----" >&2
  echo "Comment: Unmapped category" >&2
  echo "function: extract_category_from_path" >&2
  echo "input_path: John Doe/UnknownCategory/file.pdf" >&2
  echo "input_category: UnknownCategory" >&2
  echo "expected_match: false" >&2
  echo "raw remainder expected: John Doe/UnknownCategory/file.pdf" >&2
  echo "raw remainder matched: $raw_remainder" >&2
  echo "cleaned remainder expected: John Doe UnknownCategory file.pdf" >&2
  echo "cleaned remainder matched: $cleaned_remainder" >&2
  echo "extracted_category expected: UnknownCategory" >&2
  echo "extracted_category matched: $extracted_category" >&2
  echo "expected match: false" >&2
  echo "---------------------" >&2
  assert_equal "$extracted_category" ""
  assert_equal "$raw_category" "UnknownCategory"
  assert_equal "$cleaned_category" ""
  assert_equal "$raw_remainder" "John Doe/UnknownCategory/file.pdf"
  assert_equal "$cleaned_remainder" "John Doe UnknownCategory file.pdf"
  assert_equal "$error_status" "unmapped"
}

@test "extract_category_from_path - John Doe/file.pdf" {
  run extract_category_from_path "John Doe/file.pdf"
  [ "$status" -eq 0 ]
  IFS='|' read -r extracted_category raw_category cleaned_category raw_remainder cleaned_remainder error_status <<< "$output"
  echo "----- TEST CASE -----" >&2
  echo "Comment: No category" >&2
  echo "function: extract_category_from_path" >&2
  echo "input_path: John Doe/file.pdf" >&2
  echo "input_category: " >&2
  echo "expected_match: false" >&2
  echo "raw remainder expected: John Doe/file.pdf" >&2
  echo "raw remainder matched: $raw_remainder" >&2
  echo "cleaned remainder expected: John Doe/file.pdf" >&2
  echo "cleaned remainder matched: $cleaned_remainder" >&2
  echo "extracted_category expected: " >&2
  echo "extracted_category matched: $extracted_category" >&2
  echo "expected match: false" >&2
  echo "---------------------" >&2
  assert_equal "$extracted_category" ""
  assert_equal "$raw_category" ""
  assert_equal "$cleaned_category" ""
  assert_equal "$raw_remainder" "John Doe/file.pdf"
  assert_equal "$cleaned_remainder" "John Doe/file.pdf"
  assert_equal "$error_status" "no_category"
}

@test "extract_category_from_path - John Doe/Support Plans/2022/plan.pdf" {
  run extract_category_from_path "John Doe/Support Plans/2022/plan.pdf"
  [ "$status" -eq 0 ]
  IFS='|' read -r extracted_category raw_category cleaned_category raw_remainder cleaned_remainder error_status <<< "$output"
  cleaned_remainder=$(python3 $BATS_TEST_DIRNAME/../../core/utils/name_matcher.py --clean-filename "$raw_remainder")
  echo "----- TEST CASE -----" >&2
  echo "Comment: Mapped category with spaces" >&2
  echo "function: extract_category_from_path" >&2
  echo "input_path: John Doe/Support Plans/2022/plan.pdf" >&2
  echo "input_category: Support Plans" >&2
  echo "expected_match: true" >&2
  echo "expected_category_name: Support Plans" >&2
  echo "expected_category_id: 4" >&2
  echo "raw_category expected: Support Plans" >&2
  echo "raw_category matched: $raw_category" >&2
  echo "cleaned_category expected: Support Plans" >&2
  echo "cleaned_category matched: $cleaned_category" >&2
  echo "raw_remainder expected: 2022/plan.pdf" >&2
  echo "raw_remainder matched: $raw_remainder" >&2
  echo "cleaned_remainder expected: 2022 plan.pdf" >&2
  echo "cleaned_remainder matched: $cleaned_remainder" >&2
  echo "error_status expected: " >&2
  echo "error_status matched: $error_status" >&2
  echo "extracted_category expected: Support Plans" >&2
  echo "extracted_category matched: $extracted_category" >&2
  echo "expected match: true" >&2
  echo "---------------------" >&2
  assert_equal "$extracted_category" "Support Plans"
  assert_equal "$raw_category" "Support Plans"
  assert_equal "$cleaned_category" "Support Plans"
  assert_equal "$raw_remainder" "2022/plan.pdf"
  assert_equal "$cleaned_remainder" "2022 plan.pdf"
  assert_equal "$error_status" ""
}

@test "extract_category_from_path - John Doe/whs/file.pdf" {
  run extract_category_from_path "John Doe/whs/file.pdf"
  [ "$status" -eq 0 ]
  IFS='|' read -r extracted_category raw_category cleaned_category raw_remainder cleaned_remainder error_status <<< "$output"
  cleaned_remainder=$(python3 $BATS_TEST_DIRNAME/../../core/utils/name_matcher.py --clean-filename "$raw_remainder")
  echo "----- TEST CASE -----" >&2
  echo "Comment: Case-insensitive mapped category" >&2
  echo "function: extract_category_from_path" >&2
  echo "input_path: John Doe/whs/file.pdf" >&2
  echo "input_category: whs" >&2
  echo "expected_match: true" >&2
  echo "expected_category_name: WHS" >&2
  echo "expected_category_id: 1" >&2
  echo "raw_category expected: whs" >&2
  echo "raw_category matched: $raw_category" >&2
  echo "cleaned_category expected: WHS" >&2
  echo "cleaned_category matched: $cleaned_category" >&2
  echo "raw_remainder expected: file.pdf" >&2
  echo "raw_remainder matched: $raw_remainder" >&2
  echo "cleaned_remainder expected: file.pdf" >&2
  echo "cleaned_remainder matched: $cleaned_remainder" >&2
  echo "error_status expected: " >&2
  echo "error_status matched: $error_status" >&2
  echo "extracted_category expected: WHS" >&2
  echo "extracted_category matched: $extracted_category" >&2
  echo "expected match: true" >&2
  echo "---------------------" >&2
  assert_equal "$extracted_category" "WHS"
  assert_equal "$raw_category" "whs"
  assert_equal "$cleaned_category" "WHS"
  assert_equal "$raw_remainder" "file.pdf"
  assert_equal "$cleaned_remainder" "file.pdf"
  assert_equal "$error_status" ""
}

@test "extract_category_from_path - John Doe/Mealtime-Management/file.pdf" {
  run extract_category_from_path "John Doe/Mealtime-Management/file.pdf"
  [ "$status" -eq 0 ]
  IFS='|' read -r extracted_category raw_category cleaned_category raw_remainder cleaned_remainder error_status <<< "$output"
  cleaned_remainder=$(python3 $BATS_TEST_DIRNAME/../../core/utils/name_matcher.py --clean-filename "$raw_remainder")
  echo "----- TEST CASE -----" >&2
  echo "Comment: Mapped category with hyphen" >&2
  echo "function: extract_category_from_path" >&2
  echo "input_path: John Doe/Mealtime-Management/file.pdf" >&2
  echo "input_category: Mealtime-Management" >&2
  echo "expected_match: true" >&2
  echo "expected_category_name: Mealtime Management" >&2
  echo "expected_category_id: 10" >&2
  echo "raw_category expected: Mealtime-Management" >&2
  echo "raw_category matched: $raw_category" >&2
  echo "cleaned_category expected: Mealtime Management" >&2
  echo "cleaned_category matched: $cleaned_category" >&2
  echo "raw_remainder expected: file.pdf" >&2
  echo "raw_remainder matched: $raw_remainder" >&2
  echo "cleaned_remainder expected: file.pdf" >&2
  echo "cleaned_remainder matched: $cleaned_remainder" >&2
  echo "error_status expected: " >&2
  echo "error_status matched: $error_status" >&2
  echo "extracted_category expected: Mealtime Management" >&2
  echo "extracted_category matched: $extracted_category" >&2
  echo "expected match: true" >&2
  echo "---------------------" >&2
  assert_equal "$extracted_category" "Mealtime Management"
  assert_equal "$raw_category" "Mealtime-Management"
  assert_equal "$cleaned_category" "Mealtime Management"
  assert_equal "$raw_remainder" "file.pdf"
  assert_equal "$cleaned_remainder" "file.pdf"
  assert_equal "$error_status" ""
}

@test "extract_category_from_path - John Doe/Photos & Videos/file.jpg" {
  run extract_category_from_path "John Doe/Photos & Videos/file.jpg"
  [ "$status" -eq 0 ]
  IFS='|' read -r extracted_category raw_category cleaned_category raw_remainder cleaned_remainder error_status <<< "$output"
  echo "----- TEST CASE -----" >&2
  echo "Comment: Unmapped category with special character" >&2
  echo "function: extract_category_from_path" >&2
  echo "input_path: John Doe/Photos & Videos/file.jpg" >&2
  echo "input_category: Photos & Videos" >&2
  echo "expected_match: false" >&2
  echo "raw remainder expected: John Doe/Photos & Videos/file.jpg" >&2
  echo "raw remainder matched: $raw_remainder" >&2
  echo "cleaned remainder expected: John Doe Photos Videos file.jpg" >&2
  echo "cleaned remainder matched: $cleaned_remainder" >&2
  echo "extracted_category expected: Photos & Videos" >&2
  echo "extracted_category matched: $extracted_category" >&2
  echo "expected match: false" >&2
  echo "---------------------" >&2
  assert_equal "$extracted_category" ""
  assert_equal "$raw_category" "Photos & Videos"
  assert_equal "$cleaned_category" ""
  assert_equal "$raw_remainder" "John Doe/Photos & Videos/file.jpg"
  assert_equal "$cleaned_remainder" "John Doe Photos Videos file.jpg"
  assert_equal "$error_status" "unmapped"
}

@test "extract_category_from_path - John Doe/Receipts_2023/file.pdf" {
  run extract_category_from_path "John Doe/Receipts_2023/file.pdf"
  [ "$status" -eq 0 ]
  IFS='|' read -r extracted_category raw_category cleaned_category raw_remainder cleaned_remainder error_status <<< "$output"
  echo "----- TEST CASE -----" >&2
  echo "Comment: Unmapped category with underscore and year" >&2
  echo "function: extract_category_from_path" >&2
  echo "input_path: John Doe/Receipts_2023/file.pdf" >&2
  echo "input_category: Receipts_2023" >&2
  echo "expected_match: false" >&2
  echo "raw remainder expected: John Doe/Receipts_2023/file.pdf" >&2
  echo "raw remainder matched: $raw_remainder" >&2
  echo "cleaned remainder expected: John Doe Receipts 2023 file.pdf" >&2
  echo "cleaned remainder matched: $cleaned_remainder" >&2
  echo "extracted_category expected: Receipts_2023" >&2
  echo "extracted_category matched: $extracted_category" >&2
  echo "expected match: false" >&2
  echo "---------------------" >&2
  assert_equal "$extracted_category" ""
  assert_equal "$raw_category" "Receipts_2023"
  assert_equal "$cleaned_category" ""
  assert_equal "$raw_remainder" "John Doe/Receipts_2023/file.pdf"
  assert_equal "$cleaned_remainder" "John Doe Receipts 2023 file.pdf"
  assert_equal "$error_status" "unmapped"
}

@test "extract_category_from_path - John Doe/!@#$/file.pdf" {
  run extract_category_from_path "John Doe/!@#$/file.pdf"
  [ "$status" -eq 0 ]
  IFS='|' read -r extracted_category raw_category cleaned_category raw_remainder cleaned_remainder error_status <<< "$output"
  echo "----- TEST CASE -----" >&2
  echo "Comment: Edge case: only special characters" >&2
  echo "function: extract_category_from_path" >&2
  echo "input_path: John Doe/!@#$/file.pdf" >&2
  echo "input_category: !@#$" >&2
  echo "expected_match: false" >&2
  echo "raw remainder expected: John Doe/!@#$/file.pdf" >&2
  echo "raw remainder matched: $raw_remainder" >&2
  echo "cleaned remainder expected: John Doe ! file.pdf" >&2
  echo "cleaned remainder matched: $cleaned_remainder" >&2
  echo "extracted_category expected: !@#$" >&2
  echo "extracted_category matched: $extracted_category" >&2
  echo "expected match: false" >&2
  echo "---------------------" >&2
  assert_equal "$extracted_category" ""
  assert_equal "$raw_category" "!@#$"
  assert_equal "$cleaned_category" ""
  assert_equal "$raw_remainder" "John Doe/!@#$/file.pdf"
  assert_equal "$cleaned_remainder" "John Doe ! file.pdf"
  assert_equal "$error_status" "unmapped"
}

@test "extract_category_from_path - John Doe/Personal Care/2024/Assessments/assessment.pdf" {
  run extract_category_from_path "John Doe/Personal Care/2024/Assessments/assessment.pdf"
  [ "$status" -eq 0 ]
  IFS='|' read -r extracted_category raw_category cleaned_category raw_remainder cleaned_remainder error_status <<< "$output"
  cleaned_remainder=$(python3 $BATS_TEST_DIRNAME/../../core/utils/name_matcher.py --clean-filename "$raw_remainder")
  echo "----- TEST CASE -----" >&2
  echo "Comment: Deep nesting with category" >&2
  echo "function: extract_category_from_path" >&2
  echo "input_path: John Doe/Personal Care/2024/Assessments/assessment.pdf" >&2
  echo "input_category: Personal Care" >&2
  echo "expected_match: true" >&2
  echo "expected_category_name: Personal Care" >&2
  echo "expected_category_id: 3" >&2
  echo "raw_category expected: Personal Care" >&2
  echo "raw_category matched: $raw_category" >&2
  echo "cleaned_category expected: Personal Care" >&2
  echo "cleaned_category matched: $cleaned_category" >&2
  echo "raw_remainder expected: 2024/Assessments/assessment.pdf" >&2
  echo "raw_remainder matched: $raw_remainder" >&2
  echo "cleaned_remainder expected: 2024 Assessments assessment.pdf" >&2
  echo "cleaned_remainder matched: $cleaned_remainder" >&2
  echo "error_status expected: " >&2
  echo "error_status matched: $error_status" >&2
  echo "extracted_category expected: Personal Care" >&2
  echo "extracted_category matched: $extracted_category" >&2
  echo "expected match: true" >&2
  echo "---------------------" >&2
  assert_equal "$extracted_category" "Personal Care"
  assert_equal "$raw_category" "Personal Care"
  assert_equal "$cleaned_category" "Personal Care"
  assert_equal "$raw_remainder" "2024/Assessments/assessment.pdf"
  assert_equal "$cleaned_remainder" "2024 Assessments assessment.pdf"
  assert_equal "$error_status" ""
}

@test "extract_category_from_path - John Doe/Behavioral Support/2023/Reports/behavioral_analysis.pdf" {
  run extract_category_from_path "John Doe/Behavioral Support/2023/Reports/behavioral_analysis.pdf"
  [ "$status" -eq 0 ]
  IFS='|' read -r extracted_category raw_category cleaned_category raw_remainder cleaned_remainder error_status <<< "$output"
  cleaned_remainder=$(python3 $BATS_TEST_DIRNAME/../../core/utils/name_matcher.py --clean-filename "$raw_remainder")
  echo "----- TEST CASE -----" >&2
  echo "Comment: Multi-word category in deep path" >&2
  echo "function: extract_category_from_path" >&2
  echo "input_path: John Doe/Behavioral Support/2023/Reports/behavioral_analysis.pdf" >&2
  echo "input_category: Behavioral Support" >&2
  echo "expected_match: true" >&2
  echo "expected_category_name: Behavioral Support" >&2
  echo "expected_category_id: 5" >&2
  echo "raw_category expected: Behavioral Support" >&2
  echo "raw_category matched: $raw_category" >&2
  echo "cleaned_category expected: Behavioral Support" >&2
  echo "cleaned_category matched: $cleaned_category" >&2
  echo "raw_remainder expected: 2023/Reports/behavioral_analysis.pdf" >&2
  echo "raw_remainder matched: $raw_remainder" >&2
  echo "cleaned_remainder expected: 2023 Reports behavioral analysis.pdf" >&2
  echo "cleaned_remainder matched: $cleaned_remainder" >&2
  echo "error_status expected: " >&2
  echo "error_status matched: $error_status" >&2
  echo "extracted_category expected: Behavioral Support" >&2
  echo "extracted_category matched: $extracted_category" >&2
  echo "expected match: true" >&2
  echo "---------------------" >&2
  assert_equal "$extracted_category" "Behavioral Support"
  assert_equal "$raw_category" "Behavioral Support"
  assert_equal "$cleaned_category" "Behavioral Support"
  assert_equal "$raw_remainder" "2023/Reports/behavioral_analysis.pdf"
  assert_equal "$cleaned_remainder" "2023 Reports behavioral analysis.pdf"
  assert_equal "$error_status" ""
}

@test "extract_category_from_path - John Doe/Incident Reports/2024/Emergency/incident_report.pdf" {
  run extract_category_from_path "John Doe/Incident Reports/2024/Emergency/incident_report.pdf"
  [ "$status" -eq 0 ]
  IFS='|' read -r extracted_category raw_category cleaned_category raw_remainder cleaned_remainder error_status <<< "$output"
  cleaned_remainder=$(python3 $BATS_TEST_DIRNAME/../../core/utils/name_matcher.py --clean-filename "$raw_remainder")
  echo "----- TEST CASE -----" >&2
  echo "Comment: Category with spaces in complex path" >&2
  echo "function: extract_category_from_path" >&2
  echo "input_path: John Doe/Incident Reports/2024/Emergency/incident_report.pdf" >&2
  echo "input_category: Incident Reports" >&2
  echo "expected_match: true" >&2
  echo "expected_category_name: Incident Reports" >&2
  echo "expected_category_id: 6" >&2
  echo "raw_category expected: Incident Reports" >&2
  echo "raw_category matched: $raw_category" >&2
  echo "cleaned_category expected: Incident Reports" >&2
  echo "cleaned_category matched: $cleaned_category" >&2
  echo "raw_remainder expected: 2024/Emergency/incident_report.pdf" >&2
  echo "raw_remainder matched: $raw_remainder" >&2
  echo "cleaned_remainder expected: 2024 Emergency incident report.pdf" >&2
  echo "cleaned_remainder matched: $cleaned_remainder" >&2
  echo "error_status expected: " >&2
  echo "error_status matched: $error_status" >&2
  echo "extracted_category expected: Incident Reports" >&2
  echo "extracted_category matched: $extracted_category" >&2
  echo "expected match: true" >&2
  echo "---------------------" >&2
  assert_equal "$extracted_category" "Incident Reports"
  assert_equal "$raw_category" "Incident Reports"
  assert_equal "$cleaned_category" "Incident Reports"
  assert_equal "$raw_remainder" "2024/Emergency/incident_report.pdf"
  assert_equal "$cleaned_remainder" "2024 Emergency incident report.pdf"
  assert_equal "$error_status" ""
}

@test "extract_category_from_path - John Doe/Medical Records/2023/Assessments/Patient Data/medical_assessment.pdf" {
  run extract_category_from_path "John Doe/Medical Records/2023/Assessments/Patient Data/medical_assessment.pdf"
  [ "$status" -eq 0 ]
  IFS='|' read -r extracted_category raw_category cleaned_category raw_remainder cleaned_remainder error_status <<< "$output"
  cleaned_remainder=$(python3 $BATS_TEST_DIRNAME/../../core/utils/name_matcher.py --clean-filename "$raw_remainder")
  echo "----- TEST CASE -----" >&2
  echo "Comment: Deep nesting with multi-word category" >&2
  echo "function: extract_category_from_path" >&2
  echo "input_path: John Doe/Medical Records/2023/Assessments/Patient Data/medical_assessment.pdf" >&2
  echo "input_category: Medical Records" >&2
  echo "expected_match: true" >&2
  echo "expected_category_name: Medical Records" >&2
  echo "expected_category_id: 7" >&2
  echo "raw_category expected: Medical Records" >&2
  echo "raw_category matched: $raw_category" >&2
  echo "cleaned_category expected: Medical Records" >&2
  echo "cleaned_category matched: $cleaned_category" >&2
  echo "raw_remainder expected: 2023/Assessments/Patient Data/medical_assessment.pdf" >&2
  echo "raw_remainder matched: $raw_remainder" >&2
  echo "cleaned_remainder expected: 2023 Assessments Patient Data medical assessment.pdf" >&2
  echo "cleaned_remainder matched: $cleaned_remainder" >&2
  echo "error_status expected: " >&2
  echo "error_status matched: $error_status" >&2
  echo "extracted_category expected: Medical Records" >&2
  echo "extracted_category matched: $extracted_category" >&2
  echo "expected match: true" >&2
  echo "---------------------" >&2
  assert_equal "$extracted_category" "Medical Records"
  assert_equal "$raw_category" "Medical Records"
  assert_equal "$cleaned_category" "Medical Records"
  assert_equal "$raw_remainder" "2023/Assessments/Patient Data/medical_assessment.pdf"
  assert_equal "$cleaned_remainder" "2023 Assessments Patient Data medical assessment.pdf"
  assert_equal "$error_status" ""
}

@test "extract_category_from_path - John Doe/Support Plans/2024/Active Plans/Current/plan.pdf" {
  run extract_category_from_path "John Doe/Support Plans/2024/Active Plans/Current/plan.pdf"
  [ "$status" -eq 0 ]
  IFS='|' read -r extracted_category raw_category cleaned_category raw_remainder cleaned_remainder error_status <<< "$output"
  cleaned_remainder=$(python3 $BATS_TEST_DIRNAME/../../core/utils/name_matcher.py --clean-filename "$raw_remainder")
  echo "----- TEST CASE -----" >&2
  echo "Comment: Category with multiple subdirectories" >&2
  echo "function: extract_category_from_path" >&2
  echo "input_path: John Doe/Support Plans/2024/Active Plans/Current/plan.pdf" >&2
  echo "input_category: Support Plans" >&2
  echo "expected_match: true" >&2
  echo "expected_category_name: Support Plans" >&2
  echo "expected_category_id: 4" >&2
  echo "raw_category expected: Support Plans" >&2
  echo "raw_category matched: $raw_category" >&2
  echo "cleaned_category expected: Support Plans" >&2
  echo "cleaned_category matched: $cleaned_category" >&2
  echo "raw_remainder expected: 2024/Active Plans/Current/plan.pdf" >&2
  echo "raw_remainder matched: $raw_remainder" >&2
  echo "cleaned_remainder expected: 2024 Active Plans Current plan.pdf" >&2
  echo "cleaned_remainder matched: $cleaned_remainder" >&2
  echo "error_status expected: " >&2
  echo "error_status matched: $error_status" >&2
  echo "extracted_category expected: Support Plans" >&2
  echo "extracted_category matched: $extracted_category" >&2
  echo "expected match: true" >&2
  echo "---------------------" >&2
  assert_equal "$extracted_category" "Support Plans"
  assert_equal "$raw_category" "Support Plans"
  assert_equal "$cleaned_category" "Support Plans"
  assert_equal "$raw_remainder" "2024/Active Plans/Current/plan.pdf"
  assert_equal "$cleaned_remainder" "2024 Active Plans Current plan.pdf"
  assert_equal "$error_status" ""
}

@test "extract_category_from_path - John Doe/Photos & Videos/2023/Client Photos/Photo Album/album.zip" {
  run extract_category_from_path "John Doe/Photos & Videos/2023/Client Photos/Photo Album/album.zip"
  [ "$status" -eq 0 ]
  IFS='|' read -r extracted_category raw_category cleaned_category raw_remainder cleaned_remainder error_status <<< "$output"
  echo "----- TEST CASE -----" >&2
  echo "Comment: Unmapped category with ampersand in deep path" >&2
  echo "function: extract_category_from_path" >&2
  echo "input_path: John Doe/Photos & Videos/2023/Client Photos/Photo Album/album.zip" >&2
  echo "input_category: Photos & Videos" >&2
  echo "expected_match: false" >&2
  echo "raw remainder expected: John Doe/Photos & Videos/2023/Client Photos/Photo Album/album.zip" >&2
  echo "raw remainder matched: $raw_remainder" >&2
  echo "cleaned remainder expected: John Doe Photos Videos 2023 Client Photos Photo Album album.zip" >&2
  echo "cleaned remainder matched: $cleaned_remainder" >&2
  echo "extracted_category expected: Photos & Videos" >&2
  echo "extracted_category matched: $extracted_category" >&2
  echo "expected match: false" >&2
  echo "---------------------" >&2
  assert_equal "$extracted_category" ""
  assert_equal "$raw_category" "Photos & Videos"
  assert_equal "$cleaned_category" ""
  assert_equal "$raw_remainder" "John Doe/Photos & Videos/2023/Client Photos/Photo Album/album.zip"
  assert_equal "$cleaned_remainder" "John Doe Photos Videos 2023 Client Photos Photo Album album.zip"
  assert_equal "$error_status" "unmapped"
}

@test "extract_category_from_path - John Doe/Emergency Contacts/2024/Updated Contacts/contact_list.pdf" {
  run extract_category_from_path "John Doe/Emergency Contacts/2024/Updated Contacts/contact_list.pdf"
  [ "$status" -eq 0 ]
  IFS='|' read -r extracted_category raw_category cleaned_category raw_remainder cleaned_remainder error_status <<< "$output"
  cleaned_remainder=$(python3 $BATS_TEST_DIRNAME/../../core/utils/name_matcher.py --clean-filename "$raw_remainder")
  echo "----- TEST CASE -----" >&2
  echo "Comment: Multi-word category with subdirectories" >&2
  echo "function: extract_category_from_path" >&2
  echo "input_path: John Doe/Emergency Contacts/2024/Updated Contacts/contact_list.pdf" >&2
  echo "input_category: Emergency Contacts" >&2
  echo "expected_match: true" >&2
  echo "expected_category_name: Emergency Contacts" >&2
  echo "expected_category_id: 8" >&2
  echo "raw_category expected: Emergency Contacts" >&2
  echo "raw_category matched: $raw_category" >&2
  echo "cleaned_category expected: Emergency Contacts" >&2
  echo "cleaned_category matched: $cleaned_category" >&2
  echo "raw_remainder expected: 2024/Updated Contacts/contact_list.pdf" >&2
  echo "raw_remainder matched: $raw_remainder" >&2
  echo "cleaned_remainder expected: 2024 Updated Contacts contact list.pdf" >&2
  echo "cleaned_remainder matched: $cleaned_remainder" >&2
  echo "error_status expected: " >&2
  echo "error_status matched: $error_status" >&2
  echo "extracted_category expected: Emergency Contacts" >&2
  echo "extracted_category matched: $extracted_category" >&2
  echo "expected match: true" >&2
  echo "---------------------" >&2
  assert_equal "$extracted_category" "Emergency Contacts"
  assert_equal "$raw_category" "Emergency Contacts"
  assert_equal "$cleaned_category" "Emergency Contacts"
  assert_equal "$raw_remainder" "2024/Updated Contacts/contact_list.pdf"
  assert_equal "$cleaned_remainder" "2024 Updated Contacts contact list.pdf"
  assert_equal "$error_status" ""
}

@test "extract_category_from_path - John Doe/Receipts/2023/Expense Reports/Detailed/expense_report.pdf" {
  run extract_category_from_path "John Doe/Receipts/2023/Expense Reports/Detailed/expense_report.pdf"
  [ "$status" -eq 0 ]
  IFS='|' read -r extracted_category raw_category cleaned_category raw_remainder cleaned_remainder error_status <<< "$output"
  cleaned_remainder=$(python3 $BATS_TEST_DIRNAME/../../core/utils/name_matcher.py --clean-filename "$raw_remainder")
  echo "----- TEST CASE -----" >&2
  echo "Comment: Simple category in very deep path" >&2
  echo "function: extract_category_from_path" >&2
  echo "input_path: John Doe/Receipts/2023/Expense Reports/Detailed/expense_report.pdf" >&2
  echo "input_category: Receipts" >&2
  echo "expected_match: true" >&2
  echo "expected_category_name: Receipts" >&2
  echo "expected_category_id: 16" >&2
  echo "raw_category expected: Receipts" >&2
  echo "raw_category matched: $raw_category" >&2
  echo "cleaned_category expected: Receipts" >&2
  echo "cleaned_category matched: $cleaned_category" >&2
  echo "raw_remainder expected: 2023/Expense Reports/Detailed/expense_report.pdf" >&2
  echo "raw_remainder matched: $raw_remainder" >&2
  echo "cleaned_remainder expected: 2023 Expense Reports Detailed expense report.pdf" >&2
  echo "cleaned_remainder matched: $cleaned_remainder" >&2
  echo "error_status expected: " >&2
  echo "error_status matched: $error_status" >&2
  echo "extracted_category expected: Receipts" >&2
  echo "extracted_category matched: $extracted_category" >&2
  echo "expected match: true" >&2
  echo "---------------------" >&2
  assert_equal "$extracted_category" "Receipts"
  assert_equal "$raw_category" "Receipts"
  assert_equal "$cleaned_category" "Receipts"
  assert_equal "$raw_remainder" "2023/Expense Reports/Detailed/expense_report.pdf"
  assert_equal "$cleaned_remainder" "2023 Expense Reports Detailed expense report.pdf"
  assert_equal "$error_status" ""
}

@test "extract_category_from_path - John Doe/Mealtime Management/2024/Diary Records/Food Preferences/food_diary.pdf" {
  run extract_category_from_path "John Doe/Mealtime Management/2024/Diary Records/Food Preferences/food_diary.pdf"
  [ "$status" -eq 0 ]
  IFS='|' read -r extracted_category raw_category cleaned_category raw_remainder cleaned_remainder error_status <<< "$output"
  cleaned_remainder=$(python3 $BATS_TEST_DIRNAME/../../core/utils/name_matcher.py --clean-filename "$raw_remainder")
  echo "----- TEST CASE -----" >&2
  echo "Comment: Category with space in complex nested structure" >&2
  echo "function: extract_category_from_path" >&2
  echo "input_path: John Doe/Mealtime Management/2024/Diary Records/Food Preferences/food_diary.pdf" >&2
  echo "input_category: Mealtime Management" >&2
  echo "expected_match: true" >&2
  echo "expected_category_name: Mealtime Management" >&2
  echo "expected_category_id: 10" >&2
  echo "raw_category expected: Mealtime Management" >&2
  echo "raw_category matched: $raw_category" >&2
  echo "cleaned_category expected: Mealtime Management" >&2
  echo "cleaned_category matched: $cleaned_category" >&2
  echo "raw_remainder expected: 2024/Diary Records/Food Preferences/food_diary.pdf" >&2
  echo "raw_remainder matched: $raw_remainder" >&2
  echo "cleaned_remainder expected: 2024 Diary Records Food Preferences food diary.pdf" >&2
  echo "cleaned_remainder matched: $cleaned_remainder" >&2
  echo "error_status expected: " >&2
  echo "error_status matched: $error_status" >&2
  echo "extracted_category expected: Mealtime Management" >&2
  echo "extracted_category matched: $extracted_category" >&2
  echo "expected match: true" >&2
  echo "---------------------" >&2
  assert_equal "$extracted_category" "Mealtime Management"
  assert_equal "$raw_category" "Mealtime Management"
  assert_equal "$cleaned_category" "Mealtime Management"
  assert_equal "$raw_remainder" "2024/Diary Records/Food Preferences/food_diary.pdf"
  assert_equal "$cleaned_remainder" "2024 Diary Records Food Preferences food diary.pdf"
  assert_equal "$error_status" ""
}

@test "extract_category_from_path - John Doe/Personal Care/2023/Assessments/2023.05.15_Assessment/assessment.pdf" {
  run extract_category_from_path "John Doe/Personal Care/2023/Assessments/2023.05.15_Assessment/assessment.pdf"
  [ "$status" -eq 0 ]
  IFS='|' read -r extracted_category raw_category cleaned_category raw_remainder cleaned_remainder error_status <<< "$output"
  cleaned_remainder=$(python3 $BATS_TEST_DIRNAME/../../core/utils/name_matcher.py --clean-filename "$raw_remainder")
  echo "----- TEST CASE -----" >&2
  echo "Comment: Category with date in subdirectory" >&2
  echo "function: extract_category_from_path" >&2
  echo "input_path: John Doe/Personal Care/2023/Assessments/2023.05.15_Assessment/assessment.pdf" >&2
  echo "input_category: Personal Care" >&2
  echo "expected_match: true" >&2
  echo "expected_category_name: Personal Care" >&2
  echo "expected_category_id: 3" >&2
  echo "raw_category expected: Personal Care" >&2
  echo "raw_category matched: $raw_category" >&2
  echo "cleaned_category expected: Personal Care" >&2
  echo "cleaned_category matched: $cleaned_category" >&2
  echo "raw_remainder expected: 2023/Assessments/2023.05.15_Assessment/assessment.pdf" >&2
  echo "raw_remainder matched: $raw_remainder" >&2
  echo "cleaned_remainder expected: 2023 Assessments 2023 05 15 Assessment assessment.pdf" >&2
  echo "cleaned_remainder matched: $cleaned_remainder" >&2
  echo "error_status expected: " >&2
  echo "error_status matched: $error_status" >&2
  echo "extracted_category expected: Personal Care" >&2
  echo "extracted_category matched: $extracted_category" >&2
  echo "expected match: true" >&2
  echo "---------------------" >&2
  assert_equal "$extracted_category" "Personal Care"
  assert_equal "$raw_category" "Personal Care"
  assert_equal "$cleaned_category" "Personal Care"
  assert_equal "$raw_remainder" "2023/Assessments/2023.05.15_Assessment/assessment.pdf"
  assert_equal "$cleaned_remainder" "2023 Assessments 2023 05 15 Assessment assessment.pdf"
  assert_equal "$error_status" ""
}

@test "extract_category_from_path - John Doe/Unknown_Category_With_Underscores/file.pdf" {
  run extract_category_from_path "John Doe/Unknown_Category_With_Underscores/file.pdf"
  [ "$status" -eq 0 ]
  IFS='|' read -r extracted_category raw_category cleaned_category raw_remainder cleaned_remainder error_status <<< "$output"
  echo "----- TEST CASE -----" >&2
  echo "Comment: Unmapped category with underscores" >&2
  echo "function: extract_category_from_path" >&2
  echo "input_path: John Doe/Unknown_Category_With_Underscores/file.pdf" >&2
  echo "input_category: Unknown_Category_With_Underscores" >&2
  echo "expected_match: false" >&2
  echo "raw remainder expected: John Doe/Unknown_Category_With_Underscores/file.pdf" >&2
  echo "raw remainder matched: $raw_remainder" >&2
  echo "cleaned remainder expected: John Doe Unknown Category With Underscores file.pdf" >&2
  echo "cleaned remainder matched: $cleaned_remainder" >&2
  echo "extracted_category expected: Unknown_Category_With_Underscores" >&2
  echo "extracted_category matched: $extracted_category" >&2
  echo "expected match: false" >&2
  echo "---------------------" >&2
  assert_equal "$extracted_category" ""
  assert_equal "$raw_category" "Unknown_Category_With_Underscores"
  assert_equal "$cleaned_category" ""
  assert_equal "$raw_remainder" "John Doe/Unknown_Category_With_Underscores/file.pdf"
  assert_equal "$cleaned_remainder" "John Doe Unknown Category With Underscores file.pdf"
  assert_equal "$error_status" "unmapped"
}

@test "extract_category_from_path - John Doe/Category-With-Multiple-Hyphens/file.pdf" {
  run extract_category_from_path "John Doe/Category-With-Multiple-Hyphens/file.pdf"
  [ "$status" -eq 0 ]
  IFS='|' read -r extracted_category raw_category cleaned_category raw_remainder cleaned_remainder error_status <<< "$output"
  echo "----- TEST CASE -----" >&2
  echo "Comment: Unmapped category with multiple hyphens " >&2
  echo "function: extract_category_from_path" >&2
  echo "input_path: John Doe/Category-With-Multiple-Hyphens/file.pdf" >&2
  echo "input_category: Category-With-Multiple-Hyphens" >&2
  echo "expected_match: false" >&2
  echo "raw remainder expected: John Doe/Category-With-Multiple-Hyphens/file.pdf" >&2
  echo "raw remainder matched: $raw_remainder" >&2
  echo "cleaned remainder expected: John Doe Category With Multiple Hyphens file.pdf" >&2
  echo "cleaned remainder matched: $cleaned_remainder" >&2
  echo "extracted_category expected: Category-With-Multiple-Hyphens" >&2
  echo "extracted_category matched: $extracted_category" >&2
  echo "expected match: false" >&2
  echo "---------------------" >&2
  assert_equal "$extracted_category" ""
  assert_equal "$raw_category" "Category-With-Multiple-Hyphens"
  assert_equal "$cleaned_category" ""
  assert_equal "$raw_remainder" "John Doe/Category-With-Multiple-Hyphens/file.pdf"
  assert_equal "$cleaned_remainder" "John Doe Category With Multiple Hyphens file.pdf"
  assert_equal "$error_status" "unmapped"
}
