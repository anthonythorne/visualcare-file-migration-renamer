#!/usr/bin/env bash

# Load BATS assertion functions
load '../test_helper/bats-support/load.bash'
load '../test_helper/bats-assert/load.bash'
load '../test_helper/bats-file/load.bash'

# Setup function to run before each test
setup() {
    # Create temporary directory for test files
    TEST_TEMP_DIR=$(mktemp -d)
    cd "$TEST_TEMP_DIR"
}

# Teardown function to run after each test
teardown() {
    # Clean up temporary directory
    cd - >/dev/null
    rm -rf "$TEST_TEMP_DIR"
}

# Custom assertion for checking if a string contains a substring
assert_contains() {
    local haystack="$1"
    local needle="$2"
    local message="${3:-Expected '$haystack' to contain '$needle'}"
    
    if [[ "$haystack" == *"$needle"* ]]; then
        return 0
    else
        echo "$message"
        return 1
    fi
}

# Custom assertion for checking if a string matches a pattern
assert_matches() {
    local string="$1"
    local pattern="$2"
    local message="${3:-Expected '$string' to match pattern '$pattern'}"
    
    if [[ "$string" =~ $pattern ]]; then
        return 0
    else
        echo "$message"
        return 1
    fi
}

# Custom assertion for checking if a file exists
assert_file_exists() {
    local file="$1"
    local message="${2:-Expected file '$file' to exist}"
    
    if [ -f "$file" ]; then
        return 0
    else
        echo "$message"
        return 1
    fi
}

# Custom assertion for checking if a directory exists
assert_dir_exists() {
    local dir="$1"
    local message="${2:-Expected directory '$dir' to exist}"
    
    if [ -d "$dir" ]; then
        return 0
    else
        echo "$message"
        return 1
    fi
}

# Custom assertion for checking if a file has specific permissions
assert_file_permissions() {
    local file="$1"
    local expected_perms="$2"
    local message="${3:-Expected file '$file' to have permissions '$expected_perms'}"
    
    local actual_perms=$(stat -c "%a" "$file")
    if [ "$actual_perms" = "$expected_perms" ]; then
        return 0
    else
        echo "$message (got $actual_perms)"
        return 1
    fi
}

# Custom assertion for checking if a command succeeds
assert_success() {
    local status="$1"
    local message="${2:-Expected command to succeed}"
    
    if [ "$status" -eq 0 ]; then
        return 0
    else
        echo "$message (got status $status)"
        return 1
    fi
}

# Custom assertion for checking if a command fails
assert_failure() {
    local status="$1"
    local message="${2:-Expected command to fail}"
    
    if [ "$status" -ne 0 ]; then
        return 0
    else
        echo "$message (got status $status)"
        return 1
    fi
}

# Helper function to assert that output contains a string
assert_output_contains() {
    local expected="$1"
    if [[ "$output" != *"$expected"* ]]; then
        echo "Expected output to contain '$expected', but got:"
        echo "$output"
        return 1
    fi
}

# Helper function to assert that output does not contain a string
assert_output_not_contains() {
    local unexpected="$1"
    if [[ "$output" == *"$unexpected"* ]]; then
        echo "Expected output to not contain '$unexpected', but got:"
        echo "$output"
        return 1
    fi
}

# Helper function to create a test file with content
create_test_file() {
    local file="$1"
    local content="$2"
    echo "$content" > "$file"
}

# Helper function to create a test directory
create_test_dir() {
    local dir="$1"
    mkdir -p "$dir"
} 