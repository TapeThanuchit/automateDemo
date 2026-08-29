*** Settings ***
Library    BuiltIn
#Suite Setup    Set Suite Variable    ${value}    100

*** Variables ***
${value}    0


*** Test Cases ***
Test01
    ${value}    Set Variable    5
    Log To Console    Test01: ${value}

Test02
    [Setup]    Set Test Variable    ${value}    10
    ${value}    Set Variable    ${value}    
    Log To Console    Test02: ${value}

Test03
    Log To Console    Test03: ${value}

Test04
    [Setup]    Set Test Variable    ${value}    150
    Log To Console    Test04-1: ${Value}
    Log To Console    Test04-2: ${VALUE}