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

        ${geckopath}=    Get latest Geckodriver Log
        ${before}=    Read latest Geckodriver Log    ${geckopath}

        Finish
    EXCEPT
        Sleep    1s
        ${after}=    Read latest Geckodriver Log    ${geckopath}
        ${error}=    Extract The Current JavaScript Error    ${after}    ${before}

        Log    ${error}
        Log To Console    \n${error}

        Error Message
            ...    error_user
            ...    ${error}
    END
    Sleep    2s
    [Teardown]    Close Browser
