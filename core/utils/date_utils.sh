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

    # Call the Python matcher
    python3 "${utils_dir}/date_matcher.py" "$filename"
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