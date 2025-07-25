#!/usr/bin/env python3
"""
Scaffold BATS output validation tests from test matrices.

For each test matrix CSV, generate a BATS test file that asserts each expected output file exists in the correct directory.
"""
import csv
from pathlib import Path

def generate_bats_for_matrix(matrix_csv, test_name, output_bats):
    bats_lines = [
        f"# Auto-generated BATS output validation for {test_name}",
        f"# Source: {matrix_csv}",
        "",
        "setup() {",
        "  PROJECT_ROOT=\"$(cd -- \"$(dirname -- \"${BATS_TEST_FILENAME:-${BASH_SOURCE[0]}}\")/../..\" && pwd)\"",
        "}",
        ""
    ]
    with open(matrix_csv, 'r') as f:
        reader = csv.DictReader(f)
        for idx, row in enumerate(reader, 1):
            person = row.get('person_name') or row.get('person')
            expected_filename = row.get('expected_filename')
            if not person or not expected_filename:
                continue
            # Skip dynamic date test cases (e.g., Temp Person)
            if 'test_file' in expected_filename:
                bats_lines.append(f"# Skipped row {idx}: {person} - {expected_filename} (dynamic date or special case)")
                continue
            bats_lines.append(f"@test \"{test_name} row {idx}: {person} - {expected_filename}\" {{")
            bats_lines.append(f"  local file=\"$PROJECT_ROOT/tests/test-files/to-{test_name}/{person}/{expected_filename}\"")
            bats_lines.append(f"  echo Checking: $file")
            bats_lines.append(f"  [ -f \"$file\" ]")
            bats_lines.append("}")
            bats_lines.append("")
    with open(output_bats, 'w') as f:
        f.write('\n'.join(bats_lines))
    print(f"Generated: {output_bats}")

def main():
    # List of (matrix_csv, test_name, output_bats)
    configs = [
        ("tests/fixtures/multi_level_directory_cases.csv", "multi-level", "tests/unit/output_validation_multi_level.bats"),
        ("tests/fixtures/category_test_cases.csv", "category", "tests/unit/output_validation_category.bats"),
        ("tests/fixtures/basic_test_cases.csv", "basic", "tests/unit/output_validation_basic.bats"),
        ("tests/fixtures/complete_test_cases.csv", "complete", "tests/unit/output_validation_complete.bats"),
    ]
    for matrix_csv, test_name, output_bats in configs:
        if Path(matrix_csv).exists():
            generate_bats_for_matrix(matrix_csv, test_name, output_bats)
        else:
            print(f"Warning: {matrix_csv} not found, skipping.")

if __name__ == "__main__":
    main() 