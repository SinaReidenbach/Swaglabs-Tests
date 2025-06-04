*** Settings ***
Resource    resources/purchase_keywords.robot
Resource    resources/auth_keywords.robot
Resource    resources/login_data.robot

Suite Setup    Open Browser To Login Page
Suite Teardown    Close Browser

*** Test Cases ***
Purchase as Standard User
    Login With Valid Credentials    standard_user    secret_sauce
    Add First Item To Cart
    Go To Cart And Checkout
    [Teardown]    Logout
