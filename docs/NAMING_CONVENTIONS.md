# File Naming Conventions

This document outlines the naming conventions used for matching files to client/staff names in the VisualCare file migration system.

## Name Matching Rules

### Full Name Matching
- Matches exact permutations of names from the config file
- Additional words in the filename don't affect the match
- Names can be found anywhere in the filename
- Examples for "John Doe":
  - `john-doe-report.pdf` ✓
  - `john_doe_smith_20230101.pdf` ✓
  - `john_doe_sarah_smith_report.pdf` ✓
  - `home-john_doe_sarah_smith_report.pdf` ✓
  - `home John Doe sarah smith report.pdf` ✓
  - `jane-smith-report.pdf` ✗ (different name)

### Initial Matching
- First name initial must have separators or beginning/end of file on both sides to be considered an initial
- Last name must be complete
- Initials at the start of filename don't need separators on both sides
- Examples for "John Doe":
  - `j-doe-report.pdf` ✓ (j has separators)
  - `jdoe-report.pdf` ✓ (j at start, no other words between)
  - `j.doe-report.pdf` ✓ (j has separators)
  - `john-d-report.pdf` ✓ (d has separators)
  - `abcd-j-fer-doe-adasd.pdf` ✓ (j has separators, matches "j,doe")
  - `abc-jdoe-def-text.pdf` ✓ (j has separators on both sides)
  - `abc-johnD-def-text.pdf` ✓ (D has separators on both sides)

### Combined Initial Matching
- Must be grouped together OR have known separators between them
- No other words allowed between initials
- Examples for "John Doe":
  - `jd-report.pdf` ✓ (grouped)
  - `j-d-report.pdf` ✓ (separated)
  - `j.d.report.pdf` ✓ (separated)
  - `home.j.d.report.pdf` ✓ (separated)
  - `j---d-report.pdf` ✓ (separated)
  - `abcdj---d-report.pdf` ✗ (j doesn't have separator on both sides)

## Separators
Valid separators include:
- Hyphen (`-`)
- Underscore (`_`)
- Period (`.`)
- Space (` `)

Multiple consecutive separators are treated as a single separator:
- `john___doe___report.pdf` → `john_doe_report.pdf`
- `john---doe---report.pdf` → `john-doe-report.pdf`
- `john...doe...report.pdf` → `john.doe.report.pdf`

## Case Sensitivity
- Matching is case-insensitive
- Examples for "John Doe":
  - `JOHN-DOE-report.pdf` ✓
  - `John-Doe-report.pdf` ✓
  - `john-doe-report.pdf` ✓

## Special Characters
- Special characters in names are preserved
- Examples for "Jón Döe":
  - `jón-döe-report.pdf` ✓
  - `j0hn-d03-report.pdf` ✓ (number substitutions)
  - `jón-d03-report.pdf` ✓ (mixed accents and numbers)

## Multiple Matches
- Files can contain multiple name matches
- All matches are extracted and reported
- Examples for "John Doe":
  - `john-doe-john-doe-report.pdf` ✓ (matches twice)
  - `john-doe-jdoe-report.pdf` ✓ (full name and initials)
  - `jdoe-john-doe-report.pdf` ✓ (initials and full name)
  - `john_doe_smith_jones_20230101.pdf` ✓ (full name match with additional words) 