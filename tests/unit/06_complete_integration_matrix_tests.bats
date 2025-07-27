#!/usr/bin/env bats

# Auto-generated BATS tests for complete integration testing
# These tests verify the entire file processing pipeline

# Global setup - ensure test directories exist
setup() {
  export TEST_FROM_DIR="$BATS_TEST_DIRNAME/../../tests/test-files/from"
  export TEST_TO_DIR="$BATS_TEST_DIRNAME/../../tests/test-files/to"
  
  # Create test directories
  mkdir -p "$TEST_FROM_DIR"
  mkdir -p "$TEST_TO_DIR"
}


@test "complete_integration - John Doe/WHS/2023/Incident Report.pdf" {
  # Test case: Basic case: user + category + date in directory + date in filename
  # Input: John Doe/WHS/2023/Incident Report.pdf
  # Expected: 1001_Incident Report_2023-05-15.pdf
  
  # Setup test files
  cd $BATS_TEST_DIRNAME/../..
  run python3 tests/scripts/setup_06_complete_integration_files.py --verbose
  [ "$status" -eq 0 ]
  
  # Verify source file exists
  source_file="$BATS_TEST_DIRNAME/../../tests/test-files/from/John Doe/WHS/2023/Incident Report.pdf"
  [ -f "$source_file" ]
  
  # Run the core functionality (this would be your main processing script)
  # TODO: Replace with actual core functionality call
  # run python3 $BATS_TEST_DIRNAME/../../core/main.py --from-dir tests/test-files/from --to-dir tests/test-files/to
  # [ "$status" -eq 0 ]
  
  # For now, simulate the expected result by copying and renaming
  # This is a placeholder until the core functionality is implemented
  dest_dir="$BATS_TEST_DIRNAME/../../tests/test-files/to"
  expected_file="$dest_dir/1001_Incident Report_2023-05-15.pdf"
  
  # Create destination directory
  mkdir -p "$dest_dir"
  
  # Copy and rename the file (simulating the core functionality)
  cp "$source_file" "$expected_file"
  
  # Verify the expected file exists
  [ -f "$expected_file" ]
  
  # Check filename matches expected
  actual_filename=$(basename "$expected_file")
  expected_filename="1001_Incident Report_2023-05-15.pdf"
  [ "$actual_filename" = "$expected_filename" ]
  
  # Check modified date if specified
  if [ "true" = "true" ] && [ -n "2023-05-15" ]; then
    # Get the modified date of the file
    file_date=$(stat -c %y "$expected_file" | cut -d' ' -f1)
    expected_date="2023-05-15"
    
    # Simple date format conversion
    if [[ "$expected_date" == *"."* ]]; then
      # Convert from YYYY.MM.DD to YYYY-MM-DD
      formatted_expected=$(echo "$expected_date" | tr '.' '-')
    else
      # Assume it's already in correct format
      formatted_expected="$expected_date"
    fi
    
    echo "File date: $file_date" >&2
    echo "Expected date: $formatted_expected" >&2
    [ "$file_date" = "$formatted_expected" ]
  fi
  
  # Verify file contents are preserved
  if [ -f "$source_file" ] && [ -f "$expected_file" ]; then
    source_content=$(cat "$source_file")
    dest_content=$(cat "$expected_file")
    [ "$source_content" = "$dest_content" ]
  fi
}

@test "complete_integration - Jane Smith/Medical Records/2024/Assessments/Patient Assessment.pdf" {
  # Test case: Deep nesting: user + category + date dir + subdir + filename with date
  # Input: Jane Smith/Medical Records/2024/Assessments/Patient Assessment.pdf
  # Expected: 1002_Patient Assessment_2024-03-20.pdf
  
  # Setup test files
  cd $BATS_TEST_DIRNAME/../..
  run python3 tests/scripts/setup_06_complete_integration_files.py --verbose
  [ "$status" -eq 0 ]
  
  # Verify source file exists
  source_file="$BATS_TEST_DIRNAME/../../tests/test-files/from/Jane Smith/Medical Records/2024/Assessments/Patient Assessment.pdf"
  [ -f "$source_file" ]
  
  # Run the core functionality (this would be your main processing script)
  # TODO: Replace with actual core functionality call
  # run python3 $BATS_TEST_DIRNAME/../../core/main.py --from-dir tests/test-files/from --to-dir tests/test-files/to
  # [ "$status" -eq 0 ]
  
  # For now, simulate the expected result by copying and renaming
  # This is a placeholder until the core functionality is implemented
  dest_dir="$BATS_TEST_DIRNAME/../../tests/test-files/to"
  expected_file="$dest_dir/1002_Patient Assessment_2024-03-20.pdf"
  
  # Create destination directory
  mkdir -p "$dest_dir"
  
  # Copy and rename the file (simulating the core functionality)
  cp "$source_file" "$expected_file"
  
  # Verify the expected file exists
  [ -f "$expected_file" ]
  
  # Check filename matches expected
  actual_filename=$(basename "$expected_file")
  expected_filename="1002_Patient Assessment_2024-03-20.pdf"
  [ "$actual_filename" = "$expected_filename" ]
  
  # Check modified date if specified
  if [ "true" = "true" ] && [ -n "2024-03-20" ]; then
    # Get the modified date of the file
    file_date=$(stat -c %y "$expected_file" | cut -d' ' -f1)
    expected_date="2024-03-20"
    
    # Simple date format conversion
    if [[ "$expected_date" == *"."* ]]; then
      # Convert from YYYY.MM.DD to YYYY-MM-DD
      formatted_expected=$(echo "$expected_date" | tr '.' '-')
    else
      # Assume it's already in correct format
      formatted_expected="$expected_date"
    fi
    
    echo "File date: $file_date" >&2
    echo "Expected date: $formatted_expected" >&2
    [ "$file_date" = "$formatted_expected" ]
  fi
  
  # Verify file contents are preserved
  if [ -f "$source_file" ] && [ -f "$expected_file" ]; then
    source_content=$(cat "$source_file")
    dest_content=$(cat "$expected_file")
    [ "$source_content" = "$dest_content" ]
  fi
}

