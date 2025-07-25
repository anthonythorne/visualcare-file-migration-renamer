#!/usr/bin/env bats

load "${BATS_TEST_DIRNAME}/../test-helper/bats-support/load.bash"
load "${BATS_TEST_DIRNAME}/../test-helper/bats-assert/load.bash"
load "${BATS_TEST_DIRNAME}/../test-helper/bats-file/load.bash"

# Auto-generated BATS tests for category extraction from path
source "${BATS_TEST_DIRNAME}/../../core/utils/category_utils.sh"


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
  echo "raw_remainder expected: John Doe/file.pdf" >&2
  echo "raw_remainder matched: $raw_remainder" >&2
  echo "cleaned_remainder expected: John Doe file.pdf" >&2
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
  assert_equal "$raw_remainder" "John Doe/file.pdf"
  assert_equal "$cleaned_remainder" "John Doe file.pdf"
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
  echo "raw_remainder expected: John Doe/2023/file.pdf" >&2
  echo "raw_remainder matched: $raw_remainder" >&2
  echo "cleaned_remainder expected: John Doe 2023 file.pdf" >&2
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
  assert_equal "$raw_remainder" "John Doe/2023/file.pdf"
  assert_equal "$cleaned_remainder" "John Doe 2023 file.pdf"
  assert_equal "$error_status" ""
}

@test "extract_category_from_path - John Doe/UnknownCategory/file.pdf" {
  cleaned_remainder=$(python3 $BATS_TEST_DIRNAME/../../core/utils/name_matcher.py --clean-filename "John Doe/UnknownCategory/file.pdf")
  echo "----- TEST CASE -----" >&2
  echo "Comment: Unmapped category" >&2
  echo "function: extract_category_from_path" >&2
  echo "input_path: John Doe/UnknownCategory/file.pdf" >&2
  echo "input_category: UnknownCategory" >&2
  echo "expected_match: false" >&2
  echo "raw remainder expected: John Doe/UnknownCategory/file.pdf" >&2
  echo "raw remainder matched: John Doe/UnknownCategory/file.pdf" >&2
  echo "cleaned remainder expected: John Doe UnknownCategory file.pdf" >&2
  echo "cleaned remainder matched: $cleaned_remainder" >&2
  echo "extracted_category expected: UnknownCategory" >&2
  echo "extracted_category matched: " >&2
  echo "expected match: false" >&2
  echo "---------------------" >&2
  assert_equal "$cleaned_remainder" "John Doe UnknownCategory file.pdf"
}

@test "extract_category_from_path - John Doe/file.pdf" {
  cleaned_remainder=$(python3 $BATS_TEST_DIRNAME/../../core/utils/name_matcher.py --clean-filename "John Doe/file.pdf")
  echo "----- TEST CASE -----" >&2
  echo "Comment: No category" >&2
  echo "function: extract_category_from_path" >&2
  echo "input_path: John Doe/file.pdf" >&2
  echo "input_category: " >&2
  echo "expected_match: false" >&2
  echo "raw remainder expected: John Doe/file.pdf" >&2
  echo "raw remainder matched: John Doe/file.pdf" >&2
  echo "cleaned remainder expected: John Doe file.pdf" >&2
  echo "cleaned remainder matched: $cleaned_remainder" >&2
  echo "extracted_category expected: " >&2
  echo "extracted_category matched: " >&2
  echo "expected match: false" >&2
  echo "---------------------" >&2
  assert_equal "$cleaned_remainder" "John Doe file.pdf"
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
  echo "raw_remainder expected: John Doe/2022/plan.pdf" >&2
  echo "raw_remainder matched: $raw_remainder" >&2
  echo "cleaned_remainder expected: John Doe 2022 plan.pdf" >&2
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
  assert_equal "$raw_remainder" "John Doe/2022/plan.pdf"
  assert_equal "$cleaned_remainder" "John Doe 2022 plan.pdf"
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
  echo "raw_remainder expected: John Doe/file.pdf" >&2
  echo "raw_remainder matched: $raw_remainder" >&2
  echo "cleaned_remainder expected: John Doe file.pdf" >&2
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
  assert_equal "$raw_remainder" "John Doe/file.pdf"
  assert_equal "$cleaned_remainder" "John Doe file.pdf"
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
  echo "raw_remainder expected: John Doe/file.pdf" >&2
  echo "raw_remainder matched: $raw_remainder" >&2
  echo "cleaned_remainder expected: John Doe file.pdf" >&2
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
  assert_equal "$raw_remainder" "John Doe/file.pdf"
  assert_equal "$cleaned_remainder" "John Doe file.pdf"
  assert_equal "$error_status" ""
}

