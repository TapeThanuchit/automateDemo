*** Settings ***
Library     JSONLibrary
Library     JsonValidator
Library     OperatingSystem
Library     RPA.Tables
Library     Collections
Library     String


*** Variables ***
${pathUserJson}     ${CURDIR}/../../TestData/user.json
${pathUsersJson}    ${CURDIR}/../../TestData/users.json
${pathUUIDsJson}    ${CURDIR}/../../TestData/uuids.json
${pathCSV}          ${CURDIR}/../../TestData/userData.csv


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
