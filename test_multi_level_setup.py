#!/usr/bin/env python3

"""
Simple Multi-Level Directory Test Setup.

This script creates test files with multi-level directory structures
and runs the test using the existing test mode functionality.

File Path: test_multi_level_setup.py

@package VisualCare\\FileMigration\\Tests
@since   1.0.0
"""

import csv
import shutil
import sys
from pathlib import Path
from typing import Dict, List


def setup_multi_level_test_files():
    """Set up multi-level directory test files for testing."""
    
    # Get test files directory
    test_files_dir = Path('tests/test-files')
    from_dir = test_files_dir / 'from-multi-level'
    
    # Load test cases from CSV
    test_cases = load_test_cases()
    
    print("Setting up Multi-Level Directory Test Files")
    print("=" * 50)
    
    # Clean up existing test files (but keep the structure)
    cleanup_existing_files(from_dir)
    
    # Create test files for each test case
    created_files = []
    for test_case in test_cases:
        file_path = create_test_file(from_dir, test_case)
        if file_path:
            created_files.append(file_path)
            print(f"✅ Created: {file_path.relative_to(from_dir)}")
    
    print(f"\nCreated {len(created_files)} test files")
    print(f"Test files location: {from_dir}")
    
    return created_files


def load_test_cases() -> List[Dict]:
    """Load test cases from the multi-level directory fixture."""
    test_cases = []
    fixture_path = Path('tests/fixtures/multi_level_directory_cases.csv')
    
    if not fixture_path.exists():
        print(f"Error: Test fixture not found: {fixture_path}")
        return test_cases
    
    with open(fixture_path, 'r') as f:
        reader = csv.DictReader(f)
        for row in reader:
            test_cases.append(row)
    
    return test_cases


def cleanup_existing_files(from_dir: Path):
    """Clean up existing test files while preserving directory structure."""
    print("Cleaning up existing test files...")
    
    # Create directory if it doesn't exist
    from_dir.mkdir(parents=True, exist_ok=True)
    
    # Remove all files but keep directories
    for person_dir in from_dir.iterdir():
        if person_dir.is_dir():
            for file_path in person_dir.rglob('*'):
                if file_path.is_file():
                    file_path.unlink()
            print(f"Cleaned: {person_dir.name}/")


def create_test_file(from_dir: Path, test_case: Dict) -> Path:
    """Create a test file based on the test case."""
    
    # Parse the full path
    full_path = test_case['full_path']
    person_name = test_case['person_name']
    description = test_case['description']
    
    # Create the full directory structure
    file_path = from_dir / full_path
    file_path.parent.mkdir(parents=True, exist_ok=True)
    
    # Create file content based on the test case
    content = f"""Test file for multi-level directory processing.

Test Case: {test_case['test_case']}
Person: {person_name}
Description: {description}
Expected Filename: {test_case['expected_filename']}

This is a test file created for validating multi-level directory
processing functionality in the VisualCare File Migration Renamer.

File: {full_path}
Expected User ID: {test_case['expected_user_id']}
Expected Name: {test_case['expected_name']}
Expected Remainder: {test_case['expected_remainder']}
Expected Date: {test_case['expected_date']}
"""
    
    # Write the file
    with open(file_path, 'w') as f:
        f.write(content)
    
    return file_path


def main():
    """Main function to set up test files."""
    print("Multi-Level Directory Test Setup")
    print("=" * 50)
    
    # Set up test files
    created_files = setup_multi_level_test_files()
    
    print("\n" + "=" * 50)
    print("SETUP COMPLETE!")
    print("=" * 50)
    print("\nTo run the multi-level directory test:")
    print("python3 main.py --test-mode --test-name multi-level --dry-run")
    print("\nTo run with actual processing:")
    print("python3 main.py --test-mode --test-name multi-level")
    print("\nTo run with verbose output:")
    print("python3 main.py --test-mode --test-name multi-level --dry-run --verbose")
    print("\nTo test a specific person:")
    print("python3 main.py --test-mode --test-name multi-level --person 'John Doe' --dry-run")
    
    print(f"\nTest files created: {len(created_files)}")
    print("Files are ready for manual inspection in tests/test-files/from-multi-level/")
    print("Output will be in tests/test-files/to-multi-level/")


if __name__ == "__main__":
    main() 