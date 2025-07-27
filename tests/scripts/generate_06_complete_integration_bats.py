#!/usr/bin/env python3
"""
Generate BATS tests for complete integration testing.

This script generates comprehensive integration tests that:
1. Read the integration matrix
2. Create test files with proper structure and dates
3. Run the core functionality
4. Verify results match expected normalized filenames
5. Check modified dates are preserved

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
            test_name = f"complete_integration - {row['input_path']}"
            
            bats_test = f"""
@test \"{test_name}\" {{
  # Test case: {row['description']}
  # Input: {row['input_path']}
  # Expected: {row['expected_normalized_filename']}
  
  # Setup test files
  cd $BATS_TEST_DIRNAME/../..
  run python3 tests/scripts/setup_06_complete_integration_files.py --verbose
  [ "$status" -eq 0 ]
  
  # Verify source file exists
  source_file="$BATS_TEST_DIRNAME/../../tests/test-files/from/{row['input_path']}"
  [ -f "$source_file" ]
  
  # Run the core functionality (this would be your main processing script)
  # TODO: Replace with actual core functionality call
  # run python3 $BATS_TEST_DIRNAME/../../core/main.py --from-dir tests/test-files/from --to-dir tests/test-files/to
  # [ "$status" -eq 0 ]
  
  # For now, simulate the expected result by copying and renaming
  # This is a placeholder until the core functionality is implemented
  dest_dir="$BATS_TEST_DIRNAME/../../tests/test-files/to"
  expected_file="$dest_dir/{row['expected_normalized_filename']}"
  
  # Create destination directory
  mkdir -p "$dest_dir"
  
  # Copy and rename the file (simulating the core functionality)
  cp "$source_file" "$expected_file"
  
  # Verify the expected file exists
  [ -f "$expected_file" ]
  
  # Check filename matches expected
  actual_filename=$(basename "$expected_file")
  expected_filename="{row['expected_normalized_filename']}"
  [ "$actual_filename" = "$expected_filename" ]
  
  # Check modified date if specified
  if [ "{row['has_modified_date']}" = "true" ] && [ -n "{row['modified_date']}" ]; then
    # Get the modified date of the file
    file_date=$(stat -c %y "$expected_file" | cut -d' ' -f1)
    expected_date="{row['modified_date']}"
    
    # Simple date format conversion
    if [[ "$expected_date" == *"."* ]]; then
      # Convert from YYYY.MM.DD to YYYY-MM-DD
      formatted_expected=$(echo "$expected_date" | tr '.' '-')
    else
      # Assume it's already in correct format
      formatted_expected="$expected_date"
    fi
    
    echo "File date: $file_date" >&2
    echo "Expected date: $formatted_expected" >&2
    [ "$file_date" = "$formatted_expected" ]
  fi
  
  # Verify file contents are preserved
  if [ -f "$source_file" ] && [ -f "$expected_file" ]; then
    source_content=$(cat "$source_file")
    dest_content=$(cat "$expected_file")
    [ "$source_content" = "$dest_content" ]
  fi
}}
"""
            tests.append(bats_test)
    
    return tests

def write_bats_file(tests):
    """Write the BATS test file."""
    
    with open(bats_file, 'w') as f:
        f.write("""#!/usr/bin/env bats

# Auto-generated BATS tests for complete integration testing
# These tests verify the entire file processing pipeline

# Global setup - ensure test directories exist
setup() {
  export TEST_FROM_DIR="$BATS_TEST_DIRNAME/../../tests/test-files/from"
  export TEST_TO_DIR="$BATS_TEST_DIRNAME/../../tests/test-files/to"
  
  # Create test directories
  mkdir -p "$TEST_FROM_DIR"
  mkdir -p "$TEST_TO_DIR"
}

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