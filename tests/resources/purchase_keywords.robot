*** Settings ***
Library    SeleniumLibrary

*** Keywords ***
Add First Item To Cart
    Click Button    xpath=//button[contains(@id,"add-to-cart")]

Go To Cart And Checkout
    Click Element   id=shopping_cart_container
    Click Button    id=checkout
    Input Text      id=first-name    Max
    Input Text      id=last-name     Mustermann
    Input Text      id=postal-code   12345
    Click Button    id=continue
    Click Button    id=finish
    Page Should Contain Element    css=h2.complete-header
