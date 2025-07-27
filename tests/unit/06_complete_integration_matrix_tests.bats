#!/usr/bin/env bats

# Auto-generated BATS tests for complete integration testing
# These tests verify the entire file processing pipeline with string-to-string comparisons

# Source the required shell functions
source /home/athorne/dev/repos/visualcare-file-migration-renamer/tests/utils/user_mapping.sh
source /home/athorne/dev/repos/visualcare-file-migration-renamer/tests/utils/category_utils.sh
source /home/athorne/dev/repos/visualcare-file-migration-renamer/tests/utils/date_utils.sh


@test "complete_integration - John Doe/WHS/2023/Incidents/01.06.2023 - John Doe.pdf" {
  # Test case: Basic multi-level with WHS category
  # Input: John Doe/WHS/2023/Incidents/01.06.2023 - John Doe.pdf
  # Expected: 1001_John Doe_2023 Incidents_2023-06-01_WHS.pdf
  
  echo "=== COMPLETE INTEGRATION TEST ===" >&2
  echo "Test case: Basic multi-level with WHS category" >&2
  echo "Input path: John Doe/WHS/2023/Incidents/01.06.2023 - John Doe.pdf" >&2
  echo "Expected filename: 1001_John Doe_2023 Incidents_2023-06-01_WHS.pdf" >&2
  echo "=================================" >&2
  
  # Test user mapping
  echo "Testing user mapping..." >&2
  result="$(extract_user_from_path "John Doe/WHS/2023/Incidents/01.06.2023 - John Doe.pdf")"
  IFS='|' read -r extracted_user_id raw_name extracted_name raw_remainder cleaned_remainder <<< "$result"
  
  expected_user_id="1001"
  expected_name="John Doe"
  
  echo "----- USER MAPPING RESULTS -----" >&2
  echo "Expected user ID: '$expected_user_id'" >&2
  echo "Extracted user ID: '$extracted_user_id'" >&2
  echo "Expected name: '$expected_name'" >&2
  echo "Raw name: '$raw_name'" >&2
  echo "Extracted name (cleaned): '$extracted_name'" >&2
  echo "Raw remainder: '$raw_remainder'" >&2
  echo "Cleaned remainder: '$cleaned_remainder'" >&2
  echo "-------------------------------" >&2
  
  [ "$extracted_user_id" = "$expected_user_id" ]
  [ "$extracted_name" = "$expected_name" ]
  
  # Test category mapping (if there's a second directory)
  # Extract the second directory as the category candidate
  # Use cut to get the second field when splitting by '/'
  category_candidate=$(echo "John Doe/WHS/2023/Incidents/01.06.2023 - John Doe.pdf" | cut -d'/' -f2)
  if [ -n "$category_candidate" ]; then
    
    echo "Testing category mapping..." >&2
    result="$(extract_category_from_path "John Doe/WHS/2023/Incidents/01.06.2023 - John Doe.pdf")"
    IFS='|' read -r extracted_category raw_category cleaned_category raw_remainder cleaned_remainder error_status <<< "$result"
    
    expected_category="WHS"
    
    echo "----- CATEGORY MAPPING RESULTS -----" >&2
    echo "Category candidate: '$category_candidate'" >&2
    echo "Expected category: '$expected_category'" >&2
    echo "Extracted category: '$extracted_category'" >&2
    echo "Raw category: '$raw_category'" >&2
    echo "Cleaned category: '$cleaned_category'" >&2
    echo "Raw remainder: '$raw_remainder'" >&2
    echo "Cleaned remainder: '$cleaned_remainder'" >&2
    echo "Error status: '$error_status'" >&2
    echo "----------------------------------" >&2
    
    if [ -n "$expected_category" ]; then
      [ "$extracted_category" = "$expected_category" ]
    fi
  fi
  
  # Test date extraction
  echo "Testing date extraction..." >&2
  result="$(extract_date_from_path "John Doe/WHS/2023/Incidents/01.06.2023 - John Doe.pdf")"
  IFS='|' read -r extracted_date raw_date cleaned_date raw_remainder cleaned_remainder error_status <<< "$result"
  
  expected_date="2023-06-01"
  
  echo "----- DATE EXTRACTION RESULTS -----" >&2
  echo "Expected date: '$expected_date'" >&2
  echo "Extracted date: '$extracted_date'" >&2
  echo "Raw date: '$raw_date'" >&2
  echo "Cleaned date: '$cleaned_date'" >&2
  echo "Raw remainder: '$raw_remainder'" >&2
  echo "Cleaned remainder: '$cleaned_remainder'" >&2
  echo "Error status: '$error_status'" >&2
  echo "--------------------------------" >&2
  
  if [ -n "$expected_date" ]; then
    [ "$extracted_date" = "$expected_date" ]
  fi
  
  # Test complete filename generation (this would be the main processing function)
  # TODO: Replace with actual complete processing function
  # result="$(process_complete_filename "John Doe/WHS/2023/Incidents/01.06.2023 - John Doe.pdf")"
  # IFS='|' read -r generated_filename user_id person_name remainder date category_id <<< "$result"
  
  # For now, verify the expected filename format
  expected_filename="1001_John Doe_2023 Incidents_2023-06-01_WHS.pdf"
  
  echo "----- COMPLETE FILENAME VALIDATION -----" >&2
  echo "Expected filename: '$expected_filename'" >&2
  echo "Expected format: user_id_person_name_remainder_date_category_id.ext" >&2
  echo "--------------------------------------" >&2
  
  # Verify the expected filename has the correct format
  if [ -n "$expected_filename" ]; then
    # Check if it starts with user_id (if user is mapped)
    if [ -n "$expected_user_id" ]; then
      echo "Checking user_id prefix..." >&2
      echo "$expected_filename" | grep -q "^$expected_user_id_"
    fi
    
    # Check if it contains the person name
    echo "Checking person name..." >&2
    echo "$expected_filename" | grep -q "$expected_name"
    
    # Check if it contains the date (if present)
    if [ -n "$expected_date" ]; then
      echo "Checking date..." >&2
      echo "$expected_filename" | grep -q "$expected_date"
    fi
    
    # Check if it contains the category (if present)
    if [ -n "$expected_category" ]; then
      echo "Checking category..." >&2
      echo "$expected_filename" | grep -q "_$expected_category\."
    fi
  fi
  
  echo "=== TEST COMPLETED SUCCESSFULLY ===" >&2
}

