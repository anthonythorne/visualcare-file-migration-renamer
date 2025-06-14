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
        # For full names, allow any non-letter characters between parts
        if [[ "$name_perm" =~ ^[A-Za-z]+[^A-Za-z]+[A-Za-z]+$ ]]; then
            if [[ "$filename" =~ [^A-Za-z]${name_perm}[^A-Za-z] ]]; then
                return 0
            fi
        # For both initials (JD), must have separators around them
        elif [[ "$name_perm" =~ ^[A-Za-z]{2}$ ]]; then
            if [[ "$filename" =~ [^A-Za-z]${name_perm}[^A-Za-z] ]]; then
                return 0
            fi
        # For first initial + last name (jdoe) or first name + last initial (johnD),
        # no separators needed
        elif [[ "$name_perm" =~ ^[A-Za-z][A-Za-z]+$ ]]; then
            if [[ "$filename" =~ ${name_perm} ]]; then
                return 0
            fi
        # For single names, must be whole words
        else
            if [[ "$filename" =~ [^A-Za-z]${name_perm}[^A-Za-z] ]]; then
                return 0
            fi
        fi
    done < <(generate_name_permutations "$name_to_match")
    
    return 1
}

# Extract the matched name and remainder from a filename
# Returns: "matched_name" "remainder"
extract_name_and_remainder() {
    local filename="$1"
    local name_to_match="$2"
    local name_perm
    local matched_name=""
    local remainder="$filename"
    
    # Generate and check each permutation
    while IFS= read -r name_perm; do
        # For full names, allow any non-letter characters between parts
        if [[ "$name_perm" =~ ^[A-Za-z]+[^A-Za-z]+[A-Za-z]+$ ]]; then
            if [[ "$filename" =~ ([^A-Za-z])(${name_perm})([^A-Za-z]) ]]; then
                # Extract the matched name with its original case
                local match="${BASH_REMATCH[2]}"
                if [ -z "$matched_name" ]; then
                    matched_name="$match"
                else
                    matched_name="$matched_name,$match"
                fi
                # Remove the matched name and its surrounding separators
                remainder="${filename/${BASH_REMATCH[1]}${match}${BASH_REMATCH[3]}/}"
            fi
        # For both initials (JD), must have separators around them
        elif [[ "$name_perm" =~ ^[A-Za-z]{2}$ ]]; then
            if [[ "$filename" =~ ([^A-Za-z])(${name_perm})([^A-Za-z]) ]]; then
                # Extract the matched name with its original case
                local match="${BASH_REMATCH[2]}"
                if [ -z "$matched_name" ]; then
                    matched_name="$match"
                else
                    matched_name="$matched_name,$match"
                fi
                # Remove the matched name and its surrounding separators
                remainder="${filename/${BASH_REMATCH[1]}${match}${BASH_REMATCH[3]}/}"
            fi
        # For first initial + last name (jdoe) or first name + last initial (johnD),
        # no separators needed
        elif [[ "$name_perm" =~ ^[A-Za-z][A-Za-z]+$ ]]; then
            if [[ "$filename" =~ (${name_perm}) ]]; then
                # Extract the matched name with its original case
                local match="${BASH_REMATCH[1]}"
                if [ -z "$matched_name" ]; then
                    matched_name="$match"
                else
                    matched_name="$matched_name,$match"
                fi
                # Remove the matched name
                remainder="${filename/${match}/}"
            fi
        # For single names, must be whole words
        else
            if [[ "$filename" =~ ([^A-Za-z])(${name_perm})([^A-Za-z]) ]]; then
                # Extract the matched name with its original case
                local match="${BASH_REMATCH[2]}"
                if [ -z "$matched_name" ]; then
                    matched_name="$match"
                else
                    matched_name="$matched_name,$match"
                fi
                # Remove the matched name and its surrounding separators
                remainder="${filename/${BASH_REMATCH[1]}${match}${BASH_REMATCH[3]}/}"
            fi
        fi
    done < <(generate_name_permutations "$name_to_match")
    
    # Clean up the remainder
    remainder=$(echo "$remainder" | sed -E 's/^[^A-Za-z]+//;s/[^A-Za-z]+$//')
    
    echo "$matched_name"
    echo "$remainder"
}

# Test function to visualize name permutations
test_name_permutations() {
    local test_name="$1"
    echo "Testing permutations for: $test_name"
    echo "----------------------------------------"
    generate_name_permutations "$test_name"
    echo "----------------------------------------"
} 