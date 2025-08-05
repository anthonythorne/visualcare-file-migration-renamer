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
- Extraction order is now fully configurable via config/components.yaml (Name.extraction_order)
- Full name extraction with fuzzy character substitution
- Initials detection (grouped and separated)
- Shorthand patterns (j-doe, john-d)
- First/last name individual extraction
- Configurable separator handling
- Remainder cleaning and normalization

Configuration:
- Loads separators and extraction order from config/components.yaml
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

def load_global_separators():
    config = load_config()
    return config['Global']['separators']['input']

def get_normalized_separator():
    config = load_config()
    return config['Global']['separators']['normalized']

def separator_regex_for_searching():
    seps = load_global_separators()
    return '(?:' + '|'.join(re.escape(sep) for sep in seps) + ')'

def separator_char_class_for_remainder():
    seps = load_global_separators()
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

def get_extraction_order():
    config = load_config()
    return config.get('Name', {}).get('extraction_order', [
        'shorthand', 'initials', 'name_components'
    ])

def extract_all_name_matches(filename: str, name_to_match: str) -> str:
    """
    Extract all possible name matches following the configured extraction order.
    For 2+ name patterns, uses extract_name_part_from_filename for full name extraction.
    Returns: extracted_names|raw_remainder|cleaned_remainder|matched
    """
    name_parts = name_to_match.split()
    extracted = []
    raw_remainder = filename
    matched = False
    
    # Get the configured extraction order
    extraction_order = get_extraction_order()
    
    # For 2+ name patterns, handle differently
    if len(name_parts) >= 2:
        # Try shorthand first (should fail for 3+ names)
        if 'shorthand' in extraction_order:
            result = extract_shorthand_name_from_filename(raw_remainder, name_to_match, clean_filename=False)
            parts = result.split('|')
            if parts[2] == 'true':  # matched
                # Split by comma to get individual shorthands
                shorthands = parts[0].split(',')
                extracted.extend(shorthands)
                raw_remainder = parts[1]
                matched = True
        
        # Try initials
        if 'initials' in extraction_order and not matched:
            result = extract_initials_from_filename(raw_remainder, name_to_match, clean_filename=False)
            parts = result.split('|')
            if parts[2] == 'true':  # matched
                # Split by comma to get individual initials
                initials = parts[0].split(',')
                extracted.extend(initials)
                raw_remainder = parts[1]
                matched = True
        
        # Try name components extraction - extract all components in one call
        if 'name_components' in extraction_order:
            result = extract_name_part_from_filename(raw_remainder, name_to_match, clean_filename=False)
            parts = result.split('|')
            if parts[2] == 'true':  # matched
                # The new extract_name_part_from_filename returns individual components in canonical order
                # Split by comma to get individual names
                name_parts_extracted = parts[0].split(',')
                extracted.extend(name_parts_extracted)
                raw_remainder = parts[1]
                matched = True
        
        # Don't try middle_name or last_name for 2+ name patterns
        # as they would conflict with the full name extraction
    
    # For single name patterns, use the original logic
    else:
        # Process each extraction type in order
        for extraction_type in extraction_order:
            if extraction_type == 'shorthand':
                # Only allow shorthand for 2-name patterns
                if len(name_parts) == 2:
                    result = extract_shorthand_name_from_filename(raw_remainder, name_to_match, clean_filename=False)
                    parts = result.split('|')
                    if parts[2] == 'true':  # matched
                        # Split by comma to get individual shorthands
                        shorthands = parts[0].split(',')
                        extracted.extend(shorthands)
                        raw_remainder = parts[1]
                        matched = True
            elif extraction_type == 'initials':
                # Find all initials matches - now handles 4+ name patterns
                result = extract_initials_from_filename(raw_remainder, name_to_match, clean_filename=False)
                parts = result.split('|')
                if parts[2] == 'true':  # matched
                    # Split by comma to get individual initials
                    initials = parts[0].split(',')
                    extracted.extend(initials)
                    raw_remainder = parts[1]
                    matched = True
            elif extraction_type == 'name_components':
                # Extract all name components in one call
                result = extract_name_part_from_filename(raw_remainder, name_to_match, clean_filename=False)
                parts = result.split('|')
                if parts[2] == 'true':  # matched
                    # The new extract_name_part_from_filename returns individual components in canonical order
                    # Split by comma to get individual names
                    name_parts_extracted = parts[0].split(',')
                    extracted.extend(name_parts_extracted)
                    raw_remainder = parts[1]
                    matched = True
    
    cleaned_remainder = clean_filename_remainder_py(raw_remainder)
    return f"{','.join(extracted)}|{raw_remainder}|{cleaned_remainder}|{'true' if matched else 'false'}"

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

