#!/usr/bin/env python3

"""
VisualCare File Migration Renamer - Main Application.

This module provides the main CLI interface and core processing logic for
renaming files based on extracted names, dates, and user IDs.

File Path: main.py

@package VisualCare\\FileMigration
@since   1.0.0

Features:
- CSV-based file mapping and processing
- Multi-level directory support
- Name and date extraction from filenames
- User ID mapping and validation
- Test mode for validation and debugging
- Dry-run mode for previewing changes
"""

import argparse
import csv
import logging
import os
import shutil
import sys
import yaml
from datetime import datetime
from pathlib import Path
from typing import Dict, List, Optional
import re

from core.utils.user_mapping import extract_user_from_path
from core.utils.date_matcher import extract_date_matches


class FileMigrationRenamer:
    """Main class for handling file migration and renaming operations."""
    
    def __init__(self, config_path: Optional[str] = None):
        """
        Initialize the FileMigrationRenamer.
        
        Args:
            config_path: Optional path to configuration file
        """
        self.config = self._load_config(config_path)
        self.logger = self._setup_logging()
        
    def _load_config(self, config_path: Optional[str] = None) -> Dict:
        """
        Load configuration from YAML file.
        
        Args:
            config_path: Optional path to configuration file
        
        Returns:
            Dict: Configuration dictionary
        """
        if config_path is None:
            config_path = str(Path(__file__).parent / 'config' / 'components.yaml')
        
        try:
            with open(config_path, 'r') as f:
                return yaml.safe_load(f)
        except Exception as e:
            print(f"Error loading configuration from {config_path}: {e}")
            sys.exit(1)
    
    def _setup_logging(self) -> logging.Logger:
        """Set up logging configuration."""
        logging.basicConfig(
            level=logging.INFO,
            format='%(asctime)s - %(levelname)s - %(message)s'
        )
        return logging.getLogger(__name__)
    
    def process_directory(self, input_dir: str, output_dir: str, user_mapping: Dict[str, str], 
                         category_mapping: Dict[str, str], duplicate: bool = True, exclude_management_flag: bool = False) -> List[Dict]:
        """
        Process all files in a directory with multi-level support.
        
        Args:
            input_dir: Input directory path
            output_dir: Output directory path
            user_mapping: Dictionary mapping full names to user IDs
            category_mapping: Dictionary mapping category names to category IDs
            duplicate: If True, copy files; if False, move files
            
        Returns:
            List of processing results
        """
        results = []
        input_path = Path(input_dir)
        output_path = Path(output_dir)
        
        if not input_path.exists():
            results.append({'error': f"Input directory not found: {input_dir}"})
            return results
        
        # Create output directory if it doesn't exist
            output_path.mkdir(parents=True, exist_ok=True)
        
        # Get all files recursively
        for filepath in input_path.rglob('*'):
            if filepath.is_file():
                # Check if file should be excluded
                filename = filepath.name
                should_exclude = False
                
                # Load config to get exclusions
                config = load_config()
                exclusions = config.get('Global', {}).get('file_exclusions', [])
                
                for exclusion in exclusions:
                    if exclusion.startswith('*') and exclusion.endswith('*'):
                        # Pattern like "*tmp*"
                        pattern = exclusion[1:-1]
                        if pattern in filename:
                            should_exclude = True
                            break
                    elif exclusion.startswith('*'):
                        # Pattern like "*.tmp"
                        pattern = exclusion[1:]
                        if filename.endswith(pattern):
                            should_exclude = True
                            break
                    elif exclusion.endswith('*'):
                        # Pattern like "~$*"
                        pattern = exclusion[:-1]
                        if filename.startswith(pattern):
                            should_exclude = True
                            break
                    else:
                        # Exact match
                        if filename == exclusion:
                            should_exclude = True
                            break
                
                if should_exclude:
                    self.logger.info(f"Skipping excluded file: {filename}")
                    continue
            
                # Debug: Log files that are being processed
                if filename == "desktop.ini":
                    self.logger.warning(f"Processing desktop.ini file: {filepath}")
                    self.logger.warning(f"Exclusions: {exclusions}")
                    self.logger.warning(f"Filename: '{filename}'")
                
                # Get relative path from input directory
                relative_path = filepath.relative_to(input_path)
                
                # Use the real normalize_filename function
                try:
                    # Extract person name and management status from the original path
                    person_directory = relative_path.parts[0] if relative_path.parts else ""
                    
                    # Use the user_mapping function to get cleaned name and management status
                    from core.utils.user_mapping import extract_user_from_path
                    user_result = extract_user_from_path(str(relative_path))
                    user_parts = user_result.split('|')
                    cleaned_person_name = user_parts[2] if len(user_parts) > 2 else person_directory
                    is_management_folder = user_parts[5] == 'True' if len(user_parts) > 5 else False
                    
                    normalized_filename = normalize_filename(str(relative_path), user_mapping, category_mapping, str(filepath), is_management_folder, exclude_management_flag)
            
                    result = {
                        'original_filename': str(relative_path),
                        'new_filename': normalized_filename,
                        'person': cleaned_person_name,
                        'success': True
                    }
            
                    try:
                        # Create person subdirectory in output using cleaned name
                        person_output_dir = output_path / cleaned_person_name
                        person_output_dir.mkdir(parents=True, exist_ok=True)
                        
                        # Capture original file times before processing
                        orig_stat = filepath.stat()
                        orig_mtime = orig_stat.st_mtime
                        orig_atime = orig_stat.st_atime
                        
                        # Process file (copy or move)
                        new_filepath = person_output_dir / normalized_filename
                        if duplicate:
                            shutil.copy2(filepath, new_filepath)
                            result['copied'] = True
                            self.logger.info(f"Copied: {relative_path} -> {cleaned_person_name}/{normalized_filename}")
                        else:
                            filepath.rename(new_filepath)
                            result['moved'] = True
                            self.logger.info(f"Moved: {relative_path} -> {cleaned_person_name}/{normalized_filename}")
                        
                        # Restore original times on the new file (ignore errors for Windows files)
                        try:
                            os.utime(new_filepath, (orig_atime, orig_mtime))
                        except OSError as e:
                            # Windows files might not allow timestamp modification, but that's okay
                            self.logger.warning(f"Could not restore timestamps for {relative_path}: {e}")
                            # Continue processing - the file was still copied/moved successfully
                    except Exception as e:
                        result['error'] = f"Failed to process {relative_path}: {e}"
                        result['success'] = False
                        self.logger.error(result['error'])
            
                    results.append(result)
                    
                except Exception as e:
                    result = {
                        'original_filename': str(relative_path),
                        'error': f"Failed to normalize filename: {e}",
                        'success': False
                    }
                    results.append(result)
                    self.logger.error(f"Error processing {relative_path}: {e}")
        
        return results
    
    def process_test_files(self, duplicate: bool = False, person_filter: Optional[str] = None, test_name: str = "basic", exclude_management_flag: bool = False) -> List[Dict]:
        """
        Process files using the tests/test-files structure with multi-level support.
        Args:
            duplicate: If True, duplicate (copy) the file before renaming; if False, move/rename the original.
            person_filter: If specified, only process files for this person
            test_name: Name of the test (determines input directory: from-<test_name> and output directory: to-<test_name>)
        Returns:
            List of processing results
        """
        import shutil
        import os
        results = []
        test_files_dir = Path(__file__).parent / 'tests' / 'test-files'
        from_dir = test_files_dir / f'from-{test_name}'
        to_dir = test_files_dir / f'to-{test_name}'
        if not from_dir.exists():
            results.append({'error': f"Test files directory not found: {from_dir}"})
            return results
        person_dirs = [d for d in from_dir.iterdir() if d.is_dir()]
        if person_filter:
            person_dirs = [d for d in person_dirs if person_filter.lower() in d.name.lower()]
        for person_dir in person_dirs:
            person_name = person_dir.name
            self.logger.info(f"Processing person: {person_name}")
            
            # Get cleaned person name for output directory
            from core.utils.user_mapping import extract_user_from_path
            user_result = extract_user_from_path(person_name)
            user_parts = user_result.split('|')
            cleaned_person_name = user_parts[2] if len(user_parts) > 2 else person_name
            
            output_person_dir = to_dir / cleaned_person_name
            output_person_dir.mkdir(parents=True, exist_ok=True)
            
            # Process all files in the person directory
            for filepath in person_dir.rglob('*'):
                if filepath.is_file():
                    # Get relative path from person directory
                    relative_path = filepath.relative_to(person_dir)
                    full_relative_path = f"{person_name}/{relative_path}"
                    
                    try:
                        # Extract person name and management status from the original path
                        person_directory = person_name
                        
                        # Use the user_mapping function to get cleaned name and management status
                        from core.utils.user_mapping import extract_user_from_path
                        user_result = extract_user_from_path(str(full_relative_path))
                        user_parts = user_result.split('|')
                        cleaned_person_name = user_parts[2] if len(user_parts) > 2 else person_directory
                        is_management_folder = user_parts[5] == 'True' if len(user_parts) > 5 else False
                        
                        # Use the real normalize_filename function
                        normalized_filename = normalize_filename(str(full_relative_path), is_management_folder=is_management_folder, exclude_management_flag=exclude_management_flag)
                        
                        result = {
                            'person': cleaned_person_name,
                            'original_filename': str(relative_path),
                            'new_filename': normalized_filename,
                            'success': True,
                            'test_name': test_name
                        }
                        
                        try:
                            new_filepath = output_person_dir / normalized_filename
                            orig_stat = filepath.stat()
                            orig_mtime = orig_stat.st_mtime
                            orig_atime = orig_stat.st_atime
                            if duplicate:
                                shutil.copy2(filepath, new_filepath)
                                result['copied'] = True
                                self.logger.info(f"Copied: {person_name}/{relative_path} -> {test_name}/{cleaned_person_name}/{normalized_filename}")
                            else:
                                filepath.rename(new_filepath)
                                result['moved'] = True
                                self.logger.info(f"Moved: {person_name}/{relative_path} -> {test_name}/{cleaned_person_name}/{normalized_filename}")
                            # Restore original times on the new file
                            os.utime(new_filepath, (orig_atime, orig_mtime))
                        except Exception as e:
                            result['error'] = f"Failed to process {relative_path}: {e}"
                            result['success'] = False
                            self.logger.error(result['error'])
                        
                        results.append(result)
                        
                    except Exception as e:
                        result = {
                            'person': cleaned_person_name,
                            'original_filename': str(relative_path),
                            'error': f"Failed to normalize filename: {e}",
                            'success': False,
                            'test_name': test_name
                        }
                        results.append(result)
                        self.logger.error(f"Error processing {relative_path}: {e}")
        
        return results
    
    def print_summary(self, results: List[Dict]):
        """Print a summary of processing results."""
        total = len(results)
        successful = sum(1 for r in results if r.get('success', False))
        errors = sum(1 for r in results if 'error' in r)
        
        print(f"\n=== Processing Summary ===")
        print(f"Total files: {total}")
        print(f"Successful: {successful}")
        print(f"Errors: {errors}")
        
        if errors > 0:
            print(f"\n=== Errors ===")
            for result in results:
                if 'error' in result:
                    print(f"- {result['error']}")
        
        # Show person breakdown for test mode
        if any('person' in result for result in results):
            print(f"\n=== Person Breakdown ===")
            person_counts = {}
            test_names = set()
            for result in results:
                if 'person' in result:
                    person = result['person']
                    person_counts[person] = person_counts.get(person, 0) + 1
                    if 'test_name' in result:
                        test_names.add(result['test_name'])
            
            for person, count in person_counts.items():
                print(f"{person}: {count} files")
            
            if test_names:
                print(f"\nTest output directories: {', '.join(f'to-{name}' for name in test_names)}")


