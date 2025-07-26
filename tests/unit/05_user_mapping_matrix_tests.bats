#!/usr/bin/env bats

# User Mapping Matrix Tests
# Generated from tests/fixtures/05_user_mapping_cases.csv

source /home/athorne/dev/repos/visualcare-file-migration-renamer/tests/utils/user_mapping.sh

@test "extract_user_from_path___John_Doe_file.pdf" {
    # Standard full name directory
    result="$(extract_user_from_path "John Doe/file.pdf")"
    
    # Parse result components
    IFS='|' read -r user_id full_name raw_name cleaned_name raw_remainder cleaned_remainder <<< "$result"
    
    # Get normalized filename using real function
    normalized_filename="$(python3 /home/athorne/dev/repos/visualcare-file-migration-renamer/tests/utils/normalize_test.py "John Doe/file.pdf")"
    
    # Debug output
    echo "----- TEST CASE -----"
    echo "Comment: Standard full name directory"
    echo "function: extract_user_from_path"
    echo "input_path: John Doe/file.pdf"
    echo "expected_user_id: 1001"
    echo "expected_full_name: John Doe"
    echo "raw_name expected: John Doe"
    echo "raw_name matched: $raw_name"
    echo "cleaned_name expected: John Doe"
    echo "cleaned_name matched: $cleaned_name"
    echo "raw_remainder expected: file.pdf"
    echo "raw_remainder matched: $raw_remainder"
    echo "cleaned_remainder expected: file.pdf"
    echo "cleaned_remainder matched: $cleaned_remainder"
    echo "user_id expected: 1001"
    echo "user_id matched: $user_id"
    echo "full_name expected: John Doe"
    echo "full_name matched: $full_name"
    echo "normalized filename: $normalized_filename"
    echo "---------------------"
    
    # Assertions
    [ "$user_id" = "1001" ]
    [ "$full_name" = "John Doe" ]
    [ "$raw_name" = "John Doe" ]
    [ "$cleaned_name" = "John Doe" ]
    [ "$raw_remainder" = "file.pdf" ]
    [ "$cleaned_remainder" = "file.pdf" ]
}

@test "extract_user_from_path___Jane_Smith_report.txt" {
    # Standard full name directory
    result="$(extract_user_from_path "Jane Smith/report.txt")"
    
    # Parse result components
    IFS='|' read -r user_id full_name raw_name cleaned_name raw_remainder cleaned_remainder <<< "$result"
    
    # Get normalized filename using real function
    normalized_filename="$(python3 /home/athorne/dev/repos/visualcare-file-migration-renamer/tests/utils/normalize_test.py "Jane Smith/report.txt")"
    
    # Debug output
    echo "----- TEST CASE -----"
    echo "Comment: Standard full name directory"
    echo "function: extract_user_from_path"
    echo "input_path: Jane Smith/report.txt"
    echo "expected_user_id: 1002"
    echo "expected_full_name: Jane Smith"
    echo "raw_name expected: Jane Smith"
    echo "raw_name matched: $raw_name"
    echo "cleaned_name expected: Jane Smith"
    echo "cleaned_name matched: $cleaned_name"
    echo "raw_remainder expected: report.txt"
    echo "raw_remainder matched: $raw_remainder"
    echo "cleaned_remainder expected: report.txt"
    echo "cleaned_remainder matched: $cleaned_remainder"
    echo "user_id expected: 1002"
    echo "user_id matched: $user_id"
    echo "full_name expected: Jane Smith"
    echo "full_name matched: $full_name"
    echo "normalized filename: $normalized_filename"
    echo "---------------------"
    
    # Assertions
    [ "$user_id" = "1002" ]
    [ "$full_name" = "Jane Smith" ]
    [ "$raw_name" = "Jane Smith" ]
    [ "$cleaned_name" = "Jane Smith" ]
    [ "$raw_remainder" = "report.txt" ]
    [ "$cleaned_remainder" = "report.txt" ]
}

