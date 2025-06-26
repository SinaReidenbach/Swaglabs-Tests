*** Settings ***
Resource            resources/keywords/errorhandling_keywords.robot
Resource            resources/keywords/auth_keywords.robot
Resource            resources/data/login_data.resource

Suite Setup         Open Browser To Login Page
Suite Teardown      Close Browser


*** Test Cases ***
Test Login And Logout With All Users
    [Documentation]    Tests login per user and logs clear and original errors to the database if any occur.
    [Tags]    login

    FOR    ${user}    ${password}    IN    &{ACCOUNTS}
        Init EventLog Per User    ${user}
        TRY
            Run Error Check    Input Login Data    ${user}    ${password}
            Run Error Check    Click Login Button
        EXCEPT    AS    ${error}
            CONTINUE
        FINALLY
            Save Entries To Database
            Run Keyword And Ignore Error    Logout
        END
    END
