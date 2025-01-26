*** Settings ***
Library    RPA.Excel.Files
Library    Collections

*** Variables ***
${testDataPath}    ../TestData/webTablesData.xlsx


*** Keywords ***
Read Excel And Return Test Data
    Open Workbook    ${CURDIR}/${testDataPath}
    Set Active Worksheet    Sheet1
    ${rowsData}    Read Worksheet
    [Return]    ${rowsData}

Get Data form excel And Input
    [Arguments]    ${rowsData}
    FOR    ${element}    IN    @{rowsData}
        &{data}    Convert To Dictionary    ${element}
        Continue For Loop If    "${data}[A]" == "First Name"
        ${firstname}    Set Variable    ${data}[A]
        ${lastname}    Set Variable    ${data}[B]
        ${age}    Set Variable    ${data}[C]
        ${email}    Set Variable    ${data}[D]
        ${department}    Set Variable    ${data}[E]
    END
    