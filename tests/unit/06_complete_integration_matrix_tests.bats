#!/usr/bin/env bats

# Auto-generated BATS tests for complete integration testing
# These tests verify the entire file processing pipeline with string-to-string comparisons

# Source the required shell functions
source /home/athorne/dev/repos/visualcare-file-migration-renamer/tests/utils/user_mapping.sh
source /home/athorne/dev/repos/visualcare-file-migration-renamer/tests/utils/category_utils.sh
source /home/athorne/dev/repos/visualcare-file-migration-renamer/tests/utils/date_utils.sh
source /home/athorne/dev/repos/visualcare-file-migration-renamer/tests/utils/complete_processing.sh


@test "complete_integration - John Doe/WHS/2023/Incidents/01.06.2023 - John Doe.pdf" {
  # Test case: Basic multi-level with WHS category
  # Input: John Doe/WHS/2023/Incidents/01.06.2023 - John Doe.pdf
  # Expected: 1001_John Doe_2023 Incidents_20230601_WHS_yes.pdf
  
  echo "=== COMPLETE INTEGRATION TEST ===" >&2
  echo "Test case: Basic multi-level with WHS category" >&2
  echo "Input path: John Doe/WHS/2023/Incidents/01.06.2023 - John Doe.pdf" >&2
  echo "Expected filename: 1001_John Doe_2023 Incidents_20230601_WHS_yes.pdf" >&2
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
  result="$(extract_date_from_path_for_string_test_fallback "John Doe/WHS/2023/Incidents/01.06.2023 - John Doe.pdf" "" "today" "filename")"
  IFS='|' read -r extracted_date raw_date cleaned_date raw_remainder cleaned_remainder error_status <<< "$result"
  
  expected_date="20230601"
  
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
  
  # Test complete filename generation
  echo "Testing complete filename generation..." >&2
  
  # Use the test-specific function that handles fallback dates
  result="$(extract_complete_filename_with_fallback "John Doe/WHS/2023/Incidents/01.06.2023 - John Doe.pdf" "" "today" "filename")"
  
  expected_filename="1001_John Doe_2023 Incidents_20230601_WHS_yes.pdf"
  
  echo "----- COMPLETE FILENAME VALIDATION -----" >&2
  echo "Expected filename: '$expected_filename'" >&2
  echo "Generated filename: '$result'" >&2
  echo "-------------------------------------" >&2
  
  # Compare the actual generated filename with the expected filename
  if [ -n "$expected_filename" ]; then
    [ "$result" = "$expected_filename" ]
  fi
  
  echo "=== TEST COMPLETED SUCCESSFULLY ===" >&2
}

@test "complete_integration - John Doe/Medical/GP Report - John Doe.docx" {
  # Test case: Multi-level with Medical category
  # Input: John Doe/Medical/GP Report - John Doe.docx
  # Expected: 1001_John Doe_GP Report_20240115_Medical_yes.docx
  
  echo "=== COMPLETE INTEGRATION TEST ===" >&2
  echo "Test case: Multi-level with Medical category" >&2
  echo "Input path: John Doe/Medical/GP Report - John Doe.docx" >&2
  echo "Expected filename: 1001_John Doe_GP Report_20240115_Medical_yes.docx" >&2
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
  result="$(extract_date_from_path_for_string_test_fallback "John Doe/Medical/GP Report - John Doe.docx" "2024-01-15" "today" "modified")"
  IFS='|' read -r extracted_date raw_date cleaned_date raw_remainder cleaned_remainder error_status <<< "$result"
  
  expected_date="20240115"
  
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
  
  # Test complete filename generation
  echo "Testing complete filename generation..." >&2
  
  # Use the test-specific function that handles fallback dates
  result="$(extract_complete_filename_with_fallback "John Doe/Medical/GP Report - John Doe.docx" "2024-01-15" "today" "modified")"
  
  expected_filename="1001_John Doe_GP Report_20240115_Medical_yes.docx"
  
  echo "----- COMPLETE FILENAME VALIDATION -----" >&2
  echo "Expected filename: '$expected_filename'" >&2
  echo "Generated filename: '$result'" >&2
  echo "-------------------------------------" >&2
  
  # Compare the actual generated filename with the expected filename
  if [ -n "$expected_filename" ]; then
    [ "$result" = "$expected_filename" ]
  fi
  
  echo "=== TEST COMPLETED SUCCESSFULLY ===" >&2
}

@test "complete_integration - John Doe/Medication/25.01.15 - John Doe Medication Report.pdf" {
  # Test case: Multi-level with Medication category - has remainder
  # Input: John Doe/Medication/25.01.15 - John Doe Medication Report.pdf
  # Expected: 1001_John Doe_Medication Report_20150125_Medication_yes.pdf
  
  echo "=== COMPLETE INTEGRATION TEST ===" >&2
  echo "Test case: Multi-level with Medication category - has remainder" >&2
  echo "Input path: John Doe/Medication/25.01.15 - John Doe Medication Report.pdf" >&2
  echo "Expected filename: 1001_John Doe_Medication Report_20150125_Medication_yes.pdf" >&2
  echo "=================================" >&2
  
  # Test user mapping
  echo "Testing user mapping..." >&2
  result="$(extract_user_from_path "John Doe/Medication/25.01.15 - John Doe Medication Report.pdf")"
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
  category_candidate=$(echo "John Doe/Medication/25.01.15 - John Doe Medication Report.pdf" | cut -d'/' -f2)
  if [ -n "$category_candidate" ]; then
    
    echo "Testing category mapping..." >&2
    result="$(extract_category_from_path "John Doe/Medication/25.01.15 - John Doe Medication Report.pdf")"
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
  result="$(extract_date_from_path_for_string_test_fallback "John Doe/Medication/25.01.15 - John Doe Medication Report.pdf" "" "today" "filename")"
  IFS='|' read -r extracted_date raw_date cleaned_date raw_remainder cleaned_remainder error_status <<< "$result"
  
  expected_date="20150125"
  
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
  
  # Test complete filename generation
  echo "Testing complete filename generation..." >&2
  
  # Use the test-specific function that handles fallback dates
  result="$(extract_complete_filename_with_fallback "John Doe/Medication/25.01.15 - John Doe Medication Report.pdf" "" "today" "filename")"
  
  expected_filename="1001_John Doe_Medication Report_20150125_Medication_yes.pdf"
  
  echo "----- COMPLETE FILENAME VALIDATION -----" >&2
  echo "Expected filename: '$expected_filename'" >&2
  echo "Generated filename: '$result'" >&2
  echo "-------------------------------------" >&2
  
  # Compare the actual generated filename with the expected filename
  if [ -n "$expected_filename" ]; then
    [ "$result" = "$expected_filename" ]
  fi
  
  echo "=== TEST COMPLETED SUCCESSFULLY ===" >&2
}

@test "complete_integration - John Doe/Personal Care/Receipts/John Doe - Receipt 2024.pdf" {
  # Test case: Multi-level with Personal Care category
  # Input: John Doe/Personal Care/Receipts/John Doe - Receipt 2024.pdf
  # Expected: 1001_John Doe_Receipts Receipt 2024_20240120_Personal Care_yes.pdf
  
  echo "=== COMPLETE INTEGRATION TEST ===" >&2
  echo "Test case: Multi-level with Personal Care category" >&2
  echo "Input path: John Doe/Personal Care/Receipts/John Doe - Receipt 2024.pdf" >&2
  echo "Expected filename: 1001_John Doe_Receipts Receipt 2024_20240120_Personal Care_yes.pdf" >&2
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
  result="$(extract_date_from_path_for_string_test_fallback "John Doe/Personal Care/Receipts/John Doe - Receipt 2024.pdf" "2024-01-20" "today" "modified")"
  IFS='|' read -r extracted_date raw_date cleaned_date raw_remainder cleaned_remainder error_status <<< "$result"
  
  expected_date="20240120"
  
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
  
  # Test complete filename generation
  echo "Testing complete filename generation..." >&2
  
  # Use the test-specific function that handles fallback dates
  result="$(extract_complete_filename_with_fallback "John Doe/Personal Care/Receipts/John Doe - Receipt 2024.pdf" "2024-01-20" "today" "modified")"
  
  expected_filename="1001_John Doe_Receipts Receipt 2024_20240120_Personal Care_yes.pdf"
  
  echo "----- COMPLETE FILENAME VALIDATION -----" >&2
  echo "Expected filename: '$expected_filename'" >&2
  echo "Generated filename: '$result'" >&2
  echo "-------------------------------------" >&2
  
  # Compare the actual generated filename with the expected filename
  if [ -n "$expected_filename" ]; then
    [ "$result" = "$expected_filename" ]
  fi
  
  echo "=== TEST COMPLETED SUCCESSFULLY ===" >&2
}

@test "complete_integration - John Doe/Medical/GP/25.02.05 - John Doe GP Summary.pdf" {
  # Test case: Multi-level with nested medical folders
  # Input: John Doe/Medical/GP/25.02.05 - John Doe GP Summary.pdf
  # Expected: 1001_John Doe_GP GP Summary_20050225_Medical_yes.pdf
  
  echo "=== COMPLETE INTEGRATION TEST ===" >&2
  echo "Test case: Multi-level with nested medical folders" >&2
  echo "Input path: John Doe/Medical/GP/25.02.05 - John Doe GP Summary.pdf" >&2
  echo "Expected filename: 1001_John Doe_GP GP Summary_20050225_Medical_yes.pdf" >&2
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
  result="$(extract_date_from_path_for_string_test_fallback "John Doe/Medical/GP/25.02.05 - John Doe GP Summary.pdf" "" "today" "filename")"
  IFS='|' read -r extracted_date raw_date cleaned_date raw_remainder cleaned_remainder error_status <<< "$result"
  
  expected_date="20050225"
  
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
  
  # Test complete filename generation
  echo "Testing complete filename generation..." >&2
  
  # Use the test-specific function that handles fallback dates
  result="$(extract_complete_filename_with_fallback "John Doe/Medical/GP/25.02.05 - John Doe GP Summary.pdf" "" "today" "filename")"
  
  expected_filename="1001_John Doe_GP GP Summary_20050225_Medical_yes.pdf"
  
  echo "----- COMPLETE FILENAME VALIDATION -----" >&2
  echo "Expected filename: '$expected_filename'" >&2
  echo "Generated filename: '$result'" >&2
  echo "-------------------------------------" >&2
  
  # Compare the actual generated filename with the expected filename
  if [ -n "$expected_filename" ]; then
    [ "$result" = "$expected_filename" ]
  fi
  
  echo "=== TEST COMPLETED SUCCESSFULLY ===" >&2
}

@test "complete_integration - John Doe/Support Plans/2023.07.25 - John Doe Support Plan.pdf" {
  # Test case: Support Plans with date in filename
  # Input: John Doe/Support Plans/2023.07.25 - John Doe Support Plan.pdf
  # Expected: 1001_John Doe_Support Plan_20230725_Support Plans_yes.pdf
  
  echo "=== COMPLETE INTEGRATION TEST ===" >&2
  echo "Test case: Support Plans with date in filename" >&2
  echo "Input path: John Doe/Support Plans/2023.07.25 - John Doe Support Plan.pdf" >&2
  echo "Expected filename: 1001_John Doe_Support Plan_20230725_Support Plans_yes.pdf" >&2
  echo "=================================" >&2
  
  # Test user mapping
  echo "Testing user mapping..." >&2
  result="$(extract_user_from_path "John Doe/Support Plans/2023.07.25 - John Doe Support Plan.pdf")"
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
  category_candidate=$(echo "John Doe/Support Plans/2023.07.25 - John Doe Support Plan.pdf" | cut -d'/' -f2)
  if [ -n "$category_candidate" ]; then
    
    echo "Testing category mapping..." >&2
    result="$(extract_category_from_path "John Doe/Support Plans/2023.07.25 - John Doe Support Plan.pdf")"
    IFS='|' read -r extracted_category raw_category cleaned_category raw_remainder cleaned_remainder error_status <<< "$result"
    
    expected_category="Support Plans"
    
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
  result="$(extract_date_from_path_for_string_test_fallback "John Doe/Support Plans/2023.07.25 - John Doe Support Plan.pdf" "" "today" "filename")"
  IFS='|' read -r extracted_date raw_date cleaned_date raw_remainder cleaned_remainder error_status <<< "$result"
  
  expected_date="20230725"
  
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
  
  # Test complete filename generation
  echo "Testing complete filename generation..." >&2
  
  # Use the test-specific function that handles fallback dates
  result="$(extract_complete_filename_with_fallback "John Doe/Support Plans/2023.07.25 - John Doe Support Plan.pdf" "" "today" "filename")"
  
  expected_filename="1001_John Doe_Support Plan_20230725_Support Plans_yes.pdf"
  
  echo "----- COMPLETE FILENAME VALIDATION -----" >&2
  echo "Expected filename: '$expected_filename'" >&2
  echo "Generated filename: '$result'" >&2
  echo "-------------------------------------" >&2
  
  # Compare the actual generated filename with the expected filename
  if [ -n "$expected_filename" ]; then
    [ "$result" = "$expected_filename" ]
  fi
  
  echo "=== TEST COMPLETED SUCCESSFULLY ===" >&2
}

