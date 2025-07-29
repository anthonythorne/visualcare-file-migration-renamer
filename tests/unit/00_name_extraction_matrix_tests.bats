#!/usr/bin/env bats

load "${BATS_TEST_DIRNAME}/../test-helper/bats-support/load.bash"
load "${BATS_TEST_DIRNAME}/../test-helper/bats-assert/load.bash"
load "${BATS_TEST_DIRNAME}/../test-helper/bats-file/load.bash"

# Auto-generated BATS tests for name extraction
source "${BATS_TEST_DIRNAME}/../utils/name_utils.sh"

# Define a single shell function to call the Python matcher with the matcher_function as the third argument
extract_name_from_filename() {
  local filename="$1"
  local name_to_match="$2"
  local matcher_function="${3:-extract_name_from_filename}"
  python3 "${BATS_TEST_DIRNAME}/../../core/utils/name_matcher.py" "$filename" "$name_to_match" "$matcher_function"
}


@test "extract_first_name_from_filename - john-doe-report.pdf" {
  run extract_name_from_filename "john-doe-report.pdf" "john doe" "extract_first_name_from_filename"
  [ "$status" -eq 0 ]
  IFS='|' read -r extracted_name raw_remainder matched <<< "$output"
  cleaned_remainder=$(clean_filename_remainder "$raw_remainder")
  echo "----- TEST CASE -----" >&2
  echo "Comment: First Name only" >&2
  echo "function: extract_first_name_from_filename" >&2
  echo "filename: john-doe-report.pdf" >&2
  echo "name to match: john doe" >&2
  echo "expected_match: true" >&2
  echo "raw remainder expected: -doe-report.pdf" >&2
  echo "raw remainder matched: $raw_remainder" >&2
  echo "cleaned remainder expected: doe report.pdf" >&2
  echo "cleaned remainder matched: $cleaned_remainder" >&2
  echo "extracted_name expected: john" >&2
  echo "extracted_name matched: $extracted_name" >&2
  echo "expected match: $matched" >&2
  echo "---------------------" >&2
  assert_equal "$extracted_name" "john"
  assert_equal "$raw_remainder" "-doe-report.pdf"
  assert_equal "$cleaned_remainder" "doe report.pdf"
}

@test "extract_first_name_from_filename - John Doe 20240525 report.pdf" {
  run extract_name_from_filename "John Doe 20240525 report.pdf" "john doe" "extract_first_name_from_filename"
  [ "$status" -eq 0 ]
  IFS='|' read -r extracted_name raw_remainder matched <<< "$output"
  cleaned_remainder=$(clean_filename_remainder "$raw_remainder")
  echo "----- TEST CASE -----" >&2
  echo "Comment: First Name only" >&2
  echo "function: extract_first_name_from_filename" >&2
  echo "filename: John Doe 20240525 report.pdf" >&2
  echo "name to match: john doe" >&2
  echo "expected_match: true" >&2
  echo "raw remainder expected:  Doe 20240525 report.pdf" >&2
  echo "raw remainder matched: $raw_remainder" >&2
  echo "cleaned remainder expected: Doe 20240525 report.pdf" >&2
  echo "cleaned remainder matched: $cleaned_remainder" >&2
  echo "extracted_name expected: John" >&2
  echo "extracted_name matched: $extracted_name" >&2
  echo "expected match: $matched" >&2
  echo "---------------------" >&2
  assert_equal "$extracted_name" "John"
  assert_equal "$raw_remainder" " Doe 20240525 report.pdf"
  assert_equal "$cleaned_remainder" "Doe 20240525 report.pdf"
}

@test "extract_last_name_from_filename - john-doe-report.pdf" {
  run extract_name_from_filename "john-doe-report.pdf" "john doe" "extract_last_name_from_filename"
  [ "$status" -eq 0 ]
  IFS='|' read -r extracted_name raw_remainder matched <<< "$output"
  cleaned_remainder=$(clean_filename_remainder "$raw_remainder")
  echo "----- TEST CASE -----" >&2
  echo "Comment: Last Name only" >&2
  echo "function: extract_last_name_from_filename" >&2
  echo "filename: john-doe-report.pdf" >&2
  echo "name to match: john doe" >&2
  echo "expected_match: true" >&2
  echo "raw remainder expected: john--report.pdf" >&2
  echo "raw remainder matched: $raw_remainder" >&2
  echo "cleaned remainder expected: john report.pdf" >&2
  echo "cleaned remainder matched: $cleaned_remainder" >&2
  echo "extracted_name expected: doe" >&2
  echo "extracted_name matched: $extracted_name" >&2
  echo "expected match: $matched" >&2
  echo "---------------------" >&2
  assert_equal "$extracted_name" "doe"
  assert_equal "$raw_remainder" "john--report.pdf"
  assert_equal "$cleaned_remainder" "john report.pdf"
}

@test "extract_last_name_from_filename - John Doe 20240525 report.pdf" {
  run extract_name_from_filename "John Doe 20240525 report.pdf" "john doe" "extract_last_name_from_filename"
  [ "$status" -eq 0 ]
  IFS='|' read -r extracted_name raw_remainder matched <<< "$output"
  cleaned_remainder=$(clean_filename_remainder "$raw_remainder")
  echo "----- TEST CASE -----" >&2
  echo "Comment: Last Name only" >&2
  echo "function: extract_last_name_from_filename" >&2
  echo "filename: John Doe 20240525 report.pdf" >&2
  echo "name to match: john doe" >&2
  echo "expected_match: true" >&2
  echo "raw remainder expected: John  20240525 report.pdf" >&2
  echo "raw remainder matched: $raw_remainder" >&2
  echo "cleaned remainder expected: John 20240525 report.pdf" >&2
  echo "cleaned remainder matched: $cleaned_remainder" >&2
  echo "extracted_name expected: Doe" >&2
  echo "extracted_name matched: $extracted_name" >&2
  echo "expected match: $matched" >&2
  echo "---------------------" >&2
  assert_equal "$extracted_name" "Doe"
  assert_equal "$raw_remainder" "John  20240525 report.pdf"
  assert_equal "$cleaned_remainder" "John 20240525 report.pdf"
}

@test "extract_initials_from_filename - j-d-report.pdf" {
  run extract_name_from_filename "j-d-report.pdf" "john doe" "extract_initials_from_filename"
  [ "$status" -eq 0 ]
  IFS='|' read -r extracted_name raw_remainder matched <<< "$output"
  cleaned_remainder=$(clean_filename_remainder "$raw_remainder")
  echo "----- TEST CASE -----" >&2
  echo "Comment: Both Initials - Hyphen separator" >&2
  echo "function: extract_initials_from_filename" >&2
  echo "filename: j-d-report.pdf" >&2
  echo "name to match: john doe" >&2
  echo "expected_match: true" >&2
  echo "raw remainder expected: -report.pdf" >&2
  echo "raw remainder matched: $raw_remainder" >&2
  echo "cleaned remainder expected: report.pdf" >&2
  echo "cleaned remainder matched: $cleaned_remainder" >&2
  echo "extracted_name expected: j-d" >&2
  echo "extracted_name matched: $extracted_name" >&2
  echo "expected match: $matched" >&2
  echo "---------------------" >&2
  assert_equal "$extracted_name" "j-d"
  assert_equal "$raw_remainder" "-report.pdf"
  assert_equal "$cleaned_remainder" "report.pdf"
}

