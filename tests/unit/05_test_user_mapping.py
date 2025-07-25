import csv
import os
import pytest

# TODO: from core.utils.user_mapping import get_user_id_by_name

@pytest.mark.parametrize("row", list(csv.DictReader(open(os.path.join(os.path.dirname(__file__), '../fixtures/05_user_mapping_cases.csv')))))
def test_user_mapping(row):
    # TODO: Replace with actual mapping logic
    input_name = row['input_name']
    expected_id = row['expected_user_id']
    # result = get_user_id_by_name(input_name)
    result = 'TODO'  # placeholder
    assert result == expected_id 