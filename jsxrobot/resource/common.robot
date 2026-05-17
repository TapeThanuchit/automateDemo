*** Settings ***
Resource    ../config/lib.resource
Resource    ../config/var.resource


*** Keywords ***
Config set suit
    Load common excel template
    Config session test

Config tear down
    Close Workbook
    Delete All Sessions
    
Load common excel template
    Open Workbook    ${CURDIR}/../TestData/template_demo.xlsx
    Set Active Worksheet    Sheet1
    @{templateData}    Read Worksheet
    Set Suite Variable    @{common_template}    @{templateData}

Config session test
    RequestsLibrary.Create Session    alias=${demo_alias}    url=${host}

Genarate Token
    [Arguments]    ${user}    ${pass}
    Process.Run Process    node    token.js    ${user}    ${pass}    cwd=${CURDIR}/../script
    
Get token to variable
    ${json}    JSONLibrary.Load Json From File    ${CURDIR}/../result/token.json
    ${token}    JSONLibrary.Get Value From Json    ${json}    $.token
    Log    ${token}[0]
    RETURN    ${token}[0]

Get userId to variable
    ${json}    JSONLibrary.Load Json From File    ${CURDIR}/../result/token.json
    ${userId}    JSONLibrary.Get Value From Json    ${json}    $.userId
    Log    ${userId}
    RETURN    ${userId}[0]

Load book all
    ${json}    JSONLibrary.Load Json From File    ${CURDIR}/../TestData/book.json
    ${isbn_list}    RPA.JSON.Get Value From Json    ${json}    $.books
    @{isbn_all}    Create List
    FOR    ${element}    IN    @{isbn_list}
        ${isbn}    RPA.JSON.Get Value From Json    ${element}    $.isbn
        Append To List    ${isbn_all}    ${isbn}
    END
    Log    ${isbn_all}
    RETURN    @{isbn_all}

