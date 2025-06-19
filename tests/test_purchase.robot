*** Settings ***
Resource            resources/keywords/purchase_keywords.robot
Resource            resources/keywords/auth_keywords.robot
Resource            resources/keywords/db_keywords.robot
Resource            resources/data/login_data.robot
Library             Collections

Suite Setup         Open Browser To Login Page
Suite Teardown      Close Browser


*** Test Cases ***
Purchase With All Users
    FOR    ${user}    IN    @{VALID_USERS}
        IF    '${user}' == 'locked_out_user'    CONTINUE
        IF    '${user}' == 'problem_user'    CONTINUE
        IF    '${user}' == 'error_user'    CONTINUE
        IF    '${user}' == 'visual_user'    CONTINUE
        Log    Aktueller Testnutzer: ${user}
        ${password}=    Get From Dictionary    ${PASSWORDS}    ${user}

        Login With Valid Credentials    ${user}    ${password}
        Add First Item To Cart

        Go To Cart
        Wait Until Element Is Visible    css=.cart_item .inventory_item_name    timeout=10s
        ${product_name}=    Get Text    css=.cart_item .inventory_item_name
        ${price_string}=    Get Text    css=.cart_item .inventory_item_price
        ${price}=    Evaluate    ${price_string}[1:]
        Checkout
        Finish
        Page Should Contain Element    css=h2.complete-header
        Save Purchase In Database    ${user}    ${product_name}    ${price}
        Logout
    END

Problem User Receives Error Message
    Open Browser To Login Page
    Input Valid Credentials    problem_user    secret_sauce
    Click Login Button
    Add First Item To Cart
    Go To Cart
    Checkout
    Page Should Contain    Last Name is required
    Finish
    Logout

Error User Cannot Finish
    Open Browser To Login Page
    Input Valid Credentials    error_user    secret_sauce
    Click Login Button
    Add First Item To Cart
    Go To Cart
    Checkout
    Click Button    id=finish
    Page Should Not Contain Element    css=h2.complete-header
    Logout