@test "complete_integration - John Doe/Behavioral Support/Journal of PBI - John Doe.pdf" {
  # Test case: Behavioral Support with no date
  # Input: John Doe/Behavioral Support/Journal of PBI - John Doe.pdf
  # Expected: 1001_John Doe_Journal of PBI_20240125_Behavioral Support_yes.pdf
  
  echo "=== COMPLETE INTEGRATION TEST ===" >&2
  echo "Test case: Behavioral Support with no date" >&2
  echo "Input path: John Doe/Behavioral Support/Journal of PBI - John Doe.pdf" >&2
  echo "Expected filename: 1001_John Doe_Journal of PBI_20240125_Behavioral Support_yes.pdf" >&2
  echo "=================================" >&2
  
  # Test user mapping
  echo "Testing user mapping..." >&2
  result="$(extract_user_from_path "John Doe/Behavioral Support/Journal of PBI - John Doe.pdf")"
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
  category_candidate=$(echo "John Doe/Behavioral Support/Journal of PBI - John Doe.pdf" | cut -d'/' -f2)
  if [ -n "$category_candidate" ]; then
    
    echo "Testing category mapping..." >&2
    result="$(extract_category_from_path "John Doe/Behavioral Support/Journal of PBI - John Doe.pdf")"
    IFS='|' read -r extracted_category raw_category cleaned_category raw_remainder cleaned_remainder error_status <<< "$result"
    
    expected_category="Behavioral Support"
    
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
  result="$(extract_date_from_path_for_string_test_fallback "John Doe/Behavioral Support/Journal of PBI - John Doe.pdf" "2024-01-25" "today" "modified")"
  IFS='|' read -r extracted_date raw_date cleaned_date raw_remainder cleaned_remainder error_status <<< "$result"
  
  expected_date="20240125"
  
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
  
  # Test complete filename generation
  echo "Testing complete filename generation..." >&2
  
  # Use the test-specific function that handles fallback dates
  result="$(extract_complete_filename_with_fallback "John Doe/Behavioral Support/Journal of PBI - John Doe.pdf" "2024-01-25" "today" "modified")"
  
  expected_filename="1001_John Doe_Journal of PBI_20240125_Behavioral Support_yes.pdf"
  
  echo "----- COMPLETE FILENAME VALIDATION -----" >&2
  echo "Expected filename: '$expected_filename'" >&2
  echo "Generated filename: '$result'" >&2
  echo "-------------------------------------" >&2
  
  # Compare the actual generated filename with the expected filename
  if [ -n "$expected_filename" ]; then
    [ "$result" = "$expected_filename" ]
  fi
  
  echo "=== TEST COMPLETED SUCCESSFULLY ===" >&2
}

@test "complete_integration - John Doe/Medical Records/Goals - John Doe.pdf" {
  # Test case: Medical Records with simple filename
  # Input: John Doe/Medical Records/Goals - John Doe.pdf
  # Expected: 1001_John Doe_Goals_20230101_Medical Records_yes.pdf
  
  echo "=== COMPLETE INTEGRATION TEST ===" >&2
  echo "Test case: Medical Records with simple filename" >&2
  echo "Input path: John Doe/Medical Records/Goals - John Doe.pdf" >&2
  echo "Expected filename: 1001_John Doe_Goals_20230101_Medical Records_yes.pdf" >&2
  echo "=================================" >&2
  
  # Test user mapping
  echo "Testing user mapping..." >&2
  result="$(extract_user_from_path "John Doe/Medical Records/Goals - John Doe.pdf")"
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
  category_candidate=$(echo "John Doe/Medical Records/Goals - John Doe.pdf" | cut -d'/' -f2)
  if [ -n "$category_candidate" ]; then
    
    echo "Testing category mapping..." >&2
    result="$(extract_category_from_path "John Doe/Medical Records/Goals - John Doe.pdf")"
    IFS='|' read -r extracted_category raw_category cleaned_category raw_remainder cleaned_remainder error_status <<< "$result"
    
    expected_category="Medical Records"
    
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
  result="$(extract_date_from_path_for_string_test_fallback "John Doe/Medical Records/Goals - John Doe.pdf" "2023-01-01" "today" "modified")"
  IFS='|' read -r extracted_date raw_date cleaned_date raw_remainder cleaned_remainder error_status <<< "$result"
  
  expected_date="20230101"
  
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
  
  # Test complete filename generation
  echo "Testing complete filename generation..." >&2
  
  # Use the test-specific function that handles fallback dates
  result="$(extract_complete_filename_with_fallback "John Doe/Medical Records/Goals - John Doe.pdf" "2023-01-01" "today" "modified")"
  
  expected_filename="1001_John Doe_Goals_20230101_Medical Records_yes.pdf"
  
  echo "----- COMPLETE FILENAME VALIDATION -----" >&2
  echo "Expected filename: '$expected_filename'" >&2
  echo "Generated filename: '$result'" >&2
  echo "-------------------------------------" >&2
  
  # Compare the actual generated filename with the expected filename
  if [ -n "$expected_filename" ]; then
    [ "$result" = "$expected_filename" ]
  fi
  
  echo "=== TEST COMPLETED SUCCESSFULLY ===" >&2
}

@test "complete_integration - John Doe/Photos/John Doe at the Cinema.jpg" {
  # Test case: Photos with descriptive filename
  # Input: John Doe/Photos/John Doe at the Cinema.jpg
  # Expected: 1001_John Doe_at the Cinema_20250105_Photos_yes.jpg
  
  echo "=== COMPLETE INTEGRATION TEST ===" >&2
  echo "Test case: Photos with descriptive filename" >&2
  echo "Input path: John Doe/Photos/John Doe at the Cinema.jpg" >&2
  echo "Expected filename: 1001_John Doe_at the Cinema_20250105_Photos_yes.jpg" >&2
  echo "=================================" >&2
  
  # Test user mapping
  echo "Testing user mapping..." >&2
  result="$(extract_user_from_path "John Doe/Photos/John Doe at the Cinema.jpg")"
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
  category_candidate=$(echo "John Doe/Photos/John Doe at the Cinema.jpg" | cut -d'/' -f2)
  if [ -n "$category_candidate" ]; then
    
    echo "Testing category mapping..." >&2
    result="$(extract_category_from_path "John Doe/Photos/John Doe at the Cinema.jpg")"
    IFS='|' read -r extracted_category raw_category cleaned_category raw_remainder cleaned_remainder error_status <<< "$result"
    
    expected_category="Photos"
    
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
  result="$(extract_date_from_path_for_string_test_fallback "John Doe/Photos/John Doe at the Cinema.jpg" "2025-01-05" "today" "modified")"
  IFS='|' read -r extracted_date raw_date cleaned_date raw_remainder cleaned_remainder error_status <<< "$result"
  
  expected_date="20250105"
  
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
  
  # Test complete filename generation
  echo "Testing complete filename generation..." >&2
  
  # Use the test-specific function that handles fallback dates
  result="$(extract_complete_filename_with_fallback "John Doe/Photos/John Doe at the Cinema.jpg" "2025-01-05" "today" "modified")"
  
  expected_filename="1001_John Doe_at the Cinema_20250105_Photos_yes.jpg"
  
  echo "----- COMPLETE FILENAME VALIDATION -----" >&2
  echo "Expected filename: '$expected_filename'" >&2
  echo "Generated filename: '$result'" >&2
  echo "-------------------------------------" >&2
  
  # Compare the actual generated filename with the expected filename
  if [ -n "$expected_filename" ]; then
    [ "$result" = "$expected_filename" ]
  fi
  
  echo "=== TEST COMPLETED SUCCESSFULLY ===" >&2
}

@test "complete_integration - John Doe/Team Meetings/12.02.2025 Team Meeting Agenda - John Doe.docx" {
  # Test case: Team Meetings with date in filename
  # Input: John Doe/Team Meetings/12.02.2025 Team Meeting Agenda - John Doe.docx
  # Expected: 1001_John Doe_Team Meeting Agenda_20250212_Team Meetings_yes.docx
  
  echo "=== COMPLETE INTEGRATION TEST ===" >&2
  echo "Test case: Team Meetings with date in filename" >&2
  echo "Input path: John Doe/Team Meetings/12.02.2025 Team Meeting Agenda - John Doe.docx" >&2
  echo "Expected filename: 1001_John Doe_Team Meeting Agenda_20250212_Team Meetings_yes.docx" >&2
  echo "=================================" >&2
  
  # Test user mapping
  echo "Testing user mapping..." >&2
  result="$(extract_user_from_path "John Doe/Team Meetings/12.02.2025 Team Meeting Agenda - John Doe.docx")"
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
  category_candidate=$(echo "John Doe/Team Meetings/12.02.2025 Team Meeting Agenda - John Doe.docx" | cut -d'/' -f2)
  if [ -n "$category_candidate" ]; then
    
    echo "Testing category mapping..." >&2
    result="$(extract_category_from_path "John Doe/Team Meetings/12.02.2025 Team Meeting Agenda - John Doe.docx")"
    IFS='|' read -r extracted_category raw_category cleaned_category raw_remainder cleaned_remainder error_status <<< "$result"
    
    expected_category="Team Meetings"
    
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
  result="$(extract_date_from_path_for_string_test_fallback "John Doe/Team Meetings/12.02.2025 Team Meeting Agenda - John Doe.docx" "" "today" "filename")"
  IFS='|' read -r extracted_date raw_date cleaned_date raw_remainder cleaned_remainder error_status <<< "$result"
  
  expected_date="20250212"
  
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
  
  # Test complete filename generation
  echo "Testing complete filename generation..." >&2
  
  # Use the test-specific function that handles fallback dates
  result="$(extract_complete_filename_with_fallback "John Doe/Team Meetings/12.02.2025 Team Meeting Agenda - John Doe.docx" "" "today" "filename")"
  
  expected_filename="1001_John Doe_Team Meeting Agenda_20250212_Team Meetings_yes.docx"
  
  echo "----- COMPLETE FILENAME VALIDATION -----" >&2
  echo "Expected filename: '$expected_filename'" >&2
  echo "Generated filename: '$result'" >&2
  echo "-------------------------------------" >&2
  
  # Compare the actual generated filename with the expected filename
  if [ -n "$expected_filename" ]; then
    [ "$result" = "$expected_filename" ]
  fi
  
  echo "=== TEST COMPLETED SUCCESSFULLY ===" >&2
}

@test "complete_integration - Jane Smith/Medical/GP Report - Jane Smith.docx" {
  # Test case: Jane Smith Medical category
  # Input: Jane Smith/Medical/GP Report - Jane Smith.docx
  # Expected: 1002_Jane Smith_GP Report_20240130_Medical_yes.docx
  
  echo "=== COMPLETE INTEGRATION TEST ===" >&2
  echo "Test case: Jane Smith Medical category" >&2
  echo "Input path: Jane Smith/Medical/GP Report - Jane Smith.docx" >&2
  echo "Expected filename: 1002_Jane Smith_GP Report_20240130_Medical_yes.docx" >&2
  echo "=================================" >&2
  
  # Test user mapping
  echo "Testing user mapping..." >&2
  result="$(extract_user_from_path "Jane Smith/Medical/GP Report - Jane Smith.docx")"
  IFS='|' read -r extracted_user_id raw_name extracted_name raw_remainder cleaned_remainder <<< "$result"
  
  expected_user_id="1002"
  expected_name="Jane Smith"
  
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
  category_candidate=$(echo "Jane Smith/Medical/GP Report - Jane Smith.docx" | cut -d'/' -f2)
  if [ -n "$category_candidate" ]; then
    
    echo "Testing category mapping..." >&2
    result="$(extract_category_from_path "Jane Smith/Medical/GP Report - Jane Smith.docx")"
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
  result="$(extract_date_from_path_for_string_test_fallback "Jane Smith/Medical/GP Report - Jane Smith.docx" "2024-01-30" "today" "modified")"
  IFS='|' read -r extracted_date raw_date cleaned_date raw_remainder cleaned_remainder error_status <<< "$result"
  
  expected_date="20240130"
  
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
  
  # Test complete filename generation
  echo "Testing complete filename generation..." >&2
  
  # Use the test-specific function that handles fallback dates
  result="$(extract_complete_filename_with_fallback "Jane Smith/Medical/GP Report - Jane Smith.docx" "2024-01-30" "today" "modified")"
  
  expected_filename="1002_Jane Smith_GP Report_20240130_Medical_yes.docx"
  
  echo "----- COMPLETE FILENAME VALIDATION -----" >&2
  echo "Expected filename: '$expected_filename'" >&2
  echo "Generated filename: '$result'" >&2
  echo "-------------------------------------" >&2
  
  # Compare the actual generated filename with the expected filename
  if [ -n "$expected_filename" ]; then
    [ "$result" = "$expected_filename" ]
  fi
  
  echo "=== TEST COMPLETED SUCCESSFULLY ===" >&2
}

