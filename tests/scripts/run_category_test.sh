#!/bin/bash
set -e
 
python3 tests/scripts/setup_category_test_files.py
python3 main.py --test-mode --test-name category
bats tests/unit/output_validation_category.bats 