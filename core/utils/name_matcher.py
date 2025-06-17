#!/usr/bin/env python3

import re
import sys
import json
import yaml
import os
from typing import Tuple, List, Optional

def normalize_name(name):
    """Normalize a name by converting to lowercase and removing special characters."""
    return re.sub(r'[^a-z0-9]', '', name.lower())

def canonical_name(name):
    """Return the canonical form of a name (e.g., 'john doe')."""
    return ' '.join(re.findall(r'[a-zA-ZÀ-ÿ0-9]+', name.lower()))

def find_first_name(filename, first_name):
    """Find first name anywhere in filename, case insensitive"""
    pattern = re.compile(rf"{first_name}", re.IGNORECASE)
    return list(pattern.finditer(filename))

def find_last_name(filename, last_name):
    """Find last name anywhere in filename, case insensitive"""
    pattern = re.compile(rf"{last_name}", re.IGNORECASE)
    return list(pattern.finditer(filename))

def find_initial(filename, initial):
    """Find initial anywhere in filename, case insensitive"""
    pattern = re.compile(rf"{initial}", re.IGNORECASE)
    return list(pattern.finditer(filename))

def debug_print(*args, **kwargs):
    """Print debug messages to stderr."""
    print(*args, file=sys.stderr, **kwargs)

def load_separators():
    """Load separators from the YAML configuration file."""
    config_path = os.path.join(os.path.dirname(os.path.dirname(os.path.dirname(__file__))), 'config', 'separators.yaml')
    with open(config_path, 'r') as f:
        config = yaml.safe_load(f)
    
    # Get standard separators
    separators = config['default_separators']['standard']
    
    # Add non-standard separators if enabled
    if config.get('default_separators', {}).get('non_standard'):
        separators.extend(config['default_separators']['non_standard'])
    
    # Add custom separators if defined
    if config.get('custom_separators'):
        separators.extend(config['custom_separators'])
    
    # Escape special regex characters in separators
    escaped_separators = [re.escape(sep) for sep in separators]
    
    # Join separators for regex pattern
    return '|'.join(escaped_separators)

def match_full_name(filename: str, full_name: str) -> str:
    """Match a full name in a filename and return the matched name and remainder."""
    # Load separators from config
    separators = load_separators()
    valid_separators = '|'.join(separators)
    
    # Split full name into parts
    name_parts = full_name.lower().split()
    if len(name_parts) != 2:
        return f"|{filename}|false"
    
    first_name, last_name = name_parts
    
    # Build regex patterns
    patterns = []
    
    # Full name patterns (comma-separated in output)
    patterns.append(f"({first_name})[{valid_separators}]+({last_name})")  # First Last
    patterns.append(f"({last_name})[{valid_separators}]+({first_name})")  # Last First
    
    # First name + last initial patterns (space-separated in output)
    patterns.append(f"({first_name})[{valid_separators}]+({last_name[0]})")  # First L
    patterns.append(f"({last_name[0]})[{valid_separators}]+({first_name})")  # L First
    
    # First initial + last name patterns (preserve original separator)
    patterns.append(f"({first_name[0]})[{valid_separators}]+({last_name})")  # F Last
    patterns.append(f"({last_name})[{valid_separators}]+({first_name[0]})")  # Last F
    
    # Both initials patterns (preserve original separator)
    patterns.append(f"({first_name[0]})[{valid_separators}]+({last_name[0]})")  # F L
    patterns.append(f"({last_name[0]})[{valid_separators}]+({first_name[0]})")  # L F
    
    # Try each pattern
    for pattern in patterns:
        match = re.search(pattern, filename.lower())
        if match:
            groups = match.groups()
            matched_text = match.group(0)
            remainder = filename[len(matched_text):]
            
            # Format the output based on the pattern type
            if len(groups[0]) > 1 and len(groups[1]) > 1:  # Full name
                output = f"{groups[0]},{groups[1]}"
            elif len(groups[0]) > 1 and len(groups[1]) == 1:  # First name + last initial
                output = f"{groups[0]} {groups[1]}"
            elif len(groups[0]) == 1 and len(groups[1]) > 1:  # First initial + last name
                # Find the separator used in the match
                sep_match = re.search(f"[{valid_separators}]+", matched_text)
                sep = sep_match.group(0) if sep_match else " "
                output = f"{groups[0]}{sep}{groups[1]}"
            else:  # Both initials
                # Find the separator used in the match
                sep_match = re.search(f"[{valid_separators}]+", matched_text)
                sep = sep_match.group(0) if sep_match else " "
                output = f"{groups[0]}{sep}{groups[1]}"
            
            return f"{output}|{remainder}|true"
    
    return f"|{filename}|false"

def match_initials_surname(filename, name_parts):
    """Match first initial + surname using base functions"""
    if len(name_parts) < 2:
        return None
    
    first, last = name_parts[0], name_parts[-1]
    initial = first[0]
    
    initial_matches = find_initial(filename, initial)
    last_matches = find_last_name(filename, last)
    
    matches = []
    for i_match in initial_matches:
        for l_match in last_matches:
            if l_match.start() > i_match.end():
                # Valid match - last name comes after initial
                full_match = filename[i_match.start():l_match.end()]
                remainder = filename[l_match.end():]
                matches.append((full_match, remainder, i_match.start(), l_match.end()))
    
    if matches:
        matches.sort(key=lambda x: x[2])
        all_matches = [m[0] for m in matches]
        return ",".join(all_matches), matches[-1][1], matches[0][2], matches[-1][3]
    
    return None

def match_both_initials(filename, name_parts):
    """Match both initials using base functions"""
    if len(name_parts) < 2:
        return None
    
    first, last = name_parts[0], name_parts[-1]
    first_initial = first[0]
    last_initial = last[0]
    
    first_matches = find_initial(filename, first_initial)
    last_matches = find_initial(filename, last_initial)
    
    matches = []
    for f_match in first_matches:
        for l_match in last_matches:
            if l_match.start() > f_match.end():
                # Valid match - last initial comes after first initial
                full_match = filename[f_match.start():l_match.end()]
                remainder = filename[l_match.end():]
                matches.append((full_match, remainder, f_match.start(), l_match.end()))
    
    if matches:
        matches.sort(key=lambda x: x[2])
        all_matches = [m[0] for m in matches]
        return ",".join(all_matches), matches[-1][1], matches[0][2], matches[-1][3]
    
    return None

def extract_name_from_filename(filename: str, name_to_match: str) -> str:
    """
    Extract a name from a filename and return the matched name, remainder, and match status.
    Returns: matched_name|remainder|matched
    """
    return match_full_name(filename, name_to_match)

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

    result = extract_name_from_filename(filename, target_name)
    print(result)  # Only print the result to stdout

if __name__ == "__main__":
    main() 