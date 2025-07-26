#!/usr/bin/env python3

"""
Test script to call normalize_filename function for BATS tests.

This script provides a simple interface for BATS tests to call the normalize_filename
function without needing the full CLI interface.

File Path: tests/utils/normalize_test.py

@package VisualCare\\FileMigration\\Tests
@since   1.0.0
"""

import sys
import os
from pathlib import Path

# Add the project root to the Python path
project_root = Path(__file__).parent.parent.parent
sys.path.insert(0, str(project_root))

from main import normalize_filename


def main():
    """Main function to handle normalize_filename calls for testing."""
    if len(sys.argv) != 2:
        print("Usage: python3 normalize_test.py <full_path>")
        sys.exit(1)
    
    full_path = sys.argv[1]
    
    try:
        # Call normalize_filename with no mappings (for testing)
        result = normalize_filename(full_path)
        print(result)
    except Exception as e:
        print(f"Error: {e}", file=sys.stderr)
        sys.exit(1)


if __name__ == "__main__":
    main() 