*** Settings ***
Resource            resources/keywords/auth_keywords.robot
Resource            resources/keywords/errorhandling_keywords.robot

Suite Setup         Open Browser To Login Page
Suite Teardown      Close Browser


*** Test Cases ***
Test Login And Logout With All Users
    [Documentation]    Tests login per user and logs clear and original errors to the database if any occur.
#    [Tags]    robot:skip
    FOR    ${user}    ${password}    IN    &{ACCOUNTS}
        TRY
            ${geckopath}=    Get latest Geckodriver Log
            ${before}=    Read latest Geckodriver Log    ${geckopath}

            Login With Valid Credentials
            ...    ${user}
            ...    ${password}

            Error Message JavaScript    ${user}    ${before}
        EXCEPT    AS    ${error}
                Error Message    ${user}    ${error}
                Error Message JavaScript    ${user}    ${before}
        END
        TRY
            ${geckopath}=    Get latest Geckodriver Log
            ${before}=    Read latest Geckodriver Log    ${geckopath}

            Logout

            Error Message JavaScript    ${user}    ${before}
        EXCEPT    AS    ${error}
                Error Message JavaScript    ${user}    ${before}
                Run Keyword And Ignore Error    Logout
        END
    END
