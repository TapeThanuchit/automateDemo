*** Settings ***
Resource    ../resource/common.robot


*** Keywords ***
Common sign up
    Open Workbook    ${CURDIR}/../TestData/signup.xlsx
    Set Active Worksheet    Sheet1
    @{templateData}    Read Worksheet    header=${True}
    FOR    ${rowsExcel}    IN    @{templateData}
        ${tag}    Convert To Lower Case    ${rowsExcel}[run]
        ${cases}    Set Variable    ${rowsExcel}[testcase]
        Continue For Loop If    '${tag}' != 'y'
        Run Keyword And Continue On Failure    ${cases}
    END

TC_Signup_API_01
    #process.Run Process    node    token.js    cwd=${CURDIR}/../script
    #Call API Genarate Token
    #Get token to variable
    Log    TC_Getbook_API_01

TC_Signup_API_02
    Log    TC_Getbook_API_02

TC_Signup_API_03
    Log    TC_Getbook_API_03

TC_Signup_API_04
    Log    TC_Getbook_API_04