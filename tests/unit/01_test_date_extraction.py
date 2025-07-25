import csv
import os
import pytest

# TODO: from core.utils.date_matcher import extract_date_matches

@pytest.mark.parametrize("row", list(csv.DictReader(open(os.path.join(os.path.dirname(__file__), '../fixtures/01_date_extraction_cases.csv')))))
def test_date_extraction(row):
    # TODO: Replace with actual extraction logic
    filename = row['filename']
    expected = row['expected_date'] if 'expected_date' in row else row['extracted_date']
    # result = extract_date_matches(filename)
    result = 'TODO'  # placeholder
    assert result == expected 