*** Settings ***
Library     SeleniumLibrary
Library     OperatingSystem
Library     String
Library     Collections

Resource    ./db_keywords.robot
Resource    ./purchase_keywords.robot

*** Variables ***
${BROWSER}      headlessfirefox
${LOGIN_URL}    https://www.saucedemo.com/


*** Keywords ***
Screenshot
    [Arguments]    ${screen_name}
    Capture Page Screenshot    ${screen_name}.png

Reset Global And Open Browser To Login Page
    [Documentation]    reset global, open browser, maximize the window and wait for it to contain the element "user-name"
    Reset Global
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
    [Arguments]    ${user}
    Go To Cart

    ${remove_buttons}=    Get WebElements    xpath=//button[contains(text(), 'Remove')]
    FOR    ${btn}    IN    @{remove_buttons}
        Click Element    ${btn}
    END

    Screenshot    screenshot_after_remove_${user}
