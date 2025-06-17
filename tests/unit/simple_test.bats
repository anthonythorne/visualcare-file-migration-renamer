#!/usr/bin/env bats

# Load test helper functions
load "${BATS_TEST_DIRNAME}/../test_helper/bats-support/load.bash"
load "${BATS_TEST_DIRNAME}/../test_helper/bats-assert/load.bash"
load "${BATS_TEST_DIRNAME}/../test_helper/bats-file/load.bash"

@test "simple test" {
    assert_equal "hello" "hello"
} 