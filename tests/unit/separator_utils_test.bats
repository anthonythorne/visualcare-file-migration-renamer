#!/usr/bin/env bats

# Load test helper
load '../test_helper.bash'

# Load the script under test
load '../../core/utils/separator_utils.sh'

setup() {
    # Create a temporary config file
    export TEST_CONFIG_FILE=$(mktemp)
    cat > "$TEST_CONFIG_FILE" << EOF
default_separators:
  standard:
    - "-"
    - "_"
    - "."
    - " "
  non_standard:
    - "*"
    - "@"
    - "#"
custom_separators:
  - ":"
  - ";"
rules:
  allow_multiple: true
  normalize_output: true
  default_output_separator: "-"
  preserve_remainder_separators: true
EOF
}

teardown() {
    rm -f "$TEST_CONFIG_FILE"
}

@test "load_separator_config loads standard separators" {
    load_separator_config "$TEST_CONFIG_FILE"
    [ "${#SEPARATOR_STANDARD[@]}" -eq 4 ]
    [ "${SEPARATOR_STANDARD[0]}" = "-" ]
    [ "${SEPARATOR_STANDARD[1]}" = "_" ]
    [ "${SEPARATOR_STANDARD[2]}" = "." ]
    [ "${SEPARATOR_STANDARD[3]}" = " " ]
}

@test "load_separator_config loads non-standard separators" {
    load_separator_config "$TEST_CONFIG_FILE"
    [ "${#SEPARATOR_NON_STANDARD[@]}" -eq 3 ]
    [ "${SEPARATOR_NON_STANDARD[0]}" = "*" ]
    [ "${SEPARATOR_NON_STANDARD[1]}" = "@" ]
    [ "${SEPARATOR_NON_STANDARD[2]}" = "#" ]
}

@test "load_separator_config loads custom separators" {
    load_separator_config "$TEST_CONFIG_FILE"
    [ "${#SEPARATOR_CUSTOM[@]}" -eq 2 ]
    [ "${SEPARATOR_CUSTOM[0]}" = ":" ]
    [ "${SEPARATOR_CUSTOM[1]}" = ";" ]
}

@test "load_separator_config loads rules" {
    load_separator_config "$TEST_CONFIG_FILE"
    [ "$SEPARATOR_ALLOW_MULTIPLE" = "true" ]
    [ "$SEPARATOR_NORMALIZE_OUTPUT" = "true" ]
    [ "$SEPARATOR_DEFAULT_OUTPUT" = "-" ]
    [ "$SEPARATOR_PRESERVE_REMAINDER" = "true" ]
}

@test "is_valid_separator identifies valid separators" {
    load_separator_config "$TEST_CONFIG_FILE"
    run is_valid_separator "-"
    [ "$status" -eq 0 ]
    run is_valid_separator "_"
    [ "$status" -eq 0 ]
    run is_valid_separator "*"
    [ "$status" -eq 0 ]
    run is_valid_separator ":"
    [ "$status" -eq 0 ]
}

@test "is_valid_separator identifies invalid separators" {
    load_separator_config "$TEST_CONFIG_FILE"
    run is_valid_separator "x"
    [ "$status" -eq 1 ]
    run is_valid_separator "1"
    [ "$status" -eq 1 ]
}

@test "normalize_separators normalizes to default separator" {
    load_separator_config "$TEST_CONFIG_FILE"
    run normalize_separators "john_doe"
    [ "$output" = "john-doe" ]
    run normalize_separators "john*doe"
    [ "$output" = "john-doe" ]
    run normalize_separators "john:doe"
    [ "$output" = "john-doe" ]
}

@test "normalize_separators handles multiple separators" {
    load_separator_config "$TEST_CONFIG_FILE"
    run normalize_separators "john__doe"
    [ "$output" = "john--doe" ]
    run normalize_separators "john***doe"
    [ "$output" = "john---doe" ]
}

@test "preserve_remainder_separators preserves original separators" {
    load_separator_config "$TEST_CONFIG_FILE"
    run preserve_remainder_separators "john_doe"
    [ "$output" = "john_doe" ]
    run preserve_remainder_separators "john*doe"
    [ "$output" = "john*doe" ]
}

@test "preserve_remainder_separators normalizes when preservation is disabled" {
    # Modify config to disable preservation
    sed -i 's/preserve_remainder_separators: true/preserve_remainder_separators: false/' "$TEST_CONFIG_FILE"
    load_separator_config "$TEST_CONFIG_FILE"
    run preserve_remainder_separators "john_doe"
    [ "$output" = "john-doe" ]
    run preserve_remainder_separators "john*doe"
    [ "$output" = "john-doe" ]
} 