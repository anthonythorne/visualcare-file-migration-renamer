#!/usr/bin/env bash
# User mapping utility shell functions

# Get user ID and full name by input name
# Usage: get_user_id_by_name <input_name>
# Output: user_id|full_name|raw_name|cleaned_name
get_user_id_by_name() {
    local input_name="$1"
    local utils_dir
    utils_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    python3 "$utils_dir/user_mapping.py" "$input_name"
}
export -f get_user_id_by_name 