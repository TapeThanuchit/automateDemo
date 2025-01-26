*** Settings ***
Variables       ../config/envDemo.yml
Resource        ../libBrowser/resource/keyword.resource
Resource        ../libBrowser/resource/checkboxCondition.resource
Resource        ../libBrowser/resource/webTablesPage.resource
Suite Setup    New Browser    chromium
Test Setup      New Test Page Browser    ${urlDemo}
Test Teardown    Take Screenshot
Suite Teardown    Close Browser

*** Test Cases ***
DEMOTB01
    [Documentation]    Verify_TextBox_Can input text all field_Success
    [Tags]    textbox
    ${fullname}    Set Variable    TestLibBrowser
    ${email}    Set Variable    test@demo.com
    ${currentAddress}    Set Variable    Tape Company
    ${permanentAddress}    Set Variable    Bangkok
    Select menu textbox
    Input fullname in menu textbox    ${fullname}
    Input Email in menu textbox    ${email}
    Input Current Address in menu text Box    ${currentAddress}
    Input Permanent Address in menu text Box    ${permanentAddress}

DEMOTB02
    #Fail Case Debugging
    [Documentation]    Verify_TextBox_Can input text and submit_Success
    [Tags]    textbox
    ${fullname}    Set Variable    TestLibBrowser
    ${email}    Set Variable    test@demo.com
    ${currentAddress}    Set Variable    Tape Company
    ${permanentAddress}    Set Variable    Bangkok
    Select menu textbox
    Input fullname in menu textbox    ${fullname}
    Input Email in menu textbox    ${email}
    Input Current Address in menu text Box    ${currentAddress}
    Input Permanent Address in menu text Box    ${permanentAddress}
    Select Submit
    Get Element States    ${outputFrom}    contains    visible
    Scroll To Element    ${outputFrom}
    Get Text    ${outputName}    equal    Name:${fullname}
    Get Text    ${outputEmail}    equal    Email:${email}
    Get Text    ${outputCurrentAddress}    equal    Current Address :${currentAddress}
    Get Text    ${outputPermanentAddress}    equal   Permanent Address :${permanentAddress}

DEMOTB03
    [Documentation]    Verify_TextBox_Field email incase input data is not email type_fail
    [Tags]    textbox
   ${fullname}    Set Variable    TestLibBrowser
    ${email}    Set Variable    test
    ${currentAddress}    Set Variable    Tape Company
    ${permanentAddress}    Set Variable    Bangkok
    Select menu textbox
    Input fullname in menu textbox    ${fullname}
    Input Email in menu textbox    ${email}
    Input Current Address in menu text Box    ${currentAddress}
    Input Permanent Address in menu text Box    ${permanentAddress}
    Select Submit
    Get Element States    ${outputFrom}    contains    hidden

DEMOCB01
    [Documentation]    Verify_Check Box_in case select checkbox Home_Success
    [Tags]    checkbox
    Select menu Checkbox
    Check Checkbox    ${homeBox}

DEMOCB02
    [Documentation]    Verify_Check Box_in case select expand and select all and collapse_Success
    [Tags]    checkbox
    Select menu Checkbox
    Verify CheckBox Before Expand or After collapse    1
    Expand All Checkbox
    Verify CheckBox After Expand    1
    Select all checkbox
    Collapse All Checkbox

DEMOCB03
    [Documentation]    Verify_Check Box_Incase spectify checkbox Choice And multiple Select_Success 
    [Tags]    checkbox
    Select menu Checkbox
    Expand All Checkbox
    Select specify checkbox    Notes,Commands    #if multiple select check use , to seperate data #example Notes,Commands

DEMORB01
    [Documentation]    Verify_RadioButtons_Select RadioButton and expect message_Success
    [Tags]    RadioButtons
    # [Setup]    Open Test Browser    ${urlDemo}
    Select menu Radio Button
    ${radioChooseSelect}    Select Radio Buttons    Yes
    Expect Message after Select Radio Buttons    ${radioChooseSelect}    You have selected ${radioChooseSelect}

DEMORB02
    [Documentation]    Verify_RadioButtons_Check Disable Radio Buttons_Success
    [Tags]    RadioButtons
    Select menu Radio Button
    Get Element States    ${noRadioButton}    contains    disabled
    
DEMOBT01
    [Documentation]    Verify_Button_Check click in condition And Expect Message_Success
    [Tags]    Button
    Select menu buttons
    Double Click Buttons
    Verify Double Click Buttons    You have done a double click
    Right Click Buttons
    Verify Right Click Butons    You have done a right click
    Click    ${defaultClickButton}
    Verify Default Click Butons    You have done a dynamic click

DEMOWT01
    [Documentation]    Verify_WebTables_Add Data in Table_Success
    [Tags]    WebTables
    Select menu WebTables
    Select Add Data in WebTables
    Input first name in web Tables    Test
    Input Last name in web Tables    Demo
    Input Age in web Tables    32
    Input Email in web Tables    test@demo.com
    Input Salary in web Tables    20000
    Input Department in web tables    IT
    Select Submit
    
DEMOWT02
    [Documentation]    Verify_WebTables_Edit Data in Table with spectify row_Success
    [Tags]    WebTables
    ${rowData}    Set Variable    1
    Select menu WebTables
    Select Row Edit Data is    ${rowData}
    Input first name in web Tables    Test
    Input Last name in web Tables    Demo
    Input Age in web Tables    32
    Input Email in web Tables    test@demo.com
    Input Salary in web Tables    20000
    Input Department in web tables    IT
    Select Submit

DEMOWT03
    [Documentation]    Verify_WebTables_Delete Data in Table with spectify row_Success
    [Tags]    WebTables
    ${rowData}    Set Variable    1
    Select menu WebTables
    Select Row Delete Data is    ${rowData}

DEMOWT04
    [Documentation]    Verify_WebTables_Add Multiple Data with Excel_Success
    [Tags]    WebTables
    Select menu WebTables
    Add Data In Registration
    

