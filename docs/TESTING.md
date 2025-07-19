# Testing Guide

This document explains how to generate, run, and understand the tests for the VisualCare File Migration Renamer project.

## Test Types

- **Name Extraction Tests:** Validate name extraction logic using a matrix in `tests/fixtures/name_extraction_cases.csv`.
- **Date Extraction Tests:** Validate date extraction logic using a matrix in `tests/fixtures/date_extraction_cases.csv`.
- **Combined Extraction Tests:** Validate both name and date extraction together using `tests/fixtures/combined_extraction_cases.csv`.
- **Test Mode Integration Tests:** Validate the main CLI application using the `tests/test-files` structure.

## Test Mode Integration Testing

The test mode functionality allows you to test the complete file processing pipeline using real files in the `tests/test-files` structure.

### Test Files Structure

```
tests/test-files/
├── from/                    # Original files (input)
│   ├── John Doe/           # Person-specific directories
│   │   ├── file1.pdf
│   │   └── file2.docx
│   ├── Jane Smith/
│   └── Bob Johnson/
├── to-basic/               # Output for basic test
├── to-userid/              # Output for user ID test
├── to-management/          # Output for management test
└── to-<test-name>/         # Custom test output directories
```

### Running Test Mode

```bash
# Basic test mode (no user IDs)
python3 main.py --test-mode --test-name basic --dry-run

# User ID test mode
python3 main.py --test-mode --test-name userid --dry-run

# Management flag test mode
python3 main.py --test-mode --test-name management --dry-run

# Person-specific test
python3 main.py --test-mode --test-name person-test --person "John Doe" --dry-run

# With verbose output
python3 main.py --test-mode --test-name basic --dry-run --verbose

# Actual processing (not dry-run)
python3 main.py --test-mode --test-name basic
```

### Test Mode Features

- **Separate Output Directories:** Each test creates its own `to-<test-name>` directory
- **Person Filtering:** Process files for specific people only
- **Dry Run Mode:** Preview changes without making them
- **Visual Comparison:** Compare `from` and `to-<test-name>` directories
- **Comprehensive Logging:** Detailed processing information

### Test Mode BATS Tests

The test mode functionality is also covered by BATS tests:

```bash
# Run test mode integration tests
bats tests/unit/test_mode_integration_test.bats

# Run specific test mode tests
bats --filter "test-mode-basic" tests/unit/test_mode_integration_test.bats
bats --filter "test-mode-person-filter" tests/unit/test_mode_integration_test.bats
```

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

This includes:
- **144 unit tests** (name, date, combined extraction)
- **4 integration tests** (test mode functionality)
- **11 test mode BATS tests**

To run a specific test type manually:

```bash
# Unit tests
bats --filter "[matcher_function=shorthand]" tests/unit/name_utils_table_test.bats
bats --filter "[matcher_function=all_matches]" tests/unit/name_utils_table_test.bats
bats tests/unit/combined_utils_table_test.bats

# Test mode tests
bats tests/unit/test_mode_integration_test.bats

# Integration tests
python3 tests/scripts/generate_bats_tests.py integration
```

## Combined Extraction Matrix

- The combined matrix (`tests/fixtures/combined_extraction_cases.csv`) contains filenames with both names and dates, plus other parts (e.g., "Report").
- Each row specifies the expected extracted name(s), date(s), raw remainder, and cleaned remainder.
- The generated tests assert that both name and date extraction work together as expected.

## Combo Extraction Test Scaffolding

The combined extraction tests use the Bash wrapper for the combo function, which is sourced in the BATS test files. Here is how the scaffolding works:

```bash
# In the BATS test file:
source "${BATS_TEST_DIRNAME}/../../core/utils/name_utils.sh"

@test "combo extraction example" {
    run extract_name_and_date_from_filename "John_Doe_2023-05-15_Report.pdf" "john doe"
    IFS='|' read -r actual_extracted_name actual_extracted_date actual_raw_remainder actual_name_matched actual_date_matched <<< "$output"
    # Assertions
    assert_equal "$actual_extracted_name" "John,Doe"
    assert_equal "$actual_extracted_date" "2023-05-15"
    assert_equal "$actual_raw_remainder" "___Report.pdf"
    assert_equal "$actual_name_matched" "true"
    assert_equal "$actual_date_matched" "true"
}
```

**Example output for the combo function:**
```
John,Doe|2023-05-15|___Report.pdf|true|true
```

**To run the combined tests:**
```bash
bats tests/unit/combined_utils_table_test.bats
```

## Test Fixtures and Scripts

- **Test matrices:** `tests/fixtures/`
- **Test files:** `tests/test-files/`
- **Test generator:** `tests/scripts/generate_bats_tests.py`
- **Generated tests:** `tests/unit/`

## Test Coverage

### Unit Tests (144 total)
- **Name extraction:** 98 tests covering all matcher functions
- **Date extraction:** 16 tests covering various date formats
- **Combined extraction:** 30 tests covering name + date extraction

### Integration Tests (15 total)
- **Test mode integration:** 11 BATS tests
- **Main CLI integration:** 4 shell script tests

### Test Scenarios Covered
- ✅ Basic name extraction (first, last, initials, shorthand)
- ✅ Date extraction (ISO, US, European, written months)
- ✅ Combined extraction (name + date in same filename)
- ✅ User ID mapping and integration
- ✅ Management flag detection
- ✅ Person-specific filtering
- ✅ Error handling and edge cases
- ✅ File processing pipeline
- ✅ Output directory management

## Troubleshooting

### Common Issues

**Tests fail after editing a matrix:**
```bash
# Regenerate the tests
python3 tests/scripts/generate_bats_tests.py name
python3 tests/scripts/generate_bats_tests.py date
python3 tests/scripts/generate_bats_tests.py combined
```

**BATS not installed:**
```bash
npm install -g bats
# or
brew install bats-core
```

**Test mode tests fail:**
```bash
# Check test files structure
ls -la tests/test-files/from/
ls -la tests/test-files/to-*/

# Run with verbose output
python3 main.py --test-mode --test-name basic --dry-run --verbose
```

**Permission issues:**
```bash
# Make test runner executable
chmod +x tests/run_tests.sh
```

### Debugging Test Mode

To debug test mode issues:

1. **Check file structure:**
   ```bash
   tree tests/test-files/
   ```

2. **Run with verbose output:**
   ```bash
   python3 main.py --test-mode --test-name debug --dry-run --verbose
   ```

3. **Check specific person:**
   ```bash
   python3 main.py --test-mode --test-name debug --person "John Doe" --dry-run --verbose
   ```

4. **Compare output directories:**
   ```bash
   diff -r tests/test-files/from/John\ Doe/ tests/test-files/to-basic/John\ Doe/
   ```

## More Information

- See `docs/FILENAME_CONVENTIONS.md` and `docs/NAMING_CONVENTIONS.md` for extraction logic details.
- See `docs/USAGE_GUIDE.md` for comprehensive usage instructions.
- See `README.md` for comprehensive project documentation.
- See `IMPLEMENTATION_SUMMARY.md` for technical implementation details. 