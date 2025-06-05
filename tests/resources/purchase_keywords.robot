*** Settings ***
Library     SeleniumLibrary


*** Keywords ***
Add First Item To Cart
    Click Button    xpath=//button[contains(@id,"add-to-cart")]

Go To Cart
    Click Element    id=shopping_cart_container
    Click Button    id=checkout
    Input Text    id=first-name    Max
    Input Text    id=last-name    Mustermann
    Input Text    id=postal-code    12345
    Click Button    id=continue

Checkout
    Click Button    id=finish
