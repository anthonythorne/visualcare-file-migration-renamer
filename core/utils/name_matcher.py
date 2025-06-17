#!/usr/bin/env python3

import re
import sys
import json
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

def match_full_name(filename: str, name_to_match: str) -> str:
    """
    Match name patterns in a filename with strict separator boundaries.
    Matches occur only when the name part is surrounded by separators or at filename boundaries.
    
    Args:
        filename: The filename to search in
        name_to_match: The full name to match (e.g. "john doe")
        
    Returns:
        A string in the format "matched_names|remaining_filename|success_flag"
        - matched_names: Comma-separated list of matched names
        - remaining_filename: The filename with matched parts removed but separators preserved
        - success_flag: "true" if any matches were found, "false" otherwise
    """
    # Split the name to match into parts
    name_parts = name_to_match.lower().split()
    if not name_parts:
        return f"|{filename}|false"
        
    # Define valid separators
    separators = r'[-_\s\.]'
    
    # Build patterns for each part
    patterns = []
    
    # First name patterns (at start, end, or between separators)
    patterns.extend([
        rf'^{name_parts[0]}(?={separators}|$)',  # First name at start
        rf'(?<={separators}){name_parts[0]}(?={separators}|$)',  # First name between separators
        rf'(?<={separators}){name_parts[0]}$'  # First name at end
    ])
    
    # Last name patterns (at start, end, or between separators)
    if len(name_parts) > 1:
        patterns.extend([
            rf'^{name_parts[-1]}(?={separators}|$)',  # Last name at start
            rf'(?<={separators}){name_parts[-1]}(?={separators}|$)',  # Last name between separators
            rf'(?<={separators}){name_parts[-1]}$'  # Last name at end
        ])
    
    # First initial + last name patterns
    if len(name_parts) > 1:
        patterns.extend([
            rf'^{name_parts[0][0]}{separators}{name_parts[-1]}(?={separators}|$)',  # At start
            rf'(?<={separators}){name_parts[0][0]}{separators}{name_parts[-1]}(?={separators}|$)',  # Between
            rf'(?<={separators}){name_parts[0][0]}{separators}{name_parts[-1]}$'  # At end
        ])
    
    # First name + last initial patterns
    if len(name_parts) > 1:
        patterns.extend([
            rf'^{name_parts[0]}{separators}{name_parts[-1][0]}(?={separators}|$)',  # At start
            rf'(?<={separators}){name_parts[0]}{separators}{name_parts[-1][0]}(?={separators}|$)',  # Between
            rf'(?<={separators}){name_parts[0]}{separators}{name_parts[-1][0]}$'  # At end
        ])
    
    # Both initials patterns
    if len(name_parts) > 1:
        patterns.extend([
            rf'^{name_parts[0][0]}{separators}{name_parts[-1][0]}(?={separators}|$)',  # At start
            rf'(?<={separators}){name_parts[0][0]}{separators}{name_parts[-1][0]}(?={separators}|$)',  # Between
            rf'(?<={separators}){name_parts[0][0]}{separators}{name_parts[-1][0]}$'  # At end
        ])
    
    # Try each pattern
    remaining = filename
    matches = []
    
    while True:
        match_found = False
        best_match = None
        best_match_pos = -1
        best_match_pattern = None
        
        # Find the leftmost match
        for pattern in patterns:
            match = re.search(pattern, remaining, re.IGNORECASE)
            if match and (best_match is None or match.start() < best_match_pos):
                best_match = match
                best_match_pos = match.start()
                best_match_pattern = pattern
        
        if best_match:
            # Get the matched text and its position
            matched_text = best_match.group()
            start_pos = best_match.start()
            end_pos = best_match.end()
            
            # For patterns with initials, keep the separator
            if best_match_pattern and len(name_parts) > 1:
                # Check if this is an initial pattern
                if (f"{name_parts[0][0]}{separators}" in best_match_pattern or 
                    f"{separators}{name_parts[-1][0]}" in best_match_pattern):
                    matches.append(matched_text)
                else:
                    # Find the actual name part (without separators)
                    name_match = re.search(r'[a-z]+', matched_text, re.IGNORECASE)
                    if name_match:
                        matches.append(name_match.group())
            else:
                # Find the actual name part (without separators)
                name_match = re.search(r'[a-z]+', matched_text, re.IGNORECASE)
                if name_match:
                    matches.append(name_match.group())
            
            # Replace the matched name with the same number of separators
            # or just remove the name while keeping separators
            if start_pos == 0:  # Match at start
                remaining = remaining[end_pos:]
            elif end_pos == len(remaining):  # Match at end
                remaining = remaining[:start_pos]
            else:  # Match in middle
                # Keep the separator before and after
                remaining = remaining[:start_pos] + remaining[end_pos:]
            
            match_found = True
        
        if not match_found:
            break
    
    if matches:
        return f"{','.join(matches)}|{remaining}|true"
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