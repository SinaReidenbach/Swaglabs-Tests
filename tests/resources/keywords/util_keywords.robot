*** Settings ***
Library     SeleniumLibrary
Library     OperatingSystem
Library     String
Library     Collections

Resource    db_keywords.robot

*** Variables ***
${BROWSER}      headlessfirefox
${LOGIN_URL}    https://www.saucedemo.com/


*** Keywords ***
Initialize Original And Open Browser To Login Page
    Initialize Original
    Open Browser To Login Page

Open Browser To Login Page
    [Documentation]    open browser, maximize the window and wait for contain of element "user-name"

    Open Browser
    ...    ${LOGIN_URL}
    ...    ${BROWSER}

    Maximize Browser Window

    Wait Until Page Contains Element
    ...    id=user-name
    ...    timeout=5s

Wait Until All Elements Visible
    [Arguments]    ${timeout}=10s    @{ids}

    FOR    ${id}    IN    @{ids}
        Wait Until Element Is Visible
        ...    ${id}
        ...    ${timeout}
    END

Get Product Info
    [Documentation]    getting actual produkt infos and remove "$"

    ${product_name}=
    ...    Get Text
    ...    css=.cart_item .inventory_item_name

    ${price_string}=
    ...    Get Text
    ...    css=.cart_item .inventory_item_price

    ${price}=
    ...    Evaluate
    ...    ${price_string}[1:]

    ${entries}=    Collect Database Entries    ${EMPTY}    ${NONE}    ${product_name}    ${price}    ${NONE}    ${NONE}


Get latest Geckodriver Log
    ${path}=   Join Path    ${OUTPUT DIR}    geckodriver-*.log
    ${cmd}=    Catenate    dir /b /od    "${path}"
    ${files}=  Run    ${cmd}

    ${list}=    Split String    ${files}    \n
    ${last}=    Get From List    ${list}    -1

    ${path}=   Join Path    ${OUTPUT DIR}    ${last}

    RETURN    ${path}

Read Latest Geckodriver Log
    [Arguments]    ${geckopath}
    ${geckofile}=    Get File    ${geckopath}
    RETURN    ${geckofile}

Initialize Original
    Set Suite Variable    @{ORIGINAL}    ${None}    ${None}    ${None}    ${None}    ${None}

Debugging
    [Arguments]    ${after_lines}    ${before_lines}    ${new_lines}
    Log To Console    \n\n\n********************************************************************

    Log To Console    ********************************************************************\n\n\n
