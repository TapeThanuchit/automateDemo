*** Settings ***
Library    RequestsLibrary
Library    JSONLibrary
Library    JsonValidator
Library    OperatingSystem
Variables    ../../config/envDemo.yml
Resource    allkeyword.resource

*** Variables ***
${alias_demo}    host

*** Keywords ***
Call API Check Autorization Expect
    [Arguments]    ${body}    ${expect}
    ${response}    POST On Session    ${alias_demo}    url=${authorized}    json=${body}    expected_status=${expect}
    Status Should Be    ${expect}    ${response}
    ${response.Autorization}    Set Variable    ${response.json()}
    [Return]    ${response.Autorization}

Call API GenarateToken Expect
    [Arguments]    ${body}    ${expect}    
    ${response}    POST On Session    ${alias_demo}    url=${genarate}    json=${body}    expected_status=${expect}
    Status Should Be    ${expect}    ${response}
    Log    ${response.json()}
    ${token}    Get Elements    ${response.json()}   $.token
    [Return]    ${token}[0]

Call API Post User: Sign up
    [Arguments]    ${body}    ${expect}
    ${response}    POST On Session    ${alias_demo}    url=${user}    json=${body}    expected_status=${expect}
    ${userId}    Get Elements and access to data    ${response.json()}    $.userID
    ${username}    Get Elements and access to data    ${response.json()}    $.username
    [Return]    ${userId}    ${username}

Call API Delete User
    [Arguments]    ${uuid}    ${expect}    ${token}
    ${headers}    Create Dictionary    Authorization=Bearer ${token}
    ${response}    Delete On Session    ${alias_demo}    url=${user}/${uuid}    headers=${headers}    expected_status=${expect}

Call API Get User
    [Arguments]    ${uuid}    ${expect}    ${token}
    ${headers}    Create Dictionary    Authorization=Bearer ${token}
    ${response}    Get On Session    ${alias_demo}    url=${user}/${uuid}    headers=${headers}    expected_status=${expect}