def normalize_filename(full_path: str, user_mapping: Dict[str, str] = None, category_mapping: Dict[str, str] = None, full_file_path: str = None, is_management_folder: bool = False, exclude_management_flag: bool = False) -> str:
    """
    Normalize a filename from a full path using existing core functions.
    This is the main function for real-world applications.
    
    Sequential extraction order:
    1. Category extraction (first directory after person)
    2. Name extraction (from remainder)
    3. Date extraction (from remainder)
    4. Final assembly (clean remainder, assemble filename)
    
    Args:
        full_path: Full path to the file (e.g., "John Doe/report.pdf" or "VC - John Doe/document.pdf")
        user_mapping: Dictionary mapping full names to user IDs (optional)
        category_mapping: Dictionary mapping category names to category IDs (optional)
        
    Returns:
        Normalized filename string
    """
    from pathlib import Path
    from core.utils.name_matcher import clean_filename_remainder_py
    from core.utils.date_matcher import extract_date_matches
    import subprocess
    import os
    
    # Parse the path
    path_obj = Path(full_path)
    path_parts = path_obj.parts
    
    # Get the file extension early and remove it from processing
    file_extension = path_obj.suffix if path_obj.suffix else ""
    
    # Initialize components
    user_id = ""
    cleaned_name = ""
    extracted_category = ""
    extracted_date = ""
    raw_remainder = full_path
    
    # Remove file extension from raw_remainder for processing
    if file_extension and raw_remainder.endswith(file_extension):
        raw_remainder = raw_remainder[:-len(file_extension)]
    
    # STEP 1: Extract person name from first directory using existing user_mapping function
    if len(path_parts) > 0:
        person_directory = path_parts[0]
        
        # Use the existing user_mapping function
        from core.utils.user_mapping import extract_user_from_path
        user_result = extract_user_from_path(full_path)
        user_parts = user_result.split('|')
        user_id = user_parts[0] if len(user_parts) > 0 else ""
        cleaned_name = user_parts[2] if len(user_parts) > 2 else ""
        
        # Determine management status from the user extraction result
        is_management_folder = user_parts[5] == 'True' if len(user_parts) > 5 else False
        
        # Use provided user mapping if available
        if user_mapping and cleaned_name in user_mapping:
            user_id = user_mapping[cleaned_name]
        
        # Get the raw remainder after person extraction
        raw_remainder = user_parts[3] if len(user_parts) > 3 else ""  # raw_remainder from user extraction
        
        # Remove file extension from raw_remainder if it's still there
        if file_extension and raw_remainder.endswith(file_extension):
            raw_remainder = raw_remainder[:-len(file_extension)]
    
    # STEP 2: Extract category using existing category_processor function
    if raw_remainder:
        # Use the existing category_processor function
        project_root = Path(__file__).parent
        try:
            category_result = subprocess.check_output([
                'python3',
                str(project_root / 'core/utils/category_processor.py'),
                full_path
            ], text=True, stderr=subprocess.DEVNULL).strip()
            category_parts = category_result.split('|')
            extracted_category = category_parts[0] if len(category_parts) > 0 else ""
            
            # Get the raw remainder after category extraction
            raw_remainder = category_parts[3] if len(category_parts) > 3 else ""  # raw_remainder from category extraction
            
            # Remove file extension from raw_remainder if it's still there
            if file_extension and raw_remainder.endswith(file_extension):
                raw_remainder = raw_remainder[:-len(file_extension)]
        except:
            extracted_category = ""
    
    # STEP 3: Extract name from remainder using existing name_matcher function
    if raw_remainder and cleaned_name:
        from core.utils.name_matcher import extract_name_from_filename
        name_result = extract_name_from_filename(raw_remainder, cleaned_name)
        name_parts = name_result.split('|')
        if len(name_parts) > 1:
            # Use the canonical name from the name matcher if available
            canonical_name = name_parts[0].replace(',', ' ').strip()
            if canonical_name and canonical_name.lower() != cleaned_name.lower():
                cleaned_name = canonical_name
            # Use the remainder after name extraction
            raw_remainder = name_parts[1]
            # Remove file extension from raw_remainder if it's still there
            if file_extension and raw_remainder.endswith(file_extension):
                raw_remainder = raw_remainder[:-len(file_extension)]
    
    # STEP 4: Extract date from remainder using existing date_matcher function
    if raw_remainder:
        # Use the existing date_matcher function
        date_result = extract_date_matches(raw_remainder)
        date_parts = date_result.split('|')
        if date_parts[0]:  # If date found
            extracted_date = date_parts[0]
            # Update remainder to remove the date
            if len(date_parts) > 1:
                raw_remainder = date_parts[1]  # This is the remainder with date removed
                
                # Remove file extension from raw_remainder if it's still there
                if file_extension and raw_remainder.endswith(file_extension):
                    raw_remainder = raw_remainder[:-len(file_extension)]
        else:
            # No date found in filename, try file metadata if we have the full path
            from core.utils.date_matcher import extract_date_with_metadata_fallback
            # Use the original filename (before name extraction) for metadata fallback
            original_filename = path_obj.name
            # Use full_file_path if provided, otherwise use full_path (which might be relative)
            file_path_for_metadata = full_file_path if full_file_path else full_path
            metadata_result = extract_date_with_metadata_fallback(original_filename, file_path_for_metadata)
            metadata_parts = metadata_result.split('|')
            if metadata_parts[0]:  # If metadata date found
                extracted_date = metadata_parts[0]
                # Keep the original remainder since metadata date doesn't change the filename
                # raw_remainder stays the same
    
    # STEP 5: Clean the final remainder using existing name_matcher function
    cleaned_remainder = clean_filename_remainder_py(raw_remainder) if raw_remainder else ""
    
    # Determine management flag based on configuration
    config = load_config()
    management_flag = ""
    if is_management_folder:
        management_config = config.get('ManagementFlag', {})
        if management_config.get('enabled', True):
            management_flag = management_config.get('no_flag', '_no')
    else:
        management_config = config.get('ManagementFlag', {})
        if management_config.get('enabled', True):
            management_flag = management_config.get('yes_flag', '_yes')
    
    # Format the final filename using existing format_filename function
    formatted = format_filename(
        user_id=user_id,
        name=cleaned_name,
        remainder=cleaned_remainder,
        date=extracted_date,
        category=extracted_category,
        management_flag=management_flag,
        exclude_management_flag=exclude_management_flag
    )
    
    # Add the file extension
    if file_extension:
        formatted += file_extension
    
    return formatted