def extract_name_part_from_filename(filename: str, name_to_match: str, clean_filename: bool = True) -> str:
    """
    Extract individual name components from a filename in canonical order.
    For 2+ name patterns, extracts each name component individually in the order they appear in name_to_match.
    For multiple matches, extracts ALL occurrences of each name component (all first names, then all last names, etc.).
    Handles mixed separators and flexible spacing.
    Returns: matched_name|remainder|matched
    """
    name_parts = name_to_match.split()
    if len(name_parts) < 2:
        return f"|{filename}|false"
    
    extracted_names = []
    current_filename = filename
    input_seps = load_global_separators()
    sep_pattern = '|'.join([re.escape(sep) for sep in input_seps])
    sep_class = f'[{sep_pattern}]'
    
    # For raw remainder, we need to track the exact separators between names
    if not clean_filename:
        # Find ALL name matches first to preserve exact separators
        name_matches = []
        temp_filename = filename
        
        # For each name part, find ALL occurrences
        for name_part in name_parts:
            name_pattern = _generate_fuzzy_regex(name_part)
            # Pattern 1: Name part surrounded by separators or at start/end
            pattern1 = re.compile(rf"(^|{sep_class})({name_pattern})(?=$|{sep_class})", re.IGNORECASE)
            # Pattern 2: Name part as part of a concatenated name (no separators)
            pattern2 = re.compile(rf"({name_pattern})", re.IGNORECASE)
            
            # Find all matches for this name part in the original filename
            matches = list(pattern1.finditer(filename))
            # Also find concatenated matches
            concat_matches = list(pattern2.finditer(filename))
            
            # Add separator-bounded matches
            for match in matches:
                name_matches.append({
                    'name': match.group(2),
                    'start': match.start(2),
                    'end': match.end(2),
                    'full_start': match.start(0),
                    'full_end': match.end(0),
                    'name_part': name_part,  # Track which name part this is
                    'type': 'separated'
                })
            
            # Add concatenated matches (but avoid duplicates)
            for match in concat_matches:
                # Check if this match is already covered by a separator-bounded match
                is_duplicate = False
                for existing in name_matches:
                    if (existing['start'] <= match.start() and existing['end'] >= match.end() and 
                        existing['name_part'] == name_part):
                        is_duplicate = True
                        break
                
                if not is_duplicate:
                    name_matches.append({
                        'name': match.group(1),
                        'start': match.start(1),
                        'end': match.end(1),
                        'full_start': match.start(0),
                        'full_end': match.end(0),
                        'name_part': name_part,  # Track which name part this is
                        'type': 'concatenated'
                    })
        
        if not name_matches:
            return f"|{filename}|false"
        
        # Sort matches by position to maintain order
        name_matches.sort(key=lambda x: x['start'])
        
        # Extract names in canonical order: all first names, then all last names, etc.
        for name_part in name_parts:
            for match in name_matches:
                if match['name_part'].lower() == name_part.lower():
                    extracted_names.append(match['name'])
        
        # Build raw remainder by preserving the original separators that were between names
        # Start with the original filename
        raw_remainder = filename
        
        # Replace each matched name with a placeholder, working backwards to maintain positions
        for i, match in enumerate(reversed(name_matches)):
            raw_remainder = raw_remainder[:match['start']] + f"_NAME_{i}_" + raw_remainder[match['end']:]
        
        # Replace placeholders with empty strings (remove the names completely)
        # The separators that were between the names will remain in the raw_remainder
        for i in range(len(name_matches)):
            raw_remainder = raw_remainder.replace(f"_NAME_{i}_", "")
        
        current_filename = raw_remainder
    
    else:
        # For clean filename, use the original logic
        for name_part in name_parts:
            name_pattern = _generate_fuzzy_regex(name_part)
            # Pattern 1: Name part surrounded by separators or at start/end
            pattern1 = re.compile(rf"(^|{sep_class})({name_pattern})(?=$|{sep_class})", re.IGNORECASE)
            # Pattern 2: Name part as part of a concatenated name (no separators)
            pattern2 = re.compile(rf"({name_pattern})", re.IGNORECASE)
            
            # Try separator-bounded match first
            match = pattern1.search(current_filename)
            if match:
                extracted_names.append(match.group(2))
                start, end = match.span(0)
                current_filename = current_filename[:start] + current_filename[end:]
                current_filename = clean_filename_remainder_py(current_filename)
            else:
                # Try concatenated match
                match = pattern2.search(current_filename)
                if match:
                    extracted_names.append(match.group(1))
                    start, end = match.span(0)
                    current_filename = current_filename[:start] + current_filename[end:]
                    current_filename = clean_filename_remainder_py(current_filename)
                else:
                    continue
    
    if not extracted_names:
        return f"|{filename}|false"
    
    # Join the extracted names in canonical order
    matched_name = ",".join(extracted_names)
    
    return f"{matched_name}|{current_filename}|true"





