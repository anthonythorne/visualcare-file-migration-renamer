#!/usr/bin/env bash

# Extract date from a filename
extract_date_from_filename() {
    local filename="$1"
    local date=""

    # Convert filename to lowercase for case-insensitive matching
    local filename_lower=$(echo "$filename" | tr '[:upper:]' '[:lower:]')

    # Standard date formats
    if [[ "$filename_lower" =~ ([0-9]{8}) ]]; then
        date="${BASH_REMATCH[1]}"
    elif [[ "$filename_lower" =~ ([0-9]{4})-([0-9]{2})-([0-9]{2}) ]]; then
        date="${BASH_REMATCH[1]}${BASH_REMATCH[2]}${BASH_REMATCH[3]}"
    elif [[ "$filename_lower" =~ ([0-9]{4})/([0-9]{2})/([0-9]{2}) ]]; then
        date="${BASH_REMATCH[1]}${BASH_REMATCH[2]}${BASH_REMATCH[3]}"
    elif [[ "$filename_lower" =~ ([0-9]{2})([0-9]{2})([0-9]{4}) ]]; then
        date="${BASH_REMATCH[3]}${BASH_REMATCH[2]}${BASH_REMATCH[1]}"
    elif [[ "$filename_lower" =~ ([0-9]{2})-([0-9]{2})-([0-9]{4}) ]]; then
        date="${BASH_REMATCH[3]}${BASH_REMATCH[2]}${BASH_REMATCH[1]}"
    elif [[ "$filename_lower" =~ ([0-9]{2})/([0-9]{2})/([0-9]{4}) ]]; then
        date="${BASH_REMATCH[3]}${BASH_REMATCH[2]}${BASH_REMATCH[1]}"
    elif [[ "$filename_lower" =~ ([0-9]{2})([0-9]{2})([0-9]{4}) ]]; then
        date="${BASH_REMATCH[3]}${BASH_REMATCH[1]}${BASH_REMATCH[2]}"
    elif [[ "$filename_lower" =~ ([0-9]{2})-([0-9]{2})-([0-9]{4}) ]]; then
        date="${BASH_REMATCH[3]}${BASH_REMATCH[1]}${BASH_REMATCH[2]}"
    elif [[ "$filename_lower" =~ ([0-9]{2})/([0-9]{2})/([0-9]{4}) ]]; then
        date="${BASH_REMATCH[3]}${BASH_REMATCH[1]}${BASH_REMATCH[2]}"
    fi

    # Abbreviated date formats
    if [[ "$filename_lower" =~ ([0-9]{6}) ]]; then
        local year="${BASH_REMATCH[1]:0:2}"
        if (( year >= 15 && year <= 25 )); then
            date="20${BASH_REMATCH[1]}"
        else
            date="${BASH_REMATCH[1]}"
        fi
    elif [[ "$filename_lower" =~ ([0-9]{2})-([0-9]{2})-([0-9]{2}) ]]; then
        local year="${BASH_REMATCH[3]}"
        if (( year >= 15 && year <= 25 )); then
            date="20${BASH_REMATCH[3]}${BASH_REMATCH[2]}${BASH_REMATCH[1]}"
        else
            date="${BASH_REMATCH[3]}${BASH_REMATCH[2]}${BASH_REMATCH[1]}"
        fi
    elif [[ "$filename_lower" =~ ([0-9]{2})/([0-9]{2})/([0-9]{2}) ]]; then
        local year="${BASH_REMATCH[3]}"
        if (( year >= 15 && year <= 25 )); then
            date="20${BASH_REMATCH[3]}${BASH_REMATCH[2]}${BASH_REMATCH[1]}"
        else
            date="${BASH_REMATCH[3]}${BASH_REMATCH[2]}${BASH_REMATCH[1]}"
        fi
    fi

    # Ambiguous date formats (not honored)
    if [[ "$filename_lower" =~ ([0-9]{2})\.([0-9]{2})\.([0-9]{4}) ]]; then
        date=""
    elif [[ "$filename_lower" =~ ([0-9]{2})\.([0-9]{2})\.([0-9]{2}) ]]; then
        date=""
    elif [[ "$filename_lower" =~ ([0-9]{2})\.([0-9]{2})\.([0-9]{2}) ]]; then
        date=""
    elif [[ "$filename_lower" =~ ([0-9]{2})\.([0-9]{2})\.([0-9]{2}) ]]; then
        date=""
    fi

    echo "$date"
} 