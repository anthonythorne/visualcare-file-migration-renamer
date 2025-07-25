#!/usr/bin/env bash

# extract_date_from_filename
#
# Extracts one or more dates from a filename based on a comprehensive set of supported formats.
# The function identifies dates, removes them from the filename to create a "raw remainder"
# with original separators intact, and returns the findings in a structured, pipe-delimited format.
#
# Supported Formats:
#   - YYYY-MM-DD, YYYY/MM/DD, YYYYMMDD
#   - DD-MM-YYYY, DD/MM/YYYY, DDMMYYYY
#   - MM-DD-YYYY, MM/DD/YYYY, MMDDYYYY
#   - Written months (e.g., "Jan", "Feb") with or without ordinal day (e.g., "1st", "2nd")
#
# Parameters:
#   $1 - The filename to process.
#
# Output:
#   A pipe-delimited string: "extracted_dates|raw_remainder|match_status"
#   - extracted_dates: A comma-separated list of dates found (in YYYY-MM-DD format).
#   - raw_remainder: The filename with the date(s) removed, preserving separators.
#   - match_status: "true" if at least one date was found, otherwise "false".
#
extract_date_from_filename() {
    local filename="$1"
    local utils_dir
    utils_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

    # Call the Python matcher and return the full result
    local result
    result=$(python3 "${utils_dir}/date_matcher.py" "$filename")
    
    # Return the full result
    echo "$result"
}

clean_date_filename_remainder() {
    local remainder="$1"

    # 1. Remove leading and trailing separators (hyphen, underscore, space, dot)
    remainder=$(echo "$remainder" | sed -E 's/^[-_ .]+//')
    remainder=$(echo "$remainder" | sed -E 's/[-_ .]+$//')

    # 2. Collapse multiple consecutive separators to a single one of the same type
    remainder=$(echo "$remainder" | sed -E 's/([-_ .])\1+/\1/g')

    # 3. Remove a separator (hyphen, underscore, space) immediately before a file extension (dot + 2-4 letters)
    remainder=$(echo "$remainder" | sed -E 's/[-_ ]+(\.[a-zA-Z0-9]{2,4})$/\1/')

    echo "$remainder"
}

# Extract date from full path (folders and filename)
# Usage: extract_date_from_path <full_path> <date_to_match>
# Output: extracted_dates|raw_remainder|matched
extract_date_from_path() {
    local full_path="$1"
    local date_to_match="$2"
    local utils_dir
    utils_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    python3 "$utils_dir/date_matcher.py" "$full_path" "$date_to_match" "extract_date_from_path"
}

export -f extract_date_from_filename
export -f clean_date_filename_remainder 
export -f extract_date_from_path 