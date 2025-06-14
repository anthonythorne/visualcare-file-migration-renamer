#!/bin/bash

# Validation utility functions

# Validate file exists and is readable
validate_file() {
    local file=$1
    local description=${2:-"File"}
    
    if [[ ! -f "$file" ]]; then
        log_error "$description does not exist: $file"
        return 1
    fi
    
    if [[ ! -r "$file" ]]; then
        log_error "$description is not readable: $file"
        return 1
    fi
    
    return 0
}

# Validate directory exists and is writable
validate_directory() {
    local dir=$1
    local description=${2:-"Directory"}
    
    if [[ ! -d "$dir" ]]; then
        log_error "$description does not exist: $dir"
        return 1
    fi
    
    if [[ ! -w "$dir" ]]; then
        log_error "$description is not writable: $dir"
        return 1
    fi
    
    return 0
}

# Validate file extension
validate_extension() {
    local file=$1
    local allowed_extensions=$2
    
    local extension="${file##*.}"
    extension=$(echo "$extension" | tr '[:upper:]' '[:lower:]')
    
    if [[ ! " $allowed_extensions " =~ " $extension " ]]; then
        log_error "Unsupported file extension: $extension"
        return 1
    fi
    
    return 0
}

# Validate date format
validate_date() {
    local date=$1
    local format=$2
    
    if ! date -d "$date" &> /dev/null; then
        log_error "Invalid date format: $date"
        return 1
    fi
    
    return 0
}

# Validate mapping file format
validate_mapping_file() {
    local file=$1
    
    if ! validate_file "$file" "Mapping file"; then
        return 1
    fi
    
    # Check if file is CSV or JSON
    if [[ "$file" == *.csv ]]; then
        if ! command -v csvlint &> /dev/null; then
            log_warn "csvlint not installed, skipping CSV validation"
            return 0
        fi
        
        if ! csvlint "$file" &> /dev/null; then
            log_error "Invalid CSV format in mapping file"
            return 1
        fi
    elif [[ "$file" == *.json ]]; then
        if ! jq empty "$file" 2>/dev/null; then
            log_error "Invalid JSON format in mapping file"
            return 1
        fi
    else
        log_error "Unsupported mapping file format"
        return 1
    fi
    
    return 0
}

# Validate plugin file
validate_plugin() {
    local plugin=$1
    
    if ! validate_file "$plugin" "Plugin file"; then
        return 1
    fi
    
    # Check if file is executable
    if [[ ! -x "$plugin" ]]; then
        log_error "Plugin file is not executable: $plugin"
        return 1
    fi
    
    return 0
} 