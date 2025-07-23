#!/bin/bash
set -e

python3 tests/scripts/setup_basic_test_files.py
python3 main.py --test-mode --test-name basic
bats tests/unit/output_validation_basic.bats 