#!/usr/bin/env bats

# User Mapping Matrix Tests
# Generated from tests/fixtures/05_user_mapping_cases.csv

source /home/athorne/dev/repos/visualcare-file-migration-renamer/tests/utils/user_mapping.sh

@test "extract_user_from_path___John_Doe_file.pdf" {
    # Standard full name directory
    result="$(extract_user_from_path "John Doe/file.pdf")"
    
    # Parse result components
    IFS='|' read -r user_id raw_name cleaned_name raw_remainder cleaned_remainder <<< "$result"
    
    # Get normalized filename using real function
    normalized_filename="$(python3 /home/athorne/dev/repos/visualcare-file-migration-renamer/tests/utils/normalize_test.py "John Doe/file.pdf")"
    
    # Debug output
    echo "----- TEST CASE -----"
    echo "Comment: Standard full name directory"
    echo "function: extract_user_from_path"
    echo "input_path: John Doe/file.pdf"
    echo "expected_user_id: 1001"
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
    echo "normalized filename: $normalized_filename"
    echo "---------------------"
    
    # Assertions
    [ "$user_id" = "1001" ]
    [ "$raw_name" = "John Doe" ]
    [ "$cleaned_name" = "John Doe" ]
    [ "$raw_remainder" = "file.pdf" ]
    [ "$cleaned_remainder" = "file.pdf" ]
}

@test "extract_user_from_path___Jane_Smith_report.txt" {
    # Standard full name directory
    result="$(extract_user_from_path "Jane Smith/report.txt")"
    
    # Parse result components
    IFS='|' read -r user_id raw_name cleaned_name raw_remainder cleaned_remainder <<< "$result"
    
    # Get normalized filename using real function
    normalized_filename="$(python3 /home/athorne/dev/repos/visualcare-file-migration-renamer/tests/utils/normalize_test.py "Jane Smith/report.txt")"
    
    # Debug output
    echo "----- TEST CASE -----"
    echo "Comment: Standard full name directory"
    echo "function: extract_user_from_path"
    echo "input_path: Jane Smith/report.txt"
    echo "expected_user_id: 1002"
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
    echo "normalized filename: $normalized_filename"
    echo "---------------------"
    
    # Assertions
    [ "$user_id" = "1002" ]
    [ "$raw_name" = "Jane Smith" ]
    [ "$cleaned_name" = "Jane Smith" ]
    [ "$raw_remainder" = "report.txt" ]
    [ "$cleaned_remainder" = "report.txt" ]
}

@test "extract_user_from_path___VC___John_Doe_document.pdf" {
    # Directory with prefix (VC - )
    result="$(extract_user_from_path "VC - John Doe/document.pdf")"
    
    # Parse result components
    IFS='|' read -r user_id raw_name cleaned_name raw_remainder cleaned_remainder <<< "$result"
    
    # Get normalized filename using real function
    normalized_filename="$(python3 /home/athorne/dev/repos/visualcare-file-migration-renamer/tests/utils/normalize_test.py "VC - John Doe/document.pdf")"
    
    # Debug output
    echo "----- TEST CASE -----"
    echo "Comment: Directory with prefix (VC - )"
    echo "function: extract_user_from_path"
    echo "input_path: VC - John Doe/document.pdf"
    echo "expected_user_id: 1001"
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
    echo "normalized filename: $normalized_filename"
    echo "---------------------"
    
    # Assertions
    [ "$user_id" = "1001" ]
    [ "$raw_name" = "VC - John Doe" ]
    [ "$cleaned_name" = "John Doe" ]
    [ "$raw_remainder" = "document.pdf" ]
    [ "$cleaned_remainder" = "document.pdf" ]
}

@test "extract_user_from_path___VC___Jane_Smith_notes.docx" {
    # Directory with prefix (VC - )
    result="$(extract_user_from_path "VC - Jane Smith/notes.docx")"
    
    # Parse result components
    IFS='|' read -r user_id raw_name cleaned_name raw_remainder cleaned_remainder <<< "$result"
    
    # Get normalized filename using real function
    normalized_filename="$(python3 /home/athorne/dev/repos/visualcare-file-migration-renamer/tests/utils/normalize_test.py "VC - Jane Smith/notes.docx")"
    
    # Debug output
    echo "----- TEST CASE -----"
    echo "Comment: Directory with prefix (VC - )"
    echo "function: extract_user_from_path"
    echo "input_path: VC - Jane Smith/notes.docx"
    echo "expected_user_id: 1002"
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
    echo "normalized filename: $normalized_filename"
    echo "---------------------"
    
    # Assertions
    [ "$user_id" = "1002" ]
    [ "$raw_name" = "VC - Jane Smith" ]
    [ "$cleaned_name" = "Jane Smith" ]
    [ "$raw_remainder" = "notes.docx" ]
    [ "$cleaned_remainder" = "notes.docx" ]
}