@test "complete_integration - Jane Smith/WHS/Hazard Reports/Risk Assessment - Jane Smith.pdf" {
  # Test case: Jane Smith deep multi-level WHS
  # Input: Jane Smith/WHS/Hazard Reports/Risk Assessment - Jane Smith.pdf
  # Expected: 1002_Jane Smith_Hazard Reports Risk Assessment_20240205_WHS_yes.pdf
  
  echo "=== COMPLETE INTEGRATION TEST ===" >&2
  echo "Test case: Jane Smith deep multi-level WHS" >&2
  echo "Input path: Jane Smith/WHS/Hazard Reports/Risk Assessment - Jane Smith.pdf" >&2
  echo "Expected filename: 1002_Jane Smith_Hazard Reports Risk Assessment_20240205_WHS_yes.pdf" >&2
  echo "=================================" >&2
  
  # Test user mapping
  echo "Testing user mapping..." >&2
  result="$(extract_user_from_path "Jane Smith/WHS/Hazard Reports/Risk Assessment - Jane Smith.pdf")"
  IFS='|' read -r extracted_user_id raw_name extracted_name raw_remainder cleaned_remainder <<< "$result"
  
  expected_user_id="1002"
  expected_name="Jane Smith"
  
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
  category_candidate=$(echo "Jane Smith/WHS/Hazard Reports/Risk Assessment - Jane Smith.pdf" | cut -d'/' -f2)
  if [ -n "$category_candidate" ]; then
    
    echo "Testing category mapping..." >&2
    result="$(extract_category_from_path "Jane Smith/WHS/Hazard Reports/Risk Assessment - Jane Smith.pdf")"
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
  result="$(extract_date_from_path_for_string_test_fallback "Jane Smith/WHS/Hazard Reports/Risk Assessment - Jane Smith.pdf" "2024-02-05" "today" "modified")"
  IFS='|' read -r extracted_date raw_date cleaned_date raw_remainder cleaned_remainder error_status <<< "$result"
  
  expected_date="20240205"
  
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
  
  # Test complete filename generation
  echo "Testing complete filename generation..." >&2
  
  # Use the test-specific function that handles fallback dates
  result="$(extract_complete_filename_with_fallback "Jane Smith/WHS/Hazard Reports/Risk Assessment - Jane Smith.pdf" "2024-02-05" "today" "modified")"
  
  expected_filename="1002_Jane Smith_Hazard Reports Risk Assessment_20240205_WHS_yes.pdf"
  
  echo "----- COMPLETE FILENAME VALIDATION -----" >&2
  echo "Expected filename: '$expected_filename'" >&2
  echo "Generated filename: '$result'" >&2
  echo "-------------------------------------" >&2
  
  # Compare the actual generated filename with the expected filename
  if [ -n "$expected_filename" ]; then
    [ "$result" = "$expected_filename" ]
  fi
  
  echo "=== TEST COMPLETED SUCCESSFULLY ===" >&2
}

@test "complete_integration - Jane Smith/Behavioral Support/Journal of PBI.pdf" {
  # Test case: Jane Smith Behavioral Support no date
  # Input: Jane Smith/Behavioral Support/Journal of PBI.pdf
  # Expected: 1002_Jane Smith_Journal of PBI_20230101_Behavioral Support_yes.pdf
  
  echo "=== COMPLETE INTEGRATION TEST ===" >&2
  echo "Test case: Jane Smith Behavioral Support no date" >&2
  echo "Input path: Jane Smith/Behavioral Support/Journal of PBI.pdf" >&2
  echo "Expected filename: 1002_Jane Smith_Journal of PBI_20230101_Behavioral Support_yes.pdf" >&2
  echo "=================================" >&2
  
  # Test user mapping
  echo "Testing user mapping..." >&2
  result="$(extract_user_from_path "Jane Smith/Behavioral Support/Journal of PBI.pdf")"
  IFS='|' read -r extracted_user_id raw_name extracted_name raw_remainder cleaned_remainder <<< "$result"
  
  expected_user_id="1002"
  expected_name="Jane Smith"
  
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
  category_candidate=$(echo "Jane Smith/Behavioral Support/Journal of PBI.pdf" | cut -d'/' -f2)
  if [ -n "$category_candidate" ]; then
    
    echo "Testing category mapping..." >&2
    result="$(extract_category_from_path "Jane Smith/Behavioral Support/Journal of PBI.pdf")"
    IFS='|' read -r extracted_category raw_category cleaned_category raw_remainder cleaned_remainder error_status <<< "$result"
    
    expected_category="Behavioral Support"
    
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
  result="$(extract_date_from_path_for_string_test_fallback "Jane Smith/Behavioral Support/Journal of PBI.pdf" "2023-01-01" "today" "modified")"
  IFS='|' read -r extracted_date raw_date cleaned_date raw_remainder cleaned_remainder error_status <<< "$result"
  
  expected_date="20230101"
  
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
  
  # Test complete filename generation
  echo "Testing complete filename generation..." >&2
  
  # Use the test-specific function that handles fallback dates
  result="$(extract_complete_filename_with_fallback "Jane Smith/Behavioral Support/Journal of PBI.pdf" "2023-01-01" "today" "modified")"
  
  expected_filename="1002_Jane Smith_Journal of PBI_20230101_Behavioral Support_yes.pdf"
  
  echo "----- COMPLETE FILENAME VALIDATION -----" >&2
  echo "Expected filename: '$expected_filename'" >&2
  echo "Generated filename: '$result'" >&2
  echo "-------------------------------------" >&2
  
  # Compare the actual generated filename with the expected filename
  if [ -n "$expected_filename" ]; then
    [ "$result" = "$expected_filename" ]
  fi
  
  echo "=== TEST COMPLETED SUCCESSFULLY ===" >&2
}

@test "complete_integration - Jane Smith/Incident Reports/06.02.2023 - Jane Smith.pdf" {
  # Test case: Jane Smith Incident Reports with date
  # Input: Jane Smith/Incident Reports/06.02.2023 - Jane Smith.pdf
  # Expected: 1002_Jane Smith_20230206_Incident Reports_yes.pdf
  
  echo "=== COMPLETE INTEGRATION TEST ===" >&2
  echo "Test case: Jane Smith Incident Reports with date" >&2
  echo "Input path: Jane Smith/Incident Reports/06.02.2023 - Jane Smith.pdf" >&2
  echo "Expected filename: 1002_Jane Smith_20230206_Incident Reports_yes.pdf" >&2
  echo "=================================" >&2
  
  # Test user mapping
  echo "Testing user mapping..." >&2
  result="$(extract_user_from_path "Jane Smith/Incident Reports/06.02.2023 - Jane Smith.pdf")"
  IFS='|' read -r extracted_user_id raw_name extracted_name raw_remainder cleaned_remainder <<< "$result"
  
  expected_user_id="1002"
  expected_name="Jane Smith"
  
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
  category_candidate=$(echo "Jane Smith/Incident Reports/06.02.2023 - Jane Smith.pdf" | cut -d'/' -f2)
  if [ -n "$category_candidate" ]; then
    
    echo "Testing category mapping..." >&2
    result="$(extract_category_from_path "Jane Smith/Incident Reports/06.02.2023 - Jane Smith.pdf")"
    IFS='|' read -r extracted_category raw_category cleaned_category raw_remainder cleaned_remainder error_status <<< "$result"
    
    expected_category="Incident Reports"
    
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
  result="$(extract_date_from_path_for_string_test_fallback "Jane Smith/Incident Reports/06.02.2023 - Jane Smith.pdf" "" "today" "filename")"
  IFS='|' read -r extracted_date raw_date cleaned_date raw_remainder cleaned_remainder error_status <<< "$result"
  
  expected_date="20230206"
  
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
  
  # Test complete filename generation
  echo "Testing complete filename generation..." >&2
  
  # Use the test-specific function that handles fallback dates
  result="$(extract_complete_filename_with_fallback "Jane Smith/Incident Reports/06.02.2023 - Jane Smith.pdf" "" "today" "filename")"
  
  expected_filename="1002_Jane Smith_20230206_Incident Reports_yes.pdf"
  
  echo "----- COMPLETE FILENAME VALIDATION -----" >&2
  echo "Expected filename: '$expected_filename'" >&2
  echo "Generated filename: '$result'" >&2
  echo "-------------------------------------" >&2
  
  # Compare the actual generated filename with the expected filename
  if [ -n "$expected_filename" ]; then
    [ "$result" = "$expected_filename" ]
  fi
  
  echo "=== TEST COMPLETED SUCCESSFULLY ===" >&2
}

@test "complete_integration - Jane Smith/Team Meetings/12.02.2025 Team Meeting Agenda.docx" {
  # Test case: Jane Smith Team Meetings with date
  # Input: Jane Smith/Team Meetings/12.02.2025 Team Meeting Agenda.docx
  # Expected: 1002_Jane Smith_Team Meeting Agenda_20250212_Team Meetings_yes.docx
  
  echo "=== COMPLETE INTEGRATION TEST ===" >&2
  echo "Test case: Jane Smith Team Meetings with date" >&2
  echo "Input path: Jane Smith/Team Meetings/12.02.2025 Team Meeting Agenda.docx" >&2
  echo "Expected filename: 1002_Jane Smith_Team Meeting Agenda_20250212_Team Meetings_yes.docx" >&2
  echo "=================================" >&2
  
  # Test user mapping
  echo "Testing user mapping..." >&2
  result="$(extract_user_from_path "Jane Smith/Team Meetings/12.02.2025 Team Meeting Agenda.docx")"
  IFS='|' read -r extracted_user_id raw_name extracted_name raw_remainder cleaned_remainder <<< "$result"
  
  expected_user_id="1002"
  expected_name="Jane Smith"
  
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
  category_candidate=$(echo "Jane Smith/Team Meetings/12.02.2025 Team Meeting Agenda.docx" | cut -d'/' -f2)
  if [ -n "$category_candidate" ]; then
    
    echo "Testing category mapping..." >&2
    result="$(extract_category_from_path "Jane Smith/Team Meetings/12.02.2025 Team Meeting Agenda.docx")"
    IFS='|' read -r extracted_category raw_category cleaned_category raw_remainder cleaned_remainder error_status <<< "$result"
    
    expected_category="Team Meetings"
    
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
  result="$(extract_date_from_path_for_string_test_fallback "Jane Smith/Team Meetings/12.02.2025 Team Meeting Agenda.docx" "" "today" "filename")"
  IFS='|' read -r extracted_date raw_date cleaned_date raw_remainder cleaned_remainder error_status <<< "$result"
  
  expected_date="20250212"
  
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
  
  # Test complete filename generation
  echo "Testing complete filename generation..." >&2
  
  # Use the test-specific function that handles fallback dates
  result="$(extract_complete_filename_with_fallback "Jane Smith/Team Meetings/12.02.2025 Team Meeting Agenda.docx" "" "today" "filename")"
  
  expected_filename="1002_Jane Smith_Team Meeting Agenda_20250212_Team Meetings_yes.docx"
  
  echo "----- COMPLETE FILENAME VALIDATION -----" >&2
  echo "Expected filename: '$expected_filename'" >&2
  echo "Generated filename: '$result'" >&2
  echo "-------------------------------------" >&2
  
  # Compare the actual generated filename with the expected filename
  if [ -n "$expected_filename" ]; then
    [ "$result" = "$expected_filename" ]
  fi
  
  echo "=== TEST COMPLETED SUCCESSFULLY ===" >&2
}

@test "complete_integration - Jane Smith/Support Plans/2023.07.25 - Jane Smith Support Plan.pdf" {
  # Test case: Jane Smith Support Plans with date
  # Input: Jane Smith/Support Plans/2023.07.25 - Jane Smith Support Plan.pdf
  # Expected: 1002_Jane Smith_Support Plan_20230725_Support Plans_yes.pdf
  
  echo "=== COMPLETE INTEGRATION TEST ===" >&2
  echo "Test case: Jane Smith Support Plans with date" >&2
  echo "Input path: Jane Smith/Support Plans/2023.07.25 - Jane Smith Support Plan.pdf" >&2
  echo "Expected filename: 1002_Jane Smith_Support Plan_20230725_Support Plans_yes.pdf" >&2
  echo "=================================" >&2
  
  # Test user mapping
  echo "Testing user mapping..." >&2
  result="$(extract_user_from_path "Jane Smith/Support Plans/2023.07.25 - Jane Smith Support Plan.pdf")"
  IFS='|' read -r extracted_user_id raw_name extracted_name raw_remainder cleaned_remainder <<< "$result"
  
  expected_user_id="1002"
  expected_name="Jane Smith"
  
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
  category_candidate=$(echo "Jane Smith/Support Plans/2023.07.25 - Jane Smith Support Plan.pdf" | cut -d'/' -f2)
  if [ -n "$category_candidate" ]; then
    
    echo "Testing category mapping..." >&2
    result="$(extract_category_from_path "Jane Smith/Support Plans/2023.07.25 - Jane Smith Support Plan.pdf")"
    IFS='|' read -r extracted_category raw_category cleaned_category raw_remainder cleaned_remainder error_status <<< "$result"
    
    expected_category="Support Plans"
    
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
  result="$(extract_date_from_path_for_string_test_fallback "Jane Smith/Support Plans/2023.07.25 - Jane Smith Support Plan.pdf" "" "today" "filename")"
  IFS='|' read -r extracted_date raw_date cleaned_date raw_remainder cleaned_remainder error_status <<< "$result"
  
  expected_date="20230725"
  
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
  
  # Test complete filename generation
  echo "Testing complete filename generation..." >&2
  
  # Use the test-specific function that handles fallback dates
  result="$(extract_complete_filename_with_fallback "Jane Smith/Support Plans/2023.07.25 - Jane Smith Support Plan.pdf" "" "today" "filename")"
  
  expected_filename="1002_Jane Smith_Support Plan_20230725_Support Plans_yes.pdf"
  
  echo "----- COMPLETE FILENAME VALIDATION -----" >&2
  echo "Expected filename: '$expected_filename'" >&2
  echo "Generated filename: '$result'" >&2
  echo "-------------------------------------" >&2
  
  # Compare the actual generated filename with the expected filename
  if [ -n "$expected_filename" ]; then
    [ "$result" = "$expected_filename" ]
  fi
  
  echo "=== TEST COMPLETED SUCCESSFULLY ===" >&2
}