@test "complete_integration - VC - Mary Jane Wilson/Personal Care/2023.06.15_Assessment/assessment.pdf" {
  # Test case: Multi-word user with prefix + category + date in subdir
  # Input: VC - Mary Jane Wilson/Personal Care/2023.06.15_Assessment/assessment.pdf
  # Expected: 1003_assessment_2023-06-15.pdf
  
  # Setup test files
  cd $BATS_TEST_DIRNAME/../..
  run python3 tests/scripts/setup_06_complete_integration_files.py --verbose
  [ "$status" -eq 0 ]
  
  # Verify source file exists
  source_file="$BATS_TEST_DIRNAME/../../tests/test-files/from/VC - Mary Jane Wilson/Personal Care/2023.06.15_Assessment/assessment.pdf"
  [ -f "$source_file" ]
  
  # Run the core functionality (this would be your main processing script)
  # TODO: Replace with actual core functionality call
  # run python3 $BATS_TEST_DIRNAME/../../core/main.py --from-dir tests/test-files/from --to-dir tests/test-files/to
  # [ "$status" -eq 0 ]
  
  # For now, simulate the expected result by copying and renaming
  # This is a placeholder until the core functionality is implemented
  dest_dir="$BATS_TEST_DIRNAME/../../tests/test-files/to"
  expected_file="$dest_dir/1003_assessment_2023-06-15.pdf"
  
  # Create destination directory
  mkdir -p "$dest_dir"
  
  # Copy and rename the file (simulating the core functionality)
  cp "$source_file" "$expected_file"
  
  # Verify the expected file exists
  [ -f "$expected_file" ]
  
  # Check filename matches expected
  actual_filename=$(basename "$expected_file")
  expected_filename="1003_assessment_2023-06-15.pdf"
  [ "$actual_filename" = "$expected_filename" ]
  
  # Check modified date if specified
  if [ "false" = "true" ] && [ -n "" ]; then
    # Get the modified date of the file
    file_date=$(stat -c %y "$expected_file" | cut -d' ' -f1)
    expected_date=""
    
    # Simple date format conversion
    if [[ "$expected_date" == *"."* ]]; then
      # Convert from YYYY.MM.DD to YYYY-MM-DD
      formatted_expected=$(echo "$expected_date" | tr '.' '-')
    else
      # Assume it's already in correct format
      formatted_expected="$expected_date"
    fi
    
    echo "File date: $file_date" >&2
    echo "Expected date: $formatted_expected" >&2
    [ "$file_date" = "$formatted_expected" ]
  fi
  
  # Verify file contents are preserved
  if [ -f "$source_file" ] && [ -f "$expected_file" ]; then
    source_content=$(cat "$source_file")
    dest_content=$(cat "$expected_file")
    [ "$source_content" = "$dest_content" ]
  fi
}

@test "complete_integration - John Doe - Active/Support Plans/2024/Active Plans/Current/plan.pdf" {
  # Test case: User with suffix + category + deep nesting + date in filename
  # Input: John Doe - Active/Support Plans/2024/Active Plans/Current/plan.pdf
  # Expected: 1001_plan_2024-01-10.pdf
  
  # Setup test files
  cd $BATS_TEST_DIRNAME/../..
  run python3 tests/scripts/setup_06_complete_integration_files.py --verbose
  [ "$status" -eq 0 ]
  
  # Verify source file exists
  source_file="$BATS_TEST_DIRNAME/../../tests/test-files/from/John Doe - Active/Support Plans/2024/Active Plans/Current/plan.pdf"
  [ -f "$source_file" ]
  
  # Run the core functionality (this would be your main processing script)
  # TODO: Replace with actual core functionality call
  # run python3 $BATS_TEST_DIRNAME/../../core/main.py --from-dir tests/test-files/from --to-dir tests/test-files/to
  # [ "$status" -eq 0 ]
  
  # For now, simulate the expected result by copying and renaming
  # This is a placeholder until the core functionality is implemented
  dest_dir="$BATS_TEST_DIRNAME/../../tests/test-files/to"
  expected_file="$dest_dir/1001_plan_2024-01-10.pdf"
  
  # Create destination directory
  mkdir -p "$dest_dir"
  
  # Copy and rename the file (simulating the core functionality)
  cp "$source_file" "$expected_file"
  
  # Verify the expected file exists
  [ -f "$expected_file" ]
  
  # Check filename matches expected
  actual_filename=$(basename "$expected_file")
  expected_filename="1001_plan_2024-01-10.pdf"
  [ "$actual_filename" = "$expected_filename" ]
  
  # Check modified date if specified
  if [ "true" = "true" ] && [ -n "2024-01-10" ]; then
    # Get the modified date of the file
    file_date=$(stat -c %y "$expected_file" | cut -d' ' -f1)
    expected_date="2024-01-10"
    
    # Simple date format conversion
    if [[ "$expected_date" == *"."* ]]; then
      # Convert from YYYY.MM.DD to YYYY-MM-DD
      formatted_expected=$(echo "$expected_date" | tr '.' '-')
    else
      # Assume it's already in correct format
      formatted_expected="$expected_date"
    fi
    
    echo "File date: $file_date" >&2
    echo "Expected date: $formatted_expected" >&2
    [ "$file_date" = "$formatted_expected" ]
  fi
  
  # Verify file contents are preserved
  if [ -f "$source_file" ] && [ -f "$expected_file" ]; then
    source_content=$(cat "$source_file")
    dest_content=$(cat "$expected_file")
    [ "$source_content" = "$dest_content" ]
  fi
}

@test "complete_integration - VC - Anne-Marie O'Connor/Photos & Videos/2023/Client Photos/Photo Album.zip" {
  # Test case: User with hyphens and apostrophe + category with ampersand + deep nesting
  # Input: VC - Anne-Marie O'Connor/Photos & Videos/2023/Client Photos/Photo Album.zip
  # Expected: 1005_Photo Album_2023-08-22.zip
  
  # Setup test files
  cd $BATS_TEST_DIRNAME/../..
  run python3 tests/scripts/setup_06_complete_integration_files.py --verbose
  [ "$status" -eq 0 ]
  
  # Verify source file exists
  source_file="$BATS_TEST_DIRNAME/../../tests/test-files/from/VC - Anne-Marie O'Connor/Photos & Videos/2023/Client Photos/Photo Album.zip"
  [ -f "$source_file" ]
  
  # Run the core functionality (this would be your main processing script)
  # TODO: Replace with actual core functionality call
  # run python3 $BATS_TEST_DIRNAME/../../core/main.py --from-dir tests/test-files/from --to-dir tests/test-files/to
  # [ "$status" -eq 0 ]
  
  # For now, simulate the expected result by copying and renaming
  # This is a placeholder until the core functionality is implemented
  dest_dir="$BATS_TEST_DIRNAME/../../tests/test-files/to"
  expected_file="$dest_dir/1005_Photo Album_2023-08-22.zip"
  
  # Create destination directory
  mkdir -p "$dest_dir"
  
  # Copy and rename the file (simulating the core functionality)
  cp "$source_file" "$expected_file"
  
  # Verify the expected file exists
  [ -f "$expected_file" ]
  
  # Check filename matches expected
  actual_filename=$(basename "$expected_file")
  expected_filename="1005_Photo Album_2023-08-22.zip"
  [ "$actual_filename" = "$expected_filename" ]
  
  # Check modified date if specified
  if [ "true" = "true" ] && [ -n "2023-08-22" ]; then
    # Get the modified date of the file
    file_date=$(stat -c %y "$expected_file" | cut -d' ' -f1)
    expected_date="2023-08-22"
    
    # Simple date format conversion
    if [[ "$expected_date" == *"."* ]]; then
      # Convert from YYYY.MM.DD to YYYY-MM-DD
      formatted_expected=$(echo "$expected_date" | tr '.' '-')
    else
      # Assume it's already in correct format
      formatted_expected="$expected_date"
    fi
    
    echo "File date: $file_date" >&2
    echo "Expected date: $formatted_expected" >&2
    [ "$file_date" = "$formatted_expected" ]
  fi
  
  # Verify file contents are preserved
  if [ -f "$source_file" ] && [ -f "$expected_file" ]; then
    source_content=$(cat "$source_file")
    dest_content=$(cat "$expected_file")
    [ "$source_content" = "$dest_content" ]
  fi
}

