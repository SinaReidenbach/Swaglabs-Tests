*** Settings ***
Resource            resources/keywords/auth_keywords.robot
Resource            resources/keywords/errorhandling_keywords.robot
Resource            resources/variables/variables.robot
Resource            resources/keywords/util_keywords.robot

Suite Setup    Initialize Global Variables And Open Browser To Login Page

Suite Teardown      Close Browser

*** Test Cases ***
Test Login And Logout With All Users
    [Documentation]    Tests login per user and logs clear and original errors to the database if any occur.
#    [Tags]    robot:skip

    ${testcase}=    Set Variable    "Test Login And Logout With All Users"

    FOR    ${user}    ${password}    IN    &{ACCOUNTS}
        Log To Console    \n\n TEST: Login Test mit ${user}\n\n
        TRY
            Run Error Check    Input Login Data    ${user}    ${password}
            Run Error Check    Click Login Button
            ${result}=    Write To Global    4    PASS
            Log To Console    TRY: global_entries: @{global_entries}

        EXCEPT    AS    ${error}
            Write To Global    4    FAIL
            Log To Console    EXCEPT: global_entries: @{global_entries}
            CONTINUE

        FINALLY
            Set Test Entries    ${testcase}    ${user}   # ${result}
            Log To Console    FINALLY: global_entries: @{global_entries}
            Save Entries To Database    @{global_entries}
            Run Keyword And Ignore Error    Logout
            Initialize Global Variables
        END
    END
