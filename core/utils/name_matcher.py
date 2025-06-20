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
    
    # Join separators for regex non-capturing group
    return '(?:' + '|'.join(escaped_separators) + ')'

def match_both_initials(filename, first_initial, last_initial):
    """
    Match both initials (grouped or separated by known separators from config) at start or after separator, no words between.
    Returns (matched, new_remainder) or None.
    """
    sep_regex = load_separators()  # dynamically loaded separator regex
    # Grouped: jd at start or after separator
    grouped_pattern = rf'(^|{sep_regex}){first_initial}{last_initial}($|{sep_regex})'
    match = re.search(grouped_pattern, filename, re.IGNORECASE)
    if match:
        start, end = match.start(0), match.end(0)
        return filename[start:end], filename[:start] + filename[end:]
    # Separated: j<sep>+d, no other words between
    sep_pattern = rf'(^|{sep_regex}){first_initial}{sep_regex}+{last_initial}($|{sep_regex})'
    match = re.search(sep_pattern, filename, re.IGNORECASE)
    if match:
        start, end = match.start(0), match.end(0)
        return filename[start:end], filename[:start] + filename[end:]
    return None

def extract_all_name_matches(filename: str, name_to_match: str) -> str:
    """
    Extract all name matches from filename using an ordered, iterative approach.
    """
    debug_print(f"Processing filename: '{filename}' with name: '{name_to_match}'")
    name_parts = name_to_match.lower().split()
    if not name_parts:
        return f"|{filename}|false"

    first_name, last_name = (name_parts[0], name_parts[-1]) if len(name_parts) > 1 else (name_parts[0], '')
    first_initial, last_initial = first_name[0], last_name[0] if last_name else ''

    sep = load_separators()

    # Try compound patterns first (for patterns involving initials)
    if first_name and last_name:
        # First initial + Last name
        pattern = rf"(^|{sep})({re.escape(first_initial)})({sep}+)({re.escape(last_name)})($|{sep})"
        match = re.search(pattern, filename, re.IGNORECASE)
        if match:
            extracted = f"{match.group(2)}{match.group(3)}{match.group(4)}"
            start, end = match.span(0)
            # If there's a trailing separator, preserve it in the remainder
            if match.group(5):  # group(5) is the trailing separator
                remainder = filename[:start] + match.group(5) + filename[end:]
            else:
                remainder = filename[:start] + filename[end:]
            return f"{extracted}|{remainder}|true"
        
        # First name + Last initial
        pattern = rf"(^|{sep})({re.escape(first_name)})({sep}+)({re.escape(last_initial)})($|{sep})"
        match = re.search(pattern, filename, re.IGNORECASE)
        if match:
            extracted = f"{match.group(2)}{match.group(3)}{match.group(4)}"
            start, end = match.span(0)
            # If there's a trailing separator, preserve it in the remainder
            if match.group(5):  # group(5) is the trailing separator
                remainder = filename[:start] + match.group(5) + filename[end:]
            else:
                remainder = filename[:start] + filename[end:]
            return f"{extracted}|{remainder}|true"
    
    if first_initial and last_initial:
        # Both initials separated
        pattern = rf"(^|{sep})({re.escape(first_initial)})({sep}+)({re.escape(last_initial)})($|{sep})"
        match = re.search(pattern, filename, re.IGNORECASE)
        if match:
            extracted = f"{match.group(2)}{match.group(3)}{match.group(4)}"
            start, end = match.span(0)
            # If there's a trailing separator, preserve it in the remainder
            if match.group(5):  # group(5) is the trailing separator
                remainder = filename[:start] + match.group(5) + filename[end:]
            else:
                remainder = filename[:start] + filename[end:]
            return f"{extracted}|{remainder}|true"
        
        # Both initials grouped
        pattern = rf"(^|{sep})({re.escape(first_initial)})({re.escape(last_initial)})($|{sep})"
        match = re.search(pattern, filename, re.IGNORECASE)
        if match:
            extracted = f"{match.group(2)}{match.group(3)}"
            start, end = match.span(0)
            # If there's a trailing separator, preserve it in the remainder
            if match.group(4):  # group(4) is the trailing separator
                remainder = filename[:start] + match.group(4) + filename[end:]
            else:
                remainder = filename[:start] + filename[end:]
            return f"{extracted}|{remainder}|true"
    
    # Full name patterns - extract individual parts
    if first_name and last_name:
        # First name + Last name (both orders)
        pattern = rf"(^|{sep})({re.escape(first_name)})({sep}+)({re.escape(last_name)})($|{sep})"
        match = re.search(pattern, filename, re.IGNORECASE)
        if match:
            extracted = f"{match.group(2)},{match.group(4)}"
            # Remove both name parts, preserving separators
            start1, end1 = match.span(2)  # first name
            start2, end2 = match.span(4)  # last name
            remainder = filename[:start1] + filename[end1:start2] + filename[end2:]
            return f"{extracted}|{remainder}|true"
        
        pattern = rf"(^|{sep})({re.escape(last_name)})({sep}+)({re.escape(first_name)})($|{sep})"
        match = re.search(pattern, filename, re.IGNORECASE)
        if match:
            extracted = f"{match.group(2)},{match.group(4)}"
            # Remove both name parts, preserving separators
            start1, end1 = match.span(2)  # last name
            start2, end2 = match.span(4)  # first name
            remainder = filename[:start1] + filename[end1:start2] + filename[end2:]
            return f"{extracted}|{remainder}|true"
    
    # Individual patterns (fallback)
    pattern = rf"(^|{sep})({re.escape(first_name)})($|{sep})"
    match = re.search(pattern, filename, re.IGNORECASE)
    if match:
        extracted = match.group(2)
        start, end = match.span(2)
        remainder = filename[:start] + filename[end:]
        return f"{extracted}|{remainder}|true"
    
    if last_name:
        pattern = rf"(^|{sep})({re.escape(last_name)})($|{sep})"
        match = re.search(pattern, filename, re.IGNORECASE)
        if match:
            extracted = match.group(2)
            start, end = match.span(2)
            remainder = filename[:start] + filename[end:]
            return f"{extracted}|{remainder}|true"

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
    return extract_all_name_matches(filename, name_to_match)