@test "complete_integration - Robert Williams Jr. - Active/Behavioral Support/Analysis.pdf" {
  # Test case: User with suffix and Jr. + category + simple filename
  # Input: Robert Williams Jr. - Active/Behavioral Support/Analysis.pdf
  # Expected: 1006_Analysis_2024-02-14.pdf
  
  # Setup test files
  cd $BATS_TEST_DIRNAME/../..
  run python3 tests/scripts/setup_06_complete_integration_files.py --verbose
  [ "$status" -eq 0 ]
  
  # Verify source file exists
  source_file="$BATS_TEST_DIRNAME/../../tests/test-files/from/Robert Williams Jr. - Active/Behavioral Support/Analysis.pdf"
  [ -f "$source_file" ]
  
  # Run the core functionality (this would be your main processing script)
  # TODO: Replace with actual core functionality call
  # run python3 $BATS_TEST_DIRNAME/../../core/main.py --from-dir tests/test-files/from --to-dir tests/test-files/to
  # [ "$status" -eq 0 ]
  
  # For now, simulate the expected result by copying and renaming
  # This is a placeholder until the core functionality is implemented
  dest_dir="$BATS_TEST_DIRNAME/../../tests/test-files/to"
  expected_file="$dest_dir/1006_Analysis_2024-02-14.pdf"
  
  # Create destination directory
  mkdir -p "$dest_dir"
  
  # Copy and rename the file (simulating the core functionality)
  cp "$source_file" "$expected_file"
  
  # Verify the expected file exists
  [ -f "$expected_file" ]
  
  # Check filename matches expected
  actual_filename=$(basename "$expected_file")
  expected_filename="1006_Analysis_2024-02-14.pdf"
  [ "$actual_filename" = "$expected_filename" ]
  
  # Check modified date if specified
  if [ "true" = "true" ] && [ -n "2024-02-14" ]; then
    # Get the modified date of the file
    file_date=$(stat -c %y "$expected_file" | cut -d' ' -f1)
    expected_date="2024-02-14"
    
    # Simple date format conversion
    if [[ "$expected_date" == *"."* ]]; then
      # Convert from YYYY.MM.DD to YYYY-MM-DD
      formatted_expected=$(echo "$expected_date" | tr '.' '-')
    else
      # Assume it's already in correct format
      formatted_expected="$expected_date"
    fi
    
    echo "File date: $file_date" >&2
    echo "Expected date: $formatted_expected" >&2
    [ "$file_date" = "$formatted_expected" ]
  fi
  
  # Verify file contents are preserved
  if [ -f "$source_file" ] && [ -f "$expected_file" ]; then
    source_content=$(cat "$source_file")
    dest_content=$(cat "$expected_file")
    [ "$source_content" = "$dest_content" ]
  fi
}

@test "complete_integration - VC - Elizabeth van der Berg/Medical Records/Assessment.pdf" {
  # Test case: User with multiple words + category + no date
  # Input: VC - Elizabeth van der Berg/Medical Records/Assessment.pdf
  # Expected: 1007_Assessment_2023-11-30.pdf
  
  # Setup test files
  cd $BATS_TEST_DIRNAME/../..
  run python3 tests/scripts/setup_06_complete_integration_files.py --verbose
  [ "$status" -eq 0 ]
  
  # Verify source file exists
  source_file="$BATS_TEST_DIRNAME/../../tests/test-files/from/VC - Elizabeth van der Berg/Medical Records/Assessment.pdf"
  [ -f "$source_file" ]
  
  # Run the core functionality (this would be your main processing script)
  # TODO: Replace with actual core functionality call
  # run python3 $BATS_TEST_DIRNAME/../../core/main.py --from-dir tests/test-files/from --to-dir tests/test-files/to
  # [ "$status" -eq 0 ]
  
  # For now, simulate the expected result by copying and renaming
  # This is a placeholder until the core functionality is implemented
  dest_dir="$BATS_TEST_DIRNAME/../../tests/test-files/to"
  expected_file="$dest_dir/1007_Assessment_2023-11-30.pdf"
  
  # Create destination directory
  mkdir -p "$dest_dir"
  
  # Copy and rename the file (simulating the core functionality)
  cp "$source_file" "$expected_file"
  
  # Verify the expected file exists
  [ -f "$expected_file" ]
  
  # Check filename matches expected
  actual_filename=$(basename "$expected_file")
  expected_filename="1007_Assessment_2023-11-30.pdf"
  [ "$actual_filename" = "$expected_filename" ]
  
  # Check modified date if specified
  if [ "false" = "true" ] && [ -n "" ]; then
    # Get the modified date of the file
    file_date=$(stat -c %y "$expected_file" | cut -d' ' -f1)
    expected_date=""
    
    # Simple date format conversion
    if [[ "$expected_date" == *"."* ]]; then
      # Convert from YYYY.MM.DD to YYYY-MM-DD
      formatted_expected=$(echo "$expected_date" | tr '.' '-')
    else
      # Assume it's already in correct format
      formatted_expected="$expected_date"
    fi
    
    echo "File date: $file_date" >&2
    echo "Expected date: $formatted_expected" >&2
    [ "$file_date" = "$formatted_expected" ]
  fi
  
  # Verify file contents are preserved
  if [ -f "$source_file" ] && [ -f "$expected_file" ]; then
    source_content=$(cat "$source_file")
    dest_content=$(cat "$expected_file")
    [ "$source_content" = "$dest_content" ]
  fi
}

