#!/usr/bin/env bats

load "${BATS_TEST_DIRNAME}/../test-helper/bats-support/load.bash"
load "${BATS_TEST_DIRNAME}/../test-helper/bats-assert/load.bash"
load "${BATS_TEST_DIRNAME}/../test-helper/bats-file/load.bash"

# Auto-generated BATS tests for user name mapping
source "${BATS_TEST_DIRNAME}/../../core/utils/user_mapping.sh"


@test "get_user_id_by_name - John Doe" {
  run get_user_id_by_name "John Doe"
  [ "$status" -eq 0 ]
  IFS='|' read -r user_id full_name raw_name cleaned_name <<< "$output"
  echo "----- TEST CASE -----" >&2
  echo "Comment: Mapped user (full name)" >&2
  echo "function: get_user_id_by_name" >&2
  echo "input_name: John Doe" >&2
  echo "expected_user_id: 1001" >&2
  echo "expected_full_name: John Doe" >&2
  echo "raw_name expected: John Doe" >&2
  echo "raw_name matched: $raw_name" >&2
  echo "cleaned_name expected: John Doe" >&2
  echo "cleaned_name matched: $cleaned_name" >&2
  echo "user_id expected: 1001" >&2
  echo "user_id matched: $user_id" >&2
  echo "full_name expected: John Doe" >&2
  echo "full_name matched: $full_name" >&2
  echo "---------------------" >&2
  assert_equal "$user_id" "1001"
  assert_equal "$full_name" "John Doe"
  assert_equal "$raw_name" "John Doe"
  assert_equal "$cleaned_name" "John Doe"
}

@test "get_user_id_by_name - Jane Smith" {
  run get_user_id_by_name "Jane Smith"
  [ "$status" -eq 0 ]
  IFS='|' read -r user_id full_name raw_name cleaned_name <<< "$output"
  echo "----- TEST CASE -----" >&2
  echo "Comment: Mapped user (full name)" >&2
  echo "function: get_user_id_by_name" >&2
  echo "input_name: Jane Smith" >&2
  echo "expected_user_id: 1002" >&2
  echo "expected_full_name: Jane Smith" >&2
  echo "raw_name expected: Jane Smith" >&2
  echo "raw_name matched: $raw_name" >&2
  echo "cleaned_name expected: Jane Smith" >&2
  echo "cleaned_name matched: $cleaned_name" >&2
  echo "user_id expected: 1002" >&2
  echo "user_id matched: $user_id" >&2
  echo "full_name expected: Jane Smith" >&2
  echo "full_name matched: $full_name" >&2
  echo "---------------------" >&2
  assert_equal "$user_id" "1002"
  assert_equal "$full_name" "Jane Smith"
  assert_equal "$raw_name" "Jane Smith"
  assert_equal "$cleaned_name" "Jane Smith"
}

@test "get_user_id_by_name - Temp Person" {
  run get_user_id_by_name "Temp Person"
  [ "$status" -eq 0 ]
  IFS='|' read -r user_id full_name raw_name cleaned_name <<< "$output"
  echo "----- TEST CASE -----" >&2
  echo "Comment: Unmapped user" >&2
  echo "function: get_user_id_by_name" >&2
  echo "input_name: Temp Person" >&2
  echo "expected_user_id: " >&2
  echo "expected_full_name: " >&2
  echo "raw_name expected: Temp Person" >&2
  echo "raw_name matched: $raw_name" >&2
  echo "cleaned_name expected: Temp Person" >&2
  echo "cleaned_name matched: $cleaned_name" >&2
  echo "user_id expected: " >&2
  echo "user_id matched: $user_id" >&2
  echo "full_name expected: " >&2
  echo "full_name matched: $full_name" >&2
  echo "---------------------" >&2
  assert_equal "$user_id" ""
  assert_equal "$full_name" ""
  assert_equal "$raw_name" "Temp Person"
  assert_equal "$cleaned_name" "Temp Person"
}

