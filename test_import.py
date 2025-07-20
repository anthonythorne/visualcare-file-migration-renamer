#!/usr/bin/env python3

"""Test script to verify imports work correctly."""

import sys
from pathlib import Path

# Add core/utils to path
sys.path.insert(0, str(Path(__file__).parent / 'core' / 'utils'))

try:
    from directory_processor import DirectoryProcessor
    print("✓ DirectoryProcessor import successful")
except Exception as e:
    print(f"✗ DirectoryProcessor import failed: {e}")

try:
    from main import FileMigrationRenamer
    print("✓ FileMigrationRenamer import successful")
except Exception as e:
    print(f"✗ FileMigrationRenamer import failed: {e}")

print("Import test completed.") 