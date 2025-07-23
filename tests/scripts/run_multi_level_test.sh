#!/bin/bash
set -e
 
python3 tests/scripts/setup_multi_level_test_files.py
python3 main.py --test-mode --test-name multi-level
bats tests/unit/output_validation_multi_level.bats 