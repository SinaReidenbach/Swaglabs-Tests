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

        Log    Aktueller Testnutzer: ${user}
        TRY
            Add Item And Go To Cart

            ${product_name}    ${price}=
            ...    Get Product Info

            Checkout

            Finish And Save
            ...    ${user}
            ...    ${product_name}
            ...    ${price}
        EXCEPT    AS    ${error}
            Error Message
            ...    ${user}
            ...    ${error}

            CONTINUE
        FINALLY
            Run Keyword And Ignore Error    Logout
        END
    END
