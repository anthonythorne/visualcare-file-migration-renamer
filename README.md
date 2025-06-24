# VisualCare File Migration Renamer

This project provides a comprehensive tool to rename files based on a CSV mapping file. It is designed to handle various file naming patterns and extract both names and dates from filenames using advanced pattern matching and validation.

## Overview

The tool reads a CSV file containing mappings of old filenames to new filenames. It processes each file, extracts names and dates from the old filename using sophisticated pattern matching, and renames the file according to the new filename format. The system supports both individual and compound name patterns, with intelligent separator preservation.

## Features

- **CSV Mapping:** Use a CSV file to map old filenames to new filenames.
- **Advanced Name Extraction:** Extract names from filenames using various patterns (first name, last name, initials, compound patterns).
- **Type-Based Processing:** Extract names by type (shorthand first, then first names, then last names) to prevent incorrect splitting.
- **Date Extraction:** Extract dates from filenames using comprehensive date format support.
- **Dynamic Separator Configuration:** Load separators from YAML configuration files with precedence-based cleaning.
- **File Renaming:** Rename files based on the extracted names/dates and the new filename format.
- **Test Scaffolding:** Automatically generate BATS tests from CSV files, ensuring one test per line for easy debugging.
- **Comprehensive Test Coverage:** 46 test cases covering all major name extraction scenarios.

## Name Extraction Approach

The name extraction system follows a sophisticated, multi-layered approach:

### 1. **Processing Algorithm**
The system processes name matches in a specific order to ensure accurate extraction:

1. **Shorthand Patterns First**: Find all shorthand patterns (e.g., `jdoe`, `j-doe`, `john-d`) before individual name parts
2. **First Names**: Find all remaining first name matches
3. **Last Names**: Find all remaining last name matches
4. **Clean Remainder**: Remove duplicate separators using separator precedence from config

**Why This Order Matters:**
Processing shorthand patterns first prevents them from being incorrectly split into individual name parts. For example:
- `jdoe` should be matched as shorthand, not as `j` + `doe`
- `j-doe` should be matched as shorthand, not as `j` + `doe`

### 2. **Python-Based Name Matcher** (`core/utils/name_matcher.py`)
- **Type-Based Extraction:** Extracts name parts by type (shorthand → first names → last names)
- **Compound Pattern Support:** Handles initial+last name, first name+initial, and both initials patterns
- **Order Preservation:** Finds names in the order they appear in the filename
- **Case-Insensitive Matching:** Matches names regardless of case
- **Dynamic Separator Loading:** Loads separators from `config/separators.yaml`
- **Separator Preservation:** Maintains original separators in the remainder

### 3. **Bash Integration** (`core/utils/name_utils.sh`)
- **Shell Wrapper:** Provides a Bash interface to the Python name matcher
- **Individual Matchers:** Separate functions for first name, last name, and initials extraction
- **Consistent API:** Matches the existing date extraction interface
- **Pipe-Delimited Output:** Returns results in format: `extracted_names|raw_remainder|match_status`

### 4. **Smart Cleaning Function**
- **Separator Precedence:** Uses separator order from YAML config to determine cleaning preference
- **Reverse Removal:** Removes duplicate separators in reverse order of YAML list
- **Leading/Trailing Cleanup:** Removes unnecessary separators from start/end
- **File Extension Awareness:** Preserves dots before file extensions
- **Preservation Logic:** Maintains meaningful separators within filenames

### 5. **Supported Name Patterns**
```
Full Names:        john-doe, doe-john → john,doe (comma-separated parts)
Initial + Last:    j-doe, j_doe, j doe, j.doe → j-doe (compound with separator)
First + Initial:   john-d, john_d, john d, john.d → john-d (compound with separator)
Both Initials:     j-d, j_d, j d, j.d → j-d (compound with separator)
Individual:        john, doe → extracted separately
```

### 6. **Processing Example**
For filename: `"file jdoe medical jdoe 2025 John doe report.txt"` with name "John Doe":

1. **Find all shorthand patterns**: `jdoe,jdoe`
   - Remainder: `"file  medical  2025 John doe report.txt"`

2. **Find all first names**: `John`
   - Combined matches: `jdoe,jdoe,John`
   - Remainder: `"file  medical  2025  doe report.txt"`

3. **Find all last names**: `doe`
   - Combined matches: `jdoe,jdoe,John,doe`
   - Remainder: `"file  medical  2025   report.txt"`

4. **Clean remainder**: Remove duplicate separators using separator precedence
   - Final remainder: `"file medical 2025 report.txt"`

### 7. **Test-Driven Development**
- **Comprehensive Test Matrix:** 23 test cases covering all major scenarios
- **Automated Test Generation:** Tests generated from CSV fixtures
- **Both Extraction and Cleaning Tests:** Validates both name extraction and remainder cleaning
- **Edge Case Coverage:** Handles various separators, compound patterns, and individual names

## Date Extraction Approach

The date extraction system follows a robust, multi-layered approach:

### 1. **Python-Based Date Matcher** (`core/utils/date_matcher.py`)
- **Comprehensive Format Support:** Handles ISO dates, US dates, European dates, compact dates, and written month formats
- **Multiple Date Extraction:** Can extract multiple dates from a single filename
- **Separator Preservation:** Maintains original separators around extracted dates
- **Validation:** Ensures extracted dates are valid using Python's datetime module

### 2. **Bash Integration** (`core/utils/date_utils.sh`)
- **Shell Wrapper:** Provides a Bash interface to the Python date matcher
- **Consistent API:** Matches the existing name extraction interface
- **Pipe-Delimited Output:** Returns results in format: `extracted_dates|raw_remainder|match_status`

