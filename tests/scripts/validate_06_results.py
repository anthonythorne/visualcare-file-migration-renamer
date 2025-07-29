#!/usr/bin/env python3
"""
Validate test 06 results by comparing generated filenames with expected filenames.

This script validates that the files created in tests/test-files/to-06/ match
the expected filenames from the test matrix and that modified dates are preserved.

File Path: tests/scripts/validate_06_results.py

@package VisualCare\\FileMigration\\Tests
@since   1.0.0
"""

import os
import csv
from pathlib import Path
from datetime import datetime


def validate_results():
    """Validate that generated filenames match expected filenames from matrix and modified dates are preserved."""
    
    # Get project root and paths
    project_root = Path(__file__).parent.parent.parent
    matrix_file = project_root / 'tests' / 'fixtures' / '06_complete_integration_cases.csv'
    output_dir = project_root / 'tests' / 'test-files' / 'to-06'
    input_dir = project_root / 'tests' / 'test-files' / 'from-06'
    
    # Read the matrix to get expected filenames and modified dates
    expected_data = {}
    with open(matrix_file, 'r', newline='') as f:
        reader = csv.DictReader(f, delimiter='|')
        for row in reader:
            full_path = row.get('full_path', '').strip() if row.get('full_path') else ''
            expected_filename = row.get('expected_filename', '').strip() if row.get('expected_filename') else ''
            modified_date = row.get('modified_date', '').strip() if row.get('modified_date') else ''
            if full_path and expected_filename:
                expected_data[full_path] = {
                    'expected_filename': expected_filename,
                    'modified_date': modified_date
                }
    
    # Get actual generated filenames and check modified dates
    actual_data = {}
    if output_dir.exists():
        for person_dir in output_dir.iterdir():
            if person_dir.is_dir():
                for file_path in person_dir.iterdir():
                    if file_path.is_file():
                        # Extract the original path from the test file content
                        with open(file_path, 'r') as f:
                            content = f.read()
                            original_path = None
                            for line in content.split('\n'):
                                if line.startswith('Path: '):
                                    original_path = line.replace('Path: ', '').strip()
                                    break
                            
                            if original_path:
                                actual_data[original_path] = {
                                    'actual_filename': file_path.name,
                                    'actual_mtime': datetime.fromtimestamp(file_path.stat().st_mtime),
                                    'file_path': file_path
                                }
    
    # Compare and report
    print("=== Test 06 Results Validation ===\n")
    
    total_tests = len(expected_data)
    passed_tests = 0
    failed_tests = 0
    date_mismatches = 0
    
    for original_path, expected_info in expected_data.items():
        actual_info = actual_data.get(original_path)
        expected_filename = expected_info['expected_filename']
        expected_modified_date = expected_info['modified_date']
        
        if not actual_info:
            print(f"❌ FAIL: {original_path}")
            print(f"   Expected: {expected_filename}")
            print(f"   Actual:   FILE NOT FOUND")
            failed_tests += 1
            print()
            continue
        
        actual_filename = actual_info['actual_filename']
        actual_mtime = actual_info['actual_mtime']
        
        # Check filename match
        filename_match = actual_filename == expected_filename
        
        # Check modified date if specified in matrix
        date_match = True
        if expected_modified_date and expected_modified_date.lower() != 'today':
            try:
                # Parse expected date (assuming format like "2023-06-01")
                expected_date = datetime.strptime(expected_modified_date, '%Y-%m-%d')
                # Compare dates (ignore time)
                date_match = actual_mtime.date() == expected_date.date()
                if not date_match:
                    date_mismatches += 1
            except ValueError:
                # If date parsing fails, skip date validation
                pass
        
        if filename_match and date_match:
            print(f"✅ PASS: {original_path}")
            print(f"   Expected: {expected_filename}")
            print(f"   Actual:   {actual_filename}")
            if expected_modified_date and expected_modified_date.lower() != 'today':
                print(f"   Modified: {actual_mtime.strftime('%Y-%m-%d %H:%M:%S')}")
            passed_tests += 1
        else:
            print(f"❌ FAIL: {original_path}")
            print(f"   Expected: {expected_filename}")
            print(f"   Actual:   {actual_filename}")
            if expected_modified_date and expected_modified_date.lower() != 'today':
                print(f"   Expected Modified: {expected_modified_date}")
                print(f"   Actual Modified:   {actual_mtime.strftime('%Y-%m-%d %H:%M:%S')}")
            failed_tests += 1
        print()
    
    print("=== Summary ===")
    print(f"Total tests: {total_tests}")
    print(f"Passed: {passed_tests}")
    print(f"Failed: {failed_tests}")
    if date_mismatches > 0:
        print(f"Date mismatches: {date_mismatches}")
    
    if failed_tests == 0:
        print("\n🎉 ALL TESTS PASSED! Test 06 complete integration is working correctly.")
        return True
    else:
        print(f"\n⚠️  {failed_tests} tests failed. Please review the differences above.")
        return False


if __name__ == "__main__":
    validate_results() 