@test "extract_initials_from_filename - Home J.D report.pdf" {
  run extract_name_from_filename "Home J.D report.pdf" "john doe" "extract_initials_from_filename"
  [ "$status" -eq 0 ]
  IFS='|' read -r extracted_name raw_remainder matched <<< "$output"
  cleaned_remainder=$(clean_filename_remainder "$raw_remainder")
  echo "----- TEST CASE -----" >&2
  echo "Comment: Both Initials - Period separator" >&2
  echo "function: extract_initials_from_filename" >&2
  echo "filename: Home J.D report.pdf" >&2
  echo "name to match: john doe" >&2
  echo "expected_match: true" >&2
  echo "raw remainder expected: Home  report.pdf" >&2
  echo "raw remainder matched: $raw_remainder" >&2
  echo "cleaned remainder expected: Home report.pdf" >&2
  echo "cleaned remainder matched: $cleaned_remainder" >&2
  echo "extracted_name expected: J.D" >&2
  echo "extracted_name matched: $extracted_name" >&2
  echo "expected match: $matched" >&2
  echo "---------------------" >&2
  assert_equal "$extracted_name" "J.D"
  assert_equal "$raw_remainder" "Home  report.pdf"
  assert_equal "$cleaned_remainder" "Home report.pdf"
}

@test "extract_initials_from_filename - File j d report.pdf" {
  run extract_name_from_filename "File j d report.pdf" "john doe" "extract_initials_from_filename"
  [ "$status" -eq 0 ]
  IFS='|' read -r extracted_name raw_remainder matched <<< "$output"
  cleaned_remainder=$(clean_filename_remainder "$raw_remainder")
  echo "----- TEST CASE -----" >&2
  echo "Comment: Both Initials - Space separator" >&2
  echo "function: extract_initials_from_filename" >&2
  echo "filename: File j d report.pdf" >&2
  echo "name to match: john doe" >&2
  echo "expected_match: true" >&2
  echo "raw remainder expected: File  report.pdf" >&2
  echo "raw remainder matched: $raw_remainder" >&2
  echo "cleaned remainder expected: File report.pdf" >&2
  echo "cleaned remainder matched: $cleaned_remainder" >&2
  echo "extracted_name expected: j d" >&2
  echo "extracted_name matched: $extracted_name" >&2
  echo "expected match: $matched" >&2
  echo "---------------------" >&2
  assert_equal "$extracted_name" "j d"
  assert_equal "$raw_remainder" "File  report.pdf"
  assert_equal "$cleaned_remainder" "File report.pdf"
}

@test "extract_initials_from_filename - j_d_report.pdf" {
  run extract_name_from_filename "j_d_report.pdf" "john doe" "extract_initials_from_filename"
  [ "$status" -eq 0 ]
  IFS='|' read -r extracted_name raw_remainder matched <<< "$output"
  cleaned_remainder=$(clean_filename_remainder "$raw_remainder")
  echo "----- TEST CASE -----" >&2
  echo "Comment: Both Initials - Underscore separator" >&2
  echo "function: extract_initials_from_filename" >&2
  echo "filename: j_d_report.pdf" >&2
  echo "name to match: john doe" >&2
  echo "expected_match: true" >&2
  echo "raw remainder expected: _report.pdf" >&2
  echo "raw remainder matched: $raw_remainder" >&2
  echo "cleaned remainder expected: report.pdf" >&2
  echo "cleaned remainder matched: $cleaned_remainder" >&2
  echo "extracted_name expected: j_d" >&2
  echo "extracted_name matched: $extracted_name" >&2
  echo "expected match: $matched" >&2
  echo "---------------------" >&2
  assert_equal "$extracted_name" "j_d"
  assert_equal "$raw_remainder" "_report.pdf"
  assert_equal "$cleaned_remainder" "report.pdf"
}

@test "extract_initials_from_filename - File j_- d_report.pdf" {
  run extract_name_from_filename "File j_- d_report.pdf" "john doe" "extract_initials_from_filename"
  [ "$status" -eq 0 ]
  IFS='|' read -r extracted_name raw_remainder matched <<< "$output"
  cleaned_remainder=$(clean_filename_remainder "$raw_remainder")
  echo "----- TEST CASE -----" >&2
  echo "Comment: Both Initials - Underscore separator" >&2
  echo "function: extract_initials_from_filename" >&2
  echo "filename: File j_- d_report.pdf" >&2
  echo "name to match: john doe" >&2
  echo "expected_match: true" >&2
  echo "raw remainder expected: File _report.pdf" >&2
  echo "raw remainder matched: $raw_remainder" >&2
  echo "cleaned remainder expected: File report.pdf" >&2
  echo "cleaned remainder matched: $cleaned_remainder" >&2
  echo "extracted_name expected: j_- d" >&2
  echo "extracted_name matched: $extracted_name" >&2
  echo "expected match: $matched" >&2
  echo "---------------------" >&2
  assert_equal "$extracted_name" "j_- d"
  assert_equal "$raw_remainder" "File _report.pdf"
  assert_equal "$cleaned_remainder" "File report.pdf"
}

@test "extract_shorthand_name_from_filename - j-doe-report.pdf" {
  run extract_name_from_filename "j-doe-report.pdf" "john doe" "extract_shorthand_name_from_filename"
  [ "$status" -eq 0 ]
  IFS='|' read -r extracted_name raw_remainder matched <<< "$output"
  cleaned_remainder=$(clean_filename_remainder "$raw_remainder")
  echo "----- TEST CASE -----" >&2
  echo "Comment: First Initial + Last Name - Hyphen separator" >&2
  echo "function: extract_shorthand_name_from_filename" >&2
  echo "filename: j-doe-report.pdf" >&2
  echo "name to match: john doe" >&2
  echo "expected_match: true" >&2
  echo "raw remainder expected: -report.pdf" >&2
  echo "raw remainder matched: $raw_remainder" >&2
  echo "cleaned remainder expected: report.pdf" >&2
  echo "cleaned remainder matched: $cleaned_remainder" >&2
  echo "extracted_name expected: j-doe" >&2
  echo "extracted_name matched: $extracted_name" >&2
  echo "expected match: $matched" >&2
  echo "---------------------" >&2
  assert_equal "$extracted_name" "j-doe"
  assert_equal "$raw_remainder" "-report.pdf"
  assert_equal "$cleaned_remainder" "report.pdf"
}

@test "extract_shorthand_name_from_filename - j_doe_report.pdf" {
  run extract_name_from_filename "j_doe_report.pdf" "john doe" "extract_shorthand_name_from_filename"
  [ "$status" -eq 0 ]
  IFS='|' read -r extracted_name raw_remainder matched <<< "$output"
  cleaned_remainder=$(clean_filename_remainder "$raw_remainder")
  echo "----- TEST CASE -----" >&2
  echo "Comment: First Initial + Last Name - Underscore separator" >&2
  echo "function: extract_shorthand_name_from_filename" >&2
  echo "filename: j_doe_report.pdf" >&2
  echo "name to match: john doe" >&2
  echo "expected_match: true" >&2
  echo "raw remainder expected: _report.pdf" >&2
  echo "raw remainder matched: $raw_remainder" >&2
  echo "cleaned remainder expected: report.pdf" >&2
  echo "cleaned remainder matched: $cleaned_remainder" >&2
  echo "extracted_name expected: j_doe" >&2
  echo "extracted_name matched: $extracted_name" >&2
  echo "expected match: $matched" >&2
  echo "---------------------" >&2
  assert_equal "$extracted_name" "j_doe"
  assert_equal "$raw_remainder" "_report.pdf"
  assert_equal "$cleaned_remainder" "report.pdf"
}

@test "extract_shorthand_name_from_filename - j doe report.pdf" {
  run extract_name_from_filename "j doe report.pdf" "john doe" "extract_shorthand_name_from_filename"
  [ "$status" -eq 0 ]
  IFS='|' read -r extracted_name raw_remainder matched <<< "$output"
  cleaned_remainder=$(clean_filename_remainder "$raw_remainder")
  echo "----- TEST CASE -----" >&2
  echo "Comment: First Initial + Last Name - Space separator" >&2
  echo "function: extract_shorthand_name_from_filename" >&2
  echo "filename: j doe report.pdf" >&2
  echo "name to match: john doe" >&2
  echo "expected_match: true" >&2
  echo "raw remainder expected:  report.pdf" >&2
  echo "raw remainder matched: $raw_remainder" >&2
  echo "cleaned remainder expected: report.pdf" >&2
  echo "cleaned remainder matched: $cleaned_remainder" >&2
  echo "extracted_name expected: j doe" >&2
  echo "extracted_name matched: $extracted_name" >&2
  echo "expected match: $matched" >&2
  echo "---------------------" >&2
  assert_equal "$extracted_name" "j doe"
  assert_equal "$raw_remainder" " report.pdf"
  assert_equal "$cleaned_remainder" "report.pdf"
}

