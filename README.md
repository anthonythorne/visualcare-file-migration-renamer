# VisualCare File Migration Renamer

This project provides a tool to rename files based on a CSV mapping file. It is designed to handle various file naming patterns and extract names from filenames.

## Overview

The tool reads a CSV file containing mappings of old filenames to new filenames. It processes each file, extracts names from the old filename, and renames the file according to the new filename format.

## Features

- **CSV Mapping:** Use a CSV file to map old filenames to new filenames.
- **Name Extraction:** Extract names from filenames using various patterns (e.g., first name, last name, initials).
- **File Renaming:** Rename files based on the extracted names and the new filename format.
- **Test Scaffolding:** Automatically generate BATS tests from a CSV file, ensuring one test per line for easy debugging.

## Installation

1. Clone the repository:
   ```bash
   git clone <repository-url>
   cd visualcare-file-migration-renamer
   ```

2. Install dependencies:
   ```bash
   pip install -r requirements.txt
   ```

3. Install BATS for testing:
   ```bash
   npm install -g bats
   ```

## Usage

### Running the Tool

1. Prepare your CSV mapping file (e.g., `mapping.csv`) with the following columns:
   - `old_filename`: The original filename.
   - `new_filename`: The desired new filename.

2. Run the tool:
   ```bash
   python main.py --csv mapping.csv
   ```

### Testing

The project includes a test scaffolding process to generate BATS tests from a CSV file. This ensures that each line in the CSV becomes an individual test, making debugging easier.

#### Generating Tests

1. Update your test cases in `tests/fixtures/name_extraction_cases.csv`.

2. Generate the BATS tests:
   ```bash
   ./scripts/generate_bats_tests.py
   ```

3. Run the tests:
   ```bash
   bats tests/unit/name_utils_table_test.bats
   ```

## Project Structure

- `core/utils/`: Contains utility functions for name extraction and file renaming.
- `tests/fixtures/`: Contains CSV files for test cases.
- `tests/unit/`: Contains BATS test files generated from the CSV.
- `scripts/`: Contains scripts for generating tests and other utilities.

## Contributing

1. Fork the repository.
2. Create a new branch for your feature.
3. Commit your changes.
4. Push to the branch.
5. Create a Pull Request.

## License

This project is licensed under the MIT License. See the LICENSE file for details.
