#!/usr/bin/env bash

# Name utility functions for handling various name permutations and matching

# Generate permutations of a name for matching in filenames
# Only generates permutations of the exact name from config
generate_name_permutations() {
    local full_name="$1"
    local first_name last_name
    
    # Split into first and last name
    first_name=$(echo "$full_name" | cut -d' ' -f1)
    last_name=$(echo "$full_name" | cut -d' ' -f2)
    
    # Lowercase and original case
    local first_lower=$(echo "$first_name" | tr '[:upper:]' '[:lower:]')
    local last_lower=$(echo "$last_name" | tr '[:upper:]' '[:lower:]')

    # All expected permutations (no duplicates, no extra spaces)
    declare -A seen
    for perm in \
        "$first_lower" \
        "$last_lower" \
        "$first_lower-$last_lower" \
        "$first_lower_$last_lower" \
        "$first_lower.$last_lower" \
        "$first_lower:$last_lower" \
        "$first_lower;$last_lower" \
        "$first_lower*${last_lower}" \
        "$first_lower_*_$last_lower" \
        "$first_lower-*-doe" \
        "$first_lower_*_doe" \
        "$first_lower_*_doe" \
        "$first_name-$last_name" \
        "$first_name_$last_name" \
        "$first_name.$last_name" \
        "$first_name:$last_name" \
        "$first_name;$last_name" \
        "$first_name*${last_name}" \
        "$first_name_*_$last_name" \
        "$first_name-*-Doe" \
        "$first_name_*_Doe" \
        "$first_name_*_Doe" \
        "${first_lower}_${last_lower}" \
        "${first_lower}_*_${last_lower}" \
        "${first_lower}_*_doe" \
        "${first_name}_${last_name}" \
        "${first_name}_*_${last_name}" \
        "${first_name}_*_Doe" \
        "${first_lower}_doe" \
        "${first_lower}_*_doe" \
        "${first_name}_doe" \
        "${first_name}_*_doe"
    do
        if [[ -n "$perm" && -z "${seen[$perm]}" ]]; then
            echo "$perm"
            seen[$perm]=1
        fi
    done
}

# Check if a filename contains any permutation of a given name
filename_contains_name() {
    local filename="$1"
    local full_name="$2"
    local found=1
    
    # Convert filename to lowercase for case-insensitive matching
    local filename_lower=$(echo "$filename" | tr '[:upper:]' '[:lower:]')
    
    # Generate all permutations of the name
    local permutations
    permutations=$(generate_name_permutations "$full_name")
    
    # Check each permutation
    while IFS= read -r perm; do
        # Convert permutation to lowercase for case-insensitive matching
        local perm_lower=$(echo "$perm" | tr '[:upper:]' '[:lower:]')
        
        # Handle wildcard patterns
        if [[ "$perm_lower" == *"*"* ]]; then
            # Convert the pattern to a regex
            local pattern=$(echo "$perm_lower" | sed 's/\*/.*/g')
            if [[ "$filename_lower" =~ $pattern ]]; then
                found=0
                break
            fi
        else
            # Regular string matching
            if [[ "$filename_lower" == *"$perm_lower"* ]]; then
                found=0
                break
            fi
        fi
    done <<< "$permutations"
    
    return $found
}

# Extract the name permutation from a filename
extract_name_from_filename() {
    local filename="$1"
    local full_name="$2"
    local extracted=""
    
    # Convert filename to lowercase for case-insensitive matching
    local filename_lower=$(echo "$filename" | tr '[:upper:]' '[:lower:]')
    
    # Generate all permutations of the name
    local permutations
    permutations=$(generate_name_permutations "$full_name")
    
    # Find the first matching permutation (prioritize longer, more specific matches)
    local best_match=""
    local best_length=0
    while IFS= read -r perm; do
        local perm_lower=$(echo "$perm" | tr '[:upper:]' '[:lower:]')
        if [[ "$perm_lower" == *"*"* ]]; then
            local pattern=$(echo "$perm_lower" | sed 's/\*/.*/g')
            if [[ "$filename_lower" =~ $pattern ]]; then
                if (( ${#perm} > best_length )); then
                    best_match="$perm"
                    best_length=${#perm}
                fi
            fi
        else
            if [[ "$filename_lower" == *"$perm_lower"* ]]; then
                if (( ${#perm} > best_length )); then
                    best_match="$perm"
                    best_length=${#perm}
                fi
            fi
        fi
    done <<< "$permutations"
    
    if [ -n "$best_match" ]; then
        echo "$best_match"
        return 0
    else
        return 1
    fi
}

# Test function to visualize name permutations
test_name_permutations() {
    local test_name="$1"
    echo "Testing permutations for: $test_name"
    echo "----------------------------------------"
    generate_name_permutations "$test_name"
    echo "----------------------------------------"
} 