# Name Extraction and Filename Processing Conventions

This document provides comprehensive documentation of the name extraction algorithms, filename processing logic, and matching rules used in the VisualCare File Migration Renamer system.

## Overview

The system uses sophisticated pattern matching algorithms to extract names, dates, and other components from filenames. This document covers the complete extraction process, from initial pattern recognition to final filename formatting.

## Name Matching Algorithm

### Processing Order
The system processes name matches in a specific order to ensure accurate extraction:

1. **Shorthand Patterns First**: Find all shorthand patterns (e.g., `jdoe`, `j-doe`, `john-d`) before individual name parts
2. **First Names**: Find all remaining first name matches
3. **Last Names**: Find all remaining last name matches
4. **Clean Remainder**: Remove duplicate separators using separator precedence from config

### Why This Order Matters
Processing shorthand patterns first prevents them from being incorrectly split into individual name parts. For example:
- `jdoe` should be matched as shorthand, not as `j` + `doe`
- `j-doe` should be matched as shorthand, not as `j` + `doe`

### Matcher Types
The system supports several matcher types, each with its own logic:

- **`first_name`**: Extracts the first name from the filename
- **`last_name`**: Extracts the last name from the filename
- **`initials`**: Matches both initials (e.g., `j-d`, `j.d`, `j d`, `jd`) with one or more valid separators or grouped
- **`shorthand`**: Matches first initial + last name (e.g., `j-doe`, `jdoe`, `j.doe`) or first name + last initial (e.g., `john-d`, `john.d`)
- **`all_matches`**: Extracts all possible matches using the processing order described above

## Separator Handling

### Configuration-Driven Separators
- **Source of Truth**: All valid separators are defined in `config/components.yaml`
- **Extensible**: To add or change separators, update the YAML file—no code changes needed
- **Supported Separators** (by default, see `allowed_separators_when_searching` in `config/components.yaml`):
  - Space (` `)
  - Hyphen (`-`)
  - Underscore (`_`)
  - Period (`.`)
  - Asterisk (`*`)
  - At sign (`@`)
  - Hash (`#`)
  - (Others as defined in YAML)

### Multiple/Mixed Separators
Any number or combination of valid separators between name parts or initials is supported:
- `j - _ d` (initials with mixed separators)
- `john---doe` (multiple hyphens)
- `j._d` (period and underscore)

### Separator Precedence and Cleaning
When cleaning the remainder, the system uses separator precedence from `config/components.yaml`:

- **Order matters**: Separators listed first in the YAML are preferred
- **Reverse removal**: When multiple separators are grouped together, remove them in reverse order of the YAML list
- **Keep preferred**: Always keep one instance of the most preferred separator

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

## Case Sensitivity and Character Handling

### Case Sensitivity
- **Matching**: Always case-insensitive
- **Extraction**: The extracted name part preserves the case as it appears in the filename

### Special Characters & Substitutions
- Special characters and common substitutions (e.g., `0` for `o`) are supported in fuzzy matching
- Examples for "Jón Döe":
  - `jón-döe-report.pdf` ✓
  - `j0hn-d03-report.pdf` ✓

### Raw vs Cleaned Remainder
- **Raw Remainder**: The literal filename with the matched part removed (may contain extra separators or spaces)
- **Cleaned Remainder**: The raw remainder, normalized by collapsing multiple separators and trimming leading/trailing separators

## Delimiting and Separator Rules

### General Rules
- **All matcher types** require the match to be delimited by a valid separator (from YAML) or be at the start/end of the filename
- **First Name / Last Name**: Only match if the name is delimited by a separator or at the start/end of the filename
- **Initials / Shorthand**: The entire match must be delimited by a separator or filename boundary

### Valid vs Invalid Patterns
**Valid patterns:**
- `-jdoe-`, `jdoe-`, `-jdoe` (shorthand, delimited)
- `-j---doe-`, `j.doe-`, `j_doe-` (shorthand, multiple/mixed separators)
- `-j-d-`, `j-d-`, `-j-d` (initials, delimited)
- `-j---d-`, `j_d-`, `j--.--d-` (initials, multiple/mixed separators)

**Invalid patterns:**
- `xjdoey`, `foo-jdoe-bar` (not delimited)

## Processing Algorithm Examples

### Example 1: Complex Filename Processing
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

### Example 2: Multiple Matches
For filename: `"john-doe-john-doe-report.pdf"` with name "John Doe":
- Extracts: `john,doe,john,doe` (all individual names in order)

### Example 3: Shorthand Priority
For filename: `"jdoe-john-doe-report.pdf"` with name "John Doe":
- Extracts: `jdoe,john,doe` (shorthand first, then individual names)

## Detailed Examples by Matcher Type

### First Name Matching
Matches the first name anywhere in the filename, using all valid separators.

**Examples for "John Doe":**
- `john-doe-report.pdf` → Extracts `john`
- `John Doe 20240525 report.pdf` → Extracts `John`
- `report-john-final.pdf` → Extracts `john`

### Last Name Matching
Matches the last name anywhere in the filename, using all valid separators.

**Examples for "John Doe":**
- `john-doe-report.pdf` → Extracts `doe`
- `John Doe 20240525 report.pdf` → Extracts `Doe`
- `report-doe-final.pdf` → Extracts `doe`

