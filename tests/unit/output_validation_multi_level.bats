# Auto-generated BATS output validation for multi-level
# Source: tests/fixtures/multi_level_directory_cases.csv

setup() {
  PROJECT_ROOT="$(cd -- "$(dirname -- "${BATS_TEST_FILENAME:-${BASH_SOURCE[0]}}")/../.." && pwd)"
}

@test "multi-level row 1: John Doe - 1001_John Doe_2023 Incidents_2023-06-01_1.pdf" {
  local file="$PROJECT_ROOT/tests/test-files/to-multi-level/John Doe/1001_John Doe_2023 Incidents_2023-06-01_1.pdf"
  echo Checking: $file
  [ -f "$file" ]
}

@test "multi-level row 2: John Doe - 1001_John Doe_GP Report_2024-01-01_2.docx" {
  local file="$PROJECT_ROOT/tests/test-files/to-multi-level/John Doe/1001_John Doe_GP Report_2024-01-01_2.docx"
  echo Checking: $file
  [ -f "$file" ]
}

@test "multi-level row 3: John Doe - 1001_John Doe_25.01.15 - Medication_2025-01-25_11.pdf" {
  local file="$PROJECT_ROOT/tests/test-files/to-multi-level/John Doe/1001_John Doe_25.01.15 - Medication_2025-01-25_11.pdf"
  echo Checking: $file
  [ -f "$file" ]
}

@test "multi-level row 4: John Doe - 1001_John Doe_Receipts Receipt_2024-01-01_3.pdf" {
  local file="$PROJECT_ROOT/tests/test-files/to-multi-level/John Doe/1001_John Doe_Receipts Receipt_2024-01-01_3.pdf"
  echo Checking: $file
  [ -f "$file" ]
}

@test "multi-level row 5: John Doe - 1001_John Doe_GP_2024-02-25_2.pdf" {
  local file="$PROJECT_ROOT/tests/test-files/to-multi-level/John Doe/1001_John Doe_GP_2024-02-25_2.pdf"
  echo Checking: $file
  [ -f "$file" ]
}

@test "multi-level row 6: John Doe - 1001_John Doe_Mealtime Management Mealtime Checklist_2023-01-01_10.pdf" {
  local file="$PROJECT_ROOT/tests/test-files/to-multi-level/John Doe/1001_John Doe_Mealtime Management Mealtime Checklist_2023-01-01_10.pdf"
  echo Checking: $file
  [ -f "$file" ]
}

@test "multi-level row 7: John Doe - 1001_John Doe_Support Plans_2023-07-25_4.pdf" {
  local file="$PROJECT_ROOT/tests/test-files/to-multi-level/John Doe/1001_John Doe_Support Plans_2023-07-25_4.pdf"
  echo Checking: $file
  [ -f "$file" ]
}

@test "multi-level row 8: John Doe - 1001_John Doe_Behavior Forms Journal of PBI_2024-01-01_5.pdf" {
  local file="$PROJECT_ROOT/tests/test-files/to-multi-level/John Doe/1001_John Doe_Behavior Forms Journal of PBI_2024-01-01_5.pdf"
  echo Checking: $file
  [ -f "$file" ]
}

@test "multi-level row 9: John Doe - 1001_John Doe_Photos at the Cinema_2025-01-01_14.jpg" {
  local file="$PROJECT_ROOT/tests/test-files/to-multi-level/John Doe/1001_John Doe_Photos at the Cinema_2025-01-01_14.jpg"
  echo Checking: $file
  [ -f "$file" ]
}

@test "multi-level row 10: John Doe - 1001_John Doe_NDIS Goals_2023-01-01_7.pdf" {
  local file="$PROJECT_ROOT/tests/test-files/to-multi-level/John Doe/1001_John Doe_NDIS Goals_2023-01-01_7.pdf"
  echo Checking: $file
  [ -f "$file" ]
}

