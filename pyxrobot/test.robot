*** Settings ***
Library    mylib/MyLibrary.py

*** Test Cases ***
Greet User Test
    ${message}=    MyLibrary.Greet User    Alice
    Should Be Equal    ${message}    Hello, Alice! Welcome to Robot Framework.

Add Numbers Test
    ${sum}=    Add Two Numbers    5    7
    Should Be Equal As Integers    ${sum}    12

Check Even Number Test
    ${result}=    Is Even Number    4
    Should Be True    ${result}