# File Normalization Process

## Overview
The file normalization process follows a **sequential extraction approach** where each component (category, name, date) is extracted and removed from the path string, building up the normalized filename step by step.

## Core Principles

### 1. String-Based Processing
- All paths and components are handled as **strings**, not arrays
- Each extraction function returns the **remainder string** after removing its component
- This allows for clean sequential processing without array manipulation

### 2. Sequential Extraction Order
1. **Category Extraction** (first priority)
2. **Name Extraction** (second priority) 
3. **Date Extraction** (third priority)

### 3. Component Isolation
- Each extraction function isolates its component and puts it aside
- The remainder string is passed to the next extraction function
- No component interferes with another's extraction

## Process Flow

### Step 1: Category Extraction
```
Input: "John Doe/Emergency Contacts/2024/Emergency Contacts Updated Contacts/contact_list.pdf"

1. Check first directory after person: "Emergency Contacts"
2. If exact match found:
   - Extract category: "Emergency Contacts"
   - Remove from path: "John Doe/2024/Emergency Contacts Updated Contacts/contact_list.pdf"
   - Put aside for {category} component (ID or name based on config)
3. If no match:
   - Leave path unchanged
   - No category component

Output: remainder_string, category_component
```

### Step 2: Name Extraction
```
Input: remainder_string from Step 1

1. Extract person name from first directory: "John Doe"
2. Remove person name from path (always)
3. Check user mapping for match:
   - If matched: put aside user_id for {user_id} component
   - If not matched: no user_id component
4. Remove all name matches from folders and filename

Output: remainder_string, name_component, user_id_component
```

### Step 3: Date Extraction
```
Input: remainder_string from Step 2

1. Search for dates in filename, then foldername, then modified/created dates
2. Extract first valid date found
3. Remove date from remainder
4. Put aside for {date} component

Output: remainder_string, date_component
```

### Step 4: Final Assembly
```
Input: All extracted components + final remainder

1. Clean the final remainder string
2. Assemble normalized filename:
   {user_id}_{name}_{remainder}_{date}_{category}.{extension}

Example: "1001_John Doe_Updated Contacts contact list_2024-01-15_Emergency Contacts.pdf"
```

## Example Walkthrough

### Input Path
```
"John Doe/Emergency Contacts/2024/Emergency Contacts Updated Contacts/contact_list.pdf"
```

### Step 1: Category Extraction
- Check: "Emergency Contacts" (first directory)
- Match: ✅ Exact match found
- Extract: category = "Emergency Contacts"
- Remainder: "John Doe/2024/Emergency Contacts Updated Contacts/contact_list.pdf"

### Step 2: Name Extraction  
- Extract: name = "John Doe"
- User mapping: ✅ Found user_id = "1001"
- Remove name from path: "2024/Emergency Contacts Updated Contacts/contact_list.pdf"
- Remove name matches from remainder: "2024/Updated Contacts/contact_list.pdf"

### Step 3: Date Extraction
- Search: filename → foldername → metadata
- Extract: date = "2024-01-15" (from foldername "2024")
- Remainder: "Updated Contacts/contact_list.pdf"

### Step 4: Final Assembly
- Clean remainder: "Updated Contacts contact list"
- Assemble: "1001_John Doe_Updated Contacts contact list_2024-01-15_Emergency Contacts.pdf"

## Benefits of String-Based Approach

### 1. Clean Sequential Processing
- Each function receives a string, processes it, returns a string
- No complex array manipulation or path reconstruction
- Easy to debug and trace the transformation

### 2. Component Isolation
- Category extraction doesn't interfere with name extraction
- Name extraction doesn't interfere with date extraction
- Each component is extracted independently

### 3. Flexible Remainder Handling
- Remainder can contain any combination of folders and filenames
- No assumptions about directory structure
- Handles edge cases naturally

### 4. Easy Integration
- Each extraction function can be tested independently
- Main function simply chains the extractions
- Clear separation of concerns

## Configuration Integration

### Category Component
- `use_id_in_output: true` → Use category ID
- `use_id_in_output: false` → Use category name

### User Component  
- `create_if_missing: true` → Create user ID if not found
- `create_if_missing: false` → Skip user ID if not found

### Date Component
- `date_priority_order: ["filename", "foldername", "modified", "created"]`
- Determines search order for date extraction

## Error Handling

### Missing Components
- If category not found: no category component in filename
- If name not found: no name component in filename  
- If date not found: no date component in filename
- If user not mapped: no user_id component in filename

### Invalid Paths
- Paths with insufficient depth: handled gracefully
- Empty components: skipped in final assembly
- Special characters: cleaned by global cleaner functions 

## Name Extraction Rules for Three-Part Names

The system uses a configurable extraction order defined in `config/components.yaml`:

```yaml
Name:
  extraction_order:
    - shorthand
    - initials
    - first_name
    - middle_name
    - last_name
```

### Three-Part Name Handling
- If a name has three parts (e.g., "Kim Maree Thorne"):
  - The **second part is always treated as a middle name** ("Maree").
  - **Shorthand matching is skipped** (e.g., "Kim T" will NOT match "Kim Maree Thorne").
  - **Initials** are allowed (e.g., "K M T").
  - **First name** ("Kim"), **middle name** ("Maree"), and **last name** ("Thorne") can all be matched individually.
  - **Full name matching is NOT allowed** ("Kim Maree Thorne" as a single unit is not matched).
  - For hyphenated names, treat as a single name part as usual.

### Two-Part Name Handling
- If a name has two parts (e.g., "John Doe"):
  - Shorthand matching is allowed (e.g., "J Doe").
  - Initials, first, and last name matching are allowed.

### Multi-Part Name Handling
- If a name has more than three parts, only the first, last, and middle (second) are considered for extraction.

These rules ensure that ambiguous cases (e.g., compound first names vs. middle names) are handled consistently and avoid false positives from shorthand matching in three-part names. 