@test "extract_user_from_path___Temp_Person_data.csv" {
    # Unmapped user
    result="$(extract_user_from_path "Temp Person/data.csv")"
    
    # Parse result components
    IFS='|' read -r user_id raw_name cleaned_name raw_remainder cleaned_remainder <<< "$result"
    
    # Get normalized filename using real function
    normalized_filename="$(python3 /home/athorne/dev/repos/visualcare-file-migration-renamer/tests/utils/normalize_test.py "Temp Person/data.csv")"
    
    # Debug output
    echo "----- TEST CASE -----"
    echo "Comment: Unmapped user"
    echo "function: extract_user_from_path"
    echo "input_path: Temp Person/data.csv"
    echo "expected_user_id: "
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
    echo "normalized filename: $normalized_filename"
    echo "---------------------"
    
    # Assertions
    [ "$user_id" = "" ]
    [ "$raw_name" = "Temp Person" ]
    [ "$cleaned_name" = "Temp Person" ]
    [ "$raw_remainder" = "data.csv" ]
    [ "$cleaned_remainder" = "data.csv" ]
}

@test "extract_user_from_path___john_doe_image.jpg" {
    # Case-insensitive mapped user
    result="$(extract_user_from_path "john doe/image.jpg")"
    
    # Parse result components
    IFS='|' read -r user_id raw_name cleaned_name raw_remainder cleaned_remainder <<< "$result"
    
    # Get normalized filename using real function
    normalized_filename="$(python3 /home/athorne/dev/repos/visualcare-file-migration-renamer/tests/utils/normalize_test.py "john doe/image.jpg")"
    
    # Debug output
    echo "----- TEST CASE -----"
    echo "Comment: Case-insensitive mapped user"
    echo "function: extract_user_from_path"
    echo "input_path: john doe/image.jpg"
    echo "expected_user_id: 1001"
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
    echo "normalized filename: $normalized_filename"
    echo "---------------------"
    
    # Assertions
    [ "$user_id" = "1001" ]
    [ "$raw_name" = "john doe" ]
    [ "$cleaned_name" = "John Doe" ]
    [ "$raw_remainder" = "image.jpg" ]
    [ "$cleaned_remainder" = "image.jpg" ]
}

@test "extract_user_from_path___VC___Mary_Jane_Wilson_2024_Progress_Report.pdf" {
    # Multi-word name with prefix and subdirectory
    result="$(extract_user_from_path "VC - Mary Jane Wilson/2024/Progress Report.pdf")"
    
    # Parse result components
    IFS='|' read -r user_id raw_name cleaned_name raw_remainder cleaned_remainder <<< "$result"
    
    # Get normalized filename using real function
    normalized_filename="$(python3 /home/athorne/dev/repos/visualcare-file-migration-renamer/tests/utils/normalize_test.py "VC - Mary Jane Wilson/2024/Progress Report.pdf")"
    
    # Debug output
    echo "----- TEST CASE -----"
    echo "Comment: Multi-word name with prefix and subdirectory"
    echo "function: extract_user_from_path"
    echo "input_path: VC - Mary Jane Wilson/2024/Progress Report.pdf"
    echo "expected_user_id: 1003"
    echo "raw_name expected: VC - Mary Jane Wilson"
    echo "raw_name matched: $raw_name"
    echo "cleaned_name expected: Mary Jane Wilson"
    echo "cleaned_name matched: $cleaned_name"
    echo "raw_remainder expected: 2024/Progress Report.pdf"
    echo "raw_remainder matched: $raw_remainder"
    echo "cleaned_remainder expected: 2024 Progress Report.pdf"
    echo "cleaned_remainder matched: $cleaned_remainder"
    echo "user_id expected: 1003"
    echo "user_id matched: $user_id"
    echo "normalized filename: $normalized_filename"
    echo "---------------------"
    
    # Assertions
    [ "$user_id" = "1003" ]
    [ "$raw_name" = "VC - Mary Jane Wilson" ]
    [ "$cleaned_name" = "Mary Jane Wilson" ]
    [ "$raw_remainder" = "2024/Progress Report.pdf" ]
    [ "$cleaned_remainder" = "2024 Progress Report.pdf" ]
}

