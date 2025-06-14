#!/usr/bin/env bats

load '../test_helper.bash'

setup() {
  source '../../../core/utils/name_utils.sh'
}

@test "table-driven name extraction cases" {
  local csv="$(dirname "$BATS_TEST_FILENAME")/../fixtures/name_extraction_cases.csv"
  local IFS=','
  local line_num=0
  while read -r filename expected_match expected_remainder name_to_match; do
    ((line_num++))
    # Skip header
    if [[ $line_num -eq 1 ]]; then continue; fi
    # Remove possible carriage returns
    filename="${filename//$'\r'/}"
    expected_match="${expected_match//$'\r'/}"
    expected_remainder="${expected_remainder//$'\r'/}"
    name_to_match="${name_to_match//$'\r'/}"
    run extract_name_and_remainder "$filename" "$name_to_match"
    if [[ -n "$expected_match" ]]; then
      assert_success
      assert_output --partial "$expected_match"
      assert_output --partial "$expected_remainder"
    else
      # If no match expected, function should fail
      assert_failure
      [[ "$output" == "" ]] || false
    fi
  done < "$csv"
} 