### Initials Matching
Matches both initials, grouped or separated by any valid separator(s).

**Examples for "John Doe":**
- `jd-report.pdf` → Extracts `jd`
- `j-d-report.pdf` → Extracts `j-d`
- `j.d.report.pdf` → Extracts `j.d`
- `j d report.pdf` → Extracts `j d`
- `j---d-report.pdf` → Extracts `j---d`
- `j - _ d report.pdf` → Extracts `j - _ d`

### Shorthand Matching
Matches first initial + last name or first name + last initial, with any valid separator(s).

**Examples for "John Doe":**
- `j-doe-report.pdf` → Extracts `j-doe`
- `jdoe-report.pdf` → Extracts `jdoe`
- `j.doe-report.pdf` → Extracts `j.doe`
- `john-d-report.pdf` → Extracts `john-d`
- `john.d.report.pdf` → Extracts `john.d`
- `john_d_report.pdf` → Extracts `john_d`

### All Matches (Complete Algorithm)
Extracts all possible matches using the processing order: shorthand → first names → last names.

**Examples for "John Doe":**
- `john-doe-jdoe-report.pdf` → Extracts `jdoe,john,doe` (shorthand first, then individual names)
- `jdoe-john-doe-report.pdf` → Extracts `jdoe,john,doe` (shorthand first, then individual names)
- `john-doe-john-doe-report.pdf` → Extracts `john,doe,john,doe` (all individual names in order)

## Date Extraction Integration

### Combined Name and Date Extraction
The system supports extracting both names and dates from filenames in a single call:

**Function:** `extract_name_and_date_from_filename(filename, name_to_match)`

**Returns:** `extracted_name|extracted_date|raw_remainder|name_matched|date_matched`

**Example:**
```bash
# Extract both name and date from a filename
extract_name_and_date_from_filename "John_Doe_2023-05-15_Report.pdf" "john doe"
# Output: John,Doe|2023-05-15|___Report.pdf|true|true
```

### Date Format Support
- **ISO**: `2023-01-15`, `20230115`
- **US**: `01-15-2023`, `01152023`
- **European**: `15-01-2023`, `15012023`
- **Written**: `25-Dec-2023`, `1st-jan-2024`

## Filename Formatting

### Template System
The system uses configurable templates for final filename generation:

**Available Placeholders:**
- `{id}`: User ID from mapping
- `{name}`: Extracted person name
- `{date}`: Extracted date (ISO format)
- `{remainder}`: Remaining filename parts
- `{category}`: Category code (future feature)
- `{management_flag}`: Management flag if detected

**Example Templates:**
```yaml
# Basic format
template: "{id}_{name}_{remainder}_{date}"

# With management flag
template: "{id}_{name}_{remainder}_{date}_{management_flag}"

# Category-based format
template: "{id}_{name}_{category}_{remainder}_{date}"
```

### Empty Component Handling
- **Skip Empty**: Empty components can be skipped to avoid unnecessary separators
- **Cleanup**: Multiple consecutive separators are cleaned up automatically
- **Preservation**: Meaningful separators within filenames are preserved

## Configuration Management

### YAML-Driven Configuration
All extraction logic is driven by `config/components.yaml` for consistency and extensibility:

```yaml
Name:
  allowed_separators_when_searching:
    - " "  # space
    - "-"  # hyphen
    - "_"  # underscore
    - "."  # period
    - "*"  # asterisk
    - "@"  # at sign
    - "#"  # hash
  allowed_separators:
    - " "  # space

Remainder:
  allowed_separators:
    - " "  # space
    - "-"  # hyphen
    - "."  # period
```

### Extensibility
- **Add Separators**: Simply add new separators to the YAML configuration
- **Change Precedence**: Reorder separators to change cleaning preferences
- **No Code Changes**: All logic adapts automatically to configuration changes

## Testing and Validation

### Test Coverage
The name extraction algorithms are thoroughly tested with:
- **174 total tests** covering all extraction scenarios
- **Edge case coverage** for unusual filename patterns
- **Separator combination testing** for complex scenarios
- **Fuzzy matching validation** for character substitutions

### Test Generation
Tests are automatically generated from CSV matrices to ensure comprehensive coverage:
- **Name extraction tests**: 98 test cases
- **Date extraction tests**: 16 test cases
- **Combined extraction tests**: 30 test cases
- **Integration tests**: 30 test cases

## Best Practices

### For Configuration
1. **Order separators by preference** in the YAML configuration
2. **Test configuration changes** with a small set of files first
3. **Document custom separators** for team consistency
4. **Use meaningful separator names** in configuration comments

### For Filename Processing
1. **Always use dry-run mode** to preview changes
2. **Test with representative filenames** before bulk processing
3. **Verify CSV mappings** are correct and complete
4. **Monitor extraction results** for unexpected matches

### For Template Design
1. **Keep templates simple** and readable
2. **Use consistent separators** throughout the template
3. **Consider filename length** limitations
4. **Test template changes** with various input files

---

**Note:** To change or add valid separators, update `config/components.yaml`. All filename parsing and matching logic is driven by this configuration for consistency and extensibility. 