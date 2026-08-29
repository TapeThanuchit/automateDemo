*** Settings ***
Library    mylib/ExcelKeywords_new.py
Library    Collections

*** Variables ***
${TEST_FILE}    ${CURDIR}/testdata/testbook.xlsx
${Example_FILE}    ${CURDIR}/testdata/bookcollection.xlsx

*** Test Cases ***
Test my example
    Open Workbook    ${Example_FILE}
    Set Active Worksheet    Sheet1
    @{rowsData}    Read Worksheet
    Log    ${rowsData}
    ${rows}    Find Empty Row
    Set Cell Value    ${rows}    B    TC_Bookcollections_API_06
    Set Styles    B${rows}    color=006700
    FOR    ${element}    IN    @{rowsData}
        Log    ${element}[A]
        Continue For Loop If    "${element}[A]" == "run"
        
    END
    Save Workbook

Test my example2
    Open Workbook    ${Example_FILE}
    Create Worksheet    new
    Save Workbook

Test my example3
    Open Workbook    ${Example_FILE}
    Remove Worksheet    new
    Save Workbook


Create And Write New Excel File
    Create Workbook    ${TEST_FILE}    sheet_name=Data
    Set Cell Value    row=1    column=A    value=Name
    Set Cell Value    row=1    column=C    value=Age
    ${rows}=    Evaluate    [["Alice", 30], ["Bob", 25]]
    Append Rows To Worksheet    ${rows}
    Save Workbook
    Close Workbook

Open And Read Excel File
    Open Workbook    ${TEST_FILE}
    ${sheets}=    List Worksheets
    Log    Worksheets: ${sheets}

    ${value}=    Get Cell Value    row=1    column=1
    Should Be Equal    ${value}    Name

    ${value2}=    Get Cell Value    row=1    column=A
    Should Be Equal    ${value2}    Name

    ${data}=    Read Worksheet    header=${TRUE}
    Log    ${data}
    Length Should Be    ${data}    2

    Close Workbook

Create Worksheet And Set Styles
    Create Workbook    ${TEST_FILE}
    ${content}=    Evaluate    [["Name", "Age"], ["Alice", 30], ["Bob", 25]]
    Create Worksheet    Report    content=${content}    exist_ok=${TRUE}
    Set Styles    A1:B1    sheet_name=Report    bold=${TRUE}    cell_fill=lightyellow    align_horizontal=center
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

Structure And Misc Keywords
    Create Workbook    ${TEST_FILE}    sheet_name=Data
    ${rows}=    Evaluate    [["Name", "Age"], ["Alice", 30], ["Bob", 25], ["Carol", 40]]
    Append Rows To Worksheet    ${rows}

    # Worksheet Exists / Get Active Worksheet
    ${exists}=    Worksheet Exists    Data
    Should Be True    ${exists}
    ${active}=    Get Active Worksheet
    Should Be Equal    ${active}    Data

    # Rename Worksheet
    Rename Worksheet    MainData    name=Data
    ${sheets}=    List Worksheets
    List Should Contain Value    ${sheets}    MainData

    # Insert / Delete Rows
    Insert Rows Before    row=2
    ${value}=    Get Cell Value    row=2    column=1
    Should Be Equal    ${value}    ${NONE}
    Delete Rows    row=2

    # Insert / Delete Columns (รองรับตัวอักษรคอลัมน์)
    Insert Columns Before    column=B
    Delete Columns    column=B

    # Clear Cell Range
    Set Cell Value    row=5    column=1    value=Temp
    Clear Cell Range    A5
    ${cleared}=    Get Cell Value    row=5    column=1
    Should Be Equal    ${cleared}    ${NONE}

    # Copy Cell Values
    Copy Cell Values    A1:B4    target_cell=D1
    ${copied}=    Get Cell Value    row=1    column=D
    Should Be Equal    ${copied}    Name

    # Find Empty Row
    ${empty_row}=    Find Empty Row
    Should Be True    ${empty_row} > 0

    Save Workbook
    Close Workbook

Read Xlsm File Example
    # ตัวอย่างการเปิดไฟล์ macro-enabled (.xlsm) — จะ detect และเก็บ macro ให้อัตโนมัติ
    [Tags]    manual
    Open Workbook    ${CURDIR}/sample_with_macro.xlsm
    ${data}=    Read Worksheet
    Log    ${data}
    Close Workbook
