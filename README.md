# VisualCare File Migration Renamer

This project provides a comprehensive tool to rename files based on a CSV mapping file. It is designed to handle various file naming patterns and extract both names and dates from filenames using advanced pattern matching and validation.

## Overview

The tool reads a CSV file containing mappings of old filenames to new filenames. It processes each file, extracts names and dates from the old filename using sophisticated pattern matching, and renames the file according to the new filename format. The system supports both individual and compound name patterns, with intelligent separator preservation.

## Features

- **CSV Mapping:** Use a CSV file to map old filenames to new filenames.
- **Advanced Name Extraction:** Extract names from filenames using various patterns (first name, last name, initials, compound patterns).
- **Sequential Part-by-Part Matching:** Extract names sequentially, preserving original separators and handling order-agnostic matching.
- **Date Extraction:** Extract dates from filenames using comprehensive date format support.
- **Dynamic Separator Configuration:** Load separators from YAML configuration files.
- **File Renaming:** Rename files based on the extracted names/dates and the new filename format.
- **Test Scaffolding:** Automatically generate BATS tests from CSV files, ensuring one test per line for easy debugging.
- **Comprehensive Test Coverage:** 46 test cases covering all major name extraction scenarios.

## Name Extraction Approach

The name extraction system follows a sophisticated, multi-layered approach:

### 1. **Python-Based Name Matcher** (`core/utils/name_matcher.py`)
- **Sequential Extraction:** Extracts name parts one by one, preserving original separators
- **Compound Pattern Support:** Handles initial+last name, first name+initial, and both initials patterns
- **Order-Agnostic Matching:** Finds names regardless of their order in the filename
- **Case-Insensitive Matching:** Matches names regardless of case
- **Dynamic Separator Loading:** Loads separators from `config/separators.yaml`
- **Separator Preservation:** Maintains original separators in the remainder

### 2. **Bash Integration** (`core/utils/name_utils.sh`)
- **Shell Wrapper:** Provides a Bash interface to the Python name matcher
- **Individual Matchers:** Separate functions for first name, last name, and initials extraction
- **Consistent API:** Matches the existing date extraction interface
- **Pipe-Delimited Output:** Returns results in format: `extracted_names|raw_remainder|match_status`

### 3. **Smart Cleaning Function**
- **Separator Collapsing:** Reduces multiple consecutive separators to single ones
- **Leading/Trailing Cleanup:** Removes unnecessary separators from start/end
- **File Extension Awareness:** Preserves dots before file extensions
- **Preservation Logic:** Maintains meaningful separators within filenames

### 4. **Supported Name Patterns**
```
Full Names:        john-doe, doe-john → john,doe (comma-separated parts)
Initial + Last:    j-doe, j_doe, j doe, j.doe → j-doe (compound with separator)
First + Initial:   john-d, john_d, john d, john.d → john-d (compound with separator)
Both Initials:     j-d, j_d, j d, j.d → j-d (compound with separator)
Individual:        john, doe → extracted separately
```

### 5. **Test-Driven Development**
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

# Full name extraction (comma-separated parts)
extract_name_from_filename "john-doe-report.pdf" "john doe"
# Output: john,doe|--report.pdf|true

# Initial + last name (compound pattern)
extract_name_from_filename "j-doe-report.pdf" "john doe"
# Output: j-doe|-report.pdf|true

# First name + initial (compound pattern)
extract_name_from_filename "john-d-report.pdf" "john doe"
# Output: john-d|-report.pdf|true

# Both initials (compound pattern)
extract_name_from_filename "j-d-report.pdf" "john doe"
# Output: j-d|-report.pdf|true

# Individual name extraction
extract_first_name_only "john-doe-report.pdf" "john"
# Output: john|-doe-report.pdf|true

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
    - "-"
    - "_"
    - " "
    - "."
  non_standard: false  # Set to true to include additional separators

custom_separators:
  - "#"
  - "@"
