#!/usr/bin/env python3

"""
User ID Mapping Utility for Filename Normalization.

This module handles mapping between user IDs and full names for filename generation.
It provides CSV-driven user mapping, fuzzy name matching, and template-based
filename formatting with configurable components and separators.

File Path: core/utils/user_mapping.py

@package VisualCare\\FileMigration\\Utils
@since   1.0.0

Features:
- CSV-based user ID to name mapping
- Fuzzy name matching with case-insensitive lookup
- Template-based filename formatting
- Configurable component ordering and separators
- Empty component handling and cleanup
- Management flag and category support
- Default mapping file creation

Configuration:
- Loads mapping from config/user_mapping.csv
- Uses config/components.yaml for formatting rules
- Supports configurable column names and file paths
- Template placeholders: {id}, {name}, {date}, {remainder}, {category}, {management_flag}

Dependencies:
- Requires config/components.yaml for configuration
- Requires config/user_mapping.csv for user mappings
- Creates default mapping file if missing (configurable)
"""

import csv
import os
import yaml
from pathlib import Path
from typing import Dict, Optional, Tuple


def load_config() -> Dict:
    """Load configuration from components.yaml."""
    config_path = Path(__file__).parent.parent.parent / 'config' / 'components.yaml'
    with open(config_path, 'r') as f:
        return yaml.safe_load(f)


def load_user_mapping() -> Dict[str, str]:
    """
    Load user ID to name mapping from CSV file.
    
    Returns:
        Dict mapping user_id (str) to full_name (str)
    """
    config = load_config()
    user_config = config.get('UserMapping', {})
    
    mapping_file = user_config.get('mapping_file', 'config/user_mapping.csv')
    id_column = user_config.get('id_column', 'user_id')
    name_column = user_config.get('name_column', 'full_name')
    
    # Resolve relative path from project root
    project_root = Path(__file__).parent.parent.parent
    mapping_path = project_root / mapping_file
    
    if not mapping_path.exists():
        if user_config.get('create_if_missing', True):
            # Create default mapping file
            create_default_mapping(mapping_path, id_column, name_column)
        else:
            raise FileNotFoundError(f"User mapping file not found: {mapping_path}")
    
    user_mapping = {}
    with open(mapping_path, 'r') as f:
        reader = csv.DictReader(f)
        for row in reader:
            user_id = row.get(id_column, '').strip()
            full_name = row.get(name_column, '').strip()
            if user_id and full_name:
                user_mapping[user_id] = full_name
    
    return user_mapping


def create_default_mapping(mapping_path: Path, id_column: str, name_column: str):
    """Create a default user mapping file."""
    mapping_path.parent.mkdir(parents=True, exist_ok=True)
    
    default_mapping = [
        {id_column: '1001', name_column: 'John Doe'},
        {id_column: '1002', name_column: 'Jane Smith'},
        {id_column: '1003', name_column: 'Bob Johnson'},
        {id_column: '1004', name_column: 'Sarah Smith'},
        {id_column: '1005', name_column: 'Michael Brown'},
    ]
    
    with open(mapping_path, 'w', newline='') as f:
        writer = csv.DictWriter(f, fieldnames=[id_column, name_column])
        writer.writeheader()
        writer.writerows(default_mapping)


def get_user_id_by_name(full_name: str) -> Optional[str]:
    """
    Get user ID by full name.
    
    Args:
        full_name: The full name to look up
        
    Returns:
        User ID if found, None otherwise
    """
    user_mapping = load_user_mapping()
    
    # Direct lookup
    for user_id, name in user_mapping.items():
        if name.lower() == full_name.lower():
            return user_id
    
    # Fuzzy matching (case-insensitive partial match)
    for user_id, name in user_mapping.items():
        if full_name.lower() in name.lower() or name.lower() in full_name.lower():
            return user_id
    
    return None


