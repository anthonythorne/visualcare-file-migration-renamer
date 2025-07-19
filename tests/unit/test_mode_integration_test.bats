#!/usr/bin/env bats

# Test the test mode functionality of the main CLI script
# This tests the integration with the tests/test-files structure

setup() {
    # Get the project root directory
    PROJECT_ROOT="$(cd "$(dirname "$BATS_TEST_DIRNAME")" && pwd)"
    cd "$PROJECT_ROOT"
    
    # Ensure test directories exist
    mkdir -p tests/test-files/to-basic tests/test-files/to-userid tests/test-files/to-management
}

teardown() {
    # Clean up test output directories
    rm -rf tests/test-files/to-*
}

@test "test-mode-basic: Basic test mode processing works" {
    echo "Current directory: $(pwd)"
    echo "Main.py exists: $(ls -la ../main.py 2>/dev/null || echo 'NOT FOUND')"
    run python3 ../main.py --test-mode --test-name basic --dry-run
    echo "Status: $status"
    echo "Output: $output"
    [ "$status" -eq 0 ]
    [[ "$output" == *"Processing test files using tests/test-files structure"* ]]
    [[ "$output" == *"Test name: basic"* ]]
    [[ "$output" == *"Processing Summary"* ]]
}

@test "test-mode-userid: User ID test mode processing works" {
    run python3 ../main.py --test-mode --test-name userid --dry-run
    [ "$status" -eq 0 ]
    [[ "$output" == *"Processing test files using tests/test-files structure"* ]]
    [[ "$output" == *"Test name: userid"* ]]
    [[ "$output" == *"Processing Summary"* ]]
}

@test "test-mode-management: Management flag test mode processing works" {
    run python3 ../main.py --test-mode --test-name management --dry-run
    [ "$status" -eq 0 ]
    [[ "$output" == *"Processing test files using tests/test-files structure"* ]]
    [[ "$output" == *"Test name: management"* ]]
    [[ "$output" == *"Processing Summary"* ]]
}

@test "test-mode-person-filter: Person filtering works" {
    run python3 ../main.py --test-mode --test-name person-test --person "John Doe" --dry-run
    [ "$status" -eq 0 ]
    [[ "$output" == *"Processing test files using tests/test-files structure"* ]]
    [[ "$output" == *"Filtering to person: John Doe"* ]]
    [[ "$output" == *"Processing person: John Doe"* ]]
}

@test "test-mode-person-filter-case-insensitive: Person filtering is case insensitive" {
    run python3 ../main.py --test-mode --test-name person-test --person "john doe" --dry-run
    [ "$status" -eq 0 ]
    [[ "$output" == *"Processing person: John Doe"* ]]
}

@test "test-mode-verbose: Verbose output works" {
    run python3 ../main.py --test-mode --test-name basic --dry-run --verbose
    [ "$status" -eq 0 ]
    [[ "$output" == *"Processing person:"* ]]
    [[ "$output" == *"DRY RUN - Would copy:"* ]]
}

@test "test-mode-output-directories: Correct output directories are created" {
    run python3 ../main.py --test-mode --test-name custom-test --dry-run
    [ "$status" -eq 0 ]
    
    # Check that the output directory structure is mentioned
    [[ "$output" == *"to-custom-test"* ]]
}

@test "test-mode-person-breakdown: Person breakdown is shown" {
    run python3 ../main.py --test-mode --test-name basic --dry-run
    [ "$status" -eq 0 ]
    [[ "$output" == *"Person Breakdown"* ]]
    [[ "$output" == *"John Doe:"* ]]
    [[ "$output" == *"Jane Smith:"* ]]
    [[ "$output" == *"Bob Johnson:"* ]]
}

@test "test-mode-file-counts: Correct file counts are shown" {
    run python3 ../main.py --test-mode --test-name basic --dry-run
    [ "$status" -eq 0 ]
    
    # Extract the summary section
    summary=$(echo "$output" | grep -A 20 "Processing Summary" | grep -E "Total files:|Successful:|Errors:")
    
    # Should have total files > 0
    [[ "$summary" == *"Total files:"* ]]
    [[ "$summary" == *"Total files: 3"* ]]
    
    # Should have successful files > 0
    [[ "$summary" == *"Successful:"* ]]
    [[ "$summary" == *"Successful: 3"* ]]
}

@test "test-mode-error-handling: Handles missing test files gracefully" {
    # Temporarily rename the from directory
    mv test-files/from test-files/from-backup
    
    run python3 ../main.py --test-mode --test-name basic --dry-run
    [ "$status" -eq 0 ]
    [[ "$output" == *"Test files directory not found"* ]]
    
    # Restore the directory
    mv test-files/from-backup test-files/from
}

@test "test-mode-actual-processing: Actual file processing works" {
    # Create a temporary test file
    mkdir -p "test-files/from/Temp Person"
    echo "test content" > "test-files/from/Temp Person/test_file.txt"
    
    run python3 ../main.py --test-mode --test-name actual-test --person "Temp Person"
    [ "$status" -eq 0 ]
    
    # Check that the output file was created
    [ -f "test-files/to-actual-test/Temp Person/test_file.txt" ]
    
    # Clean up
    rm -rf "test-files/from/Temp Person"
    rm -rf "test-files/to-actual-test"
} 