@test "complete_integration - Jane Smith/Receipts/Jane Smith - Receipt 2024.pdf" {
  # Test case: Jane Smith Receipts with subdirectory
  # Input: Jane Smith/Receipts/Jane Smith - Receipt 2024.pdf
  # Expected: 1002_Jane Smith_Receipt 2024_20240120_Receipts_yes.pdf
  
  echo "=== COMPLETE INTEGRATION TEST ===" >&2
  echo "Test case: Jane Smith Receipts with subdirectory" >&2
  echo "Input path: Jane Smith/Receipts/Jane Smith - Receipt 2024.pdf" >&2
  echo "Expected filename: 1002_Jane Smith_Receipt 2024_20240120_Receipts_yes.pdf" >&2
  echo "=================================" >&2
  
  # Test user mapping
  echo "Testing user mapping..." >&2
  result="$(extract_user_from_path "Jane Smith/Receipts/Jane Smith - Receipt 2024.pdf")"
  IFS='|' read -r extracted_user_id raw_name extracted_name raw_remainder cleaned_remainder <<< "$result"
  
  expected_user_id="1002"
  expected_name="Jane Smith"
  
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
  category_candidate=$(echo "Jane Smith/Receipts/Jane Smith - Receipt 2024.pdf" | cut -d'/' -f2)
  if [ -n "$category_candidate" ]; then
    
    echo "Testing category mapping..." >&2
    result="$(extract_category_from_path "Jane Smith/Receipts/Jane Smith - Receipt 2024.pdf")"
    IFS='|' read -r extracted_category raw_category cleaned_category raw_remainder cleaned_remainder error_status <<< "$result"
    
    expected_category="Receipts"
    
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
  result="$(extract_date_from_path_for_string_test_fallback "Jane Smith/Receipts/Jane Smith - Receipt 2024.pdf" "2024-01-20" "today" "modified")"
  IFS='|' read -r extracted_date raw_date cleaned_date raw_remainder cleaned_remainder error_status <<< "$result"
  
  expected_date="20240120"
  
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
  
  # Test complete filename generation
  echo "Testing complete filename generation..." >&2
  
  # Use the test-specific function that handles fallback dates
  result="$(extract_complete_filename_with_fallback "Jane Smith/Receipts/Jane Smith - Receipt 2024.pdf" "2024-01-20" "today" "modified")"
  
  expected_filename="1002_Jane Smith_Receipt 2024_20240120_Receipts_yes.pdf"
  
  echo "----- COMPLETE FILENAME VALIDATION -----" >&2
  echo "Expected filename: '$expected_filename'" >&2
  echo "Generated filename: '$result'" >&2
  echo "-------------------------------------" >&2
  
  # Compare the actual generated filename with the expected filename
  if [ -n "$expected_filename" ]; then
    [ "$result" = "$expected_filename" ]
  fi
  
  echo "=== TEST COMPLETED SUCCESSFULLY ===" >&2
}

@test "complete_integration - Jane Smith/Medical/GP/25.02.05 - Jane Smith GP Summary.pdf" {
  # Test case: Jane Smith nested Medical folders
  # Input: Jane Smith/Medical/GP/25.02.05 - Jane Smith GP Summary.pdf
  # Expected: 1002_Jane Smith_GP GP Summary_20050225_Medical_yes.pdf
  
  echo "=== COMPLETE INTEGRATION TEST ===" >&2
  echo "Test case: Jane Smith nested Medical folders" >&2
  echo "Input path: Jane Smith/Medical/GP/25.02.05 - Jane Smith GP Summary.pdf" >&2
  echo "Expected filename: 1002_Jane Smith_GP GP Summary_20050225_Medical_yes.pdf" >&2
  echo "=================================" >&2
  
  # Test user mapping
  echo "Testing user mapping..." >&2
  result="$(extract_user_from_path "Jane Smith/Medical/GP/25.02.05 - Jane Smith GP Summary.pdf")"
  IFS='|' read -r extracted_user_id raw_name extracted_name raw_remainder cleaned_remainder <<< "$result"
  
  expected_user_id="1002"
  expected_name="Jane Smith"
  
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
  category_candidate=$(echo "Jane Smith/Medical/GP/25.02.05 - Jane Smith GP Summary.pdf" | cut -d'/' -f2)
  if [ -n "$category_candidate" ]; then
    
    echo "Testing category mapping..." >&2
    result="$(extract_category_from_path "Jane Smith/Medical/GP/25.02.05 - Jane Smith GP Summary.pdf")"
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
  result="$(extract_date_from_path_for_string_test_fallback "Jane Smith/Medical/GP/25.02.05 - Jane Smith GP Summary.pdf" "" "today" "filename")"
  IFS='|' read -r extracted_date raw_date cleaned_date raw_remainder cleaned_remainder error_status <<< "$result"
  
  expected_date="20050225"
  
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
  
  # Test complete filename generation
  echo "Testing complete filename generation..." >&2
  
  # Use the test-specific function that handles fallback dates
  result="$(extract_complete_filename_with_fallback "Jane Smith/Medical/GP/25.02.05 - Jane Smith GP Summary.pdf" "" "today" "filename")"
  
  expected_filename="1002_Jane Smith_GP GP Summary_20050225_Medical_yes.pdf"
  
  echo "----- COMPLETE FILENAME VALIDATION -----" >&2
  echo "Expected filename: '$expected_filename'" >&2
  echo "Generated filename: '$result'" >&2
  echo "-------------------------------------" >&2
  
  # Compare the actual generated filename with the expected filename
  if [ -n "$expected_filename" ]; then
    [ "$result" = "$expected_filename" ]
  fi
  
  echo "=== TEST COMPLETED SUCCESSFULLY ===" >&2
}

@test "complete_integration - Jane Smith/Mealtime Management/Jane Smith Mealtime Checklist.pdf" {
  # Test case: Jane Smith Mealtime Management
  # Input: Jane Smith/Mealtime Management/Jane Smith Mealtime Checklist.pdf
  # Expected: 1002_Jane Smith_Mealtime Checklist_20230101_Mealtime Management_yes.pdf
  
  echo "=== COMPLETE INTEGRATION TEST ===" >&2
  echo "Test case: Jane Smith Mealtime Management" >&2
  echo "Input path: Jane Smith/Mealtime Management/Jane Smith Mealtime Checklist.pdf" >&2
  echo "Expected filename: 1002_Jane Smith_Mealtime Checklist_20230101_Mealtime Management_yes.pdf" >&2
  echo "=================================" >&2
  
  # Test user mapping
  echo "Testing user mapping..." >&2
  result="$(extract_user_from_path "Jane Smith/Mealtime Management/Jane Smith Mealtime Checklist.pdf")"
  IFS='|' read -r extracted_user_id raw_name extracted_name raw_remainder cleaned_remainder <<< "$result"
  
  expected_user_id="1002"
  expected_name="Jane Smith"
  
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
  category_candidate=$(echo "Jane Smith/Mealtime Management/Jane Smith Mealtime Checklist.pdf" | cut -d'/' -f2)
  if [ -n "$category_candidate" ]; then
    
    echo "Testing category mapping..." >&2
    result="$(extract_category_from_path "Jane Smith/Mealtime Management/Jane Smith Mealtime Checklist.pdf")"
    IFS='|' read -r extracted_category raw_category cleaned_category raw_remainder cleaned_remainder error_status <<< "$result"
    
    expected_category="Mealtime Management"
    
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
  result="$(extract_date_from_path_for_string_test_fallback "Jane Smith/Mealtime Management/Jane Smith Mealtime Checklist.pdf" "2023-01-01" "today" "modified")"
  IFS='|' read -r extracted_date raw_date cleaned_date raw_remainder cleaned_remainder error_status <<< "$result"
  
  expected_date="20230101"
  
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
  
  # Test complete filename generation
  echo "Testing complete filename generation..." >&2
  
  # Use the test-specific function that handles fallback dates
  result="$(extract_complete_filename_with_fallback "Jane Smith/Mealtime Management/Jane Smith Mealtime Checklist.pdf" "2023-01-01" "today" "modified")"
  
  expected_filename="1002_Jane Smith_Mealtime Checklist_20230101_Mealtime Management_yes.pdf"
  
  echo "----- COMPLETE FILENAME VALIDATION -----" >&2
  echo "Expected filename: '$expected_filename'" >&2
  echo "Generated filename: '$result'" >&2
  echo "-------------------------------------" >&2
  
  # Compare the actual generated filename with the expected filename
  if [ -n "$expected_filename" ]; then
    [ "$result" = "$expected_filename" ]
  fi
  
  echo "=== TEST COMPLETED SUCCESSFULLY ===" >&2
}

@test "complete_integration - Jane Smith/Photos/Jane Smith at the Cinema.jpg" {
  # Test case: Jane Smith Photos with descriptive name
  # Input: Jane Smith/Photos/Jane Smith at the Cinema.jpg
  # Expected: 1002_Jane Smith_at the Cinema_20250105_Photos_yes.jpg
  
  echo "=== COMPLETE INTEGRATION TEST ===" >&2
  echo "Test case: Jane Smith Photos with descriptive name" >&2
  echo "Input path: Jane Smith/Photos/Jane Smith at the Cinema.jpg" >&2
  echo "Expected filename: 1002_Jane Smith_at the Cinema_20250105_Photos_yes.jpg" >&2
  echo "=================================" >&2
  
  # Test user mapping
  echo "Testing user mapping..." >&2
  result="$(extract_user_from_path "Jane Smith/Photos/Jane Smith at the Cinema.jpg")"
  IFS='|' read -r extracted_user_id raw_name extracted_name raw_remainder cleaned_remainder <<< "$result"
  
  expected_user_id="1002"
  expected_name="Jane Smith"
  
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
  category_candidate=$(echo "Jane Smith/Photos/Jane Smith at the Cinema.jpg" | cut -d'/' -f2)
  if [ -n "$category_candidate" ]; then
    
    echo "Testing category mapping..." >&2
    result="$(extract_category_from_path "Jane Smith/Photos/Jane Smith at the Cinema.jpg")"
    IFS='|' read -r extracted_category raw_category cleaned_category raw_remainder cleaned_remainder error_status <<< "$result"
    
    expected_category="Photos"
    
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
  result="$(extract_date_from_path_for_string_test_fallback "Jane Smith/Photos/Jane Smith at the Cinema.jpg" "2025-01-05" "today" "modified")"
  IFS='|' read -r extracted_date raw_date cleaned_date raw_remainder cleaned_remainder error_status <<< "$result"
  
  expected_date="20250105"
  
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
  
  # Test complete filename generation
  echo "Testing complete filename generation..." >&2
  
  # Use the test-specific function that handles fallback dates
  result="$(extract_complete_filename_with_fallback "Jane Smith/Photos/Jane Smith at the Cinema.jpg" "2025-01-05" "today" "modified")"
  
  expected_filename="1002_Jane Smith_at the Cinema_20250105_Photos_yes.jpg"
  
  echo "----- COMPLETE FILENAME VALIDATION -----" >&2
  echo "Expected filename: '$expected_filename'" >&2
  echo "Generated filename: '$result'" >&2
  echo "-------------------------------------" >&2
  
  # Compare the actual generated filename with the expected filename
  if [ -n "$expected_filename" ]; then
    [ "$result" = "$expected_filename" ]
  fi
  
  echo "=== TEST COMPLETED SUCCESSFULLY ===" >&2
}

@test "complete_integration - Jane Smith/Photos/Jane Smith at the Cinema 2024-07-01,2025-06-30.jpg" {
  # Test case: Jane Smith Photos with descriptive name and date range (should be excluded and used in rmeainder)
  # Input: Jane Smith/Photos/Jane Smith at the Cinema 2024-07-01,2025-06-30.jpg
  # Expected: 1002_Jane Smith_at the Cinema 2024.07.01 - 2025.06.30_20250105_Photos_yes.jpg
  
  echo "=== COMPLETE INTEGRATION TEST ===" >&2
  echo "Test case: Jane Smith Photos with descriptive name and date range (should be excluded and used in rmeainder)" >&2
  echo "Input path: Jane Smith/Photos/Jane Smith at the Cinema 2024-07-01,2025-06-30.jpg" >&2
  echo "Expected filename: 1002_Jane Smith_at the Cinema 2024.07.01 - 2025.06.30_20250105_Photos_yes.jpg" >&2
  echo "=================================" >&2
  
  # Test user mapping
  echo "Testing user mapping..." >&2
  result="$(extract_user_from_path "Jane Smith/Photos/Jane Smith at the Cinema 2024-07-01,2025-06-30.jpg")"
  IFS='|' read -r extracted_user_id raw_name extracted_name raw_remainder cleaned_remainder <<< "$result"
  
  expected_user_id="1002"
  expected_name="Jane Smith"
  
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
  category_candidate=$(echo "Jane Smith/Photos/Jane Smith at the Cinema 2024-07-01,2025-06-30.jpg" | cut -d'/' -f2)
  if [ -n "$category_candidate" ]; then
    
    echo "Testing category mapping..." >&2
    result="$(extract_category_from_path "Jane Smith/Photos/Jane Smith at the Cinema 2024-07-01,2025-06-30.jpg")"
    IFS='|' read -r extracted_category raw_category cleaned_category raw_remainder cleaned_remainder error_status <<< "$result"
    
    expected_category="Photos"
    
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
  result="$(extract_date_from_path_for_string_test_fallback "Jane Smith/Photos/Jane Smith at the Cinema 2024-07-01,2025-06-30.jpg" "2025-01-05" "today" "modified")"
  IFS='|' read -r extracted_date raw_date cleaned_date raw_remainder cleaned_remainder error_status <<< "$result"
  
  expected_date="20250105"
  
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
  
  # Test complete filename generation
  echo "Testing complete filename generation..." >&2
  
  # Use the test-specific function that handles fallback dates
  result="$(extract_complete_filename_with_fallback "Jane Smith/Photos/Jane Smith at the Cinema 2024-07-01,2025-06-30.jpg" "2025-01-05" "today" "modified")"
  
  expected_filename="1002_Jane Smith_at the Cinema 2024.07.01 - 2025.06.30_20250105_Photos_yes.jpg"
  
  echo "----- COMPLETE FILENAME VALIDATION -----" >&2
  echo "Expected filename: '$expected_filename'" >&2
  echo "Generated filename: '$result'" >&2
  echo "-------------------------------------" >&2
  
  # Compare the actual generated filename with the expected filename
  if [ -n "$expected_filename" ]; then
    [ "$result" = "$expected_filename" ]
  fi
  
  echo "=== TEST COMPLETED SUCCESSFULLY ===" >&2
}

