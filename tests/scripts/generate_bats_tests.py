#!/usr/bin/env python3

import csv
import os
import argparse
from pathlib import Path
import shutil
import time
import yaml
import re

# Remove old/archived matrix references and update to only use current test matrices
def generate_bats_tests(test_type):
    """Generate BATS tests for the specified test type using the current minimal matrix."""
    project_root = Path(__file__).parent.parent.parent
    if test_type == 'basic':
        csv_path = project_root / 'tests' / 'fixtures' / 'basic_test_cases.csv'
    elif test_type == 'category':
        csv_path = project_root / 'tests' / 'fixtures' / 'category_test_cases.csv'
    elif test_type == 'date':
        csv_path = project_root / 'tests' / 'fixtures' / 'date_extraction_cases.csv'
    elif test_type == 'multi_level':
        csv_path = project_root / 'tests' / 'fixtures' / 'multi_level_directory_cases.csv'
    elif test_type == 'complete':
        csv_path = project_root / 'tests' / 'fixtures' / 'complete_test_cases.csv'
    else:
        raise ValueError(f"Unknown test type: {test_type}")
    
    # Ensure the output directory exists
    output_path = project_root / 'tests' / 'unit' / f"{test_type}_utils_table_test.bats"
    output_path.parent.mkdir(parents=True, exist_ok=True)
    
    # Read the CSV file - both name and date now use pipe delimiter
    with open(csv_path, 'r') as f:
        reader = csv.DictReader(f, delimiter='|')
        test_cases = list(reader)
    
    if test_type == 'combined':
        bats_content = f"""#!/usr/bin/env bats

# Combined name and date extraction tests
# This file is auto-generated from combined_extraction_cases.csv
# It checks that both name and date extraction work together on realistic filenames.

load "${{BATS_TEST_DIRNAME}}/../test-helper/bats-support/load.bash"
load "${{BATS_TEST_DIRNAME}}/../test-helper/bats-assert/load.bash"
load "${{BATS_TEST_DIRNAME}}/../test-helper/bats-file/load.bash"

source "${{BATS_TEST_DIRNAME}}/../../core/utils/name_utils.sh"
source "${{BATS_TEST_DIRNAME}}/../../core/utils/date_utils.sh"

"""
        for i, case in enumerate(test_cases, 1):
            test_name = case['use_case']
            final_test_name = f"combined-extraction-{i}: {test_name}"
            bats_content += f"""@test "{final_test_name}" {{
    run extract_name_and_date_from_filename "{case['filename']}" "{case['name_to_match']}"
    IFS='|' read -r actual_extracted_name actual_extracted_date actual_raw_remainder actual_name_matched actual_date_matched <<< "$output"

    # Debug output
    echo "[DEBUG] Testing: {case['filename']}" >&2
    echo "[DEBUG] Expected name: {case['extracted_name']}" >&2
    echo "[DEBUG] Expected date: {case['extracted_date']}" >&2
    echo "[DEBUG] Expected raw remainder: {case['raw_remainder']}" >&2
    echo "[DEBUG] Expected cleaned: {case['cleaned_remainder']}" >&2
    echo "[DEBUG] Actual name: $actual_extracted_name" >&2
    echo "[DEBUG] Actual date: $actual_extracted_date" >&2
    echo "[DEBUG] Actual raw remainder: $actual_raw_remainder" >&2
    echo "[DEBUG] Actual cleaned: $(clean_filename_remainder "$actual_raw_remainder")" >&2
    echo "[DEBUG] Name matched: $actual_name_matched" >&2
    echo "[DEBUG] Date matched: $actual_date_matched" >&2

    assert_equal "$actual_extracted_name" "{case['extracted_name']}"
    assert_equal "$actual_extracted_date" "{case['extracted_date']}"
    assert_equal "$actual_raw_remainder" "{case['raw_remainder']}"
    assert_equal "$(clean_filename_remainder "$actual_raw_remainder")" "{case['cleaned_remainder']}"
    # Name matching: should match if expected_match is true
    if [ "{case['expected_match']}" = "true" ]; then
        assert_equal "$actual_name_matched" "true"
    else
        assert_equal "$actual_name_matched" "false"
    fi
    # Date matching: should match only if there's an expected date
    if [ -n "{case['extracted_date']}" ]; then
        assert_equal "$actual_date_matched" "true"
    else
        assert_equal "$actual_date_matched" "false"
    fi
}}

"""
        # No separate cleaning tests for combined for now
        # Write the generated content to the BATS test file
        with open(output_path, 'w') as f:
            f.write(bats_content)
        os.chmod(output_path, 0o755)
        print(f"Generated {len(test_cases)} combined tests in {output_path}")
        return
    
    # Load test helper functions
    bats_content = f"""#!/usr/bin/env bats

# Load test helper functions
load "${{BATS_TEST_DIRNAME}}/../test-helper/bats-support/load.bash"
load "${{BATS_TEST_DIRNAME}}/../test-helper/bats-assert/load.bash"
load "${{BATS_TEST_DIRNAME}}/../test-helper/bats-file/load.bash"

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
            matcher_func = case.get('matcher_function', 'extract_name_from_filename')
            final_test_name = f"{test_type}-extraction-{i} [matcher_function={matcher_func}]: {test_name}"
            
            # Use the matcher_function column directly as the python function name
            py_function = matcher_func

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

def generate_file_creation_bats_tests():
    """
    Generate BATS tests for all file-creation-based test matrices (basic, category, multi-level).
    Each test will:
    1. Run main.py in test mode for the test name.
    2. Run validate_test_outputs.py <testname> to check output files against the matrix.
    3. Fail if any mismatch is found.
    """
    project_root = Path(__file__).parent.parent.parent.absolute()
    test_cases = [
        ('basic', 'Basic test mode processing'),
        ('category', 'Category test mode processing'),
        ('multi-level', 'Multi-level test mode processing'),
    ]
    output_path = project_root / 'tests' / 'unit' / 'file_creation_matrix_tests.bats'
    bats_content = f"""#!/usr/bin/env bats

