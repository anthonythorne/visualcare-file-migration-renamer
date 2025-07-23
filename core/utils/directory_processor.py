#!/usr/bin/env python3

"""
Directory Processing Utilities for VisualCare File Migration Renamer.

This module provides utilities for processing multi-level directory structures,
handling file ignore patterns, and managing date/year folder processing.

File Path: core/utils/directory_processor.py

@package VisualCare\\FileMigration\\Utils
@since   1.0.0

Features:
- Multi-level directory traversal with configurable depth limits
- File and directory ignore patterns
- Year and date folder detection and handling
- Smart directory name inclusion/exclusion
- Folder path extraction for filename components
"""

import os
import re
from pathlib import Path
from typing import Dict, List, Tuple, Optional, Set
from datetime import datetime


class DirectoryProcessor:
    """Handles multi-level directory processing and file filtering."""
    
    def __init__(self, config: Dict):
        """
        Initialize the directory processor with configuration.
        
        Args:
            config: Configuration dictionary containing directory processing settings.
        """
        self.config = config
        self.file_ignore_config = config.get('FileIgnore', {})
        self.dir_structure_config = config.get('DirectoryStructure', {})
        self.date_folder_config = config.get('DateFolderHandling', {})
        
        # Compile ignore patterns for efficiency
        self._compile_ignore_patterns()
    
    def _compile_ignore_patterns(self):
        """Compile ignore patterns for efficient matching."""
        self.ignore_files = set(self.file_ignore_config.get('ignore_files', []))
        self.ignore_directories = set(self.file_ignore_config.get('ignore_directories', []))
        self.exclude_directories = set(self.dir_structure_config.get('exclude_directories', []))
        
        # Compile regex patterns for wildcard matching
        self.ignore_file_patterns = []
        for pattern in self.ignore_files:
            if '*' in pattern:
                regex_pattern = pattern.replace('*', '.*')
                self.ignore_file_patterns.append(re.compile(regex_pattern, re.IGNORECASE))
    
    def should_ignore_file(self, filepath: Path) -> bool:
        """
        Check if a file should be ignored based on configuration.
        
        Args:
            filepath: Path to the file to check.
            
        Returns:
            bool: True if file should be ignored, False otherwise.
        """
        filename = filepath.name
        
        # Check exact matches
        if filename in self.ignore_files:
            return True
        
        # Check wildcard patterns
        for pattern in self.ignore_file_patterns:
            if pattern.match(filename):
                return True
        
        # Check hidden files
        if self.file_ignore_config.get('ignore_hidden_files', True):
            if filename.startswith('.'):
                return True
        
        return False
    
    def should_ignore_directory(self, dirpath: Path) -> bool:
        """
        Check if a directory should be ignored based on configuration.
        
        Args:
            dirpath: Path to the directory to check.
            
        Returns:
            bool: True if directory should be ignored, False otherwise.
        """
        dirname = dirpath.name
        
        # Check exact matches
        if dirname in self.ignore_directories:
            return True
        
        # Check hidden directories
        if self.file_ignore_config.get('ignore_hidden_files', True):
            if dirname.startswith('.'):
                return True
        
        return False
    
    def is_year_folder(self, dirname: str) -> bool:
        """
        Check if a directory name represents a year (e.g., "2023", "2024").
        
        Args:
            dirname: Directory name to check.
            
        Returns:
            bool: True if directory name is a year, False otherwise.
        """
        if not self.date_folder_config.get('enabled', True):
            return False
        
        pattern = self.date_folder_config.get('year_pattern', r'^\d{4}$')
        return bool(re.match(pattern, dirname))
    
    def is_full_date_folder(self, dirname: str) -> bool:
        """
        Check if a directory name represents a full date (e.g., "25.01.15", "2023.07.25").
        
        Args:
            dirname: Directory name to check.
            
        Returns:
            bool: True if directory name is a full date, False otherwise.
        """
        if not self.date_folder_config.get('enabled', True):
            return False
        
        pattern = self.date_folder_config.get('full_date_pattern', r'^\d{2}\.\d{2}\.\d{4}$|^\d{4}\.\d{2}\.\d{2}$')
        return bool(re.match(pattern, dirname))
    
    def parse_date_from_folder(self, dirname: str) -> Optional[datetime]:
        """
        Parse a date from a folder name.
        
        Args:
            dirname: Directory name containing a date.
            
        Returns:
            datetime: Parsed date object, or None if parsing fails.
        """
        try:
            # Handle DD.MM.YYYY format
            if re.match(r'^\d{2}\.\d{2}\.\d{4}$', dirname):
                return datetime.strptime(dirname, '%d.%m.%Y')
            
            # Handle YYYY.MM.DD format
            elif re.match(r'^\d{4}\.\d{2}\.\d{2}$', dirname):
                return datetime.strptime(dirname, '%Y.%m.%d')
            
            # Handle YYYY format (convert to January 1st of that year)
            elif re.match(r'^\d{4}$', dirname):
                return datetime.strptime(f'{dirname}-01-01', '%Y-%m-%d')
            
        except ValueError:
            pass
        
        return None
    
    def should_include_directory_in_filename(self, dirname: str) -> bool:
        """
        Check if a directory name should be included in the filename.
        
        Args:
            dirname: Directory name to check.
            
        Returns:
            bool: True if directory should be included, False otherwise.
        """
        handling = self.dir_structure_config.get('directory_handling', 'smart')
        
        if handling == 'exclude':
            return False
        elif handling == 'include':
            return True
        elif handling == 'smart':
            # Exclude system directories and utility directories
            return dirname not in self.exclude_directories
        
        return True
    
    def extract_folder_path_components(self, filepath: Path, root_path: Path) -> Dict:
        """
        Extract folder path components for a file.
        
        Args:
            filepath: Path to the file.
            root_path: Root directory path for relative path calculation.
            
        Returns:
            Dict: Dictionary containing folder path information:
                - full_path_string: Complete path string for name/date extraction
                - year_folders: List of year folders encountered
                - date_folders: List of date folders encountered
                - folder_date: Date from folder structure (if any)
                - relative_path: Relative path from root
        """
        try:
            # Get relative path from root
            relative_path = filepath.relative_to(root_path)
            parent_path = relative_path.parent
            
            year_folders = []
            date_folders = []
            folder_date = None
            
            # Build the full path string for name/date extraction
            path_parts = []
            
            # Process each directory in the path
            for part in parent_path.parts:
                path_parts.append(part)
                
                if self.is_year_folder(part):
                    year_folders.append(part)
                elif self.is_full_date_folder(part):
                    date_folders.append(part)
                    parsed_date = self.parse_date_from_folder(part)
                    if parsed_date:
                        folder_date = parsed_date
            
            # Add the filename to the path
            path_parts.append(filepath.name)
            
            # Create the full path string (folders + filename)
            full_path_string = '/'.join(path_parts)
            
            # Create folder-only string for remainder processing (without filename)
            folder_only_parts = path_parts[:-1]  # Exclude the filename
            folder_only_string = '/'.join(folder_only_parts) if folder_only_parts else ""
            
            return {
                'full_path_string': full_path_string,
                'folder_only_string': folder_only_string,
                'year_folders': year_folders,
                'date_folders': date_folders,
                'folder_date': folder_date,
                'relative_path': str(relative_path)
            }
            
        except ValueError:
            # File is not relative to root path
            return {
                'full_path_string': filepath.name,
                'folder_only_string': "",
                'year_folders': [],
                'date_folders': [],
                'folder_date': None,
                'relative_path': str(filepath)
            }
    
    def get_files_recursive(self, root_path: Path, max_depth: Optional[int] = None) -> List[Tuple[Path, Dict]]:
        """
        Get all files recursively from a directory, respecting ignore patterns.
        
        Args:
            root_path: Root directory to scan.
            max_depth: Maximum depth to scan (None for unlimited).
            
        Returns:
            List[Tuple[Path, Dict]]: List of (filepath, folder_info) tuples.
        """
        files = []
        
        if max_depth is None:
            max_depth = self.dir_structure_config.get('max_depth', 0)
        
        for filepath in root_path.rglob('*'):
            # Check depth limit
            if max_depth > 0:
                depth = len(filepath.relative_to(root_path).parts)
                if depth > max_depth:
                    continue
            
            # Skip if it's a directory
            if filepath.is_dir():
                continue
            
            # Check if file should be ignored
            if self.should_ignore_file(filepath):
                continue
            
            # Check if any parent directory should be ignored
            should_skip = False
            for parent in filepath.parents:
                if parent == root_path:
                    break
                if self.should_ignore_directory(parent):
                    should_skip = True
                    break
            
            if should_skip:
                continue
            
            # Extract folder path information
            folder_info = self.extract_folder_path_components(filepath, root_path)
            files.append((filepath, folder_info))
        
        return files
    
    def get_priority_date(self, folder_date: Optional[datetime], filename_date: Optional[datetime], 
                         modified_date: Optional[datetime], created_date: Optional[datetime]) -> Optional[datetime]:
        """
        Get the priority date based on configuration.
        
        Args:
            folder_date: Date from folder structure.
            filename_date: Date extracted from filename.
            modified_date: File modification date.
            created_date: File creation date.
            
        Returns:
            datetime: Priority date, or None if no date available.
        """
        priority_order = self.date_folder_config.get('date_priority', [
            'folder_date', 'filename_date', 'modified_date', 'created_date'
        ])
        
        date_map = {
            'folder_date': folder_date,
            'filename_date': filename_date,
            'modified_date': modified_date,
            'created_date': created_date
        }
        
        for priority in priority_order:
            date_value = date_map.get(priority)
            if date_value is not None:
                return date_value
        
        return None
    
    def process_folder_remainder(self, folder_string: str, person_name: str, category_name: str = None) -> str:
        """
        Process folder string to create remainder by removing person names, category names, and dates.
        If a category is present, only include the subpath after the category as the remainder.
        Args:
            folder_string: The folder path string (e.g., "John Doe/2023/WHS/Incidents")
            person_name: The person name to remove from folders
            category_name: The category name to remove from folders (optional)
        Returns:
            str: Processed remainder with person names, category names, and dates removed, separators replaced with spaces
        """
        if not folder_string:
            return ""
        
        # Get configuration settings
        preserve_year_folders = self.dir_structure_config.get('preserve_year_folders', True)
        remove_date_folders = self.dir_structure_config.get('remove_date_folders', True)
        separator_replacement = self.dir_structure_config.get('folder_separator_replacement', ' ')
        
        folder_parts = folder_string.split('/')
        processed_parts = []
        
        # Remove person name if present at the start
        if folder_parts and folder_parts[0].lower() == person_name.lower():
            folder_parts = folder_parts[1:]
        
        # If category_name is present, find its first occurrence and only keep subpath after it
        if category_name:
            for idx, part in enumerate(folder_parts):
                if part.lower() == category_name.lower():
                    folder_parts = folder_parts[idx+1:]
                    break
        
        for part in folder_parts:
            part = part.strip()
            # Handle year folders (4 digits)
            if re.match(r'^\d{4}$', part):
                if preserve_year_folders:
                    processed_parts.append(part)
                continue
            # Handle date folders (DD.MM.YYYY or YYYY.MM.DD)
            if self.is_full_date_folder(part):
                if not remove_date_folders:
                    processed_parts.append(part)
                continue
            # Add the part if it's not a date/year
            processed_parts.append(part)
        
        remainder = separator_replacement.join(processed_parts)
        remainder = re.sub(r'\s+', ' ', remainder).strip()
        return remainder 