@test "get_user_id_by_name - J.D." {
  run get_user_id_by_name "J.D."
  [ "$status" -eq 0 ]
  IFS='|' read -r user_id full_name raw_name cleaned_name <<< "$output"
  echo "----- TEST CASE -----" >&2
  echo "Comment: Initials (should map to full name if possible)" >&2
  echo "function: get_user_id_by_name" >&2
  echo "input_name: J.D." >&2
  echo "expected_user_id: " >&2
  echo "expected_full_name: " >&2
  echo "raw_name expected: J.D." >&2
  echo "raw_name matched: $raw_name" >&2
  echo "cleaned_name expected: John Doe" >&2
  echo "cleaned_name matched: $cleaned_name" >&2
  echo "user_id expected: " >&2
  echo "user_id matched: $user_id" >&2
  echo "full_name expected: " >&2
  echo "full_name matched: $full_name" >&2
  echo "---------------------" >&2
  assert_equal "$user_id" ""
  assert_equal "$full_name" ""
  assert_equal "$raw_name" "J.D."
  assert_equal "$cleaned_name" "John Doe"
}

@test "get_user_id_by_name - JD" {
  run get_user_id_by_name "JD"
  [ "$status" -eq 0 ]
  IFS='|' read -r user_id full_name raw_name cleaned_name <<< "$output"
  echo "----- TEST CASE -----" >&2
  echo "Comment: Initials, no punctuation" >&2
  echo "function: get_user_id_by_name" >&2
  echo "input_name: JD" >&2
  echo "expected_user_id: " >&2
  echo "expected_full_name: " >&2
  echo "raw_name expected: JD" >&2
  echo "raw_name matched: $raw_name" >&2
  echo "cleaned_name expected: John Doe" >&2
  echo "cleaned_name matched: $cleaned_name" >&2
  echo "user_id expected: " >&2
  echo "user_id matched: $user_id" >&2
  echo "full_name expected: " >&2
  echo "full_name matched: $full_name" >&2
  echo "---------------------" >&2
  assert_equal "$user_id" ""
  assert_equal "$full_name" ""
  assert_equal "$raw_name" "JD"
  assert_equal "$cleaned_name" "John Doe"
}

@test "get_user_id_by_name - john doe" {
  run get_user_id_by_name "john doe"
  [ "$status" -eq 0 ]
  IFS='|' read -r user_id full_name raw_name cleaned_name <<< "$output"
  echo "----- TEST CASE -----" >&2
  echo "Comment: Case-insensitive mapped user" >&2
  echo "function: get_user_id_by_name" >&2
  echo "input_name: john doe" >&2
  echo "expected_user_id: 1001" >&2
  echo "expected_full_name: John Doe" >&2
  echo "raw_name expected: john doe" >&2
  echo "raw_name matched: $raw_name" >&2
  echo "cleaned_name expected: John Doe" >&2
  echo "cleaned_name matched: $cleaned_name" >&2
  echo "user_id expected: 1001" >&2
  echo "user_id matched: $user_id" >&2
  echo "full_name expected: John Doe" >&2
  echo "full_name matched: $full_name" >&2
  echo "---------------------" >&2
  assert_equal "$user_id" "1001"
  assert_equal "$full_name" "John Doe"
  assert_equal "$raw_name" "john doe"
  assert_equal "$cleaned_name" "John Doe"
}

@test "get_user_id_by_name - Jöhn Döe" {
  run get_user_id_by_name "Jöhn Döe"
  [ "$status" -eq 0 ]
  IFS='|' read -r user_id full_name raw_name cleaned_name <<< "$output"
  echo "----- TEST CASE -----" >&2
  echo "Comment: Accented name, should map to John Doe" >&2
  echo "function: get_user_id_by_name" >&2
  echo "input_name: Jöhn Döe" >&2
  echo "expected_user_id: " >&2
  echo "expected_full_name: " >&2
  echo "raw_name expected: Jöhn Döe" >&2
  echo "raw_name matched: $raw_name" >&2
  echo "cleaned_name expected: John Doe" >&2
  echo "cleaned_name matched: $cleaned_name" >&2
  echo "user_id expected: " >&2
  echo "user_id matched: $user_id" >&2
  echo "full_name expected: " >&2
  echo "full_name matched: $full_name" >&2
  echo "---------------------" >&2
  assert_equal "$user_id" ""
  assert_equal "$full_name" ""
  assert_equal "$raw_name" "Jöhn Döe"
  assert_equal "$cleaned_name" "John Doe"
}

