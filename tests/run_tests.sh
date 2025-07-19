#!/usr/bin/env bash

# Exit on error
set -e

# Get the directory where this script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Check if BATS is installed
if ! command -v bats &> /dev/null; then
    echo "BATS is not installed. Please install it first:"
    echo "  npm install -g bats"
    echo "  or"
    echo "  brew install bats-core"
    exit 1
fi

# Run all unit tests
echo "Running unit tests..."
bats "$SCRIPT_DIR/unit/"*.bats

# Run integration tests using the test-files structure
echo ""
echo "Running integration tests..."
cd "$SCRIPT_DIR/.."

# Test 1: Basic processing (no user IDs)
echo "Test 1: Basic processing (no user IDs)"
python3 main.py --test-mode --test-name basic --dry-run --verbose > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo "✓ Basic processing test passed"
else
    echo "✗ Basic processing test failed"
    exit 1
fi

# Test 2: User ID processing
echo "Test 2: User ID processing"
python3 main.py --test-mode --test-name userid --dry-run --verbose > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo "✓ User ID processing test passed"
else
    echo "✗ User ID processing test failed"
    exit 1
fi

# Test 3: Management flag processing
echo "Test 3: Management flag processing"
python3 main.py --test-mode --test-name management --dry-run --verbose > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo "✓ Management flag processing test passed"
else
    echo "✗ Management flag processing test failed"
    exit 1
fi

# Test 4: Person-specific processing
echo "Test 4: Person-specific processing (John Doe)"
python3 main.py --test-mode --test-name person-test --person "John Doe" --dry-run --verbose > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo "✓ Person-specific processing test passed"
else
    echo "✗ Person-specific processing test failed"
    exit 1
fi

echo ""
echo "All tests completed successfully!" 