#!/usr/bin/env bash

# Name utility functions for handling various name permutations and matching

# Generate all possible name permutations for matching
# Input: "John Doe" -> ["John Doe", "John", "Doe", "J Doe", "J", "JD", "jdoe", "johnD"]
generate_name_permutations() {
    local full_name="$1"
    local first_name last_name initial
    
    # Split into first and last name
    first_name=$(echo "$full_name" | cut -d' ' -f1)
    last_name=$(echo "$full_name" | cut -d' ' -f2)
    initial="${first_name:0:1}"
    
    # Generate permutations
    echo "$full_name"                    # Full name
    echo "$first_name"                   # First name
    echo "$last_name"                    # Last name
    echo "$initial $last_name"           # Initial + last name
    echo "$initial"                      # First initial
    echo "${initial}${last_name:0:1}"    # Both initials (JD)
    echo "${initial}${last_name}"        # First initial + last name (jdoe)
    echo "${first_name}${last_name:0:1}" # First name + last initial (johnD)
}

# Check if a filename contains any permutation of a name
# Returns 0 if match found, 1 if no match
filename_contains_name() {
    local filename="$1"
    local name_to_match="$2"
    local name_perm
    
    # Generate and check each permutation
    while IFS= read -r name_perm; do
        # For full names, allow any non-alphanumeric characters between parts
        if [[ "$name_perm" =~ ^[A-Za-zÀ-ÿ0-9]+[^A-Za-zÀ-ÿ0-9]+[A-Za-zÀ-ÿ0-9]+$ ]]; then
            if [[ "$filename" =~ [^A-Za-zÀ-ÿ0-9]${name_perm}[^A-Za-zÀ-ÿ0-9] ]]; then
                return 0
            fi
        # For both initials (JD), must have separators around them
        elif [[ "$name_perm" =~ ^[A-Za-zÀ-ÿ0-9]{2}$ ]]; then
            if [[ "$filename" =~ [^A-Za-zÀ-ÿ0-9]${name_perm}[^A-Za-zÀ-ÿ0-9] ]]; then
                return 0
            fi
        # For first initial + last name (jdoe) or first name + last initial (johnD),
        # no separators needed
        elif [[ "$name_perm" =~ ^[A-Za-zÀ-ÿ0-9][A-Za-zÀ-ÿ0-9]+$ ]]; then
            if [[ "$filename" =~ ${name_perm} ]]; then
                return 0
            fi
        # For single names, must be whole words
        else
            if [[ "$filename" =~ [^A-Za-zÀ-ÿ0-9]${name_perm}[^A-Za-zÀ-ÿ0-9] ]]; then
                return 0
            fi
        fi
    done < <(generate_name_permutations "$name_to_match")
    
    return 1
}

# Test function to visualize name permutations
test_name_permutations() {
    local test_name="$1"
    echo "Testing permutations for: $test_name"
    echo "----------------------------------------"
    generate_name_permutations "$test_name"
    echo "----------------------------------------"
}

# Function to clean a filename remainder
# Removes leading/trailing separators and standardizes internal separators
clean_filename_remainder() {
    local remainder="$1"
    
    # Remove leading and trailing separators
    remainder=$(echo "$remainder" | sed -E 's/^[-_\s\.]+//')
    remainder=$(echo "$remainder" | sed -E 's/[-_\s\.]+$//')
    
    # Replace multiple consecutive separators with a single hyphen
    remainder=$(echo "$remainder" | sed -E 's/[-_\s\.]{2,}/-/g')
    remainder=$(echo "$remainder" | sed -E 's/^ +//')
    remainder=$(echo "$remainder" | sed -E 's/ +$//')
    
    echo "$remainder"
}

