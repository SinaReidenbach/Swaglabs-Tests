*** Settings ***
Resource            resources/keywords/auth_keywords.robot
Resource            resources/keywords/errorhandling_keywords.robot
Resource            resources/variables/variables.robot

Suite Setup    Initialize Original And Open Browser To Login Page

Suite Teardown      Close Browser

*** Test Cases ***
Test Login And Logout With All Users
    [Documentation]    Tests login per user and logs clear and original errors to the database if any occur.
#    [Tags]    robot:skip

    FOR    ${user}    ${password}    IN    &{ACCOUNTS}
        Log To Console    \n\n TEST: Login Test mit ${user}
        Log To Console    ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
        TRY
            Run Error Check    ${user}    Login With Valid Credentials    ${user}    ${password}
        EXCEPT    AS    ${error}
                Error Message Selenium   ${user}    ${error}
        END
        Run Keyword And Ignore Error    Logout
        Save Entries To Database
    END
