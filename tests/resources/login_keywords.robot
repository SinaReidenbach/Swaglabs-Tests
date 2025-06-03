*** Settings ***
Library    SeleniumLibrary

*** Variables ***
${BROWSER}        firefox
${LOGIN_URL}      https://www.saucedemo.com/

*** Keywords ***
Open Browser To Login Page
    Open Browser    ${LOGIN_URL}    ${BROWSER}
    Maximize Browser Window

Input Valid Credentials
    [Arguments]    ${username}    ${password}
    Input Text    id=user-name    ${username}
    Input Text    id=password     ${password}

Click Login Button
    Click Button    id=login-button

Login With Valid Credentials
    [Arguments]    ${username}    ${password}
    Input Valid Credentials    ${username}    ${password}
    Click Login Button