@test "extract_shorthand_name_from_filename - j.doe.report.pdf" {
  run extract_name_from_filename "j.doe.report.pdf" "john doe" "extract_shorthand_name_from_filename"
  [ "$status" -eq 0 ]
  IFS='|' read -r extracted_name raw_remainder matched <<< "$output"
  cleaned_remainder=$(clean_filename_remainder "$raw_remainder")
  echo "----- TEST CASE -----" >&2
  echo "Comment: First Initial + Last Name - Period separator" >&2
  echo "function: extract_shorthand_name_from_filename" >&2
  echo "filename: j.doe.report.pdf" >&2
  echo "name to match: john doe" >&2
  echo "expected_match: true" >&2
  echo "raw remainder expected: .report.pdf" >&2
  echo "raw remainder matched: $raw_remainder" >&2
  echo "cleaned remainder expected: report.pdf" >&2
  echo "cleaned remainder matched: $cleaned_remainder" >&2
  echo "extracted_name expected: j.doe" >&2
  echo "extracted_name matched: $extracted_name" >&2
  echo "expected match: $matched" >&2
  echo "---------------------" >&2
  assert_equal "$extracted_name" "j.doe"
  assert_equal "$raw_remainder" ".report.pdf"
  assert_equal "$cleaned_remainder" "report.pdf"
}

@test "extract_shorthand_name_from_filename - john-d-report.pdf" {
  run extract_name_from_filename "john-d-report.pdf" "john doe" "extract_shorthand_name_from_filename"
  [ "$status" -eq 0 ]
  IFS='|' read -r extracted_name raw_remainder matched <<< "$output"
  cleaned_remainder=$(clean_filename_remainder "$raw_remainder")
  echo "----- TEST CASE -----" >&2
  echo "Comment: First Name + Last Initial - Hyphen separator" >&2
  echo "function: extract_shorthand_name_from_filename" >&2
  echo "filename: john-d-report.pdf" >&2
  echo "name to match: john doe" >&2
  echo "expected_match: true" >&2
  echo "raw remainder expected: -report.pdf" >&2
  echo "raw remainder matched: $raw_remainder" >&2
  echo "cleaned remainder expected: report.pdf" >&2
  echo "cleaned remainder matched: $cleaned_remainder" >&2
  echo "extracted_name expected: john-d" >&2
  echo "extracted_name matched: $extracted_name" >&2
  echo "expected match: $matched" >&2
  echo "---------------------" >&2
  assert_equal "$extracted_name" "john-d"
  assert_equal "$raw_remainder" "-report.pdf"
  assert_equal "$cleaned_remainder" "report.pdf"
}

@test "extract_shorthand_name_from_filename - john_d_report.pdf" {
  run extract_name_from_filename "john_d_report.pdf" "john doe" "extract_shorthand_name_from_filename"
  [ "$status" -eq 0 ]
  IFS='|' read -r extracted_name raw_remainder matched <<< "$output"
  cleaned_remainder=$(clean_filename_remainder "$raw_remainder")
  echo "----- TEST CASE -----" >&2
  echo "Comment: First Name + Last Initial - Underscore separator" >&2
  echo "function: extract_shorthand_name_from_filename" >&2
  echo "filename: john_d_report.pdf" >&2
  echo "name to match: john doe" >&2
  echo "expected_match: true" >&2
  echo "raw remainder expected: _report.pdf" >&2
  echo "raw remainder matched: $raw_remainder" >&2
  echo "cleaned remainder expected: report.pdf" >&2
  echo "cleaned remainder matched: $cleaned_remainder" >&2
  echo "extracted_name expected: john_d" >&2
  echo "extracted_name matched: $extracted_name" >&2
  echo "expected match: $matched" >&2
  echo "---------------------" >&2
  assert_equal "$extracted_name" "john_d"
  assert_equal "$raw_remainder" "_report.pdf"
  assert_equal "$cleaned_remainder" "report.pdf"
}

@test "extract_shorthand_name_from_filename - john d report.pdf" {
  run extract_name_from_filename "john d report.pdf" "john doe" "extract_shorthand_name_from_filename"
  [ "$status" -eq 0 ]
  IFS='|' read -r extracted_name raw_remainder matched <<< "$output"
  cleaned_remainder=$(clean_filename_remainder "$raw_remainder")
  echo "----- TEST CASE -----" >&2
  echo "Comment: First Name + Last Initial - Space separator" >&2
  echo "function: extract_shorthand_name_from_filename" >&2
  echo "filename: john d report.pdf" >&2
  echo "name to match: john doe" >&2
  echo "expected_match: true" >&2
  echo "raw remainder expected:  report.pdf" >&2
  echo "raw remainder matched: $raw_remainder" >&2
  echo "cleaned remainder expected: report.pdf" >&2
  echo "cleaned remainder matched: $cleaned_remainder" >&2
  echo "extracted_name expected: john d" >&2
  echo "extracted_name matched: $extracted_name" >&2
  echo "expected match: $matched" >&2
  echo "---------------------" >&2
  assert_equal "$extracted_name" "john d"
  assert_equal "$raw_remainder" " report.pdf"
  assert_equal "$cleaned_remainder" "report.pdf"
}

@test "extract_shorthand_name_from_filename - john.d.report.pdf" {
  run extract_name_from_filename "john.d.report.pdf" "john doe" "extract_shorthand_name_from_filename"
  [ "$status" -eq 0 ]
  IFS='|' read -r extracted_name raw_remainder matched <<< "$output"
  cleaned_remainder=$(clean_filename_remainder "$raw_remainder")
  echo "----- TEST CASE -----" >&2
  echo "Comment: First Name + Last Initial - Period separator" >&2
  echo "function: extract_shorthand_name_from_filename" >&2
  echo "filename: john.d.report.pdf" >&2
  echo "name to match: john doe" >&2
  echo "expected_match: true" >&2
  echo "raw remainder expected: .report.pdf" >&2
  echo "raw remainder matched: $raw_remainder" >&2
  echo "cleaned remainder expected: report.pdf" >&2
  echo "cleaned remainder matched: $cleaned_remainder" >&2
  echo "extracted_name expected: john.d" >&2
  echo "extracted_name matched: $extracted_name" >&2
  echo "expected match: $matched" >&2
  echo "---------------------" >&2
  assert_equal "$extracted_name" "john.d"
  assert_equal "$raw_remainder" ".report.pdf"
  assert_equal "$cleaned_remainder" "report.pdf"
}

@test "extract_name_from_filename - john-doe-report.pdf" {
  run extract_name_from_filename "john-doe-report.pdf" "john doe" "extract_name_from_filename"
  [ "$status" -eq 0 ]
  IFS='|' read -r extracted_name raw_remainder matched <<< "$output"
  cleaned_remainder=$(clean_filename_remainder "$raw_remainder")
  echo "----- TEST CASE -----" >&2
  echo "Comment: First Name - Hyphen separator" >&2
  echo "function: extract_name_from_filename" >&2
  echo "filename: john-doe-report.pdf" >&2
  echo "name to match: john doe" >&2
  echo "expected_match: true" >&2
  echo "raw remainder expected: --report.pdf" >&2
  echo "raw remainder matched: $raw_remainder" >&2
  echo "cleaned remainder expected: report.pdf" >&2
  echo "cleaned remainder matched: $cleaned_remainder" >&2
  echo "extracted_name expected: john,doe" >&2
  echo "extracted_name matched: $extracted_name" >&2
  echo "expected match: $matched" >&2
  echo "---------------------" >&2
  assert_equal "$extracted_name" "john,doe"
  assert_equal "$raw_remainder" "--report.pdf"
  assert_equal "$cleaned_remainder" "report.pdf"
}