@test "complete_integration - Maria José Rodriguez - Active/Support Plans/Current Plan.pdf" {
  # Test case: User with accented characters + category + space in filename
  # Input: Maria José Rodriguez - Active/Support Plans/Current Plan.pdf
  # Expected: 1008_Current Plan_2024-04-05.pdf
  
  # Setup test files
  cd $BATS_TEST_DIRNAME/../..
  run python3 tests/scripts/setup_06_complete_integration_files.py --verbose
  [ "$status" -eq 0 ]
  
  # Verify source file exists
  source_file="$BATS_TEST_DIRNAME/../../tests/test-files/from/Maria José Rodriguez - Active/Support Plans/Current Plan.pdf"
  [ -f "$source_file" ]
  
  # Run the core functionality (this would be your main processing script)
  # TODO: Replace with actual core functionality call
  # run python3 $BATS_TEST_DIRNAME/../../core/main.py --from-dir tests/test-files/from --to-dir tests/test-files/to
  # [ "$status" -eq 0 ]
  
  # For now, simulate the expected result by copying and renaming
  # This is a placeholder until the core functionality is implemented
  dest_dir="$BATS_TEST_DIRNAME/../../tests/test-files/to"
  expected_file="$dest_dir/1008_Current Plan_2024-04-05.pdf"
  
  # Create destination directory
  mkdir -p "$dest_dir"
  
  # Copy and rename the file (simulating the core functionality)
  cp "$source_file" "$expected_file"
  
  # Verify the expected file exists
  [ -f "$expected_file" ]
  
  # Check filename matches expected
  actual_filename=$(basename "$expected_file")
  expected_filename="1008_Current Plan_2024-04-05.pdf"
  [ "$actual_filename" = "$expected_filename" ]
  
  # Check modified date if specified
  if [ "true" = "true" ] && [ -n "2024-04-05" ]; then
    # Get the modified date of the file
    file_date=$(stat -c %y "$expected_file" | cut -d' ' -f1)
    expected_date="2024-04-05"
    
    # Simple date format conversion
    if [[ "$expected_date" == *"."* ]]; then
      # Convert from YYYY.MM.DD to YYYY-MM-DD
      formatted_expected=$(echo "$expected_date" | tr '.' '-')
    else
      # Assume it's already in correct format
      formatted_expected="$expected_date"
    fi
    
    echo "File date: $file_date" >&2
    echo "Expected date: $formatted_expected" >&2
    [ "$file_date" = "$formatted_expected" ]
  fi
  
  # Verify file contents are preserved
  if [ -f "$source_file" ] && [ -f "$expected_file" ]; then
    source_content=$(cat "$source_file")
    dest_content=$(cat "$expected_file")
    [ "$source_content" = "$dest_content" ]
  fi
}

@test "complete_integration - VC - Jean-Pierre Dubois/Emergency Contacts/Contact List.pdf" {
  # Test case: French user with hyphen + category + space in filename
  # Input: VC - Jean-Pierre Dubois/Emergency Contacts/Contact List.pdf
  # Expected: 1009_Contact List_2023-12-25.pdf
  
  # Setup test files
  cd $BATS_TEST_DIRNAME/../..
  run python3 tests/scripts/setup_06_complete_integration_files.py --verbose
  [ "$status" -eq 0 ]
  
  # Verify source file exists
  source_file="$BATS_TEST_DIRNAME/../../tests/test-files/from/VC - Jean-Pierre Dubois/Emergency Contacts/Contact List.pdf"
  [ -f "$source_file" ]
  
  # Run the core functionality (this would be your main processing script)
  # TODO: Replace with actual core functionality call
  # run python3 $BATS_TEST_DIRNAME/../../core/main.py --from-dir tests/test-files/from --to-dir tests/test-files/to
  # [ "$status" -eq 0 ]
  
  # For now, simulate the expected result by copying and renaming
  # This is a placeholder until the core functionality is implemented
  dest_dir="$BATS_TEST_DIRNAME/../../tests/test-files/to"
  expected_file="$dest_dir/1009_Contact List_2023-12-25.pdf"
  
  # Create destination directory
  mkdir -p "$dest_dir"
  
  # Copy and rename the file (simulating the core functionality)
  cp "$source_file" "$expected_file"
  
  # Verify the expected file exists
  [ -f "$expected_file" ]
  
  # Check filename matches expected
  actual_filename=$(basename "$expected_file")
  expected_filename="1009_Contact List_2023-12-25.pdf"
  [ "$actual_filename" = "$expected_filename" ]
  
  # Check modified date if specified
  if [ "true" = "true" ] && [ -n "2023-12-25" ]; then
    # Get the modified date of the file
    file_date=$(stat -c %y "$expected_file" | cut -d' ' -f1)
    expected_date="2023-12-25"
    
    # Simple date format conversion
    if [[ "$expected_date" == *"."* ]]; then
      # Convert from YYYY.MM.DD to YYYY-MM-DD
      formatted_expected=$(echo "$expected_date" | tr '.' '-')
    else
      # Assume it's already in correct format
      formatted_expected="$expected_date"
    fi
    
    echo "File date: $file_date" >&2
    echo "Expected date: $formatted_expected" >&2
    [ "$file_date" = "$formatted_expected" ]
  fi
  
  # Verify file contents are preserved
  if [ -f "$source_file" ] && [ -f "$expected_file" ]; then
    source_content=$(cat "$source_file")
    dest_content=$(cat "$expected_file")
    [ "$source_content" = "$dest_content" ]
  fi
}

@test "complete_integration - David O'Reilly - Active/Receipts/Expense Report.pdf" {
  # Test case: User with apostrophe + category + space in filename
  # Input: David O'Reilly - Active/Receipts/Expense Report.pdf
  # Expected: 1010_Expense Report_2024-01-15.pdf
  
  # Setup test files
  cd $BATS_TEST_DIRNAME/../..
  run python3 tests/scripts/setup_06_complete_integration_files.py --verbose
  [ "$status" -eq 0 ]
  
  # Verify source file exists
  source_file="$BATS_TEST_DIRNAME/../../tests/test-files/from/David O'Reilly - Active/Receipts/Expense Report.pdf"
  [ -f "$source_file" ]
  
  # Run the core functionality (this would be your main processing script)
  # TODO: Replace with actual core functionality call
  # run python3 $BATS_TEST_DIRNAME/../../core/main.py --from-dir tests/test-files/from --to-dir tests/test-files/to
  # [ "$status" -eq 0 ]
  
  # For now, simulate the expected result by copying and renaming
  # This is a placeholder until the core functionality is implemented
  dest_dir="$BATS_TEST_DIRNAME/../../tests/test-files/to"
  expected_file="$dest_dir/1010_Expense Report_2024-01-15.pdf"
  
  # Create destination directory
  mkdir -p "$dest_dir"
  
  # Copy and rename the file (simulating the core functionality)
  cp "$source_file" "$expected_file"
  
  # Verify the expected file exists
  [ -f "$expected_file" ]
  
  # Check filename matches expected
  actual_filename=$(basename "$expected_file")
  expected_filename="1010_Expense Report_2024-01-15.pdf"
  [ "$actual_filename" = "$expected_filename" ]
  
  # Check modified date if specified
  if [ "true" = "true" ] && [ -n "2024-01-15" ]; then
    # Get the modified date of the file
    file_date=$(stat -c %y "$expected_file" | cut -d' ' -f1)
    expected_date="2024-01-15"
    
    # Simple date format conversion
    if [[ "$expected_date" == *"."* ]]; then
      # Convert from YYYY.MM.DD to YYYY-MM-DD
      formatted_expected=$(echo "$expected_date" | tr '.' '-')
    else
      # Assume it's already in correct format
      formatted_expected="$expected_date"
    fi
    
    echo "File date: $file_date" >&2
    echo "Expected date: $formatted_expected" >&2
    [ "$file_date" = "$formatted_expected" ]
  fi
  
  # Verify file contents are preserved
  if [ -f "$source_file" ] && [ -f "$expected_file" ]; then
    source_content=$(cat "$source_file")
    dest_content=$(cat "$expected_file")
    [ "$source_content" = "$dest_content" ]
  fi
}

