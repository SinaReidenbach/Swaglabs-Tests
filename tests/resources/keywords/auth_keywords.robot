*** Settings ***
Library     SeleniumLibrary


*** Variables ***
${BROWSER}      firefox
${LOGIN_URL}    https://www.saucedemo.com/


*** Keywords ***
Open Browser To Login Page
    Open Browser    ${LOGIN_URL}    ${BROWSER}    options=add_argument("--headless")
    Maximize Browser Window

Input Valid Credentials
    [Arguments]    ${user}    ${password}
    Input Text    id=user-name    ${user}
    Input Text    id=password    ${password}

Click Login Button
    Click Button    id=login-button

Login With Valid Credentials
    [Arguments]    ${user}    ${password}
    Input Valid Credentials    ${user}    ${password}
    Click Login Button

Logout
    Wait Until Element Is Visible    id=react-burger-menu-btn    timeout=20s
    Click Element    id=react-burger-menu-btn
    Wait Until Element Is Visible    id=logout_sidebar_link    timeout=20s
    Click Element    id=logout_sidebar_link
    Log    Logout abgeschlossen
