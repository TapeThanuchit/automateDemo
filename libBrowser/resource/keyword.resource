*** Settings ***
Library     Browser
Library     String
Resource    variable.resource


*** Keywords ***
Open Test Browser
    [Arguments]    ${url}
    Open Browser    ${url}

New Test Page Browser
    [Arguments]    ${url}
    New Page    ${url}    wait_until=load

Enter Menu Elements
    Click    ${elementsCard}

Select menu textbox
    click    ${textBoxMenu}

Select menu buttons
    click    ${buttonsMenu}

Select menu Checkbox
    click    ${checkboxMenu}

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

Verify Click Buttons
    [Arguments]    ${expect}
    ${text}    Get Text    ${doubleClilckMessage}
    Should Be Equal    ${expect}    ${text}

Expand All Checkbox
    Click    ${expandButton}

Count Checkbox
    ${valueCheckbox}    Get Element Count    ${checkboxElements}
    RETURN    ${valueCheckbox}

Select all checkbox
    [Arguments]    ${checkboxCount}
    IF    ${checkboxCount} == 1
        Check Checkbox    xpath=(//span[@class="rct-checkbox"])[1]
    ELSE
        FOR    ${counter}    IN RANGE    1    ${checkboxCount}
            ${locator}    Set Variable    xpath=(//span[@class="rct-checkbox"])[${counter}]
            Scroll To Element    ${locator}
            Check Checkbox    ${locator}
        END
    END

Select specify checkbox
    [Arguments]    ${indexCheckbox}
    ${pass}    Run Keyword And Return Status    Should Contain    ${indexCheckbox}    ,
    IF    ${pass}
        ${choice}    Split String    ${indexCheckbox}    ,
    ELSE
        Check Checkbox    xpath=(//span[@class="rct-checkbox"])[1]
    END
