#!/usr/bin/env python3
"""
Validate test outputs for VisualCare File Migration Renamer.

Checks that all expected output filenames (from the CSV matrix) exist in the to-<testname> directory.
Reports any missing or mismatched files. Exits with nonzero status if any issues are found.
"""
import sys
import csv
from pathlib import Path
import datetime

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
    # Load expected filenames and dates from CSV
    expected = {}
    with open(csv_file, 'r') as f:
        reader = csv.DictReader(f)
        for row in reader:
            person = row.get('person_name') or row.get('person')
            expected_filename = row.get('expected_filename')
            modified_date = row.get('modified_date', '').strip()
            created_date = row.get('created_date', '').strip()
            if person and expected_filename:
                expected[(person, expected_filename)] = {
                    'modified_date': modified_date,
                    'created_date': created_date
                }
    # Check actual output files
    actual = set()
    file_dates = {}
    if not to_dir.exists():
        print(f"Output directory does not exist: {to_dir}", file=sys.stderr)
        sys.exit(1)
    for person_dir in to_dir.iterdir():
        if person_dir.is_dir():
            for file in person_dir.iterdir():
                if file.is_file():
                    actual.add((person_dir.name, file.name))
                    stat = file.stat()
                    mtime = datetime.datetime.fromtimestamp(stat.st_mtime).date()
                    # Try to get creation date (birth time)
                    ctime = None
                    if hasattr(stat, 'st_birthtime'):
                        ctime = datetime.datetime.fromtimestamp(stat.st_birthtime).date()
                    elif sys.platform == 'win32':
                        ctime = datetime.datetime.fromtimestamp(stat.st_ctime).date()
                    file_dates[(person_dir.name, file.name)] = {
                        'modified_date': mtime,
                        'created_date': ctime
                    }
    # Compare
    missing = set(expected.keys()) - actual
    extra = actual - set(expected.keys())
    date_mismatches = []
    today = datetime.date.today()
    for key in expected:
        if key in file_dates:
            exp = expected[key]
            act = file_dates[key]
            # Modified date check
            if exp['modified_date']:
                if exp['modified_date'].lower() == 'today':
                    if act['modified_date'] != today:
                        date_mismatches.append((key, 'modified', act['modified_date'], today))
                else:
                    try:
                        exp_mod = datetime.datetime.strptime(exp['modified_date'], '%Y-%m-%d').date()
                        if act['modified_date'] != exp_mod:
                            date_mismatches.append((key, 'modified', act['modified_date'], exp_mod))
                    except Exception as e:
                        print(f"Warning: Could not parse expected modified_date for {key}: {e}")
            # Created date check
            if exp['created_date']:
                if act['created_date'] is None:
                    print(f"Warning: Creation date not available for {key[0]}/{key[1]} on this OS.")
                else:
                    if exp['created_date'].lower() == 'today':
                        if act['created_date'] != today:
                            date_mismatches.append((key, 'created', act['created_date'], today))
                    else:
                        try:
                            exp_cre = datetime.datetime.strptime(exp['created_date'], '%Y-%m-%d').date()
                            if act['created_date'] != exp_cre:
                                date_mismatches.append((key, 'created', act['created_date'], exp_cre))
                        except Exception as e:
                            print(f"Warning: Could not parse expected created_date for {key}: {e}")
    if missing:
        print("Missing or mismatched output files:")
        for person, fname in sorted(missing):
            print(f"  {person}/{fname}")
    if extra:
        print("Extra files not expected by matrix:")
        for person, fname in sorted(extra):
            print(f"  {person}/{fname}")
    if date_mismatches:
        print("Date mismatches:")
        for (person, fname), typ, actual, expected in date_mismatches:
            print(f"  {person}/{fname}: {typ} date {actual} != expected {expected}")
    if missing or extra or date_mismatches:
        sys.exit(1)
    print("All output filenames and file dates match expected matrix.")
    sys.exit(0)

if __name__ == "__main__":
    main() 