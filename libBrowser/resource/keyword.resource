*** Settings ***
Library     Browser
Resource    variable.resource


*** Keywords ***
Open Test Browser
    [Arguments]    ${url}
    Open Browser    ${url}

New Test Page Browser
    [Arguments]    ${url}
    New Page    ${url}

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
