# VisualCare File Migration Renamer

This project provides a comprehensive tool to rename files based on a CSV mapping file. It is designed to handle various file naming patterns and extract both names and dates from filenames using advanced pattern matching and validation. The system now supports **User ID mapping**, **configurable filename formats**, **category support**, and **management flags** for real-world file migration scenarios.

## Overview

The tool reads a CSV file containing mappings of old filenames to new filenames. It processes each file, extracts names and dates from the old filename using sophisticated pattern matching, and renames the file according to the new filename format. The system supports both individual and compound name patterns, with intelligent separator preservation.

**New Features (Latest Update):**
- **User ID Mapping**: Map user IDs to full names for consistent filename generation
- **Configurable Filename Format**: Template-based filename generation with placeholders
- **Category Support**: Future-ready category detection and mapping
- **Management Flags**: Automatic detection and flagging of management files
- **Enhanced Testing**: 174 total tests (144 unit + 30 integration) with 100% pass rate

## Features

- **CSV Mapping:** Use a CSV file to map old filenames to new filenames.
- **Advanced Name Extraction:** Extract names from filenames using various patterns (first name, last name, initials, compound patterns).
- **Type-Based Processing:** Extract names by type (shorthand first, then first names, then last names) to prevent incorrect splitting.
- **Date Extraction:** Extract dates from filenames using comprehensive date format support.
- **User ID Mapping:** Map user IDs to full names for consistent filename generation.
- **Configurable Filename Format:** Template-based filename generation with placeholders.
- **Category Support:** Future-ready category detection and mapping from folder names.
- **Management Flags:** Automatic detection and flagging of management files.
- **Dynamic Separator Configuration:** Load separators from component-based YAML configuration (`config/components.yaml`) with precedence-based cleaning.
- **File Renaming:** Rename files based on the extracted names/dates and the new filename format.
- **Test Scaffolding:** Automatically generate BATS tests from CSV files, ensuring one test per line for easy debugging.
- **Comprehensive Test Coverage:** 174 test cases covering all major scenarios with 100% pass rate.

## Real-World Use Case Support

This tool is designed to handle real-world file migration scenarios as described in the original requirements:

### Example Transformations
**Original:** `F016 Sarah Support Plan 16.04.23 - v5.0.docx`
- Client ID: 1234
- Client Name: Sarah Smith
- File Date: 16.04.23 (converted to 20230416)
- **New filename:** `1234_Sarah Smith_F016SarahSupportPlanV5.0_20230416.docx`

**Original:** `Hazard Report - Crates under legs of lounge - Sarah Smith.pdf`
- Client ID: 1234
- Client Name: Sarah Smith
- Date: From file's modified property: 12/05/2023 (converted to 20230512)
- **New filename:** `1234_Sarah Smith_HazardReportCratesUnderLegsofLounge_20230512.pdf`

## Configuration

### Filename Format Configuration

The system now supports configurable filename formats using placeholders:

```yaml
FilenameFormat:
  # Template for normalized filename using placeholders
  # Available placeholders: {id}, {name}, {date}, {remainder}, {category}, {management_flag}
  template: "{id}_{name}_{remainder}_{date}"
  
  # Separator between components in the final filename
  component_separator: "_"
  
  # Whether to include empty components (e.g., if no date, skip the separator)
  skip_empty_components: true
  
  # Whether to clean up multiple consecutive separators in final filename
  cleanup_separators: true
```

### User ID Mapping

Map user IDs to full names for consistent filename generation:

```yaml
UserMapping:
  # Path to CSV file containing user ID to name mappings
  mapping_file: "config/user_mapping.csv"
  
  # Column names in the mapping CSV
  id_column: "user_id"
  name_column: "full_name"
  
  # Whether to create the mapping file if it doesn't exist
  create_if_missing: true
  
  # Default behavior when user ID is not found in mapping
  missing_id_behavior: "error"
```

**Example user_mapping.csv:**
```csv
user_id,full_name
1001,John Doe
1002,Jane Smith
1003,Bob Johnson
1004,Sarah Smith
1005,Michael Brown
```

### Category Support (Future-Ready)

```yaml
Category:
  # Whether to enable category support
  enabled: false
  
  # Default category when none can be determined
  default_category: "general"
  
  # Category mapping from folder names to category codes
  folder_mapping:
    "Hazard & Risk Reports": "hazard"
    "Management": "management"
    "Support Plans": "support"
    "Policies": "policy"
  
  # Whether to append category to filename
  append_to_filename: false
```

### Management Flag Configuration

```yaml
ManagementFlag:
  # Whether to enable management flag detection
  enabled: true
  
  # Keywords that indicate management files
  keywords:
    - "management"
    - "admin"
    - "supervisor"
  
  # Flag to append to management files
  flag: "MGMT"
  
  # Where to place the flag in the filename
  placement: "suffix"
```

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
- **Dynamic Separator Loading:** Loads separators from `config/components.yaml`
- **Separator Preservation:** Maintains original separators in the remainder