@test "extract_name_from_filename - john_doe_report.pdf" {
  run extract_name_from_filename "john_doe_report.pdf" "john doe" "extract_name_from_filename"
  [ "$status" -eq 0 ]
  IFS='|' read -r extracted_name raw_remainder matched <<< "$output"
  cleaned_remainder=$(clean_filename_remainder "$raw_remainder")
  echo "----- TEST CASE -----" >&2
  echo "Comment: First Name - Underscore separator" >&2
  echo "function: extract_name_from_filename" >&2
  echo "filename: john_doe_report.pdf" >&2
  echo "name to match: john doe" >&2
  echo "expected_match: true" >&2
  echo "raw remainder expected: __report.pdf" >&2
  echo "raw remainder matched: $raw_remainder" >&2
  echo "cleaned remainder expected: report.pdf" >&2
  echo "cleaned remainder matched: $cleaned_remainder" >&2
  echo "extracted_name expected: john,doe" >&2
  echo "extracted_name matched: $extracted_name" >&2
  echo "expected match: $matched" >&2
  echo "---------------------" >&2
  assert_equal "$extracted_name" "john,doe"
  assert_equal "$raw_remainder" "__report.pdf"
  assert_equal "$cleaned_remainder" "report.pdf"
}

@test "extract_name_from_filename - john doe report.pdf" {
  run extract_name_from_filename "john doe report.pdf" "john doe" "extract_name_from_filename"
  [ "$status" -eq 0 ]
  IFS='|' read -r extracted_name raw_remainder matched <<< "$output"
  cleaned_remainder=$(clean_filename_remainder "$raw_remainder")
  echo "----- TEST CASE -----" >&2
  echo "Comment: First Name - Space separator" >&2
  echo "function: extract_name_from_filename" >&2
  echo "filename: john doe report.pdf" >&2
  echo "name to match: john doe" >&2
  echo "expected_match: true" >&2
  echo "raw remainder expected:   report.pdf" >&2
  echo "raw remainder matched: $raw_remainder" >&2
  echo "cleaned remainder expected: report.pdf" >&2
  echo "cleaned remainder matched: $cleaned_remainder" >&2
  echo "extracted_name expected: john,doe" >&2
  echo "extracted_name matched: $extracted_name" >&2
  echo "expected match: $matched" >&2
  echo "---------------------" >&2
  assert_equal "$extracted_name" "john,doe"
  assert_equal "$raw_remainder" "  report.pdf"
  assert_equal "$cleaned_remainder" "report.pdf"
}

@test "extract_name_from_filename - john.doe.report.pdf" {
  run extract_name_from_filename "john.doe.report.pdf" "john doe" "extract_name_from_filename"
  [ "$status" -eq 0 ]
  IFS='|' read -r extracted_name raw_remainder matched <<< "$output"
  cleaned_remainder=$(clean_filename_remainder "$raw_remainder")
  echo "----- TEST CASE -----" >&2
  echo "Comment: First Name - Period separator" >&2
  echo "function: extract_name_from_filename" >&2
  echo "filename: john.doe.report.pdf" >&2
  echo "name to match: john doe" >&2
  echo "expected_match: true" >&2
  echo "raw remainder expected: ..report.pdf" >&2
  echo "raw remainder matched: $raw_remainder" >&2
  echo "cleaned remainder expected: report.pdf" >&2
  echo "cleaned remainder matched: $cleaned_remainder" >&2
  echo "extracted_name expected: john,doe" >&2
  echo "extracted_name matched: $extracted_name" >&2
  echo "expected match: $matched" >&2
  echo "---------------------" >&2
  assert_equal "$extracted_name" "john,doe"
  assert_equal "$raw_remainder" "..report.pdf"
  assert_equal "$cleaned_remainder" "report.pdf"
}

@test "extract_name_from_filename - doe-john-report.pdf" {
  run extract_name_from_filename "doe-john-report.pdf" "john doe" "extract_name_from_filename"
  [ "$status" -eq 0 ]
  IFS='|' read -r extracted_name raw_remainder matched <<< "$output"
  cleaned_remainder=$(clean_filename_remainder "$raw_remainder")
  echo "----- TEST CASE -----" >&2
  echo "Comment: Last Name - Hyphen separator" >&2
  echo "function: extract_name_from_filename" >&2
  echo "filename: doe-john-report.pdf" >&2
  echo "name to match: john doe" >&2
  echo "expected_match: true" >&2
  echo "raw remainder expected: --report.pdf" >&2
  echo "raw remainder matched: $raw_remainder" >&2
  echo "cleaned remainder expected: report.pdf" >&2
  echo "cleaned remainder matched: $cleaned_remainder" >&2
  echo "extracted_name expected: john,doe" >&2
  echo "extracted_name matched: $extracted_name" >&2
  echo "expected match: $matched" >&2
  echo "---------------------" >&2
  assert_equal "$extracted_name" "john,doe"
  assert_equal "$raw_remainder" "--report.pdf"
  assert_equal "$cleaned_remainder" "report.pdf"
}

@test "extract_name_from_filename - doe_john_report.pdf" {
  run extract_name_from_filename "doe_john_report.pdf" "john doe" "extract_name_from_filename"
  [ "$status" -eq 0 ]
  IFS='|' read -r extracted_name raw_remainder matched <<< "$output"
  cleaned_remainder=$(clean_filename_remainder "$raw_remainder")
  echo "----- TEST CASE -----" >&2
  echo "Comment: Last Name - Underscore separator" >&2
  echo "function: extract_name_from_filename" >&2
  echo "filename: doe_john_report.pdf" >&2
  echo "name to match: john doe" >&2
  echo "expected_match: true" >&2
  echo "raw remainder expected: __report.pdf" >&2
  echo "raw remainder matched: $raw_remainder" >&2
  echo "cleaned remainder expected: report.pdf" >&2
  echo "cleaned remainder matched: $cleaned_remainder" >&2
  echo "extracted_name expected: john,doe" >&2
  echo "extracted_name matched: $extracted_name" >&2
  echo "expected match: $matched" >&2
  echo "---------------------" >&2
  assert_equal "$extracted_name" "john,doe"
  assert_equal "$raw_remainder" "__report.pdf"
  assert_equal "$cleaned_remainder" "report.pdf"
}

@test "extract_name_from_filename - doe john report.pdf" {
  run extract_name_from_filename "doe john report.pdf" "john doe" "extract_name_from_filename"
  [ "$status" -eq 0 ]
  IFS='|' read -r extracted_name raw_remainder matched <<< "$output"
  cleaned_remainder=$(clean_filename_remainder "$raw_remainder")
  echo "----- TEST CASE -----" >&2
  echo "Comment: Last Name - Space separator" >&2
  echo "function: extract_name_from_filename" >&2
  echo "filename: doe john report.pdf" >&2
  echo "name to match: john doe" >&2
  echo "expected_match: true" >&2
  echo "raw remainder expected:   report.pdf" >&2
  echo "raw remainder matched: $raw_remainder" >&2
  echo "cleaned remainder expected: report.pdf" >&2
  echo "cleaned remainder matched: $cleaned_remainder" >&2
  echo "extracted_name expected: john,doe" >&2
  echo "extracted_name matched: $extracted_name" >&2
  echo "expected match: $matched" >&2
  echo "---------------------" >&2
  assert_equal "$extracted_name" "john,doe"
  assert_equal "$raw_remainder" "  report.pdf"
  assert_equal "$cleaned_remainder" "report.pdf"
}

