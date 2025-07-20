#!/usr/bin/env python3
"""
Setup script for basic test files.

Creates test files for the basic test scenario with John Doe and Jane Smith.
"""

import os
from pathlib import Path

def setup_basic_test_files():
    """Create test files for the basic test scenario."""
    print("Setting up Basic Test Files")
    print("=" * 50)
    
    # Get the project root directory
    project_root = Path(__file__).parent.parent.parent
    test_files_dir = project_root / 'tests' / 'test-files'
    from_dir = test_files_dir / 'from-basic'
    to_dir = test_files_dir / 'to-basic'
    
    # Create directories
    print(f"Creating directory: {from_dir}")
    from_dir.mkdir(parents=True, exist_ok=True)
    print(f"Creating directory: {to_dir}")
    to_dir.mkdir(parents=True, exist_ok=True)
    
    # Clean up existing test files
    def cleanup_existing_files(directory):
        if directory.exists():
            for item in directory.iterdir():
                if item.is_file():
                    item.unlink()
                elif item.is_dir():
                    import shutil
                    shutil.rmtree(item)
    
    cleanup_existing_files(from_dir)
    # Note: Output directory is preserved for inspection
    
    # Test files to create
    test_files = [
        # John Doe files
        ("John Doe", "John_Doe_2023-05-15_Report.pdf"),
        ("John Doe", "john-doe-20240101-invoice.docx"),
        ("John Doe", "2022-12-31_John_Doe_summary.txt"),
        
        # Jane Smith files  
        ("Jane Smith", "jane-smith-20240101-invoice.docx"),
        ("Jane Smith", "Jane_Smith_2023-06-20_Report.pdf"),
        ("Jane Smith", "2023-01-15_jane_smith_notes.txt"),
        
        # Temp Person files (for other tests)
        ("Temp Person", "test_file.txt"),
        
        # Additional test file to demonstrate dynamic counting
        ("John Doe", "John_Doe_2024-03-15_Additional_Report.pdf"),
    ]
    
    # Create test files
    for person, filename in test_files:
        person_dir = from_dir / person
        person_dir.mkdir(parents=True, exist_ok=True)
        
        file_path = person_dir / filename
        with open(file_path, 'w') as f:
            f.write(f"Test content for {filename}")
        
        print(f"✅ Created: {person}/{filename}")
    
    print(f"\nCreated {len(test_files)} test files")
    print(f"Test files location: {from_dir}")
    print()
    print("To run the basic test:")
    print("python3 main.py --test-mode --test-name basic --dry-run")
    print()
    print("To run with actual processing:")
    print("python3 main.py --test-mode --test-name basic")

if __name__ == "__main__":
    setup_basic_test_files() 