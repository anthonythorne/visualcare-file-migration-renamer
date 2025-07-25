#!/usr/bin/env python3
"""
Generate BATS tests for name extraction from folder/file paths.

Note: For full debug output, use `bats --verbose-run ...` (not --verbose) with your BATS version.
"""
import csv
from pathlib import Path

bats_file = Path(__file__).parent.parent / 'unit' / '02_name_extraction_from_path_matrix_tests.bats'
matrix_file = Path(__file__).parent.parent / 'fixtures' / '02_name_extraction_from_path_cases.csv'

bats_file.parent.mkdir(parents=True, exist_ok=True)

with open(matrix_file, newline='') as csvfile:
    reader = csv.DictReader(csvfile, delimiter='|')
    tests = []
    for i, row in enumerate(reader):
        test_name = f"{row['matcher_function']} - {row['full_path']}"
        if row['expected_match'].strip().lower() == 'false':
            # For no-match cases, just check cleaned remainder
            bats_test = f"""
@test "{test_name}" {{
  cleaned_remainder=$(clean_filename_remainder "{row['full_path']}")
  echo "----- TEST CASE -----" >&2
  echo "Comment: {row['use_case']}" >&2
  echo "function: {row['matcher_function']}" >&2
  echo "full_path: {row['full_path']}" >&2
  echo "name to match: {row['name_to_match']}" >&2
  echo "expected_match: {row['expected_match']}" >&2
  echo "raw remainder expected: {row['raw_remainder']}" >&2
  echo "raw remainder matched: {row['raw_remainder']}" >&2
  echo "cleaned remainder expected: {row['cleaned_remainder']}" >&2
  echo "cleaned remainder matched: $cleaned_remainder" >&2
  echo "extracted_name expected: {row['extracted_name']}" >&2
  echo "extracted_name matched: " >&2
  echo "expected match: false" >&2
  echo "---------------------" >&2
  assert_equal "$cleaned_remainder" "{row['cleaned_remainder']}"
}}
"""
        else:
            bats_test = f"""
@test "{test_name}" {{
  run {row['matcher_function']} "{row['full_path']}" "{row['name_to_match']}"
  [ "$status" -eq 0 ]
  IFS='|' read -r extracted_name raw_remainder matched <<< "$output"
  cleaned_remainder=$(clean_filename_remainder "$raw_remainder")
  echo "----- TEST CASE -----" >&2
  echo "Comment: {row['use_case']}" >&2
  echo "function: {row['matcher_function']}" >&2
  echo "full_path: {row['full_path']}" >&2
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

# Auto-generated BATS tests for name extraction from path
source "${BATS_TEST_DIRNAME}/../../core/utils/name_utils.sh"

""")
    for t in tests:
        f.write(t) 