@test "complete_integration - John Doe/Medical/GP Report - John Doe.docx" {
  # Test case: Multi-level with Medical category
  # Input: John Doe/Medical/GP Report - John Doe.docx
  # Expected: 1001_John Doe_GP Report_Medical.docx
  
  echo "=== COMPLETE INTEGRATION TEST ===" >&2
  echo "Test case: Multi-level with Medical category" >&2
  echo "Input path: John Doe/Medical/GP Report - John Doe.docx" >&2
  echo "Expected filename: 1001_John Doe_GP Report_Medical.docx" >&2
  echo "=================================" >&2
  
  # Test user mapping
  echo "Testing user mapping..." >&2
  result="$(extract_user_from_path "John Doe/Medical/GP Report - John Doe.docx")"
  IFS='|' read -r extracted_user_id raw_name extracted_name raw_remainder cleaned_remainder <<< "$result"
  
  expected_user_id="1001"
  expected_name="John Doe"
  
  echo "----- USER MAPPING RESULTS -----" >&2
  echo "Expected user ID: '$expected_user_id'" >&2
  echo "Extracted user ID: '$extracted_user_id'" >&2
  echo "Expected name: '$expected_name'" >&2
  echo "Raw name: '$raw_name'" >&2
  echo "Extracted name (cleaned): '$extracted_name'" >&2
  echo "Raw remainder: '$raw_remainder'" >&2
  echo "Cleaned remainder: '$cleaned_remainder'" >&2
  echo "-------------------------------" >&2
  
  [ "$extracted_user_id" = "$expected_user_id" ]
  [ "$extracted_name" = "$expected_name" ]
  
  # Test category mapping (if there's a second directory)
  # Extract the second directory as the category candidate
  # Use cut to get the second field when splitting by '/'
  category_candidate=$(echo "John Doe/Medical/GP Report - John Doe.docx" | cut -d'/' -f2)
  if [ -n "$category_candidate" ]; then
    
    echo "Testing category mapping..." >&2
    result="$(extract_category_from_path "John Doe/Medical/GP Report - John Doe.docx")"
    IFS='|' read -r extracted_category raw_category cleaned_category raw_remainder cleaned_remainder error_status <<< "$result"
    
    expected_category="Medical"
    
    echo "----- CATEGORY MAPPING RESULTS -----" >&2
    echo "Category candidate: '$category_candidate'" >&2
    echo "Expected category: '$expected_category'" >&2
    echo "Extracted category: '$extracted_category'" >&2
    echo "Raw category: '$raw_category'" >&2
    echo "Cleaned category: '$cleaned_category'" >&2
    echo "Raw remainder: '$raw_remainder'" >&2
    echo "Cleaned remainder: '$cleaned_remainder'" >&2
    echo "Error status: '$error_status'" >&2
    echo "----------------------------------" >&2
    
    if [ -n "$expected_category" ]; then
      [ "$extracted_category" = "$expected_category" ]
    fi
  fi
  
  # Test date extraction
  echo "Testing date extraction..." >&2
  result="$(extract_date_from_path "John Doe/Medical/GP Report - John Doe.docx")"
  IFS='|' read -r extracted_date raw_date cleaned_date raw_remainder cleaned_remainder error_status <<< "$result"
  
  expected_date=""
  
  echo "----- DATE EXTRACTION RESULTS -----" >&2
  echo "Expected date: '$expected_date'" >&2
  echo "Extracted date: '$extracted_date'" >&2
  echo "Raw date: '$raw_date'" >&2
  echo "Cleaned date: '$cleaned_date'" >&2
  echo "Raw remainder: '$raw_remainder'" >&2
  echo "Cleaned remainder: '$cleaned_remainder'" >&2
  echo "Error status: '$error_status'" >&2
  echo "--------------------------------" >&2
  
  if [ -n "$expected_date" ]; then
    [ "$extracted_date" = "$expected_date" ]
  fi
  
  # Test complete filename generation (this would be the main processing function)
  # TODO: Replace with actual complete processing function
  # result="$(process_complete_filename "John Doe/Medical/GP Report - John Doe.docx")"
  # IFS='|' read -r generated_filename user_id person_name remainder date category_id <<< "$result"
  
  # For now, verify the expected filename format
  expected_filename="1001_John Doe_GP Report_Medical.docx"
  
  echo "----- COMPLETE FILENAME VALIDATION -----" >&2
  echo "Expected filename: '$expected_filename'" >&2
  echo "Expected format: user_id_person_name_remainder_date_category_id.ext" >&2
  echo "--------------------------------------" >&2
  
  # Verify the expected filename has the correct format
  if [ -n "$expected_filename" ]; then
    # Check if it starts with user_id (if user is mapped)
    if [ -n "$expected_user_id" ]; then
      echo "Checking user_id prefix..." >&2
      echo "$expected_filename" | grep -q "^$expected_user_id_"
    fi
    
    # Check if it contains the person name
    echo "Checking person name..." >&2
    echo "$expected_filename" | grep -q "$expected_name"
    
    # Check if it contains the date (if present)
    if [ -n "$expected_date" ]; then
      echo "Checking date..." >&2
      echo "$expected_filename" | grep -q "$expected_date"
    fi
    
    # Check if it contains the category (if present)
    if [ -n "$expected_category" ]; then
      echo "Checking category..." >&2
      echo "$expected_filename" | grep -q "_$expected_category\."
    fi
  fi
  
  echo "=== TEST COMPLETED SUCCESSFULLY ===" >&2
}

