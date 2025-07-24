#!/usr/bin/env python3

"""
Name Matcher Utility for Filename Processing.

This module provides comprehensive name extraction functionality for filenames using
multiple algorithms including fuzzy matching, initials detection, shorthand patterns,
and configurable separators. It handles various name formats and provides cleaning
and normalization capabilities.

File Path: core/utils/name_matcher.py

@package VisualCare\\FileMigration\\Utils
@since   1.0.0

Algorithms:
- Full name extraction with fuzzy character substitution
- Initials detection (grouped and separated)
- Shorthand patterns (j-doe, john-d)
- First/last name individual extraction
- Configurable separator handling
- Remainder cleaning and normalization

Configuration:
- Loads separators from config/components.yaml
- Supports fuzzy character substitutions
- Configurable separator precedence for cleaning
- Extension preservation during processing

Returns:
- Pipe-separated strings: extracted_name|remainder|matched
- Supports both cleaned and raw remainder modes
"""

import re
import sys
import json
import yaml
import os
from typing import Tuple, List, Optional

def debug_print(*args, **kwargs):
    """Print debug messages to stderr."""
    print(*args, file=sys.stderr, **kwargs)

def load_config():
    config_path = os.path.join(os.path.dirname(os.path.dirname(os.path.dirname(__file__))), 'config', 'components.yaml')
    with open(config_path, 'r') as f:
        return yaml.safe_load(f)

def load_separators_for_searching():
    config = load_config()
    return config['Name']['allowed_separators_when_searching']

def load_allowed_separators_for_name():
    config = load_config()
    return config['Name']['allowed_separators']

def load_remainder_allowed_separators():
    config = load_config()
    return config['Remainder']['allowed_separators']

def separator_regex_for_searching():
    seps = load_separators_for_searching()
    return '(?:' + '|'.join(re.escape(sep) for sep in seps) + ')'