@test "extract_name_from_filename - doe.john.report.pdf" {
  run extract_name_from_filename "doe.john.report.pdf" "john doe" "extract_name_from_filename"
  [ "$status" -eq 0 ]
  IFS='|' read -r extracted_name raw_remainder matched <<< "$output"
  cleaned_remainder=$(clean_filename_remainder "$raw_remainder")
  echo "----- TEST CASE -----" >&2
  echo "Comment: Last Name - Period separator" >&2
  echo "function: extract_name_from_filename" >&2
  echo "filename: doe.john.report.pdf" >&2
  echo "name to match: john doe" >&2
  echo "expected_match: true" >&2
  echo "raw remainder expected: ..report.pdf" >&2
  echo "raw remainder matched: $raw_remainder" >&2
  echo "cleaned remainder expected: report.pdf" >&2
  echo "cleaned remainder matched: $cleaned_remainder" >&2
  echo "extracted_name expected: john,doe" >&2
  echo "extracted_name matched: $extracted_name" >&2
  echo "expected match: $matched" >&2
  echo "---------------------" >&2
  assert_equal "$extracted_name" "john,doe"
  assert_equal "$raw_remainder" "..report.pdf"
  assert_equal "$cleaned_remainder" "report.pdf"
}

@test "extract_name_from_filename - john*doe-report.pdf" {
  run extract_name_from_filename "john*doe-report.pdf" "john doe" "extract_name_from_filename"
  [ "$status" -eq 0 ]
  IFS='|' read -r extracted_name raw_remainder matched <<< "$output"
  cleaned_remainder=$(clean_filename_remainder "$raw_remainder")
  echo "----- TEST CASE -----" >&2
  echo "Comment: Non-standard separator (asterisk)" >&2
  echo "function: extract_name_from_filename" >&2
  echo "filename: john*doe-report.pdf" >&2
  echo "name to match: john doe" >&2
  echo "expected_match: true" >&2
  echo "raw remainder expected: *-report.pdf" >&2
  echo "raw remainder matched: $raw_remainder" >&2
  echo "cleaned remainder expected: report.pdf" >&2
  echo "cleaned remainder matched: $cleaned_remainder" >&2
  echo "extracted_name expected: john,doe" >&2
  echo "extracted_name matched: $extracted_name" >&2
  echo "expected match: $matched" >&2
  echo "---------------------" >&2
  assert_equal "$extracted_name" "john,doe"
  assert_equal "$raw_remainder" "*-report.pdf"
  assert_equal "$cleaned_remainder" "report.pdf"
}

@test "extract_name_from_filename - john@doe-report.pdf" {
  run extract_name_from_filename "john@doe-report.pdf" "john doe" "extract_name_from_filename"
  [ "$status" -eq 0 ]
  IFS='|' read -r extracted_name raw_remainder matched <<< "$output"
  cleaned_remainder=$(clean_filename_remainder "$raw_remainder")
  echo "----- TEST CASE -----" >&2
  echo "Comment: Non-standard separator (at sign)" >&2
  echo "function: extract_name_from_filename" >&2
  echo "filename: john@doe-report.pdf" >&2
  echo "name to match: john doe" >&2
  echo "expected_match: true" >&2
  echo "raw remainder expected: @-report.pdf" >&2
  echo "raw remainder matched: $raw_remainder" >&2
  echo "cleaned remainder expected: report.pdf" >&2
  echo "cleaned remainder matched: $cleaned_remainder" >&2
  echo "extracted_name expected: john,doe" >&2
  echo "extracted_name matched: $extracted_name" >&2
  echo "expected match: $matched" >&2
  echo "---------------------" >&2
  assert_equal "$extracted_name" "john,doe"
  assert_equal "$raw_remainder" "@-report.pdf"
  assert_equal "$cleaned_remainder" "report.pdf"
}

@test "extract_name_from_filename - john#doe-report.pdf" {
  run extract_name_from_filename "john#doe-report.pdf" "john doe" "extract_name_from_filename"
  [ "$status" -eq 0 ]
  IFS='|' read -r extracted_name raw_remainder matched <<< "$output"
  cleaned_remainder=$(clean_filename_remainder "$raw_remainder")
  echo "----- TEST CASE -----" >&2
  echo "Comment: Non-standard separator (hash)" >&2
  echo "function: extract_name_from_filename" >&2
  echo "filename: john#doe-report.pdf" >&2
  echo "name to match: john doe" >&2
  echo "expected_match: true" >&2
  echo "raw remainder expected: #-report.pdf" >&2
  echo "raw remainder matched: $raw_remainder" >&2
  echo "cleaned remainder expected: report.pdf" >&2
  echo "cleaned remainder matched: $cleaned_remainder" >&2
  echo "extracted_name expected: john,doe" >&2
  echo "extracted_name matched: $extracted_name" >&2
  echo "expected match: $matched" >&2
  echo "---------------------" >&2
  assert_equal "$extracted_name" "john,doe"
  assert_equal "$raw_remainder" "#-report.pdf"
  assert_equal "$cleaned_remainder" "report.pdf"
}

@test "extract_name_from_filename - j0hn-d03-report.pdf" {
  run extract_name_from_filename "j0hn-d03-report.pdf" "john doe" "extract_name_from_filename"
  [ "$status" -eq 0 ]
  IFS='|' read -r extracted_name raw_remainder matched <<< "$output"
  cleaned_remainder=$(clean_filename_remainder "$raw_remainder")
  echo "----- TEST CASE -----" >&2
  echo "Comment: Name with numbers/letter substitution" >&2
  echo "function: extract_name_from_filename" >&2
  echo "filename: j0hn-d03-report.pdf" >&2
  echo "name to match: john doe" >&2
  echo "expected_match: true" >&2
  echo "raw remainder expected: --report.pdf" >&2
  echo "raw remainder matched: $raw_remainder" >&2
  echo "cleaned remainder expected: report.pdf" >&2
  echo "cleaned remainder matched: $cleaned_remainder" >&2
  echo "extracted_name expected: j0hn,d03" >&2
  echo "extracted_name matched: $extracted_name" >&2
  echo "expected match: $matched" >&2
  echo "---------------------" >&2
  assert_equal "$extracted_name" "j0hn,d03"
  assert_equal "$raw_remainder" "--report.pdf"
  assert_equal "$cleaned_remainder" "report.pdf"
}

@test "extract_name_from_filename - jôn-döe-report.pdf" {
  run extract_name_from_filename "jôn-döe-report.pdf" "john doe" "extract_name_from_filename"
  [ "$status" -eq 0 ]
  IFS='|' read -r extracted_name raw_remainder matched <<< "$output"
  cleaned_remainder=$(clean_filename_remainder "$raw_remainder")
  echo "----- TEST CASE -----" >&2
  echo "Comment: Name with accents" >&2
  echo "function: extract_name_from_filename" >&2
  echo "filename: jôn-döe-report.pdf" >&2
  echo "name to match: john doe" >&2
  echo "expected_match: true" >&2
  echo "raw remainder expected: jôn--report.pdf" >&2
  echo "raw remainder matched: $raw_remainder" >&2
  echo "cleaned remainder expected: jôn report.pdf" >&2
  echo "cleaned remainder matched: $cleaned_remainder" >&2
  echo "extracted_name expected: döe" >&2
  echo "extracted_name matched: $extracted_name" >&2
  echo "expected match: $matched" >&2
  echo "---------------------" >&2
  assert_equal "$extracted_name" "döe"
  assert_equal "$raw_remainder" "jôn--report.pdf"
  assert_equal "$cleaned_remainder" "jôn report.pdf"
}

