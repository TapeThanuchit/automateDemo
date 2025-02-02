*** Settings ***
Library     JSONLibrary
Library     JsonValidator
Library     OperatingSystem
Library     RPA.Tables
Library     Collections
Library     String
Library     RPA.Excel.Files


*** Variables ***
${pathUserJson}         ${CURDIR}/../../TestData/user.json
${pathUsersJson}        ${CURDIR}/../../TestData/users.json
${pathUUIDsJson}        ${CURDIR}/../../TestData/uuids.json
${pathCSV}              ${CURDIR}/../../TestData/userData.csv
${columnCharactor}      A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z


*** Keywords ***
Get Elements and access to data
    [Arguments]    ${json_source}    ${expr}
    ${data}    Get Elements    ${json_source}    ${expr}
    ${data}    Set Variable    ${data}[0]
    RETURN    ${data}

Save Response User To File Json
    [Arguments]    ${uuid}    ${usernameData}
    Create File    ${pathUserJson}    {}
    ${json}    Load Json From File    ${pathUserJson}
    ${userID}    Create Dictionary    userID=${uuid}
    ${username}    Create Dictionary    username=${usernameData}
    ${json}    Add Object To Json    ${json}    $    ${userID}
    ${json}    Add Object To Json    ${json}    $    ${username}
    ${json}    Convert Json To String    ${json}
    Create File    ${pathUserJson}    ${json}

Save Response Muti Users To File Json
    [Arguments]    ${uuid}    ${usernameData}    ${json}
    ${uuidData}    Create Dictionary    userID=${uuid}    username=${usernameData}
    ${jsonRecord}    Add Object To Json    ${json}    $.data    ${uuidData}
    RETURN    ${jsonRecord}

Create JSON File To Save Response
    [Arguments]    ${path}    ${json}
    ${json}    Convert Json To String    ${json}
    Create File    ${path}    ${json}

Read Data From User Signup
    ${json}    Load Json From File    ${pathUserJson}
    ${uuid}    Get Elements and access to data    ${json}    $.userID
    RETURN    ${uuid}

Read Data From Users Signup
    [Arguments]    ${path}    ${exprIndex}
    ${json}    Load Json From File    ${path}
    ${uuid}    Get Elements and access to data    ${json}    ${exprIndex}
    RETURN    ${uuid}

Delete Data in Json When Delete User
    ${json}    Load Json From File    ${pathUserJson}
    ${json}    Delete Object From Json    ${json}    $.*
    ${jsonStr}    Convert Json To String    ${json}
    Create File    ${pathUserJson}    ${jsonStr}

Create JSON File With Read Data From CSV
    @{rowsData}    Read table from CSV    ${pathCSV}    encoding=UTF-8
    Create File    ${pathUsersJson}    {"data":[]}
    ${json}    Load Json From File    ${pathUsersJson}
    &{user}    Create Dictionary
    FOR    ${data}    IN    @{rowsData}
        ${userId}    Set Variable    ${data}[userId]
        ${password}    Set Variable    ${data}[password]
        Set To Dictionary    ${user}    userId=${userId}    password=${password}
        ${json}    Add Object To Json    ${json}    $.data    ${user}
    END
    ${json}    Convert JSON to String    ${json}
    Create File    ${pathUsersJson}    ${json}

Load User Data
    ${json}    Load Json From File    ${pathUsersJson}
    ${userId}    Get Elements    ${json}    $.data[*]..userId
    ${password}    Get Elements    ${json}    $.data[*]..password
    RETURN    ${userId}    ${password}

Log Response To Excel
    [Arguments]    ${response}
    ${statusCode}    Set Variable    ${response.status_code}
    IF    '${statusCode}' == '201'
        ${listTitle}    Create Test Result API Sign up    signIn
        @{response_data_all}    Create List
        ${userId}    Get Elements and access to data    ${response.json()}    $.userId
        ${username}    Get Elements and access to data    ${response.json()}    $.username
        ${books}    Get Elements and access to data    ${response.json()}    $.books
        ${inbook}    Get Length    ${books}
        Append To List    ${response_data_all}    ${userId}    ${username}    ${books}
        IF    '${inbook}' != '0'
            ${isbn}    Get Elements and access to data    ${response.json()}    $.books..isbn
            Append To List    ${response_data_all}    ${isbn}
        END
        Write Test Result    ${listTitle}    ${response_data_all}
    ELSE
        ${code}    Get Elements and access to data    ${response.json()}    $.code
        ${message}    Get Elements and access to data    ${response.json()}    $.message
    END

Create Test Result API Sign up
    [Arguments]    ${sheetname}
    Run Keyword And Ignore Error    Create Worksheet    ${sheetname}
    Set Active Worksheet    ${sheetname}
    @{column}    Split String    ${columnCharactor}    ,
    ${titleResult}    Set Variable
    ...    Testcases,TestScenario,API_Name,StatusCode,ResponseAll,UserId,Username,Books,isbn,title,subTitle,author,publish_date,publisher,pages,description,website
    @{listTitle}    Split String    ${titleResult}    ,
    ${index}    Set Variable    0
    FOR    ${headerData}    IN    @{listTitle}
        Set Cell Value    1    ${column}[${index}]    ${headerData}
        ${index}    Evaluate    ${index}+1
    END
    RETURN    @{listTitle}

Write Test Result
    [Arguments]    ${listTitle}    ${response_data_all}
    @{column}    Split String    ${columnCharactor}    ,
    ${index}    Set Variable    0
    FOR    ${element}    IN    @{listTitle}
        ${rows}    Find empty row
        ${result}    Set Variable    ${response_data_all}[${index}]
        ${column_Index}    Set Variable    ${column}[${index}]
        Set Cell Value    ${rows}    ${column_Index}    ${response_data_all}[${index}]
    END
    Save Workbook

Compare Expect Code
    [Arguments]    ${expect_code}    ${response_code}
    Log Many    ${expect_code}    ${response_code}
    IF    '${expect_code}' == '${response_code}'
        ${result}    Set Variable    PASSED
    ELSE IF    '${expect_code}' == '${None}' or '${expect_code}' == '${EMPTY}'
        ${result}    Set Variable    Have Not Expect
    ELSE
        ${result}    Set Variable    FAILED
    END
    RETURN    ${result}

Set Color Message
    [Arguments]    ${result}    ${column_Index}    ${rows}
    Log    ${column_Index}${rows}
    IF    '${result}' == 'PASSED'
        Set Styles    ${column_Index}${rows}    color=006700
    ELSE
        Set Styles    ${column_Index}${rows}    color=FF0000
    END


Log Result To Excel
    [Arguments]    ${testcase}    ${testscenario}    ${method}    ${apipath}    ${expecCode}    ${actualCode}
    Open Workbook    ${CURDIR}/../../TestResult/ReportTestDemo.xlsx
    Set Active Worksheet    Report
    @{rowsData}    Read Worksheet
    ${rows}    Find Empty Row
    Set Cell Value    ${rows}    A    ${testcase}
    Set Cell Value    ${rows}    B    ${testscenario}
    Set Cell Value    ${rows}    C    ${method}
    Set Cell Value    ${rows}    D    ${apipath}
    Set Cell Value    ${rows}    E    ${expecCode}
    Set Cell Value    ${rows}    F    ${actualCode}
    ${result}    Compare Expect Code    ${expecCode}    ${actualCode}
    Set Color Message    ${result}    G    ${rows}
    Set Cell Value    ${rows}    G    ${result}
    Save Workbook