# Function to extract name from filename
extract_name_from_filename() {
    local filename="$1"
    local name_to_match="$2"

    # Compute absolute path to core/utils
    local utils_dir
    utils_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

    # Call the Python matcher and capture the output
    local result
    result=$(python3 -c "
import sys, os
sys.path.append('$utils_dir')
from name_matcher import extract_all_name_matches
result = extract_all_name_matches('$filename', '$name_to_match')
print(result)
" 2>/dev/null)

    # Split the result into components
    IFS='|' read -r matched_name remainder matched <<< "$result"
    
    # If we have a match, ensure we preserve the full matched name including separators
    if [ "$matched" = "true" ]; then
        # For First Name + Last Initial cases, ensure we include the separator and initial
        if [[ "$matched_name" =~ ^[a-zA-Z]+$ ]] && [[ "$remainder" =~ ^([-_\s\.])[a-zA-Z] ]]; then
            # Extract the separator and initial from the remainder (including space)
            local separator_initial
            separator_initial=$(echo "$remainder" | grep -oE '^( |-_|\.|_)[a-zA-Z]')
            if [ -z "$separator_initial" ]; then
                separator_initial=$(echo "$remainder" | grep -oE '^.[a-zA-Z]')
            fi
            matched_name="${matched_name}${separator_initial}"
            remainder="${remainder#${separator_initial}}"
        fi
    fi
    
    # Return the result in the expected format
    echo "${matched_name}|${remainder}|${matched}"
}

# Function to extract first name only
extract_first_name() {
    local filename="$1"
    local name_to_match="$2"

    # Compute absolute path to core/utils
    local utils_dir
    utils_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

    # Call the Python matcher for first name only
    local result
    result=$(python3 -c "
import sys, os
sys.path.append('$utils_dir')
from name_matcher import extract_first_name_only
result = extract_first_name_only('$filename', '$name_to_match')
print(result)
" 2>/dev/null)

    # Split the result into components
    IFS='|' read -r matched_name remainder matched <<< "$result"
    
    # Return the result in the expected format
    echo "${matched_name}|${remainder}|${matched}"
}

# Function to extract last name only
extract_last_name() {
    local filename="$1"
    local name_to_match="$2"

    # Compute absolute path to core/utils
    local utils_dir
    utils_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

    # Call the Python matcher for last name only
    local result
    result=$(python3 -c "
import sys, os
sys.path.append('$utils_dir')
from name_matcher import extract_last_name_only
result = extract_last_name_only('$filename', '$name_to_match')
print(result)
" 2>/dev/null)

    # Split the result into components
    IFS='|' read -r matched_name remainder matched <<< "$result"
    
    # Return the result in the expected format
    echo "${matched_name}|${remainder}|${matched}"
}

# Function to extract initials
extract_initials() {
    local filename="$1"
    local name_to_match="$2"

    # Compute absolute path to core/utils
    local utils_dir
    utils_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

    # Call the Python matcher for initials
    local result
    result=$(python3 -c "
import sys, os
sys.path.append('$utils_dir')
from name_matcher import extract_initials_only
result = extract_initials_only('$filename', '$name_to_match')
print(result)
" 2>/dev/null)

    # Split the result into components
    IFS='|' read -r matched_name remainder matched <<< "$result"
    
    # Return the result in the expected format
    echo "${matched_name}|${remainder}|${matched}"
}

# Function to clean a filename
clean_filename() {
    local filename="$1"
    
    # Remove leading/trailing separators
    filename="${filename#"${filename%%[!-_. ]*}"}"
    filename="${filename%"${filename##*[!-_. ]}"}"
    
    # Replace multiple separators with a single underscore
    filename=$(echo "$filename" | sed -E 's/[-_. ]+/_/g')
    
    echo "$filename"
}

# Main script
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    # If script is run directly, process command line arguments
    if [[ $# -lt 1 ]]; then
        echo "Usage: $0 <filename> [name_to_match]"
        exit 1
    fi
    
    filename="$1"
    name_to_match="${2:-}"
    
    if [[ -n "$name_to_match" ]]; then
        # Extract name and clean remainder
        if extract_name_from_filename "$filename" "$name_to_match"; then
            exit 0
        else
            exit 1
        fi
    else
        # Just clean the filename
        clean_filename "$filename"
    fi
fi 