#!/bin/bash

# Pre-processing hook: Validate filenames
# This plugin validates filenames before processing to ensure they meet basic requirements

# Source required utilities
source "$(dirname "$0")/../../core/utils/logging.sh"
source "$(dirname "$0")/../../core/utils/validation.sh"

# Hook function that will be called for each file
pre_process_file() {
    local file=$1
    
    log_debug "Validating filename: $file"
    
    # Get filename without path
    local filename=$(basename "$file")
    
    # Check for empty filename
    if [[ -z "$filename" ]]; then
        log_error "Empty filename detected"
        return 1
    fi
    
    # Check for maximum length (255 characters is typical filesystem limit)
    if [[ ${#filename} -gt 255 ]]; then
        log_error "Filename exceeds maximum length: $filename"
        return 1
    }
    
    # Check for invalid characters
    if [[ "$filename" =~ [<>:"/\\|?*] ]]; then
        log_error "Filename contains invalid characters: $filename"
        return 1
    }
    
    # Check for leading/trailing spaces
    if [[ "$filename" =~ ^[[:space:]] ]] || [[ "$filename" =~ [[:space:]]$ ]]; then
        log_error "Filename contains leading or trailing spaces: $filename"
        return 1
    }
    
    # Check for consecutive spaces
    if [[ "$filename" =~ [[:space:]]{2,} ]]; then
        log_error "Filename contains consecutive spaces: $filename"
        return 1
    }
    
    log_debug "Filename validation passed: $filename"
    return 0
}

# Register the hook
register_pre_process_hook "pre_process_file" 