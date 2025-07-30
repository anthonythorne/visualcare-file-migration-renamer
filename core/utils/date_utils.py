import re
import sys
from core.utils.date_matcher import load_config

def is_date_range_and_normalize(text, config=None):
    """
    Detects if the input text contains a date range (using allowed_formats and exclude_ranges_separators from config),
    and normalizes it using exclude_ranges_normalized_separator. Returns (is_date_range: bool, normalized_range: str or None).
    """
    import datetime
    if config is None:
        config = load_config()
    allowed_formats = config.get('Date', {}).get('allowed_formats', ['%Y-%m-%d'])
    exclude_ranges_separators = config.get('Date', {}).get('exclude_ranges_separators', [" ", "-", "_", ".", ",", "to"])
    normalized_separator = config.get('Date', {}).get('exclude_ranges_normalized_separator', " - ")
    normalized_format = config.get('Date', {}).get('normalized_format', '%Y-%m-%d')
    normalized_ranges_format = config.get('Date', {}).get('normalized_ranges_format', '%Y-%m-%d')

    # Build regex patterns for all allowed formats
    date_patterns = []
    for fmt in allowed_formats:
        if fmt == "%Y-%m-%d":
            date_patterns.append(r'\d{4}-\d{1,2}-\d{1,2}')
        elif fmt == "%d-%m-%Y":
            date_patterns.append(r'\d{1,2}-\d{1,2}-\d{4}')
        elif fmt == "%Y%m%d":
            date_patterns.append(r'\d{8}')
        elif fmt == "%d%m%Y":
            date_patterns.append(r'\d{8}')
        elif fmt == "%m%d%Y":
            date_patterns.append(r'\d{8}')
        elif fmt == "%d-%b-%Y":
            date_patterns.append(r'\d{1,2}-(?:Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec)-\d{4}')
        elif fmt == "%b-%d-%Y":
            date_patterns.append(r'(?:Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec)-\d{1,2}-\d{4}')
        elif fmt == "%d %b %Y":
            date_patterns.append(r'\d{1,2} (?:Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec) \d{4}')
        elif fmt == "%B %d, %Y":
            date_patterns.append(r'(?:January|February|March|April|May|June|July|August|September|October|November|December) \d{1,2}, \d{4}')
        elif fmt == "%Y.%m.%d":
            date_patterns.append(r'\d{4}\.\d{1,2}\.\d{1,2}')
        elif fmt == "%d.%m.%Y":
            date_patterns.append(r'\d{1,2}\.\d{1,2}\.\d{4}')
        elif fmt == "%d %B %Y":
            date_patterns.append(r'\d{1,2} (?:January|February|March|April|May|June|July|August|September|October|November|December) \d{4}')
        elif fmt == "%d-%B-%Y":
            date_patterns.append(r'\d{1,2}-(?:January|February|March|April|May|June|July|August|September|October|November|December)-\d{4}')
        elif fmt == "%d/%m/%Y":
            date_patterns.append(r'\d{1,2}/\d{1,2}/\d{4}')
        elif fmt == "%Y/%m/%d":
            date_patterns.append(r'\d{4}/\d{1,2}/\d{1,2}')
        elif fmt == "%d.%m.%y":
            date_patterns.append(r'\d{1,2}\.\d{1,2}\.\d{2}')
        elif fmt == "%d/%m/%y":
            date_patterns.append(r'\d{1,2}/\d{1,2}/\d{2}')
        elif fmt == "%d-%m-%y":
            date_patterns.append(r'\d{1,2}-\d{1,2}-\d{2}')

    # Build separator pattern (zero or more, any order)
    escaped_separators = [re.escape(sep) for sep in exclude_ranges_separators]
    separator_pattern = '|'.join(escaped_separators)

    # Try all combinations of date patterns for ranges (single-char/word separators)
    found_match = False
    for date_pattern in date_patterns:
        range_pattern = f"({date_pattern})(?:{separator_pattern})+({date_pattern})"
        match = re.search(range_pattern, text, re.IGNORECASE)
        if match:
            date1_raw = match.group(1)
            date2_raw = match.group(2)
            def try_parse(date_str):
                for fmt in allowed_formats:
                    try:
                        dt = datetime.datetime.strptime(date_str, fmt)
                        return dt
                    except Exception:
                        continue
                return None
            dt1 = try_parse(date1_raw)
            dt2 = try_parse(date2_raw)
            if dt1 and dt2:
                date1_norm = dt1.strftime(normalized_ranges_format)
                date2_norm = dt2.strftime(normalized_ranges_format)
                normalized = f"{date1_norm}{normalized_separator}{date2_norm}"
                return True, normalized
            def replace_separators(m):
                return m.group(1) + normalized_separator + m.group(2)
            normalized = re.sub(range_pattern, replace_separators, match.group(0), flags=re.IGNORECASE)
            return True, normalized
    # If not found, try multi-character string separators
    separator_strings = config.get('Date', {}).get('exclude_ranges_separator_strings', [])
    for sep_str in separator_strings:
        for date_pattern in date_patterns:
            range_pattern = f"({date_pattern}){re.escape(sep_str)}({date_pattern})"
            match = re.search(range_pattern, text, re.IGNORECASE)
            if match:
                date1_raw = match.group(1)
                date2_raw = match.group(2)
                def try_parse(date_str):
                    for fmt in allowed_formats:
                        try:
                            dt = datetime.datetime.strptime(date_str, fmt)
                            return dt
                        except Exception:
                            continue
                    return None
                dt1 = try_parse(date1_raw)
                dt2 = try_parse(date2_raw)
                if dt1 and dt2:
                    date1_norm = dt1.strftime(normalized_ranges_format)
                    date2_norm = dt2.strftime(normalized_ranges_format)
                    normalized = f"{date1_norm}{normalized_separator}{date2_norm}"
                    return True, normalized
                normalized = f"{date1_raw}{normalized_separator}{date2_raw}"
                return True, normalized
    # Also check for already-normalized ranges
    for date_pattern in date_patterns:
        norm_pattern = f"{date_pattern}{re.escape(normalized_separator)}{date_pattern}"
        if re.search(norm_pattern, text):
            return True, re.search(norm_pattern, text).group(0)
    return False, None 