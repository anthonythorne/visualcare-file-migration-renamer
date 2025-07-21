#!/usr/bin/env bats

# Test the test mode functionality of the main CLI script
# This tests the integration with the tests/test-files structure
# Following the CRITICAL TESTING REQUIREMENTS from docs/TESTING.md

setup() {
    # Get the project root directory (parent of tests directory)
    PROJECT_ROOT="$(cd "$(dirname "$BATS_TEST_DIRNAME")/.." && pwd)"
    cd "$PROJECT_ROOT"
    
    # Clean existing input and output test directories for fresh start
    rm -rf tests/test-files/from-*
    rm -rf tests/test-files/to-*
    
    # Run setup scripts to create test files from CSV matrices
    python3 tests/scripts/setup_basic_test_files.py
    python3 tests/scripts/setup_category_test_files.py
    python3 tests/scripts/setup_multi_level_test_files.py
}

# Note: No teardown function - we want to preserve test outputs for inspection

@test "test-mode-basic: Basic test mode processing with actual file creation" {
    # Basic test creates 8 files (hardcoded in setup script)
    expected_count=8
    
    # Run actual processing (not dry-run) with real extraction logic
    run python3 "$PROJECT_ROOT/main.py" --test-mode --test-name basic
    [ "$status" -eq 0 ]
    
    # Count actual output files
    actual_count=$(find "$PROJECT_ROOT/tests/test-files/to-basic" -type f | wc -l)
    
    # Validate file count matches expected count
    [ "$actual_count" -eq "$expected_count" ]
    
    # Verify output directory exists and contains files
    [ -d "$PROJECT_ROOT/tests/test-files/to-basic" ]
    [ "$actual_count" -gt 0 ]
    
    # Check that processing summary shows correct counts
    [[ "$output" == *"Total files: $expected_count"* ]]
    [[ "$output" == *"Successful: $expected_count"* ]]
    [[ "$output" == *"Errors: 0"* ]]
    # Validate output filenames
    run python3 "$PROJECT_ROOT/tests/scripts/validate_test_outputs.py" basic
    [ "$status" -eq 0 ]
}

@test "test-mode-category: Category test mode processing with actual file creation" {
    # Count expected files from CSV matrix (50 data lines)
    expected_count=50
    
    # Run actual processing (not dry-run) with real extraction logic
    run python3 "$PROJECT_ROOT/main.py" --test-mode --test-name category
    [ "$status" -eq 0 ]
    
    # Count actual output files
    actual_count=$(find "$PROJECT_ROOT/tests/test-files/to-category" -type f | wc -l)
    
    # Validate file count matches CSV matrix
    [ "$actual_count" -eq "$expected_count" ]
    
    # Verify output directory exists and contains files
    [ -d "$PROJECT_ROOT/tests/test-files/to-category" ]
    [ "$actual_count" -gt 0 ]
    
    # Check that processing summary shows correct counts
    [[ "$output" == *"Total files: $expected_count"* ]]
    [[ "$output" == *"Successful: $expected_count"* ]]
    [[ "$output" == *"Errors: 0"* ]]
    # Validate output filenames
    run python3 "$PROJECT_ROOT/tests/scripts/validate_test_outputs.py" category
    [ "$status" -eq 0 ]
}

@test "test-mode-multi-level: Multi-level test mode processing with actual file creation" {
    # Count expected files from CSV matrix (30 data lines)
    expected_count=30
    
    # Run actual processing (not dry-run) with real extraction logic
    run python3 "$PROJECT_ROOT/main.py" --test-mode --test-name multi-level
    [ "$status" -eq 0 ]
    
    # Count actual output files
    actual_count=$(find "$PROJECT_ROOT/tests/test-files/to-multi-level" -type f | wc -l)
    
    # Validate file count matches CSV matrix
    [ "$actual_count" -eq "$expected_count" ]
    
    # Verify output directory exists and contains files
    [ -d "$PROJECT_ROOT/tests/test-files/to-multi-level" ]
    [ "$actual_count" -gt 0 ]
    
    # Check that processing summary shows correct counts
    [[ "$output" == *"Total files: $expected_count"* ]]
    [[ "$output" == *"Successful: $expected_count"* ]]
    [[ "$output" == *"Errors: 0"* ]]
    # Validate output filenames
    run python3 "$PROJECT_ROOT/tests/scripts/validate_test_outputs.py" multi-level
    [ "$status" -eq 0 ]
}