def format_filename(user_id: str = "", name: str = "", remainder: str = "", date: str = "", category: str = "", management_flag: str = "", exclude_management_flag: bool = False) -> str:
    """
    Format a filename using the global component order and separator configuration.
    
    Args:
        user_id: User ID component
        name: Name component  
        remainder: Remainder component
        date: Date component
        category: Category component
        management_flag: Management flag component
        exclude_management_flag: Whether to exclude the management flag
        
    Returns:
        Formatted filename string
    """
    config = load_config()
    global_config = config.get('Global', {})
    component_order = global_config.get('component_order', ['id', 'name', 'remainder', 'date', 'category', 'management'])
    component_separator = global_config.get('component_separator', '_')
    
    # Build filename using component order
    filename_parts = []
    for component in component_order:
        if component == 'id':
            value = user_id
        elif component == 'name':
            value = name
        elif component == 'remainder':
            value = remainder
        elif component == 'date':
            value = date
        elif component == 'category':
            value = category
        elif component == 'management':
            # Skip management component if exclude_management_flag is True
            if exclude_management_flag:
                continue
            value = management_flag
        else:
            value = ""
        
        # Only add non-empty components
        if value:
            filename_parts.append(value)
    
    # Join with component separator
    formatted = component_separator.join(filename_parts)
    
    # Clean up any duplicate separators
    import re
    formatted = re.sub(f'{re.escape(component_separator)}+', component_separator, formatted)
    formatted = formatted.strip(component_separator)
    
    return formatted


