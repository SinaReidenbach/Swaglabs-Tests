*** Settings ***
Library     SeleniumLibrary
Library     OperatingSystem
Library     String
Library     Collections

Resource    ./db_keywords.robot

*** Variables ***
${BROWSER}      headlessfirefox
${LOGIN_URL}    https://www.saucedemo.com/


*** Keywords ***
Initialize Global Variables And Open Browser To Login Page
    Initialize Global Variables
    Open Browser To Login Page

Initialize Global Variables
    Set Suite Variable    @{global_entries}    ${None}    ${None}    ${None}    ${None}    ${None}    ${None}    ${None}


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
    RETURN    ${product_name}    ${price}

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

Remove All Items From Cart
    Click Element    class:shopping_cart_link
    ${remove_buttons}=    Get WebElements    xpath=//button[contains(text(), 'Remove')]
    FOR    ${btn}    IN    @{remove_buttons}
        Click Element    ${btn}
    END
