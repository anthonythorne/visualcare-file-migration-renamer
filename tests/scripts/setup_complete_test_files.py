#!/usr/bin/env python3
"""
Setup Complete Test Files.

This script creates test files for the complete test scenario in
tests/test-files/from-complete/ and cleans tests/test-files/to-complete/.

File Path: tests/scripts/setup_complete_test_files.py

@package VisualCare\\FileMigration\\Tests
@since   1.0.0

Creates test files for:
- All-in-one edge case coverage (category, multi-level, name, date, etc.)
- Person folder (John Doe)
- Various directory and filename patterns
"""
import csv
import shutil
from pathlib import Path

def setup_complete_test_files():
    print("Setting up Complete Test Files (matrix-driven)")
    print("=" * 50)
    project_root = Path(__file__).parent.parent.parent
    test_files_dir = project_root / 'tests' / 'test-files'
    from_dir = test_files_dir / 'from-complete'
    to_dir = test_files_dir / 'to-complete'
    # Clean up existing test files
    def cleanup_existing_files(directory):
        if directory.exists():
            print(f"Deleting and recreating directory: {directory}")
            shutil.rmtree(directory)
        directory.mkdir(parents=True, exist_ok=True)
    cleanup_existing_files(from_dir)
    cleanup_existing_files(to_dir)
    # Load test cases from CSV
    fixture_path = Path(__file__).parent.parent / 'fixtures' / 'complete_test_cases.csv'
    test_files = []
    with open(fixture_path, 'r') as f:
        reader = csv.DictReader(f)
        for row in reader:
            full_path = row['full_path']
            person_name = row['person_name']
            description = row.get('description', '')
            expected_date = row.get('expected_date', '')
            modified_date = row.get('modified_date', '').strip() if 'modified_date' in row else ''
            created_date = row.get('created_date', '').strip() if 'created_date' in row else ''
            file_path = from_dir / full_path
            file_path.parent.mkdir(parents=True, exist_ok=True)
            with open(file_path, 'w') as f_out:
                f_out.write(f"Test content for {full_path}\nPerson: {person_name}\nDescription: {description}\n")
            # Set file modification and creation date if specified
            import time, os
            if modified_date and modified_date.lower() != 'today':
                try:
                    t = time.mktime(time.strptime(modified_date, '%Y-%m-%d'))
                    os.utime(file_path, (t, t))
                except Exception as e:
                    print(f"Warning: Could not set file date for {file_path}: {e}")
            # Creation date is always 'now' (today) if 'created_date' is 'today' or empty
            test_files.append((person_name, full_path))
            print(f"✅ Created: {person_name}/{file_path.name}")
    print(f"\nCreated {len(test_files)} test files")
    print(f"Test files location: {from_dir}")
    print() 
    print("To run the complete test:")
    print("python3 main.py --test-mode --test-name complete")
    print() 
    print("To run with actual processing:")
    print("python3 main.py --test-mode --test-name complete")

    # Regenerate output validation BATS tests for complete
    import subprocess
    subprocess.run(["python3", "tests/scripts/generate_output_validation_bats.py"])

if __name__ == "__main__":
    setup_complete_test_files() 