*** Settings ***
Variables       ../config/envDemo.yml
Resource        ../libBrowser/resource/keyword.resource


*** Test Cases ***
Test01 Test Text Box Menu With Open Browser
    Open Test Browser    ${urlDemo}
    Enter Menu Elements
    Select menu textbox
    Input fullname in menu textbox    TestLibBrowserV2
    Input Email in menu textbox    test@demo.com
    Input Current Address in menu text Box    currentAddress
    Input Permanent Address in menu text Box    test
    Select Submit
    Take Screenshot
    Sleep    5s

Test02 Test Text Box Menu With New Page
    New Test Page Browser    ${urlDemo}
    Enter Menu Elements
    Select menu textbox
    Input fullname in menu textbox    TestLibBrowser
    Input Email in menu textbox    test@demo.com
    Input Current Address in menu text Box    currentAddress
    Input Permanent Address in menu text Box    test
    Select Submit
    Take Screenshot

Test03 Test Buttons
    New Test Page Browser    ${urlDemo}
    Enter Menu Elements
    Select menu buttons
    Click With Options    ${doubleClilckButton}    clickCount=2
    ${text}    Get Text    ${doubleClilckMessage}
    Should Be Equal    ${text}    You have done a double click
    Take Screenshot
