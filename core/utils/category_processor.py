#!/usr/bin/env python3

"""
Category Processor for Multi-Level Directory Processing.

This module handles category detection and mapping for multi-level
directory structures, allowing first-level directories to be mapped
to category IDs that are appended to filenames.

File Path: core/utils/category_processor.py

@package VisualCare\\FileMigration\\Utils
@since   1.0.0

Features:
- Load category mappings from CSV file
- Case insensitive category name matching
- First-level directory category detection
- Category ID extraction and validation
"""

import csv
import sys
from pathlib import Path
from typing import Dict, Optional, Tuple


class CategoryProcessor:
    """Process category mappings and detect categories from directory structures."""
    
    def __init__(self, config: Dict):
        """
        Initialize the category processor.
        
        Args:
            config: Configuration dictionary containing category settings.
        """
        self.config = config
        self.category_mapping = {}
        self.category_settings = config.get('Category', {})
        self._load_category_mapping()
    
    def _load_category_mapping(self):
        """Load category mappings from the configured CSV file."""
        mapping_file = self.category_settings.get('mapping_file', 'config/category_mapping.csv')
        id_column = self.category_settings.get('id_column', 'category_id')
        name_column = self.category_settings.get('name_column', 'category_name')
        
        # Get the project root directory
        project_root = Path(__file__).parent.parent.parent
        mapping_path = project_root / mapping_file
        
        if not mapping_path.exists():
            print(f"Warning: Category mapping file not found: {mapping_path}", file=sys.stderr)
            sys.stderr.flush()
            return
        
        try:
            with open(mapping_path, 'r') as f:
                reader = csv.DictReader(f)
                for row in reader:
                    category_id = row.get(id_column, '').strip()
                    category_name = row.get(name_column, '').strip()
                    if category_id and category_name:
                        # Store with case-insensitive key if enabled
                        key = category_name.lower() if self.category_settings.get('case_insensitive', True) else category_name
                        self.category_mapping[key] = category_id
            
            print(f"Loaded {len(self.category_mapping)} category mappings", file=sys.stderr)
            sys.stderr.flush()
            
        except Exception as e:
            print(f"Error loading category mapping: {e}", file=sys.stderr)
            sys.stderr.flush()
    
    def detect_category_from_path(self, folder_info: Dict) -> Optional[str]:
        """
        Detect category from the folder path structure.
        
        Args:
            folder_info: Dictionary containing folder path information.
            
        Returns:
            Optional[str]: Category ID if found, None otherwise.
        """
        if not self.category_settings.get('enabled', False):
            return None
        
        # Only check first-level directories if configured
        if not self.category_settings.get('first_level_only', True):
            return None
        
        # Get the folder-only string (without filename)
        folder_string = folder_info.get('folder_only_string', '')
        if not folder_string:
            return None
        
        # Split the path and get the first-level directory
        path_parts = Path(folder_string).parts
        
        # If no path parts or only root, no category
        if len(path_parts) <= 1:
            return None
        
        # Get the first-level directory (after the person's root directory)
        if len(path_parts) >= 2:
            first_level_dir = path_parts[1]  # Skip the person's root directory
        else:
            return None
        
        # Check if the first-level directory matches a category
        return self._match_category_name(first_level_dir)
    
    def _match_category_name(self, directory_name: str) -> Optional[str]:
        """
        Match a directory name to a category ID.
        
        Args:
            directory_name: The directory name to match.
            
        Returns:
            Optional[str]: Category ID if match found, None otherwise.
        """
        if not directory_name:
            return None
        
        # Use case-insensitive matching if enabled
        if self.category_settings.get('case_insensitive', True):
            search_name = directory_name.lower()
        else:
            search_name = directory_name
        
        # Check for exact match
        if search_name in self.category_mapping:
            return self.category_mapping[search_name]
        
        # Check for partial matches (optional, for flexibility)
        for category_name, category_id in self.category_mapping.items():
            if search_name in category_name or category_name in search_name:
                return category_id
        
        return None
    
    def should_include_category_in_filename(self) -> bool:
        """
        Check if category should be included in filename.
        
        Returns:
            bool: True if category should be included, False otherwise.
        """
        return self.category_settings.get('append_to_filename', False)
    
    def get_category_placement(self) -> str:
        """
        Get where the category should be placed in the filename.
        
        Returns:
            str: Placement option ('prefix', 'suffix', 'separate_component').
        """
        return self.category_settings.get('placement', 'suffix')
    
    def format_filename_with_category(self, base_filename: str, category_id: str) -> str:
        """
        Format filename with category ID based on placement setting.
        
        Args:
            base_filename: The base filename without category.
            category_id: The category ID to add.
            
        Returns:
            str: Formatted filename with category.
        """
        if not category_id:
            return base_filename
        
        placement = self.get_category_placement()
        
        if placement == 'prefix':
            # Add category at the beginning
            return f"{category_id}_{base_filename}"
        elif placement == 'suffix':
            # Add category at the end (before extension)
            name_parts = base_filename.rsplit('.', 1)
            if len(name_parts) == 2:
                return f"{name_parts[0]}_{category_id}.{name_parts[1]}"
            else:
                return f"{base_filename}_{category_id}"
        elif placement == 'separate_component':
            # Add category as a separate component in the middle
            return f"{base_filename}_{category_id}"
        else:
            # Default to suffix
            name_parts = base_filename.rsplit('.', 1)
            if len(name_parts) == 2:
                return f"{name_parts[0]}_{category_id}.{name_parts[1]}"
            else:
                return f"{base_filename}_{category_id}"
    
    def get_all_categories(self) -> Dict[str, str]:
        """
        Get all category mappings.
        
        Returns:
            Dict[str, str]: Dictionary of category names to IDs.
        """
        return self.category_mapping.copy()
    
    def validate_category_id(self, category_id: str) -> bool:
        """
        Validate if a category ID exists in the mapping.
        
        Args:
            category_id: The category ID to validate.
            
        Returns:
            bool: True if valid, False otherwise.
        """
        return category_id in self.category_mapping.values()


