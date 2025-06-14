#!/usr/bin/env bats

# Load test helper functions
load 'test_helper'

# Load the script to test
load '../core/utils/config_utils.sh'

setup() {
    # Setup runs before each test
    export TEST_TEMP_DIR=$(mktemp -d)
    export CONFIG_FILE="$TEST_TEMP_DIR/config.json"
}

teardown() {
    # Cleanup runs after each test
    rm -rf "$TEST_TEMP_DIR"
}

@test "load_config loads valid JSON config" {
    local config='{"source_dir": "/test", "target_dir": "/target", "log_level": "INFO"}'
    echo "$config" > "$CONFIG_FILE"
    
    run load_config "$CONFIG_FILE"
    [ "$status" -eq 0 ]
    [ "$SOURCE_DIR" = "/test" ]
    [ "$TARGET_DIR" = "/target" ]
    [ "$LOG_LEVEL" = "INFO" ]
}

@test "load_config fails with invalid JSON" {
    local config='{"source_dir": "/test", "target_dir": "/target", "log_level": "INFO"'
    echo "$config" > "$CONFIG_FILE"
    
    run load_config "$CONFIG_FILE"
    [ "$status" -eq 1 ]
}

@test "load_config fails with missing required fields" {
    local config='{"source_dir": "/test"}'
    echo "$config" > "$CONFIG_FILE"
    
    run load_config "$CONFIG_FILE"
    [ "$status" -eq 1 ]
}

@test "load_config handles empty config file" {
    touch "$CONFIG_FILE"
    
    run load_config "$CONFIG_FILE"
    [ "$status" -eq 1 ]
}

@test "load_config handles non-existent config file" {
    run load_config "/nonexistent/config.json"
    [ "$status" -eq 1 ]
}

@test "validate_config validates correct config" {
    export SOURCE_DIR="/test"
    export TARGET_DIR="/target"
    export LOG_LEVEL="INFO"
    
    run validate_config
    [ "$status" -eq 0 ]
}

@test "validate_config fails with missing source directory" {
    export TARGET_DIR="/target"
    export LOG_LEVEL="INFO"
    
    run validate_config
    [ "$status" -eq 1 ]
}

@test "validate_config fails with missing target directory" {
    export SOURCE_DIR="/test"
    export LOG_LEVEL="INFO"
    
    run validate_config
    [ "$status" -eq 1 ]
}

@test "validate_config fails with invalid log level" {
    export SOURCE_DIR="/test"
    export TARGET_DIR="/target"
    export LOG_LEVEL="INVALID"
    
    run validate_config
    [ "$status" -eq 1 ]
}

@test "validate_config handles empty directories" {
    export SOURCE_DIR=""
    export TARGET_DIR=""
    export LOG_LEVEL="INFO"
    
    run validate_config
    [ "$status" -eq 1 ]
}

@test "validate_config handles relative paths" {
    export SOURCE_DIR="./test"
    export TARGET_DIR="../target"
    export LOG_LEVEL="INFO"
    
    run validate_config
    [ "$status" -eq 0 ]
} 