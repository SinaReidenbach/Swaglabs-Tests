*** Settings ***
Library     SeleniumLibrary
Library     OperatingSystem
Library     String
Library     Collections
Resource    ../tests/resources/keywords/purchase_keywords.robot
Resource    ../tests/resources/keywords/errorhandling_keywords.robot
Resource    ../tests/resources/keywords/util_keywords.robot


*** Test Cases ***
Provoziere JS-Fehler
    Open Browser To Login Page
    TRY
        Login With Valid Credentials
        ...    error_user
        ...    secret_sauce

        Add Item And Go To Cart

        Checkout

        ${geckofile}=    Get Most Recent Geckodriver Log
        ${before}=    Get File    ${geckofile}

        Finish
    EXCEPT
        Sleep    1s
        ${after}=    Get File    ${geckofile}
        ${log}=    Replace String    ${after}    ${before}    ${EMPTY}
        Should Contain    ${log}    cesetRart
        ${parts}=   Split String    ${log}    TypeError:
        ${error}=   Get From List   ${parts}    1
        ${error}=    Strip String     ${error}
        Log    ${error}
        Log To Console    \n${error}
    END
    Sleep    2s
    [Teardown]    Close Browser
