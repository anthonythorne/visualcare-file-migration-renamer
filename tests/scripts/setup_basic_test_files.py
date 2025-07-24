#!/usr/bin/env python3
"""
Setup script for basic test files (matrix-driven).

Creates test files for the basic test scenario using tests/fixtures/basic_test_cases.csv.
"""
import csv
from pathlib import Path

def setup_basic_test_files():
    print("Setting up Basic Test Files (matrix-driven)")
    print("=" * 50)
    project_root = Path(__file__).parent.parent.parent
    test_files_dir = project_root / 'tests' / 'test-files'
    from_dir = test_files_dir / 'from-basic'
    to_dir = test_files_dir / 'to-basic'
    # Create directories
    print(f"Creating directory: {from_dir}")
    from_dir.mkdir(parents=True, exist_ok=True)
    print(f"Creating directory: {to_dir}")
    to_dir.mkdir(parents=True, exist_ok=True)
    # Clean up existing test files
    def cleanup_existing_files(directory):
        import shutil
        if directory.exists():
            print(f"Deleting and recreating directory: {directory}")
            shutil.rmtree(directory)
        directory.mkdir(parents=True, exist_ok=True)
    cleanup_existing_files(from_dir)
    cleanup_existing_files(to_dir)
    # Load test cases from CSV
    fixture_path = Path(__file__).parent.parent / 'fixtures' / 'basic_test_cases.csv'
    test_files = []
    with open(fixture_path, 'r') as f:
        reader = csv.DictReader(f)
        for row in reader:
            full_path = row['full_path']
            person_name = row['person_name']
            description = row.get('description', '')
            expected_date = row.get('expected_date', '')
            file_path = from_dir / full_path
            file_path.parent.mkdir(parents=True, exist_ok=True)
            with open(file_path, 'w') as f_out:
                f_out.write(f"Test content for {full_path}\nPerson: {person_name}\nDescription: {description}\n")
            # Set file modification and creation date if expected_date is provided
            if expected_date:
                import time
                import os
                try:
                    t = time.mktime(time.strptime(expected_date, '%Y-%m-%d'))
                    os.utime(file_path, (t, t))
                except Exception as e:
                    print(f"Warning: Could not set file date for {file_path}: {e}")
            test_files.append((person_name, full_path))
            print(f"✅ Created: {person_name}/{file_path.name}")
    print(f"\nCreated {len(test_files)} test files")
    print(f"Test files location: {from_dir}")
    print() 
    print("To run the basic test:")
    print("python3 main.py --test-mode --test-name basic")
    print() 
    print("To run with actual processing:")
    print("python3 main.py --test-mode --test-name basic")

    # Regenerate output validation BATS tests for basic
    import subprocess
    subprocess.run(["python3", "tests/scripts/generate_output_validation_bats.py"])

if __name__ == "__main__":
    setup_basic_test_files() 