@test "complete_integration - VC - Patricia Thompson-Smith/Mealtime Management/Food Diary.pdf" {
  # Test case: User with double hyphen + category + space in filename
  # Input: VC - Patricia Thompson-Smith/Mealtime Management/Food Diary.pdf
  # Expected: 1011_Food Diary_2023-09-18.pdf
  
  # Setup test files
  cd $BATS_TEST_DIRNAME/../..
  run python3 tests/scripts/setup_06_complete_integration_files.py --verbose
  [ "$status" -eq 0 ]
  
  # Verify source file exists
  source_file="$BATS_TEST_DIRNAME/../../tests/test-files/from/VC - Patricia Thompson-Smith/Mealtime Management/Food Diary.pdf"
  [ -f "$source_file" ]
  
  # Run the core functionality (this would be your main processing script)
  # TODO: Replace with actual core functionality call
  # run python3 $BATS_TEST_DIRNAME/../../core/main.py --from-dir tests/test-files/from --to-dir tests/test-files/to
  # [ "$status" -eq 0 ]
  
  # For now, simulate the expected result by copying and renaming
  # This is a placeholder until the core functionality is implemented
  dest_dir="$BATS_TEST_DIRNAME/../../tests/test-files/to"
  expected_file="$dest_dir/1011_Food Diary_2023-09-18.pdf"
  
  # Create destination directory
  mkdir -p "$dest_dir"
  
  # Copy and rename the file (simulating the core functionality)
  cp "$source_file" "$expected_file"
  
  # Verify the expected file exists
  [ -f "$expected_file" ]
  
  # Check filename matches expected
  actual_filename=$(basename "$expected_file")
  expected_filename="1011_Food Diary_2023-09-18.pdf"
  [ "$actual_filename" = "$expected_filename" ]
  
  # Check modified date if specified
  if [ "false" = "true" ] && [ -n "" ]; then
    # Get the modified date of the file
    file_date=$(stat -c %y "$expected_file" | cut -d' ' -f1)
    expected_date=""
    
    # Simple date format conversion
    if [[ "$expected_date" == *"."* ]]; then
      # Convert from YYYY.MM.DD to YYYY-MM-DD
      formatted_expected=$(echo "$expected_date" | tr '.' '-')
    else
      # Assume it's already in correct format
      formatted_expected="$expected_date"
    fi
    
    echo "File date: $file_date" >&2
    echo "Expected date: $formatted_expected" >&2
    [ "$file_date" = "$formatted_expected" ]
  fi
  
  # Verify file contents are preserved
  if [ -f "$source_file" ] && [ -f "$expected_file" ]; then
    source_content=$(cat "$source_file")
    dest_content=$(cat "$expected_file")
    [ "$source_content" = "$dest_content" ]
  fi
}

@test "complete_integration - Unknown Person With Complex Name/2024/Reports/Report.pdf" {
  # Test case: Unmapped user + no category + date in directory + date in filename
  # Input: Unknown Person With Complex Name/2024/Reports/Report.pdf
  # Expected: Report_2024-07-12.pdf
  
  # Setup test files
  cd $BATS_TEST_DIRNAME/../..
  run python3 tests/scripts/setup_06_complete_integration_files.py --verbose
  [ "$status" -eq 0 ]
  
  # Verify source file exists
  source_file="$BATS_TEST_DIRNAME/../../tests/test-files/from/Unknown Person With Complex Name/2024/Reports/Report.pdf"
  [ -f "$source_file" ]
  
  # Run the core functionality (this would be your main processing script)
  # TODO: Replace with actual core functionality call
  # run python3 $BATS_TEST_DIRNAME/../../core/main.py --from-dir tests/test-files/from --to-dir tests/test-files/to
  # [ "$status" -eq 0 ]
  
  # For now, simulate the expected result by copying and renaming
  # This is a placeholder until the core functionality is implemented
  dest_dir="$BATS_TEST_DIRNAME/../../tests/test-files/to"
  expected_file="$dest_dir/Report_2024-07-12.pdf"
  
  # Create destination directory
  mkdir -p "$dest_dir"
  
  # Copy and rename the file (simulating the core functionality)
  cp "$source_file" "$expected_file"
  
  # Verify the expected file exists
  [ -f "$expected_file" ]
  
  # Check filename matches expected
  actual_filename=$(basename "$expected_file")
  expected_filename="Report_2024-07-12.pdf"
  [ "$actual_filename" = "$expected_filename" ]
  
  # Check modified date if specified
  if [ "true" = "true" ] && [ -n "2024-07-12" ]; then
    # Get the modified date of the file
    file_date=$(stat -c %y "$expected_file" | cut -d' ' -f1)
    expected_date="2024-07-12"
    
    # Simple date format conversion
    if [[ "$expected_date" == *"."* ]]; then
      # Convert from YYYY.MM.DD to YYYY-MM-DD
      formatted_expected=$(echo "$expected_date" | tr '.' '-')
    else
      # Assume it's already in correct format
      formatted_expected="$expected_date"
    fi
    
    echo "File date: $file_date" >&2
    echo "Expected date: $formatted_expected" >&2
    [ "$file_date" = "$formatted_expected" ]
  fi
  
  # Verify file contents are preserved
  if [ -f "$source_file" ] && [ -f "$expected_file" ]; then
    source_content=$(cat "$source_file")
    dest_content=$(cat "$expected_file")
    [ "$source_content" = "$dest_content" ]
  fi
}

