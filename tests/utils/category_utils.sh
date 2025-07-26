#!/usr/bin/env bash

# Extract category from path (folders and filename)
# Usage: extract_category_from_path <input_path>
# Output: extracted_category|raw_category|cleaned_category|raw_remainder|cleaned_remainder|error_status
extract_category_from_path() {
    local input_path="$1"
    local utils_dir
    utils_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../core/utils" && pwd)"
    python3 "$utils_dir/category_processor.py" "$input_path" 2>/dev/null
}

export -f extract_category_from_path 