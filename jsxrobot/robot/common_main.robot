*** Settings ***
Resource    ../resource/common.robot
Resource    getbook.robot
Resource    bookcollection.robot
Suite Setup    Config set suit
Suite Teardown    Config tear down

*** Test Cases ***
Common API
    [Documentation]    Call API Book Store
    FOR    ${rowsExcel}    IN    @{common_template}
        &{data}    Convert To Dictionary    ${rowsExcel}
        ${tag}    Convert To Lower Case    ${data}[A]
        ${feature}    Convert To Lower Case    ${data}[B]
        Continue For Loop If    "${tag}" != "y"
        IF    "${feature}" == "getbook"
            getbook.Common get book
        ELSE IF    "${feature}" == "bookcollection"
            bookcollection.Common book collection
        END
    END