@test "complete_integration - VC - Mary Jane Wilson Management/Support and NDIS Plan/Mary Jane Wilson - DSOA0476 ISP - 01.07.2024 to 30.06.2025.docx" {
  # Test case: Real-world date range exclusion test (Mary Jane Wilson DSOA ISP)
  # Input: VC - Mary Jane Wilson Management/Support and NDIS Plan/Mary Jane Wilson - DSOA0476 ISP - 01.07.2024 to 30.06.2025.docx
  # Expected: 1003_Mary Jane Wilson_DSOA0476 ISP 2024.07.01 - 2025.06.30_20250105_Support and NDIS Plan_no.docx
  
  echo "=== COMPLETE INTEGRATION TEST ===" >&2
  echo "Test case: Real-world date range exclusion test (Mary Jane Wilson DSOA ISP)" >&2
  echo "Input path: VC - Mary Jane Wilson Management/Support and NDIS Plan/Mary Jane Wilson - DSOA0476 ISP - 01.07.2024 to 30.06.2025.docx" >&2
  echo "Expected filename: 1003_Mary Jane Wilson_DSOA0476 ISP 2024.07.01 - 2025.06.30_20250105_Support and NDIS Plan_no.docx" >&2
  echo "=================================" >&2
  
  # Test user mapping
  echo "Testing user mapping..." >&2
  result="$(extract_user_from_path "VC - Mary Jane Wilson Management/Support and NDIS Plan/Mary Jane Wilson - DSOA0476 ISP - 01.07.2024 to 30.06.2025.docx")"
  IFS='|' read -r extracted_user_id raw_name extracted_name raw_remainder cleaned_remainder <<< "$result"
  
  expected_user_id="1003"
  expected_name="Mary Jane Wilson"
  
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
  category_candidate=$(echo "VC - Mary Jane Wilson Management/Support and NDIS Plan/Mary Jane Wilson - DSOA0476 ISP - 01.07.2024 to 30.06.2025.docx" | cut -d'/' -f2)
  if [ -n "$category_candidate" ]; then
    
    echo "Testing category mapping..." >&2
    result="$(extract_category_from_path "VC - Mary Jane Wilson Management/Support and NDIS Plan/Mary Jane Wilson - DSOA0476 ISP - 01.07.2024 to 30.06.2025.docx")"
    IFS='|' read -r extracted_category raw_category cleaned_category raw_remainder cleaned_remainder error_status <<< "$result"
    
    expected_category="Support and NDIS Plan"
    
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
  result="$(extract_date_from_path_for_string_test_fallback "VC - Mary Jane Wilson Management/Support and NDIS Plan/Mary Jane Wilson - DSOA0476 ISP - 01.07.2024 to 30.06.2025.docx" "2025-01-05" "today" "modified")"
  IFS='|' read -r extracted_date raw_date cleaned_date raw_remainder cleaned_remainder error_status <<< "$result"
  
  expected_date="20250105"
  
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
  
  # Test complete filename generation
  echo "Testing complete filename generation..." >&2
  
  # Use the test-specific function that handles fallback dates
  result="$(extract_complete_filename_with_fallback "VC - Mary Jane Wilson Management/Support and NDIS Plan/Mary Jane Wilson - DSOA0476 ISP - 01.07.2024 to 30.06.2025.docx" "2025-01-05" "today" "modified")"
  
  expected_filename="1003_Mary Jane Wilson_DSOA0476 ISP 2024.07.01 - 2025.06.30_20250105_Support and NDIS Plan_no.docx"
  
  echo "----- COMPLETE FILENAME VALIDATION -----" >&2
  echo "Expected filename: '$expected_filename'" >&2
  echo "Generated filename: '$result'" >&2
  echo "-------------------------------------" >&2
  
  # Compare the actual generated filename with the expected filename
  if [ -n "$expected_filename" ]; then
    [ "$result" = "$expected_filename" ]
  fi
  
  echo "=== TEST COMPLETED SUCCESSFULLY ===" >&2
}

@test "complete_integration - VC - Mary Jane Wilson/Medical Reports/F017 Medication Authority Form - Mary Jane Wilson.pdf" {
  # Test case: Real-world name extraction test (Mary Jane Wilson medication form)
  # Input: VC - Mary Jane Wilson/Medical Reports/F017 Medication Authority Form - Mary Jane Wilson.pdf
  # Expected: 1003_Mary Jane Wilson_F017 Medication Authority Form_20250105_Medical Reports_yes.pdf
  
  echo "=== COMPLETE INTEGRATION TEST ===" >&2
  echo "Test case: Real-world name extraction test (Mary Jane Wilson medication form)" >&2
  echo "Input path: VC - Mary Jane Wilson/Medical Reports/F017 Medication Authority Form - Mary Jane Wilson.pdf" >&2
  echo "Expected filename: 1003_Mary Jane Wilson_F017 Medication Authority Form_20250105_Medical Reports_yes.pdf" >&2
  echo "=================================" >&2
  
  # Test user mapping
  echo "Testing user mapping..." >&2
  result="$(extract_user_from_path "VC - Mary Jane Wilson/Medical Reports/F017 Medication Authority Form - Mary Jane Wilson.pdf")"
  IFS='|' read -r extracted_user_id raw_name extracted_name raw_remainder cleaned_remainder <<< "$result"
  
  expected_user_id="1003"
  expected_name="Mary Jane Wilson"
  
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
  category_candidate=$(echo "VC - Mary Jane Wilson/Medical Reports/F017 Medication Authority Form - Mary Jane Wilson.pdf" | cut -d'/' -f2)
  if [ -n "$category_candidate" ]; then
    
    echo "Testing category mapping..." >&2
    result="$(extract_category_from_path "VC - Mary Jane Wilson/Medical Reports/F017 Medication Authority Form - Mary Jane Wilson.pdf")"
    IFS='|' read -r extracted_category raw_category cleaned_category raw_remainder cleaned_remainder error_status <<< "$result"
    
    expected_category="Medical Reports"
    
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
  result="$(extract_date_from_path_for_string_test_fallback "VC - Mary Jane Wilson/Medical Reports/F017 Medication Authority Form - Mary Jane Wilson.pdf" "2025-01-05" "today" "modified")"
  IFS='|' read -r extracted_date raw_date cleaned_date raw_remainder cleaned_remainder error_status <<< "$result"
  
  expected_date="20250105"
  
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
  
  # Test complete filename generation
  echo "Testing complete filename generation..." >&2
  
  # Use the test-specific function that handles fallback dates
  result="$(extract_complete_filename_with_fallback "VC - Mary Jane Wilson/Medical Reports/F017 Medication Authority Form - Mary Jane Wilson.pdf" "2025-01-05" "today" "modified")"
  
  expected_filename="1003_Mary Jane Wilson_F017 Medication Authority Form_20250105_Medical Reports_yes.pdf"
  
  echo "----- COMPLETE FILENAME VALIDATION -----" >&2
  echo "Expected filename: '$expected_filename'" >&2
  echo "Generated filename: '$result'" >&2
  echo "-------------------------------------" >&2
  
  # Compare the actual generated filename with the expected filename
  if [ -n "$expected_filename" ]; then
    [ "$result" = "$expected_filename" ]
  fi
  
  echo "=== TEST COMPLETED SUCCESSFULLY ===" >&2
}

@test "complete_integration - VC - Mary Jane Wilson/Medical Reports/24.01.2025 - Mary Jane Wilson CHAPS.pdf" {
  # Test case: Real-world date extraction test (Mary Jane Wilson CHAPS)
  # Input: VC - Mary Jane Wilson/Medical Reports/24.01.2025 - Mary Jane Wilson CHAPS.pdf
  # Expected: 1003_Mary Jane Wilson_CHAPS_20250124_Medical Reports_yes.pdf
  
  echo "=== COMPLETE INTEGRATION TEST ===" >&2
  echo "Test case: Real-world date extraction test (Mary Jane Wilson CHAPS)" >&2
  echo "Input path: VC - Mary Jane Wilson/Medical Reports/24.01.2025 - Mary Jane Wilson CHAPS.pdf" >&2
  echo "Expected filename: 1003_Mary Jane Wilson_CHAPS_20250124_Medical Reports_yes.pdf" >&2
  echo "=================================" >&2
  
  # Test user mapping
  echo "Testing user mapping..." >&2
  result="$(extract_user_from_path "VC - Mary Jane Wilson/Medical Reports/24.01.2025 - Mary Jane Wilson CHAPS.pdf")"
  IFS='|' read -r extracted_user_id raw_name extracted_name raw_remainder cleaned_remainder <<< "$result"
  
  expected_user_id="1003"
  expected_name="Mary Jane Wilson"
  
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
  category_candidate=$(echo "VC - Mary Jane Wilson/Medical Reports/24.01.2025 - Mary Jane Wilson CHAPS.pdf" | cut -d'/' -f2)
  if [ -n "$category_candidate" ]; then
    
    echo "Testing category mapping..." >&2
    result="$(extract_category_from_path "VC - Mary Jane Wilson/Medical Reports/24.01.2025 - Mary Jane Wilson CHAPS.pdf")"
    IFS='|' read -r extracted_category raw_category cleaned_category raw_remainder cleaned_remainder error_status <<< "$result"
    
    expected_category="Medical Reports"
    
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
  result="$(extract_date_from_path_for_string_test_fallback "VC - Mary Jane Wilson/Medical Reports/24.01.2025 - Mary Jane Wilson CHAPS.pdf" "" "today" "filename")"
  IFS='|' read -r extracted_date raw_date cleaned_date raw_remainder cleaned_remainder error_status <<< "$result"
  
  expected_date="20250124"
  
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
  
  # Test complete filename generation
  echo "Testing complete filename generation..." >&2
  
  # Use the test-specific function that handles fallback dates
  result="$(extract_complete_filename_with_fallback "VC - Mary Jane Wilson/Medical Reports/24.01.2025 - Mary Jane Wilson CHAPS.pdf" "" "today" "filename")"
  
  expected_filename="1003_Mary Jane Wilson_CHAPS_20250124_Medical Reports_yes.pdf"
  
  echo "----- COMPLETE FILENAME VALIDATION -----" >&2
  echo "Expected filename: '$expected_filename'" >&2
  echo "Generated filename: '$result'" >&2
  echo "-------------------------------------" >&2
  
  # Compare the actual generated filename with the expected filename
  if [ -n "$expected_filename" ]; then
    [ "$result" = "$expected_filename" ]
  fi
  
  echo "=== TEST COMPLETED SUCCESSFULLY ===" >&2
}

@test "complete_integration - VC - Mary Jane Wilson/WHS/06.02.2025 - Mary Jane Wilson - Incident.pdf" {
  # Test case: Real-world category extraction test (Mary Jane Wilson incident)
  # Input: VC - Mary Jane Wilson/WHS/06.02.2025 - Mary Jane Wilson - Incident.pdf
  # Expected: 1003_Mary Jane Wilson_Incident_20250206_WHS_yes.pdf
  
  echo "=== COMPLETE INTEGRATION TEST ===" >&2
  echo "Test case: Real-world category extraction test (Mary Jane Wilson incident)" >&2
  echo "Input path: VC - Mary Jane Wilson/WHS/06.02.2025 - Mary Jane Wilson - Incident.pdf" >&2
  echo "Expected filename: 1003_Mary Jane Wilson_Incident_20250206_WHS_yes.pdf" >&2
  echo "=================================" >&2
  
  # Test user mapping
  echo "Testing user mapping..." >&2
  result="$(extract_user_from_path "VC - Mary Jane Wilson/WHS/06.02.2025 - Mary Jane Wilson - Incident.pdf")"
  IFS='|' read -r extracted_user_id raw_name extracted_name raw_remainder cleaned_remainder <<< "$result"
  
  expected_user_id="1003"
  expected_name="Mary Jane Wilson"
  
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
  category_candidate=$(echo "VC - Mary Jane Wilson/WHS/06.02.2025 - Mary Jane Wilson - Incident.pdf" | cut -d'/' -f2)
  if [ -n "$category_candidate" ]; then
    
    echo "Testing category mapping..." >&2
    result="$(extract_category_from_path "VC - Mary Jane Wilson/WHS/06.02.2025 - Mary Jane Wilson - Incident.pdf")"
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
  result="$(extract_date_from_path_for_string_test_fallback "VC - Mary Jane Wilson/WHS/06.02.2025 - Mary Jane Wilson - Incident.pdf" "" "today" "filename")"
  IFS='|' read -r extracted_date raw_date cleaned_date raw_remainder cleaned_remainder error_status <<< "$result"
  
  expected_date="20250206"
  
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
  
  # Test complete filename generation
  echo "Testing complete filename generation..." >&2
  
  # Use the test-specific function that handles fallback dates
  result="$(extract_complete_filename_with_fallback "VC - Mary Jane Wilson/WHS/06.02.2025 - Mary Jane Wilson - Incident.pdf" "" "today" "filename")"
  
  expected_filename="1003_Mary Jane Wilson_Incident_20250206_WHS_yes.pdf"
  
  echo "----- COMPLETE FILENAME VALIDATION -----" >&2
  echo "Expected filename: '$expected_filename'" >&2
  echo "Generated filename: '$result'" >&2
  echo "-------------------------------------" >&2
  
  # Compare the actual generated filename with the expected filename
  if [ -n "$expected_filename" ]; then
    [ "$result" = "$expected_filename" ]
  fi
  
  echo "=== TEST COMPLETED SUCCESSFULLY ===" >&2
}