### 3. **Bash Integration** (`core/utils/name_utils.sh`)
- **Shell Wrapper:** Provides a Bash interface to the Python name matcher
- **Individual Matchers:** Separate functions for first name, last name, and initials extraction
- **Consistent API:** Matches the existing date extraction interface
- **Pipe-Delimited Output:** Returns results in format: `extracted_names|raw_remainder|match_status`

### 4. **Smart Cleaning Function**
- **Separator Precedence:** Uses separator order from `config/components.yaml` to determine cleaning preference
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

## Combo Name and Date Extraction

The system supports extracting both names and dates from filenames in a single call, using the combo extraction function:

### 1. **Python-Based Combo Extractor** (`core/utils/name_matcher.py`)
- **Function:** `extract_name_and_date_from_filename(filename, name_to_match)`
- **Returns:** `extracted_name|extracted_date|raw_remainder|name_matched|date_matched`
- **Raw remainder:** The filename with both name and date removed (all leftover separators preserved).
- **Cleaned remainder:** Use the cleaning function to normalize the raw remainder for final renaming.

### 2. **Bash Integration** (`core/utils/name_utils.sh`)
- **Shell Wrapper:** `extract_name_and_date_from_filename <filename> <name_to_match>`
- **Output:** `extracted_name|extracted_date|raw_remainder|name_matched|date_matched`

#### Example Usage
```bash
# Extract both name and date from a filename
source core/utils/name_utils.sh
extract_name_and_date_from_filename "John_Doe_2023-05-15_Report.pdf" "john doe"
# Output: John,Doe|2023-05-15|___Report.pdf|true|true

# Clean the remainder for final renaming
clean_filename_remainder "___Report.pdf"
# Output: Report.pdf
```

### 3. **Combined Extraction Tests**
- The combined extraction logic is tested using a dedicated CSV matrix: `tests/fixtures/combined_extraction_cases.csv`.
- Tests are generated and run using the same BATS-based workflow as for name and date extraction.
- See [docs/TESTING.md](docs/TESTING.md) for details on running and understanding combined tests.

## User ID Mapping

### 1. **Python-Based User Mapping** (`core/utils/user_mapping.py`)
- **CSV-Based Mapping:** Loads user ID to name mappings from configurable CSV file
- **Fuzzy Matching:** Supports case-insensitive and partial name matching
- **ID Extraction:** Can extract user IDs from filenames using pattern matching
- **Filename Formatting:** Formats filenames according to configured template

### 2. **Key Functions**
```python
# Get user ID by name
get_user_id_by_name("John Doe")  # Returns "1001"

# Get name by user ID
get_name_by_user_id("1001")  # Returns "John Doe"

# Extract user ID from filename
extract_user_id_from_filename("1234_report.pdf", "John Doe")  # Returns "1234"

# Format filename with ID
format_filename_with_id("1001", "John Doe", "2023-05-15", "report.pdf")
# Returns "1001_John Doe_report_2023-05-15.pdf"
```

### 3. **CLI Interface**
```bash
# Get user ID by name
python3 core/utils/user_mapping.py get_id "John Doe"

# Get name by user ID
python3 core/utils/user_mapping.py get_name "1001"

# Extract user ID from filename
python3 core/utils/user_mapping.py extract_id "1234_report.pdf" "John Doe"
```

## Naming and Separator Conventions

See [FILENAME_CONVENTIONS.md](docs/FILENAME_CONVENTIONS.md) for the full, up-to-date documentation on all name extraction, matching, and cleaning logic, including matcher types, YAML-driven separator configuration, and case handling.

### Separator Order and Cleaning
- The order of separators in `config/components.yaml` determines their cleaning preference.
- When cleaning, for any run of consecutive separators, the most preferred (earliest in the YAML list) is kept and all others are removed.
- This ensures consistent, extensible, and predictable filename normalization.

**Example with components.yaml:**
```yaml
Name:
  allowed_separators_when_searching:
  - " "  # space (most preferred)
  - "-"  # hyphen
  - "_"  # underscore
  - "."  # period (least preferred)
  allowed_separators:
    - " "  # space
Remainder:
  allowed_separators:
    - " "  # space
    - "-"  # hyphen
    - "."  # period
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

**📖 For comprehensive usage instructions, see [Usage Guide](docs/USAGE_GUIDE.md)**

### Quick Examples

```bash
# Test mode (recommended for testing)
python3 main.py --test-mode --test-name my-test --dry-run

# Process CSV mapping
python3 main.py --csv mapping.csv --dry-run

