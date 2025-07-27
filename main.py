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
                         category_mapping: Dict[str, str], dry_run: bool = False) -> List[Dict]:
        """
        Process all files in a directory with multi-level support.
        
        Args:
            input_dir: Input directory path
            output_dir: Output directory path
            user_mapping: Dictionary mapping full names to user IDs
            category_mapping: Dictionary mapping category names to category IDs
            dry_run: If True, don't actually process files
            
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
        if not dry_run:
            output_path.mkdir(parents=True, exist_ok=True)
        
        # Get all files recursively
        for filepath in input_path.rglob('*'):
            if filepath.is_file():
                # Get relative path from input directory
                relative_path = filepath.relative_to(input_path)
                
                # Use the real normalize_filename function
                try:
                    normalized_filename = normalize_filename(str(relative_path), user_mapping, category_mapping)
                    
                    result = {
                        'original_filename': str(relative_path),
                        'new_filename': normalized_filename,
                        'person': relative_path.parts[0] if relative_path.parts else "",
                        'success': True
                    }
                    
                    if not dry_run:
                        try:
                            # Copy to output directory with new name
                            new_filepath = output_path / normalized_filename
                            shutil.copy2(filepath, new_filepath)
                            result['copied'] = True
                            self.logger.info(f"Copied: {relative_path} -> {normalized_filename}")
                        except Exception as e:
                            result['error'] = f"Failed to copy {relative_path}: {e}"
                            result['success'] = False
                            self.logger.error(result['error'])
                    else:
                        result['copied'] = False
                        self.logger.info(f"DRY RUN - Would copy: {relative_path} -> {normalized_filename}")
                    
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
    
    def process_test_files(self, duplicate: bool = False, person_filter: Optional[str] = None, test_name: str = "basic") -> List[Dict]:
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
            output_person_dir = to_dir / person_name
            output_person_dir.mkdir(parents=True, exist_ok=True)
            
            # Process all files in the person directory
            for filepath in person_dir.rglob('*'):
                if filepath.is_file():
                    # Get relative path from person directory
                    relative_path = filepath.relative_to(person_dir)
                    full_relative_path = f"{person_name}/{relative_path}"
                    
                    try:
                        # Use the real normalize_filename function
                        normalized_filename = normalize_filename(str(full_relative_path))
                        
                        result = {
                            'person': person_name,
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
                                self.logger.info(f"Copied: {person_name}/{relative_path} -> {test_name}/{person_name}/{normalized_filename}")
                            else:
                                filepath.rename(new_filepath)
                                result['moved'] = True
                                self.logger.info(f"Moved: {person_name}/{relative_path} -> {test_name}/{person_name}/{normalized_filename}")
                            # Restore original times on the new file
                            os.utime(new_filepath, (orig_atime, orig_mtime))
                        except Exception as e:
                            result['error'] = f"Failed to process {relative_path}: {e}"
                            result['success'] = False
                            self.logger.error(result['error'])
                        
                        results.append(result)
                        
                    except Exception as e:
                        result = {
                            'person': person_name,
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


def normalize_filename(full_path: str, user_mapping: Dict[str, str] = None, category_mapping: Dict[str, str] = None) -> str:
    """
    Normalize a filename from a full path using all extraction functions.
    This is the main function for real-world applications.
    
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
    from core.utils.category_processor import extract_category_from_path_cli
    
    # Parse the path
    path_obj = Path(full_path)
    directory = path_obj.parent.name if path_obj.parent.name else path_obj.name
    filename = path_obj.name if path_obj.parent.name else ""
    
    # Extract user information
    user_result = extract_user_from_path(full_path)
    user_parts = user_result.split('|')
    user_id = user_parts[0] if len(user_parts) > 0 else ""
    cleaned_name = user_parts[3] if len(user_parts) > 3 else ""
    cleaned_remainder = user_parts[5] if len(user_parts) > 5 else ""
    
    # Use provided user mapping if available
    if user_mapping and cleaned_name in user_mapping:
        user_id = user_mapping[cleaned_name]
    
    # Extract date from filename using the standalone date matcher
    date_result = extract_date_matches(filename)
    date_parts = date_result.split('|')
    extracted_date = date_parts[0] if len(date_parts) > 0 else ""
    
    # Extract category from directory using the CLI function
    import subprocess
    project_root = Path(__file__).parent
    category_result = subprocess.check_output([
        'python3',
        str(project_root / 'core/utils/category_processor.py'),
        full_path
    ], text=True, stderr=subprocess.DEVNULL).strip()
    category_parts = category_result.split('|')
    category = category_parts[0] if len(category_parts) > 0 else ""
    
    # Use provided category mapping if available
    if category_mapping and category in category_mapping:
        category = category_mapping[category]
    
    # Format the final filename
    return format_filename(
        user_id=user_id,
        name=cleaned_name,
        remainder=cleaned_remainder,
        date=extracted_date,
        category=category
    )


def format_filename(user_id: str = "", name: str = "", remainder: str = "", date: str = "", category: str = "") -> str:
    """
    Format a filename using the global component order and separator configuration.
    
    Args:
        user_id: User ID component
        name: Name component  
        remainder: Remainder component
        date: Date component
        category: Category component
        
    Returns:
        Formatted filename string
    """
    config = load_config()
    global_config = config.get('Global', {})
    component_order = global_config.get('component_order', ['id', 'name', 'remainder', 'date', 'category'])
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
        '--dry-run',
        action='store_true',
        help='Preview changes without making them (recommended for testing)'
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
    
    if args.test_mode:
        print(f"Processing test files using tests/test-files structure")
        print(f"Test name: {args.test_name}")
        if args.person_filter:
            print(f"Filtering to person: {args.person_filter}")
        results = renamer.process_test_files(duplicate=args.duplicate, person_filter=args.person_filter, test_name=args.test_name)
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
        results = renamer.process_directory(args.input_dir, args.output_dir, user_mapping, category_mapping, args.dry_run)
        renamer.print_summary(results)
    else:
        print("Error: Must specify either --test-mode or both --input-dir and --output-dir")
        parser.print_help()
        sys.exit(1)
    
    sys.exit(0)


if __name__ == "__main__":
    main() 