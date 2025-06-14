#!/usr/bin/env bats

# Load test helper functions
load 'test_helper'

# Load the script to test
load '../core/utils/file_utils.sh'

setup() {
    # Setup runs before each test
    export TEST_TEMP_DIR=$(mktemp -d)
    cd "$TEST_TEMP_DIR"
}

teardown() {
    # Cleanup runs after each test
    cd - >/dev/null
    rm -rf "$TEST_TEMP_DIR"
}

@test "is_valid_file returns true for valid files" {
    create_test_file "test.pdf" "test content"
    run is_valid_file "test.pdf"
    [ "$status" -eq 0 ]  # Should succeed for valid file
}

@test "is_valid_file returns false for non-existent files" {
    run is_valid_file "nonexistent.pdf"
    [ "$status" -eq 1 ]  # Should fail for non-existent file
}

@test "is_valid_file returns false for directories" {
    create_test_dir "test_dir"
    run is_valid_file "test_dir"
    [ "$status" -eq 1 ]  # Should fail for directory
}

@test "get_file_extension returns correct extension" {
    run get_file_extension "test.pdf"
    [ "$status" -eq 0 ]        # Should succeed
    [ "$output" = "pdf" ]      # Should return correct extension
}

@test "get_file_extension handles files without extension" {
    run get_file_extension "test"
    [ "$status" -eq 0 ]        # Should succeed
    [ "$output" = "" ]         # Should return empty string
}

@test "get_file_extension handles files with multiple dots" {
    run get_file_extension "test.backup.pdf"
    [ "$status" -eq 0 ]        # Should succeed
    [ "$output" = "pdf" ]      # Should return last extension
}

@test "is_supported_extension returns true for supported extensions" {
    run is_supported_extension "pdf"
    [ "$status" -eq 0 ]  # Should succeed for supported extension
}

@test "is_supported_extension returns false for unsupported extensions" {
    run is_supported_extension "xyz"
    [ "$status" -eq 1 ]  # Should fail for unsupported extension
}

@test "create_backup creates backup file" {
    create_test_file "test.pdf" "test content"
    run create_backup "test.pdf"
    [ "$status" -eq 0 ]  # Should succeed
    assert_file_exists "test.pdf.bak"  # Should create backup file
}

@test "create_backup preserves original file content" {
    local content="test content"
    create_test_file "test.pdf" "$content"
    run create_backup "test.pdf"
    [ "$status" -eq 0 ]                # Should succeed
    [ "$(cat test.pdf)" = "$content" ] # Should preserve original content
}

@test "create_backup creates backup with correct content" {
    local content="test content"
    create_test_file "test.pdf" "$content"
    run create_backup "test.pdf"
    [ "$status" -eq 0 ]                    # Should succeed
    [ "$(cat test.pdf.bak)" = "$content" ] # Should copy content to backup
}

@test "restore_from_backup restores file from backup" {
    local content="test content"
    create_test_file "test.pdf" "new content"
    create_test_file "test.pdf.bak" "$content"
    run restore_from_backup "test.pdf"
    [ "$status" -eq 0 ]                # Should succeed
    [ "$(cat test.pdf)" = "$content" ] # Should restore from backup
}

@test "restore_from_backup fails if backup doesn't exist" {
    create_test_file "test.pdf" "test content"
    run restore_from_backup "test.pdf"
    [ "$status" -eq 1 ]  # Should fail when backup doesn't exist
} 