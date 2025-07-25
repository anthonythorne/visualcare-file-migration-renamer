import csv
import os
import pytest

# TODO: from core.utils.name_matcher import extract_name_from_filename

@pytest.mark.parametrize("row", list(csv.DictReader(open(os.path.join(os.path.dirname(__file__), '../fixtures/00_name_extraction_cases.csv')))))
def test_name_extraction(row):
    # TODO: Replace with actual extraction logic
    filename = row['filename']
    name_to_match = row['name_to_match']
    expected = row['extracted_name']
    # result = extract_name_from_filename(filename, name_to_match)
    result = 'TODO'  # placeholder
    assert result == expected 