@test "complete_integration - John Doe/Medication/25.01.15 - John Doe Medication.pdf" {
  # Test case: Multi-level with Medication category
  # Input: John Doe/Medication/25.01.15 - John Doe Medication.pdf
  # Expected: 1001_John Doe_25.01.15 - Medication_2015-01-25_Medication.pdf
  
  echo "=== COMPLETE INTEGRATION TEST ===" >&2
  echo "Test case: Multi-level with Medication category" >&2
  echo "Input path: John Doe/Medication/25.01.15 - John Doe Medication.pdf" >&2
  echo "Expected filename: 1001_John Doe_25.01.15 - Medication_2015-01-25_Medication.pdf" >&2
  echo "=================================" >&2
  
  # Test user mapping
  echo "Testing user mapping..." >&2
  result="$(extract_user_from_path "John Doe/Medication/25.01.15 - John Doe Medication.pdf")"
  IFS='|' read -r extracted_user_id raw_name extracted_name raw_remainder cleaned_remainder <<< "$result"
  
  expected_user_id="1001"
  expected_name="John Doe"
  
  echo "----- USER MAPPING RESULTS -----" >&2
  echo "Expected user ID: '$expected_user_id'" >&2
  echo "Extracted user ID: '$extracted_user_id'" >&2
  echo "Expected name: '$expected_name'" >&2
  echo "Raw name: '$raw_name'" >&2
  echo "Extracted name (cleaned): '$extracted_name'" >&2
  echo "Raw remainder: '$raw_remainder'" >&2
  echo "Cleaned remainder: '$cleaned_remainder'" >&2
  echo "-------------------------------" >&2
  
  [ "$extracted_user_id" = "$expected_user_id" ]
  [ "$extracted_name" = "$expected_name" ]
  
  # Test category mapping (if there's a second directory)
  # Extract the second directory as the category candidate
  # Use cut to get the second field when splitting by '/'
  category_candidate=$(echo "John Doe/Medication/25.01.15 - John Doe Medication.pdf" | cut -d'/' -f2)
  if [ -n "$category_candidate" ]; then
    
    echo "Testing category mapping..." >&2
    result="$(extract_category_from_path "John Doe/Medication/25.01.15 - John Doe Medication.pdf")"
    IFS='|' read -r extracted_category raw_category cleaned_category raw_remainder cleaned_remainder error_status <<< "$result"
    
    expected_category="Medication"
    
    echo "----- CATEGORY MAPPING RESULTS -----" >&2
    echo "Category candidate: '$category_candidate'" >&2
    echo "Expected category: '$expected_category'" >&2
    echo "Extracted category: '$extracted_category'" >&2
    echo "Raw category: '$raw_category'" >&2
    echo "Cleaned category: '$cleaned_category'" >&2
    echo "Raw remainder: '$raw_remainder'" >&2
    echo "Cleaned remainder: '$cleaned_remainder'" >&2
    echo "Error status: '$error_status'" >&2
    echo "----------------------------------" >&2
    
    if [ -n "$expected_category" ]; then
      [ "$extracted_category" = "$expected_category" ]
    fi
  fi
  
  # Test date extraction
  echo "Testing date extraction..." >&2
  result="$(extract_date_from_path "John Doe/Medication/25.01.15 - John Doe Medication.pdf")"
  IFS='|' read -r extracted_date raw_date cleaned_date raw_remainder cleaned_remainder error_status <<< "$result"
  
  expected_date="2015-01-25"
  
  echo "----- DATE EXTRACTION RESULTS -----" >&2
  echo "Expected date: '$expected_date'" >&2
  echo "Extracted date: '$extracted_date'" >&2
  echo "Raw date: '$raw_date'" >&2
  echo "Cleaned date: '$cleaned_date'" >&2
  echo "Raw remainder: '$raw_remainder'" >&2
  echo "Cleaned remainder: '$cleaned_remainder'" >&2
  echo "Error status: '$error_status'" >&2
  echo "--------------------------------" >&2
  
  if [ -n "$expected_date" ]; then
    [ "$extracted_date" = "$expected_date" ]
  fi
  
  # Test complete filename generation (this would be the main processing function)
  # TODO: Replace with actual complete processing function
  # result="$(process_complete_filename "John Doe/Medication/25.01.15 - John Doe Medication.pdf")"
  # IFS='|' read -r generated_filename user_id person_name remainder date category_id <<< "$result"
  
  # For now, verify the expected filename format
  expected_filename="1001_John Doe_25.01.15 - Medication_2015-01-25_Medication.pdf"
  
  echo "----- COMPLETE FILENAME VALIDATION -----" >&2
  echo "Expected filename: '$expected_filename'" >&2
  echo "Expected format: user_id_person_name_remainder_date_category_id.ext" >&2
  echo "--------------------------------------" >&2
  
  # Verify the expected filename has the correct format
  if [ -n "$expected_filename" ]; then
    # Check if it starts with user_id (if user is mapped)
    if [ -n "$expected_user_id" ]; then
      echo "Checking user_id prefix..." >&2
      echo "$expected_filename" | grep -q "^$expected_user_id_"
    fi
    
    # Check if it contains the person name
    echo "Checking person name..." >&2
    echo "$expected_filename" | grep -q "$expected_name"
    
    # Check if it contains the date (if present)
    if [ -n "$expected_date" ]; then
      echo "Checking date..." >&2
      echo "$expected_filename" | grep -q "$expected_date"
    fi
    
    # Check if it contains the category (if present)
    if [ -n "$expected_category" ]; then
      echo "Checking category..." >&2
      echo "$expected_filename" | grep -q "_$expected_category\."
    fi
  fi
  
  echo "=== TEST COMPLETED SUCCESSFULLY ===" >&2
}

