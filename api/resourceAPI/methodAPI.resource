*** Settings ***
Library    RequestsLibrary
Library    JSONLibrary
Library    JsonValidator
Library    OperatingSystem
Variables    ../../config/envDemo.yml

*** Variables ***
${alias_demo}    host
${pathUserJsonData}    ../../TestData//user.json

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



###### Keyword Other #######
Get Elements and access to data
    [Arguments]    ${json_source}    ${expr}
    ${data}    Get Elements    ${json_source}    ${expr}
    ${data}    Set Variable    ${data}[0]
    [Return]    ${data}

Save Response User To File Json
    [Arguments]    ${uuid}    ${usernameData}
    ${path}    Set Variable    ${CURDIR}/${pathUserJsonData}
    Create File    ${path}    {}
    ${json}    Load Json From File    ${path}
    ${userID}    Create Dictionary   userID=${uuid}
    ${username}    Create Dictionary   username=${usernameData}
    ${json}    Add Object To Json    ${json}    $    ${userID}
    ${json}    Add Object To Json    ${json}    $    ${username}
    ${json}    Convert Json To String    ${json}
    Create File    ${path}    ${json}

Read Data From User Signup
    ${path}    Set Variable    ${CURDIR}/${pathUserJsonData}
    ${json}    Load Json From File    ${path}
    ${uuid}    Get Elements and access to data    ${json}    $.userID
    [Return]    ${uuid}