def extract_first_name_only(filename: str, name_to_match: str) -> str:
    """
    Extract only the first name from a filename.
    Returns: matched_name|remainder|matched
    """
    debug_print(f"Processing filename: '{filename}' for first name: '{name_to_match}'")
    
    # Find first name matches
    first_matches = find_first_name(filename, name_to_match.lower())
    if not first_matches:
        debug_print(f"First name '{name_to_match}' not found")
        return f"|{filename}|false"
    
    # Use the first match found
    first_match = first_matches[0]
    debug_print(f"Found first name '{name_to_match}' at position {first_match.start()}-{first_match.end()}")
    
    # Extract the matched name and remainder
    matched_name = filename[first_match.start():first_match.end()]
    before_match = filename[:first_match.start()]
    after_match = filename[first_match.end():]
    remainder = before_match + after_match
    
    debug_print(f"Matched name: '{matched_name}', remainder: '{remainder}'")
    
    return f"{matched_name}|{remainder}|true"

def extract_last_name_only(filename: str, name_to_match: str) -> str:
    """
    Extract only the last name from a filename.
    Returns: matched_name|remainder|matched
    """
    debug_print(f"Processing filename: '{filename}' for last name: '{name_to_match}'")
    
    # Find last name matches
    last_matches = find_last_name(filename, name_to_match.lower())
    if not last_matches:
        debug_print(f"Last name '{name_to_match}' not found")
        return f"|{filename}|false"
    
    # Use the first match found
    last_match = last_matches[0]
    debug_print(f"Found last name '{name_to_match}' at position {last_match.start()}-{last_match.end()}")
    
    # Extract the matched name and remainder
    matched_name = filename[last_match.start():last_match.end()]
    before_match = filename[:last_match.start()]
    after_match = filename[last_match.end():]
    remainder = before_match + after_match
    
    debug_print(f"Matched name: '{matched_name}', remainder: '{remainder}'")
    
    return f"{matched_name}|{remainder}|true"

def extract_initials_only(filename: str, name_to_match: str) -> str:
    """
    Extract only initials from a filename.
    """
    first_initial = name_to_match[0].lower()
    last_initial = name_to_match[1].lower() if len(name_to_match) > 1 else ''
    if not last_initial:
        return f"|{filename}|false"

    sep = load_separators()
    patterns = [
        rf'\b{first_initial}{sep}+{last_initial}\b',
        rf'\b{first_initial}{last_initial}\b',
    ]

    for pattern in patterns:
        match = re.search(pattern, filename, re.IGNORECASE)
        if match:
            matched_text = match.group(0)
            start, end = match.span()
            remainder = filename[:start] + filename[end:]
            return f"{matched_text}|{remainder}|true"
            
    return f"|{filename}|false"

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