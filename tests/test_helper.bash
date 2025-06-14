#!/usr/bin/env bash

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

# Helper function to assert that a file exists
assert_file_exists() {
    local file="$1"
    if [[ ! -f "$file" ]]; then
        echo "Expected file '$file' to exist, but it doesn't"
        return 1
    fi
}

# Helper function to assert that a file does not exist
assert_file_not_exists() {
    local file="$1"
    if [[ -f "$file" ]]; then
        echo "Expected file '$file' to not exist, but it does"
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