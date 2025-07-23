#!/usr/bin/env python3

"""
Setup Category Test Files.

This script creates test files with category directory structures
in the tests/test-files/from-category/ directory for testing the category
system functionality.

File Path: tests/scripts/setup_category_test_files.py

@package VisualCare\\FileMigration\\Tests
@since   1.0.0

Creates test files with:
- Category directory structures (WHS, Medical, Financial, etc.)
- Person folders (John Doe, Jane Smith, Bob Johnson)
- Subdirectories within categories
- Files with and without categories
- Various file types (PDF, DOCX, JPG, etc.)
"""

import csv
import shutil
import sys
from pathlib import Path
from typing import Dict, List

# Add project root to path
sys.path.insert(0, str(Path(__file__).parent.parent.parent))


def setup_category_test_files():
    """Set up category test files for testing."""
    
    # Get project root and test files directory
    project_root = Path(__file__).parent.parent.parent
    test_files_dir = project_root / 'tests' / 'test-files'
    from_dir = test_files_dir / 'from-category'
    to_dir = test_files_dir / 'to-category'
    
    # Load test cases from CSV
    test_cases = load_test_cases()
    
    print("Setting up Category Test Files")
    print("=" * 50)
    
    # Clean up existing input and output test files for fresh start
    cleanup_existing_files(from_dir)
    cleanup_existing_files(to_dir)
    
    # Create test files for each test case
    created_files = []
    for test_case in test_cases:
        file_path = create_test_file(from_dir, test_case)
        if file_path:
            created_files.append(file_path)
            print(f"✅ Created: {file_path.relative_to(from_dir)}")
    
    print(f"\nCreated {len(created_files)} test files")
    print(f"Test files location: {from_dir}")
    print("\nTo run the category test:")
    print("python3 main.py --test-mode --test-name category --dry-run")
    print("\nTo run with actual processing:")
    print("python3 main.py --test-mode --test-name category")

    # Regenerate output validation BATS tests for category
    import subprocess
    subprocess.run(["python3", "tests/scripts/generate_output_validation_bats.py"])
    
    return created_files


def load_test_cases() -> List[Dict]:
    """Load test cases from the category fixture."""
    test_cases = []
    fixture_path = Path(__file__).parent.parent / 'fixtures' / 'category_test_cases.csv'
    
    if not fixture_path.exists():
        print(f"Error: Test fixture not found: {fixture_path}")
        return test_cases
    
    with open(fixture_path, 'r') as f:
        reader = csv.DictReader(f)
        for row in reader:
            test_cases.append(row)
    
    return test_cases


def cleanup_existing_files(test_dir: Path):
    """Fully delete the directory and all its contents, then recreate it (for both input and output test dirs)."""
    if test_dir.exists():
        print(f"Deleting and recreating directory: {test_dir}")
        shutil.rmtree(test_dir)
    test_dir.mkdir(parents=True, exist_ok=True)


def create_test_file(from_dir: Path, test_case: Dict) -> Path:
    """Create a test file based on the test case."""
    
    # Parse the full path
    full_path = test_case['full_path']
    person_name = test_case['person_name']
    expected_filename = test_case['expected_filename']
    expected_category = test_case['expected_category']
    
    # Create the full directory structure
    file_path = from_dir / full_path
    file_path.parent.mkdir(parents=True, exist_ok=True)
    
    # Create file content based on the test case
    content = f"""Test file for category system processing.

Test Case: {test_case['test_case']}
Person: {person_name}
Full Path: {full_path}
Expected Filename: {expected_filename}
Expected Category: {expected_category}

This is a test file created for validating category system
functionality in the VisualCare File Migration Renamer.

Expected User ID: {test_case['expected_user_id']}
Expected Name: {test_case['expected_name']}
Expected Remainder: {test_case['expected_remainder']}
Expected Date: {test_case['expected_date']}
Description: {test_case['description']}

Date Information:
- Folder Date: {test_case.get('folder_date', 'None')}
- Filename Date: {test_case.get('filename_date', 'None')}
- Modified Date: {test_case.get('modified_date', 'None')}
- Created Date: {test_case.get('created_date', 'None')}
- Priority Date: {test_case.get('priority_date', 'None')}
"""
    
    # Write the file
    with open(file_path, 'w') as f:
        f.write(content)
    
    return file_path


def run_category_test():
    """Run the category test using the main script."""
    print("\nRunning Category Test")
    print("=" * 50)
    
    # Import and run the main script
    import subprocess
    import sys
    
    # Run the test mode with category test name
    cmd = [
        sys.executable, 
        'main.py', 
        '--test-mode', 
        '--test-name', 
        'category',
        '--dry-run'
    ]
    
    print(f"Running: {' '.join(cmd)}")
    result = subprocess.run(cmd, capture_output=True, text=True)
    
    print("STDOUT:")
    print(result.stdout)
    
    if result.stderr:
        print("STDERR:")
        print(result.stderr)
    
    print(f"Exit code: {result.returncode}")
    
    return result.returncode == 0


def main():
    """Main function to set up and optionally run the test."""
    import argparse
    
    parser = argparse.ArgumentParser(description="Set up category test files")
    parser.add_argument('--run-test', action='store_true', help='Run the test after setup')
    parser.add_argument('--actual', action='store_true', help='Run with actual processing (not dry-run)')
    
    args = parser.parse_args()
    
    # Set up test files
    created_files = setup_category_test_files()
    
    if args.run_test:
        if args.actual:
            print("\nRunning with actual processing...")
            # Import and run with actual processing
            import subprocess
            import sys
            
            cmd = [
                sys.executable, 
                'main.py', 
                '--test-mode', 
                '--test-name', 
                'category'
            ]
            
            print(f"Running: {' '.join(cmd)}")
            result = subprocess.run(cmd)
            print(f"Exit code: {result.returncode}")
        else:
            success = run_category_test()
            if success:
                print("✅ Category test completed successfully")
            else:
                print("❌ Category test failed")
                sys.exit(1)


if __name__ == "__main__":
    main() 