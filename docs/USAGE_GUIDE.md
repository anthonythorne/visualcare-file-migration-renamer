# VisualCare File Migration Renamer - Usage Guide

This comprehensive guide covers how to use the VisualCare File Migration Renamer tool for real-world file migration scenarios.

## Quick Start

### Basic Usage
```bash
# Process directory with optional mapping files
python3 main.py --input-dir /path/to/input --output-dir /path/to/output

# With user mapping file
python3 main.py --input-dir /path/to/input --output-dir /path/to/output --user-mapping users.csv

# With both user and category mapping files
python3 main.py --input-dir /path/to/input --output-dir /path/to/output --user-mapping users.csv --category-mapping categories.csv

# Test mode (for testing with built-in files)
python3 main.py --test-mode --test-name my-test
```

## Command Line Options

### Core Options (Required for Directory Processing)
- `--input-dir <path>`: Input directory containing files to process
- `--output-dir <path>`: Output directory for processed files

### Optional Mapping Files
- `--user-mapping <file>`: CSV file with user ID to name mappings (optional)
- `--category-mapping <file>`: CSV file with category mappings (optional)

### Processing Options
- `--duplicate`: Copy files instead of moving them (default: move/rename)
- `--dry-run`: Preview changes without making them (recommended for testing)
- `--verbose, -v`: Enable detailed logging

### Test Mode Options
- `--test-mode`: Use the built-in test files structure (`tests/test-files`)
- `--test-name <name>`: Name for the test (creates `to-<name>` output directory)
- `--person-filter <name>`: Filter to specific person only

## Usage Scenarios

### 1. Directory Processing (Primary Use Case)

The main purpose of this tool is to process all files in an input directory, normalize their names using the global configuration, and move or copy them to an output directory.

#### Basic Directory Processing
```bash
# Process all files in input directory to output directory
python3 main.py --input-dir /path/to/input --output-dir /path/to/output

# Preview changes first (recommended)
python3 main.py --input-dir /path/to/input --output-dir /path/to/output --dry-run

# Copy files instead of moving them
python3 main.py --input-dir /path/to/input --output-dir /path/to/output --duplicate
```

#### With User Mapping
```bash
# Process with user ID mapping
python3 main.py --input-dir /path/to/input --output-dir /path/to/output --user-mapping users.csv

# Preview with user mapping
python3 main.py --input-dir /path/to/input --output-dir /path/to/output --user-mapping users.csv --dry-run
```

**User Mapping CSV Format:**
```csv
user_id,full_name
1001,John Doe
1002,Jane Smith
1003,Bob Johnson
```

#### With Category Mapping
```bash
# Process with category mapping
python3 main.py --input-dir /path/to/input --output-dir /path/to/output --category-mapping categories.csv

# With both user and category mapping
python3 main.py --input-dir /path/to/input --output-dir /path/to/output --user-mapping users.csv --category-mapping categories.csv
```

**Category Mapping CSV Format:**
```csv
category_id,category_name
WHS,Workplace Health and Safety
HR,Human Resources
IT,Information Technology
```

### 2. Test Mode (For Testing and Development)

Test mode uses the built-in `tests/test-files` structure for safe testing:

```bash
# Basic test with all files
python3 main.py --test-mode --test-name basic

# Test with specific person
python3 main.py --test-mode --test-name person-test --person-filter "John Doe"

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

## How It Works

### Default Processing Flow

1. **Input Directory**: The tool processes all files in the specified input directory
2. **Name Extraction**: Extracts person names from directory names and filenames using configurable algorithms
3. **User Mapping**: If `--user-mapping` is provided, maps extracted names to user IDs
4. **Category Detection**: If `--category-mapping` is provided, detects categories from directory structure
5. **Date Extraction**: Extracts dates from filenames, directory names, or file metadata
6. **Filename Normalization**: Creates normalized filenames using the global component order and separator
7. **File Operations**: Moves or copies files to the output directory with normalized names

### Component Processing

The tool processes these components based on the global configuration:

- **User ID**: From user mapping file (if provided)
- **Name**: Extracted from directory names or filenames
- **Remainder**: Remaining filename parts after extraction
- **Date**: Extracted from filename, directory, or file metadata
- **Category**: From category mapping file (if provided)

### Filename Format

The final filename format is determined by the global configuration in `config/components.yaml`:

```yaml
Global:
  component_order: [id, name, remainder, date, category]
  component_separator: "_"
