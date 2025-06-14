#!/bin/bash

# Name utility functions for handling various name permutations and matching

# Generate all possible name permutations for a given full name
generate_name_permutations() {
    local full_name=$1
    local -a permutations=()
    
    # Convert to lowercase for case-insensitive matching
    local lower_name=$(echo "$full_name" | tr '[:upper:]' '[:lower:]')
    
    # Split into first and last name
    local first_name=$(echo "$lower_name" | awk '{print $1}')
    local last_name=$(echo "$lower_name" | awk '{print $2}')
    
    # Get first letter of first name
    local first_initial=${first_name:0:1}
    
    # Define all possible separators
    local -a separators=("" " " "-" "_" "." "," ";" ":" "--" "__" "---" "___" "..." ".." "~" "=" "+" "|" "/" "\\" "&" "@" "#" "*")
    
    # Basic permutations
    permutations+=("$first_name")                    # john
    permutations+=("$last_name")                     # doe
    permutations+=("${first_name^}")                 # John
    permutations+=("${last_name^}")                  # Doe
    permutations+=("$first_initial$last_name")       # jdoe
    permutations+=("$first_initial${last_name^}")    # jDoe
    permutations+=("${first_name^}$last_name")       # Johndoe
    permutations+=("$first_name$last_name")          # johndoe
    permutations+=("$first_name $last_name")         # john doe
    permutations+=("${first_name^} ${last_name^}")   # John Doe
    
    # Generate permutations with all possible separators
    for sep in "${separators[@]}"; do
        # Full name with separator
        permutations+=("$first_name$sep$last_name")         # john-doe, john_doe, etc.
        permutations+=("${first_name^}$sep$last_name")      # John-doe, John_doe, etc.
        permutations+=("$first_name$sep${last_name^}")      # john-Doe, john_Doe, etc.
        permutations+=("${first_name^}$sep${last_name^}")   # John-Doe, John_Doe, etc.
        
        # Initial + last name with separator
        permutations+=("$first_initial$sep$last_name")      # j-doe, j_doe, etc.
        permutations+=("$first_initial$sep${last_name^}")   # j-Doe, j_Doe, etc.
        
        # Names with leading/trailing separators
        permutations+=("$sep$first_name")                   # -john, _john, etc.
        permutations+=("$first_name$sep")                   # john-, john_, etc.
        permutations+=("$sep$last_name")                    # -doe, _doe, etc.
        permutations+=("$last_name$sep")                    # doe-, doe_, etc.
    done
    
    # Handle multiple word last names
    if [[ "$last_name" == *" "* ]]; then
        local last_name_first=$(echo "$last_name" | awk '{print $1}')
        local last_name_last=$(echo "$last_name" | awk '{print $2}')
        
        for sep in "${separators[@]}"; do
            # Basic combinations with separators
            permutations+=("$first_initial$sep$last_name_first$sep$last_name_last")  # j-vander-bilt
            permutations+=("$first_initial$sep$last_name_first $last_name_last")     # j-vander bilt
            permutations+=("$first_initial $last_name_first$sep$last_name_last")     # j vander-bilt
        done
    fi
    
    # Handle multiple word first names
    if [[ "$first_name" == *" "* ]]; then
        local first_name_first=$(echo "$first_name" | awk '{print $1}')
        local first_name_last=$(echo "$first_name" | awk '{print $2}')
        local first_initial2=${first_name_last:0:1}
        
        for sep in "${separators[@]}"; do
            # Basic combinations with separators
            permutations+=("$first_name_first$sep$first_name_last")              # mary-jane
            permutations+=("$first_initial$sep$first_initial2$sep$last_name")    # m-j-doe
            permutations+=("$first_initial$first_initial2$sep$last_name")        # mj-doe
        done
    fi
    
    # Add original full name
    permutations+=("$full_name")
    
    # Add case variations of the full name
    permutations+=("$(echo "$full_name" | tr '[:upper:]' '[:lower:]')")  # john doe
    permutations+=("$(echo "$full_name" | tr '[:lower:]' '[:upper:]')")  # JOHN DOE
    
    # Add mixed case variations
    permutations+=("$(echo "$full_name" | sed -E 's/([a-z])([a-z]*)/\U\1\L\2/g')")  # JoHn DoE
    
    # Add variations with common prefixes/suffixes
    permutations+=("$first_name's")                   # john's
    permutations+=("$last_name's")                    # doe's
    permutations+=("$first_name's $last_name")        # john's doe
    permutations+=("$first_name $last_name's")        # john doe's
    
    # Add non-adjacent name variations (names split by other text)
    for sep in "${separators[@]}"; do
        # First name + any text + last name
        permutations+=("$first_name$sep*$sep$last_name")         # john-anytext-doe
        permutations+=("${first_name^}$sep*$sep$last_name")      # John-anytext-doe
        permutations+=("$first_name$sep*$sep${last_name^}")      # john-anytext-Doe
        permutations+=("${first_name^}$sep*$sep${last_name^}")   # John-anytext-Doe
        
        # Initial + any text + last name
        permutations+=("$first_initial$sep*$sep$last_name")      # j-anytext-doe
        permutations+=("$first_initial$sep*$sep${last_name^}")   # j-anytext-Doe
    done
    
    # Add variations with numbers or dates between names
    for sep in "${separators[@]}"; do
        # Names with numbers between them
        permutations+=("$first_name$sep[0-9]*$sep$last_name")    # john-123-doe
        permutations+=("$first_initial$sep[0-9]*$sep$last_name") # j-123-doe
        
        # Names with dates between them
        permutations+=("$first_name$sep[0-9]{1,2}[./-][0-9]{1,2}[./-][0-9]{2,4}$sep$last_name")  # john-23-06-2023-doe
    done
    
    # Remove duplicates and return
    printf "%s\n" "${permutations[@]}" | sort -u
}

