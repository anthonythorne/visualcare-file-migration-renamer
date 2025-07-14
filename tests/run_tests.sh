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

# Run all test files
echo "Running unit tests..."
bats "$SCRIPT_DIR/unit/"*.bats

echo "All tests completed successfully!" 