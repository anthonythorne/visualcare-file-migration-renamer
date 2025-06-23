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

def load_separators(include_path_separator=True):
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

def _generate_fuzzy_regex(part):
    """Generates a regex for a name part that accounts for common character substitutions."""
    # This could be expanded or loaded from config
    substitutions = {
        'o': '[o0ôöó]', 'e': '[e3€]', 'a': '[a@4àáâä]', 's': '[s5$]',
        'i': '[i1íìîï]', 'l': '[l1|]', 'z': '[z2]', 't': '[t7+]',
    }
    fuzzy_pattern = ""
    for char in part.lower():
        if char in substitutions:
            fuzzy_pattern += substitutions[char]
        else:
            fuzzy_pattern += re.escape(char)
    return fuzzy_pattern

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
    This function will repeatedly scan the filename and extract all possible name parts
    and compound name patterns until no more matches can be found.
    """
    debug_print(f"START: Processing filename: '{filename}' with name: '{name_to_match}'")
    name_parts = [p.lower() for p in name_to_match.split() if p]
    if not name_parts:
        return f"|{filename}|false"

    first_name, last_name = (name_parts[0], name_parts[-1]) if len(name_parts) > 1 else (name_parts[0], '')
    first_initial, last_initial = first_name[0], last_name[0] if last_name else ''
    
    sep = load_separators()
    
    # Define patterns in order of precedence. Non-capturing group for boundaries.
    patterns = []
    if first_name and last_name:
        # Compound patterns (treated as a single token)
        patterns.append(rf"(?:^|{sep})({re.escape(first_initial)}{sep}+{re.escape(last_name)})(?=$|{sep})")
        patterns.append(rf"(?:^|{sep})({re.escape(first_name)}{sep}+{re.escape(last_initial)})(?=$|{sep})")
        patterns.append(rf"(?:^|{sep})({re.escape(first_initial)}{sep}+{re.escape(last_initial)})(?=$|{sep})")
        patterns.append(rf"(?:^|{sep})({re.escape(first_initial)}{re.escape(last_initial)})(?=$|{sep})")
    
    # Full name patterns (will be split into parts)
    if first_name and last_name:
        patterns.append(rf"({re.escape(first_name)}{sep}+{re.escape(last_name)})")
        patterns.append(rf"({re.escape(last_name)}{sep}+{re.escape(first_name)})")

    # Individual name parts
    all_name_parts = set(name_parts)
    for part in all_name_parts:
        fuzzy_part_regex = _generate_fuzzy_regex(part)
        patterns.append(rf"(?:^|{sep})({fuzzy_part_regex})(?=$|{sep})")
        
    full_regex = re.compile('|'.join(p for p in patterns if p), re.IGNORECASE)
    
    extracted_pieces = []
    work_filename = filename
    
    match_spans = []

    while True:
        match = full_regex.search(work_filename)
        if not match:
            break

        # Find the first non-None group to get the actual matched text and its span
        group_index = next(i for i, g in enumerate(match.groups()) if g is not None)
        match_text = match.group(group_index + 1)
        match_span = match.span(group_index + 1)
        
        debug_print(f"Found match: '{match_text}' at span {match_span}")
        match_spans.append(match_span)

        # Split full names by separators, but keep compound matches whole
        is_compound = any(
            re.fullmatch(p.replace(f"(?:^|{sep})", "").replace(f"(?=$|{sep})", ""), match_text, re.IGNORECASE)
            for p in patterns[:4] # Compound patterns are the first 4
        )

        if is_compound:
            extracted_pieces.append(match_text)
        else:
            parts = re.split(sep, match_text)
            extracted_pieces.extend(p for p in parts if p)

        # Blank out the matched part in the work filename to prevent re-matching
        start, end = match_span
        work_filename = work_filename[:start] + ("_" * (end - start)) + work_filename[end:]
        debug_print(f"Work filename now: '{work_filename}'")

    if not extracted_pieces:
        return f"|{filename}|false"

    final_extracted = ",".join(extracted_pieces)
    
    # Rebuild the remainder from the original filename using the collected spans
    remainder = ""
    last_end = 0
    # Sort spans to process them in order
    for start, end in sorted(match_spans):
        remainder += filename[last_end:start]
        last_end = end
    remainder += filename[last_end:]


    debug_print(f"FINAL: Extracted: '{final_extracted}', Remainder: '{remainder}'")
    return f"{final_extracted}|{remainder}|true"

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
    sep = load_separators()
    # We only care about the first part of the name_to_match for this function
    first_name = name_to_match.split()[0]
    
    # Use the fuzzy regex for the first name part
    fuzzy_pattern = _generate_fuzzy_regex(first_name)
    pattern = re.compile(rf"(?:^|{sep})({fuzzy_pattern})(?=$|{sep})", re.IGNORECASE)
    
    first_match = pattern.search(filename)
    if not first_match:
        return f"|{filename}|false"
    
    # The actual matched text from the filename (e.g., 'j0hn')
    matched_name = first_match.group(1)
    
    # To get the remainder, we remove the full match (group 0), which includes separators.
    start, end = first_match.span(0)
    remainder = filename[:start] + filename[end:]
    
    return f"{matched_name}|{remainder}|true"

def extract_last_name_only(filename: str, name_to_match: str) -> str:
    """
    Extract only the last name from a filename.
    Returns: matched_name|remainder|matched
    """
    sep = load_separators()
    # We only care about the last part of the name_to_match for this function
    name_parts = name_to_match.split()
    if not name_parts:
        return f"|{filename}|false"
    last_name = name_parts[-1]

    # Use the fuzzy regex for the last name part
    fuzzy_pattern = _generate_fuzzy_regex(last_name)
    pattern = re.compile(rf"{fuzzy_pattern}(?=$|{sep})", re.IGNORECASE)
    
    match = pattern.search(filename)
    if not match:
        return f"|{filename}|false"
        
    matched_name = match.group(0)
    start, end = match.span(0)
    remainder = filename[:start] + filename[end:]
    
    return f"{matched_name}|{remainder}|true"

def extract_shorthand(filename: str, name_to_match: str) -> str:
    """
    Extracts shorthand name patterns like 'j-doe' or 'john-d'.
    """
    sep = load_separators()
    name_parts = name_to_match.split()
    if len(name_parts) < 2:
        return f"|{filename}|false"

    first_name, last_name = name_parts[0], name_parts[-1]
    first_initial, last_initial = first_name[0], last_name[0]

    # Pattern 1: j-doe, j_doe, j doe, j.doe
    # Fuzzy match on the last name part
    fuzzy_last_name = _generate_fuzzy_regex(last_name)
    pattern1_str = rf"(?:^|{sep})({re.escape(first_initial)}{sep}{fuzzy_last_name})(?=$|{sep})"
    
    # Pattern 2: john-d, john_d, john d, john.d
    # Fuzzy match on the first name part
    fuzzy_first_name = _generate_fuzzy_regex(first_name)
    pattern2_str = rf"(?:^|{sep})({fuzzy_first_name}{sep}{re.escape(last_initial)})(?=$|{sep})"

    # Combine patterns and search
    pattern = re.compile(f"{pattern1_str}|{pattern2_str}", re.IGNORECASE)
    match = pattern.search(filename)

    if match:
        # Find which group was captured to get the correct text
        matched_text = next(g for g in match.groups() if g is not None)
        start, end = match.span(0)
        remainder = filename[:start] + filename[end:]
        return f"{matched_text}|{remainder}|true"

    return f"|{filename}|false"

def separator_char_class():
    """Return a regex character class for all separators from YAML config."""
    seps = load_separator_list()
    return '[' + ''.join(re.escape(s) for s in seps) + ']'

def extract_initials_only(filename: str, name_to_match: str) -> str:
    """
    Extract only initials from a filename. This handles separated (j-d) and grouped (jd) initials.
    """
    parts = name_to_match.split()
    if len(parts) < 2:
        return f"|{filename}|false"
    first_initial = parts[0][0].lower()
    last_initial = parts[1][0].lower()

    sep = load_separators(include_path_separator=False)
    sep_class = separator_char_class()
    debug_print(f"[DEBUG] sep regex: {sep}")
    # Pattern 1: separated initials (j-d, j_d, j.d, j d, etc.)
    pattern_sep = re.compile(rf"(?:^|{sep})({re.escape(first_initial)}{sep_class}+{re.escape(last_initial)})(?=$|{sep})", re.IGNORECASE)
    match = pattern_sep.search(filename)
    if match:
        matched_text = match.group(1)
        start, end = match.span(0)
        remainder = filename[:start] + filename[end:]
        return f"{matched_text}|{remainder}|true"
    # Pattern 2: grouped initials (jd)
    pattern_grouped = re.compile(rf"(?:^|{sep})({re.escape(first_initial)}{re.escape(last_initial)})(?=$|{sep})", re.IGNORECASE)
    match = pattern_grouped.search(filename)
    if match:
        matched_text = match.group(1)
        start, end = match.span(0)
        remainder = filename[:start] + filename[end:]
        return f"{matched_text}|{remainder}|true"
    return f"|{filename}|false"

def load_separator_list():
    """Load the ordered list of separators from the YAML config."""
    config_path = os.path.join(os.path.dirname(os.path.dirname(os.path.dirname(__file__))), 'config', 'separators.yaml')
    with open(config_path, 'r') as f:
        config = yaml.safe_load(f)
    return config['default_separators']['standard']

def clean_filename_remainder_py(remainder):
    """
    Clean a filename remainder by collapsing runs of consecutive separators to the most preferred one (from YAML order).
    """
    # Split extension
    if '.' in remainder:
        base, ext = remainder.rsplit('.', 1)
        ext = '.' + ext
    else:
        base, ext = remainder, ''
    seps = load_separator_list()
    # Build a regex that matches any run of 2+ separators (in any order)
    sep_class = ''.join(re.escape(s) for s in seps)
    def replace_run(match):
        run = match.group(0)
        for sep in seps:
            if sep in run:
                return sep
        return run[0]  # fallback
    # Collapse runs of 2+ separators to the most preferred
    cleaned = re.sub(rf'[{sep_class}]{{2,}}', replace_run, base)
    # Remove leading/trailing separators (least preferred first)
    for sep in reversed(seps):
        cleaned = cleaned.lstrip(sep)
        cleaned = cleaned.rstrip(sep)
    return cleaned + ext

def main():
    """Main function to process command line arguments."""
    if len(sys.argv) > 1 and sys.argv[1] == '--clean-filename':
        remainder = sys.argv[2]
        print(clean_filename_remainder_py(remainder))
        return

    if len(sys.argv) < 3:
        # Only print errors to stderr
        print(json.dumps({
            "error": "Usage: name_matcher.py <filename> <target_name> [function_name]"
        }), file=sys.stderr)
        sys.exit(1)

    filename = sys.argv[1]
    target_name = sys.argv[2]
    function_name = sys.argv[3] if len(sys.argv) > 3 else "extract_name_from_filename"

    # Get the function from the global scope
    matcher_function = globals().get(function_name)

    if not matcher_function or not callable(matcher_function):
        print(json.dumps({
            "error": f"Invalid function name provided: {function_name}"
        }), file=sys.stderr)
        sys.exit(1)
        
    result = matcher_function(filename, target_name)
    print(result)  # Only print the result to stdout

if __name__ == "__main__":
    main() 