#!/usr/bin/env bats

load '../test_helper.bash'

setup() {
  source '../../../core/utils/name_utils.sh'
}

@test "table-driven name extraction cases" {
  local csv="$(dirname "$BATS_TEST_FILENAME")/../fixtures/name_extraction_cases.csv"
  local IFS=','
  local line_num=0
  while read -r filename name_to_match expected_match extracted_name raw_remainder cleaned_remainder; do
    ((line_num++))
    # Skip header, comments, and blank lines
    if [[ $line_num -eq 1 ]] || [[ "$filename" =~ ^[[:space:]]*# ]] || [[ -z "$filename" ]]; then continue; fi
    # Remove possible carriage returns
    filename="${filename//$'\r'/}"
    name_to_match="${name_to_match//$'\r'/}"
    expected_match="${expected_match//$'\r'/}"
    extracted_name="${extracted_name//$'\r'/}"
    raw_remainder="${raw_remainder//$'\r'/}"
    cleaned_remainder="${cleaned_remainder//$'\r'/}"

    run extract_name_and_remainder "$filename" "$name_to_match"
    if [[ "$expected_match" == "true" ]]; then
      assert_success
      # Output should be three lines: extracted_name, raw_remainder, cleaned_remainder
      IFS=$'\n' read -r out_name out_raw out_clean <<< "$output"
      [ "$out_name" = "$extracted_name" ] || { echo "Extracted name mismatch: got '$out_name', expected '$extracted_name' for $filename"; false; }
      [ "$out_raw" = "$raw_remainder" ] || { echo "Raw remainder mismatch: got '$out_raw', expected '$raw_remainder' for $filename"; false; }
      [ "$out_clean" = "$cleaned_remainder" ] || { echo "Cleaned remainder mismatch: got '$out_clean', expected '$cleaned_remainder' for $filename"; false; }
    else
      assert_failure
      # Output should be empty or just the cleaned remainder (original filename)
      [ "$output" = "$cleaned_remainder" ] || { echo "Expected cleaned remainder '$cleaned_remainder', got '$output' for $filename"; false; }
    fi
  done < "$csv"
} 