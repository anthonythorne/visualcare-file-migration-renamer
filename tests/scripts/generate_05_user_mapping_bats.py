#!/usr/bin/env python3
"""
Generate BATS tests for user name mapping (ID <-> name) from the matrix.
"""
import csv
from pathlib import Path

bats_file = Path(__file__).parent.parent / 'unit' / '05_user_mapping_matrix_tests.bats'
matrix_file = Path(__file__).parent.parent / 'fixtures' / '05_user_mapping_cases.csv'

bats_file.parent.mkdir(parents=True, exist_ok=True)

with open(matrix_file, newline='') as csvfile:
    reader = csv.DictReader(csvfile, delimiter='|')
    tests = []
    for i, row in enumerate(reader):
        test_name = f"{row['matcher_function']} - {row['input_name']}"
        bats_test = f"""
@test "{test_name}" {{
  run {row['matcher_function']} "{row['input_name']}"
  [ "$status" -eq 0 ]
  IFS='|' read -r user_id full_name raw_name cleaned_name <<< "$output"
  echo "----- TEST CASE -----" >&2
  echo "Comment: {row['description']}" >&2
  echo "function: {row['matcher_function']}" >&2
  echo "input_name: {row['input_name']}" >&2
  echo "expected_user_id: {row['expected_user_id']}" >&2
  echo "expected_full_name: {row['expected_full_name']}" >&2
  echo "raw_name expected: {row['raw_name']}" >&2
  echo "raw_name matched: $raw_name" >&2
  echo "cleaned_name expected: {row['cleaned_name']}" >&2
  echo "cleaned_name matched: $cleaned_name" >&2
  echo "user_id expected: {row['expected_user_id']}" >&2
  echo "user_id matched: $user_id" >&2
  echo "full_name expected: {row['expected_full_name']}" >&2
  echo "full_name matched: $full_name" >&2
  echo "---------------------" >&2
  assert_equal "$user_id" "{row['expected_user_id']}"
  assert_equal "$full_name" "{row['expected_full_name']}"
  assert_equal "$raw_name" "{row['raw_name']}"
  assert_equal "$cleaned_name" "{row['cleaned_name']}"
}}
"""
        tests.append(bats_test)

with open(bats_file, 'w') as f:
    f.write("""#!/usr/bin/env bats

load "${BATS_TEST_DIRNAME}/../test-helper/bats-support/load.bash"
load "${BATS_TEST_DIRNAME}/../test-helper/bats-assert/load.bash"
load "${BATS_TEST_DIRNAME}/../test-helper/bats-file/load.bash"

# Auto-generated BATS tests for user name mapping
source "${BATS_TEST_DIRNAME}/../../core/utils/user_mapping.sh"

""")
    for t in tests:
        f.write(t) 