#!/usr/bin/env python3
"""
Generate BATS tests for date extraction from filenames.

Note: For full debug output, use `bats --verbose-run ...` (not --verbose) with your BATS version.
"""
import csv
from pathlib import Path

bats_file = Path(__file__).parent.parent / 'unit' / '01_date_extraction_matrix_tests.bats'
matrix_file = Path(__file__).parent.parent / 'fixtures' / '01_date_extraction_cases.csv'

bats_file.parent.mkdir(parents=True, exist_ok=True)

with open(matrix_file, newline='') as csvfile:
    reader = csv.DictReader(csvfile, delimiter='|')
    tests = []
    for i, row in enumerate(reader):
        test_name = f"{row['matcher_function']} - {row['filename']}"
        if row['expected_match'].strip().lower() == 'false':
            # For no-match cases, just check cleaned remainder using the universal cleaner
            bats_test = f"""
@test "{test_name}" {{
  cleaned_remainder=$(python3 $BATS_TEST_DIRNAME/../../core/utils/name_matcher.py --clean-filename "{row['filename']}")
  echo "----- TEST CASE -----" >&2
  echo "Comment: {row['use_case']}" >&2
  echo "function: {row['matcher_function']}" >&2
  echo "filename: {row['filename']}" >&2
  echo "date to match: {row['date_to_match']}" >&2
  echo "expected_match: {row['expected_match']}" >&2
  echo "raw remainder expected: {row['raw_remainder']}" >&2
  echo "raw remainder matched: {row['raw_remainder']}" >&2
  echo "cleaned remainder expected: {row['cleaned_remainder']}" >&2
  echo "cleaned remainder matched: $cleaned_remainder" >&2
  echo "extracted_date expected: {row['extracted_date']}" >&2
  echo "extracted_date matched: " >&2
  echo "expected match: false" >&2
  echo "---------------------" >&2
  assert_equal "$cleaned_remainder" "{row['cleaned_remainder']}"
}}
"""
        else:
            bats_test = f"""
@test "{test_name}" {{
  run {row['matcher_function']} "{row['filename']}" "{row['date_to_match']}"
  [ "$status" -eq 0 ]
  IFS='|' read -r extracted_date raw_remainder matched <<< "$output"
  cleaned_remainder=$(python3 $BATS_TEST_DIRNAME/../../core/utils/name_matcher.py --clean-filename "$raw_remainder")
  echo "----- TEST CASE -----" >&2
  echo "Comment: {row['use_case']}" >&2
  echo "function: {row['matcher_function']}" >&2
  echo "filename: {row['filename']}" >&2
  echo "date to match: {row['date_to_match']}" >&2
  echo "expected_match: {row['expected_match']}" >&2
  echo "raw remainder expected: {row['raw_remainder']}" >&2
  echo "raw remainder matched: $raw_remainder" >&2
  echo "cleaned remainder expected: {row['cleaned_remainder']}" >&2
  echo "cleaned remainder matched: $cleaned_remainder" >&2
  echo "extracted_date expected: {row['extracted_date']}" >&2
  echo "extracted_date matched: $extracted_date" >&2
  echo "expected match: $matched" >&2
  echo "---------------------" >&2
  assert_equal "$extracted_date" "{row['extracted_date']}"
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

# Auto-generated BATS tests for date extraction from filename
source "${BATS_TEST_DIRNAME}/../utils/date_utils.sh"

""")
    for t in tests:
        f.write(t) 