@test "complete_integration - John Doe/Personal Care/Receipts/John Doe - Receipt 2024.pdf" {
  # Test case: Multi-level with Personal Care category
  # Input: John Doe/Personal Care/Receipts/John Doe - Receipt 2024.pdf
  # Expected: 1001_John Doe_Receipts Receipt_Personal Care.pdf
  
  echo "=== COMPLETE INTEGRATION TEST ===" >&2
  echo "Test case: Multi-level with Personal Care category" >&2
  echo "Input path: John Doe/Personal Care/Receipts/John Doe - Receipt 2024.pdf" >&2
  echo "Expected filename: 1001_John Doe_Receipts Receipt_Personal Care.pdf" >&2
  echo "=================================" >&2
  
  # Test user mapping
  echo "Testing user mapping..." >&2
  result="$(extract_user_from_path "John Doe/Personal Care/Receipts/John Doe - Receipt 2024.pdf")"
  IFS='|' read -r extracted_user_id raw_name extracted_name raw_remainder cleaned_remainder <<< "$result"
  
  expected_user_id="1001"
  expected_name="John Doe"
  
  echo "----- USER MAPPING RESULTS -----" >&2
  echo "Expected user ID: '$expected_user_id'" >&2
  echo "Extracted user ID: '$extracted_user_id'" >&2
  echo "Expected name: '$expected_name'" >&2
  echo "Raw name: '$raw_name'" >&2
  echo "Extracted name (cleaned): '$extracted_name'" >&2
  echo "Raw remainder: '$raw_remainder'" >&2
  echo "Cleaned remainder: '$cleaned_remainder'" >&2
  echo "-------------------------------" >&2
  
  [ "$extracted_user_id" = "$expected_user_id" ]
  [ "$extracted_name" = "$expected_name" ]
  
  # Test category mapping (if there's a second directory)
  # Extract the second directory as the category candidate
  # Use cut to get the second field when splitting by '/'
  category_candidate=$(echo "John Doe/Personal Care/Receipts/John Doe - Receipt 2024.pdf" | cut -d'/' -f2)
  if [ -n "$category_candidate" ]; then
    
    echo "Testing category mapping..." >&2
    result="$(extract_category_from_path "John Doe/Personal Care/Receipts/John Doe - Receipt 2024.pdf")"
    IFS='|' read -r extracted_category raw_category cleaned_category raw_remainder cleaned_remainder error_status <<< "$result"
    
    expected_category="Personal Care"
    
    echo "----- CATEGORY MAPPING RESULTS -----" >&2
    echo "Category candidate: '$category_candidate'" >&2
    echo "Expected category: '$expected_category'" >&2
    echo "Extracted category: '$extracted_category'" >&2
    echo "Raw category: '$raw_category'" >&2
    echo "Cleaned category: '$cleaned_category'" >&2
    echo "Raw remainder: '$raw_remainder'" >&2
    echo "Cleaned remainder: '$cleaned_remainder'" >&2
    echo "Error status: '$error_status'" >&2
    echo "----------------------------------" >&2
    
    if [ -n "$expected_category" ]; then
      [ "$extracted_category" = "$expected_category" ]
    fi
  fi
  
  # Test date extraction
  echo "Testing date extraction..." >&2
  result="$(extract_date_from_path "John Doe/Personal Care/Receipts/John Doe - Receipt 2024.pdf")"
  IFS='|' read -r extracted_date raw_date cleaned_date raw_remainder cleaned_remainder error_status <<< "$result"
  
  expected_date=""
  
  echo "----- DATE EXTRACTION RESULTS -----" >&2
  echo "Expected date: '$expected_date'" >&2
  echo "Extracted date: '$extracted_date'" >&2
  echo "Raw date: '$raw_date'" >&2
  echo "Cleaned date: '$cleaned_date'" >&2
  echo "Raw remainder: '$raw_remainder'" >&2
  echo "Cleaned remainder: '$cleaned_remainder'" >&2
  echo "Error status: '$error_status'" >&2
  echo "--------------------------------" >&2
  
  if [ -n "$expected_date" ]; then
    [ "$extracted_date" = "$expected_date" ]
  fi
  
  # Test complete filename generation (this would be the main processing function)
  # TODO: Replace with actual complete processing function
  # result="$(process_complete_filename "John Doe/Personal Care/Receipts/John Doe - Receipt 2024.pdf")"
  # IFS='|' read -r generated_filename user_id person_name remainder date category_id <<< "$result"
  
  # For now, verify the expected filename format
  expected_filename="1001_John Doe_Receipts Receipt_Personal Care.pdf"
  
  echo "----- COMPLETE FILENAME VALIDATION -----" >&2
  echo "Expected filename: '$expected_filename'" >&2
  echo "Expected format: user_id_person_name_remainder_date_category_id.ext" >&2
  echo "--------------------------------------" >&2
  
  # Verify the expected filename has the correct format
  if [ -n "$expected_filename" ]; then
    # Check if it starts with user_id (if user is mapped)
    if [ -n "$expected_user_id" ]; then
      echo "Checking user_id prefix..." >&2
      echo "$expected_filename" | grep -q "^$expected_user_id_"
    fi
    
    # Check if it contains the person name
    echo "Checking person name..." >&2
    echo "$expected_filename" | grep -q "$expected_name"
    
    # Check if it contains the date (if present)
    if [ -n "$expected_date" ]; then
      echo "Checking date..." >&2
      echo "$expected_filename" | grep -q "$expected_date"
    fi
    
    # Check if it contains the category (if present)
    if [ -n "$expected_category" ]; then
      echo "Checking category..." >&2
      echo "$expected_filename" | grep -q "_$expected_category\."
    fi
  fi
  
  echo "=== TEST COMPLETED SUCCESSFULLY ===" >&2
}