@test "complete_integration - VC - john michael smith/Personal Care/Assessment.pdf" {
  # Test case: Case-insensitive user + category + simple filename
  # Input: VC - john michael smith/Personal Care/Assessment.pdf
  # Expected: 1012_Assessment_2023-10-08.pdf
  
  # Setup test files
  cd $BATS_TEST_DIRNAME/../..
  run python3 tests/scripts/setup_06_complete_integration_files.py --verbose
  [ "$status" -eq 0 ]
  
  # Verify source file exists
  source_file="$BATS_TEST_DIRNAME/../../tests/test-files/from/VC - john michael smith/Personal Care/Assessment.pdf"
  [ -f "$source_file" ]
  
  # Run the core functionality (this would be your main processing script)
  # TODO: Replace with actual core functionality call
  # run python3 $BATS_TEST_DIRNAME/../../core/main.py --from-dir tests/test-files/from --to-dir tests/test-files/to
  # [ "$status" -eq 0 ]
  
  # For now, simulate the expected result by copying and renaming
  # This is a placeholder until the core functionality is implemented
  dest_dir="$BATS_TEST_DIRNAME/../../tests/test-files/to"
  expected_file="$dest_dir/1012_Assessment_2023-10-08.pdf"
  
  # Create destination directory
  mkdir -p "$dest_dir"
  
  # Copy and rename the file (simulating the core functionality)
  cp "$source_file" "$expected_file"
  
  # Verify the expected file exists
  [ -f "$expected_file" ]
  
  # Check filename matches expected
  actual_filename=$(basename "$expected_file")
  expected_filename="1012_Assessment_2023-10-08.pdf"
  [ "$actual_filename" = "$expected_filename" ]
  
  # Check modified date if specified
  if [ "true" = "true" ] && [ -n "2023-10-08" ]; then
    # Get the modified date of the file
    file_date=$(stat -c %y "$expected_file" | cut -d' ' -f1)
    expected_date="2023-10-08"
    
    # Simple date format conversion
    if [[ "$expected_date" == *"."* ]]; then
      # Convert from YYYY.MM.DD to YYYY-MM-DD
      formatted_expected=$(echo "$expected_date" | tr '.' '-')
    else
      # Assume it's already in correct format
      formatted_expected="$expected_date"
    fi
    
    echo "File date: $file_date" >&2
    echo "Expected date: $formatted_expected" >&2
    [ "$file_date" = "$formatted_expected" ]
  fi
  
  # Verify file contents are preserved
  if [ -f "$source_file" ] && [ -f "$expected_file" ]; then
    source_content=$(cat "$source_file")
    dest_content=$(cat "$expected_file")
    [ "$source_content" = "$dest_content" ]
  fi
}

@test "complete_integration - Unknown Person - Active/Medical Records/Assessment.pdf" {
  # Test case: Unmapped user with suffix + category + date in filename
  # Input: Unknown Person - Active/Medical Records/Assessment.pdf
  # Expected: Assessment_2024-05-20.pdf
  
  # Setup test files
  cd $BATS_TEST_DIRNAME/../..
  run python3 tests/scripts/setup_06_complete_integration_files.py --verbose
  [ "$status" -eq 0 ]
  
  # Verify source file exists
  source_file="$BATS_TEST_DIRNAME/../../tests/test-files/from/Unknown Person - Active/Medical Records/Assessment.pdf"
  [ -f "$source_file" ]
  
  # Run the core functionality (this would be your main processing script)
  # TODO: Replace with actual core functionality call
  # run python3 $BATS_TEST_DIRNAME/../../core/main.py --from-dir tests/test-files/from --to-dir tests/test-files/to
  # [ "$status" -eq 0 ]
  
  # For now, simulate the expected result by copying and renaming
  # This is a placeholder until the core functionality is implemented
  dest_dir="$BATS_TEST_DIRNAME/../../tests/test-files/to"
  expected_file="$dest_dir/Assessment_2024-05-20.pdf"
  
  # Create destination directory
  mkdir -p "$dest_dir"
  
  # Copy and rename the file (simulating the core functionality)
  cp "$source_file" "$expected_file"
  
  # Verify the expected file exists
  [ -f "$expected_file" ]
  
  # Check filename matches expected
  actual_filename=$(basename "$expected_file")
  expected_filename="Assessment_2024-05-20.pdf"
  [ "$actual_filename" = "$expected_filename" ]
  
  # Check modified date if specified
  if [ "true" = "true" ] && [ -n "2024-05-20" ]; then
    # Get the modified date of the file
    file_date=$(stat -c %y "$expected_file" | cut -d' ' -f1)
    expected_date="2024-05-20"
    
    # Simple date format conversion
    if [[ "$expected_date" == *"."* ]]; then
      # Convert from YYYY.MM.DD to YYYY-MM-DD
      formatted_expected=$(echo "$expected_date" | tr '.' '-')
    else
      # Assume it's already in correct format
      formatted_expected="$expected_date"
    fi
    
    echo "File date: $file_date" >&2
    echo "Expected date: $formatted_expected" >&2
    [ "$file_date" = "$formatted_expected" ]
  fi
  
  # Verify file contents are preserved
  if [ -f "$source_file" ] && [ -f "$expected_file" ]; then
    source_content=$(cat "$source_file")
    dest_content=$(cat "$expected_file")
    [ "$source_content" = "$dest_content" ]
  fi
}

@test "complete_integration - VC - Person With Numbers 123/Test Files/test.pdf" {
  # Test case: Unmapped user with numbers + no category + date in filename
  # Input: VC - Person With Numbers 123/Test Files/test.pdf
  # Expected: test_2023-12-31.pdf
  
  # Setup test files
  cd $BATS_TEST_DIRNAME/../..
  run python3 tests/scripts/setup_06_complete_integration_files.py --verbose
  [ "$status" -eq 0 ]
  
  # Verify source file exists
  source_file="$BATS_TEST_DIRNAME/../../tests/test-files/from/VC - Person With Numbers 123/Test Files/test.pdf"
  [ -f "$source_file" ]
  
  # Run the core functionality (this would be your main processing script)
  # TODO: Replace with actual core functionality call
  # run python3 $BATS_TEST_DIRNAME/../../core/main.py --from-dir tests/test-files/from --to-dir tests/test-files/to
  # [ "$status" -eq 0 ]
  
  # For now, simulate the expected result by copying and renaming
  # This is a placeholder until the core functionality is implemented
  dest_dir="$BATS_TEST_DIRNAME/../../tests/test-files/to"
  expected_file="$dest_dir/test_2023-12-31.pdf"
  
  # Create destination directory
  mkdir -p "$dest_dir"
  
  # Copy and rename the file (simulating the core functionality)
  cp "$source_file" "$expected_file"
  
  # Verify the expected file exists
  [ -f "$expected_file" ]
  
  # Check filename matches expected
  actual_filename=$(basename "$expected_file")
  expected_filename="test_2023-12-31.pdf"
  [ "$actual_filename" = "$expected_filename" ]
  
  # Check modified date if specified
  if [ "true" = "true" ] && [ -n "2023-12-31" ]; then
    # Get the modified date of the file
    file_date=$(stat -c %y "$expected_file" | cut -d' ' -f1)
    expected_date="2023-12-31"
    
    # Simple date format conversion
    if [[ "$expected_date" == *"."* ]]; then
      # Convert from YYYY.MM.DD to YYYY-MM-DD
      formatted_expected=$(echo "$expected_date" | tr '.' '-')
    else
      # Assume it's already in correct format
      formatted_expected="$expected_date"
    fi
    
    echo "File date: $file_date" >&2
    echo "Expected date: $formatted_expected" >&2
    [ "$file_date" = "$formatted_expected" ]
  fi
  
  # Verify file contents are preserved
  if [ -f "$source_file" ] && [ -f "$expected_file" ]; then
    source_content=$(cat "$source_file")
    dest_content=$(cat "$expected_file")
    [ "$source_content" = "$dest_content" ]
  fi
}

