*** Settings ***
Library    SeleniumLibrary
Library    String
Resource    ../../libexcel/excelProcess.resource
Resource    ../../libSelenium/resource/keyword.resource

*** Keywords ***
Count Data in WebTables
    ${index}    Get Element Count    ${rowsData}
    ${dataCount}    Set Variable    0
    FOR    ${counter}    IN RANGE    1    ${index}
        # Get text from colum fist name to check value
        ${data}    Get Text    xpath=(//div[@class="rt-tr-group"])[${counter}]//div[@class="rt-td"][1]
        IF    '${data}' == '${SPACE}'
            No Operation
        ELSE IF    "${data}" != "${None}" or "${data}" != "${EMPTY}"
            ${dataCount}    Evaluate    ${dataCount}+1
        END
    END

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
    

