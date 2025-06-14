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
    [ "$status" -eq 0 ]
    assert_file_exists "$LOG_FILE"
    assert_output_contains "Test message"
}

@test "log_message includes timestamp" {
    run log_message "INFO" "Test message"
    [ "$status" -eq 0 ]
    assert_output_contains "$(date +'%Y-%m-%d %H:%M:%S')"
}

@test "log_message includes log level" {
    run log_message "INFO" "Test message"
    [ "$status" -eq 0 ]
    assert_output_contains "[INFO]"
}

@test "log_info writes info message" {
    run log_info "Test info message"
    [ "$status" -eq 0 ]
    assert_output_contains "[INFO]"
    assert_output_contains "Test info message"
}

@test "log_warning writes warning message" {
    run log_warning "Test warning message"
    [ "$status" -eq 0 ]
    assert_output_contains "[WARNING]"
    assert_output_contains "Test warning message"
}

@test "log_error writes error message" {
    run log_error "Test error message"
    [ "$status" -eq 0 ]
    assert_output_contains "[ERROR]"
    assert_output_contains "Test error message"
}

@test "log_debug writes debug message when debug level is set" {
    export LOG_LEVEL="DEBUG"
    run log_debug "Test debug message"
    [ "$status" -eq 0 ]
    assert_output_contains "[DEBUG]"
    assert_output_contains "Test debug message"
}

@test "log_debug does not write when debug level is not set" {
    export LOG_LEVEL="INFO"
    run log_debug "Test debug message"
    [ "$status" -eq 0 ]
    assert_output_not_contains "[DEBUG]"
    assert_output_not_contains "Test debug message"
}

@test "log_message handles empty message" {
    run log_message "INFO" ""
    [ "$status" -eq 0 ]
    assert_output_contains "[INFO]"
}

@test "log_message handles special characters" {
    run log_message "INFO" "Test message with special chars: !@#$%^&*()"
    [ "$status" -eq 0 ]
    assert_output_contains "Test message with special chars: !@#$%^&*()"
} 