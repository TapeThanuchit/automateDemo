*** Settings ***
Library    mylib/ExcelKeywords.py

*** Variables ***
${TEST_FILE}    ${CURDIR}/testdata/testbook.xlsx
${collectionfile}    ${CURDIR}/testdata/bookcollection.xlsx

*** Test Cases ***
Create And Write New Excel File
    Create Workbook    ${TEST_FILE}    sheet_name=Data
    Set Cell Value    A1    Name
    Set Cell Value    B1    Age
    ${row1}=    Create List    Ben    30
    ${row2}=    Create List    Bob      25
    ${rows}=    Create List    ${row1}    ${row2}
    Append Rows To Worksheet    ${rows}
    Save Workbook
    Close Workbook

Open And Read Excel File
    Open Workbook    ${TEST_FILE}
    ${sheets}=    List Worksheets
    Log    Worksheets: ${sheets}

    ${value}=    Get Cell Value    A1
    Should Be Equal    ${value}    Name

    ${data}=    Read Worksheet    header=${TRUE}
    Log    ${data}
    Length Should Be    ${data}    2

    Close Workbook

Create Worksheet And Set Styles
    Create Workbook    ${TEST_FILE}
    Create Worksheet    Report
    Set Active Worksheet    Report
    Set Cell Value    A1    Hello
    Set Styles    A1:B1    sheet_name=Report    bold=${TRUE}    bg_color=FFFF00    horizontal_alignment=center
    Save Workbook
    Close Workbook

Remove Worksheet Example
    Open Workbook    ${TEST_FILE}
    Create Worksheet    TempSheet    exist_ok=${TRUE}
    Remove Worksheet    TempSheet
    ${sheets}=    List Worksheets
    Log    Worksheets \: ${sheets}
    Save Workbook
    Close Workbook

Read Xlsm File Example
    # ตัวอย่างการเปิดไฟล์ macro-enabled (.xlsm) — จะ detect และเก็บ macro ให้อัตโนมัติ
    [Tags]    manual
    Open Workbook    ${CURDIR}/sample_with_macro.xlsm
    ${data}=    Read Worksheet
    Log    ${data}
    Close Workbook