```

Example output: `1001_John Doe_report_2024-01-15_WHS.pdf`

## Configuration

### Main Configuration File (`config/components.yaml`)

The system uses a comprehensive YAML configuration file for all settings:

```yaml
Global:
  separators:
    input: [" ", "-", "_", ".", "/", "*", "@", "#", "$", "%", "&", "+", "=", "~", "|"]
    normalized: " "
    preserve: false
  case_normalization: "titlecase"
  allow_multiple_separators: false
  component_order: [id, name, remainder, date, category]
  component_separator: "_"

Name:
  use_global_separators: true
  extraction_order: [shorthand, initials, first_name, last_name]

Date:
  use_global_separators: true
  format: "%Y-%m-%d"
  date_priority_order: [filename, foldername, modified, created]

Category:
  mapping_test_file: tests/fixtures/04_category_mapping.csv
  id_column: category_id
  name_column: category_name
  case_insensitive: true
  enabled: true
  first_level_only: true
  append_to_filename: true
  placement: suffix

UserMapping:
  mapping_test_file: tests/fixtures/05_user_mapping.csv
  id_column: user_id
  name_column: full_name
  case_insensitive: true
  create_if_missing: false
  prefix: "VC - "
  suffix: " - Active"
```

## Advanced Features

### Person Filtering (Test Mode Only)

Filter processing to specific people only:

```bash
# Process only John Doe's files
python3 main.py --test-mode --test-name john-only --person-filter "John Doe"

# Case-insensitive filtering
python3 main.py --test-mode --test-name jane-only --person-filter "jane smith"
```

### Verbose Logging

Get detailed information about the processing:

```bash
python3 main.py --input-dir /path/to/input --output-dir /path/to/output --verbose
```

**Verbose Output Example:**
```
Processing directory: /path/to/input -> /path/to/output
2025-07-19 10:20:53,847 - INFO - Processing person: Jane Smith
2025-07-19 10:20:53,880 - INFO - DRY RUN - Would move: Jane Smith/file1.pdf -> output/1002_Jane Smith_file1_2023-11-30.pdf
```

## Error Handling

### Common Issues and Solutions

**1. "Input directory not found"**
```bash
# Ensure the input directory exists
ls -la /path/to/input/
```

**2. "User ID not found in mapping"**
```bash
# Check the user mapping file
cat users.csv
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
python3 main.py --input-dir /path/to/input --output-dir /path/to/output --dry-run

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
python3 main.py --input-dir /path/to/input --output-dir /path/to/output --dry-run
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
python3 main.py --input-dir /path/to/input --output-dir /path/to/output --verbose
```

### 5. Test with Small Batches
```bash
# Test with specific person first
python3 main.py --test-mode --test-name small-batch --person-filter "John Doe"
```

## Integration Examples

### Production Processing Script
```bash
#!/bin/bash
# Production file processing

# Backup original files
cp -r /path/to/input /path/to/backup/$(date +%Y%m%d_%H%M%S)

# Preview changes
python3 main.py --input-dir /path/to/input --output-dir /path/to/output --user-mapping users.csv --dry-run

# Apply changes
python3 main.py --input-dir /path/to/input --output-dir /path/to/output --user-mapping users.csv --verbose

echo "Processing completed!"
```

### Batch Processing with Different Configurations
```bash
#!/bin/bash
# Process multiple directories with different configurations

echo "Processing HR files..."
python3 main.py --input-dir /path/to/hr --output-dir /path/to/output/hr --user-mapping users.csv --category-mapping hr_categories.csv

echo "Processing IT files..."
python3 main.py --input-dir /path/to/it --output-dir /path/to/output/it --user-mapping users.csv --category-mapping it_categories.csv

echo "All processing completed!"
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
- [File Normalization Process](FILE_NORMALIZATION_PROCESS.md)

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