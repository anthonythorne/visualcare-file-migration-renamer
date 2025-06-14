#!/usr/bin/env bats

# Load test helper functions
load 'test_helper'

# Load the script to test
load '../core/utils/logging_utils.sh'

setup() {
    # Setup runs before each test
    export TEST_TEMP_DIR=$(mktemp -d)
    export LOG_FILE="$TEST_TEMP_DIR/test.log"
    export LOG_LEVEL="INFO"
}

teardown() {
    # Cleanup runs after each test
    rm -rf "$TEST_TEMP_DIR"
}

@test "log_message writes to log file" {
    run log_message "INFO" "Test message"
    [ "$status" -eq 0 ]                # Should succeed
    assert_file_exists "$LOG_FILE"     # Should create log file
    assert_output_contains "Test message"  # Should contain message
}

@test "log_message includes timestamp" {
    run log_message "INFO" "Test message"
    [ "$status" -eq 0 ]                # Should succeed
    assert_output_contains "$(date +'%Y-%m-%d %H:%M:%S')"  # Should include timestamp
}

@test "log_message includes log level" {
    run log_message "INFO" "Test message"
    [ "$status" -eq 0 ]                # Should succeed
    assert_output_contains "[INFO]"    # Should include log level
}

@test "log_info writes info message" {
    run log_info "Test info message"
    [ "$status" -eq 0 ]                # Should succeed
    assert_output_contains "[INFO]"    # Should include INFO level
    assert_output_contains "Test info message"  # Should contain message
}

@test "log_warning writes warning message" {
    run log_warning "Test warning message"
    [ "$status" -eq 0 ]                # Should succeed
    assert_output_contains "[WARNING]" # Should include WARNING level
    assert_output_contains "Test warning message"  # Should contain message
}

@test "log_error writes error message" {
    run log_error "Test error message"
    [ "$status" -eq 0 ]                # Should succeed
    assert_output_contains "[ERROR]"   # Should include ERROR level
    assert_output_contains "Test error message"  # Should contain message
}

@test "log_debug writes debug message when debug level is set" {
    export LOG_LEVEL="DEBUG"
    run log_debug "Test debug message"
    [ "$status" -eq 0 ]                # Should succeed
    assert_output_contains "[DEBUG]"   # Should include DEBUG level
    assert_output_contains "Test debug message"  # Should contain message
}

@test "log_debug does not write when debug level is not set" {
    export LOG_LEVEL="INFO"
    run log_debug "Test debug message"
    [ "$status" -eq 0 ]                # Should succeed
    assert_output_not_contains "[DEBUG]"  # Should not include DEBUG level
    assert_output_not_contains "Test debug message"  # Should not contain message
}

@test "log_message handles empty message" {
    run log_message "INFO" ""
    [ "$status" -eq 0 ]                # Should succeed
    assert_output_contains "[INFO]"    # Should include log level
}

@test "log_message handles special characters" {
    run log_message "INFO" "Test message with special chars: !@#$%^&*()"
    [ "$status" -eq 0 ]                # Should succeed
    assert_output_contains "Test message with special chars: !@#$%^&*()"  # Should handle special chars
} 