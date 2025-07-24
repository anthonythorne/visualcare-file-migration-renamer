# VisualCare File Migration Renamer - Usage Guide

This comprehensive guide covers how to use the VisualCare File Migration Renamer tool for real-world file migration scenarios.

## Quick Start

### Basic Usage
```bash
# Test mode (recommended for testing)
python3 main.py --test-mode --test-name my-test

# Process CSV mapping
python3 main.py --csv mapping.csv

# Process directory with name mapping
python3 main.py --input-dir /path/to/input --output-dir /path/to/output --name-mapping names.csv
```

## Command Line Options

### Core Options
- `--csv <file>`: Process files using a CSV mapping file
- `--input-dir <path>`: Input directory containing files to process
- `--output-dir <path>`: Output directory for processed files
- `--test-mode`: Use the built-in test files structure (`tests/test-files`)
- `--dry-run`: Preview changes without making them (recommended)
- `--verbose, -v`: Enable detailed logging

### Test Mode Options
- `--test-name <name>`: Name for the test (creates `to-<name>` output directory)
- `--person <name>`: Filter to specific person only

### Configuration Options
- `--config <file>`: Path to configuration file (default: `config/components.yaml`)
- `--name-mapping <file>`: CSV file with filename to name mappings (for directory processing)

## Usage Scenarios

### 1. Test Mode (Recommended for Testing)

Test mode uses the built-in `tests/test-files` structure for safe testing:

```bash
# Basic test with all files
python3 main.py --test-mode --test-name basic

# Test with specific person
python3 main.py --test-mode --test-name person-test --person "John Doe"

# Test with verbose output
python3 main.py --test-mode --test-name debug --verbose

# Actual processing (not dry-run)
python3 main.py --test-mode --test-name production
```

**Test Files Structure:**
```
tests/test-files/
├── from/                    # Original files (input)
│   ├── John Doe/           # Person-specific directories
│   ├── Jane Smith/
│   └── Bob Johnson/
├── to-basic/               # Output for basic test
├── to-userid/              # Output for user ID test
└── to-<test-name>/         # Custom test output directories
```

### 2. CSV Mapping Processing

Process files using a CSV file that maps old filenames to new filenames:

```bash
# Preview changes
python3 main.py --csv mapping.csv

# Apply changes
python3 main.py --csv mapping.csv

# With verbose output
python3 main.py --csv mapping.csv --verbose
```

**CSV Format:**
```csv
filename,name_to_match,new_filename
old_file.pdf,John Doe,new_file.pdf
another_file.docx,Jane Smith,renamed_file.docx
```

### 3. Directory Processing

Process all files in a directory using a name mapping file:

```bash
# Preview changes
python3 main.py --input-dir /path/to/input --output-dir /path/to/output --name-mapping names.csv

# Apply changes
python3 main.py --input-dir /path/to/input --output-dir /path/to/output --name-mapping names.csv
```

**Name Mapping CSV Format:**
```csv
filename,name_to_match
file1.pdf,John Doe
file2.docx,Jane Smith
```

## Configuration

### Main Configuration File (`config/components.yaml`)

The system uses a comprehensive YAML configuration file for all settings:

```yaml
# Name extraction settings
Name:
  allowed_separators_when_searching:
    - " "  # space
    - "-"  # hyphen
    - "_"  # underscore
    - "."  # period

# Date extraction settings
Date:
  formats:
    - "%Y-%m-%d"  # ISO format
    - "%Y%m%d"    # Compact format
    - "%m-%d-%Y"  # US format

# Filename format configuration
FilenameFormat:
  template: "{id}_{name}_{remainder}_{date}"
  component_separator: "_"
  skip_empty_components: true
  cleanup_separators: true

# User ID mapping
UserMapping:
  mapping_file: "config/user_mapping.csv"
  id_column: "user_id"
  name_column: "full_name"
  create_if_missing: true
  missing_id_behavior: "error"

# Category support (future-ready)
Category:
  enabled: false
  default_category: "general"
  folder_mapping:
    "Hazard & Risk Reports": "hazard"
    "Management": "management"

# Management flag detection
ManagementFlag:
  enabled: true
  keywords:
    - "management"
    - "admin"
    - "supervisor"
  flag: "MGMT"
  placement: "suffix"
```

### User ID Mapping (`config/user_mapping.csv`)

Map user IDs to full names for consistent filename generation:

```csv
user_id,full_name
1001,John Doe
1002,Jane Smith
1003,Bob Johnson
1001,John Doe
1005,Michael Brown
```

## Filename Format Templates

The system supports configurable filename formats using placeholders:

### Available Placeholders
- `{id}`: User ID from mapping
- `{name}`: Extracted person name
- `{date}`: Extracted date (ISO format)
- `{remainder}`: Remaining filename parts
- `{category}`: Category code (future feature)
- `{management_flag}`: Management flag if detected

### Example Templates
```yaml
# Basic format
template: "{id}_{name}_{remainder}_{date}"

# With management flag
template: "{id}_{name}_{remainder}_{date}_{management_flag}"

# Category-based format
template: "{id}_{name}_{category}_{remainder}_{date}"
```

### Example Transformations

**Input:** `F016 John Support Plan 16.04.23 - v5.0.docx`
- Client ID: 1001
- Client Name: John Doe
- Date: 16.04.23 → 2023-04-16
- **Output:** `1001_John Doe_F016JohnSupportPlanV5.0_2023-04-16.docx`

