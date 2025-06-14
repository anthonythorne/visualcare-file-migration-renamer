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
    local config_file=$1
    
    # Check if config file exists
    if [[ ! -f "$config_file" ]]; then
        log_error "Configuration file not found: $config_file"
        return 1
    fi
    
    # Check dependencies
    check_dependencies
    
    # Load configuration
    log_debug "Loading configuration from $config_file"
    
    # Read configuration values
    INPUT_DIR=$(yq e '.input_dir' "$config_file")
    OUTPUT_DIR=$(yq e '.output_dir' "$config_file")
    MAPPING_FILE=$(yq e '.mapping_file' "$config_file")
    DATE_FORMATS=$(yq e '.date_formats[]' "$config_file")
    ALLOWED_SPECIAL_CHARS=$(yq e '.allowed_special_chars' "$config_file")
    
    # Validate required fields
    if [[ -z "$INPUT_DIR" ]] || [[ -z "$OUTPUT_DIR" ]]; then
        log_error "Required configuration fields missing"
        return 1
    fi
    
    # Create output directory if it doesn't exist
    if [[ ! -d "$OUTPUT_DIR" ]]; then
        mkdir -p "$OUTPUT_DIR"
    fi
    
    log_info "Configuration loaded successfully"
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