def get_name_by_user_id(user_id: str) -> Optional[str]:
    """
    Get full name by user ID.
    
    Args:
        user_id: The user ID to look up
        
    Returns:
        Full name if found, None otherwise
    """
    user_mapping = load_user_mapping()
    return user_mapping.get(user_id)


def extract_user_id_from_filename(filename: str, name_to_match: str) -> Optional[str]:
    """
    Extract user ID from filename by matching the name.
    
    Args:
        filename: The filename to analyze
        name_to_match: The name to match against
        
    Returns:
        User ID if found, None otherwise
    """
    # First, try to get user ID from the name
    user_id = get_user_id_by_name(name_to_match)
    if user_id:
        return user_id
    
    # If no direct match, look for user ID patterns in filename
    # Common patterns: ID at start, ID with separators, etc.
    import re
    
    # Pattern for user ID at start of filename (e.g., "1234_filename.pdf")
    start_pattern = r'^(\d{3,5})[_\-\s]'
    match = re.search(start_pattern, filename)
    if match:
        potential_id = match.group(1)
        # Verify this ID exists in our mapping
        if get_name_by_user_id(potential_id):
            return potential_id
    
    # Pattern for user ID anywhere in filename (e.g., "filename_1234_something.pdf")
    anywhere_pattern = r'[_\-\s](\d{3,5})[_\-\s]'
    match = re.search(anywhere_pattern, filename)
    if match:
        potential_id = match.group(1)
        # Verify this ID exists in our mapping
        if get_name_by_user_id(potential_id):
            return potential_id
    
    return None


def format_filename_with_id(user_id: str, name: str, date: str, remainder: str, 
                           category: str = "", management_flag: str = "") -> str:
    """
    Format filename according to the configured template.
    
    Args:
        user_id: The user ID
        name: The normalized name
        date: The extracted date
        remainder: The cleaned remainder
        category: Optional category
        management_flag: Optional management flag
        
    Returns:
        Formatted filename string
    """
    config = load_config()
    format_config = config.get('FilenameFormat', {})
    
    template = format_config.get('template', '{id}_{name}_{remainder}_{date}')
    skip_empty = format_config.get('skip_empty_components', True)
    cleanup_separators = format_config.get('cleanup_separators', True)
    
    # Replace placeholders in template
    formatted = template.format(
        id=user_id,
        name=name,
        date=date,
        remainder=remainder,
        category=category,
        management_flag=management_flag
    )
    
    if skip_empty:
        # Remove empty components and their separators
        import re
        # Remove patterns like "_" or "__" that result from empty components
        formatted = re.sub(r'_+', '_', formatted)
        # Remove leading/trailing underscores
        formatted = formatted.strip('_')
    
    if cleanup_separators:
        # Clean up multiple consecutive separators
        import re
        formatted = re.sub(r'_+', '_', formatted)
    
    return formatted


if __name__ == "__main__":
    # Test the functionality
    import sys
    
    if len(sys.argv) < 2:
        print("Usage: user_mapping.py <command> [args]")
        print("Commands:")
        print("  get_id <name> - Get user ID by name")
        print("  get_name <id> - Get name by user ID")
        print("  extract_id <filename> <name> - Extract user ID from filename")
        sys.exit(1)
    
    command = sys.argv[1]
    
    if command == "get_id" and len(sys.argv) >= 3:
        name = sys.argv[2]
        user_id = get_user_id_by_name(name)
        print(f"User ID for '{name}': {user_id}")
    
    elif command == "get_name" and len(sys.argv) >= 3:
        user_id = sys.argv[2]
        name = get_name_by_user_id(user_id)
        print(f"Name for user ID '{user_id}': {name}")
    
    elif command == "extract_id" and len(sys.argv) >= 4:
        filename = sys.argv[2]
        name = sys.argv[3]
        user_id = extract_user_id_from_filename(filename, name)
        print(f"Extracted user ID from '{filename}' for '{name}': {user_id}")
    
    else:
        print("Invalid command or missing arguments")
        sys.exit(1) 