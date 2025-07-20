#!/usr/bin/env python3

"""
Test Category System Implementation.

This script tests the category system for multi-level directory processing,
verifying that category detection and filename formatting work correctly.

File Path: test_category_system.py

@package VisualCare\\FileMigration\\Tests
@since   1.0.0
"""

import sys
from pathlib import Path

# Add core/utils to path
sys.path.insert(0, str(Path(__file__).parent / 'core' / 'utils'))

from main import FileMigrationRenamer


def test_category_system():
    """Test the category system implementation."""
    
    print("Category System Test")
    print("=" * 50)
    
    # Initialize the renamer
    renamer = FileMigrationRenamer()
    
    # Test cases with different category scenarios
    test_cases = [
        {
            'name': 'John Doe',
            'folder_info': {
                'full_path_string': 'John Doe/WHS/2023/Incidents/01.06.2023 - John Doe.pdf',
                'folder_only_string': 'John Doe/WHS/2023/Incidents'
            },
            'expected_category': '1',  # WHS category ID
            'description': 'WHS category with nested structure'
        },
        {
            'name': 'Jane Smith',
            'folder_info': {
                'full_path_string': 'Jane Smith/Medical/GP Reports/Jane Smith Report.pdf',
                'folder_only_string': 'Jane Smith/Medical/GP Reports'
            },
            'expected_category': '2',  # Medical category ID
            'description': 'Medical category with subdirectories'
        },
        {
            'name': 'Bob Johnson',
            'folder_info': {
                'full_path_string': 'Bob Johnson/Personal Notes/Daily Journal.pdf',
                'folder_only_string': 'Bob Johnson/Personal Notes'
            },
            'expected_category': '',  # No category match
            'description': 'No category match (Personal Notes not in mapping)'
        },
        {
            'name': 'John Doe',
            'folder_info': {
                'full_path_string': 'John Doe/whs/2023/Incidents/01.06.2023 - John Doe.pdf',
                'folder_only_string': 'John Doe/whs/2023/Incidents'
            },
            'expected_category': '1',  # WHS category ID (case insensitive)
            'description': 'Case insensitive category matching'
        },
        {
            'name': 'Jane Smith',
            'folder_info': {
                'full_path_string': 'Jane Smith/Support Plans/2024 Plan.pdf',
                'folder_only_string': 'Jane Smith/Support Plans'
            },
            'expected_category': '4',  # Support Plans category ID
            'description': 'Support Plans category'
        }
    ]
    
    results = []
    
    for i, test_case in enumerate(test_cases, 1):
        print(f"\nTest {i}: {test_case['description']}")
        print(f"Input: {test_case['folder_info']['full_path_string']}")
        
        # Extract components
        components = renamer.extract_file_components(
            'test.pdf', 
            test_case['name'], 
            test_case['folder_info']
        )
        
        if not components:
            print("❌ Failed to extract components")
            results.append(False)
            continue
        
        # Check category detection
        detected_category = components.get('category', '')
        expected_category = test_case['expected_category']
        
        print(f"Expected category: {expected_category}")
        print(f"Detected category: {detected_category}")
        
        # Format filename
        formatted_filename = renamer.format_normalized_filename(components)
        print(f"Formatted filename: {formatted_filename}")
        
        # Check if category is correctly included
        if expected_category:
            if expected_category in formatted_filename:
                print("✅ Category correctly included in filename")
                results.append(True)
            else:
                print("❌ Category not included in filename")
                results.append(False)
        else:
            if detected_category:
                print("❌ Category detected when none expected")
                results.append(False)
            else:
                print("✅ No category correctly detected")
                results.append(True)
    
    # Summary
    print(f"\n{'='*50}")
    print("CATEGORY SYSTEM TEST SUMMARY")
    print(f"{'='*50}")
    print(f"Total tests: {len(results)}")
    print(f"Passed: {sum(results)}")
    print(f"Failed: {len(results) - sum(results)}")
    
    if all(results):
        print("🎉 All category system tests passed!")
        return True
    else:
        print("⚠️  Some category system tests failed!")
        return False


def test_category_processor_directly():
    """Test the category processor directly."""
    
    print("\n" + "="*50)
    print("DIRECT CATEGORY PROCESSOR TEST")
    print("="*50)
    
    # Load config
    import yaml
    config_path = Path('config/components.yaml')
    with open(config_path, 'r') as f:
        config = yaml.safe_load(f)
    
    # Test category processor
    from category_processor import CategoryProcessor
    processor = CategoryProcessor(config)
    
    # Show all loaded categories
    print("Loaded categories:")
    categories = processor.get_all_categories()
    for name, category_id in categories.items():
        print(f"  {name} -> {category_id}")
    
    # Test category detection
    test_paths = [
        {'folder_only_string': 'John Doe/WHS/2023/Incidents'},
        {'folder_only_string': 'Jane Smith/Medical/GP Reports'},
        {'folder_only_string': 'Bob Johnson/Personal Notes'},
        {'folder_only_string': 'John Doe/whs/2023/Incidents'},  # Case insensitive
        {'folder_only_string': 'John Doe/Support Plans/2024'},
    ]
    
    print("\nCategory detection tests:")
    for i, test_path in enumerate(test_paths, 1):
        category_id = processor.detect_category_from_path(test_path)
        print(f"  {i}. {test_path['folder_only_string']} -> Category ID: {category_id}")


def main():
    """Run all category system tests."""
    print("Category System Implementation Test")
    print("=" * 60)
    
    # Test category processor directly
    test_category_processor_directly()
    
    # Test full system integration
    success = test_category_system()
    
    if success:
        print("\n✅ Category system implementation is working correctly!")
        sys.exit(0)
    else:
        print("\n❌ Category system implementation has issues!")
        sys.exit(1)


if __name__ == "__main__":
    main() 