def extract_shorthand_name_from_filename(filename: str, name_to_match: str, clean_filename: bool = True) -> str:
    """
    Extracts shorthand name patterns like 'j-doe' or 'john-d'.
    Only works for 2-name patterns.
    Finds ALL occurrences of shorthand patterns.
    """
    sep = separator_regex_for_searching()
    name_parts = name_to_match.split()
    if len(name_parts) != 2:
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
    
    # Find ALL matches
    matches = list(pattern.finditer(filename))
    if not matches:
        return f"|{filename}|false"
    
    # Extract all matched shorthand patterns
    extracted_shorthands = []
    raw_remainder = filename
    
    for match in reversed(matches):  # Process backwards to maintain positions
        # Find which group matched
        matched_text = None
        for i in [2, 4, 6]:
            if match.group(i) is not None:
                matched_text = match.group(i)
                sep_start, sep_end = match.span(i-1)
                name_start, name_end = match.span(i)
                break
        
        if matched_text is not None:
            extracted_shorthands.append(matched_text)
            if clean_filename:
                start, end = match.span(0)
                raw_remainder = raw_remainder[:start] + raw_remainder[end:]
            else:
                # Remove only the name, not the leading separator
                raw_remainder = raw_remainder[:sep_end] + raw_remainder[name_end:]
    
    if clean_filename:
        raw_remainder = clean_filename_remainder_py(raw_remainder)
    
    # Join all extracted shorthands
    matched_text = ",".join(extracted_shorthands)
    return f"{matched_text}|{raw_remainder}|true"

def separator_char_class():
    """Return a regex character class for all separators from YAML config."""
    seps = load_global_separators()
    return '[' + ''.join(re.escape(s) for s in seps) + ']'