@test "extract_user_from_path___VC___Anne_Marie_O'Connor_Photos_&_Videos_Photo_Album.zip" {
    # Name with hyphens and apostrophe
    result="$(extract_user_from_path "VC - Anne-Marie O'Connor/Photos & Videos/Photo Album.zip")"
    
    # Parse result components
    IFS='|' read -r user_id raw_name cleaned_name raw_remainder cleaned_remainder <<< "$result"
    
    # Get normalized filename using real function
    normalized_filename="$(python3 /home/athorne/dev/repos/visualcare-file-migration-renamer/tests/utils/normalize_test.py "VC - Anne-Marie O'Connor/Photos & Videos/Photo Album.zip")"
    
    # Debug output
    echo "----- TEST CASE -----"
    echo "Comment: Name with hyphens and apostrophe"
    echo "function: extract_user_from_path"
    echo "input_path: VC - Anne-Marie O'Connor/Photos & Videos/Photo Album.zip"
    echo "expected_user_id: 1005"
    echo "raw_name expected: VC - Anne-Marie O'Connor"
    echo "raw_name matched: $raw_name"
    echo "cleaned_name expected: Anne-Marie O'Connor"
    echo "cleaned_name matched: $cleaned_name"
    echo "raw_remainder expected: Photos & Videos/Photo Album.zip"
    echo "raw_remainder matched: $raw_remainder"
    echo "cleaned_remainder expected: Photos Videos Photo Album.zip"
    echo "cleaned_remainder matched: $cleaned_remainder"
    echo "user_id expected: 1005"
    echo "user_id matched: $user_id"
    echo "normalized filename: $normalized_filename"
    echo "---------------------"
    
    # Assertions
    [ "$user_id" = "1005" ]
    [ "$raw_name" = "VC - Anne-Marie O'Connor" ]
    [ "$cleaned_name" = "Anne-Marie O'Connor" ]
    [ "$raw_remainder" = "Photos & Videos/Photo Album.zip" ]
    [ "$cleaned_remainder" = "Photos Videos Photo Album.zip" ]
}

@test "extract_user_from_path___VC___Elizabeth_van_der_Berg_Medical_Records_Assessment.pdf" {
    # Name with multiple words
    result="$(extract_user_from_path "VC - Elizabeth van der Berg/Medical Records/Assessment.pdf")"
    
    # Parse result components
    IFS='|' read -r user_id raw_name cleaned_name raw_remainder cleaned_remainder <<< "$result"
    
    # Get normalized filename using real function
    normalized_filename="$(python3 /home/athorne/dev/repos/visualcare-file-migration-renamer/tests/utils/normalize_test.py "VC - Elizabeth van der Berg/Medical Records/Assessment.pdf")"
    
    # Debug output
    echo "----- TEST CASE -----"
    echo "Comment: Name with multiple words"
    echo "function: extract_user_from_path"
    echo "input_path: VC - Elizabeth van der Berg/Medical Records/Assessment.pdf"
    echo "expected_user_id: 1007"
    echo "raw_name expected: VC - Elizabeth van der Berg"
    echo "raw_name matched: $raw_name"
    echo "cleaned_name expected: Elizabeth Van Der Berg"
    echo "cleaned_name matched: $cleaned_name"
    echo "raw_remainder expected: Medical Records/Assessment.pdf"
    echo "raw_remainder matched: $raw_remainder"
    echo "cleaned_remainder expected: Medical Records Assessment.pdf"
    echo "cleaned_remainder matched: $cleaned_remainder"
    echo "user_id expected: 1007"
    echo "user_id matched: $user_id"
    echo "normalized filename: $normalized_filename"
    echo "---------------------"
    
    # Assertions
    [ "$user_id" = "1007" ]
    [ "$raw_name" = "VC - Elizabeth van der Berg" ]
    [ "$cleaned_name" = "Elizabeth Van Der Berg" ]
    [ "$raw_remainder" = "Medical Records/Assessment.pdf" ]
    [ "$cleaned_remainder" = "Medical Records Assessment.pdf" ]
}

