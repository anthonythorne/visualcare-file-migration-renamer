# VisualCare File Migration Renamer

## Overview
This project automates the renaming and preparation of bulk client, staff, and policy documents for upload into VisualCare. The script standardises file naming conventions, extracts or assigns dates, maps client/staff names to IDs, handles management flagging, and supports iterative testing and refinement.

## Name Matching Rules

### Full Name Matching
- Matches full names with any non-letter characters (numbers, underscores, dashes, etc.) between name parts
- Examples:
  - `john_doe` matches "John Doe"
  - `john-ads-doe` matches "John Doe" (extracts "john,doe" with remainder "ads")
  - `john*doe` matches "John Doe" (extracts "john,doe" with remainder "")
  - `abcdj ads doe` does NOT match "John Doe" (only matches "doe")
  - `johndoe` does NOT match "John Doe" (no separator between names)

### Initials Matching
There are three distinct rules for handling initials:

1. Both Initials (e.g., "JD", "jd", "Jd", "jD"):
   - Must have known separators around them
   - Examples:
     - `abcd-jd-home.pdf` matches "jd" (has `-` separators)
     - `abcd_jd_home.pdf` matches "jd" (has `_` separators)
     - `abcdjdhome.pdf` does NOT match (no separators)

2. First Initial + Last Name (e.g., "jdoe", "Jdoe", "jDoe", "JDoe"):
   - Does NOT need separators around it
   - Examples:
     - `abcdjdoe_report.pdf` matches "jdoe"
     - `abcdjdoehome.pdf` matches "jdoe"
     - `abcdJdoe_report.pdf` matches "Jdoe"
     - `abcdjDoe_report.pdf` matches "jDoe"

3. First Name + Last Initial (e.g., "johnD", "JohnD", "johnD", "JohnD"):
   - Does NOT need separators around it
   - Examples:
     - `abcdjohnD_report.pdf` matches "johnD"
     - `abcdjohnDhome.pdf` matches "johnD"
     - `abcdJohnD_report.pdf` matches "JohnD"

### Case Insensitivity
- All matching is case-insensitive
- Original case is preserved in the extracted name and remainder

### Numbers and Special Characters
- Names containing numbers are matched if they contain valid name parts
- Examples:
  - `john123-doe` matches "john doe"
  - `123john-doe` matches "john doe"
  - `john-doe123` matches "john doe"
  - `123john-doe123` matches "john doe"
- Special characters in names are treated similarly
- Examples:
  - `john@-doe` matches "john doe"
  - `john-doe@` matches "john doe"
  - `@john-doe` matches "john doe"

### Unicode and Accented Characters
- Names with accented characters are matched if they contain valid name parts
- Examples:
  - `jón-doe` matches "jón doe"
  - `jóhn-doe` matches "jóhn doe"
  - `jôhn-doe` matches "jôhn doe"
  - `jöhn-doe` matches "jöhn doe"
- Common variations and typos are handled
- Examples:
  - `jón-doe` and `jon-doe` both match
  - `jóhn-doe` and `jôhn-doe` both match

### Multiple Match Handling
- All valid name matches in a filename are extracted
- Duplicate matches are removed (e.g., "john-doe-john-doe" → "john,doe")
- Different variations of the same name are treated as unique:
  - "john-doe-jdoe" → "john,doe,jdoe"
  - "john-doe-johnD" → "john,doe,johnD"
  - "jdoe-johnD" → "jdoe,johnD"
- Matches are preserved in their original case
- The remainder is cleaned of any matched names and their surrounding separators

### Folder and Category Handling
- Names are extracted from files in various folder structures:
  - Management folders: `management/john-doe-report.pdf`
  - Category folders: `hazard_reports/john-doe-report.pdf`
  - Nested folders: `client/john_doe/hazard_reports/report.pdf`
- Category information is preserved in the remainder
- Examples:
  - `management/john-doe-report.pdf` → "john,doe" with remainder "management-report.pdf"
  - `hazard_reports/john_doe_report.pdf` → "john,doe" with remainder "hazard_reports-report.pdf"
  - `client/john_doe/management/report.pdf` → "john,doe" with remainder "client-management-report.pdf"