# Check if a filename contains any permutation of a given name
filename_contains_name() {
    local filename=$1
    local full_name=$2
    
    # Generate all permutations
    local -a permutations
    mapfile -t permutations < <(generate_name_permutations "$full_name")
    
    # Convert filename to lowercase for case-insensitive matching
    local lower_filename=$(echo "$filename" | tr '[:upper:]' '[:lower:]')
    
    # Check each permutation
    for perm in "${permutations[@]}"; do
        # Convert permutation to lowercase for case-insensitive matching
        local lower_perm=$(echo "$perm" | tr '[:upper:]' '[:lower:]')
        
        # Handle wildcard patterns
        if [[ "$lower_perm" == *"*"* ]]; then
            # Convert the pattern to a regex
            local pattern=$(echo "$lower_perm" | sed 's/\*/.*/g')
            if [[ "$lower_filename" =~ $pattern ]]; then
                return 0  # Found a match
            fi
        else
            # Regular string matching
            if [[ "$lower_filename" == *"$lower_perm"* ]]; then
                return 0  # Found a match
            fi
        fi
    done
    
    return 1  # No match found
}

# Extract name from filename if it matches any permutation
extract_name_from_filename() {
    local filename=$1
    local full_name=$2
    
    # Generate all permutations
    local -a permutations
    mapfile -t permutations < <(generate_name_permutations "$full_name")
    
    # Convert filename to lowercase for case-insensitive matching
    local lower_filename=$(echo "$filename" | tr '[:upper:]' '[:lower:]')
    
    # Check each permutation
    for perm in "${permutations[@]}"; do
        # Convert permutation to lowercase for case-insensitive matching
        local lower_perm=$(echo "$perm" | tr '[:upper:]' '[:lower:]')
        
        # Handle wildcard patterns
        if [[ "$lower_perm" == *"*"* ]]; then
            # Convert the pattern to a regex
            local pattern=$(echo "$lower_perm" | sed 's/\*/.*/g')
            if [[ "$lower_filename" =~ $pattern ]]; then
                echo "$perm"  # Return the matching permutation
                return 0
            fi
        else
            # Regular string matching
            if [[ "$lower_filename" == *"$lower_perm"* ]]; then
                echo "$perm"  # Return the matching permutation
                return 0
            fi
        fi
    done
    
    return 1  # No match found
}

# Test function (can be used for debugging)
test_name_permutations() {
    local test_name=$1
    log_info "Testing name permutations for: $test_name"
    log_info "Generated permutations:"
    generate_name_permutations "$test_name" | while read -r perm; do
        log_info "  - $perm"
    done
} 