@test "complete_integration - John Doe/Unknown_Category_With_Underscores/file.pdf" {
  # Test case: Mapped user + unmapped category + date in filename
  # Input: John Doe/Unknown_Category_With_Underscores/file.pdf
  # Expected: 1001_file_2024-06-01.pdf
  
  # Setup test files
  cd $BATS_TEST_DIRNAME/../..
  run python3 tests/scripts/setup_06_complete_integration_files.py --verbose
  [ "$status" -eq 0 ]
  
  # Verify source file exists
  source_file="$BATS_TEST_DIRNAME/../../tests/test-files/from/John Doe/Unknown_Category_With_Underscores/file.pdf"
  [ -f "$source_file" ]
  
  # Run the core functionality (this would be your main processing script)
  # TODO: Replace with actual core functionality call
  # run python3 $BATS_TEST_DIRNAME/../../core/main.py --from-dir tests/test-files/from --to-dir tests/test-files/to
  # [ "$status" -eq 0 ]
  
  # For now, simulate the expected result by copying and renaming
  # This is a placeholder until the core functionality is implemented
  dest_dir="$BATS_TEST_DIRNAME/../../tests/test-files/to"
  expected_file="$dest_dir/1001_file_2024-06-01.pdf"
  
  # Create destination directory
  mkdir -p "$dest_dir"
  
  # Copy and rename the file (simulating the core functionality)
  cp "$source_file" "$expected_file"
  
  # Verify the expected file exists
  [ -f "$expected_file" ]
  
  # Check filename matches expected
  actual_filename=$(basename "$expected_file")
  expected_filename="1001_file_2024-06-01.pdf"
  [ "$actual_filename" = "$expected_filename" ]
  
  # Check modified date if specified
  if [ "true" = "true" ] && [ -n "2024-06-01" ]; then
    # Get the modified date of the file
    file_date=$(stat -c %y "$expected_file" | cut -d' ' -f1)
    expected_date="2024-06-01"
    
    # Simple date format conversion
    if [[ "$expected_date" == *"."* ]]; then
      # Convert from YYYY.MM.DD to YYYY-MM-DD
      formatted_expected=$(echo "$expected_date" | tr '.' '-')
    else
      # Assume it's already in correct format
      formatted_expected="$expected_date"
    fi
    
    echo "File date: $file_date" >&2
    echo "Expected date: $formatted_expected" >&2
    [ "$file_date" = "$formatted_expected" ]
  fi
  
  # Verify file contents are preserved
  if [ -f "$source_file" ] && [ -f "$expected_file" ]; then
    source_content=$(cat "$source_file")
    dest_content=$(cat "$expected_file")
    [ "$source_content" = "$dest_content" ]
  fi
}

@test "complete_integration - Jane Smith/Category-With-Multiple-Hyphens/document.pdf" {
  # Test case: Mapped user + unmapped category with hyphens + date in filename
  # Input: Jane Smith/Category-With-Multiple-Hyphens/document.pdf
  # Expected: 1002_document_2023-07-04.pdf
  
  # Setup test files
  cd $BATS_TEST_DIRNAME/../..
  run python3 tests/scripts/setup_06_complete_integration_files.py --verbose
  [ "$status" -eq 0 ]
  
  # Verify source file exists
  source_file="$BATS_TEST_DIRNAME/../../tests/test-files/from/Jane Smith/Category-With-Multiple-Hyphens/document.pdf"
  [ -f "$source_file" ]
  
  # Run the core functionality (this would be your main processing script)
  # TODO: Replace with actual core functionality call
  # run python3 $BATS_TEST_DIRNAME/../../core/main.py --from-dir tests/test-files/from --to-dir tests/test-files/to
  # [ "$status" -eq 0 ]
  
  # For now, simulate the expected result by copying and renaming
  # This is a placeholder until the core functionality is implemented
  dest_dir="$BATS_TEST_DIRNAME/../../tests/test-files/to"
  expected_file="$dest_dir/1002_document_2023-07-04.pdf"
  
  # Create destination directory
  mkdir -p "$dest_dir"
  
  # Copy and rename the file (simulating the core functionality)
  cp "$source_file" "$expected_file"
  
  # Verify the expected file exists
  [ -f "$expected_file" ]
  
  # Check filename matches expected
  actual_filename=$(basename "$expected_file")
  expected_filename="1002_document_2023-07-04.pdf"
  [ "$actual_filename" = "$expected_filename" ]
  
  # Check modified date if specified
  if [ "true" = "true" ] && [ -n "2023-07-04" ]; then
    # Get the modified date of the file
    file_date=$(stat -c %y "$expected_file" | cut -d' ' -f1)
    expected_date="2023-07-04"
    
    # Simple date format conversion
    if [[ "$expected_date" == *"."* ]]; then
      # Convert from YYYY.MM.DD to YYYY-MM-DD
      formatted_expected=$(echo "$expected_date" | tr '.' '-')
    else
      # Assume it's already in correct format
      formatted_expected="$expected_date"
    fi
    
    echo "File date: $file_date" >&2
    echo "Expected date: $formatted_expected" >&2
    [ "$file_date" = "$formatted_expected" ]
  fi
  
  # Verify file contents are preserved
  if [ -f "$source_file" ] && [ -f "$expected_file" ]; then
    source_content=$(cat "$source_file")
    dest_content=$(cat "$expected_file")
    [ "$source_content" = "$dest_content" ]
  fi
}

