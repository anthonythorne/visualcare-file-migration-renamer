#!/usr/bin/env python3

"""
VisualCare File Migration Renamer - Demo Script

This script demonstrates all the features of the file migration renamer system,
including name extraction, date extraction, user ID mapping, and filename formatting.
"""

import sys
from pathlib import Path

# Add core/utils to path for imports
sys.path.insert(0, str(Path(__file__).parent / 'core' / 'utils'))

from name_matcher import extract_name_and_date_from_filename, clean_filename_remainder_py
from user_mapping import get_user_id_by_name, format_filename_with_id, load_user_mapping
from date_matcher import extract_date_matches


def demo_name_extraction():
    """Demonstrate name extraction functionality."""
    print("=== Name Extraction Demo ===")
    
    test_cases = [
        ("John_Doe_2023-05-15_Report.pdf", "john doe"),
        ("jane-smith-proposal.docx", "jane smith"),
        ("bob.johnson.2023.10.05.receipt.pdf", "bob johnson"),
        ("jsmith_final_report_2024-01-15.pdf", "jane smith"),
        ("F016 Sarah Support Plan 16.04.23 - v5.0.docx", "sarah smith"),
    ]
    
    for filename, name_to_match in test_cases:
        print(f"\nFilename: {filename}")
        print(f"Name to match: {name_to_match}")
        
        result = extract_name_and_date_from_filename(filename, name_to_match)
        extracted_name, extracted_date, raw_remainder, name_matched, date_matched = result.split('|')
        
        print(f"  Extracted name: {extracted_name}")
        print(f"  Extracted date: {extracted_date}")
        print(f"  Raw remainder: {raw_remainder}")
        print(f"  Name matched: {name_matched}")
        print(f"  Date matched: {date_matched}")
        
        # Clean remainder
        cleaned_remainder = clean_filename_remainder_py(raw_remainder)
        print(f"  Cleaned remainder: {cleaned_remainder}")


def demo_user_mapping():
    """Demonstrate user ID mapping functionality."""
    print("\n=== User ID Mapping Demo ===")
    
    test_names = ["John Doe", "Jane Smith", "Bob Johnson", "Sarah Smith", "Unknown Person"]
    
    for name in test_names:
        user_id = get_user_id_by_name(name)
        print(f"Name: {name} -> User ID: {user_id}")
    
    # Show all mappings
    print("\nAll user mappings:")
    user_mapping = load_user_mapping()
    for user_id, full_name in user_mapping.items():
        print(f"  {user_id}: {full_name}")


def demo_filename_formatting():
    """Demonstrate filename formatting functionality."""
    print("\n=== Filename Formatting Demo ===")
    
    test_cases = [
        {
            'user_id': '1001',
            'name': 'John Doe',
            'date': '2023-05-15',
            'remainder': 'Report',
            'category': '',
            'management_flag': ''
        },
        {
            'user_id': '1004',
            'name': 'Sarah Smith',
            'date': '2023-04-16',
            'remainder': 'F016 Support Plan v5.0',
            'category': '',
            'management_flag': ''
        },
        {
            'user_id': '1002',
            'name': 'Jane Smith',
            'date': '',
            'remainder': 'proposal',
            'category': '',
            'management_flag': 'MGMT'
        }
    ]
    
    for i, case in enumerate(test_cases, 1):
        print(f"\nCase {i}:")
        print(f"  User ID: {case['user_id']}")
        print(f"  Name: {case['name']}")
        print(f"  Date: {case['date']}")
        print(f"  Remainder: {case['remainder']}")
        print(f"  Management Flag: {case['management_flag']}")
        
        formatted = format_filename_with_id(
            user_id=case['user_id'],
            name=case['name'],
            date=case['date'],
            remainder=case['remainder'],
            category=case['category'],
            management_flag=case['management_flag']
        )
        print(f"  Formatted: {formatted}")


def demo_real_world_examples():
    """Demonstrate real-world examples from the original quote."""
    print("\n=== Real-World Examples Demo ===")
    
    examples = [
        {
            'original': 'F016 Sarah Support Plan 16.04.23 - v5.0.docx',
            'name': 'sarah smith',
            'expected': '1234_Sarah Smith_F016SarahSupportPlanV5.0_20230416.docx'
        },
        {
            'original': 'Hazard Report - Crates under legs of lounge - Sarah Smith.pdf',
            'name': 'sarah smith',
            'expected': '1234_Sarah Smith_HazardReportCratesUnderLegsofLounge_20230512.pdf'
        }
    ]
    
    for example in examples:
        print(f"\nOriginal: {example['original']}")
        print(f"Name: {example['name']}")
        print(f"Expected: {example['expected']}")
        
        # Extract components
        result = extract_name_and_date_from_filename(example['original'], example['name'])
        extracted_name, extracted_date, raw_remainder, name_matched, date_matched = result.split('|')
        
        # Clean remainder
        cleaned_remainder = clean_filename_remainder_py(raw_remainder)
        
        # Get user ID
        user_id = get_user_id_by_name(example['name'])
        
        # Format filename
        normalized_name = extracted_name.replace(',', ' ') if extracted_name else ""
        formatted = format_filename_with_id(
            user_id=user_id or "",
            name=normalized_name,
            date=extracted_date or "",
            remainder=cleaned_remainder,
            category="",
            management_flag=""
        )
        
        # Add extension
        original_ext = Path(example['original']).suffix
        if not formatted.endswith(original_ext):
            formatted += original_ext
        
        print(f"Actual: {formatted}")
        print(f"Match: {'✓' if formatted == example['expected'] else '✗'}")


def demo_management_detection():
    """Demonstrate management flag detection."""
    print("\n=== Management Flag Detection Demo ===")
    
    management_files = [
        "management_report_2023-12-01.pdf",
        "admin_notes_2024-01-15.txt",
        "supervisor_review_2023-11-30.docx",
        "regular_report_2023-10-15.pdf"
    ]
    
    for filename in management_files:
        filename_lower = filename.lower()
        keywords = ["management", "admin", "supervisor"]
        is_management = any(keyword in filename_lower for keyword in keywords)
        
        print(f"File: {filename}")
        print(f"  Management: {'Yes' if is_management else 'No'}")
        if is_management:
            print(f"  Flag: MGMT")


def main():
    """Run all demos."""
    print("VisualCare File Migration Renamer - Feature Demo")
    print("=" * 50)
    
    try:
        demo_name_extraction()
        demo_user_mapping()
        demo_filename_formatting()
        demo_real_world_examples()
        demo_management_detection()
        
        print("\n" + "=" * 50)
        print("Demo completed successfully!")
        
    except Exception as e:
        print(f"Error during demo: {e}")
        sys.exit(1)


if __name__ == "__main__":
    main() 