def extract_initials_from_filename(filename: str, name_to_match: str, clean_filename: bool = True) -> str:
    """
    Extract initials from a filename. This handles separated and grouped initials for all name parts.
    For 4+ name patterns, extracts initials for all parts (e.g., m-i-r-s for Maria Isabella Rodriguez Santos).
    Finds ALL occurrences of initials patterns.
    """
    parts = name_to_match.split()
    if len(parts) < 2:
        return f"|{filename}|false"
    
    # For 2-name patterns, use the original logic
    if len(parts) == 2:
        first_initial = parts[0][0].lower()
        last_initial = parts[1][0].lower()
        sep = separator_regex_for_searching()
        sep_class = separator_char_class()
        
        # Try separated initials pattern first (e.g., j-d)
        pattern_sep = re.compile(rf"(^|{sep})({re.escape(first_initial)}{sep_class}+{re.escape(last_initial)})(?=$|{sep})", re.IGNORECASE)
        matches = list(pattern_sep.finditer(filename))
        
        if not matches:
            # Try grouped initials pattern (e.g., jd)
            pattern_grouped = re.compile(rf"(^|{sep})({re.escape(first_initial)}{re.escape(last_initial)})(?=$|{sep})", re.IGNORECASE)
            matches = list(pattern_grouped.finditer(filename))
        
        if matches:
            # Extract all matched initials
            extracted_initials = []
            raw_remainder = filename
            
            for match in reversed(matches):  # Process backwards to maintain positions
                matched_text = match.group(2)
                extracted_initials.append(matched_text)
                
                if clean_filename:
                    start, end = match.span(0)
                    raw_remainder = raw_remainder[:start] + raw_remainder[end:]
                else:
                    sep_start, sep_end = match.span(1)
                    name_start, name_end = match.span(2)
                    raw_remainder = raw_remainder[:sep_end] + raw_remainder[name_end:]
            
            if clean_filename:
                raw_remainder = clean_filename_remainder_py(raw_remainder)
            
            # Join all extracted initials
            matched_text = ",".join(extracted_initials)
            return f"{matched_text}|{raw_remainder}|true"
    
    # For 4+ name patterns, extract initials for all parts
    else:
        # Get initials for all name parts
        all_initials = [part[0].lower() for part in parts]
        sep = separator_regex_for_searching()
        sep_class = separator_char_class()
        
        # Try separated initials pattern (e.g., m-i-r-s)
        initials_pattern = sep_class.join([re.escape(initial) for initial in all_initials])
        pattern_sep = re.compile(rf"(^|{sep})({initials_pattern})(?=$|{sep})", re.IGNORECASE)
        matches = list(pattern_sep.finditer(filename))
        
        if not matches:
            # Try grouped initials pattern (e.g., mirs)
            grouped_initials = ''.join(all_initials)
            pattern_grouped = re.compile(rf"(^|{sep})({re.escape(grouped_initials)})(?=$|{sep})", re.IGNORECASE)
            matches = list(pattern_grouped.finditer(filename))
        
        if matches:
            # Extract all matched initials
            extracted_initials = []
            raw_remainder = filename
            
            for match in reversed(matches):  # Process backwards to maintain positions
                matched_text = match.group(2)
                extracted_initials.append(matched_text)
                
                if clean_filename:
                    start, end = match.span(0)
                    raw_remainder = raw_remainder[:start] + raw_remainder[end:]
                else:
                    sep_start, sep_end = match.span(1)
                    name_start, name_end = match.span(2)
                    raw_remainder = raw_remainder[:sep_end] + raw_remainder[name_end:]
            
            if clean_filename:
                raw_remainder = clean_filename_remainder_py(raw_remainder)
            
            # Join all extracted initials
            matched_text = ",".join(extracted_initials)
            return f"{matched_text}|{raw_remainder}|true"
    
    return f"|{filename}|false"

