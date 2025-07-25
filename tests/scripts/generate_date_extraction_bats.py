#!/usr/bin/env python3
"""
Generate BATS tests for date extraction from the matrix.
"""
import csv
from pathlib import Path

bats_file = Path(__file__).parent.parent / 'unit' / '01_date_extraction_matrix_tests.bats'
matrix_file = Path(__file__).parent.parent / 'fixtures' / '01_date_extraction_cases.csv'

with open(matrix_file, newline='') as csvfile:
    reader = csv.DictReader(csvfile, delimiter='|')
    tests = []
    for i, row in enumerate(reader):
        test_name = f"{row['matcher_function']} - {row['filename']}"
        bats_test = f"""
@test "{test_name}" {{
  run {row['matcher_function']} "{row['filename']}" "{row['date_to_match']}"
  [ "$status" -eq 0 ]
  IFS='|' read -r extracted_date raw_remainder matched <<< "$output"
  cleaned_remainder=$(clean_date_filename_remainder "$raw_remainder")
  echo "[DEBUG] Testing: {row['filename']}" >&2
  echo "[DEBUG] Matcher function: {row['matcher_function']}" >&2
  echo "[DEBUG] Expected extracted_date: {row['extracted_date']}" >&2
  echo "[DEBUG] Expected raw_remainder: {row['raw_remainder']}" >&2
  echo "[DEBUG] Expected cleaned_remainder: {row['cleaned_remainder']}" >&2
  echo "[DEBUG] Actual extracted_date: $extracted_date" >&2
  echo "[DEBUG] Actual raw_remainder: $raw_remainder" >&2
  echo "[DEBUG] Actual cleaned_remainder: $cleaned_remainder" >&2
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

# Auto-generated BATS tests for date extraction
source "${BATS_TEST_DIRNAME}/../../core/utils/date_utils.sh"

""")
    for t in tests:
        f.write(t) 