@test "test-mode-person-filter: Person filtering with actual file creation" {
    # Count expected files for John Doe (4 files in basic test)
    expected_count=4
    
    # Run actual processing with person filter (not dry-run) with real extraction logic
    run python3 "$PROJECT_ROOT/main.py" --test-mode --test-name basic --person "John Doe"
    [ "$status" -eq 0 ]
    
    # Count actual output files for John Doe
    actual_count=$(find "$PROJECT_ROOT/tests/test-files/to-basic/John Doe" -type f 2>/dev/null | wc -l)
    
    # Validate file count matches CSV matrix for this person
    [ "$actual_count" -eq "$expected_count" ]
    
    # Verify output directory exists and contains files
    [ -d "$PROJECT_ROOT/tests/test-files/to-basic/John Doe" ]
    [ "$actual_count" -gt 0 ]
    
    # Check that processing summary shows correct person
    [[ "$output" == *"Processing person: John Doe"* ]]
}

@test "test-mode-person-filter-case-insensitive: Person filtering case insensitive with actual file creation" {
    # Count expected files for Jane Smith from CSV matrix
    expected_count=$(grep -c "Jane Smith" tests/fixtures/category_test_cases.csv)
    
    # Run actual processing with case insensitive person filter (not dry-run) with real extraction logic
    run python3 "$PROJECT_ROOT/main.py" --test-mode --test-name category --person "jane smith"
    [ "$status" -eq 0 ]
    
    # Count actual output files for Jane Smith
    actual_count=$(find "$PROJECT_ROOT/tests/test-files/to-category/Jane Smith" -type f 2>/dev/null | wc -l)
    
    # Validate file count matches CSV matrix for this person
    [ "$actual_count" -eq "$expected_count" ]
    
    # Verify output directory exists and contains files
    [ -d "$PROJECT_ROOT/tests/test-files/to-category/Jane Smith" ]
    [ "$actual_count" -gt 0 ]
    
    # Check that processing summary shows correct person
    [[ "$output" == *"Processing person: Jane Smith"* ]]
}

@test "test-mode-verbose: Verbose output with actual file creation" {
    # Basic test creates 8 files (hardcoded in setup script)
    expected_count=8
    
    # Run actual processing with verbose output (not dry-run) with real extraction logic
    run python3 "$PROJECT_ROOT/main.py" --test-mode --test-name basic --verbose
    [ "$status" -eq 0 ]
    
    # Count actual output files
    actual_count=$(find "$PROJECT_ROOT/tests/test-files/to-basic" -type f | wc -l)
    
    # Validate file count matches CSV matrix
    [ "$actual_count" -eq "$expected_count" ]
    
    # Check that verbose output shows actual processing
    [[ "$output" == *"Processing person:"* ]]
    [[ "$output" == *"Copied:"* ]]
    [[ "$output" != *"DRY RUN"* ]]
    
    # Verify output directory exists and contains files
    [ -d "$PROJECT_ROOT/tests/test-files/to-basic" ]
    [ "$actual_count" -gt 0 ]
}

@test "test-mode-output-directories: Correct output directories are created with actual files" {
    # Create a minimal input directory for the test
    mkdir -p "$PROJECT_ROOT/tests/test-files/from-custom-test/Temp Person"
    echo "test content" > "$PROJECT_ROOT/tests/test-files/from-custom-test/Temp Person/test_file.txt"
    
    # Run actual processing (not dry-run) - no CSV data for custom test
    run python3 "$PROJECT_ROOT/main.py" --test-mode --test-name custom-test
    [ "$status" -eq 0 ]
    
    # Verify output directory was created
    [ -d "$PROJECT_ROOT/tests/test-files/to-custom-test" ]
    
    # Verify output file was created
    [ -f "$PROJECT_ROOT/tests/test-files/to-custom-test/Temp Person/test_file.txt" ]
    
    # Check that processing summary shows correct output directory
    [[ "$output" == *"to-custom-test"* ]]
}

