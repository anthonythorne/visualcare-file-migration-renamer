import re

def normalize_date_range_separators(text, normalized_separator=' - '):
    date_pattern = r'\d{4}-\d{1,2}-\d{1,2}'
    separator_pattern = r'[-\s_,.]+'
    range_pattern = f'({date_pattern})({separator_pattern})*({date_pattern})'
    
    def replace_separators(match):
        date1 = match.group(1)
        date2 = match.group(3)
        return date1 + normalized_separator + date2
    
    return re.sub(range_pattern, replace_separators, text, flags=re.IGNORECASE)

test_cases = [
    '2024-07-01,2025-06-30',
    '2024-07-01 , 2025-06-30', 
    '2024-07-01_2025-06-30',
    '2024-07-01  2025-06-30'
]

for case in test_cases:
    result = normalize_date_range_separators(case)
    print(f'{case} -> {result}')
