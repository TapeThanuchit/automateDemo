*** Keywords ***
Select specify checkbox
    [Arguments]    ${checkBoxSelect}
    ${pass}    Run Keyword And Return Status    Should Contain    ${checkBoxSelect}    ,
    IF    ${pass}
        ${checkBoxData}    Split String    ${checkBoxSelect}    ,
        multiple select checkbox process    ${checkBoxData}
    ELSE
        ${index}    checkbox choose    ${checkBoxSelect}
        Check Checkbox    xpath=(//span[@class="rct-checkbox"])[${index}]
    END

multiple select checkbox process
    [Arguments]    ${checkBoxData}
    ${index}    Get Length    ${checkBoxData}
    FOR    ${i}    IN RANGE    0    ${index}
        ${index}    checkbox choose    ${checkBoxData}[${i}]
        Check Checkbox    xpath=(//span[@class="rct-checkbox"])[${index}]
    END

checkbox choose
    [Arguments]    ${checkBoxData}
    IF    "${checkBoxData}" == "Home"
        ${index}    Set Variable    1
    ELSE IF    "${checkBoxData}" == "Desktop"
        ${index}    Set Variable    2
    ELSE IF    "${checkBoxData}" == "Notes"
        ${index}    Set Variable    3
    ELSE IF    "${checkBoxData}" == "Commands"
        ${index}    Set Variable    4
    ELSE IF    "${checkBoxData}" == "Documents"
        ${index}    Set Variable    5
    ELSE IF    "${checkBoxData}" == "WorkSpace"
        ${index}    Set Variable    6
    ELSE IF    "${checkBoxData}" == "React"
        ${index}    Set Variable    7
    ELSE IF    "${checkBoxData}" == "Angular"
        ${index}    Set Variable    8
    ELSE IF    "${checkBoxData}" == "Veu"
        ${index}    Set Variable    9
    ELSE IF    "${checkBoxData}" == "Office"
        ${index}    Set Variable    10
    ELSE IF    "${checkBoxData}" == "Public"
        ${index}    Set Variable    11
    ELSE IF    "${checkBoxData}" == "Private"
        ${index}    Set Variable    12
    ELSE IF    "${checkBoxData}" == "Classified"
        ${index}    Set Variable    13
    ELSE IF    "${checkBoxData}" == "General"
        ${index}    Set Variable    14
    ELSE IF    "${checkBoxData}" == "Downloads"
        ${index}    Set Variable    15
    ELSE IF    "${checkBoxData}" == "Word File.doc"
        ${index}    Set Variable    16
    ELSE IF    "${checkBoxData}" == "Excel File.doc"
        ${index}    Set Variable    17
    ELSE
        Log    Checkbox Is not have Data
    END
    [Return]    ${index}