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
Initialize Global Entries And Open Browser To Login Page
    Initialize Global Entries

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

    Log To Console    \n Produktinfos ermitteln

    ${product_name}=
    ...    Get Text
    ...    css=.cart_item .inventory_item_name

    ${price_string}=
    ...    Get Text
    ...    css=.cart_item .inventory_item_price

    ${price}=
    ...    Evaluate
    ...    ${price_string}[1:]
    ...
    Log To Console    ermittelte Produktinfos: produkt_name: ${product_name} | price: ${price}

    ${entries}=    Collect Database Entries    ${None}    ${None}    ${product_name}    ${price}    ${None}    ${None}


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

Initialize Global Entries
    Log To Console    \n Entries wird initialisiert

    Set Suite Variable    @{entries}    ${None}    ${None}    ${None}    ${None}    ${None}    ${None}

Initialize Global Testcase
    Log To Console    \n Testcase wird initialisiert

    Set Suite Variable    ${testcase}    ${None}

Debugging
    [Arguments]    ${after_lines}    ${before_lines}    ${new_lines}
    Log To Console    \n\n\n********************************************************************

    Log To Console    ********************************************************************\n\n\n
