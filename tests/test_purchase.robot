*** Settings ***
Resource            resources/purchase_keywords.robot
Resource            resources/auth_keywords.robot
Resource            resources/login_data.robot
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
        Checkout
        Page Should Contain Element    css=h2.complete-header
        Logout
    END

Problem User Receives Error Message
    Open Browser To Login Page
    Input Valid Credentials    problem_user    secret_sauce
    Click Login Button
    Add First Item To Cart
    Go To Cart
    Page Should Contain    Last Name is required
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
