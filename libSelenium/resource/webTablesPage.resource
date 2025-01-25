*** Keywords ***
Count Data in WebTables
    ${index}    Get Element Count    ${rowsDataFirstName}
    ${dataCount}    Set Variable    0
    FOR    ${counter}    IN RANGE    1    ${index}
        ${data}    Get Text    xpath=(//div[@class="rt-tr-group"]//div//div[@class="rt-td"])[${counter}]
        IF    "${data}" != "${None}" or "${data}" != "${EMPTY}"
            ${dataCount}    Evaluate    ${dataCount}+1
        END
    END
    Log    ${dataCount}