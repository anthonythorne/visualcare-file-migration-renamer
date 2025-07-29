#!/bin/bash

# User Mapping Shell Utilities
# Provides shell wrappers for user mapping functionality

extract_user_from_path() {
    local full_path="$1"
    local script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../core/utils" && pwd)"
    python3 "$script_dir/user_mapping.py" "$full_path" 2>/dev/null
}

get_user_id_by_name() {
    local name="$1"
    local script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../core/utils" && pwd)"
    python3 "$script_dir/user_mapping.py" "$name" 2>/dev/null | cut -d'|' -f1
}

get_name_by_user_id() {
    local user_id="$1"
    local script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../core/utils" && pwd)"
    python3 "$script_dir/user_mapping.py" get_name "$user_id" 2>/dev/null
}

# Export functions for use in BATS tests
export -f extract_user_from_path
export -f get_user_id_by_name
export -f get_name_by_user_id 