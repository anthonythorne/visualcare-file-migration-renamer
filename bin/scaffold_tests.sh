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

# Load main test helper (loads all BATS helpers)
load "${BATS_TEST_DIRNAME}/../test_helper.bash"

# Source the function to test
source "${BATS_TEST_DIRNAME}/../../core/utils/name_utils.sh"
EOF

i=0
# Read the CSV, skip the header
while IFS='|' read -r filename name_to_match expected_match extracted_name raw_remainder cleaned_remainder use_case; do
  # Skip header
  if [ $i -eq 0 ]; then i=1; continue; fi
  # Sanitize test name (remove spaces and special chars)
  safe_test_name=$(echo "$use_case" | tr -cd '[:alnum:]_-' | tr ' ' '_')
  cat >> "$TEMP_FILE" << EOF

@test "$safe_test_name" {
  run extract_name_from_filename "$filename" "$name_to_match"
  IFS='|' read -r actual_extracted_name actual_raw_remainder actual_matched <<< "\$output"
  # Debug output
  echo "[DEBUG] Testing: $filename" >&2
  echo "[DEBUG] Expected match: $expected_match" >&2
  echo "[DEBUG] Expected extracted name: $extracted_name" >&2
  echo "[DEBUG] Expected raw remainder: $raw_remainder" >&2
  echo "[DEBUG] Expected cleaned remainder: $cleaned_remainder" >&2
  echo "[DEBUG] Use case: $use_case" >&2
  echo "[DEBUG] Actual output: \$output" >&2
  if [ "$expected_match" = "true" ]; then
    assert_equal "\$actual_matched" "true"
    assert_equal "\$actual_extracted_name" "$extracted_name"
    assert_equal "\$actual_raw_remainder" "$raw_remainder"
  else
    assert_equal "\$actual_matched" "false"
    assert_equal "\$actual_extracted_name" ""
    assert_equal "\$actual_raw_remainder" "$raw_remainder"
  fi
}
EOF
done < "$CSV_FILE"

# Replace the test file with the new content
mv "$TEMP_FILE" "$TEST_FILE"

# Make the test file executable
chmod +x "$TEST_FILE"

echo "Test file has been updated: $TEST_FILE" 