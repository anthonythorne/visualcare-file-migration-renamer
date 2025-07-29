#!/usr/bin/env python3
"""
Generate BATS tests for category extraction from folder/file paths.

Note: For full debug output, use `bats --verbose-run ...` (not --verbose) with your BATS version.
"""
import csv
from pathlib import Path

bats_file = Path(__file__).parent.parent / 'unit' / '04_category_extraction_and_mapping_matrix_tests.bats'
matrix_file = Path(__file__).parent.parent / 'fixtures' / '04_category_extraction_and_mapping_cases.csv'

bats_file.parent.mkdir(parents=True, exist_ok=True)

with open(matrix_file, newline='') as csvfile:
    reader = csv.DictReader(csvfile, delimiter='|')
    tests = []
    for i, row in enumerate(reader):
        test_name = f"{row['matcher_function']} - {row['input_path']}"
        if row['expected_match'].strip().lower() == 'false':
            # For no-match cases, call the category processor to get proper remainder
            bats_test = f"""
@test \"{test_name}\" {{
  run {row['matcher_function']} \"{row['input_path']}\"
  [ "$status" -eq 0 ]
  IFS='|' read -r extracted_category raw_category cleaned_category raw_remainder cleaned_remainder error_status <<< "$output"
  echo \"----- TEST CASE -----\" >&2
  echo \"Comment: {row['description']}\" >&2
  echo \"function: {row['matcher_function']}\" >&2
  echo \"input_path: {row['input_path']}\" >&2
  echo \"input_category: {row['input_category']}\" >&2
  echo \"expected_match: {row['expected_match']}\" >&2
  echo \"raw remainder expected: {row['raw_remainder']}\" >&2
  echo \"raw remainder matched: $raw_remainder\" >&2
  echo \"cleaned remainder expected: {row['cleaned_remainder']}\" >&2
  echo \"cleaned remainder matched: $cleaned_remainder\" >&2
  echo \"extracted_category expected: {row['expected_category_name']}\" >&2
  echo \"extracted_category matched: $extracted_category\" >&2
  echo \"expected match: false\" >&2
  echo \"---------------------\" >&2
  assert_equal "$extracted_category" ""
  assert_equal "$raw_category" "{row['input_category']}"
  assert_equal "$cleaned_category" ""
  assert_equal "$raw_remainder" "{row['raw_remainder']}"
  assert_equal "$cleaned_remainder" "{row['cleaned_remainder']}"
  assert_equal "$error_status" "{row['error_status']}"
}}
"""
        else:
            bats_test = f"""
@test \"{test_name}\" {{
  run {row['matcher_function']} \"{row['input_path']}\"
  [ "$status" -eq 0 ]
  IFS='|' read -r extracted_category raw_category cleaned_category raw_remainder cleaned_remainder error_status <<< "$output"
  cleaned_remainder=$(python3 $BATS_TEST_DIRNAME/../../core/utils/name_matcher.py --clean-filename "$raw_remainder")
  echo \"----- TEST CASE -----\" >&2
  echo \"Comment: {row['description']}\" >&2
  echo \"function: {row['matcher_function']}\" >&2
  echo \"input_path: {row['input_path']}\" >&2
  echo \"input_category: {row['input_category']}\" >&2
  echo \"expected_match: {row['expected_match']}\" >&2
  echo \"expected_category_name: {row['expected_category_name']}\" >&2
  echo \"expected_category_id: {row['expected_category_id']}\" >&2
  echo \"raw_category expected: {row['raw_category']}\" >&2
  echo \"raw_category matched: $raw_category\" >&2
  echo \"cleaned_category expected: {row['cleaned_category']}\" >&2
  echo \"cleaned_category matched: $cleaned_category\" >&2
  echo \"raw_remainder expected: {row['raw_remainder']}\" >&2
  echo \"raw_remainder matched: $raw_remainder\" >&2
  echo \"cleaned_remainder expected: {row['cleaned_remainder']}\" >&2
  echo \"cleaned_remainder matched: $cleaned_remainder\" >&2
  echo \"error_status expected: {row['error_status']}\" >&2
  echo \"error_status matched: $error_status\" >&2
  echo \"extracted_category expected: {row['expected_category_name']}\" >&2
  echo \"extracted_category matched: $extracted_category\" >&2
  echo \"expected match: {row['expected_match']}\" >&2
  echo \"---------------------\" >&2
  assert_equal "$extracted_category" "{row['expected_category_name']}"
  assert_equal "$raw_category" "{row['raw_category']}"
  assert_equal "$cleaned_category" "{row['cleaned_category']}"
  assert_equal "$raw_remainder" "{row['raw_remainder']}"
  assert_equal "$cleaned_remainder" "{row['cleaned_remainder']}"
  assert_equal "$error_status" "{row['error_status']}"
}}
"""
        tests.append(bats_test)

with open(bats_file, 'w') as f:
    f.write("""#!/usr/bin/env bats

load "${BATS_TEST_DIRNAME}/../test-helper/bats-support/load.bash"
load "${BATS_TEST_DIRNAME}/../test-helper/bats-assert/load.bash"
load "${BATS_TEST_DIRNAME}/../test-helper/bats-file/load.bash"

# Auto-generated BATS tests for category extraction and mapping from path
source "${BATS_TEST_DIRNAME}/../utils/category_utils.sh"

""")
    for t in tests:
        f.write(t) 