#!/usr/bin/env python3

import csv
import os
import argparse
from pathlib import Path

def generate_bats_tests(test_type):
    # Get the project root directory (2 levels up from this script)
    project_root = Path(__file__).parent.parent.absolute()

    if test_type == 'name':
        csv_path = project_root / 'tests' / 'fixtures' / 'name_extraction_cases.csv'
        output_path = project_root / 'tests' / 'unit' / 'name_utils_table_test.bats'
        source_script = "name_utils.sh"
        id_col = 'name_to_match'
        extracted_col = 'extracted_name'
        function_call_template = 'extract_name_from_filename "{filename}" "{id_val}"'
        clean_function = 'clean_filename_remainder'
    elif test_type == 'date':
        csv_path = project_root / 'tests' / 'fixtures' / 'date_extraction_cases.csv'
        output_path = project_root / 'tests' / 'unit' / 'date_utils_table_test.bats'
        source_script = "date_utils.sh"
        id_col = 'date_to_match'
        extracted_col = 'extracted_date'
        function_call_template = 'extract_date_from_filename "{filename}"'
        clean_function = 'clean_date_filename_remainder'
    else:
        raise ValueError("Invalid test type specified. Must be 'name' or 'date'.")

    # Ensure the output directory exists
    output_path.parent.mkdir(parents=True, exist_ok=True)

    # Read the CSV file - both name and date now use pipe delimiter
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
source "${{BATS_TEST_DIRNAME}}/../../core/utils/{source_script}"

# Override the main python script call to allow specifying the function
extract_name_from_filename() {{
    local filename="$1"
    local target_name="$2"
    local function_name="${{3:-extract_name_from_filename}}"  # Default to extract_name_from_filename
    
    # Call the python script, passing the function name as an argument
    # The python script will need to be adapted to handle this
    python3 "${{BATS_TEST_DIRNAME}}/../../core/utils/name_matcher.py" "$filename" "$target_name" "$function_name"
}}

"""

    # Generate extraction tests
    for i, case in enumerate(test_cases, 1):
        test_name = case['use_case']
        
        final_test_name = f"{test_type}-extraction-{i}: {test_name}"
        if test_type == 'name':
            matcher_func = case.get('matcher_function', 'all_matches')
            final_test_name = f"{test_type}-extraction-{i} [matcher_function={matcher_func}]: {test_name}"
            
            # Determine the correct python function to call based on the test case
            if matcher_func == 'first_name':
                py_function = 'extract_first_name_only'
            elif matcher_func == 'last_name':
                py_function = 'extract_last_name_only'
            elif matcher_func == 'initials':
                py_function = 'extract_initials_only'
            elif matcher_func == 'shorthand':
                py_function = 'extract_shorthand'
            else: # all_matches and any other case
                py_function = 'extract_name_from_filename'

            # The vcmigrate script is the entry point that calls the python script
            function_call = f'extract_name_from_filename "{case["filename"]}" "{case[id_col]}" "{py_function}"'

        else: # date
            function_call = function_call_template.format(filename=case['filename'])

        bats_content += f"""@test "{final_test_name}" {{
    run {function_call}

    # Split the output into components
    IFS='|' read -r actual_extracted actual_raw_remainder actual_matched <<< "$(echo \"$output\" | tail -n1)"

    # Debug output
    echo "[DEBUG] Testing: {case['filename']}" >&2
    echo "[DEBUG] Expected match: {case['expected_match']}" >&2
    echo "[DEBUG] Expected extracted: {case[extracted_col]}" >&2
    echo "[DEBUG] Expected raw remainder: {case['raw_remainder']}" >&2
    echo "[DEBUG] Use case: {case['use_case']}" >&2
    echo "[DEBUG] Actual output: $output" >&2

    # Assertions
    if [ "{case['expected_match']}" = "true" ]; then
        assert_equal "$actual_matched" "true"
        assert_equal "$actual_extracted" "{case[extracted_col]}"
        assert_equal "$actual_raw_remainder" "{case['raw_remainder']}"
    else
        assert_equal "$actual_matched" "false"
        assert_equal "$actual_extracted" ""
        assert_equal "$actual_raw_remainder" "{case['filename']}"
    fi
}}

"""

    # Generate filename cleaning tests
    bats_content += f"# --- Filename Cleaning Tests --- #\n\n"
    for i, case in enumerate(test_cases, 1):
        test_name = case['use_case']
        
        final_test_name = f"{test_type}-clean_filename-{i}: {test_name}"
        if test_type == 'name':
            matcher_func = case.get('matcher_function', 'none')
            final_test_name = f"{test_type}-clean_filename-{i} [matcher_function={matcher_func}]: {test_name}"

        bats_content += f"""@test "{final_test_name}" {{
    run {clean_function} "{case['raw_remainder']}"

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

    print(f"Generated {len(test_cases) * 2} {test_type} tests in {output_path}")

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description="Generate BATS tests for name or date extraction.")
    parser.add_argument('test_type', choices=['name', 'date'], help="The type of tests to generate ('name' or 'date').")
    args = parser.parse_args()
    generate_bats_tests(args.test_type) 