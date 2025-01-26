*** Settings ***
Resource    ../../libexcel/excelProcess.resource
Resource    ../../libBrowser/resource/keyword.resource
Resource    variable.resource
Library    Browser

*** Keywords ***
Count Data in WebTables
    ${index}    Get Element Count    ${rowsData}
    ${dataCount}    Set Variable    0
    FOR    ${counter}    IN RANGE    1    ${index}
        ${data}    Get Text    xpath=(//div[@class="rt-tr-group"])[${counter}]//div[@class="rt-td"][1]
        IF    "${data}" != "${None}" or "${data}" != "${EMPTY}"
            ${dataCount}    Evaluate    ${dataCount}+1
        END
    END
    Log    ${dataCount}

Add Data In Registration
    ${rowsDataTable}    Read Excel And Return Test Data
    FOR    ${element}    IN    @{rowsDataTable}
        &{data}    Convert To Dictionary    ${element}
        Continue For Loop If    "${data}[A]" == "First Name"
        ${firstname}    Set Variable    ${data}[A]
        ${lastname}    Set Variable    ${data}[B]
        ${age}    Set Variable    ${data}[C]
        ${email}    Set Variable    ${data}[D]
        ${salary}    Set Variable    ${data}[E]
        ${department}    Set Variable    ${data}[F]
        Select Add Data in WebTables
        Input first name in web Tables    ${firstname}
        Input Last name in web Tables    ${lastname}
        Input Age in web Tables    ${age}
        Input Email in web Tables    ${email}
        Input Salary in web Tables    ${salary}
        Input Department in web tables    ${department}
        Select Submit
    END

Select Add Data in WebTables
    Click    ${addNewRecordButton}

Input first name in web Tables
    [Arguments]    ${firstname}
    Fill Text    ${firstnameInput}    ${firstname}

Input Last name in web Tables
    [Arguments]    ${lastname}
    Fill Text    ${lastnameInput}    ${lastname}

Input Age in web Tables
    [Arguments]    ${age}
    Fill Text    ${ageInput}    ${age}

Input Email in web Tables
    [Arguments]    ${email}
    Fill Text    ${emailIput}    ${email}

Input Salary in web Tables
    [Arguments]    ${salary}
    Fill Text    ${salaryInput}    ${salary}