@test "extract_category_from_path - John Doe/Photos & Videos/file.jpg" {
  run extract_category_from_path "John Doe/Photos & Videos/file.jpg"
  [ "$status" -eq 0 ]
  IFS='|' read -r extracted_category raw_category cleaned_category raw_remainder cleaned_remainder error_status <<< "$output"
  cleaned_remainder=$(python3 $BATS_TEST_DIRNAME/../../core/utils/name_matcher.py --clean-filename "$raw_remainder")
  echo "----- TEST CASE -----" >&2
  echo "Comment: Mapped category with special character (should map to Photos)" >&2
  echo "function: extract_category_from_path" >&2
  echo "input_path: John Doe/Photos & Videos/file.jpg" >&2
  echo "input_category: Photos & Videos" >&2
  echo "expected_match: true" >&2
  echo "expected_category_name: Photos" >&2
  echo "expected_category_id: 14" >&2
  echo "raw_category expected: Photos & Videos" >&2
  echo "raw_category matched: $raw_category" >&2
  echo "cleaned_category expected: Photos" >&2
  echo "cleaned_category matched: $cleaned_category" >&2
  echo "raw_remainder expected: John Doe/file.jpg" >&2
  echo "raw_remainder matched: $raw_remainder" >&2
  echo "cleaned_remainder expected: John Doe file.jpg" >&2
  echo "cleaned_remainder matched: $cleaned_remainder" >&2
  echo "error_status expected: " >&2
  echo "error_status matched: $error_status" >&2
  echo "extracted_category expected: Photos" >&2
  echo "extracted_category matched: $extracted_category" >&2
  echo "expected match: true" >&2
  echo "---------------------" >&2
  assert_equal "$extracted_category" "Photos"
  assert_equal "$raw_category" "Photos & Videos"
  assert_equal "$cleaned_category" "Photos"
  assert_equal "$raw_remainder" "John Doe/file.jpg"
  assert_equal "$cleaned_remainder" "John Doe file.jpg"
  assert_equal "$error_status" ""
}

@test "extract_category_from_path - John Doe/Receipts_2023/file.pdf" {
  run extract_category_from_path "John Doe/Receipts_2023/file.pdf"
  [ "$status" -eq 0 ]
  IFS='|' read -r extracted_category raw_category cleaned_category raw_remainder cleaned_remainder error_status <<< "$output"
  cleaned_remainder=$(python3 $BATS_TEST_DIRNAME/../../core/utils/name_matcher.py --clean-filename "$raw_remainder")
  echo "----- TEST CASE -----" >&2
  echo "Comment: Mapped category with underscore and year" >&2
  echo "function: extract_category_from_path" >&2
  echo "input_path: John Doe/Receipts_2023/file.pdf" >&2
  echo "input_category: Receipts_2023" >&2
  echo "expected_match: true" >&2
  echo "expected_category_name: Receipts" >&2
  echo "expected_category_id: 16" >&2
  echo "raw_category expected: Receipts_2023" >&2
  echo "raw_category matched: $raw_category" >&2
  echo "cleaned_category expected: Receipts" >&2
  echo "cleaned_category matched: $cleaned_category" >&2
  echo "raw_remainder expected: John Doe/file.pdf" >&2
  echo "raw_remainder matched: $raw_remainder" >&2
  echo "cleaned_remainder expected: John Doe file.pdf" >&2
  echo "cleaned_remainder matched: $cleaned_remainder" >&2
  echo "error_status expected: " >&2
  echo "error_status matched: $error_status" >&2
  echo "extracted_category expected: Receipts" >&2
  echo "extracted_category matched: $extracted_category" >&2
  echo "expected match: true" >&2
  echo "---------------------" >&2
  assert_equal "$extracted_category" "Receipts"
  assert_equal "$raw_category" "Receipts_2023"
  assert_equal "$cleaned_category" "Receipts"
  assert_equal "$raw_remainder" "John Doe/file.pdf"
  assert_equal "$cleaned_remainder" "John Doe file.pdf"
  assert_equal "$error_status" ""
}

@test "extract_category_from_path - John Doe/!@#$/file.pdf" {
  cleaned_remainder=$(python3 $BATS_TEST_DIRNAME/../../core/utils/name_matcher.py --clean-filename "John Doe/!@#$/file.pdf")
  echo "----- TEST CASE -----" >&2
  echo "Comment: Edge case: only special characters " >&2
  echo "function: extract_category_from_path" >&2
  echo "input_path: John Doe/!@#$/file.pdf" >&2
  echo "input_category: !@#$" >&2
  echo "expected_match: false" >&2
  echo "raw remainder expected: John Doe/file.pdf" >&2
  echo "raw remainder matched: John Doe/file.pdf" >&2
  echo "cleaned remainder expected: John Doe ! file.pdf" >&2
  echo "cleaned remainder matched: $cleaned_remainder" >&2
  echo "extracted_category expected: !@#$" >&2
  echo "extracted_category matched: " >&2
  echo "expected match: false" >&2
  echo "---------------------" >&2
  assert_equal "$cleaned_remainder" "John Doe ! file.pdf"
}