def clean_filename_remainder_py(remainder):
    """
    Clean a filename remainder by replacing all input separators with the normalized separator,
    collapsing runs of separators, and trimming leading/trailing separators.
    """
    import re
    
    if not remainder:
        return remainder
        
    # STEP 1: Normalize date ranges first using centralized utility (on full remainder)
    try:
        from core.utils.date_utils import is_date_range_and_normalize
    except ImportError:
        # If core module is not in path, try relative import
        import sys
        import os
        sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..', '..'))
        from core.utils.date_utils import is_date_range_and_normalize
    
    config = load_config()
    date_normalized_separator = config.get("Date", {}).get("exclude_ranges_normalized_separator", " - ")
    exclude_ranges_separators = config.get('Date', {}).get('exclude_ranges_separators', [" ", "-", "_", ".", ","])
    
    # Check if this is a date range and normalize it
    is_range, normalized_range = is_date_range_and_normalize(remainder, config)
    
    if is_range and normalized_range:
        # Replace the original range with the normalized version
        # Find the original range pattern to replace it
        allowed_formats = config.get('Date', {}).get('allowed_formats', ['%Y-%m-%d'])
        
        # Create date patterns for all allowed formats
        date_patterns_for_ranges = []
        for fmt in allowed_formats:
            if fmt == "%Y-%m-%d":
                date_patterns_for_ranges.append(r'\d{4}-\d{1,2}-\d{1,2}')
            elif fmt == "%d-%m-%Y":
                date_patterns_for_ranges.append(r'\d{1,2}-\d{1,2}-\d{4}')
            elif fmt == "%Y%m%d":
                date_patterns_for_ranges.append(r'\d{8}')
            elif fmt == "%d%m%Y":
                date_patterns_for_ranges.append(r'\d{8}')
            elif fmt == "%m%d%Y":
                date_patterns_for_ranges.append(r'\d{8}')
            elif fmt == "%d-%b-%Y":
                date_patterns_for_ranges.append(r'\d{1,2}-(?:Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec)-\d{4}')
            elif fmt == "%b-%d-%Y":
                date_patterns_for_ranges.append(r'(?:Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec)-\d{1,2}-\d{4}')
            elif fmt == "%d %b %Y":
                date_patterns_for_ranges.append(r'\d{1,2} (?:Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec) \d{4}')
            elif fmt == "%B %d, %Y":
                date_patterns_for_ranges.append(r'(?:January|February|March|April|May|June|July|August|September|October|November|December) \d{1,2}, \d{4}')
            elif fmt == "%Y.%m.%d":
                date_patterns_for_ranges.append(r'\d{4}\.\d{1,2}\.\d{1,2}')
            elif fmt == "%d.%m.%Y":
                date_patterns_for_ranges.append(r'\d{1,2}\.\d{1,2}\.\d{4}')
            elif fmt == "%d %B %Y":
                date_patterns_for_ranges.append(r'\d{1,2} (?:January|February|March|April|May|June|July|August|September|October|November|December) \d{4}')
            elif fmt == "%d-%B-%Y":
                date_patterns_for_ranges.append(r'\d{1,2}-(?:January|February|March|April|May|June|July|August|September|October|November|December)-\d{4}')
            elif fmt == "%d/%m/%Y":
                date_patterns_for_ranges.append(r'\d{1,2}/\d{1,2}/\d{4}')
            elif fmt == "%Y/%m/%d":
                date_patterns_for_ranges.append(r'\d{4}/\d{1,2}/\d{1,2}')
            elif fmt == "%d.%m.%y":
                date_patterns_for_ranges.append(r'\d{1,2}\.\d{1,2}\.\d{2}')
            elif fmt == "%d/%m/%y":
                date_patterns_for_ranges.append(r'\d{1,2}/\d{1,2}/\d{2}')
            elif fmt == "%d-%m-%y":
                date_patterns_for_ranges.append(r'\d{1,2}-\d{1,2}-\d{2}')
        
        # Build separator pattern for the original separators
        escaped_separators = [re.escape(sep) for sep in exclude_ranges_separators]
        separator_pattern = '|'.join(escaped_separators)
        
        # Find and replace the original range
        for date_pattern in date_patterns_for_ranges:
            range_pattern = f"{date_pattern}(?:{separator_pattern})*{date_pattern}"
            match = re.search(range_pattern, remainder, re.IGNORECASE)
            if match:
                start, end = match.span()
                remainder = remainder[:start] + normalized_range + remainder[end:]
                break
        # Also try string separators
        separator_strings = config.get('Date', {}).get('exclude_ranges_separator_strings', [])
        for sep_str in separator_strings:
            for date_pattern in date_patterns_for_ranges:
                range_pattern = f"{date_pattern}{re.escape(sep_str)}{date_pattern}"
                match = re.search(range_pattern, remainder, re.IGNORECASE)
                if match:
                    start, end = match.span()
                    remainder = remainder[:start] + normalized_range + remainder[end:]
                    break
    
    # STEP 2: Protect normalized date ranges from general separator normalization
    # Create patterns for normalized date ranges (with the normalized separator)
    normalized_date_patterns = []
    allowed_formats = config.get('Date', {}).get('allowed_formats', ['%Y-%m-%d'])
    
    for fmt in allowed_formats:
        if fmt == "%Y-%m-%d":
            normalized_date_patterns.append(f"\\d{{4}}-\\d{{1,2}}-\\d{{1,2}}{re.escape(date_normalized_separator)}\\d{{4}}-\\d{{1,2}}-\\d{{1,2}}")
        elif fmt == "%d-%m-%Y":
            normalized_date_patterns.append(f"\\d{{1,2}}-\\d{{1,2}}-\\d{{4}}{re.escape(date_normalized_separator)}\\d{{1,2}}-\\d{{1,2}}-\\d{{4}}")
        elif fmt == "%d.%m.%Y":
            pattern = f"\\d{{1,2}}\\.\\d{{1,2}}\\.\\d{{4}}{re.escape(date_normalized_separator)}\\d{{1,2}}\\.\\d{{1,2}}\\.\\d{{4}}"
            normalized_date_patterns.append(pattern)
        elif fmt == "%d/%m/%Y":
            normalized_date_patterns.append(f"\\d{{1,2}}/\\d{{1,2}}/\\d{{4}}{re.escape(date_normalized_separator)}\\d{{1,2}}/\\d{{1,2}}/\\d{{4}}")
        elif fmt == "%Y.%m.%d":
            normalized_date_patterns.append(f"\\d{{4}}\\.\\d{{1,2}}\\.\\d{{1,2}}{re.escape(date_normalized_separator)}\\d{{4}}\\.\\d{{1,2}}\\.\\d{{1,2}}")
        elif fmt == "%Y%m%d":
            normalized_date_patterns.append(f"\\d{{8}}{re.escape(date_normalized_separator)}\\d{{8}}")
        elif fmt == "%d%m%Y":
            normalized_date_patterns.append(f"\\d{{8}}{re.escape(date_normalized_separator)}\\d{{8}}")
        elif fmt == "%m%d%Y":
            normalized_date_patterns.append(f"\\d{{8}}{re.escape(date_normalized_separator)}\\d{{8}}")
        elif fmt == "%d-%b-%Y":
            normalized_date_patterns.append(f"\\d{{1,2}}-(?:Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec)-\\d{{4}}{re.escape(date_normalized_separator)}\\d{{1,2}}-(?:Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec)-\\d{{4}}")
        elif fmt == "%b-%d-%Y":
            normalized_date_patterns.append(f"(?:Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec)-\\d{{1,2}}-\\d{{4}}{re.escape(date_normalized_separator)}(?:Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec)-\\d{{1,2}}-\\d{{4}}")
        elif fmt == "%d %b %Y":
            normalized_date_patterns.append(f"\\d{{1,2}} (?:Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec) \\d{{4}}{re.escape(date_normalized_separator)}\\d{{1,2}} (?:Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec) \\d{{4}}")
        elif fmt == "%B %d, %Y":
            normalized_date_patterns.append(f"(?:January|February|March|April|May|June|July|August|September|October|November|December) \\d{{1,2}}, \\d{{4}}{re.escape(date_normalized_separator)}(?:January|February|March|April|May|June|July|August|September|October|November|December) \\d{{1,2}}, \\d{{4}}")
        elif fmt == "%d %B %Y":
            normalized_date_patterns.append(f"\\d{{1,2}} (?:January|February|March|April|May|June|July|August|September|October|November|December) \\d{{4}}{re.escape(date_normalized_separator)}\\d{{1,2}} (?:January|February|March|April|May|June|July|August|September|October|November|December) \\d{{4}}")
        elif fmt == "%d-%B-%Y":
            normalized_date_patterns.append(f"\\d{{1,2}}-(?:January|February|March|April|May|June|July|August|September|October|November|December)-\\d{{4}}{re.escape(date_normalized_separator)}\\d{{1,2}}-(?:January|February|March|April|May|June|July|August|September|October|November|December)-\\d{{4}}")
        elif fmt == "%Y/%m/%d":
            normalized_date_patterns.append(f"\\d{{4}}/\\d{{1,2}}/\\d{{1,2}}{re.escape(date_normalized_separator)}\\d{{4}}/\\d{{1,2}}/\\d{{1,2}}")
        elif fmt == "%d.%m.%y":
            normalized_date_patterns.append(f"\\d{{1,2}}\\.\\d{{1,2}}\\.\\d{{2}}{re.escape(date_normalized_separator)}\\d{{1,2}}\\.\\d{{1,2}}\\.\\d{{2}}")
        elif fmt == "%d/%m/%y":
            normalized_date_patterns.append(f"\\d{{1,2}}/\\d{{1,2}}/\\d{{2}}{re.escape(date_normalized_separator)}\\d{{1,2}}/\\d{{1,2}}/\\d{{2}}")
        elif fmt == "%d-%m-%y":
            normalized_date_patterns.append(f"\\d{{1,2}}-\\d{{1,2}}-\\d{{2}}{re.escape(date_normalized_separator)}\\d{{1,2}}-\\d{{1,2}}-\\d{{2}}")
    
    # STEP 3: Protect prefix dates from general separator normalization
    # Create patterns for prefix dates (e.g., "exp 2025.08.30")
    prefix_date_patterns = []
    excluded_date_by_prefix = config.get('Date', {}).get('excluded_date_by_prefix', [])
    normalized_prefix_format = config.get('Date', {}).get('normalized_prefix_format', '%Y.%m.%d')
    
    for prefix in excluded_date_by_prefix:
        for fmt in allowed_formats:
            if fmt == "%Y.%m.%d":
                prefix_date_patterns.append(f"{re.escape(prefix)}\\s+\\d{{4}}\\.\\d{{1,2}}\\.\\d{{1,2}}")
            elif fmt == "%d.%m.%Y":
                prefix_date_patterns.append(f"{re.escape(prefix)}\\s+\\d{{1,2}}\\.\\d{{1,2}}\\.\\d{{4}}")
            elif fmt == "%d.%m.%y":
                prefix_date_patterns.append(f"{re.escape(prefix)}\\s+\\d{{1,2}}\\.\\d{{1,2}}\\.\\d{{2}}")
    
    # STEP 4: Apply general separator normalization, but protect normalized date ranges, prefix dates, and file extensions
    input_seps = load_global_separators()
    norm_sep = get_normalized_separator()
    
    # Protect file extensions first
    file_extension = ""
    if '.' in remainder:
        base, ext = remainder.rsplit('.', 1)
        if not ext.isdigit() and len(ext) <= 4:  # Likely a file extension
            file_extension = '.' + ext
            remainder = base
        else:
            # Not a file extension, restore the dot
            remainder = base + '.' + ext
    
    # Split the text into parts, preserving normalized date ranges and prefix dates
    combined_pattern = '|'.join(normalized_date_patterns + prefix_date_patterns)
    parts = re.split(f"({combined_pattern})", remainder)
    
    for i, part in enumerate(parts):
        # Skip normalized date ranges and prefix dates - they should not be processed by general separator normalization
        is_protected = any(re.search(pattern, part) for pattern in normalized_date_patterns + prefix_date_patterns)
        if is_protected:
            continue
        # Apply general separator normalization to other parts
        for sep in input_seps:
            part = part.replace(sep, norm_sep)
        parts[i] = part
    
    remainder = "".join(parts)
    
    # STEP 5: Collapse runs of separators
    remainder = re.sub(f'{re.escape(norm_sep)}+', norm_sep, remainder)
    
    # STEP 6: Trim leading/trailing separators (all known input separators)
    for sep in input_seps:
        remainder = remainder.strip(sep)
    
    # STEP 7: Restore file extension
    result = remainder + file_extension
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

