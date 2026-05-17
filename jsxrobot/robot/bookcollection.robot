*** Settings ***
Resource    ../config/lib.resource
Resource    ../config/var.resource
Resource    ../resource/common.robot

*** Keywords ***
Common book collection
    Open Workbook    ${CURDIR}/../TestData/bookcollection.xlsx
    Set Active Worksheet    Sheet1
    @{templateData}    Read Worksheet    header=${True}
    FOR    ${rowsExcel}    IN    @{templateData}
        ${tag}    Convert To Lower Case    ${rowsExcel}[run]
        ${cases}    Set Variable    ${rowsExcel}[testcases]
        ${user}    Set Variable    ${rowsExcel}[user]
        ${pass}    Set Variable    ${rowsExcel}[pass]
        ${scenario}    Set Variable    ${rowsExcel}[testscenario]
        ${param}    Set Variable    ${rowsExcel}[book]
        Continue For Loop If    '${tag}' != 'y'
        Run Keyword And Continue On Failure    ${cases}    ${user}    ${pass}    ${scenario}    ${param}
    END

TC_Bookcollections_API_01
    [Arguments]    ${user}    ${pass}    ${scenario}    ${param}
    [Documentation]    ${scenario}
    common.Genarate Token    ${user}    ${pass}
    ${token}    common.Get token to variable
    ${userId}    common.Get userId to variable
    @{isbn_all}    Load book all
    ${isbn}    Set Variable    ${isbn_all}[0]
    &{isbn_dict}    Create Dictionary    isbn=${isbn}
    @{isbn_list}    Create List    ${isbn_dict}
    ${headers}    Create Dictionary    Authorization=Bearer ${token}
    &{body}    Create Dictionary    userId=${userId}
    ...    collectionOfIsbns=${isbn_list}
    ${response}    POST On Session    alias=${demo_alias}    url=${books}    json=${body}    headers=${headers}    expected_status=anything
    Run Keyword And Continue On Failure    OperatingSystem.Remove File    ${CURDIR}/../result/token.json

TC_Bookcollections_API_02
    [Arguments]    ${user}    ${pass}    ${scenario}    ${param}
    [Documentation]    ${scenario}
    common.Genarate Token    ${user}    ${pass}
    ${token}    common.Get token to variable
    ${userId}    common.Get userId to variable
    @{isbn_all}    Load book all
    ${isbn}    Set Variable    ${isbn_all}[0]
    ${headers}    Create Dictionary    Authorization=Bearer ${token}
    &{body}    Create Dictionary    userId=${userId}
    ...    isbn=${isbn}
    ${response}    DELETE On Session    alias=${demo_alias}    url=${book}    json=${body}    headers=${headers}    expected_status=anything
    Run Keyword And Continue On Failure    OperatingSystem.Remove File    ${CURDIR}/../result/token.json

TC_Bookcollections_API_03
    Log    message
TC_Bookcollections_API_04
    Log    message
TC_Bookcollections_API_05
    Log    message