import csv
import os
import pytest

# TODO: from core.utils.category_processor import detect_category_from_path

@pytest.mark.parametrize("row", list(csv.DictReader(open(os.path.join(os.path.dirname(__file__), '../fixtures/04_category_extraction_cases.csv')))))
def test_category_extraction(row):
    # TODO: Replace with actual extraction logic
    input_path = row['input_path']
    expected_name = row['expected_category_name']
    expected_id = row['expected_category_id']
    # result_name, result_id = detect_category_from_path(input_path)
    result_name, result_id = 'TODO', 'TODO'  # placeholder
    assert result_name == expected_name
    assert result_id == expected_id 