*** Settings ***
Resource            resources/keywords/purchase_keywords.robot
Resource            resources/keywords/util_keywords.robot
Resource            resources/keywords/errorhandling_keywords.robot
Resource            resources/variables/variables.robot

Suite Setup         Reset Global And Open Browser To Login Page
Suite Teardown      Close Browser

*** Test Cases ***
Test Purchase With All Users
    [Documentation]    Tests purchase per user and logs clear and original errors to the database if any occur.
    ...    user which cannot log in will except
    [Tags]    purchase   # robot:skip

    FOR    ${user}    ${password}    IN    &{ACCOUNTS}
        TRY
            Login With Valid Credentials    ${user}
        EXCEPT
            CONTINUE
        END

        TRY
            Run Error Check    Add Item And Go To Cart
            ${product_name}    ${price}=    Get Product Info
            Run Error Check    Checkout
            Run Error Check    Finish Purchase
            Set Purchase Entries    ${product_name}    ${price}
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
