# VisualCare File Migration Renamer

A comprehensive file migration and renaming tool designed for real-world file management scenarios. This tool intelligently extracts names, dates, and user IDs from filenames and generates normalized filenames according to configurable templates.

## 🚀 Quick Start

### Install Dependencies
```bash
pip install pyyaml
```

### Basic Usage
```bash
# Test mode (recommended for testing)
python3 main.py --test-mode --test-name my-test --dry-run

# Process files using CSV mapping
python3 main.py --csv mapping.csv --dry-run

# Process directory with name mapping
python3 main.py --input-dir /path/to/input --output-dir /path/to/output --name-mapping names.csv --dry-run
```

## 📋 Features

- **Smart Name Extraction**: Extracts names using fuzzy matching, initials, and shorthand patterns
- **Date Recognition**: Supports multiple date formats (ISO, US, European, written months)
- **User ID Mapping**: Maps user IDs to names for consistent filename generation
- **Template-Based Formatting**: Configurable filename templates with placeholders
- **Management Flag Detection**: Automatically flags management documents
- **Comprehensive Testing**: 174 tests with 100% pass rate
- **Dry-Run Mode**: Preview changes before applying them

## 🎯 Real-World Examples

### Example 1: Support Plan Document
**Original:** `F016 Sarah Support Plan 16.04.23 - v5.0.docx`  
**Processed:** `1004_Sarah Smith_F016 Support Plan v5.0_2023-04-16.docx`

### Example 2: Hazard Report
**Original:** `Hazard Report - Crates under legs of lounge - Sarah Smith.pdf`  
**Processed:** `1004_Sarah Smith_Hazard Report Crates under legs of lounge.pdf`

### Example 3: Management Document
**Original:** `management_report_2023-12-01.pdf`  
**Processed:** `1001_John Doe_management report_2023-12-01_MGMT.pdf`

## 📖 Usage Guide

### Test Mode (Recommended)
   ```bash
# Basic test with all files
python3 main.py --test-mode --test-name basic --dry-run

# Test with specific person
python3 main.py --test-mode --test-name person-test --person "John Doe" --dry-run

# Actual processing (not dry-run)
python3 main.py --test-mode --test-name production
   ```

### CSV Mapping
```bash
# Preview changes
python3 main.py --csv mapping.csv --dry-run

# Apply changes
python3 main.py --csv mapping.csv
```

**CSV Format:**
```csv
filename,name_to_match
old_file.pdf,John Doe
another_file.docx,Jane Smith
   ```

### Directory Processing
```bash
# Process entire directory
python3 main.py --input-dir /path/to/input --output-dir /path/to/output --name-mapping names.csv --dry-run
```

## ⚙️ Configuration

### Filename Template
Configure the output filename format in `config/components.yaml`:

```yaml
FilenameFormat:
  template: "{id}_{name}_{remainder}_{date}"
  skip_empty_components: true
  cleanup_separators: true
```

**Available Placeholders:**
- `{id}`: User ID from mapping
- `{name}`: Extracted person name
- `{date}`: Extracted date (ISO format)
- `{remainder}`: Remaining filename parts
- `{category}`: Category code (future feature)
- `{management_flag}`: Management flag if detected

### User ID Mapping
Map user IDs to names in `config/user_mapping.csv`:

```csv
user_id,full_name
1001,John Doe
1002,Jane Smith
1003,Bob Johnson
1004,Sarah Smith
1005,Michael Brown
```

### Management Flag Detection
```yaml
ManagementFlag:
  enabled: true
  keywords: ["management", "admin", "supervisor"]
  flag: "MGMT"
```

## 🧪 Testing

### Run All Tests
```bash
./tests/run_tests.sh
```

### Test Coverage
- **174 total tests** (144 unit + 30 integration)
- **100% pass rate**
- **Comprehensive edge case coverage**
- **Automated test generation from CSV matrices**

### Test Mode Integration
```bash
# Basic test mode
python3 main.py --test-mode --test-name basic --dry-run

# User ID processing
python3 main.py --test-mode --test-name userid --dry-run

# Management flag processing
python3 main.py --test-mode --test-name management --dry-run
```

## 📚 Documentation

### For Users
- **[Usage Guide](docs/USAGE_GUIDE.md)** - Complete usage instructions and examples
- **[Testing Guide](docs/TESTING.md)** - Testing procedures and validation

### For Developers
- **[Implementation Summary](docs/IMPLEMENTATION_SUMMARY.md)** - Technical architecture and design
- **[Naming Conventions](docs/NAMING_CONVENTIONS.md)** - Complete name extraction and filename processing

### For System Administrators
- **[Usage Guide](docs/USAGE_GUIDE.md)** - Deployment and configuration
- **[Implementation Summary](docs/IMPLEMENTATION_SUMMARY.md)** - System requirements

## 🔧 Advanced Features

### Name Extraction Algorithms
- **Shorthand Patterns**: `jdoe`, `j-doe`, `john-d`
- **Initials**: `j-d`, `j.d`, `j d`, `jd`
- **Full Names**: `john-doe`, `doe-john`
- **Fuzzy Matching**: Handles character substitutions and case variations

### Date Format Support
- **ISO**: `2023-01-15`, `20230115`
- **US**: `01-15-2023`, `01152023`
- **European**: `15-01-2023`, `15012023`
- **Written**: `25-Dec-2023`, `1st-jan-2024`

### Separator Handling
- **Configurable**: All separators defined in YAML configuration
- **Smart Cleaning**: Removes duplicate separators using precedence rules
- **Preservation**: Maintains meaningful separators in filenames

## 🚨 Important Notes

### Before Processing Files
1. **Always use `--dry-run` first** to preview changes
2. **Backup your files** before running actual processing
3. **Test with a small subset** of files first
4. **Verify CSV mappings** are correct

### File Safety
- **No files are modified** in dry-run mode
- **Original files are preserved** during processing
- **Comprehensive logging** tracks all operations
- **Error handling** prevents data loss

## 🤝 Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for development guidelines and contribution instructions.

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 📞 Support

### Getting Help
1. **Check the documentation** - Start with the [Usage Guide](docs/USAGE_GUIDE.md)
2. **Run tests** - Use `./tests/run_tests.sh` to verify system status
3. **Use test mode** - Test your specific scenario with test mode
4. **Review examples** - Check usage examples in the documentation

### Common Issues
- **File not found**: Ensure file paths are correct and files exist
- **Name not matched**: Check CSV mapping and name spelling
- **Date not extracted**: Verify date format is supported
- **Permission errors**: Ensure write permissions for output directories

---

**Version**: 1.0.0  
**Last Updated**: July 2025  
**Status**: Production Ready
