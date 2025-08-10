#!/bin/bash
set -e

VERBOSE_MODE="errors"

# Parse --verbose flag
for arg in "$@"; do
  case $arg in
    --verbose=all)
      VERBOSE_MODE="all"
      ;;
    --verbose=errors)
      VERBOSE_MODE="errors"
      ;;
  esac
  shift
done

# Rescaffold and run name extraction tests
echo "[INFO] Generating and running name extraction BATS tests..."
python3 tests/scripts/generate_00_name_extraction_bats.py
if [ "$VERBOSE_MODE" = "all" ]; then
  bats --show-output-of-passing-tests tests/unit/00_name_extraction_matrix_tests.bats
else
  bats tests/unit/00_name_extraction_matrix_tests.bats
fi

# Rescaffold and run date extraction tests
echo "[INFO] Generating and running date extraction BATS tests..."
python3 tests/scripts/generate_01_date_extraction_bats.py
if [ "$VERBOSE_MODE" = "all" ]; then
  bats --show-output-of-passing-tests tests/unit/01_date_extraction_matrix_tests.bats
else
  bats tests/unit/01_date_extraction_matrix_tests.bats
fi

# Rescaffold and run name extraction from path tests
echo "[INFO] Generating and running name extraction from path BATS tests..."
python3 tests/scripts/generate_02_name_extraction_from_path_bats.py
if [ "$VERBOSE_MODE" = "all" ]; then
  bats --show-output-of-passing-tests tests/unit/02_name_extraction_from_path_matrix_tests.bats
else
  bats tests/unit/02_name_extraction_from_path_matrix_tests.bats
fi

# Rescaffold and run date extraction from path tests
echo "[INFO] Generating and running date extraction from path BATS tests..."
python3 tests/scripts/generate_03_date_extraction_from_path_bats.py
if [ "$VERBOSE_MODE" = "all" ]; then
  bats --show-output-of-passing-tests tests/unit/03_date_extraction_from_path_matrix_tests.bats
else
  bats tests/unit/03_date_extraction_from_path_matrix_tests.bats
fi

# Rescaffold and run category extraction and mapping tests
echo "[INFO] Generating and running category extraction and mapping BATS tests..."
python3 tests/scripts/generate_04_category_extraction_and_mapping_bats.py

if [ "$VERBOSE_MODE" = "all" ]; then
    bats --show-output-of-passing-tests tests/unit/04_category_extraction_and_mapping_matrix_tests.bats
else
    bats tests/unit/04_category_extraction_and_mapping_matrix_tests.bats
fi

# Rescaffold and run user mapping tests
echo "[INFO] Generating and running user mapping BATS tests..."
python3 tests/scripts/generate_05_user_mapping_bats.py
if [ "$VERBOSE_MODE" = "all" ]; then
  bats --show-output-of-passing-tests tests/unit/05_user_mapping_matrix_tests.bats
else
  bats tests/unit/05_user_mapping_matrix_tests.bats
fi

# Rescaffold and run complete integration tests
echo "[INFO] Generating and running complete integration BATS tests..."
python3 tests/scripts/generate_06_complete_integration_bats.py
if [ "$VERBOSE_MODE" = "all" ]; then
  bats --show-output-of-passing-tests tests/unit/06_complete_integration_matrix_tests.bats
else
  bats tests/unit/06_complete_integration_matrix_tests.bats
fi

# Also scaffold real test files and validate results for Test 06
echo "[INFO] Setting up 06 integration test files (from-06/to-06) and validating output..."
python3 tests/scripts/setup_06_complete_integration_files.py --verbose | cat
# Run the real processor over the scaffolded files to populate the to-06/ directory
python3 main.py --input-dir tests/test-files/from-06 --output-dir tests/test-files/to-06 --user-mapping tests/fixtures/05_user_mapping.csv --category-mapping tests/fixtures/04_category_mapping.csv --duplicate | cat
python3 tests/scripts/validate_06_results.py | cat

echo "All core extraction tests passed!"