@test "test-mode-person-breakdown: Person breakdown shows actual processing results" {
    # Run actual processing (not dry-run) with real extraction logic
    run python3 "$PROJECT_ROOT/main.py" --test-mode --test-name basic
    [ "$status" -eq 0 ]
    
    # Check that person breakdown is shown with actual counts
    [[ "$output" == *"Person Breakdown"* ]]
    [[ "$output" == *"John Doe:"* ]]
    [[ "$output" == *"Jane Smith:"* ]]
    [[ "$output" == *"Temp Person:"* ]]
    
    # Verify output files exist for each person
    [ -d "$PROJECT_ROOT/tests/test-files/to-basic/John Doe" ]
    [ -d "$PROJECT_ROOT/tests/test-files/to-basic/Jane Smith" ]
    [ -d "$PROJECT_ROOT/tests/test-files/to-basic/Temp Person" ]
}

@test "test-mode-file-counts: Correct file counts from actual processing" {
    # Basic test creates 8 files (hardcoded in setup script)
    expected_count=8
    
    # Run actual processing (not dry-run) with real extraction logic
    run python3 "$PROJECT_ROOT/main.py" --test-mode --test-name basic
    [ "$status" -eq 0 ]
    
    # Count actual output files
    actual_count=$(find "$PROJECT_ROOT/tests/test-files/to-basic" -type f | wc -l)
    
    # Validate file count matches CSV matrix
    [ "$actual_count" -eq "$expected_count" ]
    
    # Check that processing summary shows correct counts
    [[ "$output" == *"Total files: $expected_count"* ]]
    [[ "$output" == *"Successful: $expected_count"* ]]
    [[ "$output" == *"Errors: 0"* ]]
}

@test "test-mode-error-handling: Handles missing test files gracefully" {
    # Test with a non-existent test name that has no input files
    run python3 "$PROJECT_ROOT/main.py" --test-mode --test-name nonexistent-test
    [ "$status" -eq 0 ]
    [[ "$output" == *"Test files directory not found"* ]]
    
    # Verify no output directory was created
    [ ! -d "$PROJECT_ROOT/tests/test-files/to-nonexistent-test" ]
}

@test "test-mode-csv-matrix-validation: Output files match CSV matrix expectations" {
    # Run category test with actual processing using CSV data
    run python3 "$PROJECT_ROOT/main.py" --test-mode --test-name category
    [ "$status" -eq 0 ]
    
    # Verify that output files exist and are accessible
    output_dir="$PROJECT_ROOT/tests/test-files/to-category"
    [ -d "$output_dir" ]
    
    # Check that all person directories exist
    [ -d "$output_dir/John Doe" ]
    [ -d "$output_dir/Jane Smith" ]
    [ -d "$output_dir/Bob Johnson" ]
    
    # Verify files are readable and have content
    for person_dir in "$output_dir"/*; do
        if [ -d "$person_dir" ]; then
            for file in "$person_dir"/*; do
                if [ -f "$file" ]; then
                    [ -r "$file" ]
                    [ -s "$file" ]  # File has content (not empty)
                fi
            done
        fi
    done
}

@test "test-mode-processing-success: No errors during actual file processing" {
    # Run all test modes to ensure no processing errors with CSV data
    for test_name in basic category multi-level; do
        echo "Testing $test_name mode..."
        run python3 "$PROJECT_ROOT/main.py" --test-mode --test-name "$test_name"
        [ "$status" -eq 0 ]
        [[ "$output" == *"Errors: 0"* ]]
    done
} 