*** Settings ***
Resource    resources/auth_keywords.robot
Resource    resources/login_data.robot

Suite Setup       Open Browser To Login Page
Suite Teardown    Close All Browsers

*** Test Cases ***
Locked Out User Cannot Login
    Open Browser To Login Page
    Input Valid Credentials    locked_out_user    secret_sauce
    Click Login Button
    Element Text Should Be    css=h3[data-test="error"]    Epic sadface: Sorry, this user has been locked out.
