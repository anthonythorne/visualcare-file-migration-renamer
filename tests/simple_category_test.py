#!/usr/bin/env python3

"""
Simple Category System Test.

This script provides a basic test of the category system implementation.
"""

import sys
from pathlib import Path

# Add core/utils to path
sys.path.insert(0, str(Path(__file__).parent / 'core' / 'utils'))

def test_category_processor():
    """Test the category processor directly."""
    try:
        # Import required modules
        import yaml
        from category_processor import CategoryProcessor
        
        print("✅ Successfully imported category processor")
        
        # Load config
        config_path = Path('config/components.yaml')
        with open(config_path, 'r') as f:
            config = yaml.safe_load(f)
        
        print("✅ Successfully loaded configuration")
        
        # Create processor
        processor = CategoryProcessor(config)
        print("✅ Successfully created category processor")
        
        # Show loaded categories
        categories = processor.get_all_categories()
        print(f"✅ Loaded {len(categories)} categories:")
        for name, category_id in list(categories.items())[:5]:  # Show first 5
            print(f"  {name} -> {category_id}")
        
        # Test category detection
        test_cases = [
            {'folder_only_string': 'John Doe/WHS/2023/Incidents'},
            {'folder_only_string': 'Jane Smith/Medical/GP Reports'},
            {'folder_only_string': 'Bob Johnson/Personal Notes'},
        ]
        
        print("\n✅ Testing category detection:")
        for i, test_case in enumerate(test_cases, 1):
            category_id = processor.detect_category_from_path(test_case)
            print(f"  {i}. {test_case['folder_only_string']} -> Category ID: {category_id}")
        
        print("\n🎉 Category system test completed successfully!")
        return True
        
    except Exception as e:
        print(f"❌ Error testing category system: {e}")
        import traceback
        traceback.print_exc()
        return False

if __name__ == "__main__":
    success = test_category_processor()
    sys.exit(0 if success else 1) 