def extract_full_name_from_path(full_path: str, name_to_match: str) -> str:
    """
    Extract the full name from a path by matching it as a single unit.
    This is specifically for path-based extraction where we want to match the complete name.
    Returns: matched_name|raw_remainder|cleaned_remainder|matched
    """
    import re
    sep = separator_regex_for_searching()
    fuzzy_pattern = _generate_fuzzy_regex(name_to_match)
    
    # Create a pattern that matches the full name as a single unit
    # Look for the name surrounded by separators or at the start/end
    pattern = re.compile(rf"(^|{sep})({fuzzy_pattern})(?=$|{sep})", re.IGNORECASE)
    
    match = pattern.search(full_path)
    if not match:
        # No match found, return cleaned path
        cleaned = clean_filename_remainder_py(full_path)
        return f"|{full_path}|{cleaned}|false"
    
    matched_name = match.group(2)
    
    # Replace all occurrences of the matched name with empty string
    # Use case-insensitive replacement with simple string operations
    raw_remainder = full_path
    # Split by separators and filter out the matched name
    sep_chars = load_global_separators()
    for sep_char in sep_chars:
        raw_remainder = raw_remainder.replace(sep_char, ' ')
    
    # Split by spaces and filter out the matched name (case-insensitive)
    parts = raw_remainder.split()
    filtered_parts = []
    name_parts = matched_name.split()
    
    i = 0
    while i < len(parts):
        # Check if we have a match for the full name starting at position i
        if i + len(name_parts) <= len(parts):
            match_found = True
            for j, name_part in enumerate(name_parts):
                if parts[i + j].lower() != name_part.lower():
                    match_found = False
                    break
            if match_found:
                i += len(name_parts)  # Skip the matched name parts
                continue
        filtered_parts.append(parts[i])
        i += 1
    
    raw_remainder = ' '.join(filtered_parts)
    
    # Clean the remainder
    cleaned_remainder = clean_filename_remainder_py(raw_remainder)
    
    return f"{matched_name}|{raw_remainder}|{cleaned_remainder}|true"


