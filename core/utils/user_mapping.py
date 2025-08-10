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
    
    # Allow override via environment variable for real runs
    mapping_file = os.environ.get('VC_USER_MAPPING_FILE') or user_config.get('mapping_test_file', 'config/user_mapping.csv')
    id_column = user_config.get('id_column', 'user_id')
    name_column = user_config.get('name_column', 'full_name')
    
    # Resolve relative path from project root
    project_root = Path(__file__).parent.parent.parent
    # Support absolute or relative mapping file paths
    mapping_path = Path(mapping_file)
    if not mapping_path.is_absolute():
        mapping_path = project_root / mapping_path
    
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
        {id_column: '1001', name_column: 'John Doe'},
        {id_column: '1005', name_column: 'Michael Brown'},
    ]
    
    with open(mapping_path, 'w', newline='') as f:
        writer = csv.DictWriter(f, fieldnames=[id_column, name_column])
        writer.writeheader()
        writer.writerows(default_mapping)


def get_user_id_by_name(full_name: str) -> Optional[str]:
    """
    Get user ID by full name, handling optional prefix/suffix removal.
    
    Args:
        full_name: The full name to look up (may include prefix/suffix)
        
    Returns:
        User ID if found, None otherwise
    """
    config = load_config()
    user_config = config.get('UserMapping', {})
    user_mapping = load_user_mapping()
    
    # Remove prefix and management_suffix if configured
    prefix = user_config.get('prefix', '')
    management_suffix = user_config.get('management_suffix', '')
    
    cleaned_name = full_name
    if prefix and cleaned_name.startswith(prefix):
        cleaned_name = cleaned_name[len(prefix):].strip()
    if management_suffix and cleaned_name.endswith(management_suffix):
        cleaned_name = cleaned_name[:-len(management_suffix)].strip()
    
    # Direct lookup (case-insensitive)
    for user_id, name in user_mapping.items():
        if name.lower() == cleaned_name.lower():
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
    
    # Pattern for user ID at start of filename (e.g., "1001_filename.pdf")
    start_pattern = r'^(\d{3,5})[_\-\s]'
    match = re.search(start_pattern, filename)
    if match:
        potential_id = match.group(1)
        # Verify this ID exists in our mapping
        if get_name_by_user_id(potential_id):
            return potential_id
    
    # Pattern for user ID anywhere in filename (e.g., "filename_1001_something.pdf")
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


def extract_user_from_path(full_path: str) -> str:
    """
    Extract user information from a full path (directory + filename).
    Follows sequential string-based approach: extracts person name from first directory.
    
    Args:
        full_path: Full path like "John Doe/file.pdf" or "VC - John Doe/document.pdf"
        
    Returns:
        user_id|raw_name|cleaned_name|raw_remainder|cleaned_remainder
        
    Process:
    1. Extract person name from first directory
    2. Remove person name from path (always)
    3. Check user mapping for match
    4. Return remainder string for next extraction step
    """
    from pathlib import Path
    import subprocess
    
    config = load_config()
    global_config = config.get('Global', {})
    case_normalization = global_config.get('case_normalization', 'titlecase')
    
    # Split path into parts to get first directory
    path_obj = Path(full_path)
    path_parts = path_obj.parts
    
    # Extract person name from first directory
    if len(path_parts) > 0:
        person_directory = path_parts[0]  # First directory is person's name
        # Get remainder (everything after person directory)
        if len(path_parts) > 1:
            raw_remainder = "/".join(path_parts[1:])
        else:
            raw_remainder = ""
    else:
        person_directory = ""
        raw_remainder = ""
    
    # Get user mapping info
    user_id = get_user_id_by_name(person_directory) or ""
    raw_name = person_directory
    
    # Get cleaned name (with prefix/management_suffix removed)
    user_config = config.get('UserMapping', {})
    prefix = user_config.get('prefix', '')
    management_suffix = user_config.get('management_suffix', '')
    
    cleaned_name = person_directory
    is_management_folder = False
    
    if prefix and cleaned_name.startswith(prefix):
        cleaned_name = cleaned_name[len(prefix):].strip()
    if management_suffix and cleaned_name.endswith(management_suffix):
        cleaned_name = cleaned_name[:-len(management_suffix)].strip()
        is_management_folder = True
    
    # If we have a mapped user, always use the name exactly as provided by the mapping CSV.
    if user_id:
        mapped_name = get_name_by_user_id(user_id)
        if mapped_name:
            cleaned_name = mapped_name
    else:
        # Apply case normalization only when no canonical mapping is found
        if case_normalization == 'titlecase':
            cleaned_name = cleaned_name.title()
        elif case_normalization == 'lowercase':
            cleaned_name = cleaned_name.lower()
        elif case_normalization == 'uppercase':
            cleaned_name = cleaned_name.upper()
    
    # Get cleaned remainder using global cleaner
    cleaned_remainder = raw_remainder
    if raw_remainder:
        project_root = Path(__file__).parent.parent.parent
        try:
            cleaned_remainder = subprocess.check_output([
                'python3',
                str(project_root / 'core/utils/name_matcher.py'),
                '--clean-filename',
                raw_remainder
            ], text=True, stderr=subprocess.DEVNULL).strip()
        except:
            cleaned_remainder = raw_remainder
    
    return f"{user_id}|{raw_name}|{cleaned_name}|{raw_remainder}|{cleaned_remainder}|{is_management_folder}"


if __name__ == "__main__":
    import sys
    from pathlib import Path
    import subprocess
    
    if len(sys.argv) == 2:
        input_path = sys.argv[1]
        
        # Check if this looks like a full path (contains directory separator)
        if '/' in input_path or '\\' in input_path:
            # Use the new path-based extraction
            result = extract_user_from_path(input_path)
            print(result)
        else:
            # Use the old name-based extraction for backward compatibility
            input_name = input_path
            user_id = get_user_id_by_name(input_name) or ""
            full_name = get_name_by_user_id(user_id) if user_id else ""
            raw_name = input_name
            
            # Get cleaned name (with prefix/management_suffix removed)
            config = load_config()
            user_config = config.get('UserMapping', {})
            global_config = config.get('Global', {})
            prefix = user_config.get('prefix', '')
            management_suffix = user_config.get('management_suffix', '')
            case_normalization = global_config.get('case_normalization', 'titlecase')
            
            cleaned_name = input_name
            if prefix and cleaned_name.startswith(prefix):
                cleaned_name = cleaned_name[len(prefix):].strip()
            if management_suffix and cleaned_name.endswith(management_suffix):
                cleaned_name = cleaned_name[:-len(management_suffix)].strip()
            
            # Apply case normalization
            if case_normalization == 'titlecase':
                cleaned_name = cleaned_name.title()
            elif case_normalization == 'lowercase':
                cleaned_name = cleaned_name.lower()
            elif case_normalization == 'uppercase':
                cleaned_name = cleaned_name.upper()
            
            print(f"{user_id}|{raw_name}|{cleaned_name}")
    
    elif len(sys.argv) >= 3:
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
        
        elif command == "extract_from_path" and len(sys.argv) >= 3:
            path = sys.argv[2]
            result = extract_user_from_path(path)
            print(result)
        
        else:
            print("Invalid command or missing arguments")
            sys.exit(1)
    
    else:
        print("Usage: python3 user_mapping.py <name_or_path>")
        print("   or: python3 user_mapping.py get_id <name>")
        print("   or: python3 user_mapping.py get_name <user_id>")
        print("   or: python3 user_mapping.py extract_id <filename> <name>")
        print("   or: python3 user_mapping.py extract_from_path <path>")
        sys.exit(1) 