#!/bin/bash

# Date extraction utilities for testing

extract_date_from_filename() {
    local filename="$1"
    local expected_date="$2"

    # Call the Python date matcher
    result=$(python3 "$(dirname "${BASH_SOURCE[0]}")/../../core/utils/date_matcher.py" "$filename" 2>/dev/null)
    
    if [ $? -eq 0 ]; then
    echo "$result"
        return 0
    else
        echo "||$filename|false"
        return 1
    fi
}

extract_date_from_path() {
    local full_path="$1"
    local date_to_match="$2"
    
    # Call the Python date matcher with the correct arguments
    result=$(python3 "$(dirname "${BASH_SOURCE[0]}")/../../core/utils/date_matcher.py" "$full_path" "$date_to_match" "extract_date_from_path" 2>/dev/null)
    
    if [ $? -eq 0 ]; then
        echo "$result"
    else
        echo "|||false"
    fi
}

# NEW: Simulate date extraction for string testing with date type specification
# This is for testing purposes - simulates what the real implementation would do
# when it has access to file metadata (modified/created dates)
extract_date_from_path_for_string_test_fallback() {
    local full_path="$1"
    local fallback_modified_date="$2"
    local fallback_created_date="$3"
    local string_test_date_type="$4"
    
    # If string_test_date_type is specified, use it to determine the date source
    if [ -n "$string_test_date_type" ]; then
        case "$string_test_date_type" in
            "filename")
                # Extract date from filename only
                result=$(python3 "$(dirname "${BASH_SOURCE[0]}")/../../core/utils/date_matcher.py" "$full_path" 2>/dev/null)
                if [ $? -eq 0 ]; then
                    IFS='|' read -r extracted_date raw_date cleaned_date raw_remainder cleaned_remainder error_status <<< "$result"
                    if [ -n "$extracted_date" ]; then
                        echo "$result"
                        return
                    fi
                fi
                echo "||$full_path|false|||"
                return
                ;;
            "foldername")
                # Extract date from foldername only (not implemented in current date_matcher)
                # For now, return empty
                echo "||$full_path|false|||"
                return
                ;;
            "modified")
                # Use modified_date from matrix
                if [ -n "$fallback_modified_date" ]; then
                    # Convert from YYYY-MM-DD to YYYYMMDD format
                    converted_date=$(echo "$fallback_modified_date" | sed 's/-//g')
                    echo "$converted_date|$full_path|true|||"
                    return
                fi
                ;;
            "created")
                # Use created_date from matrix
                if [ -n "$fallback_created_date" ]; then
                    # Convert from YYYY-MM-DD to YYYYMMDD format
                    converted_date=$(echo "$fallback_created_date" | sed 's/-//g')
                    echo "$converted_date|$full_path|true|||"
                    return
                fi
                ;;
        esac
    fi
    
    # Fallback to original logic if no string_test_date_type specified
    # First try to extract date from filename and foldername
    result=$(python3 "$(dirname "${BASH_SOURCE[0]}")/../../core/utils/date_matcher.py" "$full_path" 2>/dev/null)
    
    if [ $? -eq 0 ]; then
        # Parse the result
        IFS='|' read -r extracted_date raw_date cleaned_date raw_remainder cleaned_remainder error_status <<< "$result"
        
        # If we found a date in filename or foldername, use it
        if [ -n "$extracted_date" ]; then
            echo "$result"
            return
        fi
    fi
    
    # If no date found in filename/foldername, use fallback dates
    # Priority: modified_date > created_date
    if [ -n "$fallback_modified_date" ]; then
        # Convert from YYYY-MM-DD to YYYYMMDD format
        converted_date=$(echo "$fallback_modified_date" | sed 's/-//g')
        echo "$converted_date|$full_path|true|||"
    elif [ -n "$fallback_created_date" ]; then
        # Convert from YYYY-MM-DD to YYYYMMDD format
        converted_date=$(echo "$fallback_created_date" | sed 's/-//g')
        echo "$converted_date|$full_path|true|||"
    else
        echo "||$full_path|false|||"
    fi
} 