@test "get_user_id_by_name - John" {
  run get_user_id_by_name "John"
  [ "$status" -eq 0 ]
  IFS='|' read -r user_id full_name raw_name cleaned_name <<< "$output"
  echo "----- TEST CASE -----" >&2
  echo "Comment: Partial name (first name)" >&2
  echo "function: get_user_id_by_name" >&2
  echo "input_name: John" >&2
  echo "expected_user_id: " >&2
  echo "expected_full_name: " >&2
  echo "raw_name expected: John" >&2
  echo "raw_name matched: $raw_name" >&2
  echo "cleaned_name expected: John Doe" >&2
  echo "cleaned_name matched: $cleaned_name" >&2
  echo "user_id expected: " >&2
  echo "user_id matched: $user_id" >&2
  echo "full_name expected: " >&2
  echo "full_name matched: $full_name" >&2
  echo "---------------------" >&2
  assert_equal "$user_id" ""
  assert_equal "$full_name" ""
  assert_equal "$raw_name" "John"
  assert_equal "$cleaned_name" "John Doe"
}

@test "get_user_id_by_name - Doe" {
  run get_user_id_by_name "Doe"
  [ "$status" -eq 0 ]
  IFS='|' read -r user_id full_name raw_name cleaned_name <<< "$output"
  echo "----- TEST CASE -----" >&2
  echo "Comment: Partial name (last name)" >&2
  echo "function: get_user_id_by_name" >&2
  echo "input_name: Doe" >&2
  echo "expected_user_id: " >&2
  echo "expected_full_name: " >&2
  echo "raw_name expected: Doe" >&2
  echo "raw_name matched: $raw_name" >&2
  echo "cleaned_name expected: John Doe" >&2
  echo "cleaned_name matched: $cleaned_name" >&2
  echo "user_id expected: " >&2
  echo "user_id matched: $user_id" >&2
  echo "full_name expected: " >&2
  echo "full_name matched: $full_name" >&2
  echo "---------------------" >&2
  assert_equal "$user_id" ""
  assert_equal "$full_name" ""
  assert_equal "$raw_name" "Doe"
  assert_equal "$cleaned_name" "John Doe"
}

@test "get_user_id_by_name - J0hn D03" {
  run get_user_id_by_name "J0hn D03"
  [ "$status" -eq 0 ]
  IFS='|' read -r user_id full_name raw_name cleaned_name <<< "$output"
  echo "----- TEST CASE -----" >&2
  echo "Comment: Name with numbers/letter substitution" >&2
  echo "function: get_user_id_by_name" >&2
  echo "input_name: J0hn D03" >&2
  echo "expected_user_id: " >&2
  echo "expected_full_name: " >&2
  echo "raw_name expected: J0hn D03" >&2
  echo "raw_name matched: $raw_name" >&2
  echo "cleaned_name expected: John Doe" >&2
  echo "cleaned_name matched: $cleaned_name" >&2
  echo "user_id expected: " >&2
  echo "user_id matched: $user_id" >&2
  echo "full_name expected: " >&2
  echo "full_name matched: $full_name" >&2
  echo "---------------------" >&2
  assert_equal "$user_id" ""
  assert_equal "$full_name" ""
  assert_equal "$raw_name" "J0hn D03"
  assert_equal "$cleaned_name" "John Doe"
}

@test "get_user_id_by_name - !@#$" {
  run get_user_id_by_name "!@#$"
  [ "$status" -eq 0 ]
  IFS='|' read -r user_id full_name raw_name cleaned_name <<< "$output"
  echo "----- TEST CASE -----" >&2
  echo "Comment: Edge case: only special characters " >&2
  echo "function: get_user_id_by_name" >&2
  echo "input_name: !@#$" >&2
  echo "expected_user_id: " >&2
  echo "expected_full_name: " >&2
  echo "raw_name expected: !@#$" >&2
  echo "raw_name matched: $raw_name" >&2
  echo "cleaned_name expected: " >&2
  echo "cleaned_name matched: $cleaned_name" >&2
  echo "user_id expected: " >&2
  echo "user_id matched: $user_id" >&2
  echo "full_name expected: " >&2
  echo "full_name matched: $full_name" >&2
  echo "---------------------" >&2
  assert_equal "$user_id" ""
  assert_equal "$full_name" ""
  assert_equal "$raw_name" "!@#$"
  assert_equal "$cleaned_name" ""
}
