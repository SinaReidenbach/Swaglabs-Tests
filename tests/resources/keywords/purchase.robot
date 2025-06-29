*** Settings ***
Documentation       Purchase Keywords

Library             SeleniumLibrary
Resource            ./util.robot


*** Keywords ***
Add Item And Go To Cart
    [Documentation]    Wait for visibility of the add-to-cart button, click the button and call the
    ...    keyword "Go To Cart"

    Wait Until Element Is Visible
    ...    xpath=//button[contains(@id,"add-to-cart")]
    ...    timeout=5s
    Click Button    xpath=//button[contains(@id,"add-to-cart")]
    Go To Cart

Go To Cart
    [Documentation]    Wait for visibility of the shopping-cart-container element and click the element
    Wait Until Element Is Visible
    ...    id=shopping_cart_container
    ...    timeout=5s
    Click Element    id=shopping_cart_container

Insert Personal Data
    [Documentation]    Fill Text in the forms with first name, lastname und postcode. After this click
    ...    the continue button

    Input Text
    ...    id=first-name
    ...    Max
    Input Text
    ...    id=last-name
    ...    Mustermann
    Input Text
    ...    id=postal-code
    ...    12345
    Click Button    id=continue

Checkout
    [Documentation]    confirms the checkout button, wait for visibility of all text forms and call the
    ...    keyword Insert Personal Data

    Click Button    id=checkout
    Wait Until All Elements Visible
    ...    5
    ...    id=first-name
    ...    id=last-name
    ...    id=postal-code
    ...    id=continue
    Insert Personal Data

Finish Purchase
    [Documentation]    click the finish button and proof for contain css=h2.complete-header

    Click Button    id=finish
    Page Should Contain Element    css=h2.complete-header

Remove All Items From Cart
    [Documentation]    go to cart, click all remove buttons on site and take a screenshot named screenshot_after_remove_${user}.png
    [Arguments]    ${user}

    Go To Cart
    ${remove_buttons}=    Get WebElements    xpath=//button[contains(text(), 'Remove')]

    FOR    ${btn}    IN    @{remove_buttons}
        Click Element    ${btn}
    END

    Screenshot    screenshot_after_remove_${user}