@test "complete_integration - VC - Mary Jane Wilson Management/Housing Information/Department of Housing Tenancy - Mary Jane Wilson.pdf" {
  # Test case: Real-world prefix/suffix handling test (Mary Jane Wilson housing)
  # Input: VC - Mary Jane Wilson Management/Housing Information/Department of Housing Tenancy - Mary Jane Wilson.pdf
  # Expected: 1003_Mary Jane Wilson_Department of Housing Tenancy_20250105_Housing Information_no.pdf
  
  echo "=== COMPLETE INTEGRATION TEST ===" >&2
  echo "Test case: Real-world prefix/suffix handling test (Mary Jane Wilson housing)" >&2
  echo "Input path: VC - Mary Jane Wilson Management/Housing Information/Department of Housing Tenancy - Mary Jane Wilson.pdf" >&2
  echo "Expected filename: 1003_Mary Jane Wilson_Department of Housing Tenancy_20250105_Housing Information_no.pdf" >&2
  echo "=================================" >&2
  
  # Test user mapping
  echo "Testing user mapping..." >&2
  result="$(extract_user_from_path "VC - Mary Jane Wilson Management/Housing Information/Department of Housing Tenancy - Mary Jane Wilson.pdf")"
  IFS='|' read -r extracted_user_id raw_name extracted_name raw_remainder cleaned_remainder <<< "$result"
  
  expected_user_id="1003"
  expected_name="Mary Jane Wilson"
  
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
  category_candidate=$(echo "VC - Mary Jane Wilson Management/Housing Information/Department of Housing Tenancy - Mary Jane Wilson.pdf" | cut -d'/' -f2)
  if [ -n "$category_candidate" ]; then
    
    echo "Testing category mapping..." >&2
    result="$(extract_category_from_path "VC - Mary Jane Wilson Management/Housing Information/Department of Housing Tenancy - Mary Jane Wilson.pdf")"
    IFS='|' read -r extracted_category raw_category cleaned_category raw_remainder cleaned_remainder error_status <<< "$result"
    
    expected_category="Housing Information"
    
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
  result="$(extract_date_from_path_for_string_test_fallback "VC - Mary Jane Wilson Management/Housing Information/Department of Housing Tenancy - Mary Jane Wilson.pdf" "2025-01-05" "today" "modified")"
  IFS='|' read -r extracted_date raw_date cleaned_date raw_remainder cleaned_remainder error_status <<< "$result"
  
  expected_date="20250105"
  
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
  
  # Test complete filename generation
  echo "Testing complete filename generation..." >&2
  
  # Use the test-specific function that handles fallback dates
  result="$(extract_complete_filename_with_fallback "VC - Mary Jane Wilson Management/Housing Information/Department of Housing Tenancy - Mary Jane Wilson.pdf" "2025-01-05" "today" "modified")"
  
  expected_filename="1003_Mary Jane Wilson_Department of Housing Tenancy_20250105_Housing Information_no.pdf"
  
  echo "----- COMPLETE FILENAME VALIDATION -----" >&2
  echo "Expected filename: '$expected_filename'" >&2
  echo "Generated filename: '$result'" >&2
  echo "-------------------------------------" >&2
  
  # Compare the actual generated filename with the expected filename
  if [ -n "$expected_filename" ]; then
    [ "$result" = "$expected_filename" ]
  fi
  
  echo "=== TEST COMPLETED SUCCESSFULLY ===" >&2
}

@test "complete_integration - VC - Mary Jane Wilson/Mealtime Management/Mary Jane Wilson Mealtime Management Plan 2025.pdf" {
  # Test case: Real-world name extraction test (Mary Jane Wilson mealtime plan)
  # Input: VC - Mary Jane Wilson/Mealtime Management/Mary Jane Wilson Mealtime Management Plan 2025.pdf
  # Expected: 1003_Mary Jane Wilson_Mealtime Management Plan 2025_20250105_Mealtime Management_yes.pdf
  
  echo "=== COMPLETE INTEGRATION TEST ===" >&2
  echo "Test case: Real-world name extraction test (Mary Jane Wilson mealtime plan)" >&2
  echo "Input path: VC - Mary Jane Wilson/Mealtime Management/Mary Jane Wilson Mealtime Management Plan 2025.pdf" >&2
  echo "Expected filename: 1003_Mary Jane Wilson_Mealtime Management Plan 2025_20250105_Mealtime Management_yes.pdf" >&2
  echo "=================================" >&2
  
  # Test user mapping
  echo "Testing user mapping..." >&2
  result="$(extract_user_from_path "VC - Mary Jane Wilson/Mealtime Management/Mary Jane Wilson Mealtime Management Plan 2025.pdf")"
  IFS='|' read -r extracted_user_id raw_name extracted_name raw_remainder cleaned_remainder <<< "$result"
  
  expected_user_id="1003"
  expected_name="Mary Jane Wilson"
  
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
  category_candidate=$(echo "VC - Mary Jane Wilson/Mealtime Management/Mary Jane Wilson Mealtime Management Plan 2025.pdf" | cut -d'/' -f2)
  if [ -n "$category_candidate" ]; then
    
    echo "Testing category mapping..." >&2
    result="$(extract_category_from_path "VC - Mary Jane Wilson/Mealtime Management/Mary Jane Wilson Mealtime Management Plan 2025.pdf")"
    IFS='|' read -r extracted_category raw_category cleaned_category raw_remainder cleaned_remainder error_status <<< "$result"
    
    expected_category="Mealtime Management"
    
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
  result="$(extract_date_from_path_for_string_test_fallback "VC - Mary Jane Wilson/Mealtime Management/Mary Jane Wilson Mealtime Management Plan 2025.pdf" "2025-01-05" "today" "modified")"
  IFS='|' read -r extracted_date raw_date cleaned_date raw_remainder cleaned_remainder error_status <<< "$result"
  
  expected_date="20250105"
  
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
  
  # Test complete filename generation
  echo "Testing complete filename generation..." >&2
  
  # Use the test-specific function that handles fallback dates
  result="$(extract_complete_filename_with_fallback "VC - Mary Jane Wilson/Mealtime Management/Mary Jane Wilson Mealtime Management Plan 2025.pdf" "2025-01-05" "today" "modified")"
  
  expected_filename="1003_Mary Jane Wilson_Mealtime Management Plan 2025_20250105_Mealtime Management_yes.pdf"
  
  echo "----- COMPLETE FILENAME VALIDATION -----" >&2
  echo "Expected filename: '$expected_filename'" >&2
  echo "Generated filename: '$result'" >&2
  echo "-------------------------------------" >&2
  
  # Compare the actual generated filename with the expected filename
  if [ -n "$expected_filename" ]; then
    [ "$result" = "$expected_filename" ]
  fi
  
  echo "=== TEST COMPLETED SUCCESSFULLY ===" >&2
}

@test "complete_integration - VC - Mary Jane Wilson/Medical Action Plan/Letter for Marjory Fluoskos - Providing Means of Life for Mary Jane Wilson.docx" {
  # Test case: Real-world complex name extraction test (Mary Jane Wilson medical letter)
  # Input: VC - Mary Jane Wilson/Medical Action Plan/Letter for Marjory Fluoskos - Providing Means of Life for Mary Jane Wilson.docx
  # Expected: 1003_Mary Jane Wilson_Letter for Marjory Fluoskos Providing Means of Life for_20250105_Medical Action Plan_yes.docx
  
  echo "=== COMPLETE INTEGRATION TEST ===" >&2
  echo "Test case: Real-world complex name extraction test (Mary Jane Wilson medical letter)" >&2
  echo "Input path: VC - Mary Jane Wilson/Medical Action Plan/Letter for Marjory Fluoskos - Providing Means of Life for Mary Jane Wilson.docx" >&2
  echo "Expected filename: 1003_Mary Jane Wilson_Letter for Marjory Fluoskos Providing Means of Life for_20250105_Medical Action Plan_yes.docx" >&2
  echo "=================================" >&2
  
  # Test user mapping
  echo "Testing user mapping..." >&2
  result="$(extract_user_from_path "VC - Mary Jane Wilson/Medical Action Plan/Letter for Marjory Fluoskos - Providing Means of Life for Mary Jane Wilson.docx")"
  IFS='|' read -r extracted_user_id raw_name extracted_name raw_remainder cleaned_remainder <<< "$result"
  
  expected_user_id="1003"
  expected_name="Mary Jane Wilson"
  
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
  category_candidate=$(echo "VC - Mary Jane Wilson/Medical Action Plan/Letter for Marjory Fluoskos - Providing Means of Life for Mary Jane Wilson.docx" | cut -d'/' -f2)
  if [ -n "$category_candidate" ]; then
    
    echo "Testing category mapping..." >&2
    result="$(extract_category_from_path "VC - Mary Jane Wilson/Medical Action Plan/Letter for Marjory Fluoskos - Providing Means of Life for Mary Jane Wilson.docx")"
    IFS='|' read -r extracted_category raw_category cleaned_category raw_remainder cleaned_remainder error_status <<< "$result"
    
    expected_category="Medical Action Plan"
    
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
  result="$(extract_date_from_path_for_string_test_fallback "VC - Mary Jane Wilson/Medical Action Plan/Letter for Marjory Fluoskos - Providing Means of Life for Mary Jane Wilson.docx" "2025-01-05" "today" "modified")"
  IFS='|' read -r extracted_date raw_date cleaned_date raw_remainder cleaned_remainder error_status <<< "$result"
  
  expected_date="20250105"
  
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
  
  # Test complete filename generation
  echo "Testing complete filename generation..." >&2
  
  # Use the test-specific function that handles fallback dates
  result="$(extract_complete_filename_with_fallback "VC - Mary Jane Wilson/Medical Action Plan/Letter for Marjory Fluoskos - Providing Means of Life for Mary Jane Wilson.docx" "2025-01-05" "today" "modified")"
  
  expected_filename="1003_Mary Jane Wilson_Letter for Marjory Fluoskos Providing Means of Life for_20250105_Medical Action Plan_yes.docx"
  
  echo "----- COMPLETE FILENAME VALIDATION -----" >&2
  echo "Expected filename: '$expected_filename'" >&2
  echo "Generated filename: '$result'" >&2
  echo "-------------------------------------" >&2
  
  # Compare the actual generated filename with the expected filename
  if [ -n "$expected_filename" ]; then
    [ "$result" = "$expected_filename" ]
  fi
  
  echo "=== TEST COMPLETED SUCCESSFULLY ===" >&2
}

