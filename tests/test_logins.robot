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
            Run Error Check    Login With Valid Credentials    ${user}    ${password}
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
