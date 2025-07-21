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
        if directory.exists():
            for item in directory.iterdir():
                if item.is_file():
                    item.unlink()
                elif item.is_dir():
                    import shutil
                    shutil.rmtree(item)
    cleanup_existing_files(from_dir)
    # Load test cases from CSV
    fixture_path = Path(__file__).parent.parent / 'fixtures' / 'basic_test_cases.csv'
    test_files = []
    with open(fixture_path, 'r') as f:
        reader = csv.DictReader(f)
        for row in reader:
            full_path = row['full_path']
            person_name = row['person_name']
            description = row.get('description', '')
            file_path = from_dir / full_path
            file_path.parent.mkdir(parents=True, exist_ok=True)
            with open(file_path, 'w') as f_out:
                f_out.write(f"Test content for {full_path}\nPerson: {person_name}\nDescription: {description}\n")
            test_files.append((person_name, full_path))
            print(f"✅ Created: {person_name}/{file_path.name}")
    print(f"\nCreated {len(test_files)} test files")
    print(f"Test files location: {from_dir}")
    print() 
    print("To run the basic test:")
    print("python3 main.py --test-mode --test-name basic --dry-run")
    print() 
    print("To run with actual processing:")
    print("python3 main.py --test-mode --test-name basic")

if __name__ == "__main__":
    setup_basic_test_files() 