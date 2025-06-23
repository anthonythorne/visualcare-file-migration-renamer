 # Filename Conventions

This document describes the conventions and logic for extracting and cleaning names from filenames in the VisualCare file migration system.

## Separator Logic (YAML-Driven)
- All valid separators and their order of preference are defined in `config/separators.yaml`.
- The order in the YAML determines which separator is preferred when cleaning runs of consecutive separators.
- To add or change separators, update the YAML—no code changes needed.

## Matcher Types
- **first_name**: Extracts the first name from the filename.
- **last_name**: Extracts the last name from the filename.
- **initials**: Matches both initials (e.g., `j-d`, `j.d`, `j d`, `jd`, etc.) with one or more valid separators or grouped.
- **shorthand**: Matches first initial + last name (e.g., `j-doe`, `jdoe`, `j.doe`) or first name + last initial (e.g., `john-d`, `john.d`).
- **all_matches**: Extracts all possible matches (full names, initials, shorthands, etc.) in order of precedence.

## Cleaning Logic
- When cleaning, for any run of consecutive separators, the most preferred (earliest in the YAML list) is kept and all others are removed.
- Leading and trailing separators are removed, starting with the least preferred.
- The cleaning logic is implemented in Python and always uses the YAML config at runtime.

## Case Handling
- Matching is always case-insensitive.
- Extracted names preserve the case as it appears in the filename.

## Examples

### Separator Order Example
If the YAML lists:
```
standard:
  - " "  # space
  - "-"  # hyphen
  - "_"  # underscore
  - "."  # period
```
Then for the filename: `File j_- d_report.pdf`
- The match and removal of `j_- d` leaves: `File _report.pdf`
- Cleaning removes `_` (less preferred than space): `File report.pdf`

### Matcher Examples
- `john-doe-report.pdf` (first_name): Extracts `john`
- `j-d-report.pdf` (initials): Extracts `j-d`
- `jdoe-report.pdf` (shorthand): Extracts `jdoe`
- `john-doe-jdoe-report.pdf` (all_matches): Extracts `john`, `doe`, `jdoe`

---

**To change or add valid separators, update `config/separators.yaml`. All logic is YAML-driven for consistency and extensibility.** 