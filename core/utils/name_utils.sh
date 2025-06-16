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
    
    # First, split into base and extension
    local base="${remainder%.*}"
    local ext="${remainder##*.}"
    
    # If base is empty, preserve it
    if [[ -z "$base" ]]; then
        echo ".${ext}"
        return 0
    fi
    
    # If base contains only separators, preserve it
    if ! echo "$base" | grep -q '[^-_. ]'; then
        echo ".${ext}"
        return 0
    fi
    
    # Remove leading/trailing separators from base
    base="${base#"${base%%[!-_. ]*}"}"
    base="${base%"${base##*[!-_. ]}"}"
    
    # Preserve version numbers and date patterns
    # Use perl for non-greedy match and substitution
    # Pattern explanation:
    # - (v[0-9]+(?:\.[0-9]+)+) - version numbers (v1.0, v1.0.0, etc.)
    # - ([0-9]{4}\.[0-9]{2}\.[0-9]{2}(?:\.[0-9]+)?) - date patterns with optional microseconds (YYYY.MM.DD.microseconds)
    # - ([0-9]{2}\.[0-9]{2}\.[0-9]{2}) - time patterns (HH.MM.SS)
    base=$(echo "$base" | perl -pe 's/(v[0-9]+(?:\.[0-9]+)+)|([0-9]{4}\.[0-9]{2}\.[0-9]{2}(?:\.[0-9]+)?)|([0-9]{2}\.[0-9]{2}\.[0-9]{2})|[-_. ]+/$1 ? $1 : ($2 ? $2 : ($3 ? $3 : "-"))/ge')
    
    # If we have an extension, add it back
    if [[ "$remainder" == *.* ]]; then
        echo "${base}.${ext}"
    else
        echo "$base"
    fi
}

# Function to extract name from filename using Python script
extract_name_from_filename() {
    local filename="$1"
    local name_to_match="$2"
    
    # Call Python script and capture output
    local script_dir
    script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    local python_output
    python_output=$(python3 "$script_dir/name_matcher.py" "$filename" "$name_to_match")
    
    # Check if Python script returned an error
    if [[ $? -ne 0 ]]; then
        echo "Error: Failed to run name_matcher.py" >&2
        return 1
    fi
    
    # Parse JSON output
    local matched
    local matched_name
    local raw_remainder
    
    matched=$(echo "$python_output" | jq -r '.matched')
    matched_name=$(echo "$python_output" | jq -r '.matched_name')
    raw_remainder=$(echo "$python_output" | jq -r '.raw_remainder')
    
    # Clean the remainder
    local cleaned_remainder
    cleaned_remainder=$(clean_filename_remainder "$raw_remainder")
    
    # Output results separated by pipe
    echo "${matched_name}|${cleaned_remainder}|${matched}"
    
    # Return success/failure
    [[ "$matched" == "true" ]]
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