@test "multi-level row 11: Jane Smith - 1002_Jane Smith_Medical GP Report_2024-01-01_2.docx" {
  local file="$PROJECT_ROOT/tests/test-files/to-multi-level/Jane Smith/1002_Jane Smith_Medical GP Report_2024-01-01_2.docx"
  echo Checking: $file
  [ -f "$file" ]
}

@test "multi-level row 12: Jane Smith - 1002_Jane Smith_WHS Hazard Reports Risk Assessment_2024-01-01_1.pdf" {
  local file="$PROJECT_ROOT/tests/test-files/to-multi-level/Jane Smith/1002_Jane Smith_WHS Hazard Reports Risk Assessment_2024-01-01_1.pdf"
  echo Checking: $file
  [ -f "$file" ]
}

@test "multi-level row 13: Jane Smith - 1002_Jane Smith_Behavior Forms Journal of PBI_2023-01-01_5.pdf" {
  local file="$PROJECT_ROOT/tests/test-files/to-multi-level/Jane Smith/1002_Jane Smith_Behavior Forms Journal of PBI_2023-01-01_5.pdf"
  echo Checking: $file
  [ -f "$file" ]
}

@test "multi-level row 14: Jane Smith - 1002_Jane Smith_Incidents_2023-02-06_6.pdf" {
  local file="$PROJECT_ROOT/tests/test-files/to-multi-level/Jane Smith/1002_Jane Smith_Incidents_2023-02-06_6.pdf"
  echo Checking: $file
  [ -f "$file" ]
}

@test "multi-level row 15: Jane Smith - 1002_Jane Smith_Team Meetings Team Meeting Agenda_2025-02-12_9.docx" {
  local file="$PROJECT_ROOT/tests/test-files/to-multi-level/Jane Smith/1002_Jane Smith_Team Meetings Team Meeting Agenda_2025-02-12_9.docx"
  echo Checking: $file
  [ -f "$file" ]
}

@test "multi-level row 16: Jane Smith - 1002_Jane Smith_Support Plans_2023-07-25_4.pdf" {
  local file="$PROJECT_ROOT/tests/test-files/to-multi-level/Jane Smith/1002_Jane Smith_Support Plans_2023-07-25_4.pdf"
  echo Checking: $file
  [ -f "$file" ]
}

@test "multi-level row 17: Jane Smith - 1002_Jane Smith_Financial Receipts Receipt_2024-01-01_3.pdf" {
  local file="$PROJECT_ROOT/tests/test-files/to-multi-level/Jane Smith/1002_Jane Smith_Financial Receipts Receipt_2024-01-01_3.pdf"
  echo Checking: $file
  [ -f "$file" ]
}

@test "multi-level row 18: Jane Smith - 1002_Jane Smith_Medical GP_2024-02-25_2.pdf" {
  local file="$PROJECT_ROOT/tests/test-files/to-multi-level/Jane Smith/1002_Jane Smith_Medical GP_2024-02-25_2.pdf"
  echo Checking: $file
  [ -f "$file" ]
}

@test "multi-level row 19: Jane Smith - 1002_Jane Smith_Mealtime Management Mealtime Management Mealtime Checklist_2023-01-01_10.pdf" {
  local file="$PROJECT_ROOT/tests/test-files/to-multi-level/Jane Smith/1002_Jane Smith_Mealtime Management Mealtime Management Mealtime Checklist_2023-01-01_10.pdf"
  echo Checking: $file
  [ -f "$file" ]
}

@test "multi-level row 20: Jane Smith - 1002_Jane Smith_Photos Photos at the Cinema_2025-01-01_14.jpg" {
  local file="$PROJECT_ROOT/tests/test-files/to-multi-level/Jane Smith/1002_Jane Smith_Photos Photos at the Cinema_2025-01-01_14.jpg"
  echo Checking: $file
  [ -f "$file" ]
}

