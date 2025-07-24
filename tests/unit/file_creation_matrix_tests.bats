#!/usr/bin/env bats

# Auto-generated integration tests for file-creation-based test matrices
# Each test runs main.py in test mode and validates output files against the expected matrix

load "${BATS_TEST_DIRNAME}/../test-helper/bats-support/load.bash"
load "${BATS_TEST_DIRNAME}/../test-helper/bats-assert/load.bash"


@test "basic: Basic test mode processing (output files match matrix)" {
    # Run main.py in test mode for this test
    run python3 ${BATS_TEST_DIRNAME}/../../main.py --test-mode --test-name basic
    [ "$status" -eq 0 ]
    # Validate output files against the matrix
    run python3 ${BATS_TEST_DIRNAME}/../scripts/validate_test_outputs.py basic
    [ "$status" -eq 0 ]
}

@test "category: Category test mode processing (output files match matrix)" {
    # Run main.py in test mode for this test
    run python3 ${BATS_TEST_DIRNAME}/../../main.py --test-mode --test-name category
    [ "$status" -eq 0 ]
    # Validate output files against the matrix
    run python3 ${BATS_TEST_DIRNAME}/../scripts/validate_test_outputs.py category
    [ "$status" -eq 0 ]
}

@test "multi-level: Multi-level test mode processing (output files match matrix)" {
    # Run main.py in test mode for this test
    run python3 ${BATS_TEST_DIRNAME}/../../main.py --test-mode --test-name multi-level
    [ "$status" -eq 0 ]
    # Validate output files against the matrix
    run python3 ${BATS_TEST_DIRNAME}/../scripts/validate_test_outputs.py multi-level
    [ "$status" -eq 0 ]
}
