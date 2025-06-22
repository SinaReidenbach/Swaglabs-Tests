*** Settings ***
Resource            resources/keywords/purchase_keywords.robot
Resource            resources/keywords/errorhandling_keywords.robot

Suite Setup         Open Browser To Login Page
Suite Teardown      Close Browser


*** Test Cases ***
Purchase With All Users   # robocop: off=too-long-test-case,too-many-calls-in-test-case
    [Documentation]    Tests purchase per user and logs clear and original errors to the database if any occur.
    ...    user which cannot log in will except
#    [Tags]    robot:skip
    FOR    ${user}    ${password}    IN    &{ACCOUNTS}
        TRY
            Login With Valid Credentials
            ...    ${user}
            ...    ${password}
        EXCEPT
            CONTINUE
        END

        TRY
            TRY
                ${geckopath}=    Get latest Geckodriver Log
                ${before}=    Read latest Geckodriver Log    ${geckopath}
                Add Item And Go To Cart
                Error Message JavaScript    ${user}    ${before}
            EXCEPT    AS    ${error}
                Error Message    ${user}    ${error}
                Error Message JavaScript    ${user}    ${before}
            END

            ${product_name}    ${price}=
            ...    Get Product Info
            TRY
                ${geckopath}=    Get latest Geckodriver Log
                ${before}=    Read latest Geckodriver Log    ${geckopath}
                Checkout
                Error Message JavaScript    ${user}    ${before}
            EXCEPT    AS    ${error}
                Error Message    ${user}    ${error}
                Error Message JavaScript    ${user}    ${before}
            END
            TRY
                ${geckopath}=    Get latest Geckodriver Log
                ${before}=    Read latest Geckodriver Log    ${geckopath}

                Finish And Save
                ...    ${user}
                ...    ${product_name}
                ...    ${price}

                Error Message JavaScript    ${user}    ${before}
            EXCEPT    AS    ${error}
                Error Message    ${user}    ${error}
                Error Message JavaScript    ${user}    ${before}
            END
        EXCEPT    AS    ${error}
            Error Message
            ...    ${user}
            ...    ${error}

            CONTINUE
        FINALLY
            Run Keyword And Ignore Error    Logout
        END
    END
