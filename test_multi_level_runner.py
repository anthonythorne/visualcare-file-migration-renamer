#!/usr/bin/env python3

"""
Multi-Level Directory Test Runner.

This script demonstrates the multi-level directory test functionality
with the new from-<test_name> directory structure.

File Path: test_multi_level_runner.py

@package VisualCare\\FileMigration\\Tests
@since   1.0.0
"""

import subprocess
import sys
from pathlib import Path


def run_multi_level_test():
    """Run the complete multi-level directory test."""
    
    print("Multi-Level Directory Test Runner")
    print("=" * 50)
    
    # Step 1: Set up test files
    print("\n1. Setting up test files...")
    try:
        result = subprocess.run([sys.executable, 'test_multi_level_setup.py'], 
                              capture_output=True, text=True)
        print(result.stdout)
        if result.stderr:
            print("STDERR:", result.stderr)
        if result.returncode != 0:
            print("❌ Failed to set up test files")
            return False
    except Exception as e:
        print(f"❌ Error setting up test files: {e}")
        return False
    
    # Step 2: Run dry-run test
    print("\n2. Running dry-run test...")
    try:
        result = subprocess.run([
            sys.executable, 'main.py', 
            '--test-mode', '--test-name', 'multi-level', 
            '--dry-run', '--verbose'
        ], capture_output=True, text=True)
        print(result.stdout)
        if result.stderr:
            print("STDERR:", result.stderr)
        if result.returncode != 0:
            print("❌ Dry-run test failed")
            return False
    except Exception as e:
        print(f"❌ Error running dry-run test: {e}")
        return False
    
    # Step 3: Run actual processing
    print("\n3. Running actual processing...")
    try:
        result = subprocess.run([
            sys.executable, 'main.py', 
            '--test-mode', '--test-name', 'multi-level'
        ], capture_output=True, text=True)
        print(result.stdout)
        if result.stderr:
            print("STDERR:", result.stderr)
        if result.returncode != 0:
            print("❌ Actual processing failed")
            return False
    except Exception as e:
        print(f"❌ Error running actual processing: {e}")
        return False
    
    # Step 4: Show results
    print("\n4. Test Results:")
    print("=" * 50)
    
    # Check input directory
    from_dir = Path('tests/test-files/from-multi-level')
    if from_dir.exists():
        print(f"✅ Input directory: {from_dir}")
        person_dirs = [d for d in from_dir.iterdir() if d.is_dir()]
        print(f"   Found {len(person_dirs)} person directories:")
        for person_dir in person_dirs:
            files = list(person_dir.rglob('*'))
            files = [f for f in files if f.is_file()]
            print(f"   - {person_dir.name}: {len(files)} files")
    else:
        print(f"❌ Input directory not found: {from_dir}")
    
    # Check output directory
    to_dir = Path('tests/test-files/to-multi-level')
    if to_dir.exists():
        print(f"✅ Output directory: {to_dir}")
        person_dirs = [d for d in to_dir.iterdir() if d.is_dir()]
        print(f"   Found {len(person_dirs)} person directories:")
        for person_dir in person_dirs:
            files = list(person_dir.iterdir())
            files = [f for f in files if f.is_file()]
            print(f"   - {person_dir.name}: {len(files)} files")
    else:
        print(f"❌ Output directory not found: {to_dir}")
    
    print("\n✅ Multi-level directory test completed successfully!")
    print("\nYou can manually inspect the results:")
    print(f"  Input files:  {from_dir}")
    print(f"  Output files: {to_dir}")
    
    return True


def main():
    """Main function."""
    success = run_multi_level_test()
    if not success:
        sys.exit(1)


if __name__ == "__main__":
    main() 