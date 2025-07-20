#!/usr/bin/env python3

"""
Multi-Level Directory Processing Tests.

This module tests the multi-level directory processing functionality,
extending the existing filename normalization system to handle nested
directory structures.

File Path: tests/test_multi_level_directory.py

@package VisualCare\\FileMigration\\Tests
@since   1.0.0

Tests:
- Multi-level directory path processing
- Name and date extraction from full paths
- Folder remainder processing
- Separator replacement and cleanup
- Integration with existing filename normalization
"""

import csv
import sys
from pathlib import Path
from typing import Dict, List

# Add project root to path
sys.path.insert(0, str(Path(__file__).parent.parent))

from main import FileMigrationRenamer


class MultiLevelDirectoryTester:
    """Test class for multi-level directory processing functionality."""
    
    def __init__(self):
        """Initialize the tester with the renamer instance."""
        self.renamer = FileMigrationRenamer()
        self.test_cases = self._load_test_cases()
    
    def _load_test_cases(self) -> List[Dict]:
        """
        Load test cases from the multi-level directory fixture.
        
        Returns:
            List[Dict]: List of test case dictionaries.
        """
        test_cases = []
        fixture_path = Path(__file__).parent / 'fixtures' / 'multi_level_directory_cases.csv'
        
        if not fixture_path.exists():
            print(f"Warning: Test fixture not found: {fixture_path}")
            return test_cases
        
        with open(fixture_path, 'r') as f:
            reader = csv.DictReader(f)
            for row in reader:
                test_cases.append(row)
        
        return test_cases
    
    def test_multi_level_processing(self) -> Dict:
        """
        Test multi-level directory processing for all test cases.
        
        Returns:
            Dict: Test results summary.
        """
        print("Testing Multi-Level Directory Processing")
        print("=" * 50)
        
        results = {
            'total': len(self.test_cases),
            'passed': 0,
            'failed': 0,
            'errors': []
        }
        
        for i, test_case in enumerate(self.test_cases, 1):
            print(f"\nTest Case {i}: {test_case['test_case']}")
            print(f"Description: {test_case['description']}")
            print(f"Input: {test_case['full_path']}")
            
            try:
                # Extract components from the full path
                components = self._extract_components_from_path(
                    test_case['full_path'], 
                    test_case['person_name']
                )
                
                if not components:
                    error_msg = f"Failed to extract components from {test_case['full_path']}"
                    results['errors'].append(error_msg)
                    results['failed'] += 1
                    print(f"❌ {error_msg}")
                    continue
                
                # Format the expected filename
                expected_filename = test_case['expected_filename']
                actual_filename = self._format_filename(components)
                
                # Compare results
                if self._compare_results(test_case, components, actual_filename):
                    results['passed'] += 1
                    print(f"✅ PASSED")
                else:
                    results['failed'] += 1
                    print(f"❌ FAILED")
                
            except Exception as e:
                error_msg = f"Error processing test case {test_case['test_case']}: {e}"
                results['errors'].append(error_msg)
                results['failed'] += 1
                print(f"❌ {error_msg}")
        
        return results
    
    def _extract_components_from_path(self, full_path: str, person_name: str) -> Dict:
        """
        Extract components from a full path string.
        
        Args:
            full_path: The full path string to process.
            person_name: The person name for matching.
            
        Returns:
            Dict: Extracted components dictionary.
        """
        # Create a mock filepath for testing
        filepath = Path(full_path)
        filename = filepath.name
        
        # Create folder info structure
        folder_info = {
            'full_path_string': full_path,
            'folder_only_string': str(filepath.parent),
            'year_folders': [],
            'date_folders': [],
            'folder_date': None,
            'relative_path': full_path
        }
        
        # Extract components using the renamer
        components = self.renamer.extract_file_components(filename, person_name, folder_info)
        return components
    
    def _format_filename(self, components: Dict) -> str:
        """
        Format filename from components.
        
        Args:
            components: Extracted components dictionary.
            
        Returns:
            str: Formatted filename.
        """
        # Get file extension
        original_filename = components['filename']
        file_ext = Path(original_filename).suffix
        
        # Format using the renamer's method
        formatted = self.renamer.format_normalized_filename(components)
        
        # Ensure extension is preserved
        if not formatted.endswith(file_ext):
            formatted += file_ext
        
        return formatted
    
    def _compare_results(self, test_case: Dict, components: Dict, actual_filename: str) -> bool:
        """
        Compare test results with expected values.
        
        Args:
            test_case: Test case dictionary.
            components: Extracted components.
            actual_filename: Actual formatted filename.
            
        Returns:
            bool: True if all comparisons pass, False otherwise.
        """
        expected_filename = test_case['expected_filename']
        expected_user_id = test_case['expected_user_id']
        expected_name = test_case['expected_name']
        expected_remainder = test_case['expected_remainder']
        expected_date = test_case['expected_date']
        
        # Compare user ID
        actual_user_id = components.get('user_id', '')
        if str(actual_user_id) != expected_user_id:
            print(f"  User ID mismatch: expected {expected_user_id}, got {actual_user_id}")
            return False
        
        # Compare name
        actual_name = components.get('extracted_name', '')
        if actual_name != expected_name:
            print(f"  Name mismatch: expected '{expected_name}', got '{actual_name}'")
            return False
        
        # Compare remainder
        actual_remainder = components.get('cleaned_remainder', '')
        if actual_remainder != expected_remainder:
            print(f"  Remainder mismatch: expected '{expected_remainder}', got '{actual_remainder}'")
            return False
        
        # Compare date
        actual_date = components.get('extracted_date', '')
        if actual_date != expected_date:
            print(f"  Date mismatch: expected '{expected_date}', got '{actual_date}'")
            return False
        
        # Compare final filename
        if actual_filename != expected_filename:
            print(f"  Filename mismatch:")
            print(f"    Expected: {expected_filename}")
            print(f"    Actual:   {actual_filename}")
            return False
        
        return True
    
    def print_summary(self, results: Dict):
        """
        Print test results summary.
        
        Args:
            results: Test results dictionary.
        """
        print("\n" + "=" * 50)
        print("MULTI-LEVEL DIRECTORY PROCESSING TEST SUMMARY")
        print("=" * 50)
        print(f"Total Tests: {results['total']}")
        print(f"Passed: {results['passed']}")
        print(f"Failed: {results['failed']}")
        
        if results['errors']:
            print(f"\nErrors:")
            for error in results['errors']:
                print(f"  - {error}")
        
        success_rate = (results['passed'] / results['total']) * 100 if results['total'] > 0 else 0
        print(f"\nSuccess Rate: {success_rate:.1f}%")
        
        if results['failed'] == 0:
            print("🎉 All tests passed!")
        else:
            print("⚠️  Some tests failed. Please review the output above.")


def main():
    """Main test runner."""
    tester = MultiLevelDirectoryTester()
    results = tester.test_multi_level_processing()
    tester.print_summary(results)
    
    # Exit with error code if any tests failed
    if results['failed'] > 0:
        sys.exit(1)


if __name__ == "__main__":
    main() 