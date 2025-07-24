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
import shutil
import sys
import yaml
from datetime import datetime
from pathlib import Path
from typing import Dict, List, Optional
import re

from core.utils.category_processor import CategoryProcessor
from core.utils.directory_processor import DirectoryProcessor
from core.utils.name_matcher import extract_name_and_date_from_filename, clean_filename_remainder_py
from core.utils.user_mapping import get_user_id_by_name, format_filename_with_id


class FileMigrationRenamer:
    """Main class for handling file migration and renaming operations."""
    
    def __init__(self, config_path: Optional[str] = None):
        """
        Initialize the renamer with configuration.
        
        Args:
            config_path: Optional path to configuration file. If not provided,
                        defaults to config/components.yaml relative to script location.
        
        Raises:
            SystemExit: If configuration file cannot be loaded.
        """
        self.config_path = config_path or str(Path(__file__).parent / 'config' / 'components.yaml')
        self.config = self._load_config()
        self.logger = self._setup_logging()
        self.directory_processor = DirectoryProcessor(self.config)
        self.category_processor = CategoryProcessor(self.config)
        
    def _load_config(self) -> Dict:
        """
        Load configuration from YAML file.
        
        Returns:
            Dict: Configuration dictionary loaded from YAML file.
        
        Raises:
            SystemExit: If configuration file cannot be read or parsed.
        """
        try:
            with open(self.config_path, 'r') as f:
                return yaml.safe_load(f)
        except Exception as e:
            print(f"Error loading config: {e}")
            sys.exit(1)
    
    def _setup_logging(self) -> logging.Logger:
        """
        Setup logging configuration for the application.
        
        Configures both file and console logging with timestamp and level information.
        Log file is created as 'file_migration.log' in the current directory.
        
        Returns:
            logging.Logger: Configured logger instance for the application.
        """
        logging.basicConfig(
            level=logging.INFO,
            format='%(asctime)s - %(levelname)s - %(message)s',
            handlers=[
                logging.FileHandler('file_migration.log'),
                logging.StreamHandler(sys.stdout)
            ]
        )
        return logging.getLogger(__name__)
    
    def extract_file_components(self, filename: str, name_to_match: str, folder_info: Optional[Dict] = None) -> Dict:
        """
        Extract all components from a filename using multiple extraction algorithms.
        This method orchestrates the extraction of name, date, user ID, management flag,
        and category from a filename or full path. It uses the name_matcher, date_matcher,
        user_mapping, and directory_processor utilities to perform comprehensive extraction.
        Returns None if extraction fails completely.
        """
        try:
            # Use full path string if available, otherwise use filename
            path_to_analyze = filename
            if folder_info and folder_info.get('full_path_string'):
                path_to_analyze = folder_info['full_path_string']

            # Extract name and date using the name_matcher utility from the full path.
            result = extract_name_and_date_from_filename(path_to_analyze, name_to_match)
            extracted_name, extracted_date, raw_remainder, name_matched, date_matched = result.split('|')

            # Process folder remainder if available
            folder_remainder = None
            if folder_info and folder_info.get('folder_only_string'):
                folder_remainder = self.directory_processor.process_folder_remainder(
                    folder_info['folder_only_string'], name_to_match, folder_info.get('category_name') if folder_info and 'category_name' in folder_info else None
                )
            # Join folder remainder (after category or after person root if no category) and filename remainder
            if folder_remainder and raw_remainder:
                combined_remainder = f"{folder_remainder} {raw_remainder}"
            elif folder_remainder:
                combined_remainder = folder_remainder
            else:
                combined_remainder = raw_remainder
            # Clean the combined remainder using separator normalization.
            cleaned_remainder = clean_filename_remainder_py(combined_remainder)

            # Get user ID from the name using fuzzy matching.
            user_id = get_user_id_by_name(name_to_match) if name_matched == 'true' else None

            # Detect management flag based on full path keywords.
            management_flag = self._detect_management_flag(path_to_analyze)

            # Detect category from folder structure.
            category = self._detect_category(path_to_analyze, folder_info)
            # Add detected category name to folder_info for remainder cleaning
            if folder_info is not None and category:
                folder_info['category_name'] = category

            # Remove category name from remainder to avoid duplication
            if category and folder_info and folder_info.get('folder_only_string'):
                # Get the category name that corresponds to this category ID
                category_name = None
                for name, cat_id in self.category_processor.get_all_categories().items():
                    if cat_id == category:
                        category_name = name
                        break
                if category_name:
                    # Remove the category name from the cleaned remainder (case-insensitive, all occurrences)
                    pattern = re.compile(rf'\b{re.escape(category_name)}\b', re.IGNORECASE)
                    cleaned_remainder = pattern.sub('', cleaned_remainder)
                    cleaned_remainder = re.sub(r'\s+', ' ', cleaned_remainder).strip()

            # Extract folder date information
            folder_date = None
            if folder_info:
                folder_date = folder_info.get('folder_date')

            # Determine priority date using config order
            filename_date = None
            if extracted_date and date_matched == 'true':
                try:
                    filename_date = datetime.strptime(extracted_date, '%Y-%m-%d')
                except ValueError:
                    filename_date = None
            modified_date = None
            created_date = None
            if folder_info and 'filepath' in folder_info:
                try:
                    stat = folder_info['filepath'].stat()
                    modified_date = datetime.fromtimestamp(stat.st_mtime)
                    created_date = datetime.fromtimestamp(stat.st_ctime)
                except (OSError, AttributeError):
                    pass
            # Use the config's date priority order
            priority_date = self.directory_processor.get_priority_date(
                folder_date, filename_date, modified_date, created_date
            )
            # Use priority date if available, otherwise fallback to extracted_date, then current date
            if priority_date:
                final_date = priority_date.strftime('%Y-%m-%d')
            elif extracted_date:
                final_date = extracted_date
            else:
                final_date = datetime.now().strftime('%Y-%m-%d')

            # Always ensure user_id and name are present
            if not user_id:
                user_id = get_user_id_by_name(name_to_match) or ''
            normalized_name = extracted_name or name_to_match or ''

            return {
                'filename': filename,
                'name_to_match': name_to_match,
                'extracted_name': normalized_name,
                'extracted_date': final_date,
                'raw_remainder': raw_remainder,
                'cleaned_remainder': cleaned_remainder,
                'name_matched': name_matched == 'true',
                'date_matched': date_matched == 'true' or priority_date is not None,
                'user_id': user_id,
                'management_flag': management_flag,
                'category': category,
                'folder_date': folder_date
            }
        except Exception as e:
            self.logger.error(f"Error extracting components from {filename}: {e}")
            return None
    
    def _detect_management_flag(self, filename: str) -> str:
        """
        Detect if file should have management flag based on filename keywords.
        
        This method checks the filename against configured management keywords
        to determine if the file should be flagged as a management document.
        
        Args:
            filename: The filename to check for management keywords.
            
        Returns:
            str: Management flag string if detected, empty string otherwise.
        """
        config = self.config.get('ManagementFlag', {})
        if not config.get('enabled', False):
            return ""
        
        keywords = config.get('keywords', [])
        filename_lower = filename.lower()
        
        # Check each keyword for presence in filename.
        for keyword in keywords:
            if keyword.lower() in filename_lower:
                return config.get('flag', 'MGMT')
        
        return ""
    
    def _detect_category(self, filename: str, folder_info: Optional[Dict] = None) -> str:
        """
        Detect category from filename and folder structure.
        
        This method uses the category processor to detect document categories based on
        first-level directory names that match category mappings.
        
        Args:
            filename: The filename to analyze for category detection.
            folder_info: Optional dictionary containing folder path information.
            
        Returns:
            str: Category ID if detected, empty string otherwise.
        """
        if not folder_info:
            return ""
        
        # Use the category processor to detect category from folder path
        category_id = self.category_processor.detect_category_from_path(folder_info)
        return category_id or ""
    
    def format_normalized_filename(self, components: Dict) -> str:
        """
        Format the normalized filename using the configured template.
        Args:
            components: Dictionary of extracted components
        Returns:
            Formatted filename string
        """
        try:
            # Get normalized name
            normalized_name = components['extracted_name'].replace(',', ' ') if components['extracted_name'] else ""
            # Do NOT skip the name if user_id is missing; always include the name (directory name)
            # Get file extension
            original_ext = Path(components['filename']).suffix
            # Clean remainder without extension
            remainder = components['cleaned_remainder'] or ""
            if remainder.endswith(original_ext):
                remainder = remainder[:-len(original_ext)]
            # Format using the template from config (should be {id}_{name}_{remainder}_{date}_{category})
            formatted = format_filename_with_id(
                user_id=components['user_id'] or "",
                name=normalized_name,
                date=components['extracted_date'] or "",
                remainder=remainder,
                category=components['category'] or "",
                management_flag=components['management_flag'] or ""
            )
            # Apply category formatting if category is detected and config says to append
            if components['category'] and self.category_processor.should_include_category_in_filename():
                formatted = self.category_processor.format_filename_with_category(formatted, components['category'])
            # Add file extension if not present
            if not formatted.endswith(original_ext):
                formatted += original_ext
            # Remove any duplicate or trailing separators (e.g., underscores)
            formatted = re.sub(r'_+', '_', formatted)
            formatted = formatted.strip('_')
            return formatted
        except Exception as e:
            self.logger.error(f"Error formatting filename: {e}")
            return components['filename']  # Return original if formatting fails
    
    def process_single_file(self, filepath: Path, name_to_match: str, dry_run: bool = False) -> Dict:
        """
        Process a single file for renaming.
        
        Args:
            filepath: Path to the file
            name_to_match: Name to match against
            dry_run: If True, don't actually rename the file
            
        Returns:
            Dictionary with processing results
        """
        filename = filepath.name
        self.logger.info(f"Processing: {filename}")
        
        # Extract components
        components = self.extract_file_components(filename, name_to_match)
        if not components:
            return {'error': f"Failed to extract components from {filename}"}
        
        # Format new filename
        new_filename = self.format_normalized_filename(components)
        
        # Prepare result
        result = {
            'original_filename': filename,
            'new_filename': new_filename,
            'components': components,
            'success': True
        }
        
        if not dry_run:
            try:
                # Rename the file
                new_filepath = filepath.parent / new_filename
                filepath.rename(new_filepath)
                result['renamed'] = True
                self.logger.info(f"Renamed: {filename} -> {new_filename}")
            except Exception as e:
                result['error'] = f"Failed to rename {filename}: {e}"
                result['success'] = False
                self.logger.error(result['error'])
        else:
            result['renamed'] = False
            self.logger.info(f"DRY RUN - Would rename: {filename} -> {new_filename}")
        
        return result
    
    def process_csv_mapping(self, csv_path: str, dry_run: bool = False) -> List[Dict]:
        """
        Process files based on CSV mapping.
        
        Args:
            csv_path: Path to CSV file with mappings
            dry_run: If True, don't actually rename files
            
        Returns:
            List of processing results
        """
        results = []
        
        try:
            with open(csv_path, 'r') as f:
                reader = csv.DictReader(f)
                
                for row in reader:
                    old_filename = row.get('old_filename', '').strip()
                    name_to_match = row.get('name_to_match', '').strip()
                    
                    if not old_filename or not name_to_match:
                        results.append({'error': f"Invalid row: {row}"})
                        continue
                    
                    # Find the file
                    filepath = Path(old_filename)
                    if not filepath.exists():
                        results.append({'error': f"File not found: {old_filename}"})
                        continue
                    
                    # Process the file
                    result = self.process_single_file(filepath, name_to_match, dry_run)
                    results.append(result)
        
        except Exception as e:
            self.logger.error(f"Error processing CSV: {e}")
            results.append({'error': f"CSV processing error: {e}"})
        
        return results
    
    def process_directory(self, input_dir: str, output_dir: str, name_mapping: Dict[str, str], 
                         dry_run: bool = False) -> List[Dict]:
        """
        Process all files in a directory with multi-level support.
        
        Args:
            input_dir: Input directory path
            output_dir: Output directory path
            name_mapping: Dictionary mapping directory names to person names
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
        
        # Get all files recursively with folder information
        files_with_info = self.directory_processor.get_files_recursive(input_path)
        
        for filepath, folder_info in files_with_info:
            filename = filepath.name
            
            # Determine person name from directory structure
            # For multi-level directories, use the top-level directory name as person name
            relative_path = filepath.relative_to(input_path)
            person_name = relative_path.parts[0] if relative_path.parts else ""
            
            # Use name_mapping if provided, otherwise use directory name
            name_to_match = name_mapping.get(person_name, person_name)
            
            if not name_to_match:
                results.append({'error': f"No name mapping for: {person_name}"})
                continue
            
            # Extract components with folder information
            components = self.extract_file_components(filename, name_to_match, folder_info)
            if not components:
                results.append({'error': f"Failed to extract components from {filename}"})
                continue
            
            # Format new filename
            new_filename = self.format_normalized_filename(components)
            
            result = {
                'original_filename': str(relative_path),
                'new_filename': new_filename,
                'components': components,
                'person': person_name,
                'success': True
            }
            
            if not dry_run:
                try:
                    # Copy to output directory with new name
                    new_filepath = output_path / new_filename
                    shutil.copy2(filepath, new_filepath)
                    result['copied'] = True
                    self.logger.info(f"Copied: {relative_path} -> {new_filename}")
                except Exception as e:
                    result['error'] = f"Failed to copy {relative_path}: {e}"
                    result['success'] = False
                    self.logger.error(result['error'])
            else:
                result['copied'] = False
                self.logger.info(f"DRY RUN - Would copy: {relative_path} -> {new_filename}")
            
            results.append(result)
        
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
            files_with_info = self.directory_processor.get_files_recursive(person_dir)
            for filepath, folder_info in files_with_info:
                filename = filepath.name
                folder_info['filepath'] = filepath
                components = self.extract_file_components(filename, person_name, folder_info)
                if not components:
                    results.append({'error': f"Failed to extract components from {filename}"})
                    continue
                new_filename = self.format_normalized_filename(components)
                result = {
                    'person': person_name,
                    'original_filename': str(filepath.relative_to(person_dir)),
                    'new_filename': new_filename,
                    'components': components,
                    'success': True,
                    'test_name': test_name
                }
                try:
                    new_filepath = output_person_dir / new_filename
                    orig_stat = filepath.stat()
                    orig_mtime = orig_stat.st_mtime
                    orig_atime = orig_stat.st_atime
                    if duplicate:
                        shutil.copy2(filepath, new_filepath)
                        result['copied'] = True
                        self.logger.info(f"Copied: {person_name}/{filepath.relative_to(person_dir)} -> {test_name}/{person_name}/{new_filename}")
                    else:
                        filepath.rename(new_filepath)
                        result['moved'] = True
                        self.logger.info(f"Moved: {person_name}/{filepath.relative_to(person_dir)} -> {test_name}/{person_name}/{new_filename}")
                    # Restore original times on the new file
                    os.utime(new_filepath, (orig_atime, orig_mtime))
                except Exception as e:
                    result['error'] = f"Failed to process {filename}: {e}"
                    result['success'] = False
                    self.logger.error(result['error'])
                results.append(result)
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


def main():
    """Main CLI entry point."""
    parser = argparse.ArgumentParser(
        description="VisualCare File Migration Renamer - Rename files based on extracted names, dates, and user IDs"
    )
    parser.add_argument(
        '--input-dir',
        help='Input directory containing files to process'
    )
    parser.add_argument(
        '--output-dir',
        help='Output directory for processed files'
    )
    parser.add_argument(
        '--name-mapping',
        help='CSV file with filename to name mappings (optional, for directory processing)'
    )
    parser.add_argument(
        '--category-mapping',
        help='CSV file with category mappings (optional, for directory processing)'
    )
    parser.add_argument(
        '--test-mode',
        action='store_true',
        help='Use tests/test-files structure for processing'
    )
    parser.add_argument(
        '--test-name',
        default='basic',
        help='Name of the test (determines output directory: to-<test_name>). Default: basic'
    )
    parser.add_argument(
        '--person',
        help='Filter to specific person when using test mode'
    )
    parser.add_argument(
        '--dry-run',
        action='store_true',
        help='Preview changes without making them'
    )
    parser.add_argument(
        '--config',
        help='Path to configuration file (default: config/components.yaml)'
    )
    parser.add_argument(
        '--verbose', '-v',
        action='store_true',
        help='Enable verbose logging'
    )
    parser.add_argument(
        '--duplicate',
        action='store_true',
        help='Duplicate (copy) the file before renaming; if not set, move/rename the original.'
    )
    args = parser.parse_args()
    if args.verbose:
        logging.getLogger().setLevel(logging.DEBUG)
    renamer = FileMigrationRenamer(args.config)
    if args.test_mode:
        print(f"Processing test files using tests/test-files structure")
        print(f"Test name: {args.test_name}")
        if args.person:
            print(f"Filtering to person: {args.person}")
        results = renamer.process_test_files(duplicate=args.duplicate, person_filter=args.person, test_name=args.test_name)
        renamer.print_summary(results)
    elif args.input_dir and args.output_dir:
        name_mapping = {}
        if args.name_mapping:
            try:
                with open(args.name_mapping, 'r') as f:
                    reader = csv.DictReader(f)
                    for row in reader:
                        filename = row.get('filename', '').strip()
                        name = row.get('name_to_match', '').strip()
                        if filename and name:
                            name_mapping[filename] = name
            except Exception as e:
                print(f"Error loading name mapping: {e}")
                sys.exit(1)
        print(f"Processing directory: {args.input_dir} -> {args.output_dir}")
        results = renamer.process_directory(args.input_dir, args.output_dir, name_mapping, args.dry_run)
        renamer.print_summary(results)
    else:
        print("Error: Must specify either --test-mode or both --input-dir and --output-dir")
        parser.print_help()
        sys.exit(1)
    sys.exit(0)


if __name__ == "__main__":
    main() 