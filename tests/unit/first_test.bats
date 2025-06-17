#!/usr/bin/env bats

# Load test helper functions
load "${BATS_TEST_DIRNAME}/../test_helper/bats-support/load.bash"
load "${BATS_TEST_DIRNAME}/../test_helper/bats-assert/load.bash"
load "${BATS_TEST_DIRNAME}/../test_helper/bats-file/load.bash"

# Source the function to test
source "${BATS_TEST_DIRNAME}/../../core/utils/name_utils.sh"

@test "name extraction: First Name - Hyphen separator" {
    echo "Starting test..." >&2
    
    # Run the function and capture output
    run extract_name_from_filename "john-doe-report.pdf" "john doe"
    echo "Function output: $output" >&2
    
    # Split the output into components
    IFS='|' read -r actual_extracted_name actual_raw_remainder actual_matched <<< "$output"
    echo "Split components:" >&2
    echo "  Extracted name: $actual_extracted_name" >&2
    echo "  Raw remainder: $actual_raw_remainder" >&2
    echo "  Matched: $actual_matched" >&2
    
    # Debug output
    echo "[DEBUG] Testing: john-doe-report.pdf" >&2
    echo "[DEBUG] Expected match: true" >&2
    echo "[DEBUG] Expected extracted name: john,doe" >&2
    echo "[DEBUG] Expected raw remainder: --report.pdf" >&2
    echo "[DEBUG] Use case: First Name - Hyphen separator" >&2
    echo "[DEBUG] Actual output: $output" >&2
    
    # Assertions
    if [ "true" = "true" ]; then
        assert_equal "$actual_matched" "true"
        assert_equal "$actual_extracted_name" "john,doe"
        assert_equal "$actual_raw_remainder" "--report.pdf"
    else
        assert_equal "$actual_matched" "false"
        assert_equal "$actual_extracted_name" ""
        assert_equal "$actual_raw_remainder" "john-doe-report.pdf"
    fi
} 