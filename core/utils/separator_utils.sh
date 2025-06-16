#!/bin/bash

# Load YAML configuration
load_separator_config() {
    local config_file="$1"
    if [ ! -f "$config_file" ]; then
        log_error "Separator configuration file not found: $config_file"
        return 1
    fi

    # Load standard separators (always enabled)
    local standard_separators=()
    while IFS= read -r line; do
        if [[ $line =~ ^[[:space:]]*-[[:space:]]*\"([^\"]+)\" ]]; then
            standard_separators+=("${BASH_REMATCH[1]}")
        fi
    done < <(yq e '.default_separators.standard[]' "$config_file")

    # Load non-standard separators (configurable)
    local non_standard_separators=()
    while IFS= read -r line; do
        if [[ $line =~ ^[[:space:]]*-[[:space:]]*\"([^\"]+)\" ]]; then
            non_standard_separators+=("${BASH_REMATCH[1]}")
        fi
    done < <(yq e '.default_separators.non_standard[]' "$config_file")

    # Load custom separators (company-specific)
    local custom_separators=()
    while IFS= read -r line; do
        if [[ $line =~ ^[[:space:]]*-[[:space:]]*\"([^\"]+)\" ]]; then
            custom_separators+=("${BASH_REMATCH[1]}")
        fi
    done < <(yq e '.custom_separators[]' "$config_file")

    # Load separator rules
    local allow_multiple
    allow_multiple=$(yq e '.rules.allow_multiple' "$config_file")
    local normalize_output
    normalize_output=$(yq e '.rules.normalize_output' "$config_file")
    local default_output_separator
    default_output_separator=$(yq e '.rules.default_output_separator' "$config_file")
    local preserve_remainder_separators
    preserve_remainder_separators=$(yq e '.rules.preserve_remainder_separators' "$config_file")

    # Export variables for use in other scripts
    export SEPARATOR_CONFIG_FILE="$config_file"
    export SEPARATOR_STANDARD=("${standard_separators[@]}")
    export SEPARATOR_NON_STANDARD=("${non_standard_separators[@]}")
    export SEPARATOR_CUSTOM=("${custom_separators[@]}")
    export SEPARATOR_ALLOW_MULTIPLE="$allow_multiple"
    export SEPARATOR_NORMALIZE_OUTPUT="$normalize_output"
    export SEPARATOR_DEFAULT_OUTPUT="$default_output_separator"
    export SEPARATOR_PRESERVE_REMAINDER="$preserve_remainder_separators"
}

# Get all valid separators
get_all_separators() {
    local separators=()
    separators+=("${SEPARATOR_STANDARD[@]}")
    separators+=("${SEPARATOR_NON_STANDARD[@]}")
    separators+=("${SEPARATOR_CUSTOM[@]}")
    printf '%s\n' "${separators[@]}"
}

# Check if a character is a valid separator
is_valid_separator() {
    local char="$1"
    local separators
    mapfile -t separators < <(get_all_separators)
    for sep in "${separators[@]}"; do
        if [ "$char" = "$sep" ]; then
            return 0
        fi
    done
    return 1
}

# Normalize separators in a string
normalize_separators() {
    local input="$1"
    if [ "$SEPARATOR_NORMALIZE_OUTPUT" = "true" ]; then
        local separators
        mapfile -t separators < <(get_all_separators)
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

# Preserve separators in remainder
preserve_remainder_separators() {
    local input="$1"
    if [ "$SEPARATOR_PRESERVE_REMAINDER" = "true" ]; then
        echo "$input"
    else
        normalize_separators "$input"
    fi
} 