# Auto-generated BATS output validation for basic
# Source: tests/fixtures/basic_test_cases.csv

setup() {
  PROJECT_ROOT="$(cd -- "$(dirname -- "${BATS_TEST_FILENAME:-${BASH_SOURCE[0]}}")/../.." && pwd)"
}

@test "basic row 1: John Doe - 1001_John Doe_Report_2023-05-15.pdf" {
  local file="$PROJECT_ROOT/tests/test-files/to-basic/John Doe/1001_John Doe_Report_2023-05-15.pdf"
  echo Checking: $file
  [ -f "$file" ]
}

@test "basic row 2: John Doe - 1001_john doe_invoice_2024-01-01.docx" {
  local file="$PROJECT_ROOT/tests/test-files/to-basic/John Doe/1001_john doe_invoice_2024-01-01.docx"
  echo Checking: $file
  [ -f "$file" ]
}

@test "basic row 3: John Doe - 1001_John Doe_summary_2022-12-31.txt" {
  local file="$PROJECT_ROOT/tests/test-files/to-basic/John Doe/1001_John Doe_summary_2022-12-31.txt"
  echo Checking: $file
  [ -f "$file" ]
}

@test "basic row 4: Jane Smith - 1002_jane smith_invoice_2024-01-01.docx" {
  local file="$PROJECT_ROOT/tests/test-files/to-basic/Jane Smith/1002_jane smith_invoice_2024-01-01.docx"
  echo Checking: $file
  [ -f "$file" ]
}

@test "basic row 5: Jane Smith - 1002_Jane Smith_Report_2023-06-20.pdf" {
  local file="$PROJECT_ROOT/tests/test-files/to-basic/Jane Smith/1002_Jane Smith_Report_2023-06-20.pdf"
  echo Checking: $file
  [ -f "$file" ]
}

@test "basic row 6: Jane Smith - 1002_jane smith_notes_2023-01-15.txt" {
  local file="$PROJECT_ROOT/tests/test-files/to-basic/Jane Smith/1002_jane smith_notes_2023-01-15.txt"
  echo Checking: $file
  [ -f "$file" ]
}

# Skipped row 7: Temp Person - test_file_2025-07-21.txt (dynamic date or special case)
@test "basic row 8: John Doe - 1001_John Doe_Additional_Report_2024-03-15.pdf" {
  local file="$PROJECT_ROOT/tests/test-files/to-basic/John Doe/1001_John Doe_Additional_Report_2024-03-15.pdf"
  echo Checking: $file
  [ -f "$file" ]
}
