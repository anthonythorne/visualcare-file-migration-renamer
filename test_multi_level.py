#!/usr/bin/env python3

"""Simple test runner for multi-level directory processing."""

import sys
from pathlib import Path

# Add project root to path
sys.path.insert(0, str(Path(__file__).parent))

try:
    from tests.test_multi_level_directory import MultiLevelDirectoryTester
    
    print("Running Multi-Level Directory Processing Tests...")
    print("=" * 60)
    
    tester = MultiLevelDirectoryTester()
    results = tester.test_multi_level_processing()
    tester.print_summary(results)
    
    if results['failed'] > 0:
        print(f"\n❌ {results['failed']} tests failed!")
        sys.exit(1)
    else:
        print(f"\n✅ All {results['passed']} tests passed!")
        
except ImportError as e:
    print(f"❌ Import error: {e}")
    print("Make sure you're running from the project root directory.")
    sys.exit(1)
except Exception as e:
    print(f"❌ Test error: {e}")
    import traceback
    traceback.print_exc()
    sys.exit(1) 