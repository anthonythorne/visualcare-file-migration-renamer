#!/usr/bin/env python3
"""
Setup script for 06 complete integration test files.

This script creates test files based on the integration matrix:
1. Reads the CSV matrix with user/category mappings
2. Creates directory structures in tests/test-files/from
3. Creates test files with specified content
4. Applies modified dates based on priority_date or modified_date

File Path: tests/scripts/setup_06_complete_integration_files.py

@package VisualCare\FileMigration\Tests
@since   1.0.0
"""

import csv
import os
import shutil
import argparse
from datetime import datetime
from pathlib import Path

def parse_date(date_str):
    """Parse date string in various formats."""
    if not date_str or date_str.strip() == '':
        return None
    
    date_str = date_str.strip()
    
    # Try different date formats
    formats = [
        '%Y-%m-%d',
        '%d.%m.%Y',
        '%d.%m.%y',
        '%Y.%m.%d',
        '%d/%m/%Y',
        '%d/%m/%y',
        '%Y/%m/%d'
    ]
    
    for fmt in formats:
        try:
            return datetime.strptime(date_str, fmt)
        except ValueError:
            continue
    
    return None

def setup_test_files(matrix_file, from_dir, to_dir, verbose=False):
    """Setup test files based on the integration matrix."""
    
    # Clean and recreate directories
    for dir_path in [from_dir, to_dir]:
        if os.path.exists(dir_path):
            shutil.rmtree(dir_path)
        os.makedirs(dir_path, exist_ok=True)
    
    if verbose:
        print(f"Cleaning directories: {from_dir}, {to_dir}")
    
    # Read matrix file and create files/directories
    with open(matrix_file, 'r', newline='') as csvfile:
        reader = csv.DictReader(csvfile, delimiter='|')
        test_cases = list(reader)
    
    if verbose:
        print(f"Processing {len(test_cases)} test cases")
    
    for i, row in enumerate(test_cases):
        full_path = row['full_path']
        description = row['description']
        
        if verbose:
            print(f"\nTest case {i+1}: {full_path}")
        
        # Determine which date to use for modified date
        # Priority: modified_date > filename_date > folder_date
        date_to_use = None
        for date_field in ['modified_date', 'filename_date', 'folder_date']:
            if row.get(date_field) and row[date_field].strip():
                date_to_use = parse_date(row[date_field])
                if date_to_use:
                    if verbose:
                        print(f"  Using {date_field}: {row[date_field]}")
                    break
        
        full_path = os.path.join(from_dir, full_path)
        dir_path = os.path.dirname(full_path)
        os.makedirs(dir_path, exist_ok=True)
        
        file_path = os.path.join(dir_path, os.path.basename(full_path))
        
        # Create test file with content (include 'Path:' for validator)
        with open(file_path, 'w') as f:
            f.write(f"Test case: {description}\n")
            f.write(f"Path: {row['full_path']}\n")
            f.write(f"Person: {row['person_name']}\n")
            f.write(f"Expected user ID: {row['expected_user_id']}\n")
            f.write(f"Expected category: {row['expected_category']}\n")
            f.write(f"Expected filename: {row['expected_filename']}\n")
            f.write(f"Expected date: {row['expected_date']}\n")
            f.write(f"Modified date: {row.get('modified_date', '')}\n")
            f.write(f"Created date: {row.get('created_date', '')}\n")
            f.write(f"Filename date: {row.get('filename_date', '')}\n")
            f.write(f"Folder date: {row.get('folder_date', '')}\n")
        
        # Apply modified date if specified
        if date_to_use:
            os.utime(file_path, (date_to_use.timestamp(), date_to_use.timestamp()))
            if verbose:
                print(f"  Applied modified date: {date_to_use}")
    
    if verbose:
        print(f"\nSetup complete. Created {len(test_cases)} test files in {from_dir}")
        print(f"Destination directory {to_dir} is ready for processing")

def main():
    """Main function."""
    parser = argparse.ArgumentParser(description='Setup test files for 06 integration tests')
    parser.add_argument('--verbose', action='store_true', help='Enable verbose output')
    args = parser.parse_args()
    
    # Get paths
    script_dir = Path(__file__).parent
    project_root = script_dir.parent.parent
    matrix_file = script_dir.parent / 'fixtures' / '06_complete_integration_cases.csv'
    from_dir = project_root / 'tests' / 'test-files' / 'from-06'
    to_dir = project_root / 'tests' / 'test-files' / 'to-06'
    
    if not matrix_file.exists():
        print(f"Error: Matrix file not found: {matrix_file}")
        return 1
    
    try:
        setup_test_files(matrix_file, from_dir, to_dir, args.verbose)
        return 0
    except Exception as e:
        print(f"Error setting up test files: {e}")
        return 1

if __name__ == "__main__":
    exit(main()) 