### 3. **Smart Cleaning Function**
- **File Extension Awareness:** Preserves dots before file extensions
- **Separator Collapsing:** Reduces multiple consecutive separators to single ones
- **Leading/Trailing Cleanup:** Removes unnecessary separators from start/end
- **Preservation Logic:** Maintains meaningful separators within filenames

### 4. **Supported Date Formats**
```
ISO Dates:     2023-01-15, 2023/01/15, 20230115
US Dates:      01-15-2023, 01/15/2023, 01152023
European Dates: 15-01-2023, 15/01/2023, 15012023
Written Months: 25-Dec-2023, 1st-jan-2024, 15th-Mar-2023
Mixed Formats: 2023-01-15_and_2024-02-20 (multiple dates)
```

### 5. **Test-Driven Development**
- **Comprehensive Test Matrix:** 16 test cases covering all major scenarios
- **Automated Test Generation:** Tests generated from CSV fixtures
- **Both Extraction and Cleaning Tests:** Validates both date extraction and remainder cleaning
- **Edge Case Coverage:** Handles no-date files, multiple dates, and various separators

## Naming and Separator Conventions

See [FILENAME_CONVENTIONS.md](docs/FILENAME_CONVENTIONS.md) for the full, up-to-date documentation on all name extraction, matching, and cleaning logic, including matcher types, YAML-driven separator configuration, and case handling.

### Separator Order and Cleaning
- The order of separators in `config/separators.yaml` determines their cleaning preference.
- When cleaning, for any run of consecutive separators, the most preferred (earliest in the YAML list) is kept and all others are removed.
- This ensures consistent, extensible, and predictable filename normalization.

**Example with separators.yaml:**
```yaml
standard:
  - " "  # space (most preferred)
  - "-"  # hyphen
  - "_"  # underscore
  - "."  # period (least preferred)
```

**Cleaning examples:**
- `"file ---_. reprot.txt"` → `"file reprot.txt"` (space preferred)
- `"file_---_._reprot.txt"` → `"file-reprot.txt"` (hyphen preferred, no spaces)

## Installation

1. Clone the repository:
   ```bash
   git clone <repository-url>
   cd visualcare-file-migration-renamer
   ```

2. Install dependencies:
   ```bash
   pip install -r requirements.txt
   ```

3. Install BATS for testing:
   ```bash
   npm install -g bats
   ```

## Usage

### Running the Tool

1. Prepare your CSV mapping file (e.g., `mapping.csv`) with the following columns:
   - `old_filename`: The original filename.
   - `new_filename`: The desired new filename.

2. Run the tool:
   ```bash
   python main.py --csv mapping.csv
   ```

### Name Extraction Examples

```bash
# Extract names from filenames
source core/utils/name_utils.sh

# --- Individual Matcher Examples ---

# 1. All Matches (default, comma-separated parts)
extract_name_from_filename "john-doe-report.pdf" "john doe"
# Output: john,doe|--report.pdf|true

# 2. First Name Only
extract_name_from_filename "john-doe-report.pdf" "john doe" "extract_first_name_only"
# Output: john|-doe-report.pdf|true

# 3. Last Name Only
extract_name_from_filename "john-doe-report.pdf" "john doe" "extract_last_name_only"
# Output: doe|john--report.pdf|true

# 4. Initials (both initials, any separator)
extract_name_from_filename "j-d-report.pdf" "john doe" "extract_initials_only"
# Output: j-d|-report.pdf|true

# 5. Shorthand (first initial + last name, or first name + last initial)
extract_name_from_filename "j-doe-report.pdf" "john doe" "extract_shorthand"
# Output: j-doe|-report.pdf|true
extract_name_from_filename "john-d-report.pdf" "john doe" "extract_shorthand"
# Output: john-d|-report.pdf|true

# Clean the remainder
clean_filename_remainder "--report.pdf"
# Output: report.pdf
```

### Date Extraction Examples

```bash
# Extract dates from filenames
source core/utils/date_utils.sh

# ISO date format
extract_date_from_filename "report-2023-01-15.pdf"
# Output: 2023-01-15|report-.pdf|true

# Multiple dates
extract_date_from_filename "20230101_and_20240202.log"
# Output: 2023-01-01,2024-02-02|_and_.log|true

# Written month format
extract_date_from_filename "scan 25-Dec-2023.jpg"
# Output: 2023-12-25|scan .jpg|true

# Clean the remainder
clean_date_filename_remainder "report-.pdf"
# Output: report.pdf
```

### Configuration

The system uses dynamic separator configuration from `config/separators.yaml`:

```yaml
default_separators:
  standard:
    - " "  # space (most preferred)
    - "-"  # hyphen
    - "_"  # underscore
    - "."  # period (least preferred)
```

### Processing Examples

```bash
# Example 1: Shorthand first
extract_name_from_filename "jdoe-john-doe-report.pdf" "john doe"
# Output: jdoe,john,doe|---report.pdf|true

# Example 2: Multiple shorthand patterns
extract_name_from_filename "file jdoe medical jdoe 2025 John doe report.txt" "john doe"
# Output: jdoe,jdoe,John,doe|file  medical  2025   report.txt|true

# Example 3: All individual names
extract_name_from_filename "john-doe-john-doe-report.pdf" "john doe"
# Output: john,doe,john,doe|----report.pdf|true
```

## Testing

Run the comprehensive test suite:

```bash
# Run all tests
./tests/run_tests.sh

# Run specific test types
bats --filter "\[matcher_function=shorthand\]" tests/unit/name_utils_table_test.bats
bats --filter "\[matcher_function=all_matches\]" tests/unit/name_utils_table_test.bats
```

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for development guidelines and contribution instructions.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