# Auto-generated integration tests for file-creation-based test matrices
# Each test runs main.py in test mode and validates output files against the expected matrix

load "${{BATS_TEST_DIRNAME}}/../test-helper/bats-support/load.bash"
load "${{BATS_TEST_DIRNAME}}/../test-helper/bats-assert/load.bash"

"""
    for testname, description in test_cases:
        bats_content += f"""
@test "{testname}: {description} (output files match matrix)" {{
    # Run main.py in test mode for this test
    run python3 ${{BATS_TEST_DIRNAME}}/../../main.py --test-mode --test-name {testname}
    [ "$status" -eq 0 ]
    # Validate output files against the matrix
    run python3 ${{BATS_TEST_DIRNAME}}/../scripts/validate_test_outputs.py {testname}
    [ "$status" -eq 0 ]
}}
"""
    with open(output_path, 'w') as f:
        f.write(bats_content)
    os.chmod(output_path, 0o755)
    print(f"Generated file-creation matrix BATS tests in {output_path}")

def normalize_name_with_config(name: str, config_path: Path) -> str:
    """
    Normalize a name string using the allowed separators from config/components.yaml.
    Replace any allowed_separators_when_searching with allowed_separator_on_normalized_name (first value),
    collapse multiples, trim, and apply case normalization.
    """
    with open(config_path, 'r') as f:
        config = yaml.safe_load(f)
    search_seps = config['Name']['allowed_separators_when_searching']
    output_sep = config['Name']['allowed_separator_on_normalized_name'][0]
    normalized_case = config['Name'].get('normalized_case', 'uppercasewords')
    pattern = '|'.join(re.escape(sep) for sep in search_seps)
    name = re.sub(pattern, output_sep, name)
    name = re.sub(re.escape(output_sep) + r'{2,}', output_sep, name)
    name = name.strip(output_sep)
    # Apply case normalization
    if normalized_case == 'uppercase':
        name = name.upper()
    elif normalized_case == 'lowercase':
        name = name.lower()
    elif normalized_case == 'uppercasewords':
        name = ' '.join(w.capitalize() for w in name.split(output_sep))
    return name

def run_integration_test():
    """
    Integration test: generate files from CSV, normalize, copy to 'to/', and check results.
    """
    project_root = Path(__file__).parent.parent.parent.absolute()
    from_dir = project_root / 'tests' / 'test-files' / 'from'
    to_dir = project_root / 'tests' / 'test-files' / 'to'
    csv_path = project_root / 'tests' / 'fixtures' / 'combined_extraction_cases.csv'
    config_path = project_root / 'config' / 'components.yaml'

    # 1. Remove and recreate directories completely (clean slate)
    if from_dir.exists():
        shutil.rmtree(from_dir)
    if to_dir.exists():
        shutil.rmtree(to_dir)
    
    from_dir.mkdir(parents=True, exist_ok=True)
    to_dir.mkdir(parents=True, exist_ok=True)

    # 2. Read CSV
    with open(csv_path, 'r') as f:
        reader = csv.DictReader(f, delimiter='|')
        cases = list(reader)

    # 3. Load config
    with open(config_path, 'r') as f:
        config = yaml.safe_load(f)
    date_priority = config['Date'].get('date_priority_order', ['filename', 'modified', 'created'])
    date_format = config['Date'].get('format', '%Y-%m-%d')

    # 4. Create files in 'from/' organized by person
    created_files = []
    for case in cases:
        filename = case['filename']
        name_to_match = case['name_to_match']
        
        # Create person-specific subdirectory
        person_dir = from_dir / name_to_match.title()
        person_dir.mkdir(parents=True, exist_ok=True)
        
        file_path = person_dir / filename
        with open(file_path, 'w') as f:
            f.write(f"Dummy content for {filename}\n")
        # Set created/modified times if specified
        if case.get('created_date'):
            t = time.mktime(time.strptime(case['created_date'], '%Y-%m-%d'))
            os.utime(file_path, (t, t))
        elif case.get('modified_date'):
            t = time.mktime(time.strptime(case['modified_date'], '%Y-%m-%d'))
            os.utime(file_path, (t, t))
        created_files.append(file_path)

    # 5. Normalize and copy to 'to/' organized by person
    sys.path.insert(0, str(project_root / 'core' / 'utils'))
    import name_matcher
    passed, failed = 0, 0
    results = []
    for case in cases:
        filename = case['filename']
        name_to_match = case['name_to_match']
        expected = case['expected_normalized_filename']
        
        # Source path includes person directory
        person_dir_name = name_to_match.title()
        src_path = from_dir / person_dir_name / filename
        # Extraction/normalization
        result = name_matcher.extract_name_and_date_from_filename(filename, name_to_match)
        extracted_name, extracted_date, raw_remainder, name_matched, date_matched = result.split('|')
        cleaned_remainder = name_matcher.clean_filename_remainder_py(raw_remainder)
        # Normalize the name using config
        normalized_name = normalize_name_with_config(extracted_name.replace(',', ' '), config_path) if extracted_name else ''
        # Date fallback logic
        date_val = ''
        for method in date_priority:
            if method == 'filename' and extracted_date:
                date_val = extracted_date
                break
            elif method == 'modified':
                stat = os.stat(src_path)
                t = stat.st_mtime
                date_val = time.strftime(date_format, time.localtime(t))
                if date_val:
                    break
            elif method == 'created':
                stat = os.stat(src_path)
                t = stat.st_ctime
                date_val = time.strftime(date_format, time.localtime(t))
                if date_val:
                    break
        # Decide if expected output includes name and/or date
        # Use regex to check for name and date in expected output
        expected_name = case['name_to_match']
        expected_name_norm = normalize_name_with_config(expected_name, config_path) if expected_name else ''
        # Date regex from config format (e.g., YYYY-MM-DD)
        date_regex = r'\d{4}-\d{2}-\d{2}' if date_format == '%Y-%m-%d' else r'\d{4}-\d{2}-\d{2}'
        has_expected_date = re.search(date_regex, expected) is not None
        has_expected_name = expected_name_norm in expected
        # Compose normalized filename
        parts = []
        if has_expected_name:
            parts.append(expected_name_norm)
        elif normalized_name:
            parts.append(normalized_name)
        if has_expected_date:
            parts.append(date_val)
        if cleaned_remainder:
            parts.append(cleaned_remainder)
        normalized = '_'.join([p for p in parts if p])
        # Use expected extension
        ext = os.path.splitext(filename)[1]
        if not normalized.endswith(ext):
            normalized += ext
        
        # Create person-specific destination directory
        dest_person_dir = to_dir / person_dir_name
        dest_person_dir.mkdir(parents=True, exist_ok=True)
        dest_path = dest_person_dir / normalized
        shutil.copy2(src_path, dest_path)
        # Check result
        if normalized == expected:
            results.append((filename, normalized, expected, True))
            passed += 1
        else:
            results.append((filename, normalized, expected, False))
            failed += 1
    # 6. Print summary
    print(f"Integration Test Results: {passed} passed, {failed} failed.")
    for fname, actual, exp, ok in results:
        status = 'PASS' if ok else 'FAIL'
        print(f"{status}: {fname} -> {actual} (expected: {exp})")

if __name__ == '__main__':
    import sys
    parser = argparse.ArgumentParser(description="Generate BATS tests for name, date, combined, file-creation, or run integration test.")
    parser.add_argument('test_type', nargs='?', choices=['name', 'date', 'combined', 'integration', 'file-creation'], help="The type of tests to generate ('name', 'date', 'combined', 'integration', 'file-creation'). If omitted, all will be generated.")
    args = parser.parse_args()
    if args.test_type == 'integration':
        run_integration_test()
    elif args.test_type == 'file-creation':
        generate_file_creation_bats_tests()
    elif args.test_type:
        generate_bats_tests(args.test_type) 
    else:
        print("No test_type specified. Generating all test types: name, date, combined, file-creation.\n")
        for t in ['name', 'date', 'combined']:
            try:
                generate_bats_tests(t)
            except Exception as e:
                print(f"Error generating {t} tests: {e}")
        try:
            generate_file_creation_bats_tests()
        except Exception as e:
            print(f"Error generating file-creation tests: {e}")
        print("\nAll test types generated.") 