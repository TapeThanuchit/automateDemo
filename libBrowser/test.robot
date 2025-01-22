*** Settings ***
Variables       ../config/envDemo.yml
Resource        ../libBrowser/resource/keyword.resource


*** Test Cases ***
Test01 Test Text Box Menu With Open Browser
    Open Test Browser    ${urlDemo}
    Enter Menu Elements
    Select menu textbox
    Input fullname in menu textbox    Test

Test02 Test Text Box Menu With New Page
    New Test Page Browser    ${urlDemo}
    Enter Menu Elements
    Select menu textbox
    Input fullname in menu textbox    TestLibBrowser
    Input Email in menu textbox    test@demo.com
