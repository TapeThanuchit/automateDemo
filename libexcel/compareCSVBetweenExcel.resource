*** Settings ***
Library     RPA.Excel.Files
Library     RPA.Tables
Library     String
Library     Collections


*** Variables ***
${columnCharactor}      ${EMPTY}
${PATH_TEST_DATA}       ${EMPTY}


*** Keywords ***
Read Title of CSV and Write To Test Result
    [Arguments]    ${csvFileName}    ${testResultFileName}    ${workSheetName}
    ${rowsData}    Read table from CSV    ${csvFileName}    header=False    encoding=UTF-8
    @{columnCharList}    Split String    ${columnCharactor}    ,
    ${columnNumber}    Set Variable    0
    ${title}    Get table row    ${rowsData}    0    as_list=${TRUE}

Count rows on CSV File
    [Arguments]    ${csvFileName}
    ${rows}    Set Variable    0
    @{rowsData}    Read table from CSV    ${csvFileName}    encoding=UTF-8
    ${countRow}    Get length    ${rowsData}
    RETURN    ${countRow}

Compare All Reconcile Excel Between CSV And Write Test Result
    [Arguments]
    ...    ${testResultFileName}
    ...    ${workSheetExportUI}
    ...    ${csvFileName}
    ...    ${worksheetTestResultName}
    ...    ${worksheetTestResultCSVName}
    ...    ${data}
    ${csvFilePathName}    Set Variable    ${CURDIR}/${PATH_TEST_DATA}/${csvFileName}.csv
    ${totalRows}    Count rows on CSV File    ${csvFilePathName}
    ${rowsData}    Read table from CSV    ${csvFilePathName}    header=False    encoding=UTF-8
    ${title}    Get table row    ${rowsData}    0    as_list=${TRUE}
    @{charList}    Split String    ${columnCharactor}    ,
    Read Title of CSV and Write To Test Result
    ...    ${csvFilePathName}
    ...    ${testResultFileName}
    ...    ${worksheetTestResultCSVName}
    Open Workbook    ${testResultFileName}
    # Remove worksheet Customize Reconsile Result    ${data}
    ${titleExportUI}    Read Title Excel WorkSheet ExportUI    ${workSheetExportUI}
    FOR    ${rowNumber}    IN RANGE    0    ${totalRows}
        ${index}    Set Variable    0
        &{excelsheet}    Read Excel Data By Row    ${testResultFileName}    ${workSheetExportUI}    ${rowNumber}
        ${hasData}    Check and Set Nonedata    ${testResultFileName}    ${workSheetExportUI}    ${rowNumber}
        &{csvsheet}    Read CSV Data By Row    ${csvFilePathName}    ${rowNumber}
        FOR    ${column}    IN    @{titleExportUI}
            ${titleExcel}    Set Variable    ${titleExportUI}[${column}]
            ${titleCsv}    Set Variable    ${title}[${index}]
            Log Many    ${titleExcel}    ${titleCsv}
            ${csv}    Set Variable    ${csvsheet}[${titleCsv}]
            IF    '${hasData}' == 'True'
                ${excel}    Set Variable    ${excelsheet}[${titleExcel}]
            ELSE
                ${excel}    Set Variable    NoData
            END
            ${csvData}    ${excelData}    Category Convert Data Have Space Comma Empty    ${csv}    ${excel}
            Compare CSV and Excel Then Write To Test Result
            ...    ${testResultFileName}
            ...    ${worksheetTestResultName}
            ...    ${rowNumber}
            ...    ${Column}
            ...    ${excelData}
            ...    ${csvData}
            Write CSV Data To Test Result
            ...    ${testResultFileName}
            ...    ${worksheetTestResultCSVName}
            ...    ${rowNumber}
            ...    ${Column}
            ...    ${csvsheet}[${titleCsv}]
            ${index}    Evaluate    ${index} +1
        END
    END
    Save Workbook

Read Title Excel WorkSheet ExportUI
    [Arguments]    ${workSheetExportUI}
    Set Active Worksheet    ${workSheetExportUI}
    @{titleExportUI}    Read Worksheet
    Log    ${titleExportUI}[0]
    RETURN    ${titleExportUI}[0]

Read CSV Data By Row
    [Arguments]    ${csvFileName}    ${rownumber}
    @{rowsData}    Read table from CSV    ${csvFileName}    encoding=UTF-8
    Log    ${rowsData}[${rownumber}]
    RETURN    ${rowsData}[${rownumber}]