def extract_name_from_path(full_path: str, name_to_match: str) -> str:
    """
    Extract the name from a path using the same core logic as filename extraction.
    This works on the full path and removes all occurrences of the matched name.
    Returns: extracted_names|raw_remainder|cleaned_remainder|matched
    """
    # Use the same core function as filename extraction on the full path
    result = extract_all_name_matches(full_path, name_to_match)
    
    # Parse the result (4 parts: extracted_names|raw_remainder|cleaned_remainder|matched)
    parts = result.split('|')
    if len(parts) >= 4:
        extracted_name = parts[0]
        raw_remainder = parts[1]
        cleaned_remainder = parts[2]
        matched = parts[3] == 'true'
        
        return f"{extracted_name}|{raw_remainder}|{cleaned_remainder}|{matched}"
    
    # Fallback if parsing fails
    return f"|{full_path}|{clean_filename_remainder_py(full_path)}|false"



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
    if function_name in ["extract_initials_from_filename", "extract_shorthand_name_from_filename"]:
        result = matcher_function(filename, target_name, clean_filename=False)
        print(result)  # Only print the result to stdout
    elif function_name == "extract_name_from_path":
        result = extract_name_from_path(filename, target_name)
        print(result)
    else:
        result = matcher_function(filename, target_name)
        print(result)  # Only print the result to stdout

if __name__ == "__main__":
    main() 