```

### Testing

The project includes a test scaffolding process to generate BATS tests from CSV files. This ensures that each line in the CSV becomes an individual test, making debugging easier.

#### Generating Tests

1. Update your test cases:
   - Name extraction: `tests/fixtures/name_extraction_cases.csv`
   - Date extraction: `tests/fixtures/date_extraction_cases.csv`

2. Generate the BATS tests:
   ```bash
   # Generate name tests
   python scripts/generate_bats_tests.py name
   
   # Generate date tests
   python scripts/generate_bats_tests.py date
   ```

3. Run the tests:
   ```bash
   # Run all tests
   bats tests/unit/
   
   # Run name extraction tests
   bats tests/unit/name_utils_table_test.bats
   
   # Run date extraction tests
   bats tests/unit/date_utils_table_test.bats
   
   # Run with verbose output
   bats tests/unit/ --show-output-of-passing-tests
   ```

## Project Structure

```
visualcare-file-migration-renamer/
├── bin/
│   ├── vcmigrate              # Main executable
│   └── scaffold_tests.sh      # Test scaffolding script
├── config/
│   ├── default/               # Default configurations
│   ├── examples/              # Example configurations
│   └── separators.yaml        # Separator configuration
├── core/
│   ├── mappers/               # Mapping utilities
│   ├── processors/            # File processing logic
│   └── utils/
│       ├── name_utils.sh      # Name extraction utilities
│       ├── name_matcher.py    # Python name matcher
│       ├── date_utils.sh      # Date extraction utilities
│       ├── date_matcher.py    # Python date matcher
│       ├── config.sh          # Configuration utilities
│       ├── logging.sh         # Logging utilities
│       └── validation.sh      # Validation utilities
├── tests/
│   ├── fixtures/
│   │   ├── name_extraction_cases.csv  # Name test cases
│   │   └── date_extraction_cases.csv  # Date test cases
│   ├── integration/           # Integration tests
│   └── unit/
│       ├── name_utils_table_test.bats # Generated name tests
│       └── date_utils_table_test.bats # Generated date tests
├── scripts/
│   └── generate_bats_tests.py # Test generation script
└── docs/
    └── NAMING_CONVENTIONS.md  # Naming convention documentation
```

## Architecture Principles

### 1. **Separation of Concerns**
- **Python for Complex Logic:** Name/date parsing, validation, and pattern matching
- **Bash for Integration:** Shell scripting, file operations, and system integration
- **CSV for Configuration:** Test cases and mappings stored in structured format
- **YAML for Settings:** Dynamic configuration for separators and other settings

### 2. **Consistent API Design**
- **Unified Interface:** Both name and date extraction use the same pipe-delimited format
- **Modular Functions:** Each utility function has a single, well-defined responsibility
- **Error Handling:** Consistent error reporting and status codes
- **Dynamic Loading:** Configuration loaded at runtime for flexibility

### 3. **Test-Driven Development**
- **Comprehensive Coverage:** 46 total tests covering both extraction and cleaning functions
- **Automated Generation:** Tests generated from human-readable CSV fixtures
- **Regression Prevention:** Automated test suite prevents breaking changes
- **Isolated Testing:** Individual matchers can be tested separately

### 4. **Extensibility**
- **Plugin Architecture:** Easy to add new name patterns or date formats
- **Configurable Separators:** Support for various filename separator characters
- **Modular Design:** Components can be used independently or together
- **Dynamic Configuration:** Settings can be changed without code modification

### 5. **Robust Pattern Matching**
- **Sequential Extraction:** Names extracted part-by-part, preserving separators
- **Compound Patterns:** Support for complex name combinations with separators
- **Order-Agnostic:** Matches names regardless of their position in filename
- **Case-Insensitive:** Handles variations in name casing
- **Separator Preservation:** Maintains original separators in remainders

## Recent Improvements

### Name Matching Enhancements
- **Sequential Part-by-Part Extraction:** Names are now extracted sequentially, preserving original separators
- **Compound Pattern Support:** Full support for initial+last name, first name+initial, and both initials patterns
- **Dynamic Separator Loading:** Separators loaded from YAML configuration for easy customization
- **Comprehensive Test Coverage:** 46 test cases covering all major scenarios
- **Separator Preservation:** Original separators are preserved in remainders as expected by test matrix

### Test Infrastructure
- **Automated Test Generation:** Tests generated from CSV fixtures with one test per line
- **Individual Matcher Testing:** Separate tests for first name, last name, initials, and main matcher
- **Both Extraction and Cleaning:** Tests validate both extraction logic and remainder cleaning
- **Verbose Output:** Detailed debug information for easy troubleshooting

## Contributing

1. Fork the repository.
2. Create a new branch for your feature.
3. Add test cases to the appropriate CSV fixture file.
4. Generate and run tests to ensure your changes work correctly.
5. Update documentation if needed.
6. Commit your changes.
7. Push to the branch.
8. Create a Pull Request.

### Development Workflow
1. **Add Test Cases:** Update `tests/fixtures/name_extraction_cases.csv` or `tests/fixtures/date_extraction_cases.csv`
2. **Generate Tests:** Run `python scripts/generate_bats_tests.py name` or `python scripts/generate_bats_tests.py date`
3. **Implement Changes:** Modify the appropriate Python or Bash files
4. **Run Tests:** Execute `bats tests/unit/` to verify all tests pass
5. **Update Documentation:** Modify README.md and other docs as needed

## License

This project is licensed under the MIT License. See the LICENSE file for details.
