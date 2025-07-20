#!/usr/bin/env python3

"""Test script to verify path extraction logic."""

import sys
from pathlib import Path

# Add core/utils to path
sys.path.insert(0, str(Path(__file__).parent / 'core' / 'utils'))

try:
    from directory_processor import DirectoryProcessor
    import yaml
    
    # Load config
    with open('config/components.yaml', 'r') as f:
        config = yaml.safe_load(f)
    
    # Create directory processor
    processor = DirectoryProcessor(config)
    
    # Test path extraction
    test_file = Path("John Doe/2023/WHS/Incidents/01.06.2023 - John Doe.pdf")
    root_path = Path(".")
    
    print("Testing our specific example:")
    print("Input: John Doe/2023/WHS/Incidents/01.06.2023 - John Doe.pdf")
    print("Expected: 1001_John Doe_2023 WHS Incidents_2023-06-01.pdf")
    print()
    
    folder_info = processor.extract_folder_path_components(test_file, root_path)
    
    print("Test Path Extraction:")
    print(f"Original file: {test_file}")
    print(f"Full path string: {folder_info['full_path_string']}")
    print(f"Folder only string: {folder_info['folder_only_string']}")
    print(f"Year folders: {folder_info['year_folders']}")
    print(f"Date folders: {folder_info['date_folders']}")
    print(f"Folder date: {folder_info['folder_date']}")
    print(f"Relative path: {folder_info['relative_path']}")
    
    # Test folder remainder processing
    name_to_match = "John Doe"
    folder_remainder = processor.process_folder_remainder(folder_info['folder_only_string'], name_to_match)
    print(f"\nFolder Remainder Processing:")
    print(f"Original folder string: {folder_info['folder_only_string']}")
    print(f"Processed folder remainder: {folder_remainder}")
    
    # Test name extraction from full path
    from name_matcher import extract_name_and_date_from_filename
    
    result = extract_name_and_date_from_filename(folder_info['full_path_string'], name_to_match)
    extracted_name, extracted_date, raw_remainder, name_matched, date_matched = result.split('|')
    
    print(f"\nName/Date Extraction from Full Path:")
    print(f"Extracted name: {extracted_name}")
    print(f"Extracted date: {extracted_date}")
    print(f"Raw remainder: {raw_remainder}")
    print(f"Name matched: {name_matched}")
    print(f"Date matched: {date_matched}")
    
    # Test combined remainder
    if folder_remainder:
        if raw_remainder:
            combined_remainder = f"{folder_remainder} {raw_remainder}"
        else:
            combined_remainder = folder_remainder
    else:
        combined_remainder = raw_remainder
    
    print(f"\nCombined Remainder:")
    print(f"Combined remainder: {combined_remainder}")
    
    # Test the full renamer process
    print(f"\nTesting Full Renamer Process:")
    try:
        from main import FileMigrationRenamer
        
        renamer = FileMigrationRenamer()
        components = renamer.extract_file_components(
            test_file.name, 
            "John Doe", 
            folder_info
        )
        
        if components:
            formatted = renamer.format_normalized_filename(components)
            print(f"Formatted filename: {formatted}")
            
            # Add extension
            final_filename = formatted + test_file.suffix
            print(f"Final filename: {final_filename}")
            
            expected = "1001_John Doe_2023 WHS Incidents_2023-06-01.pdf"
            if final_filename == expected:
                print("✅ SUCCESS: Matches expected output!")
            else:
                print("❌ FAILED: Does not match expected output")
                print(f"Expected: {expected}")
        else:
            print("❌ FAILED: Could not extract components")
    except Exception as e:
        print(f"❌ ERROR: {e}")
    
    print("\n✓ Path extraction test completed successfully!")
    
except Exception as e:
    print(f"✗ Test failed: {e}")
    import traceback
    traceback.print_exc() 