### Version Numbers and Dates
- Version numbers are preserved in the remainder
- Examples:
  - `john-doe-report-v1.0.pdf` → "john,doe" with remainder "report-v1.0.pdf"
  - `john-doe-report-v2.1.pdf` → "john,doe" with remainder "report-v2.1.pdf"
- Dates in various formats are preserved
- Examples:
  - `john_doe_2023-01-01.pdf` → "john,doe" with remainder "2023-01-01.pdf"
  - `john_doe_23rd_June_2023.pdf` → "john,doe" with remainder "23rd_June_2023.pdf"

### Extraction Logic
- Removes the matched name permutation from the filename
- Trims leading/trailing separators from the remainder
- Preserves original case and internal separators in the remainder
- For multiple matches:
  - Returns comma-separated list of unique matches (duplicates are removed)
  - Matches are returned in order of appearance
  - Examples:
    - `john-doe-john-doe-report.pdf` → "john,doe" (duplicate removed)
    - `john-ads-doe_report.pdf` → "john,doe" with remainder "ads-report.pdf"
    - `john*doe-2023.pdf` → "john,doe" with remainder "2023.pdf"
    - `abcdjdoe_report.pdf` → "jdoe" with remainder "abcd_report.pdf"
    - `john-doe-sarah-smith-report.pdf` → "john,doe,sarah,smith" with remainder "report.pdf"
    - `john-doe-jdoe-report.pdf` → "john,doe,jdoe" with remainder "report.pdf"
    - `jdoe-john-doe-report.pdf` → "jdoe,john,doe" with remainder "report.pdf"

## Testing
The project includes a comprehensive test matrix covering all name matching scenarios. Run the test suite using BATS:
```bash
bats tests/unit/name_utils_test.bats
bats tests/unit/name_utils_table_test.bats
```

For a complete list of test cases and examples, see [tests/fixtures/name_extraction_cases.csv](tests/fixtures/name_extraction_cases.csv). This file contains all the test cases used to verify the name extraction functionality, including examples of:
- Basic name formats with standard separators
- Multiple separators
- Mixed separators
- Non-standard separators
- Extra content between names
- Initials variations
- Case variations
- Names with numbers and special characters
- Multiple matches in same filename
- Initials with extra content
- No match cases
- Edge cases
- Date variations
- Common name variations and typos
- Mixed variations
- Management flag cases
- Document category cases
- Nested folder cases
- Complex nested paths
- Multiple names with complex paths
- Version numbers with dates
- Multiple dates
- Complex separators with categories
- Mixed content with categories

## Usage
[Usage instructions and examples will be added here.]

## Contributing
[Contributing guidelines will be added here.]

# Visualcare File Migration Renamer

A flexible, extensible command-line utility for migrating and renaming files to meet Visualcare's import requirements. This tool is designed to be modular and plugin-based, allowing for custom business rules and integration with various data sources.

## Features

- Recursive file discovery and processing in nested directories
- Configurable ID mapping from external data sources (CSV, JSON, etc.)
- Intelligent date extraction from filenames or metadata
- Robust filename sanitization
- Plugin system for custom business rules and processing
- Comprehensive reporting and logging
- Automated testing with BATS (Bash Automated Testing System)

## Project Structure

```
visualcare-file-migration-renamer/
├── bin/                    # Executable scripts
│   └── vcmigrate          # Main entry point
├── config/                 # Configuration files
│   ├── default/           # Default configurations
│   └── examples/          # Example configurations
├── core/                   # Core functionality
│   ├── processors/        # File processing modules
│   ├── mappers/          # ID mapping modules
│   └── utils/            # Utility functions
├── plugins/               # Plugin directory
│   ├── pre-process/      # Pre-processing hooks
│   ├── post-process/     # Post-processing hooks
│   └── custom/           # Custom business rules
├── tests/                # Test suite
│   ├── unit/            # Unit tests
│   ├── integration/     # Integration tests
│   └── fixtures/        # Test data and fixtures
└── docs/                 # Documentation
```

## Quick Start

1. Clone the repository
2. Copy `config/examples/config.yaml` to `config/config.yaml`
3. Customize the configuration for your needs
4. Run the migration:
   ```bash
   ./bin/vcmigrate --config config/config.yaml
   ```