@test "extract_user_from_path___VC___Jean_Pierre_Dubois_Emergency_Contacts_Contact_List.pdf" {
    # French name with hyphen
    result="$(extract_user_from_path "VC - Jean-Pierre Dubois/Emergency Contacts/Contact List.pdf")"
    
    # Parse result components
    IFS='|' read -r user_id raw_name cleaned_name raw_remainder cleaned_remainder <<< "$result"
    
    # Get normalized filename using real function
    normalized_filename="$(python3 /home/athorne/dev/repos/visualcare-file-migration-renamer/tests/utils/normalize_test.py "VC - Jean-Pierre Dubois/Emergency Contacts/Contact List.pdf")"
    
    # Debug output
    echo "----- TEST CASE -----"
    echo "Comment: French name with hyphen"
    echo "function: extract_user_from_path"
    echo "input_path: VC - Jean-Pierre Dubois/Emergency Contacts/Contact List.pdf"
    echo "expected_user_id: 1009"
    echo "raw_name expected: VC - Jean-Pierre Dubois"
    echo "raw_name matched: $raw_name"
    echo "cleaned_name expected: Jean-Pierre Dubois"
    echo "cleaned_name matched: $cleaned_name"
    echo "raw_remainder expected: Emergency Contacts/Contact List.pdf"
    echo "raw_remainder matched: $raw_remainder"
    echo "cleaned_remainder expected: Emergency Contacts Contact List.pdf"
    echo "cleaned_remainder matched: $cleaned_remainder"
    echo "user_id expected: 1009"
    echo "user_id matched: $user_id"
    echo "normalized filename: $normalized_filename"
    echo "---------------------"
    
    # Assertions
    [ "$user_id" = "1009" ]
    [ "$raw_name" = "VC - Jean-Pierre Dubois" ]
    [ "$cleaned_name" = "Jean-Pierre Dubois" ]
    [ "$raw_remainder" = "Emergency Contacts/Contact List.pdf" ]
    [ "$cleaned_remainder" = "Emergency Contacts Contact List.pdf" ]
}

@test "extract_user_from_path___VC___Patricia_Thompson_Smith_Mealtime_Management_Food_Diary.pdf" {
    # Name with double hyphen
    result="$(extract_user_from_path "VC - Patricia Thompson-Smith/Mealtime Management/Food Diary.pdf")"
    
    # Parse result components
    IFS='|' read -r user_id raw_name cleaned_name raw_remainder cleaned_remainder <<< "$result"
    
    # Get normalized filename using real function
    normalized_filename="$(python3 /home/athorne/dev/repos/visualcare-file-migration-renamer/tests/utils/normalize_test.py "VC - Patricia Thompson-Smith/Mealtime Management/Food Diary.pdf")"
    
    # Debug output
    echo "----- TEST CASE -----"
    echo "Comment: Name with double hyphen"
    echo "function: extract_user_from_path"
    echo "input_path: VC - Patricia Thompson-Smith/Mealtime Management/Food Diary.pdf"
    echo "expected_user_id: 1011"
    echo "raw_name expected: VC - Patricia Thompson-Smith"
    echo "raw_name matched: $raw_name"
    echo "cleaned_name expected: Patricia Thompson-Smith"
    echo "cleaned_name matched: $cleaned_name"
    echo "raw_remainder expected: Mealtime Management/Food Diary.pdf"
    echo "raw_remainder matched: $raw_remainder"
    echo "cleaned_remainder expected: Mealtime Management Food Diary.pdf"
    echo "cleaned_remainder matched: $cleaned_remainder"
    echo "user_id expected: 1011"
    echo "user_id matched: $user_id"
    echo "normalized filename: $normalized_filename"
    echo "---------------------"
    
    # Assertions
    [ "$user_id" = "1011" ]
    [ "$raw_name" = "VC - Patricia Thompson-Smith" ]
    [ "$cleaned_name" = "Patricia Thompson-Smith" ]
    [ "$raw_remainder" = "Mealtime Management/Food Diary.pdf" ]
    [ "$cleaned_remainder" = "Mealtime Management Food Diary.pdf" ]
}

@test "extract_user_from_path___Unknown_Person_With_Complex_Name_2024_Reports_Report.pdf" {
    # Unmapped complex name
    result="$(extract_user_from_path "Unknown Person With Complex Name/2024/Reports/Report.pdf")"
    
    # Parse result components
    IFS='|' read -r user_id raw_name cleaned_name raw_remainder cleaned_remainder <<< "$result"
    
    # Get normalized filename using real function
    normalized_filename="$(python3 /home/athorne/dev/repos/visualcare-file-migration-renamer/tests/utils/normalize_test.py "Unknown Person With Complex Name/2024/Reports/Report.pdf")"
    
    # Debug output
    echo "----- TEST CASE -----"
    echo "Comment: Unmapped complex name"
    echo "function: extract_user_from_path"
    echo "input_path: Unknown Person With Complex Name/2024/Reports/Report.pdf"
    echo "expected_user_id: "
    echo "raw_name expected: Unknown Person With Complex Name"
    echo "raw_name matched: $raw_name"
    echo "cleaned_name expected: Unknown Person With Complex Name"
    echo "cleaned_name matched: $cleaned_name"
    echo "raw_remainder expected: 2024/Reports/Report.pdf"
    echo "raw_remainder matched: $raw_remainder"
    echo "cleaned_remainder expected: 2024 Reports Report.pdf"
    echo "cleaned_remainder matched: $cleaned_remainder"
    echo "user_id expected: "
    echo "user_id matched: $user_id"
    echo "normalized filename: $normalized_filename"
    echo "---------------------"
    
    # Assertions
    [ "$user_id" = "" ]
    [ "$raw_name" = "Unknown Person With Complex Name" ]
    [ "$cleaned_name" = "Unknown Person With Complex Name" ]
    [ "$raw_remainder" = "2024/Reports/Report.pdf" ]
    [ "$cleaned_remainder" = "2024 Reports Report.pdf" ]
}