def load_config() -> Dict:
    """Load configuration from components.yaml."""
    config_path = Path(__file__).parent / 'config' / 'components.yaml'
    with open(config_path, 'r') as f:
        return yaml.safe_load(f)


def main():
    """Main CLI entry point."""
    parser = argparse.ArgumentParser(
        description="VisualCare File Migration Renamer - Process and normalize files in directories"
    )
    
    # Core arguments for directory processing
    parser.add_argument(
        '--input-dir',
        help='Input directory containing files to process'
    )
    parser.add_argument(
        '--output-dir',
        help='Output directory for processed files'
    )
    parser.add_argument(
        '--user-mapping',
        help='CSV file with user ID to name mappings (optional)'
    )
    parser.add_argument(
        '--category-mapping',
        help='CSV file with category mappings (optional)'
    )
    parser.add_argument(
        '--duplicate',
        action='store_true',
        help='Copy files instead of moving them (default: move/rename)'
    )
    parser.add_argument(
        '--exclude-management-flag',
        action='store_true',
        help='Exclude management flag from filenames (default: include management flag)'
    )
    parser.add_argument(
        '--verbose', '-v',
        action='store_true',
        help='Enable detailed logging'
    )
    
    # Test mode arguments
    parser.add_argument(
        '--test-mode',
        action='store_true',
        help='Run in test mode using predefined test files'
    )
    parser.add_argument(
        '--person-filter',
        help='Filter to specific person directory (for test mode)'
    )
    parser.add_argument(
        '--test-name',
        default='basic',
        help='Test name for output directory (for test mode)'
    )
    
    # Single file processing for testing
    parser.add_argument(
        '--extract-filename',
        help='Extract normalized filename from a single file path (for testing)'
    )
    
    args = parser.parse_args()
    
    if args.verbose:
        logging.getLogger().setLevel(logging.DEBUG)
    
    renamer = FileMigrationRenamer()
    
    # Handle single file extraction for testing
    if args.extract_filename:
        try:
            # Load user mapping
            user_mapping = {}
            user_mapping_file = Path(__file__).parent / 'tests' / 'fixtures' / '05_user_mapping.csv'
            if user_mapping_file.exists():
                with open(user_mapping_file, 'r') as f:
                    reader = csv.DictReader(f)
                    for row in reader:
                        user_id = row.get('user_id', '').strip()
                        full_name = row.get('full_name', '').strip()
                        if user_id and full_name:
                            user_mapping[full_name] = user_id
            
            # Load category mapping
            category_mapping = {}
            category_mapping_file = Path(__file__).parent / 'tests' / 'fixtures' / '04_category_mapping.csv'
            if category_mapping_file.exists():
                with open(category_mapping_file, 'r') as f:
                    reader = csv.DictReader(f)
                    for row in reader:
                        category_id = row.get('category_id', '').strip()
                        category_name = row.get('category_name', '').strip()
                        if category_id and category_name:
                            category_mapping[category_name] = category_id
            
            # Extract normalized filename
            result = normalize_filename(args.extract_filename, user_mapping, category_mapping)
            print(result)
            sys.exit(0)
        except Exception as e:
            print(f"Error extracting filename: {e}")
            sys.exit(1)
    
    if args.test_mode:
        print(f"Processing test files using tests/test-files structure")
        print(f"Test name: {args.test_name}")
        if args.person_filter:
            print(f"Filtering to person: {args.person_filter}")
        results = renamer.process_test_files(duplicate=args.duplicate, person_filter=args.person_filter, test_name=args.test_name, exclude_management_flag=args.exclude_management_flag)
        renamer.print_summary(results)
    elif args.input_dir and args.output_dir:
        # Load user mapping if provided
        user_mapping = {}
        if args.user_mapping:
            try:
                with open(args.user_mapping, 'r') as f:
                    reader = csv.DictReader(f)
                    for row in reader:
                        user_id = row.get('user_id', '').strip()
                        full_name = row.get('full_name', '').strip()
                        if user_id and full_name:
                            user_mapping[full_name] = user_id
            except Exception as e:
                print(f"Error loading user mapping: {e}")
                sys.exit(1)
        
        # Load category mapping if provided
        category_mapping = {}
        if args.category_mapping:
            try:
                with open(args.category_mapping, 'r') as f:
                    reader = csv.DictReader(f)
                    for row in reader:
                        category_id = row.get('category_id', '').strip()
                        category_name = row.get('category_name', '').strip()
                        if category_id and category_name:
                            category_mapping[category_name] = category_id
            except Exception as e:
                print(f"Error loading category mapping: {e}")
                sys.exit(1)
        
        print(f"Processing directory: {args.input_dir} -> {args.output_dir}")
        results = renamer.process_directory(args.input_dir, args.output_dir, user_mapping, category_mapping, args.duplicate, args.exclude_management_flag)
        renamer.print_summary(results)
    else:
        print("Error: Must specify either --test-mode or both --input-dir and --output-dir")
        parser.print_help()
        sys.exit(1)
    
    sys.exit(0)


if __name__ == "__main__":
    main() 