@test "extract_name_from_filename - john-doe-john-doe-report.pdf" {
  run extract_name_from_filename "john-doe-john-doe-report.pdf" "john doe" "extract_name_from_filename"
  [ "$status" -eq 0 ]
  IFS='|' read -r extracted_name raw_remainder matched <<< "$output"
  cleaned_remainder=$(clean_filename_remainder "$raw_remainder")
  echo "----- TEST CASE -----" >&2
  echo "Comment: Multiple matches (same name twice)" >&2
  echo "function: extract_name_from_filename" >&2
  echo "filename: john-doe-john-doe-report.pdf" >&2
  echo "name to match: john doe" >&2
  echo "expected_match: true" >&2
  echo "raw remainder expected: ----report.pdf" >&2
  echo "raw remainder matched: $raw_remainder" >&2
  echo "cleaned remainder expected: report.pdf" >&2
  echo "cleaned remainder matched: $cleaned_remainder" >&2
  echo "extracted_name expected: john,john,doe,doe" >&2
  echo "extracted_name matched: $extracted_name" >&2
  echo "expected match: $matched" >&2
  echo "---------------------" >&2
  assert_equal "$extracted_name" "john,john,doe,doe"
  assert_equal "$raw_remainder" "----report.pdf"
  assert_equal "$cleaned_remainder" "report.pdf"
}

@test "extract_name_from_filename - john-doe-jdoe-report.pdf" {
  run extract_name_from_filename "john-doe-jdoe-report.pdf" "john doe" "extract_name_from_filename"
  [ "$status" -eq 0 ]
  IFS='|' read -r extracted_name raw_remainder matched <<< "$output"
  cleaned_remainder=$(clean_filename_remainder "$raw_remainder")
  echo "----- TEST CASE -----" >&2
  echo "Comment: Multiple matches (full and initials)" >&2
  echo "function: extract_name_from_filename" >&2
  echo "filename: john-doe-jdoe-report.pdf" >&2
  echo "name to match: john doe" >&2
  echo "expected_match: true" >&2
  echo "raw remainder expected: ---report.pdf" >&2
  echo "raw remainder matched: $raw_remainder" >&2
  echo "cleaned remainder expected: report.pdf" >&2
  echo "cleaned remainder matched: $cleaned_remainder" >&2
  echo "extracted_name expected: jdoe,john,doe" >&2
  echo "extracted_name matched: $extracted_name" >&2
  echo "expected match: $matched" >&2
  echo "---------------------" >&2
  assert_equal "$extracted_name" "jdoe,john,doe"
  assert_equal "$raw_remainder" "---report.pdf"
  assert_equal "$cleaned_remainder" "report.pdf"
}

@test "extract_name_from_filename - john-doe-jdoe-report-john.pdf" {
  run extract_name_from_filename "john-doe-jdoe-report-john.pdf" "john doe" "extract_name_from_filename"
  [ "$status" -eq 0 ]
  IFS='|' read -r extracted_name raw_remainder matched <<< "$output"
  cleaned_remainder=$(clean_filename_remainder "$raw_remainder")
  echo "----- TEST CASE -----" >&2
  echo "Comment: Multiple matches (full and initials)" >&2
  echo "function: extract_name_from_filename" >&2
  echo "filename: john-doe-jdoe-report-john.pdf" >&2
  echo "name to match: john doe" >&2
  echo "expected_match: true" >&2
  echo "raw remainder expected: ---report-.pdf" >&2
  echo "raw remainder matched: $raw_remainder" >&2
  echo "cleaned remainder expected: report.pdf" >&2
  echo "cleaned remainder matched: $cleaned_remainder" >&2
  echo "extracted_name expected: jdoe,john,john,doe" >&2
  echo "extracted_name matched: $extracted_name" >&2
  echo "expected match: $matched" >&2
  echo "---------------------" >&2
  assert_equal "$extracted_name" "jdoe,john,john,doe"
  assert_equal "$raw_remainder" "---report-.pdf"
  assert_equal "$cleaned_remainder" "report.pdf"
}

@test "extract_name_from_filename - jdoe-john-doe-report.pdf" {
  run extract_name_from_filename "jdoe-john-doe-report.pdf" "john doe" "extract_name_from_filename"
  [ "$status" -eq 0 ]
  IFS='|' read -r extracted_name raw_remainder matched <<< "$output"
  cleaned_remainder=$(clean_filename_remainder "$raw_remainder")
  echo "----- TEST CASE -----" >&2
  echo "Comment: Multiple matches (initials and full)" >&2
  echo "function: extract_name_from_filename" >&2
  echo "filename: jdoe-john-doe-report.pdf" >&2
  echo "name to match: john doe" >&2
  echo "expected_match: true" >&2
  echo "raw remainder expected: ---report.pdf" >&2
  echo "raw remainder matched: $raw_remainder" >&2
  echo "cleaned remainder expected: report.pdf" >&2
  echo "cleaned remainder matched: $cleaned_remainder" >&2
  echo "extracted_name expected: jdoe,john,doe" >&2
  echo "extracted_name matched: $extracted_name" >&2
  echo "expected match: $matched" >&2
  echo "---------------------" >&2
  assert_equal "$extracted_name" "jdoe,john,doe"
  assert_equal "$raw_remainder" "---report.pdf"
  assert_equal "$cleaned_remainder" "report.pdf"
}

@test "extract_name_from_filename - .pdf" {
  run extract_name_from_filename ".pdf" "john doe" "extract_name_from_filename"
  [ "$status" -eq 0 ]
  IFS='|' read -r extracted_name raw_remainder matched <<< "$output"
  cleaned_remainder=$(clean_filename_remainder "$raw_remainder")
  echo "----- TEST CASE -----" >&2
  echo "Comment: Edge case: empty filename" >&2
  echo "function: extract_name_from_filename" >&2
  echo "filename: .pdf" >&2
  echo "name to match: john doe" >&2
  echo "expected_match: false" >&2
  echo "raw remainder expected: .pdf" >&2
  echo "raw remainder matched: $raw_remainder" >&2
  echo "cleaned remainder expected: .pdf" >&2
  echo "cleaned remainder matched: $cleaned_remainder" >&2
  echo "extracted_name expected: " >&2
  echo "extracted_name matched: $extracted_name" >&2
  echo "expected match: $matched" >&2
  echo "---------------------" >&2
  assert_equal "$extracted_name" ""
  assert_equal "$raw_remainder" ".pdf"
  assert_equal "$cleaned_remainder" ".pdf"
}

@test "extract_name_from_filename - JOHN-DOE-report.pdf" {
  run extract_name_from_filename "JOHN-DOE-report.pdf" "john doe" "extract_name_from_filename"
  [ "$status" -eq 0 ]
  IFS='|' read -r extracted_name raw_remainder matched <<< "$output"
  cleaned_remainder=$(clean_filename_remainder "$raw_remainder")
  echo "----- TEST CASE -----" >&2
  echo "Comment: Case: all uppercase" >&2
  echo "function: extract_name_from_filename" >&2
  echo "filename: JOHN-DOE-report.pdf" >&2
  echo "name to match: john doe" >&2
  echo "expected_match: true" >&2
  echo "raw remainder expected: --report.pdf" >&2
  echo "raw remainder matched: $raw_remainder" >&2
  echo "cleaned remainder expected: report.pdf" >&2
  echo "cleaned remainder matched: $cleaned_remainder" >&2
  echo "extracted_name expected: JOHN,DOE" >&2
  echo "extracted_name matched: $extracted_name" >&2
  echo "expected match: $matched" >&2
  echo "---------------------" >&2
  assert_equal "$extracted_name" "JOHN,DOE"
  assert_equal "$raw_remainder" "--report.pdf"
  assert_equal "$cleaned_remainder" "report.pdf"
}

@test "extract_name_from_filename - John-Doe-report.pdf" {
  run extract_name_from_filename "John-Doe-report.pdf" "john doe" "extract_name_from_filename"
  [ "$status" -eq 0 ]
  IFS='|' read -r extracted_name raw_remainder matched <<< "$output"
  cleaned_remainder=$(clean_filename_remainder "$raw_remainder")
  echo "----- TEST CASE -----" >&2
  echo "Comment: Case: proper case" >&2
  echo "function: extract_name_from_filename" >&2
  echo "filename: John-Doe-report.pdf" >&2
  echo "name to match: john doe" >&2
  echo "expected_match: true" >&2
  echo "raw remainder expected: --report.pdf" >&2
  echo "raw remainder matched: $raw_remainder" >&2
  echo "cleaned remainder expected: report.pdf" >&2
  echo "cleaned remainder matched: $cleaned_remainder" >&2
  echo "extracted_name expected: John,Doe" >&2
  echo "extracted_name matched: $extracted_name" >&2
  echo "expected match: $matched" >&2
  echo "---------------------" >&2
  assert_equal "$extracted_name" "John,Doe"
  assert_equal "$raw_remainder" "--report.pdf"
  assert_equal "$cleaned_remainder" "report.pdf"
}

