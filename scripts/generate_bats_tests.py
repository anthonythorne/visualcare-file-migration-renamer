#!/usr/bin/env python3

import csv
import os
from pathlib import Path

def generate_bats_tests():
    # Get the project root directory (2 levels up from this script)
    project_root = Path(__file__).parent.parent.absolute()
    
    # Define paths
    csv_path = project_root / 'tests' / 'fixtures' / 'name_extraction_cases.csv'
    output_path = project_root / 'tests' / 'unit' / 'name_utils_table_test.bats'
    
    # Ensure the output directory exists
    output_path.parent.mkdir(parents=True, exist_ok=True)
    
    # Read the CSV file
    with open(csv_path, 'r') as f:
        reader = csv.DictReader(f, delimiter='|')
        test_cases = list(reader)
    
    # Generate the BATS test file content
    bats_content = f"""#!/usr/bin/env bats

# Load test helper functions
load "${{BATS_TEST_DIRNAME}}/../test_helper/bats-support/load.bash"
load "${{BATS_TEST_DIRNAME}}/../test_helper/bats-assert/load.bash"
load "${{BATS_TEST_DIRNAME}}/../test_helper/bats-file/load.bash"

# Source the function to test
source "${{BATS_TEST_DIRNAME}}/../../core/utils/name_utils.sh"

"""
    
    # Generate name extraction tests
    for i, case in enumerate(test_cases, 1):
        test_name = case['use_case']  # Use the original use case name
        bats_content += f"""@test "name extraction: {test_name}" {{
    run extract_name_from_filename "{case['filename']}" "{case['name_to_match']}"
    
    # Split the output into components
    IFS='|' read -r actual_extracted_name actual_raw_remainder actual_matched <<< "$output"
    
    # Debug output
    echo "[DEBUG] Testing: {case['filename']}" >&2
    echo "[DEBUG] Expected match: {case['expected_match']}" >&2
    echo "[DEBUG] Expected extracted name: {case['extracted_name']}" >&2
    echo "[DEBUG] Expected raw remainder: {case['raw_remainder']}" >&2
    echo "[DEBUG] Use case: {case['use_case']}" >&2
    echo "[DEBUG] Actual output: $output" >&2
    
    # Assertions
    if [ "{case['expected_match']}" = "true" ]; then
        assert_equal "$actual_matched" "true"
        assert_equal "$actual_extracted_name" "{case['extracted_name']}"
        assert_equal "$actual_raw_remainder" "{case['raw_remainder']}"
    else
        assert_equal "$actual_matched" "false"
        assert_equal "$actual_extracted_name" ""
        assert_equal "$actual_raw_remainder" "{case['filename']}"
    fi
}}

"""
    
    # Generate filename cleaning tests
    for i, case in enumerate(test_cases, 1):
        test_name = case['use_case']  # Use the original use case name
        bats_content += f"""@test "clean filename: {test_name}" {{
    run clean_filename_remainder "{case['raw_remainder']}"
    
    # Debug output
    echo "[DEBUG] Testing remainder: {case['raw_remainder']}" >&2
    echo "[DEBUG] Expected cleaned: {case['cleaned_remainder']}" >&2
    echo "[DEBUG] Use case: {case['use_case']}" >&2
    echo "[DEBUG] Actual output: $output" >&2
    
    # Assertions
    assert_equal "$output" "{case['cleaned_remainder']}"
}}

"""
    
    # Write the generated content to the BATS test file
    with open(output_path, 'w') as f:
        f.write(bats_content)
    
    # Make the file executable
    os.chmod(output_path, 0o755)
    
    print(f"Generated {len(test_cases) * 2} tests in {output_path}")

if __name__ == '__main__':
    generate_bats_tests() 