## Development Setup

1. Install BATS (Bash Automated Testing System):
   ```bash
   # Using npm
   npm install -g bats
   
   # Or using Homebrew
   brew install bats-core
   ```

2. Run the test suite:
   ```bash
   ./tests/run_tests.sh
   ```

## Configuration

The tool is configured using YAML files. Key configuration areas include:

- ID mapping sources and rules
- Date format patterns
- File naming conventions
- Plugin configurations
- Processing rules

See `config/examples/` for sample configurations.

## Plugin System

The tool supports plugins in several ways:

1. **Pre/Post Processing Hooks**: Execute custom code before or after main processing
2. **Custom Processors**: Add new file type handlers or processing logic
3. **Custom Mappers**: Implement custom ID mapping logic
4. **Business Rules**: Add organization-specific rules and validations

See `docs/plugins.md` for detailed plugin development guide.

## Testing

The project uses BATS (Bash Automated Testing System) for automated testing. The test suite includes:

- Unit tests for core utilities
- Integration tests for end-to-end functionality
- Test fixtures for reproducible test cases

To run the tests:
```bash
./tests/run_tests.sh
```

## Contributing

We welcome contributions! Please see `CONTRIBUTING.md` for guidelines.

## Roadmap

- [ ] Python port with enhanced plugin capabilities
- [ ] Node.js port for web integration
- [ ] GUI interface
- [ ] Additional data source integrations
- [ ] Enhanced reporting and analytics

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Name Permutations: Coverage and Description

Below is a list of all realistic permutations and variations for matching a person's name (e.g., "John Doe") in filenames. These descriptions can guide your matching logic and inform users about what's included and what's not.

### Standard Permutations
- **Exact match**: The full name appears exactly, with or without separators (e.g., john_doe, john-doe, john.doe, john doe, johndoe).
- **Reversed order**: Last name before first name (e.g., doe_john, doe-john, doe.john, doejohn).
- **Initials and surname**: First initial plus last name (e.g., jdoe, j-doe, j_doe, j.doe, J.Doe, JDoe).
- **First name and last initial**: (e.g., john_d, john-d, john.d, JohnD).
- **Both initials**: First and last name as initials (e.g., jd, j.d, j-d, JD).
- **Camel case**: Names combined with capitalisation (e.g., JohnDoe, DoeJohn, JDoe, JohnD).
- **Mixed case**: Any permutation in uppercase, lowercase, or title case.
- **Spaces vs. no spaces**: Name with spaces, tabs, or no separators.
- **Extra or multiple separators**: Names separated by multiple dashes, underscores, or periods (e.g., john__doe, john--doe, john...doe).

### Filename Context Variations
- **Prefix/suffix text**: Name embedded in a longer filename with additional words or codes before or after (e.g., invoice_john_doe_2023.pdf, report-JohnDoe.pdf).
- **Date and numeric patterns**: Name adjacent to dates, times, or numbers in various formats (e.g., john_doe_20230506.pdf, 2023-05-06-johndoe.pdf, doe_john-2023.txt).
- **Additional descriptive text**: Name surrounded by words such as "report", "summary", "statement", etc.
- **Name with versioning**: Filenames with appended version numbers or labels (e.g., john_doe-v2.pdf, jdoe_final.docx).

### Partial & Embedded Permutations
- **Non-adjacent first and last name**: Name parts separated by other words or symbols (e.g., john_smith_doe.pdf, john_2023_doe.pdf).
- **Initials embedded in other words**: Initials appearing at the start, end, or within words (e.g., JD_Report.pdf, ReportJD.pdf).
- **Reverse or split names**: Name appears backwards, partially, or split with other words or numbers.

### Edge & Exotic Cases (Programmatic Handling Recommended)
- **Whitespace/typos**: Names with arbitrary or accidental whitespace within or between name parts (e.g., J o h n _ D o e .pdf).
- **Multiple middle names or initials**: Additional middle initials or names present (e.g., John Q. Doe, J.Q.Doe).
- **Misspellings or character transpositions**: Common or likely typos (e.g., JonhDoe, JohnDoee).
- **International/localised name variants**: Alternate spellings or translations (e.g., Juan_Doe, Johann_Doe).
- **Unicode/accents/homoglyphs**: Names using accented letters or visually similar Unicode glyphs (e.g., Jöhn_Döe, Jоhn_Doe with Cyrillic "o").
- **Hidden/invisible characters**: Zero-width spaces, BOMs, or other non-printing Unicode inserted in the filename.
- **Substring containment**: The target name is embedded within other, unrelated words or as a part of longer names (e.g., report_about_johnny_doedoe.pdf).