@test "multi-level row 21: Bob Johnson - 1003_Bob Johnson_CHAPS_2023-01-14_8.pdf" {
  local file="$PROJECT_ROOT/tests/test-files/to-multi-level/Bob Johnson/1003_Bob Johnson_CHAPS_2023-01-14_8.pdf"
  echo Checking: $file
  [ -f "$file" ]
}

@test "multi-level row 22: Bob Johnson - 1003_Bob Johnson_Support Plans_2023-07-25_4.pdf" {
  local file="$PROJECT_ROOT/tests/test-files/to-multi-level/Bob Johnson/1003_Bob Johnson_Support Plans_2023-07-25_4.pdf"
  echo Checking: $file
  [ -f "$file" ]
}

@test "multi-level row 23: Bob Johnson - 1003_Bob Johnson_Photos at the Cinema_2025-01-01_14.jpg" {
  local file="$PROJECT_ROOT/tests/test-files/to-multi-level/Bob Johnson/1003_Bob Johnson_Photos at the Cinema_2025-01-01_14.jpg"
  echo Checking: $file
  [ -f "$file" ]
}

@test "multi-level row 24: Bob Johnson - 1003_Bob Johnson_NDIS Goals_2024-01-01_7.pdf" {
  local file="$PROJECT_ROOT/tests/test-files/to-multi-level/Bob Johnson/1003_Bob Johnson_NDIS Goals_2024-01-01_7.pdf"
  echo Checking: $file
  [ -f "$file" ]
}

@test "multi-level row 25: Bob Johnson - 1003_Bob Johnson_Medication PRN PRN Administration_2024-01-01_11.pdf" {
  local file="$PROJECT_ROOT/tests/test-files/to-multi-level/Bob Johnson/1003_Bob Johnson_Medication PRN PRN Administration_2024-01-01_11.pdf"
  echo Checking: $file
  [ -f "$file" ]
}

@test "multi-level row 26: Bob Johnson - 1003_Bob Johnson_Medical GP Report_2024-01-01_2.docx" {
  local file="$PROJECT_ROOT/tests/test-files/to-multi-level/Bob Johnson/1003_Bob Johnson_Medical GP Report_2024-01-01_2.docx"
  echo Checking: $file
  [ -f "$file" ]
}

@test "multi-level row 27: Bob Johnson - 1003_Bob Johnson_WHS Hazard Reports Risk Assessment_2024-01-01_1.pdf" {
  local file="$PROJECT_ROOT/tests/test-files/to-multi-level/Bob Johnson/1003_Bob Johnson_WHS Hazard Reports Risk Assessment_2024-01-01_1.pdf"
  echo Checking: $file
  [ -f "$file" ]
}

@test "multi-level row 28: Bob Johnson - 1003_Bob Johnson_Behavior Forms Journal of PBI_2023-01-01_5.pdf" {
  local file="$PROJECT_ROOT/tests/test-files/to-multi-level/Bob Johnson/1003_Bob Johnson_Behavior Forms Journal of PBI_2023-01-01_5.pdf"
  echo Checking: $file
  [ -f "$file" ]
}

@test "multi-level row 29: Bob Johnson - 1003_Bob Johnson_Incidents_2023-02-06_6.pdf" {
  local file="$PROJECT_ROOT/tests/test-files/to-multi-level/Bob Johnson/1003_Bob Johnson_Incidents_2023-02-06_6.pdf"
  echo Checking: $file
  [ -f "$file" ]
}

@test "multi-level row 30: Bob Johnson - 1003_Bob Johnson_Team Meetings Team Meeting Agenda_2025-02-12_9.docx" {
  local file="$PROJECT_ROOT/tests/test-files/to-multi-level/Bob Johnson/1003_Bob Johnson_Team Meetings Team Meeting Agenda_2025-02-12_9.docx"
  echo Checking: $file
  [ -f "$file" ]
}
