#!/usr/bin/env python3
"""
Generate BATS tests for name extraction from the matrix.

Note: For full debug output, use `bats --verbose-run ...` (not --verbose) with your BATS version.
"""
import csv
from pathlib import Path

bats_file = Path(__file__).parent.parent / 'unit' / '00_name_extraction_matrix_tests.bats'
matrix_file = Path(__file__).parent.parent / 'fixtures' / '00_name_extraction_cases.csv'

with open(matrix_file, newline='') as csvfile:
    reader = csv.DictReader(csvfile, delimiter='|')
    tests = []
    for i, row in enumerate(reader):
        test_name = f"{row['matcher_function']} - {row['filename']}"
        bats_test = f"""
@test "{test_name}" {{
  run extract_name_from_filename "{row['filename']}" "{row['name_to_match']}" "{row['matcher_function']}"
  [ "$status" -eq 0 ]
  IFS='|' read -r extracted_name raw_remainder matched <<< "$output"
  cleaned_remainder=$(clean_filename_remainder "$raw_remainder")
  echo "----- TEST CASE -----" >&2
  echo "Comment: {row['use_case']}" >&2
  echo "function: {row['matcher_function']}" >&2
  echo "filename: {row['filename']}" >&2
  echo "name to match: {row['name_to_match']}" >&2
  echo "expected_match: {row['expected_match']}" >&2
  echo "raw remainder expected: {row['raw_remainder']}" >&2
  echo "raw remainder matched: $raw_remainder" >&2
  echo "cleaned remainder expected: {row['cleaned_remainder']}" >&2
  echo "cleaned remainder matched: $cleaned_remainder" >&2
  echo "extracted_name expected: {row['extracted_name']}" >&2
  echo "extracted_name matched: $extracted_name" >&2
  echo "expected match: $matched" >&2
  echo "---------------------" >&2
  assert_equal "$extracted_name" "{row['extracted_name']}"
  assert_equal "$raw_remainder" "{row['raw_remainder']}"
  assert_equal "$cleaned_remainder" "{row['cleaned_remainder']}"
}}
"""
        tests.append(bats_test)

with open(bats_file, 'w') as f:
    f.write("""#!/usr/bin/env bats

load "${BATS_TEST_DIRNAME}/../test-helper/bats-support/load.bash"
load "${BATS_TEST_DIRNAME}/../test-helper/bats-assert/load.bash"
load "${BATS_TEST_DIRNAME}/../test-helper/bats-file/load.bash"

# Auto-generated BATS tests for name extraction
source "${BATS_TEST_DIRNAME}/../../core/utils/name_utils.sh"

# Define a single shell function to call the Python matcher with the matcher_function as the third argument
extract_name_from_filename() {
  local filename="$1"
  local name_to_match="$2"
  local matcher_function="${3:-extract_name_from_filename}"
  python3 "${BATS_TEST_DIRNAME}/../../core/utils/name_matcher.py" "$filename" "$name_to_match" "$matcher_function"
}

""")
    for t in tests:
        f.write(t) 