**Input:** `Hazard Report - Crates under legs of lounge - John Doe.pdf`
- Client ID: 1001
- Client Name: John Doe
- Date: From file metadata → 2023-05-12
- **Output:** `1001_John Doe_HazardReportCratesUnderLegsofLounge_2023-05-12.pdf`

## Advanced Features

### Person Filtering

Filter processing to specific people only:

```bash
# Process only John Doe's files
python3 main.py --test-mode --test-name john-only --person "John Doe"

# Case-insensitive filtering
python3 main.py --test-mode --test-name jane-only --person "jane smith"
```

### Management Flag Detection

The system automatically detects management-related files:

```bash
# Files containing "management", "admin", or "supervisor" get flagged
python3 main.py --test-mode --test-name management
```

### Verbose Logging

Get detailed information about the processing:

```bash
python3 main.py --test-mode --test-name debug --verbose
```

**Verbose Output Example:**
```
Processing test files using tests/test-files structure
Test name: debug
2025-07-19 10:20:53,847 - INFO - Processing person: Jane Smith
2025-07-19 10:20:53,880 - INFO - DRY RUN - Would copy: Jane Smith/file1.pdf -> debug/Jane Smith/1002_jane smith_file1_2023-11-30.pdf
```

## Error Handling

### Common Issues and Solutions

**1. "Test files directory not found"**
```bash
# Ensure the test files structure exists
ls -la tests/test-files/from/
```

**2. "User ID not found in mapping"**
```bash
# Check the user mapping file
cat config/user_mapping.csv
```

**3. "Configuration file not found"**
```bash
# Ensure config file exists
ls -la config/components.yaml
```

### Error Recovery

The system provides detailed error reporting:

```bash
# Check for errors in dry-run mode
python3 main.py --test-mode --test-name error-check

# Review error summary
=== Processing Summary ===
Total files: 10
Successful: 8
Errors: 2

=== Errors ===
- Failed to extract components from invalid_file.txt
- User ID not found in mapping: 9999
```

## Best Practices

### 1. Always Use Dry-Run First
```bash
# Always preview changes before applying
python3 main.py --csv mapping.csv
```

### 2. Use Test Mode for Development
```bash
# Test with built-in files first
python3 main.py --test-mode --test-name development
```

### 3. Backup Original Files
```bash
# Create backup before processing
cp -r /path/to/input /path/to/backup
```

### 4. Use Verbose Logging for Debugging
```bash
# Get detailed processing information
python3 main.py --test-mode --test-name debug --verbose
```

### 5. Test with Small Batches
```bash
# Test with specific person first
python3 main.py --test-mode --test-name small-batch --person "John Doe"
```

## Integration Examples

### Batch Processing Script
```bash
#!/bin/bash
# Process multiple test scenarios

echo "Running basic test..."
python3 main.py --test-mode --test-name basic

echo "Running user ID test..."
python3 main.py --test-mode --test-name userid

echo "Running management test..."
python3 main.py --test-mode --test-name management

echo "All tests completed!"
```

### Production Processing
```bash
#!/bin/bash
# Production file processing

# Backup original files
cp -r /path/to/input /path/to/backup/$(date +%Y%m%d_%H%M%S)

# Process with verbose logging
python3 main.py --input-dir /path/to/input --output-dir /path/to/output --name-mapping names.csv --verbose

echo "Processing completed!"
```

## Troubleshooting

### Check System Status
```bash
# Verify all tests pass
./tests/run_tests.sh

# Check configuration
python3 main.py --test-mode --test-name config-check

# Verify file structure
tree tests/test-files/
```

### Common Commands
```bash
# Run all tests
./tests/run_tests.sh

# Check specific test
bats tests/unit/test_mode_integration_test.bats

# Regenerate test files
python3 tests/scripts/generate_bats_tests.py combined
```

For more detailed information, see:
- [Testing Guide](TESTING.md)
- [Naming Conventions](NAMING_CONVENTIONS.md)
- [Filename Conventions](FILENAME_CONVENTIONS.md) 

## File Date Handling and Extraction

- **Testing:**
  - Test files are created with modification and access times set to the matrix date (usually midnight).
  - The tool preserves these times when moving or duplicating files to the output directory.

- **Real Usage:**
  - The tool preserves the original file's modification and access times on the output file, whether moved or duplicated (using the `--duplicate` flag).
  - Date extraction logic uses these times as per the configured priority in `components.yaml`.

- **Date Extraction Priority:**
  - You can configure the tool to extract the date from filename, foldername, modification time, or creation time (if supported by your OS/filesystem).
  - If `created` is included in the priority order, the tool will attempt to use the file's creation/birth time. Note: On some filesystems (especially Linux/WSL2), creation time may not be settable or available.

- **Consistency:**
  - This approach ensures that both test and real runs are consistent and reliable. 

## Known Pitfalls and Limitations

- **Modification Time:**
  - Only modification time (`mtime`) is reliably preserved and settable by the tool.
- **Creation Time:**
  - Creation time (`birth time`) is not reliably available or settable on all filesystems/OSes.
  - When moving within the same filesystem, the OS preserves creation time; when moving across filesystems or duplicating, creation time is reset and cannot be set by the tool.
  - Do not rely on creation time for critical logic.
- **Date Extraction:**
  - The tool can extract from creation time if configured and available, but will fall back to modification time if not.
- **Best Practice:**
  - Always rely on modification time for date-based processing, as it is universally supported and preserved by the tool. 