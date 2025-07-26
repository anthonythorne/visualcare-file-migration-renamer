"""
Date Matcher Utility for Filename Processing.

This module provides comprehensive date extraction functionality from filenames using
multiple date formats and patterns. It supports various international date formats
and provides fallback mechanisms for date extraction.

File Path: core/utils/date_matcher.py

@package VisualCare\\FileMigration\\Core
@since   1.0.0

Supported Date Formats:
- YYYY-MM-DD (ISO format)
- DD-MM-YYYY (European format)
- MM-DD-YYYY (US format)
- YYYYMMDD (compact format)
- DDMMYYYY (compact format)
- MMDDYYYY (compact format)
- Month name formats (e.g., "15th Mar 2023")

Key Features:
- Multiple date pattern recognition
- Configurable allowed formats
- Invalid date validation and handling
- Separator preservation

Output Format:
- Pipe-separated strings: extracted_dates|remainder|matched
- Multiple dates joined by commas if found
- Raw remainder with preserved separators
- Boolean match indicator

Processing Logic:
- Separator preservation before and after dates
- Invalid date filtering with datetime validation
- Multiple date extraction from single filename
"""

import re
import sys
import yaml
from datetime import datetime
from pathlib import Path


def load_config():
    """Load configuration from components.yaml."""
    config_path = Path(__file__).parent.parent.parent / 'config' / 'components.yaml'
    with open(config_path, 'r') as f:
        return yaml.safe_load(f)


def build_date_patterns(allowed_formats):
    """
    Build regex patterns for allowed date formats.
    
    @param allowed_formats: List of datetime format strings from config
    @return: List of (pattern, format_name) tuples
    """
    patterns = []
    sep_regex = r'[-\._\s]'
    
    # Month name mappings for abbreviated and full month names
    month_abbr = r'(?P<month>Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec)'
    month_full = r'(?P<month>January|February|March|April|May|June|July|August|September|October|November|December)'
    
    for fmt in allowed_formats:
        if fmt == "%Y-%m-%d":
            patterns.append((
                rf'(?P<year>\d{{4}}){sep_regex}(?P<month>0[1-9]|1[0-2]){sep_regex}(?P<day>0[1-9]|[12]\d|3[01])',
                'YMD'
            ))
        elif fmt == "%d-%m-%Y":
            patterns.append((
                rf'(?P<day>0[1-9]|[12]\d|3[01]){sep_regex}(?P<month>0[1-9]|1[0-2]){sep_regex}(?P<year>\d{{4}})',
                'DMY'
            ))
        elif fmt == "%m-%d-%Y":
            patterns.append((
                rf'(?P<month>0[1-9]|1[0-2]){sep_regex}(?P<day>0[1-9]|[12]\d|3[01]){sep_regex}(?P<year>\d{{4}})',
                'MDY'
            ))
        elif fmt == "%Y%m%d":
            patterns.append((
                rf'(?P<year>\d{{4}})(?P<month>0[1-9]|1[0-2])(?P<day>0[1-9]|[12]\d|3[01])',
                'YMD_nosep'
            ))
        elif fmt == "%d%m%Y":
            patterns.append((
                rf'(?P<day>0[1-9]|[12]\d|3[01])(?P<month>0[1-9]|1[0-2])(?P<year>\d{{4}})',
                'DMY_nosep'
            ))
        elif fmt == "%m%d%Y":
            patterns.append((
                rf'(?P<month>0[1-9]|1[0-2])(?P<day>0[1-9]|[12]\d|3[01])(?P<year>\d{{4}})',
                'MDY_nosep'
            ))
        elif fmt == "%d-%b-%Y":
            patterns.append((
                rf'(?P<day>\d{{1,2}})(st|nd|rd|th)?[-\. ]*{month_abbr}[-\. ]*(?P<year>\d{{4}})',
                'DayMonthAbbr'
            ))
        elif fmt == "%b-%d-%Y":
            patterns.append((
                rf'{month_abbr}[-\. ]*(?P<day>\d{{1,2}})(st|nd|rd|th)?[-\. ]*(?P<year>\d{{4}})',
                'MonthAbbrDay'
            ))
        elif fmt == "%d %b %Y":
            patterns.append((
                rf'(?P<day>\d{{1,2}})(st|nd|rd|th)?\s+{month_abbr}\s+(?P<year>\d{{4}})',
                'DayMonthAbbr'
            ))
        elif fmt == "%B %d, %Y":
            patterns.append((
                rf'{month_full}\s+(?P<day>\d{{1,2}})(st|nd|rd|th)?,\s+(?P<year>\d{{4}})',
                'MonthFullDay'
            ))
        elif fmt == "%Y.%m.%d":
            patterns.append((
                rf'(?P<year>\d{{4}})\.(?P<month>0[1-9]|1[0-2])\.(?P<day>0[1-9]|[12]\d|3[01])',
                'YMD_dot'
            ))
        elif fmt == "%d %B %Y":
            patterns.append((
                rf'(?P<day>\d{{1,2}})(st|nd|rd|th)?\s+{month_full}\s+(?P<year>\d{{4}})',
                'DayMonthFull'
            ))
        elif fmt == "%d-%B-%Y":
            patterns.append((
                rf'(?P<day>\d{{1,2}})(st|nd|rd|th)?[-\. ]*{month_full}[-\. ]*(?P<year>\d{{4}})',
                'DayMonthFull'
            ))
        elif fmt == "%d/%m/%Y":
            patterns.append((
                rf'(?P<day>0[1-9]|[12]\d|3[01])/(?P<month>0[1-9]|1[0-2])/(?P<year>\d{{4}})',
                'DMY_slash'
            ))
        elif fmt == "%Y/%m/%d":
            patterns.append((
                rf'(?P<year>\d{{4}})/(?P<month>0[1-9]|1[0-2])/(?P<day>0[1-9]|[12]\d|3[01])',
                'YMD_slash'
            ))
    
    return patterns


