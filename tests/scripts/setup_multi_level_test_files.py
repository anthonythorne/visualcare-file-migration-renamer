#!/usr/bin/env python3

"""
Setup Multi-Level Directory Test Files.

This script creates test files with multi-level directory structures
in the tests/test-files/from/ directory for testing the multi-level
directory processing functionality.

File Path: tests/scripts/setup_multi_level_test_files.py

@package VisualCare\\FileMigration\\Tests
@since   1.0.0

Creates test files with:
- Multi-level directory structures
- Year folders (2023, 2024, 2025)
- Category folders (WHS, Medical, CHAPS, etc.)
- Date-based filenames
- Person names in filenames
- Various file types (PDF, DOCX, JPG, etc.)
"""

import csv
import shutil
import sys
from pathlib import Path
from typing import Dict, List

# Add project root to path
sys.path.insert(0, str(Path(__file__).parent.parent.parent))


def setup_multi_level_test_files():
    """Set up multi-level directory test files for testing."""
    
    # Get project root and test files directory
    project_root = Path(__file__).parent.parent.parent
    test_files_dir = project_root / 'tests' / 'test-files'
    from_dir = test_files_dir / 'from-multi-level'
    to_dir = test_files_dir / 'to-multi-level'
    
    # Load test cases from CSV
    test_cases = load_test_cases()
    
    print("Setting up Multi-Level Directory Test Files")
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
    print("\nTo run the multi-level directory test:")
    print("python3 main.py --test-mode --test-name multi-level --dry-run")
    print("\nTo run with actual processing:")
    print("python3 main.py --test-mode --test-name multi-level")

    # Regenerate output validation BATS tests for multi-level
    import subprocess
    subprocess.run(["python3", "tests/scripts/generate_output_validation_bats.py"])
    
    return created_files


def load_test_cases() -> List[Dict]:
    """Load test cases from the multi-level directory fixture."""
    test_cases = []
    fixture_path = Path(__file__).parent.parent / 'fixtures' / 'multi_level_directory_cases.csv'
    
    if not fixture_path.exists():
        print(f"Error: Test fixture not found: {fixture_path}")
        return test_cases
    
    with open(fixture_path, 'r') as f:
        reader = csv.DictReader(f)
        for row in reader:
            test_cases.append(row)
    
    return test_cases


def cleanup_existing_files(directory: Path):
    """Clean up existing test files while preserving directory structure."""
    import shutil
    if directory.exists():
        print(f"Deleting and recreating directory: {directory}")
        shutil.rmtree(directory)
    directory.mkdir(parents=True, exist_ok=True)


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


def run_multi_level_test():
    """Run the multi-level directory test using the main script."""
    print("\nRunning Multi-Level Directory Test")
    print("=" * 50)
    
    # Import and run the main script
    import subprocess
    import sys
    
    # Run the test mode with multi-level test name
    cmd = [
        sys.executable, 
        'main.py', 
        '--test-mode', 
        '--test-name', 
        'multi-level',
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
    
    parser = argparse.ArgumentParser(description="Set up multi-level directory test files")
    parser.add_argument('--run-test', action='store_true', help='Run the test after setup')
    parser.add_argument('--actual', action='store_true', help='Run with actual processing (not dry-run)')
    
    args = parser.parse_args()
    
    # Set up test files
    created_files = setup_multi_level_test_files()
    
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
                'multi-level'
            ]
            
            print(f"Running: {' '.join(cmd)}")
            result = subprocess.run(cmd)
            print(f"Exit code: {result.returncode}")
        else:
            success = run_multi_level_test()
            if success:
                print("✅ Multi-level directory test completed successfully!")
            else:
                print("❌ Multi-level directory test failed!")
                sys.exit(1)


if __name__ == "__main__":
    main() 