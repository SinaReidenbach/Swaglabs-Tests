*** Settings ***
Documentation       Purchase Test

Resource            resources/keywords/purchase.robot
Resource            resources/keywords/authentication.robot
Resource            resources/data/login.resource
Resource            resources/keywords/errorhandling.robot

Suite Setup         Open Browser To Login Page
Suite Teardown      Close Browser


*** Test Cases ***
Test Purchase With All Users
    [Documentation]    Tests purchase per user and logs clear and original errors to the database if any occur.
    ...    user which cannot log in will except
    [Tags]    purchase

    FOR    ${user}    ${password}    IN    &{ACCOUNTS}
        Init EventLog Per User    ${user}
        TRY
            Login With Valid Credentials    ${user}    ${password}
        EXCEPT
            CONTINUE
        END

        TRY
            Run Error Check    Add Item And Go To Cart
            ${product_name}    ${price}=    Get Product Info
            Run Error Check    Checkout
            Run Error Check    Finish Purchase
            Set Purchase Entries    ${product_name}    ${price}
        EXCEPT    AS    ${error}
            Run Keyword And Ignore Error    Remove All Items From Cart    ${user}
            CONTINUE
        FINALLY
            Save Entries To Database
            Run Keyword And Ignore Error    Logout
        END
    END
