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
python3 tests/scripts/generate_name_extraction_bats.py
if [ "$VERBOSE_MODE" = "all" ]; then
  bats --show-output-of-passing-tests tests/unit/00_name_extraction_matrix_tests.bats
else
  bats tests/unit/00_name_extraction_matrix_tests.bats
fi

# Rescaffold and run date extraction tests
echo "[INFO] Generating and running date extraction BATS tests..."
python3 tests/scripts/generate_date_extraction_bats.py
if [ "$VERBOSE_MODE" = "all" ]; then
  bats --show-output-of-passing-tests tests/unit/01_date_extraction_matrix_tests.bats
else
  bats tests/unit/01_date_extraction_matrix_tests.bats
fi

# Rescaffold and run name extraction from path tests
echo "[INFO] Generating and running name extraction from path BATS tests..."
python3 tests/scripts/generate_name_extraction_from_path_bats.py
if [ "$VERBOSE_MODE" = "all" ]; then
  bats --show-output-of-passing-tests tests/unit/02_name_extraction_from_path_matrix_tests.bats
else
  bats tests/unit/02_name_extraction_from_path_matrix_tests.bats
fi

# Rescaffold and run date extraction from path tests
echo "[INFO] Generating and running date extraction from path BATS tests..."
python3 tests/scripts/generate_date_extraction_from_path_bats.py
if [ "$VERBOSE_MODE" = "all" ]; then
  bats --show-output-of-passing-tests tests/unit/03_date_extraction_from_path_matrix_tests.bats
else
  bats tests/unit/03_date_extraction_from_path_matrix_tests.bats
fi

# 04: Category extraction matrix test
python3 tests/scripts/generate_category_extraction_bats.py
bats --show-output-of-passing-tests tests/unit/04_category_extraction_matrix_tests.bats

echo "All core extraction tests passed!" 