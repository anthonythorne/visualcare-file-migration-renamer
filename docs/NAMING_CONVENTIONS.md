# File Naming Conventions

This document outlines the naming conventions and matching logic used for extracting client/staff names from filenames in the VisualCare file migration system.

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

### Matcher Functions
The system supports several matcher types, each with its own logic:
- **first_name**: Extracts the first name from the filename.
- **last_name**: Extracts the last name from the filename.
- **initials**: Matches both initials (e.g., `j-d`, `j.d`, `j d`, `jd`, etc.) with one or more valid separators or grouped.
- **shorthand**: Matches first initial + last name (e.g., `j-doe`, `jdoe`, `j.doe`) or first name + last initial (e.g., `john-d`, `john.d`).
- **all_matches**: Extracts all possible matches using the processing order described above.

### Separator Handling
- **Source of Truth**: All valid separators are defined in `config/separators.yaml`.
- **Extensible**: To add or change separators, update the YAML file—no code changes needed.
- **Supported Separators** (by default):
  - Hyphen (`-`)
  - Underscore (`_`)
  - Period (`.`)
  - Space (` `)
  - (Others as defined in YAML)
- **Multiple/Mixed Separators**: Any number or combination of valid separators between name parts or initials is supported (e.g., `j - _ d`, `john---doe`, `j._d`).

### Case Sensitivity
- **Matching**: Always case-insensitive.
- **Extraction**: The extracted name part preserves the case as it appears in the filename.

### Raw vs Cleaned Remainder
- **Raw Remainder**: The literal filename with the matched part removed (may contain extra separators or spaces).
- **Cleaned Remainder**: The raw remainder, normalized by collapsing multiple separators and trimming leading/trailing separators, as defined by the cleaning logic.

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
When cleaning the remainder, the system uses separator precedence from `config/separators.yaml`:

- **Order matters**: Separators listed first in the YAML are preferred
- **Reverse removal**: When multiple separators are grouped together, remove them in reverse order of the YAML list
- **Keep preferred**: Always keep one instance of the most preferred separator

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

### First Name Matching
- Matches the first name anywhere in the filename, using all valid separators.
- Examples for "John Doe":
  - `john-doe-report.pdf` → Extracts `john`
  - `John Doe 20240525 report.pdf` → Extracts `John`

### Last Name Matching
- Matches the last name anywhere in the filename, using all valid separators.
- Examples for "John Doe":
  - `john-doe-report.pdf` → Extracts `doe`
  - `John Doe 20240525 report.pdf` → Extracts `Doe`

### Initials Matching
- Matches both initials, grouped or separated by any valid separator(s).
- Examples for "John Doe":
  - `jd-report.pdf`, `j-d-report.pdf`, `j.d.report.pdf`, `j d report.pdf`, `j---d-report.pdf`, `j - _ d report.pdf` → All valid

### Shorthand Matching
- Matches first initial + last name or first name + last initial, with any valid separator(s).
- Examples for "John Doe":
  - `j-doe-report.pdf`, `jdoe-report.pdf`, `j.doe-report.pdf`, `john-d-report.pdf`, `john.d.report.pdf`, `john_d_report.pdf`

### All Matches (New Algorithm)
- Extracts all possible matches using the processing order: shorthand → first names → last names
- Examples for "John Doe":
  - `john-doe-jdoe-report.pdf` → Extracts `jdoe,john,doe` (shorthand first, then individual names)
  - `jdoe-john-doe-report.pdf` → Extracts `jdoe,john,doe` (shorthand first, then individual names)
  - `john-doe-john-doe-report.pdf` → Extracts `john,doe,john,doe` (all individual names in order)

### Special Characters & Substitutions
- Special characters and common substitutions (e.g., `0` for `o`) are supported in fuzzy matching.
- Examples for "Jón Döe":
  - `jón-döe-report.pdf` ✓
  - `j0hn-d03-report.pdf` ✓

### Multiple Matches
- All valid matches are extracted and reported in the order they appear in the filename.
- Example:
  - `john-doe-john-doe-report.pdf` → Extracts `john,doe,john,doe`

---

**Note:**
- To change or add valid separators, update `config/separators.yaml`.
- All filename parsing and matching logic is driven by this config for consistency and extensibility.

john*doe-report.pdf|john doe|true|john,doe|*-report.pdf|-report.pdf|all_matches|Non-standard separator (asterisk)
john@doe-report.pdf|john doe|true|john,doe|@-report.pdf|@-report.pdf|all_matches|Non-standard separator (at sign)
john#doe-report.pdf|john doe|true|john,doe|#-report.pdf|#-report.pdf|all_matches|Non-standard separator (hash)
jdoe-john-doe-report.pdf|john doe|true|jdoe,john,doe|---report.pdf|report.pdf|all_matches|Multiple matches (initials and full) 