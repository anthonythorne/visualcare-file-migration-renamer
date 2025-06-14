#!/usr/bin/env bats

load '../test_helper.bash'
source '../../core/utils/date_utils.sh'

@test "extract_date_from_filename extracts standard date formats" {
    run extract_date_from_filename "report_20230506.pdf"
    [ "$status" -eq 0 ]
    [ "$output" = "20230506" ]
}

@test "extract_date_from_filename extracts abbreviated date formats" {
    run extract_date_from_filename "report_230506.pdf"
    [ "$status" -eq 0 ]
    [ "$output" = "20230506" ]
}

@test "extract_date_from_filename does not extract ambiguous date formats" {
    run extract_date_from_filename "report_06.05.2023.pdf"
    [ "$status" -eq 0 ]
    [ "$output" = "" ]
}

@test "extract_date_from_filename handles mixed case" {
    run extract_date_from_filename "Report_20230506.pdf"
    [ "$status" -eq 0 ]
    [ "$output" = "20230506" ]
}

@test "extract_date_from_filename handles dates with additional text" {
    run extract_date_from_filename "report_20230506_final.pdf"
    [ "$status" -eq 0 ]
    [ "$output" = "20230506" ]
}

@test "extract_date_from_filename handles dates with versioning" {
    run extract_date_from_filename "report_20230506-v2.pdf"
    [ "$status" -eq 0 ]
    [ "$output" = "20230506" ]
}

@test "extract_date_from_filename handles dates with whitespace" {
    run extract_date_from_filename "report_2023 05 06.pdf"
    [ "$status" -eq 0 ]
    [ "$output" = "20230506" ]
}

@test "extract_date_from_filename handles dates with localisation" {
    run extract_date_from_filename "report_06.05.2023.pdf"
    [ "$status" -eq 0 ]
    [ "$output" = "" ]
}

@test "extract_date_from_filename handles dates with hidden characters" {
    run extract_date_from_filename "report_20230506.pdf"
    [ "$status" -eq 0 ]
    [ "$output" = "20230506" ]
}

@test "extract_date_from_filename handles dates with substrings" {
    run extract_date_from_filename "report_about_20230506.pdf"
    [ "$status" -eq 0 ]
    [ "$output" = "20230506" ]
} 