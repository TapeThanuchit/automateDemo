*** Settings ***
Library    JSONLibrary
Library    JsonValidator
Library    OperatingSystem
Library    RPA.Tables
Library    Collections
Library    String

*** Variables ***
${pathUserJsonData}    ../../TestData/user.json
${path}    ${CURDIR}/${pathUserJsonData}

*** Keywords ***
Get Elements and access to data
    [Arguments]    ${json_source}    ${expr}
    ${data}    Get Elements    ${json_source}    ${expr}
    ${data}    Set Variable    ${data}[0]
    [Return]    ${data}

Save Response User To File Json
    [Arguments]    ${uuid}    ${usernameData}
    Create File    ${path}    {}
    ${json}    Load Json From File    ${path}
    ${userID}    Create Dictionary   userID=${uuid}
    ${username}    Create Dictionary   username=${usernameData}
    ${json}    Add Object To Json    ${json}    $    ${userID}
    ${json}    Add Object To Json    ${json}    $    ${username}
    ${json}    Convert Json To String    ${json}
    Create File    ${path}    ${json}

Read Data From User Signup
    ${json}    Load Json From File    ${path}
    ${uuid}    Get Elements and access to data    ${json}    $.userID
    [Return]    ${uuid}

Delete Data in Json When Delete User
    ${json}    Load Json From File    ${path}
    ${json}    Delete Object From Json    ${json}    $.*
    ${jsonStr}    Convert Json To String    ${json}
    Create File    ${path}    ${jsonStr}

Create JSON File with Multi Data
    [Documentation]    Create a JSON file with expected structure and add user data.
    ${path}    Set Variable    ${CURDIR}/../TestData/test.json
    # Define the initial empty JSON structure
    
    Create File    ${path}    {"data":[]}

    ${json}    Load Json From File    ${path}
    # Define user dictionaries
    ${user1}    Create Dictionary    user=test1
    ${user2}    Create Dictionary    user=test2

    # Add user objects to JSON data array
    ${json}    Add Object To Json    ${json}    $.data    ${user1}
    ${json}    Add Object To Json    ${json}    $.data    ${user2}

    # Convert JSON to string and write to file
    ${json_string}    Convert Json To String    ${json}
    Create File    ${path}    ${json_string}

    ${json}    Load Json From File    ${path}
    ${respone}    Get Elements    ${json}    $.data[0]..user
    Log To Console    message:${respone}

    ###
    ${json}    Delete Object From Json    ${json}   $.data[0]
    
    ${respone}    Get Elements    ${json}    $.data[0]..user
    Log To Console    messageAfter Delete:${respone}