@test "complete_integration - VC - Mary Jane Wilson/Monthly Feedback/Monthly Feedback Form - Mary Jane Wilson February 2025.docx" {
  # Test case: Real-world name extraction test (Mary Jane Wilson monthly feedback)
  # Input: VC - Mary Jane Wilson/Monthly Feedback/Monthly Feedback Form - Mary Jane Wilson February 2025.docx
  # Expected: 1003_Mary Jane Wilson_Monthly Feedback Form February 2025_20250105_Monthly Feedback_yes.docx
  
  echo "=== COMPLETE INTEGRATION TEST ===" >&2
  echo "Test case: Real-world name extraction test (Mary Jane Wilson monthly feedback)" >&2
  echo "Input path: VC - Mary Jane Wilson/Monthly Feedback/Monthly Feedback Form - Mary Jane Wilson February 2025.docx" >&2
  echo "Expected filename: 1003_Mary Jane Wilson_Monthly Feedback Form February 2025_20250105_Monthly Feedback_yes.docx" >&2
  echo "=================================" >&2
  
  # Test user mapping
  echo "Testing user mapping..." >&2
  result="$(extract_user_from_path "VC - Mary Jane Wilson/Monthly Feedback/Monthly Feedback Form - Mary Jane Wilson February 2025.docx")"
  IFS='|' read -r extracted_user_id raw_name extracted_name raw_remainder cleaned_remainder <<< "$result"
  
  expected_user_id="1003"
  expected_name="Mary Jane Wilson"
  
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
  category_candidate=$(echo "VC - Mary Jane Wilson/Monthly Feedback/Monthly Feedback Form - Mary Jane Wilson February 2025.docx" | cut -d'/' -f2)
  if [ -n "$category_candidate" ]; then
    
    echo "Testing category mapping..." >&2
    result="$(extract_category_from_path "VC - Mary Jane Wilson/Monthly Feedback/Monthly Feedback Form - Mary Jane Wilson February 2025.docx")"
    IFS='|' read -r extracted_category raw_category cleaned_category raw_remainder cleaned_remainder error_status <<< "$result"
    
    expected_category="Monthly Feedback"
    
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
  result="$(extract_date_from_path_for_string_test_fallback "VC - Mary Jane Wilson/Monthly Feedback/Monthly Feedback Form - Mary Jane Wilson February 2025.docx" "2025-01-05" "today" "modified")"
  IFS='|' read -r extracted_date raw_date cleaned_date raw_remainder cleaned_remainder error_status <<< "$result"
  
  expected_date="20250105"
  
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
  
  # Test complete filename generation
  echo "Testing complete filename generation..." >&2
  
  # Use the test-specific function that handles fallback dates
  result="$(extract_complete_filename_with_fallback "VC - Mary Jane Wilson/Monthly Feedback/Monthly Feedback Form - Mary Jane Wilson February 2025.docx" "2025-01-05" "today" "modified")"
  
  expected_filename="1003_Mary Jane Wilson_Monthly Feedback Form February 2025_20250105_Monthly Feedback_yes.docx"
  
  echo "----- COMPLETE FILENAME VALIDATION -----" >&2
  echo "Expected filename: '$expected_filename'" >&2
  echo "Generated filename: '$result'" >&2
  echo "-------------------------------------" >&2
  
  # Compare the actual generated filename with the expected filename
  if [ -n "$expected_filename" ]; then
    [ "$result" = "$expected_filename" ]
  fi
  
  echo "=== TEST COMPLETED SUCCESSFULLY ===" >&2
}

@test "complete_integration - VC - Mary Jane Wilson Management/Service Agreements/2021.03.20 - Mary Jane Wilson - Letter from participant changing provider to Helping Care.pdf" {
  # Test case: Real-world date extraction test (Mary Jane Wilson service agreement)
  # Input: VC - Mary Jane Wilson Management/Service Agreements/2021.03.20 - Mary Jane Wilson - Letter from participant changing provider to Helping Care.pdf
  # Expected: 1003_Mary Jane Wilson_Letter from participant changing provider to Helping Care_20210320_Service Agreements_no.pdf
  
  echo "=== COMPLETE INTEGRATION TEST ===" >&2
  echo "Test case: Real-world date extraction test (Mary Jane Wilson service agreement)" >&2
  echo "Input path: VC - Mary Jane Wilson Management/Service Agreements/2021.03.20 - Mary Jane Wilson - Letter from participant changing provider to Helping Care.pdf" >&2
  echo "Expected filename: 1003_Mary Jane Wilson_Letter from participant changing provider to Helping Care_20210320_Service Agreements_no.pdf" >&2
  echo "=================================" >&2
  
  # Test user mapping
  echo "Testing user mapping..." >&2
  result="$(extract_user_from_path "VC - Mary Jane Wilson Management/Service Agreements/2021.03.20 - Mary Jane Wilson - Letter from participant changing provider to Helping Care.pdf")"
  IFS='|' read -r extracted_user_id raw_name extracted_name raw_remainder cleaned_remainder <<< "$result"
  
  expected_user_id="1003"
  expected_name="Mary Jane Wilson"
  
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
  category_candidate=$(echo "VC - Mary Jane Wilson Management/Service Agreements/2021.03.20 - Mary Jane Wilson - Letter from participant changing provider to Helping Care.pdf" | cut -d'/' -f2)
  if [ -n "$category_candidate" ]; then
    
    echo "Testing category mapping..." >&2
    result="$(extract_category_from_path "VC - Mary Jane Wilson Management/Service Agreements/2021.03.20 - Mary Jane Wilson - Letter from participant changing provider to Helping Care.pdf")"
    IFS='|' read -r extracted_category raw_category cleaned_category raw_remainder cleaned_remainder error_status <<< "$result"
    
    expected_category="Service Agreements"
    
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
  result="$(extract_date_from_path_for_string_test_fallback "VC - Mary Jane Wilson Management/Service Agreements/2021.03.20 - Mary Jane Wilson - Letter from participant changing provider to Helping Care.pdf" "" "today" "filename")"
  IFS='|' read -r extracted_date raw_date cleaned_date raw_remainder cleaned_remainder error_status <<< "$result"
  
  expected_date="20210320"
  
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
  
  # Test complete filename generation
  echo "Testing complete filename generation..." >&2
  
  # Use the test-specific function that handles fallback dates
  result="$(extract_complete_filename_with_fallback "VC - Mary Jane Wilson Management/Service Agreements/2021.03.20 - Mary Jane Wilson - Letter from participant changing provider to Helping Care.pdf" "" "today" "filename")"
  
  expected_filename="1003_Mary Jane Wilson_Letter from participant changing provider to Helping Care_20210320_Service Agreements_no.pdf"
  
  echo "----- COMPLETE FILENAME VALIDATION -----" >&2
  echo "Expected filename: '$expected_filename'" >&2
  echo "Generated filename: '$result'" >&2
  echo "-------------------------------------" >&2
  
  # Compare the actual generated filename with the expected filename
  if [ -n "$expected_filename" ]; then
    [ "$result" = "$expected_filename" ]
  fi
  
  echo "=== TEST COMPLETED SUCCESSFULLY ===" >&2
}

@test "complete_integration - Sarah Johnson/Support Plans/Sarah Johnson Support Plan 2024-07-01,2025-06-30.pdf" {
  # Test case: Sarah Johnson Support Plan with comma-separated date range (should be excluded and normalized)
  # Input: Sarah Johnson/Support Plans/Sarah Johnson Support Plan 2024-07-01,2025-06-30.pdf
  # Expected: 1004_Sarah Johnson_Support Plan 2024.07.01 - 2025.06.30_20250105_Support Plans_yes.pdf
  
  echo "=== COMPLETE INTEGRATION TEST ===" >&2
  echo "Test case: Sarah Johnson Support Plan with comma-separated date range (should be excluded and normalized)" >&2
  echo "Input path: Sarah Johnson/Support Plans/Sarah Johnson Support Plan 2024-07-01,2025-06-30.pdf" >&2
  echo "Expected filename: 1004_Sarah Johnson_Support Plan 2024.07.01 - 2025.06.30_20250105_Support Plans_yes.pdf" >&2
  echo "=================================" >&2
  
  # Test user mapping
  echo "Testing user mapping..." >&2
  result="$(extract_user_from_path "Sarah Johnson/Support Plans/Sarah Johnson Support Plan 2024-07-01,2025-06-30.pdf")"
  IFS='|' read -r extracted_user_id raw_name extracted_name raw_remainder cleaned_remainder <<< "$result"
  
  expected_user_id="1004"
  expected_name="Sarah Johnson"
  
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
  category_candidate=$(echo "Sarah Johnson/Support Plans/Sarah Johnson Support Plan 2024-07-01,2025-06-30.pdf" | cut -d'/' -f2)
  if [ -n "$category_candidate" ]; then
    
    echo "Testing category mapping..." >&2
    result="$(extract_category_from_path "Sarah Johnson/Support Plans/Sarah Johnson Support Plan 2024-07-01,2025-06-30.pdf")"
    IFS='|' read -r extracted_category raw_category cleaned_category raw_remainder cleaned_remainder error_status <<< "$result"
    
    expected_category="Support Plans"
    
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
  result="$(extract_date_from_path_for_string_test_fallback "Sarah Johnson/Support Plans/Sarah Johnson Support Plan 2024-07-01,2025-06-30.pdf" "2025-01-05" "today" "modified")"
  IFS='|' read -r extracted_date raw_date cleaned_date raw_remainder cleaned_remainder error_status <<< "$result"
  
  expected_date="20250105"
  
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
  
  # Test complete filename generation
  echo "Testing complete filename generation..." >&2
  
  # Use the test-specific function that handles fallback dates
  result="$(extract_complete_filename_with_fallback "Sarah Johnson/Support Plans/Sarah Johnson Support Plan 2024-07-01,2025-06-30.pdf" "2025-01-05" "today" "modified")"
  
  expected_filename="1004_Sarah Johnson_Support Plan 2024.07.01 - 2025.06.30_20250105_Support Plans_yes.pdf"
  
  echo "----- COMPLETE FILENAME VALIDATION -----" >&2
  echo "Expected filename: '$expected_filename'" >&2
  echo "Generated filename: '$result'" >&2
  echo "-------------------------------------" >&2
  
  # Compare the actual generated filename with the expected filename
  if [ -n "$expected_filename" ]; then
    [ "$result" = "$expected_filename" ]
  fi
  
  echo "=== TEST COMPLETED SUCCESSFULLY ===" >&2
}

@test "complete_integration - Sarah Johnson/Support Plans/Sarah Johnson Support Plan exp 2025.08.30.pdf" {
  # Test case: Sarah Johnson Support Plan with exp date (should be excluded and normalized)
  # Input: Sarah Johnson/Support Plans/Sarah Johnson Support Plan exp 2025.08.30.pdf
  # Expected: 1004_Sarah Johnson_Support Plan exp 2025.08.30_20250105_Support Plans_yes.pdf
  
  echo "=== COMPLETE INTEGRATION TEST ===" >&2
  echo "Test case: Sarah Johnson Support Plan with exp date (should be excluded and normalized)" >&2
  echo "Input path: Sarah Johnson/Support Plans/Sarah Johnson Support Plan exp 2025.08.30.pdf" >&2
  echo "Expected filename: 1004_Sarah Johnson_Support Plan exp 2025.08.30_20250105_Support Plans_yes.pdf" >&2
  echo "=================================" >&2
  
  # Test user mapping
  echo "Testing user mapping..." >&2
  result="$(extract_user_from_path "Sarah Johnson/Support Plans/Sarah Johnson Support Plan exp 2025.08.30.pdf")"
  IFS='|' read -r extracted_user_id raw_name extracted_name raw_remainder cleaned_remainder <<< "$result"
  
  expected_user_id="1004"
  expected_name="Sarah Johnson"
  
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
  category_candidate=$(echo "Sarah Johnson/Support Plans/Sarah Johnson Support Plan exp 2025.08.30.pdf" | cut -d'/' -f2)
  if [ -n "$category_candidate" ]; then
    
    echo "Testing category mapping..." >&2
    result="$(extract_category_from_path "Sarah Johnson/Support Plans/Sarah Johnson Support Plan exp 2025.08.30.pdf")"
    IFS='|' read -r extracted_category raw_category cleaned_category raw_remainder cleaned_remainder error_status <<< "$result"
    
    expected_category="Support Plans"
    
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
  result="$(extract_date_from_path_for_string_test_fallback "Sarah Johnson/Support Plans/Sarah Johnson Support Plan exp 2025.08.30.pdf" "2025-01-05" "today" "modified")"
  IFS='|' read -r extracted_date raw_date cleaned_date raw_remainder cleaned_remainder error_status <<< "$result"
  
  expected_date="20250105"
  
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
  
  # Test complete filename generation
  echo "Testing complete filename generation..." >&2
  
  # Use the test-specific function that handles fallback dates
  result="$(extract_complete_filename_with_fallback "Sarah Johnson/Support Plans/Sarah Johnson Support Plan exp 2025.08.30.pdf" "2025-01-05" "today" "modified")"
  
  expected_filename="1004_Sarah Johnson_Support Plan exp 2025.08.30_20250105_Support Plans_yes.pdf"
  
  echo "----- COMPLETE FILENAME VALIDATION -----" >&2
  echo "Expected filename: '$expected_filename'" >&2
  echo "Generated filename: '$result'" >&2
  echo "-------------------------------------" >&2
  
  # Compare the actual generated filename with the expected filename
  if [ -n "$expected_filename" ]; then
    [ "$result" = "$expected_filename" ]
  fi
  
  echo "=== TEST COMPLETED SUCCESSFULLY ===" >&2
}

