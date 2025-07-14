#!/bin/bash

# Load YAML configuration for separators from new components.yaml
load_separator_config() {
    local config_file="$1"
    if [ ! -f "$config_file" ]; then
        log_error "Separator configuration file not found: $config_file"
        return 1
    fi

    # Load name separators for searching
    local name_separators_searching=()
    while IFS= read -r line; do
        if [[ $line =~ ^[[:space:]]*-[[:space:]]*"([^"]+)" ]]; then
            name_separators_searching+=("${BASH_REMATCH[1]}")
        fi
    done < <(yq e '.Name.allowed_separators_when_searching[]' "$config_file")

    # Load allowed separators for plucked name (from directory)
    local name_allowed_separators=()
    while IFS= read -r line; do
        if [[ $line =~ ^[[:space:]]*-[[:space:]]*"([^"]+)" ]]; then
            name_allowed_separators+=("${BASH_REMATCH[1]}")
        fi
    done < <(yq e '.Name.allowed_separators[]' "$config_file")

    # Load remainder allowed separators
    local remainder_allowed_separators=()
    while IFS= read -r line; do
        if [[ $line =~ ^[[:space:]]*-[[:space:]]*"([^"]+)" ]]; then
            remainder_allowed_separators+=("${BASH_REMATCH[1]}")
        fi
    done < <(yq e '.Remainder.allowed_separators[]' "$config_file")

    # Load other rules
    local allow_multiple
    allow_multiple=$(yq e '.Name.allow_multiple' "$config_file")
    local normalize_output
    normalize_output=$(yq e '.Name.normalize_output' "$config_file")
    local default_output_separator
    default_output_separator=$(yq e '.Name.default_output_separator' "$config_file")
    local preserve_remainder_separators
    preserve_remainder_separators=$(yq e '.Remainder.preserve_remainder_separators' "$config_file")

    # Export variables for use in other scripts
    export SEPARATOR_CONFIG_FILE="$config_file"
    export NAME_SEPARATORS_SEARCHING=("${name_separators_searching[@]}")
    export NAME_ALLOWED_SEPARATORS=("${name_allowed_separators[@]}")
    export REMAINDER_ALLOWED_SEPARATORS=("${remainder_allowed_separators[@]}")
    export SEPARATOR_ALLOW_MULTIPLE="$allow_multiple"
    export SEPARATOR_NORMALIZE_OUTPUT="$normalize_output"
    export SEPARATOR_DEFAULT_OUTPUT="$default_output_separator"
    export SEPARATOR_PRESERVE_REMAINDER="$preserve_remainder_separators"
}

# Get all valid separators for searching name parts
get_name_separators_searching() {
    printf '%s\n' "${NAME_SEPARATORS_SEARCHING[@]}"
}

# Get allowed separators for plucked name
get_name_allowed_separators() {
    printf '%s\n' "${NAME_ALLOWED_SEPARATORS[@]}"
}

# Get allowed separators for remainder
get_remainder_allowed_separators() {
    printf '%s\n' "${REMAINDER_ALLOWED_SEPARATORS[@]}"
}

# Normalize separators in a string (for name searching)
normalize_separators() {
    local input="$1"
    if [ "$SEPARATOR_NORMALIZE_OUTPUT" = "true" ]; then
        local separators
        mapfile -t separators < <(get_name_separators_searching)
        for sep in "${separators[@]}"; do
            input="${input//$sep/$SEPARATOR_DEFAULT_OUTPUT}"
        done
        # Remove multiple consecutive default separators if not allowed
        if [ "$SEPARATOR_ALLOW_MULTIPLE" = "false" ]; then
            local pattern="$SEPARATOR_DEFAULT_OUTPUT$SEPARATOR_DEFAULT_OUTPUT"
            while [[ "$input" =~ $pattern ]]; do
                input="${input//$pattern/$SEPARATOR_DEFAULT_OUTPUT}"
            done
        fi
    fi
    echo "$input"
}

# Preserve separators in remainder (collapse duplicates)
preserve_remainder_separators() {
    local input="$1"
    if [ "$SEPARATOR_PRESERVE_REMAINDER" = "true" ]; then
        # Collapse duplicate allowed separators
        local separators
        mapfile -t separators < <(get_remainder_allowed_separators)
        for sep in "${separators[@]}"; do
            local pattern="$sep$sep"
            while [[ "$input" =~ $pattern ]]; do
                input="${input//$pattern/$sep}"
            done
        done
        echo "$input"
    else
        normalize_separators "$input"
    fi
} 