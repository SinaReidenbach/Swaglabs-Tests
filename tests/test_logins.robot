*** Settings ***
Resource            resources/keywords/auth_keywords.robot
Resource            resources/keywords/errorhandling_keywords.robot
Resource            resources/variables/variables.robot
Resource            resources/keywords/util_keywords.robot

Suite Setup    Initialize Global Entries And Open Browser To Login Page

Suite Teardown      Close Browser

*** Test Cases ***
Test Login And Logout With All Users
    [Documentation]    Tests login per user and logs clear and original errors to the database if any occur.
#    [Tags]    robot:skip

    Initialize Global Testcase And User
    ${global_testcase}=    Set Variable    "Test Login And Logout With All Users"

    FOR    ${user}    ${password}    IN    &{ACCOUNTS}
        Log To Console    \n\n TEST: Login Test mit ${user}
        Log To Console    ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
        TRY
            Run Error Check    Login With Valid Credentials    ${user}    ${password}
        EXCEPT    AS    ${error}
                Error Message Selenium   ${error}
        END
        Run Keyword And Ignore Error    Logout
        Set Entry If Needed    ${global_entries}    0    ${global_testcase}
        Set Entry If Needed    ${global_entries}    1    ${user}
        Save Entries To Database    ${global_entries}

        Initialize Global Entries
    END
