*** Settings ***
Library     SeleniumLibrary
Resource    locator.resource


*** Keywords ***
Options Selenium
    ${options}    Evaluate    sys.modules['selenium.webdriver'].ChromeOptions()    sys
    Call Method    ${options}    add_argument    --disable-notifications
    Call Method    ${options}    add_argument    --disable-infobars
    Call Method    ${options}    add_argument    --disable-extensions
    Call Method    ${options}    add_argument    --no-sandbox
    Call Method    ${options}    add_argument    --headless
    Call Method    ${options}    add_argument    --disable-dev-shm-usage
    RETURN    ${options}

Open Test Browser with headless
    [Arguments]    ${url}
    ${options}    Options Selenium
    Open Browser    ${url}    browser=chrome    options=${options}
    Wait Until Element Is Visible    ${elementsCard}

Select menu textbox
    Click Element    ${textBoxMenu}

Select menu buttons
    Click Element    ${buttonsMenu}

Input fullname in menu textbox
    [Arguments]    ${fullnameData}
    Input Text    ${textBox.fullnameInput}    ${fullnameData}

Input Email in menu textbox
    [Arguments]    ${emailData}
    Input Text    ${textBox.emailInput}    ${emailData}

Input Current Address in menu text Box
    [Arguments]    ${currentAddress}
    Input Text    ${textBox.currentAddress}    ${currentAddress}

Input Permanent Address in menu text Box
    [Arguments]    ${permanentAddress}
    Input Text    ${textBox.permanentAddress}    ${permanentAddress}

Select Submit
    Scroll Element Into View    ${submitButton}
    Click Element    ${submitButton}

Double Click Buttons
    Double Click Element    ${doubleClilckButton}

Right Click Buttons
    # Open Context Menu == Right Click
    Open Context Menu    ${rightClickButton}

Verify Double Click Buttons
    [Arguments]    ${expect}
    ${text}    Get Text    ${doubleClilckMessage}
    Should Be Equal    ${expect}    ${text}

Verify Right Click Butons
    [Arguments]    ${expect}
    ${text}    Get Text    ${rightClickMessage}
    Should Be Equal    ${expect}    ${text}

Verify Default Click Butons
    [Arguments]    ${expect}
    ${text}    Get Text    ${defaultClickMessage}
    Should Be Equal    ${expect}    ${text}

Expand All Checkbox
    Click Element    ${expandButton}

Collapse All Checkbox
    Click Element    ${expandButton}

Count Checkbox
    ${valueCheckbox}    Get Element Count    ${checkboxElements}
    RETURN    ${valueCheckbox}

Select all checkbox
    ${checkboxCount}    Count Checkbox
    IF    ${checkboxCount} == 1
        Click Element    xpath=(//span[@class="rct-checkbox"])[1]
    ELSE
        FOR    ${counter}    IN RANGE    1    ${checkboxCount}
            ${locator}    Set Variable    xpath=(//span[@class="rct-checkbox"])[${counter}]
            Scroll Element Into View    ${locator}
            Click Element    ${locator}
        END
    END

Select Radio Buttons
    [Arguments]    ${radioChooseSelect}
    IF    "${radioChooseSelect}" == "Yes"
        Click Element    ${yesRadioButton}
    ELSE IF    "${radioChooseSelect}" == "Impressive"
        Click Element    ${impressiveRadioButon}
    END
    [Return]    ${radioChooseSelect}

Expect Message after Select Radio Buttons
    [Arguments]    ${radioChooseSelect}    ${expectMessage}
    IF    "${radioChooseSelect}" == "Yes"
        Should Be Equal    You have selected Yes    ${expectMessage}
    ELSE IF    "${radioChooseSelect}" == "Impressive"
        Should Be Equal    You have selected Impressive    ${expectMessage}
    END

Verify CheckBox Before Expand or After collapse
    [Arguments]    ${expect}
    ${count}    Get Element Count    ${checkboxElements}
    Should Be True    ${count}==${expect}

Verify CheckBox After Expand
    [Arguments]    ${expect}
    ${count}    Get Element Count    ${checkboxElements}
    Should Be True    ${count}>${expect}

Select Add Data in WebTables
    Click Element    ${addNewRecordButton}

Input first name in web Tables
    [Arguments]    ${firstname}
    Input Text    ${firstnameInput}    ${firstname}

Input Last name in web Tables
    [Arguments]    ${lastname}
    Input Text    ${lastnameInput}    ${lastname}

Input Age in web Tables
    [Arguments]    ${age}
    Input Text    ${ageInput}    ${age}

Input Email in web Tables
    [Arguments]    ${email}
    Input Text    ${emailIput}    ${email}

Input Salary in web Tables
    [Arguments]    ${salary}
    Input Text    ${salaryInput}    ${salary}

Input Department in web tables
    [Arguments]    ${department}
    Input Text    ${departmentInput}    ${department}

Select Row Edit Data is
    [Arguments]    ${index}
    Click Element    id=edit-record-${index}

Select Row Delete Data is
    [Arguments]    ${index}
    Click Element    id=delete-record-${index}

Select menu Radio Button
    Click Element    ${radioButtonsMenu}

Select menu WebTables
    Click Element    ${webTablesMenu}

Select menu checkbox
    Click Element    ${checkboxMenu}