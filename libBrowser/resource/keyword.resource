*** Settings ***
Library     Browser
Library     String
Resource    variable.resource


*** Keywords ***
Open Test Browser
    [Arguments]    ${url}    ${headlessOption}
    Open Browser    ${url}    browser=chromium    headless=${headlessOption}

New Test Page Browser
    [Arguments]    ${url}
    New Browser    chromium
    New Page    ${url}    wait_until=commit

Enter Menu Elements
    Wait For Elements State    ${elementsCard}    visible
    Click    ${elementsCard}

Select menu textbox
    click    ${textBoxMenu}

Select menu buttons
    click    ${buttonsMenu}

Select menu Checkbox
    click    ${checkboxMenu}

Select menu Radio Button
    click    ${radioButtonsMenu}

Select menu WebTables
    Click    ${webTablesMenu}

Input fullname in menu textbox
    [Arguments]    ${fullnameData}
    Fill Text    ${textBox.fullnameInput}    ${fullnameData}

Input Email in menu textbox
    [Arguments]    ${emailData}
    Fill Text    ${textBox.emailInput}    ${emailData}

Input Current Address in menu text Box
    [Arguments]    ${currentAddress}
    Fill Text    ${textBox.currentAddress}    ${currentAddress}

Input Permanent Address in menu text Box
    [Arguments]    ${permanentAddress}
    Fill Text    ${textBox.permanentAddress}    ${permanentAddress}

Select Submit
    Click    ${submitButton}

Double Click Buttons
    Click With Options    ${doubleClilckButton}    clickCount=2

Right Click Buttons
    Click    ${rightClickButton}    right

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
    Click    ${expandButton}

Collapse All Checkbox
    Click    ${expandButton}

Count Checkbox
    ${valueCheckbox}    Get Element Count    ${checkboxElements}
    RETURN    ${valueCheckbox}

Select all checkbox
    ${checkboxCount}    Count Checkbox
    IF    ${checkboxCount} == 1
        Check Checkbox    xpath=(//span[@class="rct-checkbox"])[1]
    ELSE
        FOR    ${counter}    IN RANGE    1    ${checkboxCount}
            ${locator}    Set Variable    xpath=(//span[@class="rct-checkbox"])[${counter}]
            Scroll To Element    ${locator}
            Check Checkbox    ${locator}
        END
    END

Select Radio Buttons
    [Arguments]    ${radioChooseSelect}
    IF    "${radioChooseSelect}" == "Yes"
        Click    ${yesRadioButton}
    ELSE IF    "${radioChooseSelect}" == "Impressive"
        Click    ${impressiveRadioButon}
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
    Get Element Count    ${checkboxElements}    ==    ${expect}

Verify CheckBox After Expand
    [Arguments]    ${expect}
    Get Element Count    ${checkboxElements}    >    ${expect}

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

Input Department in web tables
    [Arguments]    ${department}
    Fill Text    ${departmentInput}    ${department}

Select Row Edit Data is
    [Arguments]    ${index}
    Click    id=edit-record-${index}

Select Row Delete Data is
    [Arguments]    ${index}
    Click    id=delete-record-${index}