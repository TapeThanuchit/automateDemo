*** Settings ***
Resource    resourceAPI/methodAPI.resource
Test Setup    Create Session    alias=${alias_demo}    url=${url}
Test Teardown    Delete All Sessions

*** Test Cases ***
Test01
    [Documentation]    Verify_Autorization_Response have True_Success
    [Tags]    Autorization
    &{body}    Create Dictionary    userName=${testData.userName}    password=${testData.password}
    ${response}    POST On Session    ${alias_demo}    url=${authorized}    json=${body}
    Should Be Equal    ${True}    ${response.json()}

Test02
    [Documentation]    Verify_Autorization_Response expect status 404 incase data is wrong_Success
    [Tags]    Autorization
    &{body}    Create Dictionary    userName=${testData.userName}    password=${testData.password}11
    ${response}    POST On Session    ${alias_demo}    url=${authorized}    json=${body}    expected_status=404
    Status Should Be    404    ${response}

Test03
    [Documentation]    Verify_Autorization_Response expect status 400 incase body request wrong _Success
    [Tags]    Autorization
    &{body}    Create Dictionary    userName=${testData.userName}    passwor=${testData.password}
    ${response}    POST On Session    ${alias_demo}    url=${authorized}    json=${body}    expected_status=400
    Status Should Be    400    ${response}

Test04
    [Documentation]    Verify_GenarateToken_incase Autorization is True_Success
    [Tags]    GenarateToken
    &{body}    Create Dictionary    userName=Tape1    password=!qaz2Wsx
    Call API Check Autorization Expect    ${body}    200
    Call API GenarateToken Expect    ${body}    200
    
Test05
    [Documentation]    Verify_User_Sign up User Success_Success
    [Tags]    User
    &{body}    Create Dictionary    userName=Tape1    password=!qaz2Wsx
    Call API Post User: Sign up    ${body}    201

Test06
    [Documentation]    Verify_User_Sign up User Success_Success
    [Tags]    User
    &{body}    Create Dictionary    userName=Tape2    password=!qaz2Wsx
    ${token}    Call API GenarateToken Expect    ${body}    200
    ${uuid}    Set Variable    ${user}/c9f8fb89-5085-42dd-83e6-03b3864a5a6c
    Call API User: Delete    ${uuid}    204    ${token}

