*** Settings ***
Resource            resourceAPI/methodAPI.resource

Test Setup          Create Session    alias=${alias_demo}    url=${url}
Test Teardown       Delete All Sessions


*** Test Cases ***
Test01
    [Documentation]    Verify_Autorization_Response have True_Success
    [Tags]    autorization
    ${testcase}    Set Variable    Test01
    ${testscenario}    Set Variable    Verify_Autorization_Response have True_Success
    ${expectCode}    Set Variable    200
    &{body}    Create Dictionary    userName=${testData.userName}    password=${testData.password}
    ${response}    POST On Session    ${alias_demo}    url=${authorized}    json=${body}
    Should Be Equal    ${True}    ${response.json()}
    Log Result To Excel    ${testcase}    ${testscenario}    POST    ${authorized}    ${expectCode}    ${response.status_code}

Test02
    [Documentation]    Verify_Autorization_Response expect status 404 incase data is wrong_Success
    [Tags]    autorization
    ${testcase}    Set Variable    Test02
    ${testscenario}    Set Variable    Verify_Autorization_Response expect status 404 incase data is wrong_Success
    ${expectCode}    Set Variable    400
    &{body}    Create Dictionary    userName=${testData.userName}    password=${testData.password}11
    ${response}    POST On Session    ${alias_demo}    url=${authorized}    json=${body}    expected_status=anything
    Log Result To Excel    ${testcase}    ${testscenario}    POST    ${authorized}    ${expectCode}    ${response.status_code}

Test03
    [Documentation]    Verify_Autorization_Response expect status 400 incase body request wrong _Success
    [Tags]    autorization
    &{body}    Create Dictionary    userName=${testData.userName}    passwor=${testData.password}
    ${response}    POST On Session    ${alias_demo}    url=${authorized}    json=${body}    expected_status=400
    Status Should Be    400    ${response}

Test04
    [Documentation]    Verify_GenarateToken_incase Autorization is True_Success
    [Tags]    genaratetoken
    &{body}    Create Dictionary    userName=${testData.userName}    password=${testData.password}
    Call API Check Autorization Expect    ${body}    200
    Call API GenarateToken Expect    ${body}    200

Test05
    [Documentation]    Verify_User_Sign up User_Success
    [Tags]    user
    [Setup]    Skip
    &{body}    Create Dictionary    userName=${testData.userName2}    password=${testData.password2}
    ${userId}    ${username}    Call API Post User: Sign up    ${body}    201

Test06
    [Documentation]    Verify_User_Delete User Incase have uuid form sing up_Success
    [Tags]    user
    [Setup]    Skip
    &{body}    Create Dictionary    userName=testdd1    password=sHsdq!s23
    ${token}    Call API GenarateToken Expect    ${body}    200
    ${uuid}    Set Variable    789725f4-61db-4b7d-9854-9bf923bd276e
    Call API Delete User    ${uuid}    204    ${token}

Test07
    [Documentation]    Verify_User_Get User Incase have uuid form sing up_Success
    [Tags]    user
    [Setup]    Skip
    &{body}    Create Dictionary    userName=${testData.userName2}    password=${testData.password2}
    ${token}    Call API GenarateToken Expect    ${body}    200
    ${uuid}    Set Variable    9646db14-80ca-4ad4-99eb-3cf443e8a84a
    Call API Get User    ${uuid}    200    ${token}

Test08
    [Documentation]    Verify_User_Sign up User And Write Response To file json in Test Data_Success
    [Tags]    user
    &{body}    Create Dictionary    userName=${testData.userName2}    password=${testData.password2}
    ${userId}    ${username}    Call API Post User: Sign up    ${body}    201
    Save Response User To File Json    ${userId}    ${username}

Test09
    [Documentation]    Verify_User_Get User Incase Read Response UUID From Testdata_Success
    [Tags]    user
    &{body}    Create Dictionary    userName=${testData.userName2}    password=${testData.password2}
    ${token}    Call API GenarateToken Expect    ${body}    200
    ${uuid}    Read Data From User Signup
    Call API Get User    ${uuid}    200    ${token}

Test10
    [Documentation]    Verify_User_Delete User Incase Read Response UUID From Testdata And Delete Object from json_Success
    [Tags]    user
    &{body}    Create Dictionary    userName=${testData.userName2}    password=${testData.password2}
    ${token}    Call API GenarateToken Expect    ${body}    200
    ${uuid}    Read Data From User Signup
    Call API Delete User    ${uuid}    204    ${token}
    Delete Data in Json When Delete User

Test11
    [Documentation]    Verify_User_Sign up Muti User With CSV Data_Success
    [Tags]    user
    Create JSON File With Read Data From CSV
    ${listUserId}    ${listPassword}    Load User Data
    Create File    ${pathUUIDsJson}    {"data":[]}
    ${json}    Load Json From File    ${pathUUIDsJson}
    FOR    ${user}    ${pass}    IN ZIP    ${listUserId}    ${listPassword}
        &{body}    Create Dictionary    userName=${user}    password=${pass}
        ${userId}    ${username}    Call API Post User: Sign up    ${body}    201
        ${json}    Save Response Muti Users To File Json    ${userId}    ${username}    ${json}
        Sleep    5s
    END
    Create JSON File To Save Response    ${pathUUIDsJson}    ${json}

Test12
    [Documentation]    Verify_User_Delete Muti User With CSV Data_Success
    [Tags]    user
    ${json}    Load Json From File    ${pathUUIDsJson}
    ${listUserId}    ${listPassword}    Load User Data
    ${index}    Set Variable    0
    FOR    ${user}    ${pass}    IN ZIP    ${listUserId}    ${listPassword}
        &{body}    Create Dictionary    userName=${user}    password=${pass}
        ${token}    Call API GenarateToken Expect    ${body}    200
        ${uuid}    Read Data From Users Signup    ${pathUUIDsJson}    $.data[${index}]..userID
        Call API Delete User    ${uuid}    204    ${token}
        ${index}    Evaluate    ${index}+1
        Sleep    5s
    END