@test "extract_name_from_filename - john-DOE-report.pdf" {
  run extract_name_from_filename "john-DOE-report.pdf" "john doe" "extract_name_from_filename"
  [ "$status" -eq 0 ]
  IFS='|' read -r extracted_name raw_remainder matched <<< "$output"
  cleaned_remainder=$(clean_filename_remainder "$raw_remainder")
  echo "----- TEST CASE -----" >&2
  echo "Comment: Case: mixed case" >&2
  echo "function: extract_name_from_filename" >&2
  echo "filename: john-DOE-report.pdf" >&2
  echo "name to match: john doe" >&2
  echo "expected_match: true" >&2
  echo "raw remainder expected: --report.pdf" >&2
  echo "raw remainder matched: $raw_remainder" >&2
  echo "cleaned remainder expected: report.pdf" >&2
  echo "cleaned remainder matched: $cleaned_remainder" >&2
  echo "extracted_name expected: john,DOE" >&2
  echo "extracted_name matched: $extracted_name" >&2
  echo "expected match: $matched" >&2
  echo "---------------------" >&2
  assert_equal "$extracted_name" "john,DOE"
  assert_equal "$raw_remainder" "--report.pdf"
  assert_equal "$cleaned_remainder" "report.pdf"
}

@test "extract_name_from_filename - john-doe-report-v1.0-2023.01.01.pdf" {
  run extract_name_from_filename "john-doe-report-v1.0-2023.01.01.pdf" "john doe" "extract_name_from_filename"
  [ "$status" -eq 0 ]
  IFS='|' read -r extracted_name raw_remainder matched <<< "$output"
  cleaned_remainder=$(clean_filename_remainder "$raw_remainder")
  echo "----- TEST CASE -----" >&2
  echo "Comment: Complex version and date" >&2
  echo "function: extract_name_from_filename" >&2
  echo "filename: john-doe-report-v1.0-2023.01.01.pdf" >&2
  echo "name to match: john doe" >&2
  echo "expected_match: true" >&2
  echo "raw remainder expected: --report-v1.0-2023.01.01.pdf" >&2
  echo "raw remainder matched: $raw_remainder" >&2
  echo "cleaned remainder expected: report v1 0 2023 01 01.pdf" >&2
  echo "cleaned remainder matched: $cleaned_remainder" >&2
  echo "extracted_name expected: john,doe" >&2
  echo "extracted_name matched: $extracted_name" >&2
  echo "expected match: $matched" >&2
  echo "---------------------" >&2
  assert_equal "$extracted_name" "john,doe"
  assert_equal "$raw_remainder" "--report-v1.0-2023.01.01.pdf"
  assert_equal "$cleaned_remainder" "report v1 0 2023 01 01.pdf"
}

@test "extract_name_from_filename - j0hn-d03-jôn-döe-report.pdf" {
  run extract_name_from_filename "j0hn-d03-jôn-döe-report.pdf" "john doe" "extract_name_from_filename"
  [ "$status" -eq 0 ]
  IFS='|' read -r extracted_name raw_remainder matched <<< "$output"
  cleaned_remainder=$(clean_filename_remainder "$raw_remainder")
  echo "----- TEST CASE -----" >&2
  echo "Comment: Multiple matches: numbers and accents" >&2
  echo "function: extract_name_from_filename" >&2
  echo "filename: j0hn-d03-jôn-döe-report.pdf" >&2
  echo "name to match: john doe" >&2
  echo "expected_match: true" >&2
  echo "raw remainder expected: --jôn--report.pdf" >&2
  echo "raw remainder matched: $raw_remainder" >&2
  echo "cleaned remainder expected: jôn report.pdf" >&2
  echo "cleaned remainder matched: $cleaned_remainder" >&2
  echo "extracted_name expected: j0hn,d03,döe" >&2
  echo "extracted_name matched: $extracted_name" >&2
  echo "expected match: $matched" >&2
  echo "---------------------" >&2
  assert_equal "$extracted_name" "j0hn,d03,döe"
  assert_equal "$raw_remainder" "--jôn--report.pdf"
  assert_equal "$cleaned_remainder" "jôn report.pdf"
}

@test "extract_name_from_filename - ---.pdf" {
  run extract_name_from_filename "---.pdf" "john doe" "extract_name_from_filename"
  [ "$status" -eq 0 ]
  IFS='|' read -r extracted_name raw_remainder matched <<< "$output"
  cleaned_remainder=$(clean_filename_remainder "$raw_remainder")
  echo "----- TEST CASE -----" >&2
  echo "Comment: Edge case: only separators" >&2
  echo "function: extract_name_from_filename" >&2
  echo "filename: ---.pdf" >&2
  echo "name to match: john doe" >&2
  echo "expected_match: false" >&2
  echo "raw remainder expected: ---.pdf" >&2
  echo "raw remainder matched: $raw_remainder" >&2
  echo "cleaned remainder expected: .pdf" >&2
  echo "cleaned remainder matched: $cleaned_remainder" >&2
  echo "extracted_name expected: " >&2
  echo "extracted_name matched: $extracted_name" >&2
  echo "expected match: $matched" >&2
  echo "---------------------" >&2
  assert_equal "$extracted_name" ""
  assert_equal "$raw_remainder" "---.pdf"
  assert_equal "$cleaned_remainder" ".pdf"
}

@test "extract_name_from_filename - 123456.pdf" {
  run extract_name_from_filename "123456.pdf" "john doe" "extract_name_from_filename"
  [ "$status" -eq 0 ]
  IFS='|' read -r extracted_name raw_remainder matched <<< "$output"
  cleaned_remainder=$(clean_filename_remainder "$raw_remainder")
  echo "----- TEST CASE -----" >&2
  echo "Comment: Edge case: only numbers" >&2
  echo "function: extract_name_from_filename" >&2
  echo "filename: 123456.pdf" >&2
  echo "name to match: john doe" >&2
  echo "expected_match: false" >&2
  echo "raw remainder expected: 123456.pdf" >&2
  echo "raw remainder matched: $raw_remainder" >&2
  echo "cleaned remainder expected: 123456.pdf" >&2
  echo "cleaned remainder matched: $cleaned_remainder" >&2
  echo "extracted_name expected: " >&2
  echo "extracted_name matched: $extracted_name" >&2
  echo "expected match: $matched" >&2
  echo "---------------------" >&2
  assert_equal "$extracted_name" ""
  assert_equal "$raw_remainder" "123456.pdf"
  assert_equal "$cleaned_remainder" "123456.pdf"
}

@test "extract_name_from_filename - !@#$%^&*().pdf" {
  run extract_name_from_filename "!@#$%^&*().pdf" "john doe" "extract_name_from_filename"
  [ "$status" -eq 0 ]
  IFS='|' read -r extracted_name raw_remainder matched <<< "$output"
  cleaned_remainder=$(clean_filename_remainder "$raw_remainder")
  echo "----- TEST CASE -----" >&2
  echo "Comment: Edge case: only special characters" >&2
  echo "function: extract_name_from_filename" >&2
  echo "filename: !@#$%^&*().pdf" >&2
  echo "name to match: john doe" >&2
  echo "expected_match: false" >&2
  echo "raw remainder expected: !@#$%^&*().pdf" >&2
  echo "raw remainder matched: $raw_remainder" >&2
  echo "cleaned remainder expected: ! ^ ().pdf" >&2
  echo "cleaned remainder matched: $cleaned_remainder" >&2
  echo "extracted_name expected: " >&2
  echo "extracted_name matched: $extracted_name" >&2
  echo "expected match: $matched" >&2
  echo "---------------------" >&2
  assert_equal "$extracted_name" ""
  assert_equal "$raw_remainder" "!@#$%^&*().pdf"
  assert_equal "$cleaned_remainder" "! ^ ().pdf"
}

