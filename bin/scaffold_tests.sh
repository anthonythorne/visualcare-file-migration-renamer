#!/bin/bash

# Script to scaffold tests from name_extraction_cases.csv
# Usage: ./bin/scaffold_tests.sh

set -e

# Path to the CSV file
CSV_FILE="$(dirname "$0")/../tests/fixtures/name_extraction_cases.csv"

# Path to the test file
TEST_FILE="$(dirname "$0")/../tests/unit/name_utils_table_test.bats"

# Create a temporary file for the new test content
TEMP_FILE=$(mktemp)

# Write the test file header
cat > "$TEMP_FILE" << 'EOF'
#!/usr/bin/env bats

# Load test helper functions
load "${BATS_TEST_DIRNAME}/../test_helper/bats-assert/load.bash"
load "${BATS_TEST_DIRNAME}/../test_helper/bats-file/load.bash"

# Source the function to test
source "${BATS_TEST_DIRNAME}/../../core/utils/name_utils.sh"

# Table-driven tests for name extraction
@test "name extraction from filename" {
  local csv="${BATS_TEST_DIRNAME}/../fixtures/name_extraction_cases.csv"
  
  # Skip header row
  tail -n +2 "$csv" | while IFS=, read -r filename name_to_match expected_match extracted_name raw_remainder cleaned_remainder use_case; do
    # Run the function
    run extract_name_from_filename "$filename" "$name_to_match"
    
    # Debug output
    echo "[DEBUG] Testing: $filename" >&2
    echo "[DEBUG] Expected match: $expected_match" >&2
    echo "[DEBUG] Expected extracted name: $extracted_name" >&2
    echo "[DEBUG] Expected raw remainder: $raw_remainder" >&2
    echo "[DEBUG] Expected cleaned remainder: $cleaned_remainder" >&2
    echo "[DEBUG] Use case: $use_case" >&2
    echo "[DEBUG] Actual output: $output" >&2
    
    # Split the output into components
    IFS='|' read -r actual_extracted_name actual_raw_remainder actual_cleaned_remainder actual_matched <<< "$output"
    
    # Assertions
    if [ "$expected_match" = "true" ]; then
      assert_equal "$actual_matched" "true"
      assert_equal "$actual_extracted_name" "$extracted_name"
      assert_equal "$actual_raw_remainder" "$raw_remainder"
      assert_equal "$actual_cleaned_remainder" "$cleaned_remainder"
    else
      assert_equal "$actual_matched" "false"
      assert_equal "$actual_extracted_name" ""
      assert_equal "$actual_raw_remainder" "$raw_remainder"
      assert_equal "$actual_cleaned_remainder" "$cleaned_remainder"
    fi
  done
}
EOF

# Replace the test file with the new content
mv "$TEMP_FILE" "$TEST_FILE"

# Make the test file executable
chmod +x "$TEST_FILE"

echo "Test file has been updated: $TEST_FILE" 