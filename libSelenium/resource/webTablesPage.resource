*** Settings ***
Library    SeleniumLibrary
Library    String
Resource    locator.resource

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
    Log    ${dataCount}
    #row = (//div[@class="rt-tr-group"])
    #Firstname columm = (//div[@class="rt-tr-group"])[1]//div[@class="rt-td"][1]