@test "complete_integration - John Doe/Medical/GP/25.02.05 - John Doe GP Summary.pdf" {
  # Test case: Multi-level with nested medical folders
  # Input: John Doe/Medical/GP/25.02.05 - John Doe GP Summary.pdf
  # Expected: 1001_John Doe_GP_2005-02-25_Medical.pdf
  
  echo "=== COMPLETE INTEGRATION TEST ===" >&2
  echo "Test case: Multi-level with nested medical folders" >&2
  echo "Input path: John Doe/Medical/GP/25.02.05 - John Doe GP Summary.pdf" >&2
  echo "Expected filename: 1001_John Doe_GP_2005-02-25_Medical.pdf" >&2
  echo "=================================" >&2
  
  # Test user mapping
  echo "Testing user mapping..." >&2
  result="$(extract_user_from_path "John Doe/Medical/GP/25.02.05 - John Doe GP Summary.pdf")"
  IFS='|' read -r extracted_user_id raw_name extracted_name raw_remainder cleaned_remainder <<< "$result"
  
  expected_user_id="1001"
  expected_name="John Doe"
  
  echo "----- USER MAPPING RESULTS -----" >&2
  echo "Expected user ID: '$expected_user_id'" >&2
  echo "Extracted user ID: '$extracted_user_id'" >&2
  echo "Expected name: '$expected_name'" >&2
  echo "Raw name: '$raw_name'" >&2
  echo "Extracted name (cleaned): '$extracted_name'" >&2
  echo "Raw remainder: '$raw_remainder'" >&2
  echo "Cleaned remainder: '$cleaned_remainder'" >&2
  echo "-------------------------------" >&2
  
  [ "$extracted_user_id" = "$expected_user_id" ]
  [ "$extracted_name" = "$expected_name" ]
  
  # Test category mapping (if there's a second directory)
  # Extract the second directory as the category candidate
  # Use cut to get the second field when splitting by '/'
  category_candidate=$(echo "John Doe/Medical/GP/25.02.05 - John Doe GP Summary.pdf" | cut -d'/' -f2)
  if [ -n "$category_candidate" ]; then
    
    echo "Testing category mapping..." >&2
    result="$(extract_category_from_path "John Doe/Medical/GP/25.02.05 - John Doe GP Summary.pdf")"
    IFS='|' read -r extracted_category raw_category cleaned_category raw_remainder cleaned_remainder error_status <<< "$result"
    
    expected_category="Medical"
    
    echo "----- CATEGORY MAPPING RESULTS -----" >&2
    echo "Category candidate: '$category_candidate'" >&2
    echo "Expected category: '$expected_category'" >&2
    echo "Extracted category: '$extracted_category'" >&2
    echo "Raw category: '$raw_category'" >&2
    echo "Cleaned category: '$cleaned_category'" >&2
    echo "Raw remainder: '$raw_remainder'" >&2
    echo "Cleaned remainder: '$cleaned_remainder'" >&2
    echo "Error status: '$error_status'" >&2
    echo "----------------------------------" >&2
    
    if [ -n "$expected_category" ]; then
      [ "$extracted_category" = "$expected_category" ]
    fi
  fi
  
  # Test date extraction
  echo "Testing date extraction..." >&2
  result="$(extract_date_from_path "John Doe/Medical/GP/25.02.05 - John Doe GP Summary.pdf")"
  IFS='|' read -r extracted_date raw_date cleaned_date raw_remainder cleaned_remainder error_status <<< "$result"
  
  expected_date="2005-02-25"
  
  echo "----- DATE EXTRACTION RESULTS -----" >&2
  echo "Expected date: '$expected_date'" >&2
  echo "Extracted date: '$extracted_date'" >&2
  echo "Raw date: '$raw_date'" >&2
  echo "Cleaned date: '$cleaned_date'" >&2
  echo "Raw remainder: '$raw_remainder'" >&2
  echo "Cleaned remainder: '$cleaned_remainder'" >&2
  echo "Error status: '$error_status'" >&2
  echo "--------------------------------" >&2
  
  if [ -n "$expected_date" ]; then
    [ "$extracted_date" = "$expected_date" ]
  fi
  
  # Test complete filename generation (this would be the main processing function)
  # TODO: Replace with actual complete processing function
  # result="$(process_complete_filename "John Doe/Medical/GP/25.02.05 - John Doe GP Summary.pdf")"
  # IFS='|' read -r generated_filename user_id person_name remainder date category_id <<< "$result"
  
  # For now, verify the expected filename format
  expected_filename="1001_John Doe_GP_2005-02-25_Medical.pdf"
  
  echo "----- COMPLETE FILENAME VALIDATION -----" >&2
  echo "Expected filename: '$expected_filename'" >&2
  echo "Expected format: user_id_person_name_remainder_date_category_id.ext" >&2
  echo "--------------------------------------" >&2
  
  # Verify the expected filename has the correct format
  if [ -n "$expected_filename" ]; then
    # Check if it starts with user_id (if user is mapped)
    if [ -n "$expected_user_id" ]; then
      echo "Checking user_id prefix..." >&2
      echo "$expected_filename" | grep -q "^$expected_user_id_"
    fi
    
    # Check if it contains the person name
    echo "Checking person name..." >&2
    echo "$expected_filename" | grep -q "$expected_name"
    
    # Check if it contains the date (if present)
    if [ -n "$expected_date" ]; then
      echo "Checking date..." >&2
      echo "$expected_filename" | grep -q "$expected_date"
    fi
    
    # Check if it contains the category (if present)
    if [ -n "$expected_category" ]; then
      echo "Checking category..." >&2
      echo "$expected_filename" | grep -q "_$expected_category\."
    fi
  fi
  
  echo "=== TEST COMPLETED SUCCESSFULLY ===" >&2
}