@test "complete_integration - VC - John Doe Management/Client Compliance/F007A Participant Information Form - John Doe.pdf" {
  # Test case: Real-world VC Management prefix/suffix test (John Doe client compliance)
  # Input: VC - John Doe Management/Client Compliance/F007A Participant Information Form - John Doe.pdf
  # Expected: 1001_John Doe_F007A Participant Information Form_20240726_Client Compliance_no.pdf
  
  echo "=== COMPLETE INTEGRATION TEST ===" >&2
  echo "Test case: Real-world VC Management prefix/suffix test (John Doe client compliance)" >&2
  echo "Input path: VC - John Doe Management/Client Compliance/F007A Participant Information Form - John Doe.pdf" >&2
  echo "Expected filename: 1001_John Doe_F007A Participant Information Form_20240726_Client Compliance_no.pdf" >&2
  echo "=================================" >&2
  
  # Test user mapping
  echo "Testing user mapping..." >&2
  result="$(extract_user_from_path "VC - John Doe Management/Client Compliance/F007A Participant Information Form - John Doe.pdf")"
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
  category_candidate=$(echo "VC - John Doe Management/Client Compliance/F007A Participant Information Form - John Doe.pdf" | cut -d'/' -f2)
  if [ -n "$category_candidate" ]; then
    
    echo "Testing category mapping..." >&2
    result="$(extract_category_from_path "VC - John Doe Management/Client Compliance/F007A Participant Information Form - John Doe.pdf")"
    IFS='|' read -r extracted_category raw_category cleaned_category raw_remainder cleaned_remainder error_status <<< "$result"
    
    expected_category="Client Compliance"
    
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
  result="$(extract_date_from_path_for_string_test_fallback "VC - John Doe Management/Client Compliance/F007A Participant Information Form - John Doe.pdf" "2024-07-26" "today" "modified")"
  IFS='|' read -r extracted_date raw_date cleaned_date raw_remainder cleaned_remainder error_status <<< "$result"
  
  expected_date="20240726"
  
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
  
  # Test complete filename generation
  echo "Testing complete filename generation..." >&2
  
  # Use the test-specific function that handles fallback dates
  result="$(extract_complete_filename_with_fallback "VC - John Doe Management/Client Compliance/F007A Participant Information Form - John Doe.pdf" "2024-07-26" "today" "modified")"
  
  expected_filename="1001_John Doe_F007A Participant Information Form_20240726_Client Compliance_no.pdf"
  
  echo "----- COMPLETE FILENAME VALIDATION -----" >&2
  echo "Expected filename: '$expected_filename'" >&2
  echo "Generated filename: '$result'" >&2
  echo "-------------------------------------" >&2
  
  # Compare the actual generated filename with the expected filename
  if [ -n "$expected_filename" ]; then
    [ "$result" = "$expected_filename" ]
  fi
  
  echo "=== TEST COMPLETED SUCCESSFULLY ===" >&2
}

@test "complete_integration - VC - John Doe Management/Consent/Participant Consent Form - John Doe.pdf" {
  # Test case: Real-world VC Management prefix/suffix test (John Doe consent)
  # Input: VC - John Doe Management/Consent/Participant Consent Form - John Doe.pdf
  # Expected: 1001_John Doe_Participant Consent Form_20240726_Consent_no.pdf
  
  echo "=== COMPLETE INTEGRATION TEST ===" >&2
  echo "Test case: Real-world VC Management prefix/suffix test (John Doe consent)" >&2
  echo "Input path: VC - John Doe Management/Consent/Participant Consent Form - John Doe.pdf" >&2
  echo "Expected filename: 1001_John Doe_Participant Consent Form_20240726_Consent_no.pdf" >&2
  echo "=================================" >&2
  
  # Test user mapping
  echo "Testing user mapping..." >&2
  result="$(extract_user_from_path "VC - John Doe Management/Consent/Participant Consent Form - John Doe.pdf")"
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
  category_candidate=$(echo "VC - John Doe Management/Consent/Participant Consent Form - John Doe.pdf" | cut -d'/' -f2)
  if [ -n "$category_candidate" ]; then
    
    echo "Testing category mapping..." >&2
    result="$(extract_category_from_path "VC - John Doe Management/Consent/Participant Consent Form - John Doe.pdf")"
    IFS='|' read -r extracted_category raw_category cleaned_category raw_remainder cleaned_remainder error_status <<< "$result"
    
    expected_category="Consent"
    
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
  result="$(extract_date_from_path_for_string_test_fallback "VC - John Doe Management/Consent/Participant Consent Form - John Doe.pdf" "2024-07-26" "today" "modified")"
  IFS='|' read -r extracted_date raw_date cleaned_date raw_remainder cleaned_remainder error_status <<< "$result"
  
  expected_date="20240726"
  
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
  
  # Test complete filename generation
  echo "Testing complete filename generation..." >&2
  
  # Use the test-specific function that handles fallback dates
  result="$(extract_complete_filename_with_fallback "VC - John Doe Management/Consent/Participant Consent Form - John Doe.pdf" "2024-07-26" "today" "modified")"
  
  expected_filename="1001_John Doe_Participant Consent Form_20240726_Consent_no.pdf"
  
  echo "----- COMPLETE FILENAME VALIDATION -----" >&2
  echo "Expected filename: '$expected_filename'" >&2
  echo "Generated filename: '$result'" >&2
  echo "-------------------------------------" >&2
  
  # Compare the actual generated filename with the expected filename
  if [ -n "$expected_filename" ]; then
    [ "$result" = "$expected_filename" ]
  fi
  
  echo "=== TEST COMPLETED SUCCESSFULLY ===" >&2
}

@test "complete_integration - VC - John Doe Management/Service Agreements/1.JohnDoe Plan NDIS.pdf" {
  # Test case: Real-world incorrect name mapping test (JohnDoe should be John Doe)
  # Input: VC - John Doe Management/Service Agreements/1.JohnDoe Plan NDIS.pdf
  # Expected: 1001_John Doe_1 Plan NDIS_20240807_Service Agreements_no.pdf
  
  echo "=== COMPLETE INTEGRATION TEST ===" >&2
  echo "Test case: Real-world incorrect name mapping test (JohnDoe should be John Doe)" >&2
  echo "Input path: VC - John Doe Management/Service Agreements/1.JohnDoe Plan NDIS.pdf" >&2
  echo "Expected filename: 1001_John Doe_1 Plan NDIS_20240807_Service Agreements_no.pdf" >&2
  echo "=================================" >&2
  
  # Test user mapping
  echo "Testing user mapping..." >&2
  result="$(extract_user_from_path "VC - John Doe Management/Service Agreements/1.JohnDoe Plan NDIS.pdf")"
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
  category_candidate=$(echo "VC - John Doe Management/Service Agreements/1.JohnDoe Plan NDIS.pdf" | cut -d'/' -f2)
  if [ -n "$category_candidate" ]; then
    
    echo "Testing category mapping..." >&2
    result="$(extract_category_from_path "VC - John Doe Management/Service Agreements/1.JohnDoe Plan NDIS.pdf")"
    IFS='|' read -r extracted_category raw_category cleaned_category raw_remainder cleaned_remainder error_status <<< "$result"
    
    expected_category="Service Agreements"
    
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
  result="$(extract_date_from_path_for_string_test_fallback "VC - John Doe Management/Service Agreements/1.JohnDoe Plan NDIS.pdf" "2024-08-07" "today" "modified")"
  IFS='|' read -r extracted_date raw_date cleaned_date raw_remainder cleaned_remainder error_status <<< "$result"
  
  expected_date="20240807"
  
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
  
  # Test complete filename generation
  echo "Testing complete filename generation..." >&2
  
  # Use the test-specific function that handles fallback dates
  result="$(extract_complete_filename_with_fallback "VC - John Doe Management/Service Agreements/1.JohnDoe Plan NDIS.pdf" "2024-08-07" "today" "modified")"
  
  expected_filename="1001_John Doe_1 Plan NDIS_20240807_Service Agreements_no.pdf"
  
  echo "----- COMPLETE FILENAME VALIDATION -----" >&2
  echo "Expected filename: '$expected_filename'" >&2
  echo "Generated filename: '$result'" >&2
  echo "-------------------------------------" >&2
  
  # Compare the actual generated filename with the expected filename
  if [ -n "$expected_filename" ]; then
    [ "$result" = "$expected_filename" ]
  fi
  
  echo "=== TEST COMPLETED SUCCESSFULLY ===" >&2
}

@test "complete_integration - VC - John Doe Management/Service Agreements/UNSIGNED John Doe - F007F Service Agreement - Independent 2024.08.02 to 2025.04.23.pdf" {
  # Test case: Real-world date range exclusion test (John Doe service agreement)
  # Input: VC - John Doe Management/Service Agreements/UNSIGNED John Doe - F007F Service Agreement - Independent 2024.08.02 to 2025.04.23.pdf
  # Expected: 1001_John Doe_UNSIGNED F007F Service Agreement Independent 2024.08.02 - 2025.04.23_20250722_Service Agreements_no.pdf
  
  echo "=== COMPLETE INTEGRATION TEST ===" >&2
  echo "Test case: Real-world date range exclusion test (John Doe service agreement)" >&2
  echo "Input path: VC - John Doe Management/Service Agreements/UNSIGNED John Doe - F007F Service Agreement - Independent 2024.08.02 to 2025.04.23.pdf" >&2
  echo "Expected filename: 1001_John Doe_UNSIGNED F007F Service Agreement Independent 2024.08.02 - 2025.04.23_20250722_Service Agreements_no.pdf" >&2
  echo "=================================" >&2
  
  # Test user mapping
  echo "Testing user mapping..." >&2
  result="$(extract_user_from_path "VC - John Doe Management/Service Agreements/UNSIGNED John Doe - F007F Service Agreement - Independent 2024.08.02 to 2025.04.23.pdf")"
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
  category_candidate=$(echo "VC - John Doe Management/Service Agreements/UNSIGNED John Doe - F007F Service Agreement - Independent 2024.08.02 to 2025.04.23.pdf" | cut -d'/' -f2)
  if [ -n "$category_candidate" ]; then
    
    echo "Testing category mapping..." >&2
    result="$(extract_category_from_path "VC - John Doe Management/Service Agreements/UNSIGNED John Doe - F007F Service Agreement - Independent 2024.08.02 to 2025.04.23.pdf")"
    IFS='|' read -r extracted_category raw_category cleaned_category raw_remainder cleaned_remainder error_status <<< "$result"
    
    expected_category="Service Agreements"
    
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
  result="$(extract_date_from_path_for_string_test_fallback "VC - John Doe Management/Service Agreements/UNSIGNED John Doe - F007F Service Agreement - Independent 2024.08.02 to 2025.04.23.pdf" "2025-07-22" "today" "modified")"
  IFS='|' read -r extracted_date raw_date cleaned_date raw_remainder cleaned_remainder error_status <<< "$result"
  
  expected_date="20250722"
  
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
  
  # Test complete filename generation
  echo "Testing complete filename generation..." >&2
  
  # Use the test-specific function that handles fallback dates
  result="$(extract_complete_filename_with_fallback "VC - John Doe Management/Service Agreements/UNSIGNED John Doe - F007F Service Agreement - Independent 2024.08.02 to 2025.04.23.pdf" "2025-07-22" "today" "modified")"
  
  expected_filename="1001_John Doe_UNSIGNED F007F Service Agreement Independent 2024.08.02 - 2025.04.23_20250722_Service Agreements_no.pdf"
  
  echo "----- COMPLETE FILENAME VALIDATION -----" >&2
  echo "Expected filename: '$expected_filename'" >&2
  echo "Generated filename: '$result'" >&2
  echo "-------------------------------------" >&2
  
  # Compare the actual generated filename with the expected filename
  if [ -n "$expected_filename" ]; then
    [ "$result" = "$expected_filename" ]
  fi
  
  echo "=== TEST COMPLETED SUCCESSFULLY ===" >&2
}

@test "complete_integration - VC - John Doe Management/Service Agreements/1.John.D Plan NDIS.pdf" {
  # Test case: Real-world incorrect name mapping test (John.D should be John Doe)
  # Input: VC - John Doe Management/Service Agreements/1.John.D Plan NDIS.pdf
  # Expected: 1001_John Doe_1 Plan NDIS_20240808_Service Agreements_no.pdf
  
  echo "=== COMPLETE INTEGRATION TEST ===" >&2
  echo "Test case: Real-world incorrect name mapping test (John.D should be John Doe)" >&2
  echo "Input path: VC - John Doe Management/Service Agreements/1.John.D Plan NDIS.pdf" >&2
  echo "Expected filename: 1001_John Doe_1 Plan NDIS_20240808_Service Agreements_no.pdf" >&2
  echo "=================================" >&2
  
  # Test user mapping
  echo "Testing user mapping..." >&2
  result="$(extract_user_from_path "VC - John Doe Management/Service Agreements/1.John.D Plan NDIS.pdf")"
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
  category_candidate=$(echo "VC - John Doe Management/Service Agreements/1.John.D Plan NDIS.pdf" | cut -d'/' -f2)
  if [ -n "$category_candidate" ]; then
    
    echo "Testing category mapping..." >&2
    result="$(extract_category_from_path "VC - John Doe Management/Service Agreements/1.John.D Plan NDIS.pdf")"
    IFS='|' read -r extracted_category raw_category cleaned_category raw_remainder cleaned_remainder error_status <<< "$result"
    
    expected_category="Service Agreements"
    
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
  result="$(extract_date_from_path_for_string_test_fallback "VC - John Doe Management/Service Agreements/1.John.D Plan NDIS.pdf" "2024-08-08" "today" "modified")"
  IFS='|' read -r extracted_date raw_date cleaned_date raw_remainder cleaned_remainder error_status <<< "$result"
  
  expected_date="20240808"
  
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
  
  # Test complete filename generation
  echo "Testing complete filename generation..." >&2
  
  # Use the test-specific function that handles fallback dates
  result="$(extract_complete_filename_with_fallback "VC - John Doe Management/Service Agreements/1.John.D Plan NDIS.pdf" "2024-08-08" "today" "modified")"
  
  expected_filename="1001_John Doe_1 Plan NDIS_20240808_Service Agreements_no.pdf"
  
  echo "----- COMPLETE FILENAME VALIDATION -----" >&2
  echo "Expected filename: '$expected_filename'" >&2
  echo "Generated filename: '$result'" >&2
  echo "-------------------------------------" >&2
  
  # Compare the actual generated filename with the expected filename
  if [ -n "$expected_filename" ]; then
    [ "$result" = "$expected_filename" ]
  fi
  
  echo "=== TEST COMPLETED SUCCESSFULLY ===" >&2
}
