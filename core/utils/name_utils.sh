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

    # Build permutations as an array
    local perms=()
    # Basic and separator permutations
    perms+=("${first_lower}${last_lower}")
    perms+=("${first_lower}-${last_lower}")
    perms+=("${first_lower}_${last_lower}")
    perms+=("${first_lower}.${last_lower}")
    perms+=("${first_lower} ${last_lower}")
    perms+=("${first_name}${last_name}")
    perms+=("${first_name}-${last_name}")
    perms+=("${first_name}_${last_name}")
    perms+=("${first_name}.${last_name}")
    perms+=("${first_name} ${last_name}")
    # Wildcard/non-adjacent patterns
    perms+=("${first_lower}-*-${last_lower}")
    perms+=("${first_lower}_*_${last_lower}")
    perms+=("${first_lower} * ${last_lower}")
    perms+=("${first_name}-*-${last_name}")
    perms+=("${first_name}_*_${last_name}")
    perms+=("${first_name} * ${last_name}")

    # Remove duplicates
    local seen=()
    for perm in "${perms[@]}"; do
        local skip=0
        for s in "${seen[@]}"; do
            if [[ "$perm" == "$s" ]]; then
                skip=1
                break
            fi
        done
        if [[ $skip -eq 0 ]]; then
            seen+=("$perm")
            echo "$perm"
        fi
    done
}

# Check if a filename contains any permutation of a given name (strict, not as substring of longer names)
filename_contains_name() {
    local filename="$1"
    local full_name="$2"
    local found=1
    local filename_lower=$(echo "$filename" | tr '[:upper:]' '[:lower:]')
    local permutations
    permutations=$(generate_name_permutations "$full_name")
    local first_name last_name
    first_name=$(echo "$full_name" | cut -d' ' -f1)
    last_name=$(echo "$full_name" | cut -d' ' -f2)
    local first_lower=$(echo "$first_name" | tr '[:upper:]' '[:lower:]')
    local last_lower=$(echo "$last_name" | tr '[:upper:]' '[:lower:]')
    while IFS= read -r perm; do
        local perm_lower=$(echo "$perm" | tr '[:upper:]' '[:lower:]')
        if [[ "$perm_lower" == *"-*-${last_lower}" || "$perm_lower" == *"_*_${last_lower}" || "$perm_lower" == *" * ${last_lower}" ]]; then
            # Wildcard pattern: match first and last name with any non-letter sequence in between
            local pattern="(^|[^a-z0-9])($first_lower|$first_name)[^a-zA-Z]+($last_lower|$last_name)([^a-z0-9]|$)"
            if [[ "$filename_lower" =~ $pattern ]]; then
                # Check that the between part does not contain letters (to avoid matching extra names)
                local between=$(echo "$filename_lower" | sed -n "s/.*$first_lower\([^a-zA-Z]*\)$last_lower.*/\1/p")
                if [[ -n "$between" && "$between" =~ ^[^a-zA-Z]+$ ]]; then
                    found=0
                    break
                fi
            fi
        else
            if [[ "$filename_lower" =~ (^|[^a-z0-9])$perm_lower([^a-z0-9]|$) ]]; then
                found=0
                break
            fi
        fi
    done <<< "$permutations"
    return $found
}

# Extract the name permutation from a filename and return the remainder (strict, preserves case)
extract_name_and_remainder() {
    local filename="$1"
    local full_name="$2"
    local filename_lower=$(echo "$filename" | tr '[:upper:]' '[:lower:]')
    local permutations
    permutations=$(generate_name_permutations "$full_name")
    local first_name last_name
    first_name=$(echo "$full_name" | cut -d' ' -f1)
    last_name=$(echo "$full_name" | cut -d' ' -f2)
    local first_lower=$(echo "$first_name" | tr '[:upper:]' '[:lower:]')
    local last_lower=$(echo "$last_name" | tr '[:upper:]' '[:lower:]')
    local best_match=""
    local best_length=0
    local best_remainder=""
    while IFS= read -r perm; do
        local perm_lower=$(echo "$perm" | tr '[:upper:]' '[:lower:]')
        if [[ "$perm_lower" == *"-*-${last_lower}" || "$perm_lower" == *"_*_${last_lower}" || "$perm_lower" == *" * ${last_lower}" ]]; then
            # Wildcard pattern: match first and last name with any non-letter sequence in between
            local pattern="(^|[^a-z0-9])(($first_name|$first_lower)[^a-zA-Z]+($last_name|$last_lower))([^a-z0-9]|$)"
            if [[ "$filename" =~ $pattern ]]; then
                local match_val="${BASH_REMATCH[2]}"
                local between=$(echo "$match_val" | sed -n "s/$first_name\([^a-zA-Z]*\)$last_name.*/\1/p;s/$first_lower\([^a-zA-Z]*\)$last_lower.*/\1/p")
                if [[ -n "$between" && "$between" =~ ^[^a-zA-Z]+$ ]]; then
                    if (( ${#match_val} > best_length )); then
                        best_match="$match_val"
                        # Remove the first occurrence of the matched permutation (with any leading/trailing separator)
                        local esc_match=$(printf '%s
' "$match_val" | sed -e 's/[]\/.*^$[]/\\&/g')
                        local remainder=$(echo "$filename" | sed -E "0,/(^|[^a-zA-Z0-9])$esc_match([^a-zA-Z0-9]|$)/s//\1_\2/")
                        remainder=$(echo "$remainder" | sed -E 's/([_-])\1+/\1\1/g; s/^[_-]+|[_-]+$//g')
                        best_remainder="$remainder"
                        best_length=${#match_val}
                    fi
                fi
            fi
        else
            if [[ "$filename_lower" =~ (^|[^a-z0-9])($perm_lower)([^a-z0-9]|$) ]]; then
                local match_val="${BASH_REMATCH[2]}"
                if (( ${#match_val} > best_length )); then
                    best_match="$match_val"
                    local esc_match=$(printf '%s
' "$match_val" | sed -e 's/[]\/.*^$[]/\\&/g')
                    local remainder=$(echo "$filename" | sed -E "0,/(^|[^a-zA-Z0-9])$esc_match([^a-zA-Z0-9]|$)/s//\1_\2/")
                    remainder=$(echo "$remainder" | sed -E 's/([_-])\1+/\1\1/g; s/^[_-]+|[_-]+$//g')
                    best_remainder="$remainder"
                    best_length=${#match_val}
                fi
            fi
        fi
    done <<< "$permutations"
    if [ -n "$best_match" ]; then
        echo "$best_match"
        echo "$best_remainder"
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