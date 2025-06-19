*** Settings ***
Library     SeleniumLibrary

*** Variables ***
${BROWSER}      headlessfirefox
${LOGIN_URL}    https://www.saucedemo.com/


*** Keywords ***
Open Browser To Login Page
    Open Browser    ${LOGIN_URL}    ${BROWSER}
    Maximize Browser Window
    Wait Until Page Contains Element    id=user-name    timeout=5s

Wait Until All Elements Visible
    [Arguments]    ${timeout}=10s    @{ids}
    FOR    ${id}    IN    @{ids}
        Wait Until Element Is Visible    ${id}    ${timeout}
    END

Get Product Info
    [Arguments]    ${user}
    ${product_name}=    Get Text    css=.cart_item .inventory_item_name
    ${price_string}=    Get Text    css=.cart_item .inventory_item_price
    ${price}=    Evaluate    ${price_string}[1:]
    RETURN    ${product_name}    ${price}
