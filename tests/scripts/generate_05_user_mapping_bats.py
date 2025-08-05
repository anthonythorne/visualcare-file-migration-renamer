#!/usr/bin/env python3

"""
Generate BATS tests for user mapping from CSV matrix.

This script reads the user mapping test matrix and generates BATS test files
that test user ID mapping functionality with full path extraction.

File Path: tests/scripts/generate_05_user_mapping_bats.py

@package VisualCare\\FileMigration\\Tests
@since   1.0.0
"""

import csv
import sys
import subprocess
from pathlib import Path


def generate_bats_tests():
    """Generate BATS tests from the user mapping matrix."""
    
    # Read the test matrix
    matrix_path = Path(__file__).parent.parent / 'fixtures' / '05_user_mapping_cases.csv'
    
    if not matrix_path.exists():
        print(f"Error: Matrix file not found: {matrix_path}")
        sys.exit(1)
    
    # Generate BATS file
    bats_file = Path(__file__).parent.parent / 'unit' / '05_user_mapping_matrix_tests.bats'
    bats_file.parent.mkdir(parents=True, exist_ok=True)
    
    with open(bats_file, 'w') as f:
        # Write BATS file header
        f.write("#!/usr/bin/env bats\n\n")
        f.write("# User Mapping Matrix Tests\n")
        f.write("# Generated from tests/fixtures/05_user_mapping_cases.csv\n\n")
        
        # Source the utility script
        project_root = Path(__file__).parent.parent.parent
        f.write(f"source {project_root}/tests/utils/user_mapping.sh\n\n")
        
        # Read matrix and generate tests
        with open(matrix_path, 'r') as matrix_file:
            reader = csv.DictReader(matrix_file, delimiter='|')
            
            for row in reader:
                input_path = row['input_path']
                expected_user_id = row['expected_user_id']
                expected_raw_name = row['raw_name']
                expected_cleaned_name = row['cleaned_name']
                expected_raw_remainder = row['raw_remainder']
                expected_cleaned_remainder = row['cleaned_remainder']
                description = row['description']
                
                # Create test name
                test_name = f"extract_user_from_path - {input_path}"
                test_name = test_name.replace('/', '_').replace(' ', '_').replace('-', '_')
                
                f.write(f"@test \"{test_name}\" {{\n")
                f.write(f"    # {description}\n")
                f.write(f"    result=\"$(extract_user_from_path \"{input_path}\")\"\n")
                f.write(f"    \n")
                f.write(f"    # Parse result components\n")
                f.write(f"    IFS='|' read -r user_id raw_name cleaned_name raw_remainder cleaned_remainder is_management_folder <<< \"$result\"\n")
                f.write(f"    \n")
                f.write(f"    # Get normalized filename using real function\n")
                f.write(f"    normalized_filename=\"$(python3 {project_root}/tests/utils/normalize_test.py \"{input_path}\")\"\n")
                f.write(f"    \n")
                f.write(f"    # Debug output\n")
                f.write(f"    echo \"----- TEST CASE -----\"\n")
                f.write(f"    echo \"Comment: {description}\"\n")
                f.write(f"    echo \"function: extract_user_from_path\"\n")
                f.write(f"    echo \"input_path: {input_path}\"\n")
                f.write(f"    echo \"expected_user_id: {expected_user_id}\"\n")
                f.write(f"    echo \"raw_name expected: {expected_raw_name}\"\n")
                f.write(f"    echo \"raw_name matched: $raw_name\"\n")
                f.write(f"    echo \"cleaned_name expected: {expected_cleaned_name}\"\n")
                f.write(f"    echo \"cleaned_name matched: $cleaned_name\"\n")
                f.write(f"    echo \"raw_remainder expected: {expected_raw_remainder}\"\n")
                f.write(f"    echo \"raw_remainder matched: $raw_remainder\"\n")
                f.write(f"    echo \"cleaned_remainder expected: {expected_cleaned_remainder}\"\n")
                f.write(f"    echo \"cleaned_remainder matched: $cleaned_remainder\"\n")
                f.write(f"    echo \"user_id expected: {expected_user_id}\"\n")
                f.write(f"    echo \"user_id matched: $user_id\"\n")
                f.write(f"    echo \"normalized filename: $normalized_filename\"\n")
                f.write(f"    echo \"---------------------\"\n")
                f.write(f"    \n")
                f.write(f"    # Assertions\n")
                f.write(f"    [ \"$user_id\" = \"{expected_user_id}\" ]\n")
                f.write(f"    [ \"$raw_name\" = \"{expected_raw_name}\" ]\n")
                f.write(f"    [ \"$cleaned_name\" = \"{expected_cleaned_name}\" ]\n")
                f.write(f"    [ \"$raw_remainder\" = \"{expected_raw_remainder}\" ]\n")
                f.write(f"    [ \"$cleaned_remainder\" = \"{expected_cleaned_remainder}\" ]\n")
                f.write(f"}}\n\n")
    
    print(f"Generated BATS tests: {bats_file}")


if __name__ == "__main__":
    generate_bats_tests() 