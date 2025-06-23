# File Naming Conventions

This document outlines the naming conventions and matching logic used for extracting client/staff names from filenames in the VisualCare file migration system.

## Name Matching Logic

### Matcher Functions
The system supports several matcher types, each with its own logic:
- **first_name**: Extracts the first name from the filename.
- **last_name**: Extracts the last name from the filename.
- **initials**: Matches both initials (e.g., `j-d`, `j.d`, `j d`, `jd`, etc.) with one or more valid separators or grouped.
- **shorthand**: Matches first initial + last name (e.g., `j-doe`, `jdoe`, `j.doe`) or first name + last initial (e.g., `john-d`, `john.d`).
- **all_matches**: Extracts all possible matches (full names, initials, shorthands, etc.) in order of precedence.

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

### All Matches
- Extracts all possible matches (full names, initials, shorthands, etc.) in order of precedence.
- Examples for "John Doe":
  - `john-doe-jdoe-report.pdf` → Extracts `john`, `doe`, `jdoe`
  - `john-doe-john-doe-report.pdf` → Extracts `john`, `doe`, `john`, `doe`

### Special Characters & Substitutions
- Special characters and common substitutions (e.g., `0` for `o`) are supported in fuzzy matching.
- Examples for "Jón Döe":
  - `jón-döe-report.pdf` ✓
  - `j0hn-d03-report.pdf` ✓

### Multiple Matches
- All valid matches are extracted and reported in order.
- Example:
  - `john-doe-john-doe-report.pdf` → Extracts `john`, `doe`, `john`, `doe`

---

**Note:**
- To change or add valid separators, update `config/separators.yaml`.
- All filename parsing and matching logic is driven by this config for consistency and extensibility. 