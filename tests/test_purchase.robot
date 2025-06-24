*** Settings ***
Resource            resources/keywords/purchase_keywords.robot
Resource            resources/keywords/util_keywords.robot
Resource            resources/keywords/errorhandling_keywords.robot
Resource            resources/variables/variables.robot

Suite Setup         Initialize Global Entries And Open Browser To Login Page
Suite Teardown      Close Browser

*** Test Cases ***
Test Purchase With All Users   # robocop: off=too-long-test-case,too-many-calls-in-test-case
    [Documentation]    Tests purchase per user and logs clear and original errors to the database if any occur.
    ...    user which cannot log in will except
#    [Tags]    robot:skip

    Initialize Global Testcase And User
    ${global_testcase}=    Set Variable    "Test Purchase With All Users"

    FOR    ${user}    ${password}    IN    &{ACCOUNTS}
        Log To Console    \n\n TEST: Purchase Test mit ${user}
        Log To Console    ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
        TRY
            Login With Valid Credentials
            ...    ${user}
            ...    ${password}
        EXCEPT
            Log To Console    *FEHLER BEIM EINLOGGEN
            ${global_entries}=    Collect Database Entries    # @DWR: das war der erste Versuch den locked_out_user
            ...    ${global_testcase}                         # raus zu löschen, gerdade aufgefallen: wenn ich none
            ...    ${None}                                    # übergebe und ein wert drin ist, soll der ja normal
            ...    ${None}                                    # nicht überschrieben werden. das sollte der Grund sein,
            ...    ${None}                                    # warum es nicht läuft
            ...    ${None}
            ...    ${None}
            CONTINUE
        END
        TRY
            Log To Console    * ${user} Add Item And Go To Cart
            Run Error Check    Add Item And Go To Cart
            ${product_name}    ${price}=    Get Product Info
            Log To Console    * ${user} Checkout
            Run Error Check    Checkout
            Log To Console    * ${user} Finish Purchase
            Run Error Check    Finish Purchase

        EXCEPT    AS    ${error}
            Log To Console    * ${user} Error Message Selenium
            Error Message Selenium    ${error}
            Log To Console    * ${user} Collect Database Entries
            ${global_entries}=    Collect Database Entries
            ...    ${global_testcase}
            ...    ${user}
            ...    ${product_name}
            ...    ${price}
            ...    ${error}
            ...    ${None}=    Error Message Selenium    ${error}
            CONTINUE
        FINALLY
            Log To Console    * ${user} Logout
            Run Keyword And Ignore Error    Logout
            Log To Console    * ${user} Set Entries
            Set Entries    ${global_testcase}    ${user}    ${product_name}    ${price}
            Log To Console    * ${user} Save Entries To Database
            Save Entries To Database    ${global_entries}
        END
        Initialize Global Entries
    END
