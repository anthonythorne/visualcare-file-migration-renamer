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
        if [[ "$name_perm" =~ ^[A-Za-zÀ-ÿ]+[^A-Za-zÀ-ÿ]+[A-Za-zÀ-ÿ]+$ ]]; then
            if [[ "$filename" =~ [^A-Za-zÀ-ÿ]${name_perm}[^A-Za-zÀ-ÿ] ]]; then
                return 0
            fi
        # For both initials (JD), must have separators around them
        elif [[ "$name_perm" =~ ^[A-Za-zÀ-ÿ]{2}$ ]]; then
            if [[ "$filename" =~ [^A-Za-zÀ-ÿ]${name_perm}[^A-Za-zÀ-ÿ] ]]; then
                return 0
            fi
        # For first initial + last name (jdoe) or first name + last initial (johnD),
        # no separators needed
        elif [[ "$name_perm" =~ ^[A-Za-zÀ-ÿ][A-Za-zÀ-ÿ]+$ ]]; then
            if [[ "$filename" =~ ${name_perm} ]]; then
                return 0
            fi
        # For single names, must be whole words
        else
            if [[ "$filename" =~ [^A-Za-zÀ-ÿ]${name_perm}[^A-Za-zÀ-ÿ] ]]; then
                return 0
            fi
        fi
    done < <(generate_name_permutations "$name_to_match")
    
    return 1
}

# Extract the matched name and remainder from a filename
# Returns: "matched_name" "raw_remainder" "cleaned_remainder"
extract_name_and_remainder() {
    local filename="$1"
    local name_to_match="$2"
    local name_perm
    local matched_names=()
    local remainder="$filename"
    local raw_remainder="$filename"
    
    # Generate and check each permutation
    while IFS= read -r name_perm; do
        # For full names, allow any non-letter characters between parts
        if [[ "$name_perm" =~ ^[A-Za-zÀ-ÿ]+[^A-Za-zÀ-ÿ]+[A-Za-zÀ-ÿ]+$ ]]; then
            if [[ "$filename" =~ ([^A-Za-zÀ-ÿ])(${name_perm})([^A-Za-zÀ-ÿ]) ]]; then
                # Extract the matched name with its original case
                local match="${BASH_REMATCH[2]}"
                # Only add if not already in matched_names
                if ! [[ " ${matched_names[*]} " =~ " ${match} " ]]; then
                    matched_names+=("$match")
                fi
                # Remove the matched name and its surrounding separators
                remainder="${filename/${BASH_REMATCH[1]}${match}${BASH_REMATCH[3]}/}"
            fi
        # For both initials (JD), must have separators around them
        elif [[ "$name_perm" =~ ^[A-Za-zÀ-ÿ]{2}$ ]]; then
            if [[ "$filename" =~ ([^A-Za-zÀ-ÿ])(${name_perm})([^A-Za-zÀ-ÿ]) ]]; then
                # Extract the matched name with its original case
                local match="${BASH_REMATCH[2]}"
                # Only add if not already in matched_names
                if ! [[ " ${matched_names[*]} " =~ " ${match} " ]]; then
                    matched_names+=("$match")
                fi
                # Remove the matched name and its surrounding separators
                remainder="${filename/${BASH_REMATCH[1]}${match}${BASH_REMATCH[3]}/}"
            fi
        # For first initial + last name (jdoe) or first name + last initial (johnD),
        # no separators needed
        elif [[ "$name_perm" =~ ^[A-Za-zÀ-ÿ][A-Za-zÀ-ÿ]+$ ]]; then
            if [[ "$filename" =~ (${name_perm}) ]]; then
                # Extract the matched name with its original case
                local match="${BASH_REMATCH[1]}"
                # Only add if not already in matched_names
                if ! [[ " ${matched_names[*]} " =~ " ${match} " ]]; then
                    matched_names+=("$match")
                fi
                # Remove the matched name
                remainder="${filename/${match}/}"
            fi
        # For single names, must be whole words
        else
            if [[ "$filename" =~ ([^A-Za-zÀ-ÿ])(${name_perm})([^A-Za-zÀ-ÿ]) ]]; then
                # Extract the matched name with its original case
                local match="${BASH_REMATCH[2]}"
                # Only add if not already in matched_names
                if ! [[ " ${matched_names[*]} " =~ " ${match} " ]]; then
                    matched_names+=("$match")
                fi
                # Remove the matched name and its surrounding separators
                remainder="${filename/${BASH_REMATCH[1]}${match}${BASH_REMATCH[3]}/}"
            fi
        fi
    done < <(generate_name_permutations "$name_to_match")
    
    # Join matched names with commas
    local matched_name=""
    if [ ${#matched_names[@]} -gt 0 ]; then
        matched_name=$(IFS=,; echo "${matched_names[*]}")
    fi
    
    # Clean up the remainder
    local cleaned_remainder=$(echo "$remainder" | sed -E 's/^[^A-Za-zÀ-ÿ]+//;s/[^A-Za-zÀ-ÿ]+$//')
    
    # Handle folder and category information
    if [[ "$filename" =~ ^([^/]+/)+ ]]; then
        local folder_path="${BASH_REMATCH[0]}"
        # Remove trailing slash
        folder_path="${folder_path%/}"
        # Replace slashes with hyphens
        folder_path="${folder_path//\//-}"
        # Add folder path to cleaned remainder
        cleaned_remainder="${folder_path}-${cleaned_remainder}"
    fi
    
    echo "$matched_name"
    echo "$raw_remainder"
    echo "$cleaned_remainder"
}

# Test function to visualize name permutations
test_name_permutations() {
    local test_name="$1"
    echo "Testing permutations for: $test_name"
    echo "----------------------------------------"
    generate_name_permutations "$test_name"
    echo "----------------------------------------"
} 