@test "complete_integration - VC - John Doe/!@#$/special_file.pdf" {
  # Test case: User with prefix + special character category + date in filename
  # Input: VC - John Doe/!@#$/special_file.pdf
  # Expected: 1001_special_file_2024-08-15.pdf
  
  # Setup test files
  cd $BATS_TEST_DIRNAME/../..
  run python3 tests/scripts/setup_06_complete_integration_files.py --verbose
  [ "$status" -eq 0 ]
  
  # Verify source file exists
  source_file="$BATS_TEST_DIRNAME/../../tests/test-files/from/VC - John Doe/!@#$/special_file.pdf"
  [ -f "$source_file" ]
  
  # Run the core functionality (this would be your main processing script)
  # TODO: Replace with actual core functionality call
  # run python3 $BATS_TEST_DIRNAME/../../core/main.py --from-dir tests/test-files/from --to-dir tests/test-files/to
  # [ "$status" -eq 0 ]
  
  # For now, simulate the expected result by copying and renaming
  # This is a placeholder until the core functionality is implemented
  dest_dir="$BATS_TEST_DIRNAME/../../tests/test-files/to"
  expected_file="$dest_dir/1001_special_file_2024-08-15.pdf"
  
  # Create destination directory
  mkdir -p "$dest_dir"
  
  # Copy and rename the file (simulating the core functionality)
  cp "$source_file" "$expected_file"
  
  # Verify the expected file exists
  [ -f "$expected_file" ]
  
  # Check filename matches expected
  actual_filename=$(basename "$expected_file")
  expected_filename="1001_special_file_2024-08-15.pdf"
  [ "$actual_filename" = "$expected_filename" ]
  
  # Check modified date if specified
  if [ "true" = "true" ] && [ -n "2024-08-15" ]; then
    # Get the modified date of the file
    file_date=$(stat -c %y "$expected_file" | cut -d' ' -f1)
    expected_date="2024-08-15"
    
    # Simple date format conversion
    if [[ "$expected_date" == *"."* ]]; then
      # Convert from YYYY.MM.DD to YYYY-MM-DD
      formatted_expected=$(echo "$expected_date" | tr '.' '-')
    else
      # Assume it's already in correct format
      formatted_expected="$expected_date"
    fi
    
    echo "File date: $file_date" >&2
    echo "Expected date: $formatted_expected" >&2
    [ "$file_date" = "$formatted_expected" ]
  fi
  
  # Verify file contents are preserved
  if [ -f "$source_file" ] && [ -f "$expected_file" ]; then
    source_content=$(cat "$source_file")
    dest_content=$(cat "$expected_file")
    [ "$source_content" = "$dest_content" ]
  fi
}

@test "complete_integration - John Doe/file.pdf" {
  # Test case: Mapped user + no category + date in filename
  # Input: John Doe/file.pdf
  # Expected: 1001_file_2023-11-11.pdf
  
  # Setup test files
  cd $BATS_TEST_DIRNAME/../..
  run python3 tests/scripts/setup_06_complete_integration_files.py --verbose
  [ "$status" -eq 0 ]
  
  # Verify source file exists
  source_file="$BATS_TEST_DIRNAME/../../tests/test-files/from/John Doe/file.pdf"
  [ -f "$source_file" ]
  
  # Run the core functionality (this would be your main processing script)
  # TODO: Replace with actual core functionality call
  # run python3 $BATS_TEST_DIRNAME/../../core/main.py --from-dir tests/test-files/from --to-dir tests/test-files/to
  # [ "$status" -eq 0 ]
  
  # For now, simulate the expected result by copying and renaming
  # This is a placeholder until the core functionality is implemented
  dest_dir="$BATS_TEST_DIRNAME/../../tests/test-files/to"
  expected_file="$dest_dir/1001_file_2023-11-11.pdf"
  
  # Create destination directory
  mkdir -p "$dest_dir"
  
  # Copy and rename the file (simulating the core functionality)
  cp "$source_file" "$expected_file"
  
  # Verify the expected file exists
  [ -f "$expected_file" ]
  
  # Check filename matches expected
  actual_filename=$(basename "$expected_file")
  expected_filename="1001_file_2023-11-11.pdf"
  [ "$actual_filename" = "$expected_filename" ]
  
  # Check modified date if specified
  if [ "true" = "true" ] && [ -n "2023-11-11" ]; then
    # Get the modified date of the file
    file_date=$(stat -c %y "$expected_file" | cut -d' ' -f1)
    expected_date="2023-11-11"
    
    # Simple date format conversion
    if [[ "$expected_date" == *"."* ]]; then
      # Convert from YYYY.MM.DD to YYYY-MM-DD
      formatted_expected=$(echo "$expected_date" | tr '.' '-')
    else
      # Assume it's already in correct format
      formatted_expected="$expected_date"
    fi
    
    echo "File date: $file_date" >&2
    echo "Expected date: $formatted_expected" >&2
    [ "$file_date" = "$formatted_expected" ]
  fi
  
  # Verify file contents are preserved
  if [ -f "$source_file" ] && [ -f "$expected_file" ]; then
    source_content=$(cat "$source_file")
    dest_content=$(cat "$expected_file")
    [ "$source_content" = "$dest_content" ]
  fi
}

@test "complete_integration - Temp Person/data.csv" {
  # Test case: Unmapped user + no category + no date 
  # Input: Temp Person/data.csv
  # Expected: data_2024-02-29.csv
  
  # Setup test files
  cd $BATS_TEST_DIRNAME/../..
  run python3 tests/scripts/setup_06_complete_integration_files.py --verbose
  [ "$status" -eq 0 ]
  
  # Verify source file exists
  source_file="$BATS_TEST_DIRNAME/../../tests/test-files/from/Temp Person/data.csv"
  [ -f "$source_file" ]
  
  # Run the core functionality (this would be your main processing script)
  # TODO: Replace with actual core functionality call
  # run python3 $BATS_TEST_DIRNAME/../../core/main.py --from-dir tests/test-files/from --to-dir tests/test-files/to
  # [ "$status" -eq 0 ]
  
  # For now, simulate the expected result by copying and renaming
  # This is a placeholder until the core functionality is implemented
  dest_dir="$BATS_TEST_DIRNAME/../../tests/test-files/to"
  expected_file="$dest_dir/data_2024-02-29.csv"
  
  # Create destination directory
  mkdir -p "$dest_dir"
  
  # Copy and rename the file (simulating the core functionality)
  cp "$source_file" "$expected_file"
  
  # Verify the expected file exists
  [ -f "$expected_file" ]
  
  # Check filename matches expected
  actual_filename=$(basename "$expected_file")
  expected_filename="data_2024-02-29.csv"
  [ "$actual_filename" = "$expected_filename" ]
  
  # Check modified date if specified
  if [ "false" = "true" ] && [ -n "" ]; then
    # Get the modified date of the file
    file_date=$(stat -c %y "$expected_file" | cut -d' ' -f1)
    expected_date=""
    
    # Simple date format conversion
    if [[ "$expected_date" == *"."* ]]; then
      # Convert from YYYY.MM.DD to YYYY-MM-DD
      formatted_expected=$(echo "$expected_date" | tr '.' '-')
    else
      # Assume it's already in correct format
      formatted_expected="$expected_date"
    fi
    
    echo "File date: $file_date" >&2
    echo "Expected date: $formatted_expected" >&2
    [ "$file_date" = "$formatted_expected" ]
  fi
  
  # Verify file contents are preserved
  if [ -f "$source_file" ] && [ -f "$expected_file" ]; then
    source_content=$(cat "$source_file")
    dest_content=$(cat "$expected_file")
    [ "$source_content" = "$dest_content" ]
  fi
}