Compare CSV and Excel Then Write To Test Result
    [Arguments]
    ...    ${testResultFileName}
    ...    ${workSheetName}
    ...    ${rowNumber}
    ...    ${column}
    ...    ${excelSheetData}
    ...    ${csvSheetData}
    IF    '${excelSheetData}' == '${csvSheetData}'
        ${result}    Set Variable    PASSED
    ELSE
        ${result}    Set Variable    ${excelSheetData}!=${csvSheetData}
    END

    ${rowNumber}    Evaluate    ${rowNumber}+2

    Set Active Worksheet    ${workSheetName}
    # A1    strikethrough=True    color=FF0000
    Set Cell Value    ${rowNumber}    ${column}    ${result}    ${workSheetName}
    IF    "${result}" == "PASSED"
        Set Styles    ${column}${rowNumber}    color=006700
    ELSE
        Set Styles    ${column}${rowNumber}    color=FF0000
    END

Convert EMPTY And None Data
    [Arguments]    ${csvData}    ${excelData}
    Log    ${csvData}
    Log    ${excelData}
    IF    '${csvData}' == '${EMPTY}' and '${excelData}' == '-'
        ${csvData}    Set Variable    None
        ${excelData}    Set Variable    None
        Log    ${csvData}
    ELSE IF    '${csvData}' == '${EMPTY}'
        ${csvData}    Set Variable    None
        Log    ${csvData}
        ${excelData}    Convert To String    ${excelData}
    ELSE IF    '${csvData}' == '${SPACE * 20}'
        ${csvData}    Set Variable    None
        Log    ${csvData}
        ${excelData}    Convert To String    ${excelData}
    ELSE IF    '${csvData}' == '${SPACE}'
        ${csvData}    Set Variable    None
        Log    ${csvData}
        ${excelData}    Convert To String    ${excelData}
    ELSE IF    '${csvData}' == '-' and '${excelData}' == '-'
        ${csvData}    Set Variable    None
        ${excelData}    Set Variable    None
        ${excelData}    Convert To String    ${excelData}
    ELSE IF    '${csvData}' == '-'
        ${csvData}    Set Variable    None
        ${excelData}    Convert To String    ${excelData}
    ELSE
        ${csvData}    Convert To String    ${csvData}
        ${excelData}    Convert To String    ${excelData}
        Log    ${csvData}
    END
    RETURN    ${csvData}    ${excelData}

Write CSV Data To Test Result
    [Arguments]    ${testResultFileName}    ${workSheetName}    ${rowNumber}    ${column}    ${csvData}
    ${rowNumber}    Evaluate    ${rowNumber}+2
    Set Active Worksheet    ${workSheetName}
    Set Cell Value    ${rowNumber}    ${column}    ${csvData}    ${workSheetName}

Read Excel Data By Row
    [Arguments]    ${testResultFileName}    ${workSheetName}    ${rownumber}
    Set Active Worksheet    ${workSheetName}
    @{rowsData}    Read Worksheet    header=True
    ${hasData}    run keyword and return status    Log    ${rowsData}[${rownumber}]
    IF    '${hasData}'=='True'
        ${dataFinal}    Set Variable    ${rowsData}[${rownumber}]
    ELSE
        &{dataFinal}    Create Dictionary
        Set To Dictionary    ${dataFinal}    No.    NoData
        Log    ${dataFinal}[No.]
    END
    RETURN    ${dataFinal}

Check and Set Nonedata
    [Arguments]    ${testResultFileName}    ${workSheetName}    ${rownumber}
    Set Active Worksheet    ${workSheetName}
    @{rowsData}    Read Worksheet    header=True
    ${hasData}    run keyword and return status    Log    ${rowsData}[${rownumber}]
    RETURN    ${hasData}