# Process directory with name mapping
python3 main.py --input-dir /path/to/input --output-dir /path/to/output --name-mapping names.csv --dry-run
```

### Running the Tool

1. Prepare your CSV mapping file (e.g., `mapping.csv`) with the following columns:
   - `old_filename`: The original filename.
   - `new_filename`: The desired new filename.

2. Run the tool:
   ```bash
   python3 main.py --csv mapping.csv
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

### User ID Mapping Examples

```bash
# Get user ID by name
python3 core/utils/user_mapping.py get_id "John Doe"
# Output: 1001

# Get name by user ID
python3 core/utils/user_mapping.py get_name "1001"
# Output: John Doe

# Extract user ID from filename
python3 core/utils/user_mapping.py extract_id "1234_report.pdf" "John Doe"
# Output: 1234

# Format filename with ID
python3 core/utils/user_mapping.py format "1001" "John Doe" "2023-05-15" "report.pdf"
# Output: 1001_John Doe_report_2023-05-15.pdf
```

### Configuration

The system uses dynamic separator configuration from `config/components.yaml`:

```yaml
Name:
  allowed_separators_when_searching:
    - " "  # space (most preferred)
    - "-"  # hyphen
    - "_"  # underscore
    - "."  # period (least preferred)
  allowed_separators:
    - " "  # space
Remainder:
  allowed_separators:
    - " "  # space
    - "-"  # hyphen
    - "."  # period
```

**To change or add valid separators, update `config/components.yaml`.**

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

### Test Coverage
- **Total Tests:** 159 tests with 100% pass rate
- **Unit Tests:** 144 BATS tests (30 combined + 16 date + 98 name)
- **Integration Tests:** 15 tests (11 test mode BATS + 4 shell script)
- **Test Generation:** Automated BATS test generation from CSV matrices
- **Test Mode:** Real file processing with separate output directories

### Running Tests
```bash
# Run all tests (144 unit + 15 integration)
./tests/run_tests.sh

# Run specific test types
bats tests/unit/combined_utils_table_test.bats
bats tests/unit/date_utils_table_test.bats
bats tests/unit/name_utils_table_test.bats
bats tests/unit/test_mode_integration_test.bats

# Run integration tests
python3 tests/scripts/generate_bats_tests.py integration

# Regenerate tests from CSV
python3 tests/scripts/generate_bats_tests.py combined
python3 tests/scripts/generate_bats_tests.py name
python3 tests/scripts/generate_bats_tests.py date
```

### Test Mode Integration Testing
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

For all details on generating, running, and understanding the test suite (including name, date, and combined extraction tests), see:

[docs/TESTING.md](docs/TESTING.md)

This file covers:
- How to regenerate BATS tests from CSV matrices
- How to run all or specific tests
- The combined extraction matrix and its purpose
- Troubleshooting tips

## Potential Issues and Concerns

### 1. **User ID Mapping**
- **Missing IDs:** What happens when a name doesn't have a corresponding user ID?
- **Duplicate Names:** How to handle multiple people with the same name?
- **ID Format:** Should we support different ID formats (numeric, alphanumeric, etc.)?

### 2. **Filename Format**
- **Special Characters:** What special characters are allowed in final filenames?
- **Length Limits:** Are there filename length restrictions?
- **Uniqueness:** How to handle potential filename collisions?

### 3. **Category Support**
- **Folder Structure:** How to handle nested folder structures for categorization?
- **Default Categories:** What should be the default category for uncategorized files?
- **Category Mapping:** How to map folder names to standardized category codes?

### 4. **Management Flags**
- **Detection Logic:** How to reliably detect management files?
- **Flag Placement:** Where should management flags appear in filenames?
- **Multiple Flags:** How to handle files that might have multiple flags?

### 5. **Performance**
- **Large File Sets:** How to handle processing thousands of files efficiently?
- **Memory Usage:** How to manage memory when processing large CSV files?
- **Error Recovery:** How to handle and recover from processing errors?

### 6. **Validation**
- **Input Validation:** How to validate CSV input files?
- **Output Validation:** How to ensure generated filenames meet system requirements?
- **Duplicate Detection:** How to detect and handle duplicate filenames?

## Documentation

**📚 [Documentation Index](docs/README.md)** - Complete documentation overview and navigation

### Core Documentation
- **[Usage Guide](docs/USAGE_GUIDE.md)** - Comprehensive usage instructions and examples
- **[Implementation Summary](docs/IMPLEMENTATION_SUMMARY.md)** - Technical architecture and design
- **[Testing Guide](docs/TESTING.md)** - Testing guide and test generation

### Technical Specifications
- **[Naming Conventions](docs/NAMING_CONVENTIONS.md)** - Name extraction logic and matching rules
- **[Filename Conventions](docs/FILENAME_CONVENTIONS.md)** - Filename processing and formatting conventions

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for development guidelines and contribution instructions.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
