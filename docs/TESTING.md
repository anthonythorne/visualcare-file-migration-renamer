# Testing Guide

This document explains how to generate, run, and understand the tests for the VisualCare File Migration Renamer project.

## Test Types

- **Name Extraction Tests:** Validate name extraction logic using a matrix in `tests/fixtures/name_extraction_cases.csv`.
- **Date Extraction Tests:** Validate date extraction logic using a matrix in `tests/fixtures/date_extraction_cases.csv`.
- **Combined Extraction Tests:** Validate both name and date extraction together using `tests/fixtures/combined_extraction_cases.csv`.
- **Test Mode Integration Tests:** Validate the main CLI application using the `tests/test-files` structure.

## Testing Rules and Standards

### Core Testing Philosophy

All tests must follow a **scaffolding approach** where:
1. **Test cases are defined in CSV matrices** in `tests/fixtures/`
2. **BATS tests are auto-generated** from CSV matrices using scaffolding commands
3. **Test files are auto-created** from CSV matrices using setup scripts
4. **Tests verify against the original matrices** to ensure functionality works as expected

### Required Testing Process

#### 1. CSV-Driven Test Matrices
- All test cases must be defined in CSV files in `tests/fixtures/`
- Use pipe (`|`) delimiters for CSV files
- Include columns for input, expected output, and test metadata
- Example: `name_extraction_cases.csv`, `date_extraction_cases.csv`, `combined_extraction_cases.csv`

#### 2. Scaffolding Commands
**NEVER create BATS tests manually.** Always use scaffolding commands:

```bash
# Generate BATS tests from CSV matrices
python3 tests/scripts/generate_bats_tests.py name
python3 tests/scripts/generate_bats_tests.py date
python3 tests/scripts/generate_bats_tests.py combined
```

#### 3. Test File Setup Scripts
**NEVER create test files manually.** Always use setup scripts:

```bash
# Create test files from CSV matrices
python3 tests/scripts/setup_category_test_files.py
python3 tests/scripts/setup_multi_level_test_files.py
```

#### 4. Test Directory Structure
```
tests/
├── fixtures/                    # CSV test matrices
│   ├── name_extraction_cases.csv
│   ├── date_extraction_cases.csv
│   ├── combined_extraction_cases.csv
│   └── category_test_cases.csv
├── test-files/                  # Test file directories
│   ├── from-<test-name>/        # Input files for specific tests
│   └── to-<test-name>/          # Output files for specific tests
├── unit/                        # Generated BATS tests
├── scripts/                     # Setup and generation scripts
└── run_tests.sh                 # Main test runner
```

### Test Execution Hierarchy

Tests must be run in order from smallest to largest:

1. **Component Tests** (smallest)
   - Name extraction tests: `bats tests/unit/name_utils_table_test.bats`
   - Date extraction tests: `bats tests/unit/date_utils_table_test.bats`

2. **Combined Tests** (medium)
   - Combined extraction tests: `bats tests/unit/combined_utils_table_test.bats`

3. **Integration Tests** (largest)
   - Test mode integration: `python3 main.py --test-mode --test-name <test-name> --dry-run`
   - Full test suite: `./tests/run_tests.sh`

### Test File Management Rules

#### Automatic Cleanup
- Setup scripts **automatically clean** existing test directories
- Scripts **delete and recreate** `from-<test-name>` and `to-<test-name>` directories
- **Never manually create or modify** test files

#### Test File Naming Convention
- Input directories: `from-<test-name>` (e.g., `from-basic`, `from-category`)
- Output directories: `to-<test-name>` (e.g., `to-basic`, `to-category`)
- Person-specific subdirectories within each test directory

#### Test File Content
- Test files are created with **realistic content** based on CSV test cases
- Files include **proper directory structures** for multi-level testing
- Content reflects **actual use cases** from the CSV matrices

#### Test Directory Cleanup Rules
- **NEVER manually create** `tests/test-files/from/` directory
- **NEVER manually create** `tests/test-files/from-<test-name>/` directories
- **ALWAYS clean both input and output directories** before running tests
- Setup scripts **automatically clean and recreate** all test directories
- **Always use setup scripts** to create test files:
  ```bash
  python3 tests/scripts/setup_category_test_files.py
  python3 tests/scripts/setup_multi_level_test_files.py
  ```
