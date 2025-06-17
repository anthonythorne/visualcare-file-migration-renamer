#!/usr/bin/env python3

import sys
sys.path.append('core/utils')
from name_matcher import match_full_name

# Test the match_full_name function
result = match_full_name("john-doe-report.pdf", "john doe")
print(result) 