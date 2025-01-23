*** Settings ***
Library         SeleniumLibrary
Resource        ../libSelenium/resource/keyword.resource
Variables       ../config/envDemo.yml

Test Setup      Open Test Browser    ${urlDemo}


*** Test Cases ***
Test01 Test Text Box Menu
    [Setup]    Open Test Browser with headless    ${urlDemo}
    Enter Menu Elements
    Select menu textbox
    Input fullname in menu textbox    TestLibBrowser
    Input Email in menu textbox    test@demo.com
    Input Current Address in menu text Box    currentAddress
    Input Permanent Address in menu text Box    test
    Select Submit