### Summary Table (for README)
| Pattern Type | Description / Example |
|--------------|----------------------|
| Exact match | john_doe, john-doe, johndoe |
| Reversed | doe_john, doe-john, doejohn |
| Initials + surname | jdoe, j-doe, j_doe, j.doe, JDoe |
| First name + initial | john_d, john-d, JohnD |
| Both initials | jd, j.d, j-d, JD |
| CamelCase/MixedCase | JohnDoe, DoeJohn, JohnD |
| Extra separators | john__doe, john--doe, john...doe |
| Prefix/Suffix | invoice_john_doe_2023.pdf, summary-JDoe.pdf |
| Dates/Numerics | john_doe_20230506.pdf, 2023-05-06-johndoe.pdf |
| Additional descriptors | john_doe_final.pdf, JDoeReport.txt |
| Partial/non-adjacent | john_2023_doe.pdf, john_smith_doe.pdf |
| Whitespace/typos | J o h n _ D o e .pdf, JonhDoe.pdf |
| Multiple initials/names | John Q. Doe.pdf, J.Q.Doe.docx |
| Localisation/Unicode | Jöhn_Döe.pdf, Johann_Doe.pdf, Jоhn_Doe.pdf |
| Hidden/invisible chars | (Not visible—zero-width, BOM) |
| Substrings/embedded | report_about_johnny_doedoe.pdf |

## Date Permutations: Coverage and Description

Below is a list of realistic permutations and variations for matching dates in filenames. These descriptions can guide your matching logic and inform users about what's included and what's not.

### Standard Date Formats
- **YYYYMMDD**: Full year, month, and day (e.g., 20230506).
- **YYYY-MM-DD**: Full year, month, and day with hyphens (e.g., 2023-05-06).
- **YYYY/MM/DD**: Full year, month, and day with slashes (e.g., 2023/05/06).
- **DDMMYYYY**: Day, month, and full year (e.g., 06052023).
- **DD-MM-YYYY**: Day, month, and full year with hyphens (e.g., 06-05-2023).
- **DD/MM/YYYY**: Day, month, and full year with slashes (e.g., 06/05/2023).
- **MMDDYYYY**: Month, day, and full year (e.g., 05062023).
- **MM-DD-YYYY**: Month, day, and full year with hyphens (e.g., 05-06-2023).
- **MM/DD/YYYY**: Month, day, and full year with slashes (e.g., 05/06/2023).

### Abbreviated Date Formats
- **YYMMDD**: Two-digit year, month, and day (e.g., 230506).
- **YY-MM-DD**: Two-digit year, month, and day with hyphens (e.g., 23-05-06).
- **YY/MM/DD**: Two-digit year, month, and day with slashes (e.g., 23/05/06).
- **DDMMYY**: Day, month, and two-digit year (e.g., 060523).
- **DD-MM-YY**: Day, month, and two-digit year with hyphens (e.g., 06-05-23).
- **DD/MM/YY**: Day, month, and two-digit year with slashes (e.g., 06/05/23).
- **MMDDYY**: Month, day, and two-digit year (e.g., 050623).
- **MM-DD-YY**: Month, day, and two-digit year with hyphens (e.g., 05-06-23).
- **MM/DD/YY**: Month, day, and two-digit year with slashes (e.g., 05/06/23).

### Ambiguous Date Formats (Not Honored)
- **American Format (MM/DD/YYYY)**: Dates in the format MM/DD/YYYY are not honored unless the day is greater than 12 (e.g., 05/06/2023 is interpreted as June 5, 2023, not May 6, 2023).
- **Dates with Ordinal Indicators**: Dates like "5th June 2023" are not matched.
- **Dates with Dots**: Dates like "06.05.2023", "6.5.2023", "6.5.23", "5.6.23" are not matched.

