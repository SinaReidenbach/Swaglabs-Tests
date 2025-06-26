*** Settings ***
Library     OperatingSystem
Library     String
Library     SeleniumLibrary
Resource    ./db_keywords.robot


*** Variables ***
${BROWSER}      headlessfirefox
${LOGIN_URL}    https://www.saucedemo.com/


*** Keywords ***
Screenshot
    [Arguments]    ${screen_name}
    Capture Page Screenshot    ${screen_name}.png

Open Browser To Login Page
    [Documentation]    Open browser and wait for it to contain the
    ...    element "user-name"

    Open Browser
    ...    ${LOGIN_URL}
    ...    ${BROWSER}
    Wait Until Page Contains Element
    ...    id=user-name
    ...    timeout=5s

Wait Until All Elements Visible
    [Documentation]    waiting for visibility of the given elements
    [Arguments]    ${timeout}=10s    @{ids}

    FOR    ${id}    IN    @{ids}
        Wait Until Element Is Visible
        ...    ${id}
        ...    ${timeout}
    END

Get Product Info
    [Documentation]    getting actual produkt infos and remove "$" from ${price}

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
    [Documentation]    Get the latest geckodriver-*.log and return the full path

    ${path}=    Join Path    ${OUTPUT DIR}    geckodriver-*.log
    ${cmd}=    Catenate    dir /b /od    "${path}"
    ${files}=    Run    ${cmd}

    ${list}=    Split String    ${files}    \n
    ${last}=    Get From List    ${list}    -1

    ${path}=    Join Path    ${OUTPUT DIR}    ${last}

    RETURN    ${path}

Read Latest Geckodriver Log
    [Arguments]    ${geckopath}

    ${geckofile}=    Get File    ${geckopath}

    RETURN    ${geckofile}
