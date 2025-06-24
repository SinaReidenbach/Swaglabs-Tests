*** Settings ***
Resource            resources/keywords/purchase_keywords.robot
Resource            resources/keywords/util_keywords.robot
Resource            resources/keywords/errorhandling_keywords.robot
Resource            resources/variables/variables.robot

Suite Setup         Initialize Global Entries And Open Browser To Login Page
Suite Teardown      Close Browser
Library    ../.venv/Lib/site-packages/robot/libraries/Easter.py

*** Test Cases ***
Test Purchase With All Users   # robocop: off=too-long-test-case,too-many-calls-in-test-case
    [Documentation]    Tests purchase per user and logs clear and original errors to the database if any occur.
    ...    user which cannot log in will except
#    [Tags]    robot:skip

    Initialize Global Testcase
    ${testcase}=    Set Variable    "Test Purchase With All Users"

    FOR    ${user}    ${password}    IN    &{ACCOUNTS}
        Log To Console    \n\n TEST: Purchase Test mit ${user}
        Log To Console    ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
        TRY
            Login With Valid Credentials
            ...    ${user}
            ...    ${password}
        EXCEPT
            CONTINUE
        END
        TRY
            Run Error Check    ${user}    Add Item And Go To Cart
            ${product_name}    ${price}=    Get Product Info
            Run Error Check    ${user}    Checkout
            Run Error Check    ${user}    Finish Purchase    ${testcase}    ${user}    ${product_name}    ${price}
        EXCEPT    AS    ${error}
            Error Message Selenium    ${user}    ${error}
            CONTINUE
        FINALLY
            Run Keyword And Ignore Error    Logout
            Set Entry If Needed    ${entries}    0    ${testcase}
            Save Entries To Database    ${entries}
        END
        Initialize Global Entries
    END
