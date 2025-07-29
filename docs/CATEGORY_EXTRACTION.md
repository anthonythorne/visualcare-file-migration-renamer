# Category Extraction Requirements

## Overview
Category extraction is responsible for identifying and extracting category information from file paths. It operates on the **first directory level after the person's name** and uses a two-step matching process.

## Core Principles

### 1. Single Responsibility
- **ONLY** extracts category information
- **NEVER** touches the person's name (handled by user mapping)
- **NEVER** performs name extraction or removal

### 2. Two-Step Matching Process
- **Step 1**: Exact match of the first directory after the person's name
- **Step 2**: If first directory matches, process remainder for partial matches

### 3. Strict First Directory Matching
- Only the first directory after the person's name is considered for category matching
- Must match a category name **exactly** (after normalization)
- No partial matches allowed in the first directory

## Examples

### ✅ Valid Category Matches (First Directory Exact Match)
```
John Doe/Emergency Contacts/2024/Emergency Contacts Updated Contacts/contact_list.pdf
→ First Directory: "Emergency Contacts" (exact match)
→ Category: "Emergency Contacts"
→ Remainder: "2024/Emergency Contacts Updated Contacts/contact_list.pdf"
→ After cleaning: "2024 Updated Contacts contact list.pdf"

John Doe/WHS/2023/Incidents/file.pdf  
→ First Directory: "WHS" (exact match)
→ Category: "WHS"
→ Remainder: "2023/Incidents/file.pdf"
→ After cleaning: "2023 Incidents file.pdf"
```

### ❌ Invalid Category Matches (First Directory Not Exact)
```
John Doe/Emergency Contacts 2023/contact_list.pdf
→ First Directory: "Emergency Contacts 2023" ≠ "Emergency Contacts" (no match)
→ Remainder: "John Doe/Emergency Contacts 2023/contact_list.pdf" (unchanged)

John Doe/Medical Records Backup/file.pdf
→ First Directory: "Medical Records Backup" ≠ "Medical Records" (no match)
→ Remainder: "John Doe/Medical Records Backup/file.pdf" (unchanged)
```

## Function Behavior

### When First Directory Matches Exactly:
1. Extract the category name
2. Remove the category directory from the path
3. Process the remainder for partial matches and cleaning
4. Return the cleaned remainder

### When First Directory Does NOT Match:
1. Return the entire path unchanged
2. No category extraction performed
3. No path modification

## Two-Step Process Details

### Step 1: First Directory Check
- Input: `PersonName/CategoryDirectory/...rest of path...`
- Check: `CategoryDirectory` against category mapping
- **Exact match only** - no partial matches allowed

### Step 2: Remainder Processing (Only if Step 1 Matches)
- Remove the matched category directory
- Process remaining path for partial matches and cleaning
- This allows partial matches in subdirectories and filenames

## Output Format
```
extracted_category|raw_category|cleaned_category|raw_remainder|cleaned_remainder|error_status
```

Where:
- `extracted_category`: The matched category name (or empty if no match)
- `raw_category`: The original directory name that was checked
- `cleaned_category`: The normalized category name
- `raw_remainder`: The path remainder after category removal (or full path if no match)
- `cleaned_remainder`: The cleaned version of the remainder (with partial matches processed)
- `error_status`: Status indicator ("unmapped", "no_category", or empty for success)

## Integration with Other Functions
- **User Mapping**: Handles person name extraction and removal
- **Date Extraction**: Handles date extraction from remainder
- **Main Function**: Coordinates all extractions and combines results

## Configuration
- Category matching is case-insensitive by default
- Category names are normalized (spaces, hyphens, underscores normalized)
- Mapping file defines valid categories and their IDs 