def extract_date_matches(filename):
    """
    Extract dates from filename using configurable allowed formats.
    
    @param filename: The filename to extract dates from
    @return: Pipe-separated string: extracted_dates|remainder|matched
    """
    config = load_config()
    allowed_formats = config.get('Date', {}).get('allowed_formats', ['%Y-%m-%d'])
    date_patterns = build_date_patterns(allowed_formats)
    
    found_dates = []
    raw_remainder = filename
    
    while True:
        best_match_info = None
        for pattern, date_format in date_patterns:
            match = re.search(pattern, raw_remainder, re.IGNORECASE)
            if match:
                best_match_info = (match, date_format)
                break
        
        if not best_match_info:
            break

        match, date_format = best_match_info
        
        year, month, day = 0, 0, 0
        if 'Month' in date_format:
            day = int(match.group('day'))
            month_str = match.group('month')
            month_map = {
                'jan': 1, 'feb': 2, 'mar': 3, 'apr': 4, 'may': 5, 'jun': 6,
                'jul': 7, 'aug': 8, 'sep': 9, 'oct': 10, 'nov': 11, 'dec': 12,
                'january': 1, 'february': 2, 'march': 3, 'april': 4, 'may': 5, 'june': 6,
                'july': 7, 'august': 8, 'september': 9, 'october': 10, 'november': 11, 'december': 12
            }
            month = month_map[month_str.lower()]
            year = int(match.group('year'))
        else:
            year = int(match.group('year'))
            month = int(match.group('month'))
            day = int(match.group('day'))
        
        try:
            dt = datetime(year, month, day)
            found_dates.append(dt.strftime('%Y-%m-%d'))
            
            # Remove the matched date portion and preserve separators
            start, end = match.span()
            
            # Find separators before and after the date
            sep_before = ""
            sep_after = ""
            
            # Look for separator before the date
            if start > 0 and raw_remainder[start-1] in '-._ ':
                sep_before = raw_remainder[start-1]
                start -= 1
            
            # Look for separator after the date
            if end < len(raw_remainder) and raw_remainder[end] in '-._ ':
                sep_after = raw_remainder[end]
                end += 1
            
            # Reconstruct remainder with preserved separators
            raw_remainder = raw_remainder[:start] + sep_before + sep_after + raw_remainder[end:]
            
        except ValueError:
            # Mark the matched part as processed to avoid infinite loops on invalid dates
            raw_remainder = raw_remainder.replace(match.group(0), '', 1)
            continue
    
    if found_dates:
        return f"{','.join(found_dates)}|{raw_remainder}|true"
    else:
        return f"|{filename}|false"


def extract_date_from_path(full_path: str, date_to_match: str) -> str:
    """
    Extract all occurrences of the full date from all components of a path (folders and filename).
    Returns: extracted_dates|raw_remainder|matched
    """
    import re
    # Accept only full dates (YYYY-MM-DD)
    date_pattern = re.compile(r'\b' + re.escape(date_to_match) + r'\b')
    path_components = [p for p in full_path.split('/') if p]
    extracted_dates = []
    new_components = []
    for part in path_components:
        matches = list(date_pattern.finditer(part))
        if matches:
            extracted_dates.extend([date_to_match] * len(matches))
            # Remove all occurrences of the date
            remainder = date_pattern.sub('', part)
            new_components.append(remainder)
        else:
            new_components.append(part)
    
    raw_remainder = '/'.join(new_components)
    matched = 'true' if extracted_dates else 'false'
    return f"{','.join(extracted_dates)}|{raw_remainder}|{matched}"


if __name__ == "__main__":
    if len(sys.argv) == 2:
        filename = sys.argv[1]
        result = extract_date_matches(filename)
        print(result)
    elif len(sys.argv) == 4 and sys.argv[3] == 'extract_date_from_path':
        full_path = sys.argv[1]
        date_to_match = sys.argv[2]
        result = extract_date_from_path(full_path, date_to_match)
        print(result)
    else:
        print('Usage: date_matcher.py <filename> [date_to_match] [function_name]') 