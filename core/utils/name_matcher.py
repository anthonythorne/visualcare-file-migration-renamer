#!/usr/bin/env python3

import re
import sys
import json

def normalize_name(name):
    """Normalize a name by converting to lowercase and removing special characters."""
    return re.sub(r'[^a-z0-9]', '', name.lower())

def canonical_name(name):
    """Return the canonical form of a name (e.g., 'john doe')."""
    return ' '.join(re.findall(r'[a-zA-ZÀ-ÿ0-9]+', name.lower()))

def extract_name_from_filename(filename, name_to_match):
    # Debug output to stderr only (or remove for production)
    # print(f"[DEBUG] Processing filename: {filename}", file=sys.stderr)
    # print(f"[DEBUG] Name to match: {name_to_match}", file=sys.stderr)

    # Split the name to match into parts
    name_parts = name_to_match.lower().split()
    if len(name_parts) < 2:
        print(json.dumps({"matched": False, "matched_name": "", "raw_remainder": filename}))
        return None, filename

    # Create regex pattern for the name
    first_part = name_parts[0]
    second_part = name_parts[-1]
    # Allow any non-alphanumeric characters between parts
    pattern = f"{first_part}[^a-zA-Z0-9]*{second_part}"

    # Try to match the pattern
    match = re.search(pattern, filename.lower())
    if not match:
        print(json.dumps({"matched": False, "matched_name": "", "raw_remainder": filename}))
        return None, filename

    # Extract the matched name and literal remainder (no cleaning/stripping)
    full_match = match.group(0)
    matched_name = full_match
    
    # Get the remainder including any leading separator
    remainder = filename[match.end():]
    
    # Check if there was a separator before the match
    if match.start() > 0:
        before_match = filename[match.start()-1:match.start()]
        if before_match and re.match(r'[-_. ]', before_match):
            # If there was a separator before, ensure there's one after
            if not remainder.startswith(before_match):
                remainder = before_match + remainder
    else:
        # If match starts at beginning, check if there's a separator after
        if remainder and not re.match(r'^[-_. ]', remainder):
            after_match = filename[match.end():match.end()+1]
            if after_match and re.match(r'[-_. ]', after_match):
                remainder = after_match + remainder

    # For extra content cases, include the extra content in the remainder
    between = full_match[len(first_part):-len(second_part)]
    if between:
        if re.fullmatch(r'[^a-zA-Z0-9]', between):
            # Single non-standard separator, normalize to '-'
            remainder = '-' + remainder.lstrip('-_. ')
        elif not re.fullmatch(r'[^a-zA-Z0-9]+', between):
            # Extra content, prepend as-is, preserve all separators
            remainder = between + remainder

    # Output JSON for Bash to parse
    result = {
        "matched": True,
        "matched_name": matched_name,
        "raw_remainder": remainder
    }
    print(json.dumps(result))
    return matched_name, remainder

def main():
    """Main function to process command line arguments."""
    if len(sys.argv) != 3:
        # Only print errors to stderr
        print(json.dumps({
            "error": "Usage: name_matcher.py <filename> <target_name>"
        }), file=sys.stderr)
        sys.exit(1)

    filename = sys.argv[1]
    target_name = sys.argv[2]

    matched_name, remainder = extract_name_from_filename(filename, target_name)
    # Do not print anything else here

if __name__ == "__main__":
    main() 