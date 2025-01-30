*** Settings ***
Resource            resourceAPI/methodAPI.resource

Test Setup          Create Session    alias=${alias_demo}    url=${url}
Test Teardown       Delete All Sessions


*** Test Cases ***
Test All
    [Documentation]    Call API Book Store API E2E
    Open Workbook    ${CURDIR}/../TestData/e2eTemplate.xlsx
    Set Active Worksheet    Template
    @{templateData}    Read Worksheet
    FOR    ${rowsExcel}    IN    @{templateData}
        &{data}    Convert To Dictionary    ${rowsExcel}
        IF    "${data}[A]" == "No" or "${data}[A]" == "${None}"    CONTINUE
        ${apiName}    Set Variable    ${data}[C]
        ${apiName}    Strip String    ${SPACE}${apiName}${SPACE}
        IF    "${apiName}" == "Call Post Sign up user"
            Call Post Sign up user    ${data}
        ELSE IF    "${apiName}" == "Call Post Authorized"
            Log    message
        END
    END
