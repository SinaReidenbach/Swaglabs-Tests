*** Settings ***
Library     SeleniumLibrary
Resource    util_keywords.robot
Resource    auth_keywords.robot
Resource    db_keywords.robot


*** Keywords ***
Add Item And Go To Cart
    Wait Until Element Is Visible
    ...    xpath=//button[contains(@id,"add-to-cart")]
    ...    timeout=5s

    Click Button    xpath=//button[contains(@id,"add-to-cart")]

    Wait Until Element Is Visible
    ...    id=shopping_cart_container
    ...    timeout=5s

    Click Element    id=shopping_cart_container

Insert Personal Data
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
    [Documentation]    confirms the checkout button and Insert Personal Data

    Click Button    id=checkout

    Wait Until All Elements Visible
    ...    5
    ...    id=first-name
    ...    id=last-name
    ...    id=postal-code
    ...    id=continue

    Insert Personal Data

Finish And Save
    [Documentation]    Clicks the finish button, verifies successful checkout, and Save Purchase In Database.
    [Arguments]    ${user}    ${product_name}    ${price}

    Click Button    id=finish

    Page Should Contain Element    css=h2.complete-header

    Save Purchase In Database
    ...    ${user}
    ...    ${product_name}
    ...    ${price}
