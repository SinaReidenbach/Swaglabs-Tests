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

    ${entries}=    Set Variable    @{ORIGINAL}
    ${user}=          Get From List    ${entries}    0
    Log To Console    save: user: ${user}
    ${product_name}=      Get From List    ${entries}    1
    Log To Console    save: product_name: ${product_name}
    ${price}=          Get From List    ${entries}    2
    Log To Console    save: price: ${price}
    ${error}=          Get From List    ${entries}    3
    Log To Console    save: error: ${error}
    ${error_describtion}=      Get From List    ${entries}    4
    Log To Console    save: error_describtion: ${error_describtion}

    Log To Console    💾 Datenbankeintrag: ${user} | ${product_name} | ${price} | ${error} | ${error_describtion}

    Save Purchase In Database    ${user}    ${product_name}    ${price}    ${error}    ${error_describtion}


Finish Purchase
    [Arguments]    ${user}    ${product_name}    ${price}
    Log To Console    \n\n Schritt Kauf abschliessen
    Click Button    id=finish

    Page Should Contain Element    css=h2.complete-header

    Log To Console      \n\n Schritt Übergabe der Produktinfos an Sammlung Entries
    ${entries}=    Collect Database Entries    ${EMPTY}    ${user}    ${product_name}    ${price}    ${NONE}    ${NONE}
