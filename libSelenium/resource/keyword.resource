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
    Wait Until Page Contains Element    ${page}

Open Test Browser
    [Arguments]    ${url}
    Open Browser    ${url}    browser=chrome
    Wait Until Page Contains Element    ${page}

Enter Menu Elements
    Element Should Be Visible    ${elementsCard}
    Scroll Element Into View    ${elementsCardText}
    Click Element    ${elementsCard}

Select menu textbox
    Wait Until Page Contains Element    ${page}
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
