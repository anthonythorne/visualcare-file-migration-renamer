#!/bin/bash

# Run complete integration tests
# This script sets up the test environment and runs the integration tests

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

echo "=== Complete Integration Test Runner ==="
echo "Project root: $PROJECT_ROOT"
echo

# Generate BATS tests from matrix
echo "Generating BATS tests..."
python3 "$SCRIPT_DIR/generate_06_complete_integration_bats.py"
echo

# Setup test files
echo "Setting up test files..."
python3 "$SCRIPT_DIR/setup_06_complete_integration_files.py" --verbose
echo

# Run the integration tests
echo "Running integration tests..."
cd "$PROJECT_ROOT"
bats tests/unit/06_complete_integration_matrix_tests.bats --verbose-run

echo
echo "=== Test files created for manual inspection ==="
echo "Source files: $PROJECT_ROOT/tests/test-files/from"
echo "Destination files: $PROJECT_ROOT/tests/test-files/to"
echo
echo "Integration test complete!" 