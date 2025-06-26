*** Settings ***
Resource            resources/keywords/auth_keywords.robot
Resource            resources/keywords/errorhandling_keywords.robot
Resource            resources/keywords/util_keywords.robot

Suite Setup    Reset Global And Open Browser To Login Page

Suite Teardown      Close Browser

*** Test Cases ***
Test Login And Logout With All Users
    [Documentation]    Tests login per user and logs clear and original errors to the database if any occur.
    [Tags]    login   # robot:skip

    FOR    ${user}    ${password}    IN    &{ACCOUNTS}
        TRY
            Run Error Check    Input Login Data    ${user}    ${password}
            Run Error Check    Click Login Button
            Write To Global    4    PASS

        EXCEPT    AS    ${error}
            Write To Global    4    FAIL
            CONTINUE

        FINALLY
            Set Test Entries    ${TEST_NAME}    ${user}
            Save Entries To Database
            Run Keyword And Ignore Error    Logout
            Reset Global
        END
    END
