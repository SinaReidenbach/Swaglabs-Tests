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
        Log To Console    \n\n TEST: Purchase Test mit ${user}\n\n
        TRY
            Login With Valid Credentials
            ...    ${user}
            ...    ${password}
        EXCEPT
            CONTINUE
        END

        TRY
            Run Error Check    Add Item And Go To Cart
            ${product_name}    ${price}=    Get Product Info
            Run Error Check    Checkout
            Run Error Check    Finish Purchase

        EXCEPT    AS    ${error}
#           ${result}    Set Variable    FAIL        -> ggf weitere Spalte result
            CONTINUE
        FINALLY
            Run Keyword And Ignore Error    Logout
            Set Test Entries    ${testcase}    ${user}
            Save Entries To Database    @{global_entries}
        END
#       ${result}    Set Variable    PASS        -> ggf weitere Spalte result
        Initialize Global Variables
    END
