# Project Tests Context

## Test Philosophy

This project uses a **matrix-driven, dynamic testing approach** where:

1. **All tests are generated dynamically** from CSV matrices (fixtures) - no hardcoded BATS tests
2. **Core logic is tested in isolation** (non-file tests) using individual functions
3. **File system operations are tested in integration** (file-based tests) that combine all components
4. **Universal configuration** ensures consistency across all components
5. **Clean separation of concerns** between extraction logic and file operations

## Test Structure

### Core Function Tests (Non-File)
- **00_name_extraction_matrix_tests.bats** - Filename-based name extraction (49 tests)
- **01_date_extraction_matrix_tests.bats** - Filename-based date extraction (8 tests)
- **02_name_extraction_from_path_matrix_tests.bats** - Path-based name extraction (5 tests)
- **03_date_extraction_from_path_matrix_tests.bats** - Path-based date extraction (5 tests)
- **04_category_extraction_matrix_tests.bats** - Category extraction from paths (10 tests)
- **05_user_mapping_matrix_tests.bats** - User mapping with full path support (7 tests)

### Integration Tests (File-Based)
- **99_complete_test_cases.csv** - Single comprehensive integration test matrix

## Key Technical Concepts

### Universal Separator Normalization
- **Global.separators.input**: List of input separators to recognize
- **Global.separators.normalized**: Single output separator (space)
- **Global.separators.preserve**: Whether to preserve original separators
- All components use this centralized configuration

### Config-Driven Extraction Order
- **Name.extraction_order**: Priority for name extraction (shorthand → initials → first_name → last_name)
- **Date.date_priority_order**: Priority for date extraction (filename → foldername → modified → created)
- **Global.component_order**: Order of components in final filename (id → name → remainder → date → category)
- **Global.component_separator**: Separator between components in final filename (default: "_")

### User Mapping with Full Path Support
- **Always expects full names as first directories** (e.g., "John Doe/", "Jane Smith/")
- **Optional prefix/suffix handling** (e.g., "VC - John Doe/", "John Doe - Active/")
- **Configurable prefix/suffix removal** in UserMapping section
- **Full path extraction** including filename remainder components
- **No fuzzy matching** - direct name lookup only

### Raw vs. Cleaned Remainder
- **Raw remainder**: String remaining after extraction (preserves original separators)
- **Cleaned remainder**: Normalized version using universal separator logic

## Workflow

### 1. Matrix Creation
- Create CSV matrices in `tests/fixtures/` with test cases
- Include expected outputs for all components
- Use minimal, high-complexity cases for easy review

### 2. Scaffolding Generation
- Run `python3 tests/scripts/generate_XX_*.py` to create BATS tests
- Scripts read matrices and generate dynamic test files
- Ensure `tests/unit/` directory exists

### 3. Test Execution
- Run `bash tests/run_tests.sh` for all tests
- Use `--verbose=all` for detailed output
- Individual tests: `bats tests/unit/XX_*.bats`

### 4. Debugging Process
- Check matrix alignment with actual function output
- Verify shell function availability and exports
- Ensure Python script output format matches expectations
- Fix indentation errors and syntax issues

## Current Status

### ✅ Completed
- **00_name_extraction_matrix_tests.bats** - All 49 tests passing
- **01_date_extraction_matrix_tests.bats** - All 8 tests passing  
- **02_name_extraction_from_path_matrix_tests.bats** - All 5 tests passing
- **03_date_extraction_from_path_matrix_tests.bats** - All 5 tests passing
- **04_category_extraction_matrix_tests.bats** - All 10 tests passing
- **05_user_mapping_matrix_tests.bats** - All 7 tests passing

**Total: 84/84 core extraction tests passing** ✅

### 🔄 Next Steps
- **99_complete_test_cases.csv** - Integration test matrix
- **setup_complete_test_files.py** - File creation for integration tests
- **generate_99_complete_bats.py** - Integration test scaffolding
- **Archive cleanup** - Move old matrices and scripts to `tests/archive/`

## Configuration

### components.yaml Structure
```yaml
Global:
  separators:
    input: [" ", "-", "_", ".", "/", "*", "@", "#", "$", "%", "&", "+", "=", "~", "|"]
    normalized: " "
    preserve: false
  case_normalization: "titlecase"
  allow_multiple_separators: false
  component_order:
    - id
    - name
    - remainder
    - date
    - category
  component_separator: "_"

Name:
  use_global_separators: true
  extraction_order:
    - shorthand
    - initials
    - first_name
    - last_name

Date:
  use_global_separators: true
  format: "%Y-%m-%d"
  date_priority_order:
    - filename
    - foldername
    - modified
    - created

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
  component_order:
    - id
    - name
    - remainder
    - date
```

## File Organization

### Core Logic
- `core/utils/name_matcher.py` - Name extraction and universal cleaning
- `core/utils/date_matcher.py` - Date extraction (filename and path)
- `core/utils/category_processor.py` - Category detection and mapping
- `core/utils/user_mapping.py` - User mapping with full path support

### Shell Wrappers
- `core/utils/name_utils.sh` - Shell functions for name extraction
- `core/utils/date_utils.sh` - Shell functions for date extraction
- `core/utils/category_utils.sh` - Shell functions for category extraction
- `core/utils/user_mapping.sh` - Shell functions for user mapping

### Test Infrastructure
- `tests/fixtures/` - CSV matrices for test cases
- `tests/scripts/` - Scaffolding generators
- `tests/unit/` - Generated BATS test files
- `tests/archive/` - Old/redundant test artifacts

## Best Practices

1. **Always use matrix-driven tests** - no hardcoded test cases
2. **Test core functions in isolation** before integration
3. **Use universal configuration** for consistency
4. **Handle edge cases** in matrices, not in code
5. **Maintain clean separation** between extraction and file operations
6. **Document all changes** in this context file
7. **Archive old artifacts** rather than deleting them 