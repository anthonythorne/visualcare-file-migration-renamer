#!/bin/bash
set -e

# Run all core/unit BATS tests
bats tests/unit/name_utils_table_test.bats
bats tests/unit/date_utils_table_test.bats
bats tests/unit/combined_utils_table_test.bats

# Run each integration test (setup, processing, validation)
bash tests/scripts/run_basic_test.sh
bash tests/scripts/run_category_test.sh
bash tests/scripts/run_multi_level_test.sh

echo "All tests passed!" 