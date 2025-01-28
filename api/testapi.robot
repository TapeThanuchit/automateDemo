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
    &{body}    Create Dictionary    userName=${testData.username}    password=${testData.password}
    Call API Check Autorization Expect    ${body}    200
    Call API GenarateToken Expect    ${body}    200
    
Test05
    [Documentation]    Verify_User_Sign up User_Success
    [Tags]    User
    [Setup]    Skip
    &{body}    Create Dictionary    userName=${testData.userName2}    password=${testData.password2}
    ${userId}    ${username}    Call API Post User: Sign up    ${body}    201

Test06
    [Documentation]    Verify_User_Delete User Incase have uuid form sing up_Success
    [Tags]    User
    [Setup]    Skip
    &{body}    Create Dictionary    userName=${testData.userName2}    password=${testData.password2}
    ${token}    Call API GenarateToken Expect    ${body}    200
    ${uuid}    Set Variable    9646db14-80ca-4ad4-99eb-3cf443e8a84a
    Call API Delete User    ${uuid}    204    ${token}

Test07
    [Documentation]    Verify_User_Get User Incase have uuid form sing up_Success
    [Tags]    User
    [Setup]    Skip
    &{body}    Create Dictionary    userName=${testData.userName2}    password=${testData.password2}
    ${token}    Call API GenarateToken Expect    ${body}    200
    ${uuid}    Set Variable    9646db14-80ca-4ad4-99eb-3cf443e8a84a
    Call API Get User   ${uuid}    200    ${token}

Test08
    [Documentation]    Verify_User_Sign up User And Write Response To file json in Test Data_Success
    [Tags]    User
    &{body}    Create Dictionary    userName=${testData.userName2}    password=${testData.password2}
    ${userId}    ${username}    Call API Post User: Sign up    ${body}    201
    Save Response User To File Json    ${userId}    ${username}

Test09
    [Documentation]    Verify_User_Get User Incase Read Response UUID From Testdata_Success
    [Tags]    User
    &{body}    Create Dictionary    userName=${testData.userName2}    password=${testData.password2}
    ${token}    Call API GenarateToken Expect    ${body}    200
    ${uuid}    Read Data From User Signup
    Call API Get User   ${uuid}    200    ${token}







