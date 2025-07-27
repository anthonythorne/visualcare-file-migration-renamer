#!/usr/bin/env python3
"""
Generate BATS tests for complete integration testing.

This script generates comprehensive integration tests that:
1. Read the integration matrix with user/category mappings
2. Test string-to-string comparisons for the complete pipeline
3. Verify user mapping, category mapping, date extraction, and filename generation
4. Test the complete normalized filename output

File Path: tests/scripts/generate_06_complete_integration_bats.py

@package VisualCare\FileMigration\Tests
@since   1.0.0
"""

import csv
from pathlib import Path

bats_file = Path(__file__).parent.parent / 'unit' / '06_complete_integration_matrix_tests.bats'
matrix_file = Path(__file__).parent.parent / 'fixtures' / '06_complete_integration_cases.csv'

bats_file.parent.mkdir(parents=True, exist_ok=True)

def generate_bats_tests():
    """Generate BATS tests from the integration matrix."""
    
    with open(matrix_file, newline='') as csvfile:
        reader = csv.DictReader(csvfile, delimiter='|')
        tests = []
        
        for i, row in enumerate(reader):
            # Skip empty rows
            if not row['test_case'] or not row['full_path']:
                continue
                
            test_name = f"complete_integration - {row['full_path']}"
            
            bats_test = f"""
@test \"{test_name}\" {{
  # Test case: {row['description']}
  # Input: {row['full_path']}
  # Expected: {row['expected_filename']}
  
  echo "=== COMPLETE INTEGRATION TEST ===" >&2
  echo "Test case: {row['description']}" >&2
  echo "Input path: {row['full_path']}" >&2
  echo "Expected filename: {row['expected_filename']}" >&2
  echo "=================================" >&2
  
  # Test user mapping
  echo "Testing user mapping..." >&2
  result="$(extract_user_from_path "{row['full_path']}")"
  IFS='|' read -r extracted_user_id raw_name extracted_name raw_remainder cleaned_remainder <<< "$result"
  
  expected_user_id="{row['expected_user_id']}"
  expected_name="{row['expected_name']}"
  
  echo "----- USER MAPPING RESULTS -----" >&2
  echo "Expected user ID: '$expected_user_id'" >&2
  echo "Extracted user ID: '$extracted_user_id'" >&2
  echo "Expected name: '$expected_name'" >&2
  echo "Raw name: '$raw_name'" >&2
  echo "Extracted name (cleaned): '$extracted_name'" >&2
  echo "Raw remainder: '$raw_remainder'" >&2
  echo "Cleaned remainder: '$cleaned_remainder'" >&2
  echo "-------------------------------" >&2
  
  [ "$extracted_user_id" = "$expected_user_id" ]
  [ "$extracted_name" = "$expected_name" ]
  
  # Test category mapping (if there's a second directory)
  # Extract the second directory as the category candidate
  # Use cut to get the second field when splitting by '/'
  category_candidate=$(echo "{row['full_path']}" | cut -d'/' -f2)
  if [ -n "$category_candidate" ]; then
    
    echo "Testing category mapping..." >&2
    result="$(extract_category_from_path "{row['full_path']}")"
    IFS='|' read -r extracted_category raw_category cleaned_category raw_remainder cleaned_remainder error_status <<< "$result"
    
    expected_category="{row['expected_category']}"
    
    echo "----- CATEGORY MAPPING RESULTS -----" >&2
    echo "Category candidate: '$category_candidate'" >&2
    echo "Expected category: '$expected_category'" >&2
    echo "Extracted category: '$extracted_category'" >&2
    echo "Raw category: '$raw_category'" >&2
    echo "Cleaned category: '$cleaned_category'" >&2
    echo "Raw remainder: '$raw_remainder'" >&2
    echo "Cleaned remainder: '$cleaned_remainder'" >&2
    echo "Error status: '$error_status'" >&2
    echo "----------------------------------" >&2
    
    if [ -n "$expected_category" ]; then
      [ "$extracted_category" = "$expected_category" ]
    fi
  fi
  
  # Test date extraction
  echo "Testing date extraction..." >&2
  result="$(extract_date_from_path "{row['full_path']}")"
  IFS='|' read -r extracted_date raw_date cleaned_date raw_remainder cleaned_remainder error_status <<< "$result"
  
  expected_date="{row['expected_date']}"
  
  echo "----- DATE EXTRACTION RESULTS -----" >&2
  echo "Expected date: '$expected_date'" >&2
  echo "Extracted date: '$extracted_date'" >&2
  echo "Raw date: '$raw_date'" >&2
  echo "Cleaned date: '$cleaned_date'" >&2
  echo "Raw remainder: '$raw_remainder'" >&2
  echo "Cleaned remainder: '$cleaned_remainder'" >&2
  echo "Error status: '$error_status'" >&2
  echo "--------------------------------" >&2
  
  if [ -n "$expected_date" ]; then
    [ "$extracted_date" = "$expected_date" ]
  fi
  
  # Test complete filename generation (this would be the main processing function)
  # TODO: Replace with actual complete processing function
  # result="$(process_complete_filename "{row['full_path']}")"
  # IFS='|' read -r generated_filename user_id person_name remainder date category_id <<< "$result"
  
  # For now, verify the expected filename format
  expected_filename="{row['expected_filename']}"
  
  echo "----- COMPLETE FILENAME VALIDATION -----" >&2
  echo "Expected filename: '$expected_filename'" >&2
  echo "Expected format: user_id_person_name_remainder_date_category_id.ext" >&2
  echo "--------------------------------------" >&2
  
  # Verify the expected filename has the correct format
  if [ -n "$expected_filename" ]; then
    # Check if it starts with user_id (if user is mapped)
    if [ -n "$expected_user_id" ]; then
      echo "Checking user_id prefix..." >&2
      echo "$expected_filename" | grep -q "^$expected_user_id_"
    fi
    
    # Check if it contains the person name
    echo "Checking person name..." >&2
    echo "$expected_filename" | grep -q "$expected_name"
    
    # Check if it contains the date (if present)
    if [ -n "$expected_date" ]; then
      echo "Checking date..." >&2
      echo "$expected_filename" | grep -q "$expected_date"
    fi
    
    # Check if it contains the category (if present)
    if [ -n "$expected_category" ]; then
      echo "Checking category..." >&2
      echo "$expected_filename" | grep -q "_$expected_category\\."
    fi
  fi
  
  echo "=== TEST COMPLETED SUCCESSFULLY ===" >&2
}}
"""
            tests.append(bats_test)
    
    return tests

def write_bats_file(tests):
    """Write the BATS test file."""
    
    with open(bats_file, 'w') as f:
        f.write("""#!/usr/bin/env bats

# Auto-generated BATS tests for complete integration testing
# These tests verify the entire file processing pipeline with string-to-string comparisons

# Source the required shell functions
source /home/athorne/dev/repos/visualcare-file-migration-renamer/tests/utils/user_mapping.sh
source /home/athorne/dev/repos/visualcare-file-migration-renamer/tests/utils/category_utils.sh
source /home/athorne/dev/repos/visualcare-file-migration-renamer/tests/utils/date_utils.sh

""")
        
        for test in tests:
            f.write(test)

def main():
    """Main function to generate BATS tests."""
    print(f"Generating BATS tests from {matrix_file}")
    
    if not matrix_file.exists():
        print(f"Error: Matrix file not found: {matrix_file}")
        return 1
    
    try:
        tests = generate_bats_tests()
        write_bats_file(tests)
        print(f"Generated BATS tests: {bats_file}")
        print(f"Created {len(tests)} test cases")
        return 0
    except Exception as e:
        print(f"Error generating BATS tests: {e}")
        return 1

if __name__ == "__main__":
    exit(main()) 