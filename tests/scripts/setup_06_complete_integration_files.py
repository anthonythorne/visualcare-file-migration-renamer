#!/usr/bin/env python3
"""
Setup script for complete integration tests.

This script reads the integration test matrix and creates the test file structure
with proper directories, files, and modified dates for comprehensive testing.

File Path: tests/scripts/setup_06_complete_integration_files.py

@package VisualCare\FileMigration\Tests
@since   1.0.0
"""

import csv
import os
import shutil
from pathlib import Path
from datetime import datetime
import argparse

def parse_date(date_str):
    """Parse date string in various formats."""
    if not date_str:
        return None
    
    # Try different date formats
    formats = [
        "%Y-%m-%d",
        "%Y.%m.%d", 
        "%d-%m-%Y",
        "%m-%d-%Y",
        "%Y%m%d",
        "%d%m%Y",
        "%m%d%Y"
    ]
    
    for fmt in formats:
        try:
            return datetime.strptime(date_str, fmt)
        except ValueError:
            continue
    
    raise ValueError(f"Could not parse date: {date_str}")

def setup_test_files(matrix_file, from_dir, to_dir, verbose=False):
    """
    Setup test files based on the integration matrix.
    
    Args:
        matrix_file: Path to the CSV matrix file
        from_dir: Source directory for test files
        to_dir: Destination directory (will be cleaned)
        verbose: Enable verbose output
    """
    # Clean and recreate directories
    if verbose:
        print(f"Cleaning directories: {from_dir}, {to_dir}")
    
    for dir_path in [from_dir, to_dir]:
        if os.path.exists(dir_path):
            shutil.rmtree(dir_path)
        os.makedirs(dir_path, exist_ok=True)
    
    # Read matrix file
    with open(matrix_file, 'r', newline='') as csvfile:
        reader = csv.DictReader(csvfile, delimiter='|')
        test_cases = list(reader)
    
    if verbose:
        print(f"Processing {len(test_cases)} test cases")
    
    for i, row in enumerate(test_cases):
        input_path = row['input_path']
        has_modified_date = row['has_modified_date'].lower() == 'true'
        modified_date = row['modified_date'] if has_modified_date else None
        
        if verbose:
            print(f"\nTest case {i+1}: {input_path}")
            if has_modified_date:
                print(f"  Modified date: {modified_date}")
        
        # Create the full path in the from directory
        full_path = os.path.join(from_dir, input_path)
        
        # Create directories
        dir_path = os.path.dirname(full_path)
        os.makedirs(dir_path, exist_ok=True)
        
        # Create the file
        filename = os.path.basename(input_path)
        file_path = os.path.join(dir_path, filename)
        
        # Create a simple text file with the test case info
        with open(file_path, 'w') as f:
            f.write(f"Test case: {row['description']}\n")
            f.write(f"Input path: {input_path}\n")
            f.write(f"Expected filename: {row['expected_normalized_filename']}\n")
            f.write(f"User: {row['user_name']} (ID: {row['user_id']})\n")
            f.write(f"Category: {row['category_name']} (ID: {row['category_id']})\n")
            if has_modified_date:
                f.write(f"Modified date: {modified_date}\n")
        
        # Apply modified date if specified
        if has_modified_date and modified_date:
            try:
                date_obj = parse_date(modified_date)
                if date_obj:
                    # Convert to timestamp
                    timestamp = date_obj.timestamp()
                    os.utime(file_path, (timestamp, timestamp))
                    if verbose:
                        print(f"  Applied modified date: {date_obj.strftime('%Y-%m-%d %H:%M:%S')}")
                else:
                    if verbose:
                        print(f"  Warning: Could not parse date: {modified_date}")
            except Exception as e:
                if verbose:
                    print(f"  Error applying date {modified_date}: {e}")
    
    if verbose:
        print(f"\nSetup complete. Created {len(test_cases)} test files in {from_dir}")
        print(f"Destination directory {to_dir} is ready for processing")

def main():
    parser = argparse.ArgumentParser(description='Setup complete integration test files')
    parser.add_argument('--matrix', default='tests/fixtures/06_complete_integration_cases.csv',
                       help='Path to the integration test matrix CSV file')
    parser.add_argument('--from-dir', default='tests/test-files/from',
                       help='Source directory for test files')
    parser.add_argument('--to-dir', default='tests/test-files/to',
                       help='Destination directory for processed files')
    parser.add_argument('--verbose', '-v', action='store_true',
                       help='Enable verbose output')
    
    args = parser.parse_args()
    
    # Ensure paths are absolute
    project_root = Path(__file__).parent.parent.parent
    matrix_file = project_root / args.matrix
    from_dir = project_root / args.from_dir
    to_dir = project_root / args.to_dir
    
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