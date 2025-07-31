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
        elif fmt == "%d.%m.%Y":
            patterns.append((
                rf'(?P<day>0[1-9]|[12]\d|3[01])\.(?P<month>0[1-9]|1[0-2])\.(?P<year>\d{{4}})',
                'DMY_dot'
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
        elif fmt == "%d.%m.%y":
            patterns.append((
                rf'(?P<day>\d{{1,2}})\.(?P<month>\d{{1,2}})\.(?P<year>\d{{2}})',
                'DMY_dot_2digit'
            ))
        elif fmt == "%d/%m/%y":
            patterns.append((
                rf'(?P<day>\d{{1,2}})/(?P<month>\d{{1,2}})/(?P<year>\d{{2}})',
                'DMY_slash_2digit'
            ))
        elif fmt == "%d-%m-%y":
            patterns.append((
                rf'(?P<day>\d{{1,2}})-(?P<month>\d{{1,2}})-(?P<year>\d{{2}})',
                'DMY_dash_2digit'
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
    normalized_format = config.get('Date', {}).get('normalized_format', '%Y-%m-%d')
    date_patterns = build_date_patterns(allowed_formats)

    found_dates = []
    raw_remainder = filename
    
    # First, detect and remove any date ranges from the text
    import re
    exclude_ranges_separators = config.get('Date', {}).get('exclude_ranges_separators', [" ", "-", "_", ".", ","])
    normalized_separator = config.get('Date', {}).get('exclude_ranges_normalized_separator', " - ")
    
    # Build a pattern to detect date ranges using all allowed formats
    escaped_separators = [re.escape(sep) for sep in exclude_ranges_separators]
    separator_pattern = '|'.join(escaped_separators)
    
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
    
    # Create range patterns for each date format
    range_patterns = []
    for date_pattern in date_patterns_for_ranges:
        range_pattern = f"{date_pattern}(?:{separator_pattern})*{date_pattern}"
        range_patterns.append(range_pattern)
    
    # Find date ranges and keep excluded ones in the remainder
    try:
        from core.utils.date_utils import is_date_range_and_normalize
    except ImportError:
        # If core module is not in path, try relative import
        import sys
        import os
        sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..', '..'))
        from core.utils.date_utils import is_date_range_and_normalize
    
    is_range, normalized_range = is_date_range_and_normalize(raw_remainder, config)
    if is_range:
        # Replace the original range with the normalized version
        # Find the original range pattern to replace it
        for date_pattern in date_patterns_for_ranges:
            range_pattern = f"{date_pattern}(?:{separator_pattern})*{date_pattern}"
            match = re.search(range_pattern, raw_remainder, re.IGNORECASE)
            if match:
                start, end = match.span()
                raw_remainder = raw_remainder[:start] + normalized_range + raw_remainder[end:]
                break
    
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
            
            # Handle 2-digit years (convert to 4-digit)
            if year < 100:
                # All 2-digit years are 2000-2099
                # So 25.02.05 = 25th February 2005, 25.02.15 = 25th February 2015
                year += 2000
        
        try:
            dt = datetime(year, month, day)
            date_str = dt.strftime(normalized_format)
            
            # Check if this date pattern should be excluded
            if should_exclude_date_pattern(filename, match.group(0)):
                # Mark the matched part as processed to avoid infinite loops
                raw_remainder = raw_remainder.replace(match.group(0), '', 1)
                continue
            
            found_dates.append(date_str)
            
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
    Extract all occurrences of dates from all components of a path (folders and filename).
    Uses the same pattern matching logic as extract_date_matches.
    Returns: extracted_dates|raw_remainder|matched
    """
    # Load configuration and build patterns
    config = load_config()
    allowed_formats = config.get('Date', {}).get('allowed_formats', [])
    normalized_format = config.get('Date', {}).get('normalized_format', '%Y-%m-%d')
    patterns = build_date_patterns(allowed_formats)
    
    extracted_dates = []
    raw_remainder = full_path
    
    # Try each pattern until we find matches
    for pattern, date_format in patterns:
        while True:
            match = re.search(pattern, raw_remainder, re.IGNORECASE)
            if not match:
                break
            
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
                
                # Handle 2-digit years (convert to 4-digit)
                if year < 100:
                    # All 2-digit years are 2000-2099
                    # So 25.02.05 = 25th February 2005, 25.02.15 = 25th February 2015
                    year += 2000
            
            try:
                dt = datetime(year, month, day)
                extracted_dates.append(dt.strftime(normalized_format))
                
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
    
    matched = 'true' if extracted_dates else 'false'
    return f"{','.join(extracted_dates)}|{raw_remainder}|{matched}"


def extract_date_from_remainder(remainder_string: str) -> str:
    """
    Extract date from remainder string following sequential string-based approach.
    This function is designed to be called after category and name extraction.
    
    Args:
        remainder_string: String containing potential dates (e.g., "2024/Updated Contacts/contact_list.pdf")
        
    Returns:
        extracted_date|raw_remainder|cleaned_remainder|matched
        
    Process:
    1. Search for dates in filename, then foldername, then metadata (following config priority)
    2. Extract first valid date found
    3. Remove date from remainder
    4. Return cleaned remainder for final assembly
    """
    from pathlib import Path
    import os
    
    # Load configuration
    config = load_config()
    date_priority_order = config.get('Date', {}).get('date_priority_order', ['filename', 'foldername', 'modified', 'created'])
    
    # Parse the remainder string
    path_obj = Path(remainder_string)
    filename = path_obj.name
    foldername = path_obj.parent.name if path_obj.parent.name else ""
    
    extracted_date = ""
    raw_remainder = remainder_string
    
    # Try each source in priority order
    for source in date_priority_order:
        if source == 'filename' and filename:
            # Extract date from filename
            date_result = extract_date_matches(filename)
            date_parts = date_result.split('|')
            if date_parts[0]:  # If date found in filename
                extracted_date = date_parts[0]
                # Remove date from filename and reconstruct remainder
                if len(date_parts) > 1:
                    cleaned_filename = date_parts[1]
                    if path_obj.parent.name:
                        raw_remainder = str(path_obj.parent / cleaned_filename)
                    else:
                        raw_remainder = cleaned_filename
                break
        elif source == 'foldername' and foldername:
            # Extract date from foldername
            date_result = extract_date_matches(foldername)
            date_parts = date_result.split('|')
            if date_parts[0]:  # If date found in foldername
                extracted_date = date_parts[0]
                # Remove date from foldername and reconstruct remainder
                if len(date_parts) > 1:
                    cleaned_foldername = date_parts[1]
                    if cleaned_foldername:
                        raw_remainder = str(Path(cleaned_foldername) / filename)
                    else:
                        raw_remainder = filename
                break
        elif source == 'modified':
            # For now, skip modified date as we don't have file system access
            continue
        elif source == 'created':
            # For now, skip created date as we don't have file system access
            continue
    
    # Clean the remainder using global cleaner
    cleaned_remainder = raw_remainder
    if raw_remainder:
        try:
            import subprocess
            project_root = Path(__file__).parent.parent.parent
            cleaned_remainder = subprocess.check_output([
                'python3',
                str(project_root / 'core/utils/name_matcher.py'),
                '--clean-filename',
                raw_remainder
            ], text=True, stderr=subprocess.DEVNULL).strip()
        except:
            cleaned_remainder = raw_remainder
    
    matched = 'true' if extracted_date else 'false'
    return f"{extracted_date}|{raw_remainder}|{cleaned_remainder}|{matched}"


def extract_date_from_file_metadata(file_path: str) -> str:
    """
    Extract date from file metadata (modified or created date) when no date is found in filename.
    
    Args:
        file_path: Full path to the file
        
    Returns:
        Date string in YYYY-MM-DD format, or empty string if no valid date found
    """
    import os
    from pathlib import Path
    
    try:
        path_obj = Path(file_path)
        if not path_obj.exists():
            return ""
        
        # Get file stats
        stat = path_obj.stat()
        modified_time = stat.st_mtime
        created_time = stat.st_ctime
        
        # Use modified time if available, otherwise created time
        timestamp = modified_time if modified_time > 0 else created_time
        
        if timestamp > 0:
            # Convert timestamp to datetime and format using config
            from datetime import datetime
            date_obj = datetime.fromtimestamp(timestamp)
            config = load_config()
            normalized_format = config.get('Date', {}).get('normalized_format', '%Y-%m-%d')
            return date_obj.strftime(normalized_format)
        
        return ""
    except Exception as e:
        # Log error but don't fail
        print(f"Error extracting date from file metadata for {file_path}: {e}")
        return ""


def extract_date_with_metadata_fallback(filename: str, file_path: str = None) -> str:
    """
    Extract date from filename first, then fall back to file metadata if no date found.
    
    Args:
        filename: Filename to extract date from
        file_path: Full path to the file (for metadata fallback)
        
    Returns:
        Pipe-separated string: extracted_date|remainder|matched
    """
    # First try to extract date from filename
    result = extract_date_matches(filename)
    parts = result.split('|')
    
    # If no date found in filename and we have file path, try metadata
    if not parts[0] and file_path:
        metadata_date = extract_date_from_file_metadata(file_path)
        if metadata_date:
            # Return the metadata date with the original filename as remainder
            return f"{metadata_date}|{filename}|true"
    
    return result


def should_exclude_date_pattern(text: str, date_match: str) -> bool:
    """
    Check if a date pattern should be excluded from extraction, using config.
    Excludes:
    - "{exclude_string} {date}" patterns (e.g., "exp 2023-05-15")
    - Date ranges using allowed_formats and exclude_ranges_separators
    """
    config = load_config()
    date_config = config.get('Date', {})
    exclude_ranges = date_config.get('exclude_ranges', False)
    excluded_date_by_prefix = date_config.get('excluded_date_by_prefix', [])
    
    if not exclude_ranges:
        return False

    import re
    
    # Check for excluded prefixes followed by optional separators and dates
    allowed_formats = date_config.get('allowed_formats', [])
    exclude_ranges_separators = date_config.get('exclude_ranges_separators', [" ", "-", "_", "."])
    
    # Escape separators that are regex special characters
    escaped_separators = [re.escape(sep) for sep in exclude_ranges_separators]
    separator_pattern = '|'.join(escaped_separators)
    
    # Create exclusion patterns for each allowed format
    for date_format in allowed_formats:
        # Convert format to regex pattern
        format_regex = date_format.replace('%Y', r'\d{4}').replace('%y', r'\d{2}').replace('%m', r'\d{1,2}').replace('%d', r'\d{1,2}').replace('%b', r'(?:Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec)').replace('%B', r'(?:January|February|March|April|May|June|July|August|September|October|November|December)')
        
        # Check for excluded prefixes followed by optional separators and dates
        for prefix in excluded_date_by_prefix:
            # Pattern: {prefix} (optional separator) {date}
            exclusion_pattern = f"{re.escape(prefix)}\\s*(?:{separator_pattern})?\\s*{format_regex}"
            if re.search(exclusion_pattern, text, re.IGNORECASE):
                return True
    
    # Use the centralized date range utility for date range detection
    from core.utils.date_utils import is_date_range_and_normalize
    is_range, _ = is_date_range_and_normalize(text, config)
    return is_range


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
    elif len(sys.argv) == 3 and sys.argv[1] == '--extract-from-remainder':
        remainder = sys.argv[2]
        result = extract_date_from_remainder(remainder)
        print(result)
    else:
        print('Usage: date_matcher.py <filename> [date_to_match] [function_name]')
        print('       date_matcher.py --extract-from-remainder <remainder_string>') 