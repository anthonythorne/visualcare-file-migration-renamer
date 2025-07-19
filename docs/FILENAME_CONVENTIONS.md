 # Filename Conventions

This document describes the conventions and logic for extracting and cleaning names from filenames in the VisualCare file migration system.

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

## Separator Logic (YAML-Driven)
- All valid separators and their order of preference are defined in `config/components.yaml`.
- The order in the YAML determines which separator is preferred when cleaning runs of consecutive separators.
- To add or change separators, update the YAML—no code changes needed.

## Matcher Types
- **first_name**: Extracts the first name from the filename.
- **last_name**: Extracts the last name from the filename.
- **initials**: Matches both initials (e.g., `j-d`, `j.d`, `j d`, `jd`, etc.) with one or more valid separators or grouped.
- **shorthand**: Matches first initial + last name (e.g., `j-doe`, `jdoe`, `j.doe`) or first name + last initial (e.g., `john-d`, `john.d`).
- **all_matches**: Extracts all possible matches using the processing order described above.

## Cleaning Logic
- When cleaning, for any run of consecutive separators, the most preferred (earliest in the YAML list) is kept and all others are removed.
- Leading and trailing separators are removed, starting with the least preferred.
- The cleaning logic is implemented in Python and always uses the YAML config at runtime.

## Case Handling
- Matching is always case-insensitive.
- Extracted names preserve the case as it appears in the filename.

## Name Extraction and Matching Rules

### Processing Algorithm Example
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

### Separator Cleaning Logic
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

### Delimiting and Separator Rules
- **All matcher types** require the match to be delimited by a valid separator (from YAML) or be at the start/end of the filename.
- **First Name / Last Name:**
  - Only match if the name is delimited by a separator or at the start/end of the filename.
- **Initials / Shorthand:**
  - The entire match (e.g., jdoe, j-doe, j---doe, j-d) must be delimited by a separator or filename boundary.
  - Any number and combination of valid separators are allowed between initials or between initial and name part (e.g., j---doe, j.doe, j_doe, j - _ d).
  - No match if the pattern is embedded within other characters (e.g., xjdoey).

### Examples
- `-jdoe-`, `jdoe-`, `-jdoe` (shorthand, delimited): valid
- `-j---doe-`, `j.doe-`, `j_doe-` (shorthand, multiple/mixed separators): valid
- `-j-d-`, `j-d-`, `-j-d` (initials, delimited): valid
- `-j---d-`, `j_d-`, `j--.--d-` (initials, multiple/mixed separators): valid
- `xjdoey`, `foo-jdoe-bar` (not delimited): not valid

## Examples

### Separator Order Example
If the YAML lists:
```yaml
standard:
  - " "  # space (most preferred)
  - "-"  # hyphen
  - "_"  # underscore
  - "."  # period (least preferred)
```

Then for the filename: `File j_- d_report.pdf`
- The match and removal of `j_- d` leaves: `File _report.pdf`
- Cleaning removes `_` (less preferred than space): `File report.pdf`

### Matcher Examples
- `john-doe-report.pdf` (first_name): Extracts `john`
- `j-d-report.pdf` (initials): Extracts `j-d`
- `jdoe-report.pdf` (shorthand): Extracts `jdoe`
- `john-doe-jdoe-report.pdf` (all_matches): Extracts `jdoe,john,doe` (shorthand first, then individual names)

---

- To change or add valid separators, update `config/components.yaml`. All logic is YAML-driven for consistency and extensibility.** 