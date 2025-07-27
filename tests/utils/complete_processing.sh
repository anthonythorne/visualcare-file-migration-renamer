#!/bin/bash

# Complete processing wrapper for the 06 integration tests
# This calls the main normalize_filename function from main.py

extract_complete_filename() {
    local full_path="$1"
    
    # Call the main.py normalize_filename function
    result=$(python3 "$(dirname "$0")/../../main.py" --extract-filename "$full_path" 2>/dev/null)
    
    if [ $? -eq 0 ]; then
        echo "$result"
    else
        echo "|||false"
    fi
} 