def main():
    """Test the category processor."""
    # Load config
    import yaml
    import sys
    config_path = Path(__file__).parent.parent.parent / 'config' / 'components.yaml'
    with open(config_path, 'r') as f:
        config = yaml.safe_load(f)
    # Create processor
    processor = CategoryProcessor(config)
    # Test category detection
    test_cases = [
        {'folder_only_string': 'John Doe/WHS/2023/Incidents'},
        {'folder_only_string': 'Jane Smith/Medical/GP Reports'},
        {'folder_only_string': 'Bob Johnson/Personal Notes'},
        {'folder_only_string': 'John Doe/whs/2023/Incidents'},  # Case insensitive
        {'folder_only_string': 'John Doe/Support Plans/2024'},
    ]
    print("Category Detection Test", file=sys.stderr)
    sys.stderr.flush()
    print("=" * 40, file=sys.stderr)
    sys.stderr.flush()
    for i, test_case in enumerate(test_cases, 1):
        category_id = processor.detect_category_from_path(test_case)
        print(f"Test {i}: {test_case['folder_only_string']}", file=sys.stderr)
        sys.stderr.flush()
        print(f"  Category ID: {category_id}", file=sys.stderr)
        sys.stderr.flush()
        if category_id:
            formatted = processor.format_filename_with_category(
                "1001_John Doe_2023 Incidents_2023-06-01.pdf", 
                category_id
            )
            print(f"  Formatted: {formatted}", file=sys.stderr)
            sys.stderr.flush()
        print(file=sys.stderr)
        sys.stderr.flush()


def extract_category_from_path_cli(input_path: str, config: dict):
    """
    CLI entrypoint for extracting category from a path.
    Outputs: extracted_category|raw_category|cleaned_category|raw_remainder|cleaned_remainder|error_status
    """
    processor = CategoryProcessor(config)
    import os
    import re
    path_parts = Path(input_path).parts
    if len(path_parts) < 3:
        # No category
        print(f"|||{input_path}|{input_path}|no_category")
        return
    person_dir = path_parts[0]
    candidate = path_parts[1]
    # Normalize function: lowercase, replace underscores/hyphens/& with spaces, remove non-alphanum except spaces, collapse spaces
    def normalize(s):
        s = s.lower()
        s = re.sub(r'[\-_&]', ' ', s)
        s = re.sub(r'[^a-z0-9 ]', '', s)
        s = re.sub(r'\s+', ' ', s)
        return s.strip()
    norm_candidate = normalize(candidate)
    # Load mapping file for robust matching
    mapping_file = processor.category_settings.get('mapping_test_file', 'config/category_mapping.csv')
    project_root = Path(__file__).parent.parent.parent
    mapping_path = project_root / mapping_file
    mapped_name_csv = None
    mapped_id = None
    if mapping_path.exists():
        import csv
        with open(mapping_path, 'r') as f:
            reader = csv.DictReader(f)
            for row in reader:
                norm_map = normalize(row['category_name'])
                # Prefer exact match, then partial
                if norm_candidate == norm_map:
                    mapped_name_csv = row['category_name']
                    mapped_id = row['category_id']
                    break
            if not mapped_name_csv:
                f.seek(0)
                next(reader)  # skip header
                for row in reader:
                    norm_map = normalize(row['category_name'])
                    if norm_map in norm_candidate or norm_candidate in norm_map:
                        mapped_name_csv = row['category_name']
                        mapped_id = row['category_id']
                        break
    if mapped_name_csv:
        raw_category = candidate
        cleaned_category = mapped_name_csv
        extracted_category = mapped_name_csv
        raw_remainder = os.path.join(person_dir, *path_parts[2:])
        # Use universal cleaner for cleaned_remainder
        import subprocess
        cleaned_remainder = subprocess.check_output([
            'python3',
            str(project_root / 'core/utils/name_matcher.py'),
            '--clean-filename',
            raw_remainder
        ], text=True).strip()
        print(f"{extracted_category}|{raw_category}|{cleaned_category}|{raw_remainder}|{cleaned_remainder}||")
    else:
        # Unmapped category, treat as directory
        if candidate:
            raw_remainder = os.path.join(person_dir, *path_parts[2:])
            import subprocess
            cleaned_remainder = subprocess.check_output([
                'python3',
                str(project_root / 'core/utils/name_matcher.py'),
                '--clean-filename',
                raw_remainder
            ], text=True).strip()
            print(f"{candidate}|{candidate}|{candidate}|{raw_remainder}|{cleaned_remainder}|unmapped")
        else:
            # No category
            print(f"|||{input_path}|{input_path}|no_category")

if __name__ == "__main__":
    import yaml
    import sys
    config_path = Path(__file__).parent.parent.parent / 'config' / 'components.yaml'
    with open(config_path, 'r') as f:
        config = yaml.safe_load(f)
    if len(sys.argv) == 2:
        extract_category_from_path_cli(sys.argv[1], config)
    else:
        main() 