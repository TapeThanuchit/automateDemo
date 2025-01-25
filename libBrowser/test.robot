*** Settings ***
Variables       ../config/envDemo.yml
Resource        ../libBrowser/resource/keyword.resource
Resource        ../libBrowser/resource/checkboxCondition.resource
Test Setup      New Test Page Browser    ${urlDemo}


*** Test Cases ***
DEMOTB01
    [Documentation]    Verify_TextBox_Can input text all field_Success
    [Tags]    textbox
    Enter Menu Elements
    Select menu textbox
    Input fullname in menu textbox    TestLibBrowserV2
    Input Email in menu textbox    test@demo.com
    Input Current Address in menu text Box    currentAddress
    Input Permanent Address in menu text Box    test

DEMOTB02
    [Documentation]    Verify_TextBox_Can input text and submit_Success
    [Tags]    textbox
    Enter Menu Elements
    Select menu textbox
    Input fullname in menu textbox    TestLibBrowser
    Input Email in menu textbox    test@demo.com
    Input Current Address in menu text Box    currentAddress
    Input Permanent Address in menu text Box    test
    Select Submit

DEMOTB03
    [Documentation]    Verify_TextBox_Field email incase input data is not email type_fail
    [Tags]    textbox
    Enter Menu Elements
    Select menu textbox
    Input fullname in menu textbox    TestLibBrowser
    Input Email in menu textbox    test
    Input Current Address in menu text Box    currentAddress
    Input Permanent Address in menu text Box    test
    Select Submit

DEMOTB04
    [Documentation]    Verify_TextBox_Incase select submit check output and compare equally data_Success 
    [Tags]    textbox
    Enter Menu Elements
    Select menu textbox
    Input fullname in menu textbox    TestLibBrowser
    Input Email in menu textbox    test
    Input Current Address in menu text Box    currentAddress
    Input Permanent Address in menu text Box    test
    Select Submit


DEMOCB01
    [Documentation]    Verify_Check Box_in case select checkbox Home_Success
    [Tags]    checkbox
    Enter Menu Elements
    Select menu Checkbox
    Check Checkbox    ${homeBox}
    Take Screenshot

DEMOCB02
    [Documentation]    Verify_Check Box_in case select expand and select all and collapse_Success
    [Tags]    checkbox
    Enter Menu Elements
    Select menu Checkbox
    Verify CheckBox Before Expand or After collapse    1
    Expand All Checkbox
    Verify CheckBox After Expand    1
    Select all checkbox
    Collapse All Checkbox
    Verify CheckBox Before Expand or After collapse    1
    Take Screenshot

DEMOCB03
    [Documentation]    Verify_Check Box_Incase spectify checkbox Choice And multiple Select_Success 
    [Tags]    checkbox
    Enter Menu Elements
    Select menu Checkbox
    Expand All Checkbox
    Select specify checkbox    Notes,Commands    #if multiple select check use , to seperate data #example Notes,Commands
    Take Screenshot

DEMORB01
    [Documentation]    Verify_RadioButtons_Select RadioButton and expect message_Success
    [Tags]    RadioButtons
    # [Setup]    Open Test Browser    ${urlDemo}
    Enter Menu Elements
    Select menu Radio Button
    ${radioChooseSelect}    Select Radio Buttons    Yes
    Expect Message after Select Radio Buttons    ${radioChooseSelect}    You have selected ${radioChooseSelect}
    Take Screenshot

DEMORB02
    [Documentation]    Verify_RadioButtons_Check Disable Radio Buttons_Success
    [Tags]    RadioButtons
    Enter Menu Elements
    Select menu Radio Button
    Get Element States    ${noRadioButton}    *assertion_expected=disabled

DEMOBT01
    [Documentation]    Verify_Button_Check click in condition And Expect Message_Success
    [Tags]    Botton
    Enter Menu Elements
    Select menu buttons
    Double Click Buttons
    Verify Double Click Buttons    You have done a double click
    Right Click Buttons
    Verify Right Click Butons    You have done a right click
    Click    ${defaultClickButton}
    Verify Default Click Butons    You have done a dynamic click
    Take Screenshot

DEMOWT01
    [Documentation]    Verify_WebTables_Add Data in Table_Success
    [Tags]    WebTables
    Enter Menu Elements
    Select menu WebTables
    Select Add Data in WebTables