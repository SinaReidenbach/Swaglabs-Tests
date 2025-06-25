*** Settings ***
Resource            resources/keywords/purchase_keywords.robot
Resource            resources/keywords/util_keywords.robot
Resource            resources/keywords/errorhandling_keywords.robot
Resource            resources/variables/variables.robot

Suite Setup         Initialize Global Variables And Open Browser To Login Page
Suite Teardown      Close Browser

*** Test Cases ***
Test Purchase With All Users
    [Documentation]    Tests purchase per user and logs clear and original errors to the database if any occur.
    ...    user which cannot log in will except
#    [Tags]    robot:skip

    Initialize Global Variables
    ${testcase}    Set Variable    Test Purchase With All Users

    FOR    ${user}    ${password}    IN    &{ACCOUNTS}
        Log To Console    \n\n[ DEBUG ] Purchase Test mit ${user}\n\n
        TRY
            Login With Valid Credentials    ${user}
        EXCEPT
            CONTINUE
        END

        TRY
            Run Error Check    Add Item And Go To Cart
            ${product_name}    ${price}=    Get Product Info
            Run Error Check    Checkout
            Run Error Check    Finish Purchase
            Set Purchase Entries    ${product_name}    ${price}
            Write To Global    4    PASS
        EXCEPT    AS    ${error}
            Write To Global    4    FAIL
            CONTINUE
        FINALLY
            Set Test Entries    ${testcase}    ${user}
            Save Entries To Database    @{global_entries}
            Log To Console    FINALLY: global_entries: @{global_entries}
            Run Keyword And Ignore Error    Logout
            Initialize Global Variables
        END
    END
