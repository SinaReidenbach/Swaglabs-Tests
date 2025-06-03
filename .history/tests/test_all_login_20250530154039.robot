*** Settings ***
Resource    resources/login_keywords.robot
Resource    resources/login_data.robot
Library     SeleniumLibrary
Library     BuiltIn
Library     Collections


Suite Setup       Open Browser To Login Page
Suite Teardown    Close All Browsers

*** Test Cases ***
Test Login With All Users
    FOR    ${user}    IN    @{VALID_USERS}
        Run Keyword If    '${user}' == 'locked_out_user'    Continue For Loop
        Run Keyword If    '${user}' == 'visual_user'    Continue For Loop
        Log    Aktueller Testnutzer: ${user}
        ${password}=    Get From Dictionary    ${PASSWORDS}    ${user}
        Input Valid Credentials    ${user}    ${password}
        Click Login Button
        Wait Until Element Is Visible    id=react-burger-menu-btn    timeout=10s
        Click Element    id=react-burger-menu-btn
        Sleep    1s
        Wait Until Element Is Visible    id=logout_sidebar_link    timeout=10s
        Click Element    id=logout_sidebar_link
    END

    Locked Out User Cannot Login
    Open Browser To Login Page
    Input Valid Credentials    locked_out_user    secret_sauce
    Click Login Button
    Element Text Should Be    css=h3[data-test="error"]    Epic sadface: Sorry, this user has been locked out.


Valid User Can Logout
    Login With Valid Credentials    standard_user    secret_sauce
    Wait Until Element Is Visible    id=react-burger-menu-btn    timeout=5s
    Click Element    id=react-burger-menu-btn
    Wait Until Element Is Visible    id=logout_sidebar_link    timeout=5s
    Click Element    id=logout_sidebar_link
    Wait Until Element Is Visible    id=user-name    timeout=10s
    Page Should Contain Element      id=user-name