- If you see `tests/test-files/from/` directory, **delete it immediately**
- Only `from-<test-name>/` directories should exist (e.g., `from-basic/`, `from-category/`)

#### Test Directory Cleanup Process
- **Before each test run**: Clean both `from-<test-name>/` and `to-<test-name>/` directories
- **Setup scripts**: Create fresh input files in `from-<test-name>/` directories
- **Test execution**: Creates output files in `to-<test-name>/` directories
- **After test run**: Output directories are preserved for inspection
- **Next test run**: Both directories are cleaned again for fresh start

**Example cleanup process:**
```bash
# Before test run
rm -rf tests/test-files/from-basic tests/test-files/to-basic

# Setup creates fresh input files
python3 tests/scripts/setup_category_test_files.py

# Test creates output files
python3 main.py --test-mode --test-name basic

# Outputs preserved for inspection
# Next test run will clean both directories again
```

#### Test Output Preservation
- **Test outputs are preserved** for inspection and validation
- `to-<test-name>/` directories are **NOT cleaned up** after tests
- This allows you to:
  - Inspect the actual files created by tests
  - Compare input and output structures
  - Debug filename transformations
  - Validate processing results
- **Manual cleanup** may be needed between test runs if you want fresh outputs
- To clean outputs manually:
  ```bash
  rm -rf tests/test-files/to-*
  ```

### Code Organization Rules

#### Test-Related Files Location
- **All test files** must be in `tests/` directory
- **Test fixtures** (CSV files) in `tests/fixtures/`
- **Test scripts** in `tests/scripts/`
- **Generated tests** in `tests/unit/`
- **Test files** in `tests/test-files/`

#### Configuration Files
- Test-related config files (e.g., `category_mapping.csv`, `user_mapping.csv`) belong in `tests/fixtures/`
- Main application config files remain in `config/`

### Validation Rules

#### Matrix Verification
- Tests must **verify against the original CSV matrices**
- Expected outputs in CSV must match actual test results
- Any deviation requires updating the CSV matrix, not the test

#### Test Independence
- Each test must be **independent** and **repeatable**
- Tests must **clean up after themselves**
- No test should depend on the state of other tests

#### Error Handling
- Tests must handle **missing files gracefully**
- Tests must provide **clear error messages**
- Tests must **fail fast** when prerequisites aren't met

### Extension Rules

When adding new features:
1. **Create CSV matrix** in `tests/fixtures/` with test cases
2. **Create setup script** in `tests/scripts/` to generate test files
3. **Update scaffolding commands** to generate BATS tests
4. **Follow existing patterns** from name/date/combined tests
5. **Never create tests manually** - always use scaffolding

### Documentation Requirements

- All test matrices must have **clear column headers**
- Setup scripts must provide **usage instructions**
- Test runners must show **clear progress and results**
- All test failures must provide **actionable error messages**

## Test Mode Integration Testing

The test mode functionality allows you to test the complete file processing pipeline using real files in the `tests/test-files` structure.

### Test Files Structure

```
tests/test-files/
├── from-basic/                  # Input files for basic test
│   ├── John Doe/               # Person-specific directories
│   │   ├── file1.pdf
│   │   └── file2.docx
│   ├── Jane Smith/
│   └── Temp Person/
├── from-category/               # Input files for category test
│   ├── John Doe/
│   ├── Jane Smith/
│   └── Bob Johnson/
├── from-<test-name>/            # Input files for specific tests
├── to-basic/                    # Output for basic test
├── to-userid/                   # Output for user ID test
├── to-management/               # Output for management test
└── to-<test-name>/              # Output for specific tests
```

**IMPORTANT:** 
- **NEVER create** `tests/test-files/from/` directory
- **ALWAYS use** `tests/test-files/from-<test-name>/` directories
- Each test type has its own input directory: `from-basic`, `from-category`, etc.
- Setup scripts automatically create the correct `from-<test-name>` directories

### Running Test Mode

```bash
# Basic test mode (no user IDs)
python3 main.py --test-mode --test-name basic --dry-run

# User ID test mode
python3 main.py --test-mode --test-name userid --dry-run

# Management flag test mode
python3 main.py --test-mode --test-name management --dry-run

# Person-specific test
python3 main.py --test-mode --test-name person-test --person "John Doe" --dry-run

# With verbose output
python3 main.py --test-mode --test-name basic --dry-run --verbose

# Actual processing (not dry-run)
python3 main.py --test-mode --test-name basic
```