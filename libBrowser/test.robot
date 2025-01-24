*** Settings ***
Variables       ../config/envDemo.yml
Resource        ../libBrowser/resource/keyword.resource

Test Setup      New Test Page Browser    ${urlDemo}


*** Test Cases ***
Test01 Test Text Box Menu With Open Browser
    [Tags]    textbox
    [Setup]    Open Test Browser    ${urlDemo}
    Enter Menu Elements
    Select menu textbox
    Input fullname in menu textbox    TestLibBrowserV2
    Input Email in menu textbox    test@demo.com
    Input Current Address in menu text Box    currentAddress
    Input Permanent Address in menu text Box    test
    Select Submit
    Go Back
    Sleep    5s

Test02 Test Text Box Menu With New Page
    [Documentation]    Test Menu Text Box
    [Tags]    textbox
    Enter Menu Elements
    Select menu textbox
    Input fullname in menu textbox    TestLibBrowser
    Input Email in menu textbox    test@demo.com
    Input Current Address in menu text Box    currentAddress
    Input Permanent Address in menu text Box    test
    Select Submit

Test03 Test Buttons
    [Documentation]    Test Menu Buttons
    [Tags]    textbox
    Enter Menu Elements
    Select menu buttons
    Double Click Buttons
    Scroll To Element    ${doubleClilckMessage}
    Verify Click Buttons    You have done a double click
    Take Screenshot

Test04 Text Checkbox
    [Tags]    checkbox
    Enter Menu Elements
    Select menu Checkbox
    Check Checkbox    ${homeBox}
    Take Screenshot

Test05 Check All Checkbox
    [Tags]    checkbox
    Enter Menu Elements
    Select menu Checkbox
    Get Element Count    ${checkboxElements}    ==    1
    Expand All Checkbox
    Get Element Count    ${checkboxElements}    >    1
    ${checkboxCount}    Count Checkbox
    Select all checkbox    ${checkboxCount}
    Take Screenshot

Test06 Check Box specify menu
    [Tags]    checkbox
    Enter Menu Elements
    Select menu Checkbox
