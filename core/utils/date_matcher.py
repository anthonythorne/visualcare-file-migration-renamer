import re
import sys
from datetime import datetime

def extract_date_matches(filename):
    sep_regex = r'[-\._\s]'
    date_patterns = [
        # YYYY-MM-DD - match only the date portion
        (rf'(?P<year>\d{{4}}){sep_regex}(?P<month>0[1-9]|1[0-2]){sep_regex}(?P<day>0[1-9]|[12]\d|3[01])', 'YMD'),
        # DD-MM-YYYY - match only the date portion
        (rf'(?P<day>0[1-9]|[12]\d|3[01]){sep_regex}(?P<month>0[1-9]|1[0-2]){sep_regex}(?P<year>\d{{4}})', 'DMY'),
        # MM-DD-YYYY - match only the date portion
        (rf'(?P<month>0[1-9]|1[0-2]){sep_regex}(?P<day>0[1-9]|[12]\d|3[01]){sep_regex}(?P<year>\d{{4}})', 'MDY'),
        # YYYYMMDD - no separators
        (rf'(?P<year>\d{{4}})(?P<month>0[1-9]|1[0-2])(?P<day>0[1-9]|[12]\d|3[01])', 'YMD_nosep'),
        # DDMMYYYY - no separators
        (rf'(?P<day>0[1-9]|[12]\d|3[01])(?P<month>0[1-9]|1[0-2])(?P<year>\d{{4}})', 'DMY_nosep'),
        # MMDDYYYY - no separators
        (rf'(?P<month>0[1-9]|1[0-2])(?P<day>0[1-9]|[12]\d|3[01])(?P<year>\d{{4}})', 'MDY_nosep'),
        # Month name formats - match only the date portion
        (rf'(?P<day>\d{{1,2}})(st|nd|rd|th)?[-\. ]*(?P<month>Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec)[-\. ]*(?P<year>\d{{4}})', 'MonthName'),
    ]

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
        if date_format == 'MonthName':
            day = int(match.group('day'))
            month_str = match.group('month')
            month_map = {'jan': 1, 'feb': 2, 'mar': 3, 'apr': 4, 'may': 5, 'jun': 6, 'jul': 7, 'aug': 8, 'sep': 9, 'oct': 10, 'nov': 11, 'dec': 12}
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

if __name__ == '__main__':
    if len(sys.argv) > 1:
        filename = sys.argv[1]
        result = extract_date_matches(filename)
        print(result) 