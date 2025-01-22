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

Input fullname in menu textbox
    [Arguments]    ${fullnameData}
    Fill Text    ${textBox.fullnameInput}    ${fullnameData}

Input Email in menu textbox
    [Arguments]    ${emailData}
    Fill Text    ${textBox.fullnameInput}    ${emailData}