Category Convert Data Have Space Comma Empty
    [Arguments]    ${csv}    ${excel}
    ${checkCommaCsv}    Run Keyword And Return Status    Should Contain    ${csv}    ,
    ${checkCommaExcel}    Run Keyword And Return Status    Should Contain    ${excel}    ,
    ${checkDotZeroCsv}    Run Keyword And Return Status    Should Contain    ${csv}    .00
    ${checkDotZeroExcel}    Run Keyword And Return Status    Should Contain    ${excel}    .00
    IF    '${csv}' == '${EMPTY}' or '${excel}' == '${EMPTY}' or '${csv}' == 'None' or '${excel}' == 'None' or '${csv}' == '0.00' or '${excel}' == '-'
        ${csvData}    ${excelData}    Convert Empty To None and 0.00 To None    ${csv}    ${excel}
    ELSE IF    '${checkCommaCsv}' == '${True}' and '${checkDotZeroCsv}' == '${True}'
        ${csv}    Convert To String    ${csv}
        ${csv}    Remove String    ${csv}    ,
        ${csvData}    Remove String    ${csv}    .00
        ${excel}    Convert To String    ${excel}
        ${excel}    Remove String    ${excel}    ,
        ${excelData}    Remove String    ${excel}    .00
    ELSE IF    '${checkCommaExcel}' == '${True}' and '${checkDotZeroExcel}' == '${True}'
        ${csv}    Convert To String    ${csv}
        ${csv}    Remove String    ${csv}    ,
        ${csvData}    Remove String    ${csv}    .00
        ${excel}    Convert To String    ${excel}
        ${excel}    Remove String    ${excel}    ,
        ${excelData}    Remove String    ${excel}    .00
    ELSE IF    '${checkCommaCsv}' == '${True}' or '${checkCommaExcel}' == '${True}'
        ${csv}    Convert To String    ${csv}
        ${csvData}    Remove String    ${csv}    ,
        ${excel}    Convert To String    ${excel}
        ${excelData}    Remove String    ${excel}    ,
    ELSE IF    '${checkDotZeroCsv}' == '${true}' or '${checkDotZeroExcel}' == '${True}'
        ${csv}    Convert To String    ${csv}
        ${csvData}    Remove String    ${csv}    .00
        ${excel}    Convert To String    ${excel}
        ${excelData}    Remove String    ${excel}    .00
    ELSE IF    '${csv}' == 'TB0003${SPACE}' and '${excel}' == 'TB0003'
        ${csv}    Convert To String    ${csv}
        ${csvData}    Remove String    ${csv}    ${SPACE}
        ${excelData}    Convert To String    ${excel}
    ELSE
        ${csvData}    Convert To String    ${csv}
        ${excelData}    Convert To String    ${excel}
    END
    RETURN    ${csvData}    ${excelData}

Convert Empty To None and 0.00 To None
    [Arguments]    ${csv}    ${excel}
    IF    '${csv}' == '${EMPTY}' and '${excel}' == '-'
        ${csvData}    Set Variable    None
        ${excelData}    Convert To String    None
    ELSE IF    '${csv}' == '${EMPTY}'
        ${csvData}    Set Variable    None
        ${excelData}    Convert To String    ${excel}
    ELSE IF    '${csv}' == '${SPACE * 20}'
        ${csvData}    Set Variable    None
        ${excelData}    Convert To String    ${excel}
    ELSE IF    '${csv}' == '${SPACE}'
        ${csvData}    Set Variable    None
        ${excelData}    Convert To String    ${excel}
    ELSE IF    '${csv}' == '-' and '${excel}' == '-'
        ${csvData}    Set Variable    None
        ${excelData}    Set Variable    None
    ELSE IF    '${csv}' == '-' and '${excel}' == 'None'
        ${csvData}    Set Variable    None
        ${excelData}    Convert To String    ${excel}
    ELSE IF    '${csv}' == '${EMPTY}' and '${excel}' == '-'
        ${csvData}    Set Variable    None
        ${excelData}    Set Variable    None
    ELSE IF    '${csv}' == '0.00' and '${excel}' == 'None'
        ${csvData}    Set Variable    None
        ${excelData}    Convert To String    ${excel}
    ELSE IF    '${csv}' == '0' and '${excel}' == '-'
        ${csvData}    Set Variable    None
        ${excelData}    Set Variable    None
    ELSE IF    '${csv}' == '0.00' and '${excel}' == '0'
        ${csvData}    Set Variable    0
        ${excelData}    Convert To String    ${excel}
    ELSE
        ${csvData}    Convert To String    ${csv}
        ${excelData}    Convert To String    ${excel}
    END
    RETURN    ${csvData}    ${excelData}
#    END
#    Remove Worksheet    ${data}[A]${ReconcileTestResult.SheetName.UIReconcileTestResultCustomizeData}
#    IF    '${pass}' == '${True}'
#    ${pass}    Run Keyword And Return Status    Set Active Worksheet    ${data}[A]${ReconcileTestResult.SheetName.UIReconcileTestResultCustomizeData}
#    [Arguments]    ${data}
# Remove worksheet Customize Reconsile Result

