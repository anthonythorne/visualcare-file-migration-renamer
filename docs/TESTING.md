# Testing Guide

This document explains how to generate, run, and understand the tests for the VisualCare File Migration Renamer project.

## Test Types

- **Name Extraction Tests:** Validate name extraction logic using a matrix in `tests/fixtures/name_extraction_cases.csv`.
- **Date Extraction Tests:** Validate date extraction logic using a matrix in `tests/fixtures/date_extraction_cases.csv`.
- **Combined Extraction Tests:** Validate both name and date extraction together using `tests/fixtures/combined_extraction_cases.csv`.

## Regenerating Tests

To regenerate BATS tests from the CSV test matrices:

```bash
python3 tests/scripts/generate_bats_tests.py name
python3 tests/scripts/generate_bats_tests.py date
python3 tests/scripts/generate_bats_tests.py combined
```

- This will update the test files in `tests/unit/`.
- The combined command generates `tests/unit/combined_utils_table_test.bats`.

## Running Tests

To run all unit and integration tests at once:

```bash
./tests/run_tests.sh
```

To run a specific test type manually:

```bash
bats --filter "[matcher_function=shorthand]" tests/unit/name_utils_table_test.bats
bats --filter "[matcher_function=all_matches]" tests/unit/name_utils_table_test.bats
bats tests/unit/combined_utils_table_test.bats
```

## Combined Extraction Matrix

- The combined matrix (`tests/fixtures/combined_extraction_cases.csv`) contains filenames with both names and dates, plus other parts (e.g., "Report").
- Each row specifies the expected extracted name(s), date(s), raw remainder, and cleaned remainder.
- The generated tests assert that both name and date extraction work together as expected.

## Test Fixtures and Scripts

- **Test matrices:** `tests/fixtures/`
- **Test generator:** `tests/scripts/generate_bats_tests.py`
- **Generated tests:** `tests/unit/`

## Troubleshooting

- If tests fail after editing a matrix, regenerate the tests using the commands above.
- Ensure BATS is installed (`npm install -g bats` or `brew install bats-core`).
- If you add new extraction logic, update the test generator script as needed.

## More Information

- See `docs/FILENAME_CONVENTIONS.md` and `docs/NAMING_CONVENTIONS.md` for extraction logic details. 