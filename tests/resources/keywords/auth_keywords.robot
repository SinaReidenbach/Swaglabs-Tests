*** Settings ***
Resource    ../init.robot


*** Keywords ***
Get Password
    [Arguments]    ${user}

    ${password}=
    ...    Get From Dictionary
    ...    ${ACCOUNTS}
    ...    ${user}

    RETURN    ${password}

Input Login Data
    [Arguments]    ${user}    ${password}

    Input Text
    ...    id=user-name
    ...    ${user}

    Input Text
    ...    id=password
    ...    ${password}

Click Login Button
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
        Fail    Login fehlgeschlagen: Weder Menü noch Fehlermeldung sichtbar – unbekannter Zustand
    END

Login With Valid Credentials
    [Arguments]    ${user}
    ${password}=    Get Password    ${user}
    Input Login Data    ${user}    ${password}
    Click Login Button

Click Burger Menu
    Sleep    0.5s

    Wait Until Element Is Visible
    ...    id=react-burger-menu-btn
    ...    timeout=5s

    Click Element    id=react-burger-menu-btn

Click Logout
    Sleep    0.5s

    Wait Until Element Is Visible
    ...    id=logout_sidebar_link
    ...    timeout=5s

    Click Element    id=logout_sidebar_link

Logout
    Click Burger Menu
    Click Logout