def separator_char_class_for_remainder():
    seps = load_remainder_allowed_separators()
    return '[' + ''.join(re.escape(s) for s in seps) + ']'

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
    sep_regex = separator_regex_for_searching()  # dynamically loaded separator regex
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
    Extract all name matches from filename using the new type-based processing algorithm.
    
    Processing order:
    1. Find all shorthand patterns first (prevents incorrect splitting)
    2. Find all remaining initials patterns
    3. Find all remaining first name matches
    4. Find all remaining last name matches
    5. Clean remainder using separator precedence from config
    
    Returns: extracted_names|raw_remainder|match_status
    """
    # debug_print(f"START: Processing filename: '{filename}' with name: '{name_to_match}'")
    name_parts = [p for p in name_to_match.split() if p]
    if not name_parts:
        return f"|{filename}|false"
    
    extracted_pieces = []
    work_filename = filename
    
    # Step 1: Find all shorthand patterns first
    # debug_print("Step 1: Finding all shorthand patterns")
    shorthand_matches = []
    while True:
        result = extract_shorthand_name_from_filename(work_filename, name_to_match, clean_filename=False)
        if result.startswith('|') or result.split('|')[2] != 'true':
            break
        extracted, remainder, _ = result.split('|')
        shorthand_matches.append(extracted)
        if work_filename == remainder:
            break  # Prevent infinite loop
        work_filename = remainder
        # debug_print(f"Found shorthand: '{extracted}', remainder: '{work_filename}'")
    extracted_pieces.extend(shorthand_matches)
    
    # Step 2: Find all remaining initials patterns
    # debug_print("Step 2: Finding all initials patterns")
    initials_matches = []
    while True:
        result = extract_initials_from_filename(work_filename, name_to_match, clean_filename=False)
        if result.startswith('|') or result.split('|')[2] != 'true':
            break
        extracted, remainder, _ = result.split('|')
        initials_matches.append(extracted)
        if work_filename == remainder:
            break  # Prevent infinite loop
        work_filename = remainder
        # debug_print(f"Found initials: '{extracted}', remainder: '{work_filename}'")
    extracted_pieces.extend(initials_matches)
    
    # Step 3: Find all remaining first name matches
    # debug_print("Step 3: Finding all first name matches")
    first_name_matches = []
    while True:
        result = extract_first_name_from_filename(work_filename, name_to_match, clean_filename=False)
        if result.startswith('|') or result.split('|')[2] != 'true':
            break
        extracted, remainder, _ = result.split('|')
        first_name_matches.append(extracted)
        if work_filename == remainder:
            break  # Prevent infinite loop
        work_filename = remainder
        # debug_print(f"Found first name: '{extracted}', remainder: '{work_filename}'")
    extracted_pieces.extend(first_name_matches)
    
    # Step 4: Find all remaining last name matches
    # debug_print("Step 4: Finding all last name matches")
    last_name_matches = []
    while True:
        result = extract_last_name_from_filename(work_filename, name_to_match, clean_filename=False)
        if result.startswith('|') or result.split('|')[2] != 'true':
            break
        extracted, remainder, _ = result.split('|')
        last_name_matches.append(extracted)
        if work_filename == remainder:
            break  # Prevent infinite loop
        work_filename = remainder
        # debug_print(f"Found last name: '{extracted}', remainder: '{work_filename}'")
    extracted_pieces.extend(last_name_matches)
    
    if not extracted_pieces:
        return f"|{filename}|false"
    
    # Return the raw remainder (before cleaning) as expected by tests
    final_extracted = ','.join(extracted_pieces)
    # debug_print(f"FINAL: Extracted: '{final_extracted}', Raw remainder: '{work_filename}'")
    return f"{final_extracted}|{work_filename}|true"

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

def extract_first_name_from_filename(filename: str, name_to_match: str, clean_filename: bool = True) -> str:
    """
    Extract only the first name from a filename.
    Returns: matched_name|remainder|matched
    """
    sep = separator_regex_for_searching()
    first_name = name_to_match.split()[0]
    fuzzy_pattern = _generate_fuzzy_regex(first_name)
    # Capture the leading separator (or start) and the name
    pattern = re.compile(rf"(^|{sep})({fuzzy_pattern})(?=$|{sep})", re.IGNORECASE)
    first_match = pattern.search(filename)
    if not first_match:
        return f"|{filename}|false"
    matched_name = first_match.group(2)
    if clean_filename:
        start, end = first_match.span(0)
        remainder = filename[:start] + filename[end:]
        remainder = clean_filename_remainder_py(remainder)
    else:
        # Remove only the name, not the leading separator
        sep_start, sep_end = first_match.span(1)
        name_start, name_end = first_match.span(2)
        remainder = filename[:sep_end] + filename[name_end:]
    return f"{matched_name}|{remainder}|true"

def extract_last_name_from_filename(filename: str, name_to_match: str, clean_filename: bool = True) -> str:
    """
    Extract only the last name from a filename.
    Returns: matched_name|remainder|matched
    """
    sep = separator_regex_for_searching()
    name_parts = name_to_match.split()
    if not name_parts:
        return f"|{filename}|false"
    last_name = name_parts[-1]
    fuzzy_pattern = _generate_fuzzy_regex(last_name)
    pattern = re.compile(rf"{fuzzy_pattern}(?=$|{sep})", re.IGNORECASE)
    match = pattern.search(filename)
    if not match:
        return f"|{filename}|false"
    matched_name = match.group(0)
    if clean_filename:
        start, end = match.span(0)
        remainder = filename[:start] + filename[end:]
        remainder = clean_filename_remainder_py(remainder)
    else:
        start, end = match.span(0)
        remainder = filename[:start] + filename[end:]
    return f"{matched_name}|{remainder}|true"

def extract_shorthand_name_from_filename(filename: str, name_to_match: str, clean_filename: bool = True) -> str:
    """
    Extracts shorthand name patterns like 'j-doe' or 'john-d'.
    """
    sep = separator_regex_for_searching()
    name_parts = name_to_match.split()
    if len(name_parts) < 2:
        return f"|{filename}|false"
    first_name, last_name = name_parts[0], name_parts[-1]
    first_initial, last_initial = first_name[0], last_name[0]
    fuzzy_first_initial = _generate_fuzzy_regex(first_initial)
    fuzzy_last_name = _generate_fuzzy_regex(last_name)
    # Capture the leading separator (or start) and the shorthand
    pattern1_str = rf"(^|{sep})({fuzzy_first_initial}{sep}{fuzzy_last_name})(?=$|{sep})"
    fuzzy_first_name = _generate_fuzzy_regex(first_name)
    fuzzy_last_initial = _generate_fuzzy_regex(last_initial)
    pattern2_str = rf"(^|{sep})({fuzzy_first_name}{sep}{fuzzy_last_initial})(?=$|{sep})"
    pattern3_str = rf"(^|{sep})({fuzzy_first_initial}{fuzzy_last_name})(?=$|{sep})"
    pattern = re.compile(f"{pattern1_str}|{pattern2_str}|{pattern3_str}", re.IGNORECASE)
    match = pattern.search(filename)
    if match:
        # Find which group matched
        matched_text = None
        for i in [2, 4, 6]:
            if match.group(i) is not None:
                matched_text = match.group(i)
                sep_start, sep_end = match.span(i-1)
                name_start, name_end = match.span(i)
                break
        if matched_text is None:
            return f"|{filename}|false"
        if clean_filename:
            start, end = match.span(0)
            remainder = filename[:start] + filename[end:]
            remainder = clean_filename_remainder_py(remainder)
        else:
            # Remove only the name, not the leading separator
            remainder = filename[:sep_end] + filename[name_end:]
        return f"{matched_text}|{remainder}|true"
    return f"|{filename}|false"

def separator_char_class():
    """Return a regex character class for all separators from YAML config."""
    seps = load_separators_for_searching()
    return '[' + ''.join(re.escape(s) for s in seps) + ']'

def extract_initials_from_filename(filename: str, name_to_match: str, clean_filename: bool = True) -> str:
    """
    Extract only initials from a filename. This handles separated (j-d) and grouped (jd) initials.
    """
    parts = name_to_match.split()
    if len(parts) < 2:
        return f"|{filename}|false"
    first_initial = parts[0][0].lower()
    last_initial = parts[1][0].lower()
    sep = separator_regex_for_searching()
    sep_class = separator_char_class()
    # Capture the leading separator (or start) and the initials
    pattern_sep = re.compile(rf"(^|{sep})({re.escape(first_initial)}{sep_class}+{re.escape(last_initial)})(?=$|{sep})", re.IGNORECASE)
    match = pattern_sep.search(filename)
    if match:
        matched_text = match.group(2)
        if clean_filename:
            start, end = match.span(0)
            remainder = filename[:start] + filename[end:]
            remainder = clean_filename_remainder_py(remainder)
        else:
            sep_start, sep_end = match.span(1)
            name_start, name_end = match.span(2)
            remainder = filename[:sep_end] + filename[name_end:]
        return f"{matched_text}|{remainder}|true"
    pattern_grouped = re.compile(rf"(^|{sep})({re.escape(first_initial)}{re.escape(last_initial)})(?=$|{sep})", re.IGNORECASE)
    match = pattern_grouped.search(filename)
    if match:
        matched_text = match.group(2)
        if clean_filename:
            start, end = match.span(0)
            remainder = filename[:start] + filename[end:]
            remainder = clean_filename_remainder_py(remainder)
        else:
            sep_start, sep_end = match.span(1)
            name_start, name_end = match.span(2)
            remainder = filename[:sep_end] + filename[name_end:]
        return f"{matched_text}|{remainder}|true"
    return f"|{filename}|false"

def clean_filename_remainder_py(remainder):
    """
    Clean a filename remainder by collapsing runs of consecutive allowed separators to the most preferred one (from YAML order),
    and replacing reserved/component separators (e.g., underscores) with the configured remainder_separator.
    """
    if not remainder:
        return remainder
    
    # Split extension to preserve it
    if '.' in remainder:
        base, ext = remainder.rsplit('.', 1)
        ext = '.' + ext
    else:
        base, ext = remainder, ''
    
    # Step 0: Replace forward slashes with spaces (for folder separators)
    base = base.replace('/', ' ')
    
    # Load separators in order (most preferred first)
    seps = load_remainder_allowed_separators()
    # Load the configured remainder separator
    config = load_config()
    remainder_sep = config.get('Remainder', {}).get('remainder_separator', ' ')
    # Replace underscores and any reserved/component separators with the configured remainder separator
    reserved_seps = ['_']  # Add more if needed
    for sep in reserved_seps:
        base = base.replace(sep, remainder_sep)
    # Build regex to match any run of 2+ separators
    sep_class = ''.join(re.escape(s) for s in seps)
    def replace_run(match):
        """Replace a run of separators with the most preferred one."""
        run = match.group(0)
        for sep in seps:  # seps is already in preference order
            if sep in run:
                return sep
        return run[0]
    # Step 1: Collapse runs of 2+ separators to the most preferred
    cleaned = re.sub(rf'[{sep_class}]{{2,}}', replace_run, base)
    # Step 2: Remove leading separators (least preferred first)
    for sep in reversed(seps):  # Start with least preferred
        cleaned = cleaned.lstrip(sep)
    # Step 3: Remove trailing separators (least preferred first)
    for sep in reversed(seps):  # Start with least preferred
        cleaned = cleaned.rstrip(sep)
    result = cleaned + ext
    return result

def extract_name_and_date_from_filename(filename: str, name_to_match: str) -> str:
    """
    Extract both name and date from a filename using existing extraction logic.
    Returns: extracted_name|extracted_date|raw_remainder|name_matched|date_matched
    If no date is found, extracted_date is empty and date_matched is false.
    If no name is found, extracted_name is empty and name_matched is false.
    raw_remainder is the filename with both name and date removed (uncleaned).
    TODO: Add file metadata fallback for date if not found in filename.
    """
    # Extract name
    name_result = extract_name_from_filename(filename, name_to_match)
    extracted_name, name_remainder, name_matched = name_result.split('|')
    # Import and call date extraction
    import importlib.util, os
    date_matcher_path = os.path.join(os.path.dirname(__file__), 'date_matcher.py')
    spec = importlib.util.spec_from_file_location('date_matcher', date_matcher_path)
    date_matcher = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(date_matcher)
    date_result = date_matcher.extract_date_matches(name_remainder)
    extracted_date, date_remainder, date_matched = date_result.split('|')
    # Return the raw remainder (uncleaned) as the third field
    return f"{extracted_name}|{extracted_date}|{date_remainder}|{name_matched}|{date_matched}"

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
        
    # For individual matcher functions, pass clean_filename=False to preserve raw remainder
    if function_name in ["extract_first_name_from_filename", "extract_last_name_from_filename", "extract_initials_from_filename", "extract_shorthand_name_from_filename"]:
        result = matcher_function(filename, target_name, clean_filename=False)
        print(result)  # Only print the result to stdout
    else:
        result = matcher_function(filename, target_name)
        print(result)  # Only print the result to stdout

if __name__ == "__main__":
    main() 