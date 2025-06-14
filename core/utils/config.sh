#!/bin/bash

# Configuration utility functions

# Check if required commands are available
check_dependencies() {
    if ! command -v yq &> /dev/null; then
        log_error "yq is required but not installed. Please install it first."
        exit 1
    fi
}

# Load configuration from YAML file
load_config() {
    local config_file="$1"
    if [[ ! -f "$config_file" ]]; then
        echo "Error: Configuration file not found: $config_file" >&2
        return 1
    fi
    # For now, we'll just echo the file content as a stub
    cat "$config_file"
    return 0
}

# Function to validate the loaded configuration
validate_config() {
    # Stub validation logic
    if [[ -z "$SOURCE_DIR" || -z "$TARGET_DIR" || -z "$LOG_LEVEL" ]]; then
        echo "Error: Missing required configuration fields." >&2
        return 1
    fi
    return 0
}

# Get configuration value
get_config() {
    local key=$1
    local config_file=$2
    
    if [[ -f "$config_file" ]]; then
        yq e ".$key" "$config_file"
    else
        log_error "Configuration file not found: $config_file"
        return 1
    fi
}

# Export configuration as environment variables
export_config() {
    export VC_INPUT_DIR="$INPUT_DIR"
    export VC_OUTPUT_DIR="$OUTPUT_DIR"
    export VC_MAPPING_FILE="$MAPPING_FILE"
    export VC_DATE_FORMATS="$DATE_FORMATS"
    export VC_ALLOWED_SPECIAL_CHARS="$ALLOWED_SPECIAL_CHARS"
} 