### Grey Areas and Assumptions
- **Years from the Last Decade**: Years like 15-25 are assumed to be 2015-2025.
- **Common Sense Dates**: If the day is greater than 12, it is assumed to be a day, not a month (e.g., 13/05/2023 is interpreted as May 13, 2023).

### Filename Context Variations
- **Date embedded in filename**: Date appears as part of a longer filename (e.g., report_20230506.pdf, invoice-2023-05-06.pdf).
- **Date with additional text**: Date surrounded by words such as "report", "summary", "statement", etc. (e.g., report_20230506_final.pdf).
- **Date with versioning**: Filenames with appended version numbers or labels (e.g., report_20230506-v2.pdf).

### Edge & Exotic Cases (Programmatic Handling Recommended)
- **Whitespace/typos**: Dates with arbitrary or accidental whitespace within or between parts (e.g., 2023 05 06.pdf).
- **Misspellings or character transpositions**: Common or likely typos (e.g., 20230506.pdf, 20230506.pdf).
- **International/localised date variants**: Alternate date formats (e.g., 06.05.2023, 06/05/2023).
- **Hidden/invisible characters**: Zero-width spaces, BOMs, or other non-printing Unicode inserted in the filename.

### Summary Table (for README)
| Pattern Type | Description / Example |
|--------------|----------------------|
| YYYYMMDD | 20230506 |
| YYYY-MM-DD | 2023-05-06 |
| YYYY/MM/DD | 2023/05/06 |
| DDMMYYYY | 06052023 |
| DD-MM-YYYY | 06-05-2023 |
| DD/MM/YYYY | 06/05/2023 |
| MMDDYYYY | 05062023 |
| MM-DD-YYYY | 05-06-2023 |
| MM/DD/YYYY | 05/06/2023 |
| YYMMDD | 230506 |
| YY-MM-DD | 23-05-06 |
| YY/MM/DD | 23/05/06 |
| DDMMYY | 060523 |
| DD-MM-YY | 06-05-23 |
| DD/MM/YY | 06/05/23 |
| MMDDYY | 050623 |
| MM-DD-YY | 05-06-23 |
| MM/DD/YY | 05/06/23 |
| Embedded | report_20230506.pdf, invoice-2023-05-06.pdf |
| Additional descriptors | report_20230506_final.pdf |
| Whitespace/typos | 2023 05 06.pdf |
| Localisation/Unicode | 06.05.2023, 06/05/2023 |
| Hidden/invisible chars | (Not visible—zero-width, BOM) |

## Table-Driven Name Extraction Tests

To ensure robust and transparent name extraction logic, this project uses a table-driven approach for testing. Test cases are defined in a CSV file and automatically run by a BATS test script.

### Test Matrix Location
- **CSV file:** `tests/fixtures/name_extraction_cases.csv`
- **Test runner:** `tests/unit/name_utils_table_test.bats`

### CSV Format
Each row in the CSV represents a test case with the following columns:
- `filename`: The input filename (with extension) to test.
- `expected_match`: The expected matched name permutation (or empty if no match is expected).
- `expected_remainder`: The expected filename after the matched name is removed (or the original filename if no match).

#### Example:
```
filename,expected_match,expected_remainder
john_doe_20230101.pdf,john_doe,20230101.pdf
john-ads-doe_report.pdf,john-ads-doe,report.pdf
abcdjdoe_report.pdf,jdoe,abcd_report.pdf
...
```

### Running the Table-Driven Tests
To run all table-driven name extraction tests:

```sh
bats tests/unit/name_utils_table_test.bats
```

### Expanding the Test Matrix
- Add new rows to `tests/fixtures/name_extraction_cases.csv` to cover additional permutations, edge cases, or real-world examples.
- The test runner will automatically include all cases in the CSV.
- This approach makes it easy to visualize, review, and maintain comprehensive test coverage.

### Contribution Guidelines
- Please add new test cases for any new logic, bugfix, or edge case you encounter.
- If you find a filename that is not handled as expected, add it to the CSV and submit a pull request.

---

For more details on the matching rules and logic, see the [Name Matching Rules](#name-matching-rules) section above.
