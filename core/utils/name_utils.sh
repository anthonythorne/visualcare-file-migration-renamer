#!/usr/bin/env bash

# Name utility functions for handling various name permutations and matching

# Generate permutations of a name for matching in filenames
# Only generates permutations of the exact name from config
generate_name_permutations() {
    local full_name="$1"
    local first_name last_name
    first_name=$(echo "$full_name" | cut -d' ' -f1)
    last_name=$(echo "$full_name" | cut -d' ' -f2)
    local first_lower=$(echo "$first_name" | tr '[:upper:]' '[:lower:]')
    local last_lower=$(echo "$last_name" | tr '[:upper:]' '[:lower:]')
    local first_initial_lower=$(echo "$first_name" | cut -c1 | tr '[:upper:]' '[:lower:]')
    local first_initial=$(echo "$first_name" | cut -c1)

    local perms=()
    # Full name permutations
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
    # Non-adjacent (wildcard) patterns: allow any non-letter chars between names
    perms+=("${first_lower}*${last_lower}")
    perms+=("${first_name}*${last_name}")
    # Initials (must be followed by separator and last name)
    perms+=("${first_initial_lower}${last_lower}")
    perms+=("${first_initial_lower}-${last_lower}")
    perms+=("${first_initial_lower}_${last_lower}")
    perms+=("${first_initial_lower}.${last_lower}")
    perms+=("${first_initial_lower} ${last_lower}")
    perms+=("${first_initial}${last_name}")
    perms+=("${first_initial}-${last_name}")
    perms+=("${first_initial}_${last_name}")
    perms+=("${first_initial}.${last_name}")
    perms+=("${first_initial} ${last_name}")

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
    local filename_lower=$(echo "$filename" | tr '[:upper:]' '[:lower:]')
    local permutations
    permutations=$(generate_name_permutations "$full_name")
    local first_name last_name
    first_name=$(echo "$full_name" | cut -d' ' -f1)
    last_name=$(echo "$full_name" | cut -d' ' -f2)
    local first_lower=$(echo "$first_name" | tr '[:upper:]' '[:lower:]')
    local last_lower=$(echo "$last_name" | tr '[:upper:]' '[:lower:]')
    local first_initial_lower=$(echo "$first_name" | cut -c1 | tr '[:upper:]' '[:lower:]')
    local found=1
    while IFS= read -r perm; do
        local perm_lower=$(echo "$perm" | tr '[:upper:]' '[:lower:]')
        # Non-adjacent pattern: allow any non-letter chars between names
        if [[ "$perm_lower" == *"*${last_lower}" ]]; then
            local pattern="(^|[^a-z0-9])${first_lower}[^a-zA-Z]+${last_lower}([^a-zA-Z0-9]|$)"
            if [[ "$filename_lower" =~ $pattern ]]; then
                found=0
                break
            fi
        # Initials: must be followed by separator and last name
        elif [[ "$perm_lower" =~ ^${first_initial_lower} ]]; then
            local pattern="(^|[^a-z0-9])${first_initial_lower}[^a-zA-Z0-9]*${last_lower}([^a-zA-Z0-9]|$)"
            if [[ "$filename_lower" =~ $pattern ]]; then
                found=0
                break
            fi
        else
            # Full name: last name must not be followed by a letter
            local pattern="(^|[^a-z0-9])$perm_lower([^a-zA-Z0-9]|$)"
            if [[ "$filename_lower" =~ $pattern ]]; then
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
    local first_initial_lower=$(echo "$first_name" | cut -c1 | tr '[:upper:]' '[:lower:]')
    local best_match=""
    local best_length=0
    local best_remainder=""
    while IFS= read -r perm; do
        local perm_lower=$(echo "$perm" | tr '[:upper:]' '[:lower:]')
        local pattern
        if [[ "$perm_lower" == *"*${last_lower}" ]]; then
            pattern="(^|[^a-z0-9])(${first_name}|${first_lower})[^a-zA-Z]+(${last_name}|${last_lower})([^a-zA-Z0-9]|$)"
        elif [[ "$perm_lower" =~ ^${first_initial_lower} ]]; then
            pattern="(^|[^a-z0-9])${first_initial_lower}[^a-zA-Z0-9]*${last_lower}([^a-zA-Z0-9]|$)"
        else
            pattern="(^|[^a-z0-9])($perm_lower)([^a-zA-Z0-9]|$)"
        fi
        if [[ "$filename_lower" =~ $pattern ]]; then
            # Find the actual match in the original filename
            local match_start=${BASH_REMATCH_START[2]:-0}
            local match_len=${#BASH_REMATCH[2]}
            local match_val="${BASH_REMATCH[2]}"
            if (( match_len > best_length )); then
                best_match="$match_val"
                # Remove the matched substring from the original filename
                local before=${filename:0:match_start}
                local after=${filename:match_start+match_len}
                local remainder="$before$after"
                # Clean up leading/trailing separators
                remainder=$(echo "$remainder" | sed -E 's/^[-_. ]+//; s/[-_. ]+$//')
                best_remainder="$remainder"
                best_length=$match_len
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