@test "extract_name_from_filename - john   doe   report.pdf" {
  run extract_name_from_filename "john   doe   report.pdf" "john doe" "extract_name_from_filename"
  [ "$status" -eq 0 ]
  IFS='|' read -r extracted_name raw_remainder matched <<< "$output"
  cleaned_remainder=$(clean_filename_remainder "$raw_remainder")
  echo "----- TEST CASE -----" >&2
  echo "Comment: Multiple consecutive spaces" >&2
  echo "function: extract_name_from_filename" >&2
  echo "filename: john   doe   report.pdf" >&2
  echo "name to match: john doe" >&2
  echo "expected_match: true" >&2
  echo "raw remainder expected:       report.pdf" >&2
  echo "raw remainder matched: $raw_remainder" >&2
  echo "cleaned remainder expected: report.pdf" >&2
  echo "cleaned remainder matched: $cleaned_remainder" >&2
  echo "extracted_name expected: john,doe" >&2
  echo "extracted_name matched: $extracted_name" >&2
  echo "expected match: $matched" >&2
  echo "---------------------" >&2
  assert_equal "$extracted_name" "john,doe"
  assert_equal "$raw_remainder" "      report.pdf"
  assert_equal "$cleaned_remainder" "report.pdf"
}

@test "extract_name_from_filename - john--doe__report.pdf" {
  run extract_name_from_filename "john--doe__report.pdf" "john doe" "extract_name_from_filename"
  [ "$status" -eq 0 ]
  IFS='|' read -r extracted_name raw_remainder matched <<< "$output"
  cleaned_remainder=$(clean_filename_remainder "$raw_remainder")
  echo "----- TEST CASE -----" >&2
  echo "Comment: Mixed consecutive separators" >&2
  echo "function: extract_name_from_filename" >&2
  echo "filename: john--doe__report.pdf" >&2
  echo "name to match: john doe" >&2
  echo "expected_match: true" >&2
  echo "raw remainder expected: --__report.pdf" >&2
  echo "raw remainder matched: $raw_remainder" >&2
  echo "cleaned remainder expected: report.pdf" >&2
  echo "cleaned remainder matched: $cleaned_remainder" >&2
  echo "extracted_name expected: john,doe" >&2
  echo "extracted_name matched: $extracted_name" >&2
  echo "expected match: $matched" >&2
  echo "---------------------" >&2
  assert_equal "$extracted_name" "john,doe"
  assert_equal "$raw_remainder" "--__report.pdf"
  assert_equal "$cleaned_remainder" "report.pdf"
}

@test "extract_name_from_filename - john . doe - report.pdf" {
  run extract_name_from_filename "john . doe - report.pdf" "john doe" "extract_name_from_filename"
  [ "$status" -eq 0 ]
  IFS='|' read -r extracted_name raw_remainder matched <<< "$output"
  cleaned_remainder=$(clean_filename_remainder "$raw_remainder")
  echo "----- TEST CASE -----" >&2
  echo "Comment: Mixed separators with spaces and punctuation" >&2
  echo "function: extract_name_from_filename" >&2
  echo "filename: john . doe - report.pdf" >&2
  echo "name to match: john doe" >&2
  echo "expected_match: true" >&2
  echo "raw remainder expected:  .  - report.pdf" >&2
  echo "raw remainder matched: $raw_remainder" >&2
  echo "cleaned remainder expected: report.pdf" >&2
  echo "cleaned remainder matched: $cleaned_remainder" >&2
  echo "extracted_name expected: john,doe" >&2
  echo "extracted_name matched: $extracted_name" >&2
  echo "expected match: $matched" >&2
  echo "---------------------" >&2
  assert_equal "$extracted_name" "john,doe"
  assert_equal "$raw_remainder" " .  - report.pdf"
  assert_equal "$cleaned_remainder" "report.pdf"
}

@test "extract_name_from_filename -  john doe report.pdf" {
  run extract_name_from_filename " john doe report.pdf" "john doe" "extract_name_from_filename"
  [ "$status" -eq 0 ]
  IFS='|' read -r extracted_name raw_remainder matched <<< "$output"
  cleaned_remainder=$(clean_filename_remainder "$raw_remainder")
  echo "----- TEST CASE -----" >&2
  echo "Comment: Leading space" >&2
  echo "function: extract_name_from_filename" >&2
  echo "filename:  john doe report.pdf" >&2
  echo "name to match: john doe" >&2
  echo "expected_match: true" >&2
  echo "raw remainder expected:    report.pdf" >&2
  echo "raw remainder matched: $raw_remainder" >&2
  echo "cleaned remainder expected: report.pdf" >&2
  echo "cleaned remainder matched: $cleaned_remainder" >&2
  echo "extracted_name expected: john,doe" >&2
  echo "extracted_name matched: $extracted_name" >&2
  echo "expected match: $matched" >&2
  echo "---------------------" >&2
  assert_equal "$extracted_name" "john,doe"
  assert_equal "$raw_remainder" "   report.pdf"
  assert_equal "$cleaned_remainder" "report.pdf"
}

@test "extract_name_from_filename - john doe report .pdf" {
  run extract_name_from_filename "john doe report .pdf" "john doe" "extract_name_from_filename"
  [ "$status" -eq 0 ]
  IFS='|' read -r extracted_name raw_remainder matched <<< "$output"
  cleaned_remainder=$(clean_filename_remainder "$raw_remainder")
  echo "----- TEST CASE -----" >&2
  echo "Comment: Trailing space before extension" >&2
  echo "function: extract_name_from_filename" >&2
  echo "filename: john doe report .pdf" >&2
  echo "name to match: john doe" >&2
  echo "expected_match: true" >&2
  echo "raw remainder expected:   report .pdf" >&2
  echo "raw remainder matched: $raw_remainder" >&2
  echo "cleaned remainder expected: report.pdf" >&2
  echo "cleaned remainder matched: $cleaned_remainder" >&2
  echo "extracted_name expected: john,doe" >&2
  echo "extracted_name matched: $extracted_name" >&2
  echo "expected match: $matched" >&2
  echo "---------------------" >&2
  assert_equal "$extracted_name" "john,doe"
  assert_equal "$raw_remainder" "  report .pdf"
  assert_equal "$cleaned_remainder" "report.pdf"
}

@test "extract_name_from_filename - john-doe_report report.pdf" {
  run extract_name_from_filename "john-doe_report report.pdf" "john doe" "extract_name_from_filename"
  [ "$status" -eq 0 ]
  IFS='|' read -r extracted_name raw_remainder matched <<< "$output"
  cleaned_remainder=$(clean_filename_remainder "$raw_remainder")
  echo "----- TEST CASE -----" >&2
  echo "Comment: Mixed separators (hyphen, underscore, space)" >&2
  echo "function: extract_name_from_filename" >&2
  echo "filename: john-doe_report report.pdf" >&2
  echo "name to match: john doe" >&2
  echo "expected_match: true" >&2
  echo "raw remainder expected: -_report report.pdf" >&2
  echo "raw remainder matched: $raw_remainder" >&2
  echo "cleaned remainder expected: report report.pdf" >&2
  echo "cleaned remainder matched: $cleaned_remainder" >&2
  echo "extracted_name expected: john,doe" >&2
  echo "extracted_name matched: $extracted_name" >&2
  echo "expected match: $matched" >&2
  echo "---------------------" >&2
  assert_equal "$extracted_name" "john,doe"
  assert_equal "$raw_remainder" "-_report report.pdf"
  assert_equal "$cleaned_remainder" "report report.pdf"
}
