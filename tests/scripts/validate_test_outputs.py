#!/usr/bin/env python3
"""
Validate test outputs for VisualCare File Migration Renamer.

Checks that all expected output filenames (from the CSV matrix) exist in the to-<testname> directory.
Reports any missing or mismatched files. Exits with nonzero status if any issues are found.
"""
import sys
import csv
from pathlib import Path

def main():
    if len(sys.argv) != 2:
        print("Usage: validate_test_outputs.py <testname>", file=sys.stderr)
        sys.exit(2)
    testname = sys.argv[1]
    project_root = Path(__file__).parent.parent.parent
    fixtures_dir = project_root / 'tests' / 'fixtures'
    test_files_dir = project_root / 'tests' / 'test-files'
    to_dir = test_files_dir / f'to-{testname}'
    # Determine CSV file
    if (fixtures_dir / f'{testname}_test_cases.csv').exists():
        csv_file = fixtures_dir / f'{testname}_test_cases.csv'
    elif testname == 'category' and (fixtures_dir / 'category_test_cases.csv').exists():
        csv_file = fixtures_dir / 'category_test_cases.csv'
    elif testname == 'multi-level' and (fixtures_dir / 'multi_level_directory_cases.csv').exists():
        csv_file = fixtures_dir / 'multi_level_directory_cases.csv'
    else:
        print(f"No CSV matrix found for test: {testname}", file=sys.stderr)
        sys.exit(2)
    # Load expected filenames from CSV
    expected = set()
    with open(csv_file, 'r') as f:
        reader = csv.DictReader(f)
        for row in reader:
            person = row.get('person_name') or row.get('person')
            expected_filename = row.get('expected_filename')
            if person and expected_filename:
                expected.add((person, expected_filename))
    # Check actual output files
    actual = set()
    if not to_dir.exists():
        print(f"Output directory does not exist: {to_dir}", file=sys.stderr)
        sys.exit(1)
    for person_dir in to_dir.iterdir():
        if person_dir.is_dir():
            for file in person_dir.iterdir():
                if file.is_file():
                    actual.add((person_dir.name, file.name))
    # Compare
    missing = expected - actual
    extra = actual - expected
    if missing:
        print("Missing or mismatched output files:")
        for person, fname in sorted(missing):
            print(f"  {person}/{fname}")
    if extra:
        print("Extra files not expected by matrix:")
        for person, fname in sorted(extra):
            print(f"  {person}/{fname}")
    if missing or extra:
        sys.exit(1)
    print("All output filenames match expected matrix.")
    sys.exit(0)

if __name__ == "__main__":
    main() 