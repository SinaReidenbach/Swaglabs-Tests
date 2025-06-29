*** Settings ***
Documentation       Authentication Keywords

Library             SeleniumLibrary


*** Keywords ***
Input Login Data
    [Documentation]    Fill the Form with username and password
    [Arguments]    ${user}    ${password}

    Input Text
    ...    id=user-name
    ...    ${user}

    Input Text
    ...    id=password
    ...    ${password}

Click Login Button
    [Documentation]    Click Login-Button and proof if error visible -> Fail if error visible

    Click Button    id=login-button
    Sleep    1s

    ${menu_visible}=
    ...    Run Keyword And Return Status
    ...    Element Should Be Visible
    ...    id=react-burger-menu-btn

    ${error_visible}=
    ...    Run Keyword And Return Status
    ...    Element Should Be Visible
    ...    css=.error-message-container

    IF    ${error_visible}
        ${message}=
        ...    Get Text
        ...    css=.error-message-container
        Fail    ${message}
    ELSE IF    not ${menu_visible}
        Fail    Login fehlgeschlagen: Weder Menü noch Fehlermeldung sichtbar - unbekannter Zustand
    END

Login With Valid Credentials
    [Documentation]    Login with valid credentials from &{ACCOUNT}
    [Arguments]    ${user}    ${password}

    Input Login Data    ${user}    ${password}
    Click Login Button

Click Burger Menu
    [Documentation]    Sleep 0,5sec, wait for visibility of burger-menu and click it

    Sleep    0.5s
    Wait Until Element Is Visible
    ...    id=react-burger-menu-btn
    ...    timeout=5s
    Click Element    id=react-burger-menu-btn

Click Logout
    [Documentation]    Sleep 0,5sec, wait for visibility of logout in sidebar and click it
    Sleep    0.5s

    Wait Until Element Is Visible
    ...    id=logout_sidebar_link
    ...    timeout=5s
    Click Element    id=logout_sidebar_link

Logout
    [Documentation]    Call the keywords "Burger Menu" and "Click Logout"

    Click Burger Menu
    Click Logout