@test "extract_user_from_path___VC___john_michael_smith_Personal_Care_Assessment.pdf" {
    # Case-insensitive multi-word name
    result="$(extract_user_from_path "VC - john michael smith/Personal Care/Assessment.pdf")"
    
    # Parse result components
    IFS='|' read -r user_id raw_name cleaned_name raw_remainder cleaned_remainder <<< "$result"
    
    # Get normalized filename using real function
    normalized_filename="$(python3 /home/athorne/dev/repos/visualcare-file-migration-renamer/tests/utils/normalize_test.py "VC - john michael smith/Personal Care/Assessment.pdf")"
    
    # Debug output
    echo "----- TEST CASE -----"
    echo "Comment: Case-insensitive multi-word name"
    echo "function: extract_user_from_path"
    echo "input_path: VC - john michael smith/Personal Care/Assessment.pdf"
    echo "expected_user_id: 1012"
    echo "raw_name expected: VC - john michael smith"
    echo "raw_name matched: $raw_name"
    echo "cleaned_name expected: John Michael Smith"
    echo "cleaned_name matched: $cleaned_name"
    echo "raw_remainder expected: Personal Care/Assessment.pdf"
    echo "raw_remainder matched: $raw_remainder"
    echo "cleaned_remainder expected: Personal Care Assessment.pdf"
    echo "cleaned_remainder matched: $cleaned_remainder"
    echo "user_id expected: 1012"
    echo "user_id matched: $user_id"
    echo "normalized filename: $normalized_filename"
    echo "---------------------"
    
    # Assertions
    [ "$user_id" = "1012" ]
    [ "$raw_name" = "VC - john michael smith" ]
    [ "$cleaned_name" = "John Michael Smith" ]
    [ "$raw_remainder" = "Personal Care/Assessment.pdf" ]
    [ "$cleaned_remainder" = "Personal Care Assessment.pdf" ]
}

@test "extract_user_from_path___VC___Person_With_Numbers_123_Test_Files_test.pdf" {
    # Name with numbers (unmapped) 
    result="$(extract_user_from_path "VC - Person With Numbers 123/Test Files/test.pdf")"
    
    # Parse result components
    IFS='|' read -r user_id raw_name cleaned_name raw_remainder cleaned_remainder <<< "$result"
    
    # Get normalized filename using real function
    normalized_filename="$(python3 /home/athorne/dev/repos/visualcare-file-migration-renamer/tests/utils/normalize_test.py "VC - Person With Numbers 123/Test Files/test.pdf")"
    
    # Debug output
    echo "----- TEST CASE -----"
    echo "Comment: Name with numbers (unmapped) "
    echo "function: extract_user_from_path"
    echo "input_path: VC - Person With Numbers 123/Test Files/test.pdf"
    echo "expected_user_id: "
    echo "raw_name expected: VC - Person With Numbers 123"
    echo "raw_name matched: $raw_name"
    echo "cleaned_name expected: Person With Numbers 123"
    echo "cleaned_name matched: $cleaned_name"
    echo "raw_remainder expected: Test Files/test.pdf"
    echo "raw_remainder matched: $raw_remainder"
    echo "cleaned_remainder expected: Test Files test.pdf"
    echo "cleaned_remainder matched: $cleaned_remainder"
    echo "user_id expected: "
    echo "user_id matched: $user_id"
    echo "normalized filename: $normalized_filename"
    echo "---------------------"
    
    # Assertions
    [ "$user_id" = "" ]
    [ "$raw_name" = "VC - Person With Numbers 123" ]
    [ "$cleaned_name" = "Person With Numbers 123" ]
    [ "$raw_remainder" = "Test Files/test.pdf" ]
    [ "$cleaned_remainder" = "Test Files test.pdf" ]
}