@test "extract_user_from_path___VC___John_Doe_document.pdf" {
    # Directory with prefix (VC - )
    result="$(extract_user_from_path "VC - John Doe/document.pdf")"
    
    # Parse result components
    IFS='|' read -r user_id full_name raw_name cleaned_name raw_remainder cleaned_remainder <<< "$result"
    
    # Get normalized filename using real function
    normalized_filename="$(python3 /home/athorne/dev/repos/visualcare-file-migration-renamer/tests/utils/normalize_test.py "VC - John Doe/document.pdf")"
    
    # Debug output
    echo "----- TEST CASE -----"
    echo "Comment: Directory with prefix (VC - )"
    echo "function: extract_user_from_path"
    echo "input_path: VC - John Doe/document.pdf"
    echo "expected_user_id: 1001"
    echo "expected_full_name: John Doe"
    echo "raw_name expected: VC - John Doe"
    echo "raw_name matched: $raw_name"
    echo "cleaned_name expected: John Doe"
    echo "cleaned_name matched: $cleaned_name"
    echo "raw_remainder expected: document.pdf"
    echo "raw_remainder matched: $raw_remainder"
    echo "cleaned_remainder expected: document.pdf"
    echo "cleaned_remainder matched: $cleaned_remainder"
    echo "user_id expected: 1001"
    echo "user_id matched: $user_id"
    echo "full_name expected: John Doe"
    echo "full_name matched: $full_name"
    echo "normalized filename: $normalized_filename"
    echo "---------------------"
    
    # Assertions
    [ "$user_id" = "1001" ]
    [ "$full_name" = "John Doe" ]
    [ "$raw_name" = "VC - John Doe" ]
    [ "$cleaned_name" = "John Doe" ]
    [ "$raw_remainder" = "document.pdf" ]
    [ "$cleaned_remainder" = "document.pdf" ]
}

@test "extract_user_from_path___VC___Jane_Smith_notes.docx" {
    # Directory with prefix (VC - )
    result="$(extract_user_from_path "VC - Jane Smith/notes.docx")"
    
    # Parse result components
    IFS='|' read -r user_id full_name raw_name cleaned_name raw_remainder cleaned_remainder <<< "$result"
    
    # Get normalized filename using real function
    normalized_filename="$(python3 /home/athorne/dev/repos/visualcare-file-migration-renamer/tests/utils/normalize_test.py "VC - Jane Smith/notes.docx")"
    
    # Debug output
    echo "----- TEST CASE -----"
    echo "Comment: Directory with prefix (VC - )"
    echo "function: extract_user_from_path"
    echo "input_path: VC - Jane Smith/notes.docx"
    echo "expected_user_id: 1002"
    echo "expected_full_name: Jane Smith"
    echo "raw_name expected: VC - Jane Smith"
    echo "raw_name matched: $raw_name"
    echo "cleaned_name expected: Jane Smith"
    echo "cleaned_name matched: $cleaned_name"
    echo "raw_remainder expected: notes.docx"
    echo "raw_remainder matched: $raw_remainder"
    echo "cleaned_remainder expected: notes.docx"
    echo "cleaned_remainder matched: $cleaned_remainder"
    echo "user_id expected: 1002"
    echo "user_id matched: $user_id"
    echo "full_name expected: Jane Smith"
    echo "full_name matched: $full_name"
    echo "normalized filename: $normalized_filename"
    echo "---------------------"
    
    # Assertions
    [ "$user_id" = "1002" ]
    [ "$full_name" = "Jane Smith" ]
    [ "$raw_name" = "VC - Jane Smith" ]
    [ "$cleaned_name" = "Jane Smith" ]
    [ "$raw_remainder" = "notes.docx" ]
    [ "$cleaned_remainder" = "notes.docx" ]
}

@test "extract_user_from_path___John_Doe___Active_summary.pdf" {
    # Directory with suffix (- Active)
    result="$(extract_user_from_path "John Doe - Active/summary.pdf")"
    
    # Parse result components
    IFS='|' read -r user_id full_name raw_name cleaned_name raw_remainder cleaned_remainder <<< "$result"
    
    # Get normalized filename using real function
    normalized_filename="$(python3 /home/athorne/dev/repos/visualcare-file-migration-renamer/tests/utils/normalize_test.py "John Doe - Active/summary.pdf")"
    
    # Debug output
    echo "----- TEST CASE -----"
    echo "Comment: Directory with suffix (- Active)"
    echo "function: extract_user_from_path"
    echo "input_path: John Doe - Active/summary.pdf"
    echo "expected_user_id: 1001"
    echo "expected_full_name: John Doe"
    echo "raw_name expected: John Doe - Active"
    echo "raw_name matched: $raw_name"
    echo "cleaned_name expected: John Doe"
    echo "cleaned_name matched: $cleaned_name"
    echo "raw_remainder expected: summary.pdf"
    echo "raw_remainder matched: $raw_remainder"
    echo "cleaned_remainder expected: summary.pdf"
    echo "cleaned_remainder matched: $cleaned_remainder"
    echo "user_id expected: 1001"
    echo "user_id matched: $user_id"
    echo "full_name expected: John Doe"
    echo "full_name matched: $full_name"
    echo "normalized filename: $normalized_filename"
    echo "---------------------"
    
    # Assertions
    [ "$user_id" = "1001" ]
    [ "$full_name" = "John Doe" ]
    [ "$raw_name" = "John Doe - Active" ]
    [ "$cleaned_name" = "John Doe" ]
    [ "$raw_remainder" = "summary.pdf" ]
    [ "$cleaned_remainder" = "summary.pdf" ]
}

