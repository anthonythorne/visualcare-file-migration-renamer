#!/bin/bash

# Complete processing wrapper for the 06 integration tests
# This calls the main normalize_filename function from main.py

extract_complete_filename() {
    local full_path="$1"
    
    # Call the main.py normalize_filename function
    result=$(python3 "$(dirname "${BASH_SOURCE[0]}")/../../main.py" --extract-filename "$full_path" 2>/dev/null)
    
    if [ $? -eq 0 ]; then
        echo "$result"
    else
        echo "|||false"
    fi
}

# Test-specific version that accepts fallback dates for string testing
extract_complete_filename_with_fallback() {
    local full_path="$1"
    local fallback_modified_date="$2"
    local fallback_created_date="$3"
    local string_test_date_type="$4"
    
    # First, get the date using our test date extraction function
    source "$(dirname "${BASH_SOURCE[0]}")/date_utils.sh"
    date_result="$(extract_date_from_path_for_string_test_fallback "$full_path" "$fallback_modified_date" "$fallback_created_date" "$string_test_date_type")"
    IFS='|' read -r extracted_date raw_date cleaned_date raw_remainder cleaned_remainder error_status <<< "$date_result"
    
    # Call the main function to get the base result
    base_result="$(extract_complete_filename "$full_path")"
    
    if [ "$base_result" = "|||false" ]; then
        echo "|||false"
        return
    fi
    
    # Check if the main function result already contains a date (YYYY-MM-DD pattern)
    if [[ "$base_result" =~ _[0-9]{4}-[0-9]{2}-[0-9]{2}_ ]]; then
        # Main function already has a date, use it as-is
        echo "$base_result"
    elif [ -n "$extracted_date" ]; then
        # Main function doesn't have a date, insert the fallback date
        # Extract the extension
        extension=""
        if [[ "$base_result" =~ \.([^_]+)$ ]]; then
            extension=".${BASH_REMATCH[1]}"
            base_without_ext="${base_result%$extension}"
        else
            base_without_ext="$base_result"
        fi
        
        # Insert the date before the category (which is before the management flag)
        # Handle the case where there's a management flag (_yes or _no) at the end
        if [[ "$base_without_ext" =~ ^(.+)_([^_]+)_(yes|no)$ ]]; then
            # Format: prefix_category_management_flag
            prefix="${BASH_REMATCH[1]}"
            category="${BASH_REMATCH[2]}"
            management_flag="${BASH_REMATCH[3]}"
            echo "${prefix}_${extracted_date}_${category}_${management_flag}${extension}"
        elif [[ "$base_without_ext" =~ ^(.+)_([^_]+)$ ]]; then
            # Format: prefix_category (no management flag)
            prefix="${BASH_REMATCH[1]}"
            category="${BASH_REMATCH[2]}"
            echo "${prefix}_${extracted_date}_${category}${extension}"
        else
            echo "$base_result"
        fi
    else
        # No date available, use base result as-is
        echo "$base_result"
    fi
} 