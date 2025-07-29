#!/usr/bin/env python3
"""
Setup test files for test 06 complete integration tests.

This script creates the test files in tests/test-files/from-06/ based on the
test matrix in tests/fixtures/06_complete_integration_cases.csv.

File Path: tests/scripts/setup_06_test_files.py

@package VisualCare\\FileMigration\\Tests
@since   1.0.0
"""

import csv
import os
from pathlib import Path
from datetime import datetime


def setup_test_files():
    """Create test files based on the 06_complete_integration_cases.csv matrix."""
    
    # Get project root and paths
    project_root = Path(__file__).parent.parent.parent
    matrix_file = project_root / 'tests' / 'fixtures' / '06_complete_integration_cases.csv'
    test_files_dir = project_root / 'tests' / 'test-files' / 'from-06'
    
    # Create test files directory
    test_files_dir.mkdir(parents=True, exist_ok=True)
    
    # Read the matrix (uses | as delimiter)
    with open(matrix_file, 'r') as f:
        # Read the entire file and replace newlines within quoted fields
        content = f.read()
        
        # Split by lines and process each line
        lines = content.strip().split('\n')
        header = lines[0]
        
        # Parse header
        fieldnames = header.split('|')
        
        # Process data lines
        for line in lines[1:]:
            if not line.strip():
                continue
                
            # Split by | and handle any remaining newlines
            fields = line.split('|')
            if len(fields) < len(fieldnames):
                continue  # Skip incomplete lines
                
            # Create a row dictionary
            row = dict(zip(fieldnames, fields))
            
            full_path = row.get('full_path', '').strip()
            person_name = row.get('person_name', '').strip()
            test_case = row.get('test_case', '').strip()
            description = row.get('description', '').strip()
            modified_date = row.get('modified_date', '').strip()
            
            if not full_path:
                continue
            
            # Create the directory structure
            file_path = test_files_dir / full_path
            file_path.parent.mkdir(parents=True, exist_ok=True)
            
            # Create a simple test file with the filename
            filename = file_path.name
            content = f"Test file for {person_name}: {filename}\n"
            content += f"Path: {full_path}\n"
            content += f"Test case: {test_case}\n"
            content += f"Description: {description}\n"
            content += f"Expected filename: {row.get('expected_filename', '')}\n"
            
            # Write the file
            with open(file_path, 'w') as f:
                f.write(content)
            
            # Set modified date if specified
            if modified_date and modified_date.lower() != 'today':
                try:
                    # Parse the date (assuming format like "2023-06-01")
                    date_obj = datetime.strptime(modified_date, '%Y-%m-%d')
                    # Set both access and modified time to the same date
                    os.utime(file_path, (date_obj.timestamp(), date_obj.timestamp()))
                    print(f"Created: {file_path} (modified: {modified_date})")
                except ValueError:
                    print(f"Created: {file_path} (invalid date format: {modified_date})")
            else:
                print(f"Created: {file_path}")
    
    print(f"\nCreated test files in: {test_files_dir}")
    print("Test files are ready for processing.")


if __name__ == "__main__":
    setup_test_files() 