@test "extract_user_from_path___Temp_Person_data.csv" {
    # Unmapped user
    result="$(extract_user_from_path "Temp Person/data.csv")"
    
    # Parse result components
    IFS='|' read -r user_id full_name raw_name cleaned_name raw_remainder cleaned_remainder <<< "$result"
    
    # Get normalized filename using real function
    normalized_filename="$(python3 /home/athorne/dev/repos/visualcare-file-migration-renamer/tests/utils/normalize_test.py "Temp Person/data.csv")"
    
    # Debug output
    echo "----- TEST CASE -----"
    echo "Comment: Unmapped user"
    echo "function: extract_user_from_path"
    echo "input_path: Temp Person/data.csv"
    echo "expected_user_id: "
    echo "expected_full_name: "
    echo "raw_name expected: Temp Person"
    echo "raw_name matched: $raw_name"
    echo "cleaned_name expected: Temp Person"
    echo "cleaned_name matched: $cleaned_name"
    echo "raw_remainder expected: data.csv"
    echo "raw_remainder matched: $raw_remainder"
    echo "cleaned_remainder expected: data.csv"
    echo "cleaned_remainder matched: $cleaned_remainder"
    echo "user_id expected: "
    echo "user_id matched: $user_id"
    echo "full_name expected: "
    echo "full_name matched: $full_name"
    echo "normalized filename: $normalized_filename"
    echo "---------------------"
    
    # Assertions
    [ "$user_id" = "" ]
    [ "$full_name" = "" ]
    [ "$raw_name" = "Temp Person" ]
    [ "$cleaned_name" = "Temp Person" ]
    [ "$raw_remainder" = "data.csv" ]
    [ "$cleaned_remainder" = "data.csv" ]
}

@test "extract_user_from_path___john_doe_image.jpg" {
    # Case-insensitive mapped user 
    result="$(extract_user_from_path "john doe/image.jpg")"
    
    # Parse result components
    IFS='|' read -r user_id full_name raw_name cleaned_name raw_remainder cleaned_remainder <<< "$result"
    
    # Get normalized filename using real function
    normalized_filename="$(python3 /home/athorne/dev/repos/visualcare-file-migration-renamer/tests/utils/normalize_test.py "john doe/image.jpg")"
    
    # Debug output
    echo "----- TEST CASE -----"
    echo "Comment: Case-insensitive mapped user "
    echo "function: extract_user_from_path"
    echo "input_path: john doe/image.jpg"
    echo "expected_user_id: 1001"
    echo "expected_full_name: John Doe"
    echo "raw_name expected: john doe"
    echo "raw_name matched: $raw_name"
    echo "cleaned_name expected: John Doe"
    echo "cleaned_name matched: $cleaned_name"
    echo "raw_remainder expected: image.jpg"
    echo "raw_remainder matched: $raw_remainder"
    echo "cleaned_remainder expected: image.jpg"
    echo "cleaned_remainder matched: $cleaned_remainder"
    echo "user_id expected: 1001"
    echo "user_id matched: $user_id"
    echo "full_name expected: John Doe"
    echo "full_name matched: $full_name"
    echo "normalized filename: $normalized_filename"
    echo "---------------------"
    
    # Assertions
    [ "$user_id" = "1001" ]
    [ "$full_name" = "John Doe" ]
    [ "$raw_name" = "john doe" ]
    [ "$cleaned_name" = "John Doe" ]
    [ "$raw_remainder" = "image.jpg" ]
    [ "$cleaned_remainder" = "image.jpg" ]
}

